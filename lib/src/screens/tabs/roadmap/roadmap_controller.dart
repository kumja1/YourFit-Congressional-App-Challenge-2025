// lib/src/screens/tabs/roadmap/roadmap_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/services/auth_service.dart';

import 'models/food_entry.dart';
import 'models/workout_type.dart';

class RoadmapController extends GetxController {
  final Rx<UserData?> currentUser = Get.find<AuthService>().currentUser;

  // --- Search ---
  final searchController = TextEditingController();
  bool loadingSearch = false;
  List<dynamic> searchResults = [];

  // --- Entries / totals / day state ---
  List<FoodEntry> entries = [];
  double totalCalories = 0;
  double totalProtein = 0;
  double totalCarbs = 0;
  double totalFat = 0;
  double totalFiber = 0;
  double totalSugar = 0;
  double totalSodium = 0;

  // --- Hydration ---
  int waterMl = 0; // per day

  // --- Targets (user-adjustable via dialog) ---
  int kcalTarget = 2600;
  int proteinTarget = 110; // g
  int carbsTarget = 330; // g
  int fatTarget = 80; // g
  int fiberTarget = 28; // g
  int waterTargetMl = 2500;

  // --- Plan / calendar ---
  bool generatingPlan = false;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  SharedPreferences? _prefs;

  Map<String, WorkoutType> workoutPlans = {};
  WorkoutType? get selectedWorkout => getWorkoutForDate(selectedDay);

  String get selectedDateName =>
      DateUtils.isSameDay(selectedDay, DateTime.now())
      ? "Today"
      : "${_monthName(selectedDay.month)} ${selectedDay.day}, ${selectedDay.year}";

  // --- Recents (quick add) ---
  // Stored as a list of per-100g nutrition objects
  List<FoodPer100> recentFoods = [];

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadDay(selectedDay);
    await _loadWorkoutPlans();
    _loadTargets();
    _loadRecents();
    if (workoutPlans.isEmpty) {
      await generateMonthlyPlan();
    } else {
      update();
    }
  }

  // ---------- Dates / keys ----------
  String _dateKey(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  void onDaySelected(DateTime sel, DateTime foc) {
    selectedDay = sel;
    focusedDay = foc;
    _loadDay(sel);
    update();
  }

  // ---------- Plans ----------
  WorkoutType? getWorkoutForDate(DateTime date) {
    final key = _dateKey(date);
    return workoutPlans[key];
  }

  Future<void> generateMonthlyPlan() async {
    generatingPlan = true;
    update();

    try {
      final user = currentUser.value;
      final age = user?.age ?? 25;
      final activity = user?.physicalActivity ?? UserPhysicalActivity.moderate;
      final plan = await _generateAIPlan(age, activity);
      await _savePlans(plan);
      workoutPlans = plan;
    } catch (e) {
      workoutPlans = _generateDefaultPlan();
    }

    generatingPlan = false;
    update();
  }

  Future<Map<String, WorkoutType>> _generateAIPlan(
    int age,
    UserPhysicalActivity activity,
  ) async {
    const apiKey = "AIzaSyCI-es8sI7XKwQwYiipkmLdlNH65MgExFo";
    const model = 'gemini-2.5-flash';

    final prompt =
        '''
Generate a 30-day workout plan.
User age: $age, activity: ${activity.name}.
Return JSON with date keys (YYYY-MM-DD) starting from today ${_dateKey(DateTime.now())}.
Allowed values: legDay, upperBody, cardio, core, fullBody, rest, yoga.
Keep variety and 1-2 rest days per week.
Example:
{"2025-01-01": "legDay", "2025-01-02": "cardio", ...}
''';

    try {
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
      );

      final response = await http
          .post(
            uri,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "contents": [
                {
                  "role": "user",
                  "parts": [
                    {"text": prompt},
                  ],
                },
              ],
              "generationConfig": {
                "temperature": 0.4,
                "responseMimeType": "application/json",
              },
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '{}';

        Map<String, dynamic> planJson;
        try {
          planJson = jsonDecode(text) as Map<String, dynamic>;
        } catch (_) {
          final start = text.indexOf('{');
          final end = text.lastIndexOf('}');
          if (start >= 0 && end > start) {
            planJson = jsonDecode(text.substring(start, end + 1));
          } else {
            planJson = {};
          }
        }

        final Map<String, WorkoutType> plan = {};
        planJson.forEach((key, value) {
          final type = _parseWorkoutType(value.toString());
          if (type != null) plan[key] = type;
        });

        if (plan.isEmpty) return _generateDefaultPlan();
        return plan;
      }
    } catch (_) {}

    return _generateDefaultPlan();
  }

  WorkoutType? _parseWorkoutType(String raw) {
    final s = raw.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
    if (s.contains('rest')) return WorkoutType.rest;
    if (s.contains('full')) return WorkoutType.fullBody;
    if (s.contains('upper') || s.contains('push') || s.contains('pull')) {
      return WorkoutType.upperBody;
    }
    if (s.contains('leg') || s.contains('lower')) return WorkoutType.legDay;
    if (s.contains('cardio') || s.contains('hiit') || s.contains('interval')) {
      return WorkoutType.cardio;
    }
    if (s.contains('core') || s.contains('abs')) return WorkoutType.core;
    if (s.contains('yoga') || s.contains('stretch') || s.contains('mobility')) {
      return WorkoutType.yoga;
    }
    return null;
  }

  Map<String, WorkoutType> _generateDefaultPlan() {
    final plan = <String, WorkoutType>{};
    final today = DateTime.now();

    final pattern = [
      WorkoutType.upperBody,
      WorkoutType.cardio,
      WorkoutType.legDay,
      WorkoutType.yoga,
      WorkoutType.core,
      WorkoutType.fullBody,
      WorkoutType.rest,
    ];

    for (int i = 0; i < 30; i++) {
      final date = today.add(Duration(days: i));
      plan[_dateKey(date)] = pattern[i % pattern.length];
    }

    return plan;
  }

  Future<void> _savePlans(Map<String, WorkoutType> plans) async {
    final Map<String, String> stringPlans = {};
    plans.forEach((key, value) => stringPlans[key] = value.name);
    await _prefs?.setString('workout_plans', jsonEncode(stringPlans));
  }

  Future<void> _loadWorkoutPlans() async {
    final saved = _prefs?.getString('workout_plans');
    if (saved != null) {
      final Map<String, dynamic> decoded = jsonDecode(saved);
      workoutPlans = {};
      decoded.forEach((key, value) {
        final type = _parseWorkoutType(value.toString());
        if (type != null) workoutPlans[key] = type;
      });
    }
    update();
  }

  // ---------- Load & persist day ----------
  void _loadDay(DateTime d) {
    // food entries
    final key = "food-${_dateKey(d)}";
    entries = [];
    final raw = _prefs?.getString(key);
    if (raw != null) {
      final list = (jsonDecode(raw) as List)
          .cast<Map>()
          .map((e) => FoodEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      entries = list;
    }

    // hydration
    waterMl = _prefs?.getInt("water-${_dateKey(d)}") ?? 0;

    // recompute totals
    _recomputeTotals();
  }

  void _persistDay() {
    final key = "food-${_dateKey(selectedDay)}";
    final list = entries.map((e) => e.toJson()).toList();
    _prefs?.setString(key, jsonEncode(list));
    _prefs?.setInt("water-${_dateKey(selectedDay)}", waterMl);
  }

  void _recomputeTotals() {
    totalCalories = 0;
    totalProtein = 0;
    totalCarbs = 0;
    totalFat = 0;
    totalFiber = 0;
    totalSugar = 0;
    totalSodium = 0;

    for (final e in entries) {
      totalCalories += e.kcal;
      totalProtein += e.proteinG;
      totalCarbs += e.carbsG;
      totalFat += e.fatG;
      totalFiber += e.fiberG;
      totalSugar += e.sugarG;
      totalSodium += e.sodiumMg;
    }
  }

  // ---------- Targets ----------
  void _loadTargets() {
    kcalTarget = _prefs?.getInt('target_kcal') ?? kcalTarget;
    proteinTarget = _prefs?.getInt('target_protein') ?? proteinTarget;
    carbsTarget = _prefs?.getInt('target_carbs') ?? carbsTarget;
    fatTarget = _prefs?.getInt('target_fat') ?? fatTarget;
    fiberTarget = _prefs?.getInt('target_fiber') ?? fiberTarget;
    waterTargetMl = _prefs?.getInt('target_water') ?? waterTargetMl;
  }

  Future<void> setTargets({
    required int kcal,
    required int protein,
    required int carbs,
    required int fat,
    required int fiber,
    required int waterMl,
  }) async {
    kcalTarget = kcal;
    proteinTarget = protein;
    carbsTarget = carbs;
    fatTarget = fat;
    fiberTarget = fiber;
    waterTargetMl = waterMl;

    await _prefs?.setInt('target_kcal', kcalTarget);
    await _prefs?.setInt('target_protein', proteinTarget);
    await _prefs?.setInt('target_carbs', carbsTarget);
    await _prefs?.setInt('target_fat', fatTarget);
    await _prefs?.setInt('target_fiber', fiberTarget);
    await _prefs?.setInt('target_water', waterTargetMl);
    update();
  }

  // ---------- Hydration ----------
  void addWater(int ml) {
    waterMl = (waterMl + ml).clamp(0, 20000);
    _persistDay();
    update();
  }

  void removeWater(int ml) {
    waterMl = (waterMl - ml).clamp(0, 20000);
    _persistDay();
    update();
  }

  // ---------- Food search ----------
  Future<void> searchFoods() async {
    final q = searchController.text.trim();
    if (q.isEmpty) return;
    loadingSearch = true;
    update();
    try {
      final uri = Uri.parse(
        "https://world.openfoodfacts.org/cgi/search.pl?search_terms=${Uri.encodeComponent(q)}&search_simple=1&action=process&json=1&page_size=25",
      );
      final res = await http.get(uri, headers: {"Accept": "application/json"});
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final products = (data["products"] as List?) ?? [];
        searchResults = products
            .where((p) {
              final n = p["product_name"] ?? p["generic_name_en"];
              final kcal =
                  p["nutriments"]?["energy-kcal_100g"] ??
                  p["nutriments"]?["energy-kcal_serving"];
              return n != null && kcal != null;
            })
            .take(25)
            .toList();
      } else {
        searchResults = [];
      }
    } catch (_) {
      searchResults = [];
    }
    loadingSearch = false;
    update();
  }

  // Convert OFF product -> FoodPer100
  FoodPer100 mapProductToPer100(dynamic p) {
    final nutr = (p["nutriments"] ?? {}) as Map;
    double _d(dynamic v) =>
        (v is num) ? v.toDouble() : double.tryParse("$v") ?? 0.0;

    return FoodPer100(
      name: (p["product_name"] ?? p["generic_name_en"] ?? "Unknown").toString(),
      brand: (p["brands"] ?? "").toString(),
      kcal100: _d(nutr["energy-kcal_100g"]),
      protein100: _d(nutr["proteins_100g"]),
      carbs100: _d(nutr["carbohydrates_100g"]),
      fat100: _d(nutr["fat_100g"]),
      fiber100: _d(nutr["fiber_100g"]),
      sugar100: _d(nutr["sugars_100g"]),
      sodium100: _d(nutr["sodium_100g"]) * 1000, // sometimes in g; ensure mg
    );
  }

  // ---------- Add / edit / remove ----------
  void addFoodFromPer100({
    required FoodPer100 per100,
    required double grams,
    required MealType meal,
  }) {
    final factor = grams / 100.0;
    final e = FoodEntry(
      name: per100.name,
      brand: per100.brand,
      grams: grams,
      meal: meal,
      kcal: per100.kcal100 * factor,
      proteinG: per100.protein100 * factor,
      carbsG: per100.carbs100 * factor,
      fatG: per100.fat100 * factor,
      fiberG: per100.fiber100 * factor,
      sugarG: per100.sugar100 * factor,
      sodiumMg: per100.sodium100 * factor,
      time: DateTime.now(),
    );

    entries.add(e);
    _recomputeTotals();
    _persistDay();
    _addRecent(per100);
    update();
  }

  void editEntry(int index, {double? grams, MealType? meal}) {
    if (index < 0 || index >= entries.length) return;
    final old = entries[index];

    var updated = old;
    if (grams != null && grams > 0) {
      final per100 = FoodPer100(
        name: old.name,
        brand: old.brand,
        kcal100: old.kcal * 100 / old.grams,
        protein100: old.proteinG * 100 / old.grams,
        carbs100: old.carbsG * 100 / old.grams,
        fat100: old.fatG * 100 / old.grams,
        fiber100: old.fiberG * 100 / old.grams,
        sugar100: old.sugarG * 100 / old.grams,
        sodium100: old.sodiumMg * 100 / old.grams,
      );
      final factor = grams / 100.0;
      updated = old.copyWith(
        grams: grams,
        kcal: per100.kcal100 * factor,
        proteinG: per100.protein100 * factor,
        carbsG: per100.carbs100 * factor,
        fatG: per100.fat100 * factor,
        fiberG: per100.fiber100 * factor,
        sugarG: per100.sugar100 * factor,
        sodiumMg: per100.sodium100 * factor,
      );
    }
    if (meal != null) {
      updated = updated.copyWith(meal: meal);
    }

    entries[index] = updated;
    _recomputeTotals();
    _persistDay();
    update();
  }

  void removeEntry(int index) {
    if (index < 0 || index >= entries.length) return;
    entries.removeAt(index);
    _recomputeTotals();
    _persistDay();
    update();
  }

  // ---------- Recents ----------
  void _loadRecents() {
    final raw = _prefs?.getString('recent_foods');
    recentFoods = [];
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = (jsonDecode(raw) as List)
            .map((e) => FoodPer100.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        recentFoods = list.take(12).toList();
      } catch (_) {}
    }
  }

  void _saveRecents() {
    final list = recentFoods.map((e) => e.toJson()).toList();
    _prefs?.setString('recent_foods', jsonEncode(list));
  }

  void _addRecent(FoodPer100 food) {
    // de-dup by name+brand
    recentFoods.removeWhere(
      (f) =>
          f.name.toLowerCase() == food.name.toLowerCase() &&
          f.brand.toLowerCase() == food.brand.toLowerCase(),
    );
    recentFoods.insert(0, food);
    if (recentFoods.length > 20) {
      recentFoods.removeRange(20, recentFoods.length);
    }
    _saveRecents();
  }

  // ---------- Share ----------
  void shareDay() {
    final lines = <String>[];
    lines.add("Day • $selectedDateName");
    if (selectedWorkout != null) {
      lines.add("Workout: ${selectedWorkout!.label}");
    }
    lines.add(
      "Calories: ${totalCalories.toStringAsFixed(0)}/${kcalTarget} • Protein: ${totalProtein.toStringAsFixed(0)}g",
    );
    lines.add("Meals:");
    for (final m in MealType.values) {
      final mealEntries = entries
          .where((e) => e.meal == m)
          .toList(growable: false);
      if (mealEntries.isEmpty) continue;
      lines.add("• ${m.label}");
      for (final e in mealEntries) {
        lines.add(
          "  - ${e.name} ${e.grams.toStringAsFixed(0)}g • ${e.kcal.toStringAsFixed(0)} kcal",
        );
      }
    }
    lines.add("Water: ${waterMl} ml");
    Share.share(lines.join("\n"));
  }

  // ---------- Date picker ----------
  Future<void> selectDate(BuildContext ctx) async {
    final pick = await showDatePickerDialog(
      context: ctx,
      minDate: currentUser.value?.createdAt ?? const ConstDateTime(1970),
      maxDate: const ConstDateTime(2050),
      initialDate: selectedDay,
      centerLeadingDate: true,
      daysOfTheWeekTextStyle: const TextStyle(
        color: Colors.black26,
        fontSize: 14,
      ),
      enabledCellsTextStyle: const TextStyle(
        color: Colors.black26,
        fontSize: 14,
      ),
      currentDateTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      currentDateDecoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      selectedCellDecoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      leadingDateTextStyle: const TextStyle(fontSize: 20),
      slidersColor: Colors.black,
      splashRadius: 20,
    );
    if (pick == null) return;
    onDaySelected(pick, pick);
  }

  // ---------- Helpers ----------
  String _monthName(int m) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return names[(m - 1).clamp(0, 11)];
  }
}
