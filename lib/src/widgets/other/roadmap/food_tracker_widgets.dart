// lib/src/screens/tabs/roadmap/widgets/food_tracker_widgets.dart
import 'package:flutter/material.dart';

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
      child: SearchBar(
        hintText: 'Search food (banana, rice, pizza)',
        controller: controller,
        onSubmitted: onSubmitted,
        trailing: [
          FilledButton.icon(
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
        ],
      ),
    );
  }
}
