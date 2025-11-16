import 'dart:convert';
import 'package:const_date_time/const_date_time.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:http/http.dart' as http;
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yourfit/src/models/index.dart';
import 'package:yourfit/src/models/roadmap/food_entry.dart';
import 'package:yourfit/src/services/device_service.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/widgets/other/index.dart';

@RoutePage()
class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: GetBuilder<RoadmapController>(
              init: RoadmapController(),
              builder: (s) => CustomScrollView(
                slivers: [
                  if (s.generatingPlan) const AiGenerationBanner(),
                  RoadmapCalendar(controller: s),
                  SelectedWorkoutCard(workout: s.selectedWorkout),
                  // ADD REGENERATE BUTTON HERE
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: s.generatingPlan
                            ? null
                            : () => s.generateMonthlyPlan(),
                        icon: s.generatingPlan
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.refresh),
                        label: Text(
                          s.generatingPlan
                              ? 'Generating...'
                              : 'Regenerate Monthly Plan',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ),
                  ),
                  NutritionSummarySliver(controller: s),
                  QuickAddRowSliver(controller: s),
                  GetBuilder<RoadmapController>(
                    builder: (controller) => FoodSearchSliver(
                      controller: controller.searchController,
                      onSubmitted: (query) async {
                        await controller.searchFood(query);
                      },
                      loading: controller.loadingSearch,
                    ),
                  ),
                  FoodResultsSliver(controller: s),
                  FoodEntriesSliver(controller: s),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FoodSearchResult {
  final String fdcId;
  final String name;
  final String brand;
  final String category;
  final List<ServingSize> servings;
  final FoodPer100 per100;

  FoodSearchResult({
    required this.fdcId,
    required this.name,
    required this.brand,
    required this.category,
    required this.servings,
    required this.per100,
  });

  factory FoodSearchResult.fromJson(Map<String, dynamic> json) {
    final nutrients = (json['foodNutrients'] as List?) ?? [];

    double getNutrient(int id) {
      final n = nutrients.firstWhere(
        (n) => n['nutrientId'] == id || n['nutrientNumber'] == id.toString(),
        orElse: () => null,
      );
      return n != null ? (n['value'] as num?)?.toDouble() ?? 0.0 : 0.0;
    }

    final servings = <ServingSize>[];
    final portions = (json['foodPortions'] as List?) ?? [];

    for (final p in portions) {
      final amount = (p['amount'] as num?)?.toDouble() ?? 1.0;
      final unit = (p['modifier'] ?? p['portionDescription'] ?? '').toString();
      final grams = (p['gramWeight'] as num?)?.toDouble() ?? 100.0;

      if (unit.isNotEmpty && grams > 0) {
        servings.add(ServingSize(amount: amount, unit: unit, grams: grams));
      }
    }

    if (servings.isEmpty) {
      servings.add(ServingSize(amount: 100, unit: 'g', grams: 100));
    }

    return FoodSearchResult(
      fdcId: json['fdcId']?.toString() ?? '',
      name: json['description'] ?? json['lowercaseDescription'] ?? 'Unknown',
      brand: json['brandName'] ?? json['brandOwner'] ?? '',
      category: json['foodCategory'] ?? json['dataType'] ?? '',
      servings: servings,
      per100: FoodPer100(
        name: json['description'] ?? 'Unknown',
        brand: json['brandName'] ?? '',
        kcal100: getNutrient(1008) * 0.239006,
        protein100: getNutrient(1003),
        carbs100: getNutrient(1005),
        fat100: getNutrient(1004),
        fiber100: getNutrient(1079),
        sugar100: getNutrient(2000),
        sodium100: getNutrient(1093),
      ),
    );
  }
}

class ServingSize {
  final double amount;
  final String unit;
  final double grams;

  ServingSize({required this.amount, required this.unit, required this.grams});

  String get label => amount == 1.0 ? unit : '$amount $unit';

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'unit': unit,
    'grams': grams,
  };

  factory ServingSize.fromJson(Map<String, dynamic> json) => ServingSize(
    amount: (json['amount'] as num?)?.toDouble() ?? 1.0,
    unit: json['unit']?.toString() ?? 'serving',
    grams: (json['grams'] as num?)?.toDouble() ?? 100.0,
  );
}

class RoadmapController extends GetxController {
  final DeviceService deviceService = Get.find();
  final Rx<UserData?> currentUser = Get.find<AuthService>().currentUser;

  static const _usdaApiKey = 'YTzDQuJd18nmpR7b0iUph7fES7bMp8fRoCBjCWlK';

  final searchController = TextEditingController();
  bool loadingSearch = false;
  List<FoodSearchResult> searchResults = [];

  List<FoodEntry> entries = [];
  double totalCalories = 0;
  double totalProtein = 0;
  double totalCarbs = 0;
  double totalFat = 0;
  double totalFiber = 0;
  double totalSugar = 0;
  double totalSodium = 0;

  int waterMl = 0;

  int kcalTarget = 2600;
  int proteinTarget = 110;
  int carbsTarget = 330;
  int fatTarget = 80;
  int fiberTarget = 28;
  int waterTargetMl = 2500;

  bool generatingPlan = false;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  Map<String, WorkoutFocus> workoutPlans = {};
  WorkoutFocus? get selectedWorkout => getWorkoutForDate(selectedDay);

  String get selectedDateName =>
      DateUtils.isSameDay(selectedDay, DateTime.now())
      ? "Today"
      : "${_monthName(selectedDay.month)} ${selectedDay.day}, ${selectedDay.year}";

  List<FoodSearchResult> recentFoods = [];

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
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

  String _dateKey(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  void onDaySelected(DateTime sel, DateTime foc) {
    selectedDay = sel;
    focusedDay = foc;
    _loadDay(sel);
    searchResults = [];
    update();
  }

  WorkoutFocus? getWorkoutForDate(DateTime date) {
    final key = _dateKey(date);
    return workoutPlans[key];
  }

  Future<void> generateMonthlyPlan() async {
    generatingPlan = true;
    update();

    try {
      final user = currentUser.value;
      final age = user?.age ?? 25;
      final activity = user?.physicalFitness ?? UserPhysicalFitness.moderate;
      final plan = await _generateAIPlan(age, activity);
      await _savePlans(plan);
      workoutPlans = plan;

      Get.snackbar(
        'Success',
        'Monthly workout plan generated!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('AI plan generation failed: $e');
      workoutPlans = _generateDefaultPlan();

      Get.snackbar(
        'Note',
        'Using default workout plan',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }

    generatingPlan = false;
    update();
  }

  Future<Map<String, WorkoutFocus>> _generateAIPlan(
    int age,
    UserPhysicalFitness activity,
  ) async {
    const apiKey = "AIzaSyCI-es8sI7XKwQwYiipkmLdlNH65MgExFo";
    const model = 'gemini-2.0-flash-exp';

    final prompt =
        '''
Generate a 30-day workout plan.
User age: $age, activity: ${activity.name}.
Return JSON with date keys (YYYY-MM-DD) starting from today ${_dateKey(DateTime.now())}.
Make the routine consistent , consistency from week to week. For example, if you have a rest day on a sunday, make sure that EVERY sunday is a rest day.
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

        final Map<String, WorkoutFocus> plan = {};
        planJson.forEach((key, value) {
          final type = _parseWorkoutType(value.toString());
          if (type != null) plan[key] = type;
        });

        if (plan.isEmpty) return _generateDefaultPlan();
        return plan;
      }
    } catch (e) {
      print('Gemini API error: $e');
    }

    return _generateDefaultPlan();
  }

  WorkoutFocus? _parseWorkoutType(String raw) {
    final s = raw.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
    if (s.contains('rest')) return WorkoutFocus.rest;
    if (s.contains('full')) return WorkoutFocus.fullBody;
    if (s.contains('upper') || s.contains('push') || s.contains('pull')) {
      return WorkoutFocus.upperBody;
    }
    if (s.contains('leg') || s.contains('lower')) return WorkoutFocus.leg;
    if (s.contains('cardio') || s.contains('hiit') || s.contains('interval')) {
      return WorkoutFocus.cardio;
    }
    if (s.contains('core') || s.contains('abs')) return WorkoutFocus.core;
    if (s.contains('yoga') || s.contains('stretch') || s.contains('mobility')) {
      return WorkoutFocus.yoga;
    }
    return null;
  }

  Map<String, WorkoutFocus> _generateDefaultPlan() {
    final plan = <String, WorkoutFocus>{};
    final today = DateTime.now();

    final pattern = [
      WorkoutFocus.upperBody,
      WorkoutFocus.cardio,
      WorkoutFocus.leg,
      WorkoutFocus.yoga,
      WorkoutFocus.core,
      WorkoutFocus.fullBody,
      WorkoutFocus.rest,
    ];

    for (int i = 0; i < 30; i++) {
      final date = today.add(Duration(days: i));
      plan[_dateKey(date)] = pattern[i % pattern.length];
    }

    return plan;
  }

  Future<void> _savePlans(Map<String, WorkoutFocus> plans) async {
    final Map<String, String> stringPlans = {};
    plans.forEach((key, value) => stringPlans[key] = value.name);
    await deviceService.setDevicePreference(
      'workout_plans',
      jsonEncode(stringPlans),
    );
  }

  Future<void> _loadWorkoutPlans() async {
    final saved = deviceService.getDevicePreference('workout_plans');
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

  void _loadDay(DateTime d) {
    final key = "food-${_dateKey(d)}";
    entries = [];
    final raw = deviceService.getDevicePreference(key);
    if (raw != null) {
      try {
        final list = (jsonDecode(raw) as List)
            .cast<Map>()
            .map((e) => FoodEntry.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        entries = list;
      } catch (e) {
        print('Error loading day: $e');
        entries = [];
      }
    }

    waterMl = deviceService.getDevicePreference("water-${_dateKey(d)}") ?? 0;
    _recomputeTotals();
  }

  void _persistDay() {
    final key = "food-${_dateKey(selectedDay)}";
    final list = entries.map((e) => e.toJson()).toList();
    deviceService.setDevicePreference(key, jsonEncode(list));
    deviceService.setDevicePreference(
      "water-${_dateKey(selectedDay)}",
      waterMl,
    );
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
    update();
  }

  void _loadTargets() {
    kcalTarget = deviceService.getDevicePreference('target_kcal') ?? kcalTarget;
    proteinTarget =
        deviceService.getDevicePreference('target_protein') ?? proteinTarget;
    carbsTarget =
        deviceService.getDevicePreference('target_carbs') ?? carbsTarget;
    fatTarget = deviceService.getDevicePreference('target_fat') ?? fatTarget;
    fiberTarget =
        deviceService.getDevicePreference('target_fiber') ?? fiberTarget;
    waterTargetMl =
        deviceService.getDevicePreference('target_water') ?? waterTargetMl;
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
    await Future.wait([
      deviceService.setDevicePreference('target_kcal', kcalTarget),
      deviceService.setDevicePreference('target_protein', proteinTarget),
      deviceService.setDevicePreference('target_carbs', carbsTarget),
      deviceService.setDevicePreference('target_fat', fatTarget),
      deviceService.setDevicePreference('target_fiber', fiberTarget),
      deviceService.setDevicePreference('target_water', waterTargetMl),
    ]);
    update();
  }

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

  Future<void> searchFood(String? query) async {
    if (query == null || query.isEmpty) return;

    loadingSearch = true;
    searchResults = [];
    update();

    try {
      // Search multiple data types for better results
      final branded = await _searchUSDA(query, 'Branded');
      final foundation = await _searchUSDA(query, 'Foundation,SR Legacy');

      final combined = <FoodSearchResult>[...branded, ...foundation];

      // Sort by relevance
      final queryLower = query.toLowerCase();
      combined.sort((a, b) {
        final aName = a.name.toLowerCase();
        final bName = b.name.toLowerCase();

        // Exact matches first
        if (aName == queryLower) return -1;
        if (bName == queryLower) return 1;

        // Starts with query
        final aStarts = aName.startsWith(queryLower) ? 0 : 1;
        final bStarts = bName.startsWith(queryLower) ? 0 : 1;
        if (aStarts != bStarts) return aStarts - bStarts;

        // Contains query earlier
        final aIndex = aName.indexOf(queryLower);
        final bIndex = bName.indexOf(queryLower);
        if (aIndex != bIndex) return aIndex - bIndex;

        // Branded items first (usually more accurate)
        if (a.brand.isNotEmpty && b.brand.isEmpty) return -1;
        if (b.brand.isNotEmpty && a.brand.isEmpty) return 1;

        return 0;
      });

      searchResults = combined.take(25).toList();

      if (searchResults.isEmpty) {
        Get.snackbar(
          'No Results',
          'No foods found for "$query". Try a different search term.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Search error: $e');
      Get.snackbar(
        'Search Failed',
        'Could not search foods. Please check your internet connection.',
        snackPosition: SnackPosition.BOTTOM,
      );
      searchResults = [];
    }

    loadingSearch = false;
    update();
  }

  Future<List<FoodSearchResult>> _searchUSDA(
    String query,
    String dataType,
  ) async {
    try {
      final uri = Uri.parse('https://api.nal.usda.gov/fdc/v1/foods/search')
          .replace(
            queryParameters: {
              'api_key': _usdaApiKey,
              'query': query,
              'dataType': dataType,
              'pageSize': '25',
              'sortBy': 'dataType.keyword',
              'sortOrder': 'asc',
            },
          );

      final res = await http.get(uri).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final foods = (data['foods'] as List?) ?? [];

        return foods
            .map((f) {
              try {
                return FoodSearchResult.fromJson(f);
              } catch (e) {
                print('Error parsing food: $e');
                return null;
              }
            })
            .whereType<FoodSearchResult>()
            .where((f) => f.per100.kcal100 > 0)
            .toList();
      } else if (res.statusCode == 403) {
        throw Exception(
          'API key invalid. Get one from https://fdc.nal.usda.gov/api-key-signup.html',
        );
      }
    } catch (e) {
      print('USDA API error for $dataType: $e');
    }

    return [];
  }

  void addFoodFromResult({
    required FoodSearchResult result,
    required ServingSize serving,
    required double servingQty,
    required MealType meal,
  }) {
    final totalGrams = serving.grams * servingQty;
    final factor = totalGrams / 100.0;

    final e = FoodEntry(
      name: result.name,
      brand: result.brand,
      grams: totalGrams,
      meal: meal,
      kcal: result.per100.kcal100 * factor,
      proteinG: result.per100.protein100 * factor,
      carbsG: result.per100.carbs100 * factor,
      fatG: result.per100.fat100 * factor,
      fiberG: result.per100.fiber100 * factor,
      sugarG: result.per100.sugar100 * factor,
      sodiumMg: result.per100.sodium100 * factor,
      time: DateTime.now(),
    );

    entries.add(e);
    _recomputeTotals();
    _persistDay();
    _addRecent(result);

    // Clear search after adding
    searchController.clear();
    searchResults = [];

    Get.snackbar(
      'Added',
      '${result.name} added to ${meal.label}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );

    update();
  }

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

  void _loadRecents() {
    final raw = deviceService.getDevicePreference('recent_foods_v2');
    recentFoods = [];
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = (jsonDecode(raw) as List)
            .map((e) {
              try {
                final servings = ((e['servings'] as List?) ?? [])
                    .map(
                      (s) => ServingSize.fromJson(Map<String, dynamic>.from(s)),
                    )
                    .toList();

                return FoodSearchResult(
                  fdcId: e['fdcId'] ?? '',
                  name: e['name'] ?? '',
                  brand: e['brand'] ?? '',
                  category: e['category'] ?? '',
                  servings: servings.isEmpty
                      ? [ServingSize(amount: 100, unit: 'g', grams: 100)]
                      : servings,
                  per100: FoodPer100.fromJson(
                    Map<String, dynamic>.from(e['per100']),
                  ),
                );
              } catch (_) {
                return null;
              }
            })
            .whereType<FoodSearchResult>()
            .toList();
        recentFoods = list.take(15).toList();
      } catch (e) {
        print('Error loading recents: $e');
      }
    }
  }

  void _saveRecents() {
    final list = recentFoods
        .map(
          (e) => {
            'fdcId': e.fdcId,
            'name': e.name,
            'brand': e.brand,
            'category': e.category,
            'servings': e.servings.map((s) => s.toJson()).toList(),
            'per100': e.per100.toJson(),
          },
        )
        .toList();
    deviceService.setDevicePreference('recent_foods_v2', jsonEncode(list));
  }

  void _addRecent(FoodSearchResult food) {
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
      final mealEntries = entries.where((e) => e.meal == m).toList();
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
