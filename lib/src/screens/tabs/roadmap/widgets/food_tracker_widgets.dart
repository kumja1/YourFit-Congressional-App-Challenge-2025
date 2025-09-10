// lib/src/screens/tabs/roadmap/widgets/food_tracker_widgets.dart
import 'package:flutter/material.dart';
import '../roadmap_controller.dart';

class FoodSearchSliver extends StatelessWidget {
  final RoadmapController controller;
  const FoodSearchSliver({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.searchController,
              decoration: const InputDecoration(
                hintText: 'Search food (banana, rice, pizza)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => controller.searchFoods(),
            ),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: controller.loadingSearch ? null : controller.searchFoods,
            icon: controller.loadingSearch
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.search),
            label: const Text('Search'),
            style: FilledButton.styleFrom(minimumSize: const Size(110, 48)),
          ),
        ],
      ),
    );
  }
}

// ... other food-related widgets like SearchResultsList and FoodEntriesList
// NOTE: These are omitted for brevity but would be structured similarly,
// taking the controller as a parameter and returning a Sliver.
