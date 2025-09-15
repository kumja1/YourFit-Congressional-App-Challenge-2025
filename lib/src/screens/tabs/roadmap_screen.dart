import 'dart:convert';
import 'package:auto_route/annotations.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart' hide AnimatedList;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class FoodEntry {
  final String name;
  final double kcal;
  final double grams;
  FoodEntry({required this.name, required this.kcal, required this.grams});
  Map<String, dynamic> toJson() => {"name": name, "kcal": kcal, "grams": grams};
  factory FoodEntry.fromJson(Map<String, dynamic> j) => FoodEntry(
    name: j["name"]?.toString() ?? "",
    kcal: (j["kcal"] as num?)?.toDouble() ?? 0,
    grams: (j["grams"] as num?)?.toDouble() ?? 0,
  );
}

@RoutePage()
class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(_RoadmapScreenController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roadmap'),
        actions: [
          GetBuilder<_RoadmapScreenController>(
            builder: (s) => IconButton(
              icon: const Icon(Icons.event),
              onPressed: () => s.selectDate(context),
            ),
          ),
          GetBuilder<_RoadmapScreenController>(
            builder: (s) => IconButton(
              icon: const Icon(Icons.ios_share),
              onPressed: s.entries.isEmpty ? null : () => s.shareDay(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: GetBuilder<_RoadmapScreenController>(
              builder: (s) => CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16, top: 12),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TableCalendar(
                          calendarFormat: CalendarFormat.month,
                          focusedDay: s.focusedDay,
                          firstDay: const ConstDateTime(2024),
                          lastDay: const ConstDateTime(2050),
                          rowHeight: 46,
                          formatAnimationDuration: const Duration(
                            milliseconds: 500,
                          ),
                          calendarStyle: CalendarStyle(
                            weekendTextStyle: const TextStyle(
                              color: Colors.black54,
                            ),
                            defaultTextStyle: const TextStyle(
                              color: Colors.black87,
                            ),
                            todayDecoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            outsideDaysVisible: false,
                            selectedDecoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            headerPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          daysOfWeekStyle: const DaysOfWeekStyle(
                            weekendStyle: TextStyle(color: Colors.black54),
                            weekdayStyle: TextStyle(color: Colors.black54),
                          ),
                          selectedDayPredicate: (d) =>
                              isSameDay(d, s.selectedDay),
                          onDaySelected: (sel, foc) =>
                              s.onDaySelected(sel, foc),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  s.totalCalories.toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "Calories today",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              s.selectedDateName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: s.searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search food (banana, rice, pizza)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (_) => s.searchFoods(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        FilledButton.icon(
                          onPressed: s.loadingSearch ? null : s.searchFoods,
                          icon: s.loadingSearch
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.search),
                          label: const Text('Search'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(110, 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  if (s.searchResults.isNotEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Search results',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (s.searchResults.isNotEmpty)
                    SliverList.separated(
                      itemBuilder: (_, i) {
                        final it = s.searchResults[i];
                        final name =
                            it["product_name"]?.toString() ??
                            it["generic_name_en"]?.toString() ??
                            "Food";
                        final kcal100 =
                            (it["nutriments"]?["energy-kcal_100g"] ??
                                    it["nutriments"]?["energy-kcal_serving"])
                                ?.toString();
                        final kcalNum = double.tryParse(kcal100 ?? "") ?? 0;
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black12,
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              kcalNum > 0
                                  ? "${kcalNum.toStringAsFixed(0)} kcal / 100g"
                                  : "No kcal data",
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: kcalNum <= 0
                                  ? null
                                  : () async {
                                      final grams = await _gramsDialog(context);
                                      if (grams == null) return;
                                      s.addFood(name, kcalNum, grams);
                                    },
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemCount: s.searchResults.length,
                    ),
                  if (s.searchResults.isNotEmpty)
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Entries',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12, width: 1.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: s.entries.isEmpty
                          ? const SizedBox(
                              height: 60,
                              child: Center(child: Text('No entries yet')),
                            )
                          : Column(
                              children: List.generate(s.entries.length, (i) {
                                final e = s.entries[i];
                                return Column(
                                  children: [
                                    ListTile(
                                      dense: true,
                                      title: Text(
                                        e.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        "${e.grams.toStringAsFixed(0)} g",
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "${e.kcal.toStringAsFixed(0)} kcal",
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                            ),
                                            onPressed: () => s.removeEntry(i),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (i != s.entries.length - 1)
                                      const Divider(height: 1),
                                  ],
                                );
                              }),
                            ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          ),
        ),
      ],
    ).center().scrollable();
  }
}

class _RoadmapScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final Rx<UserData?> currentUser = Get.find<AuthService>().currentUser;
  final searchController = TextEditingController();
  List<dynamic> searchResults = [];
  List<FoodEntry> entries = [];
  double totalCalories = 0;
  bool loadingSearch = false;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  SharedPreferences? _prefs;

  String get selectedDateName =>
      DateUtils.isSameDay(selectedDay, DateTime.now())
      ? "Today"
      : "${_monthName(selectedDay.month)} ${selectedDay.day}, ${selectedDay.year}";

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
    _loadFoodFor(selectedDay);
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    update();
  }

  String _dateKey(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  void onDaySelected(DateTime sel, DateTime foc) {
    selectedDay = sel;
    focusedDay = foc;
    _loadFoodFor(sel);
    update();
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

  void _loadFoodFor(DateTime d) {
    final key = "food-${_dateKey(d)}";
    entries = [];
    totalCalories = 0;
    final raw = _prefs?.getString(key);
    if (raw != null) {
      final list = (jsonDecode(raw) as List)
          .cast<Map>()
          .map((e) => FoodEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      entries = list;
      totalCalories = entries.fold(0, (a, b) => a + b.kcal);
    }
  }

  void _persistFood() {
    final key = "food-${_dateKey(selectedDay)}";
    final list = entries.map((e) => e.toJson()).toList();
    _prefs?.setString(key, jsonEncode(list));
  }

  Future<void> searchFoods() async {
    final q = searchController.text.trim();
    if (q.isEmpty) return;
    loadingSearch = true;
    update();
    try {
      final uri = Uri.parse(
        "https://world.openfoodfacts.org/cgi/search.pl?search_terms=${Uri.encodeComponent(q)}&search_simple=1&action=process&json=1&page_size=20",
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
            .take(20)
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

  void addFood(String name, double kcalPer100g, double grams) {
    final kcal = kcalPer100g * grams / 100.0;
    entries.add(FoodEntry(name: name, kcal: kcal, grams: grams));
    totalCalories = entries.fold(0, (a, b) => a + b.kcal);
    _persistFood();
    update();
  }

  void removeEntry(int index) {
    if (index < 0 || index >= entries.length) return;
    entries.removeAt(index);
    totalCalories = entries.fold(0, (a, b) => a + b.kcal);
    _persistFood();
    update();
  }

  void shareDay() {
    final lines = <String>[];
    lines.add("Day • $selectedDateName");
    if (entries.isNotEmpty) {
      lines.add("Food:");
      for (final e in entries) {
        lines.add(
          "- ${e.name} ${e.kcal.toStringAsFixed(0)} kcal (${e.grams.toStringAsFixed(0)}g)",
        );
      }
      lines.add("Total: ${totalCalories.toStringAsFixed(0)} kcal");
    }
    Share.share(lines.join("\n"));
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

Future<double?> _gramsDialog(BuildContext context) async {
  final ctrl = TextEditingController(text: "100");
  return showDialog<double>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Enter grams'),
      content: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(hintText: 'e.g., 120'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final v = double.tryParse(ctrl.text.trim());
            if (v == null || v <= 0) {
              Navigator.of(ctx).pop();
            } else {
              Navigator.of(ctx).pop(v);
            }
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
