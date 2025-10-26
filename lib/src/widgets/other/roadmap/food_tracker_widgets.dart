// lib/src/widgets/other/roadmap/food_tracker_widgets.dart
import 'package:flutter/material.dart';
import 'package:yourfit/src/models/roadmap/food_entry.dart';
import 'package:yourfit/src/screens/tabs/roadmap_screen.dart';

class NutritionSummarySliver extends StatelessWidget {
  final dynamic controller;
  const NutritionSummarySliver({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nutrition Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Calories: ${controller.totalCalories.toStringAsFixed(0)} / ${controller.kcalTarget} kcal',
                ),
                Text(
                  'Protein: ${controller.totalProtein.toStringAsFixed(0)}g / ${controller.proteinTarget}g',
                ),
                Text(
                  'Carbs: ${controller.totalCarbs.toStringAsFixed(0)}g / ${controller.carbsTarget}g',
                ),
                Text(
                  'Fat: ${controller.totalFat.toStringAsFixed(0)}g / ${controller.fatTarget}g',
                ),
                const SizedBox(height: 4),
                Text(
                  'Water: ${controller.waterMl} / ${controller.waterTargetMl} ml',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuickAddRowSliver extends StatelessWidget {
  final dynamic controller;
  const QuickAddRowSliver({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () => controller.addWater(250),
                child: const Text('+250ml Water'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: controller.shareDay,
                child: const Text('Share Day'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodSearchSliver extends StatelessWidget {
  final Function(String?) onSubmitted;
  final TextEditingController controller;
  final bool loading;
  const FoodSearchSliver({
    super.key,
    required this.onSubmitted,
    required this.controller,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: onSubmitted,
                decoration: const InputDecoration(
                  hintText: 'Search food (banana, rice, pizza)',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: loading ? null : () => onSubmitted(controller.text),
                icon: loading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search),
                label: const Text('Search'),
                style: FilledButton.styleFrom(minimumSize: const Size(110, 48)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodResultsSliver extends StatelessWidget {
  final dynamic controller;
  const FoodResultsSliver({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final results = controller.searchResults;
    if (results.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList.builder(
      itemCount: results.length,
      itemBuilder: (context, i) {
        final r = results[i];
        return ListTile(
          title: Text(r.name),
          subtitle: Text(r.brand.isEmpty ? r.category : r.brand),
          trailing: IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              controller.addFoodFromResult(
                result: r,
                serving: r.servings.first,
                servingQty: 1,
                meal: MealType.breakfast,
              );
            },
          ),
        );
      },
    );
  }
}

class FoodEntriesSliver extends StatelessWidget {
  final dynamic controller;
  const FoodEntriesSliver({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final entries = controller.entries;
    if (entries.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No food logged yet', textAlign: TextAlign.center),
        ),
      );
    }

    return SliverList.builder(
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final e = entries[i];
        return ListTile(
          title: Text(e.name),
          subtitle: Text(
            '${e.grams.toStringAsFixed(0)}g • ${e.kcal.toStringAsFixed(0)} kcal',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => controller.removeEntry(i),
          ),
        );
      },
    );
  }
}
