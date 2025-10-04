// lib/src/screens/tabs/roadmap/widgets/food_tracker_widgets.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/screens/tabs/roadmap_screen.dart';
import '../../../models/roadmap/food_entry.dart';

// --- Nutrition Summary (calorie ring surrogate + macro bars + hydration) ---
class NutritionSummarySliver extends StatelessWidget {
  final RoadmapController controller;
  const NutritionSummarySliver({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    double pct(double x, double tgt) =>
        tgt > 0 ? (x / tgt).clamp(0, 1).toDouble() : 0;

    final kcalPct = pct(c.totalCalories, c.kcalTarget.toDouble());
    final protPct = pct(c.totalProtein, c.proteinTarget.toDouble());
    final carbPct = pct(c.totalCarbs, c.carbsTarget.toDouble());
    final fatPct = pct(c.totalFat, c.fatTarget.toDouble());
    final fiberPct = pct(c.totalFiber, c.fiberTarget.toDouble());
    final waterPct = pct(c.waterMl.toDouble(), c.waterTargetMl.toDouble());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    _RadialStat(
                      label: 'Calories',
                      value:
                          '${c.totalCalories.toStringAsFixed(0)}/${c.kcalTarget}',
                      progress: kcalPct,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          _MacroBar(
                            label: 'Protein',
                            unit: 'g',
                            value: c.totalProtein,
                            target: c.proteinTarget.toDouble(),
                            progress: protPct,
                          ),
                          const SizedBox(height: 6),
                          _MacroBar(
                            label: 'Carbs',
                            unit: 'g',
                            value: c.totalCarbs,
                            target: c.carbsTarget.toDouble(),
                            progress: carbPct,
                          ),
                          const SizedBox(height: 6),
                          _MacroBar(
                            label: 'Fat',
                            unit: 'g',
                            value: c.totalFat,
                            target: c.fatTarget.toDouble(),
                            progress: fatPct,
                          ),
                          const SizedBox(height: 6),
                          _MacroBar(
                            label: 'Fiber',
                            unit: 'g',
                            value: c.totalFiber,
                            target: c.fiberTarget.toDouble(),
                            progress: fiberPct,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.water_drop_outlined, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: LinearProgressIndicator(value: waterPct)),
                    const SizedBox(width: 10),
                    Text('${c.waterMl}/${c.waterTargetMl} ml'),
                    const SizedBox(width: 8),
                    _WaterButtons(controller: c),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Sugar: ${c.totalSugar.toStringAsFixed(0)} g • Sodium: ${c.totalSodium.toStringAsFixed(0)} mg',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _openTargetsDialog(context, c),
                      icon: const Icon(Icons.tune, size: 16),
                      label: const Text('Targets'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openTargetsDialog(BuildContext context, RoadmapController c) async {
    final kcal = TextEditingController(text: '${c.kcalTarget}');
    final p = TextEditingController(text: '${c.proteinTarget}');
    final carb = TextEditingController(text: '${c.carbsTarget}');
    final fat = TextEditingController(text: '${c.fatTarget}');
    final fiber = TextEditingController(text: '${c.fiberTarget}');
    final water = TextEditingController(text: '${c.waterTargetMl}');
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Daily Targets'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _numField('Calories (kcal)', kcal),
              _numField('Protein (g)', p),
              _numField('Carbs (g)', carb),
              _numField('Fat (g)', fat),
              _numField('Fiber (g)', fiber),
              _numField('Water (ml)', water),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              c.setTargets(
                kcal: int.tryParse(kcal.text) ?? c.kcalTarget,
                protein: int.tryParse(p.text) ?? c.proteinTarget,
                carbs: int.tryParse(carb.text) ?? c.carbsTarget,
                fat: int.tryParse(fat.text) ?? c.fatTarget,
                fiber: int.tryParse(fiber.text) ?? c.fiberTarget,
                waterMl: int.tryParse(water.text) ?? c.waterTargetMl,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _numField(String label, TextEditingController c) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: TextField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    ),
  );
}

class _WaterButtons extends StatelessWidget {
  const _WaterButtons({required this.controller});
  final RoadmapController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      children: [
        IconButton(
          tooltip: "+250 ml",
          onPressed: () => controller.addWater(250),
          icon: const Icon(Icons.add),
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          tooltip: "-250 ml",
          onPressed: () => controller.removeWater(250),
          icon: const Icon(Icons.remove),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

class _RadialStat extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  const _RadialStat({
    required this.label,
    required this.value,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 112,
            height: 112,
            child: CircularProgressIndicator(value: progress, strokeWidth: 10),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final String unit;
  final double value;
  final double target;
  final double progress;
  const _MacroBar({
    required this.label,
    required this.unit,
    required this.value,
    required this.target,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(label),
            const SizedBox(width: 8),
            Expanded(child: LinearProgressIndicator(value: progress)),
            const SizedBox(width: 8),
            Text(
              '${value.toStringAsFixed(0)}/${target.toStringAsFixed(0)} $unit',
            ),
          ],
        ),
      ],
    );
  }
}

// --- Quick add row (recents + common grams + meals) ---
class QuickAddRowSliver extends StatelessWidget {
  final RoadmapController controller;
  const QuickAddRowSliver({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (c.recentFoods.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: c.recentFoods.take(10).map((f) {
                  return ActionChip(
                    label: Text(f.name, overflow: TextOverflow.ellipsis),
                    onPressed: () => _openAddDialog(context, c, f),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _openAddDialog(
    BuildContext context,
    RoadmapController c,
    FoodPer100 per100,
  ) {
    final grams = TextEditingController(text: '100');
    MealType selected = MealType.lunch;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add "${per100.name}"'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              per100.brand.isEmpty ? 'Per 100g' : '${per100.brand} • Per 100g',
            ),
            const SizedBox(height: 8),
            _nutritionPreview(per100),
            const SizedBox(height: 8),
            TextField(
              controller: grams,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Grams',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: [50, 100, 150, 200, 300].map((g) {
                return OutlinedButton(
                  onPressed: () => grams.text = '$g',
                  child: Text('${g}g'),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<MealType>(
              value: selected,
              items: MealType.values
                  .map((m) => DropdownMenuItem(value: m, child: Text(m.label)))
                  .toList(),
              onChanged: (m) => selected = m ?? MealType.lunch,
              decoration: const InputDecoration(
                labelText: 'Meal',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final g = double.tryParse(grams.text) ?? 100.0;
              c.addFoodFromPer100(per100: per100, grams: g, meal: selected);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _nutritionPreview(FoodPer100 f) {
    String n(double v, {String unit = ''}) =>
        v == 0 ? '-' : '${v.toStringAsFixed(0)}$unit';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'kcal: ${n(f.kcal100)} • P: ${n(f.protein100, unit: 'g')} • C: ${n(f.carbs100, unit: 'g')} • F: ${n(f.fat100, unit: 'g')}',
        ),
        Text(
          'Fiber: ${n(f.fiber100, unit: 'g')} • Sugar: ${n(f.sugar100, unit: 'g')} • Sodium: ${n(f.sodium100, unit: 'mg')}',
        ),
      ],
    );
  }
}

// --- Search results sliver ---
class FoodResultsSliver extends StatelessWidget {
  final RoadmapController controller;
  const FoodResultsSliver({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    if (c.searchResults.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList.separated(
      itemCount: c.searchResults.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final p = c.searchResults[i];
        final per100 = c.mapProductToPer100(p);
        return ListTile(
          dense: true,
          title: Text(per100.name),
          subtitle: Text(per100.brand.isEmpty ? 'Per 100g' : per100.brand),
          trailing: Text('${per100.kcal100.toStringAsFixed(0)} kcal/100g'),
          onTap: () => _openAddDialog(context, c, per100),
        );
      },
    );
  }

  void _openAddDialog(
    BuildContext context,
    RoadmapController c,
    FoodPer100 per100,
  ) {
    final grams = TextEditingController(text: '100');
    MealType selected = MealType.lunch;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add "${per100.name}"'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              per100.brand.isEmpty ? 'Per 100g' : '${per100.brand} • Per 100g',
            ),
            const SizedBox(height: 8),
            _nutritionPreview(per100),
            const SizedBox(height: 8),
            TextField(
              controller: grams,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Grams',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: [50, 100, 150, 200, 300].map((g) {
                return OutlinedButton(
                  onPressed: () => grams.text = '$g',
                  child: Text('${g}g'),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<MealType>(
              value: selected,
              items: MealType.values
                  .map((m) => DropdownMenuItem(value: m, child: Text(m.label)))
                  .toList(),
              onChanged: (m) => selected = m ?? MealType.lunch,
              decoration: const InputDecoration(
                labelText: 'Meal',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final g = double.tryParse(grams.text) ?? 100.0;
              c.addFoodFromPer100(per100: per100, grams: g, meal: selected);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _nutritionPreview(FoodPer100 f) {
    String n(double v, {String unit = ''}) =>
        v == 0 ? '-' : '${v.toStringAsFixed(0)}$unit';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'kcal: ${n(f.kcal100)} • P: ${n(f.protein100, unit: 'g')} • C: ${n(f.carbs100, unit: 'g')} • F: ${n(f.fat100, unit: 'g')}',
        ),
        Text(
          'Fiber: ${n(f.fiber100, unit: 'g')} • Sugar: ${n(f.sugar100, unit: 'g')} • Sodium: ${n(f.sodium100, unit: 'mg')}',
        ),
      ],
    );
  }
}

// --- Entries sliver (grouped by meal) ---
class FoodEntriesSliver extends StatelessWidget {
  final RoadmapController controller;
  const FoodEntriesSliver({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    if (c.entries.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Text('No foods added yet. Search above to log your meal.'),
        ),
      );
    }

    final groups = <MealType, List<FoodEntry>>{};
    for (final m in MealType.values) {
      groups[m] = c.entries.where((e) => e.meal == m).toList();
    }

    return SliverList.builder(
      itemCount: MealType.values.length,
      itemBuilder: (_, idx) {
        final meal = MealType.values[idx];
        final list = groups[meal]!;
        if (list.isEmpty) return const SizedBox.shrink();

        final kcal = list.fold<double>(0, (a, b) => a + b.kcal);
        final prot = list.fold<double>(0, (a, b) => a + b.proteinG);

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        meal.label,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Text(
                        '${kcal.toStringAsFixed(0)} kcal • ${prot.toStringAsFixed(0)} g P',
                      ),
                    ],
                  ),
                  const Divider(),
                  ...List.generate(list.length, (i) {
                    final e = list[i];
                    final globalIndex = c.entries.indexOf(e);
                    return ListTile(
                      dense: true,
                      title: Text(e.name),
                      subtitle: Text(
                        '${e.brand.isEmpty ? '' : '${e.brand} • '}${e.grams.toStringAsFixed(0)}g — P ${e.proteinG.toStringAsFixed(0)}g, C ${e.carbsG.toStringAsFixed(0)}g, F ${e.fatG.toStringAsFixed(0)}g',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${e.kcal.toStringAsFixed(0)} kcal'),
                          IconButton(
                            tooltip: 'Edit',
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () =>
                                _openEditDialog(context, c, globalIndex, e),
                          ),
                          IconButton(
                            tooltip: 'Remove',
                            icon: const Icon(Icons.delete_outline, size: 18),
                            onPressed: () => c.removeEntry(globalIndex),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openEditDialog(
    BuildContext context,
    RoadmapController c,
    int idx,
    FoodEntry e,
  ) {
    final grams = TextEditingController(text: e.grams.toStringAsFixed(0));
    MealType selected = e.meal;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit "${e.name}"'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: grams,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Grams',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: [50, 100, 150, 200, 300].map((g) {
                return OutlinedButton(
                  onPressed: () => grams.text = '$g',
                  child: Text('${g}g'),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<MealType>(
              value: selected,
              items: MealType.values
                  .map((m) => DropdownMenuItem(value: m, child: Text(m.label)))
                  .toList(),
              onChanged: (m) => selected = m ?? e.meal,
              decoration: const InputDecoration(
                labelText: 'Meal',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final g = double.tryParse(grams.text);
              c.editEntry(idx, grams: g, meal: selected);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
