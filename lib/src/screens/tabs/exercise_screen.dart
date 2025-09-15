// lib/src/screens/tabs/exercise/workouts_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/exercise/workouts_controller.dart';
import '../../widgets/exercise/compact_header.dart';
import '../../widgets/exercise/exercise_card.dart';
import '../../widgets/exercise/ai_insights_panel.dart';
import '../../widgets/exercise/qa_mini.dart';

@RoutePage()
class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(WorkoutsScreenController());
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      floatingActionButton: GetBuilder<WorkoutsScreenController>(
        init: WorkoutsScreenController(),
        builder: (c) => FloatingActionButton.extended(
          onPressed: c.loading ? null : c.generate,
          icon: c.loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.refresh),
          label: const Text('New Plan'),
        ),
      ),
      body: GetBuilder<WorkoutsScreenController>(
        builder: (c) {
          final scroll = CustomScrollView(
            slivers: [
              if (c.lastError != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        c.lastError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ),
                ),

              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  minExtentVal: 84,
                  maxExtentVal: 120,
                  child: Material(
                    elevation: 2,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: CompactHeader(
                        level: c.level,
                        xp: c.xp,
                        xpToNext: c.xpToNext,
                        progress: c.xpProgress,
                        streak: c.streak,
                      ),
                    ),
                  ),
                ),
              ),

              if (c.dayFocus != null && c.dayFocus!.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TODAY'S FOCUS",
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              color: Theme.of(context).primaryColor,
                              size: 26,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                c.dayFocus!,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: AiInsightsPanel(
                    explanation: c.aiExplanation,
                    loading: c.loading,
                    onTweak: (instruction) => c.tweakWorkout(instruction),
                  ),
                ),
              ),

              if (c.loading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  sliver: SliverList.builder(
                    itemCount: c.exercises.length,
                    itemBuilder: (_, i) {
                      final ex = c.exercises[i];
                      return ExerciseCard(
                        exercise: ex,
                        progress: c.progressFor(i),
                        isDone: c.isDone(i),
                        onStart: () => c.openExec(i),
                        onYoutube: () => _openYoutube(ex.name),
                        summaryText: ex.summary,
                      );
                    },
                  ),
                ),
            ],
          );

          return Stack(
            children: [
              scroll,
              Positioned(
                right: 16,
                bottom: 92, // sits above the main FAB
                child: const QaMiniButton(),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openYoutube(String exerciseName) async {
    final query = '$exerciseName tutorial';
    final url =
        'https://www.youtube.com/results?search_query=${Uri.encodeQueryComponent(query)}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickyHeaderDelegate({
    required this.minExtentVal,
    required this.maxExtentVal,
    required this.child,
  });

  final double minExtentVal;
  final double maxExtentVal;
  final Widget child;

  @override
  double get minExtent => minExtentVal;

  @override
  double get maxExtent => maxExtentVal;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.minExtentVal != minExtentVal ||
        oldDelegate.maxExtentVal != maxExtentVal ||
        oldDelegate.child != child;
  }
}
