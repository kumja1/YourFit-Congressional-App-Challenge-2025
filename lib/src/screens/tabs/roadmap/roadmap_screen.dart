// lib/src/screens/tabs/roadmap/roadmap_screen.dart
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/screens/tabs/roadmap/models/food_tracker_widget.dart';

import 'roadmap_controller.dart';
import 'widgets/daily_summary_widgets.dart';
import 'widgets/roadmap_calendar.dart';
import 'widgets/food_tracker_widgets.dart' hide FoodSearchSliver;

@RoutePage()
class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(RoadmapController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roadmap'),
        actions: [
          GetBuilder<RoadmapController>(
            builder: (s) => IconButton(
              icon: const Icon(Icons.auto_awesome),
              onPressed: s.generatingPlan ? null : s.generateMonthlyPlan,
              tooltip: 'Generate AI Plan',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: GetBuilder<RoadmapController>(
              builder: (s) => CustomScrollView(
                slivers: [
                  if (s.generatingPlan) const AiGenerationBanner(),

                  // Calendar
                  RoadmapCalendar(controller: s),

                  // Selected day summary (workout chip, share, etc.)
                  SelectedWorkoutCard(controller: s),

                  // --- Nutrition Summary (macros, calories, hydration, targets) ---
                  NutritionSummarySliver(controller: s),

                  // --- Food Quick Add & Water ---
                  QuickAddRowSliver(controller: s),

                  // --- Search box + Search button ---
                  FoodSearchSliver(controller: s),

                  // --- Search results list (tap to add with grams + meal) ---
                  FoodResultsSliver(controller: s),

                  // --- Logged entries, grouped by meal, with edit/remove ---
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
