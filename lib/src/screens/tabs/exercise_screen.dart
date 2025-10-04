// lib/src/screens/tabs/exercise/workouts_screen.dart
import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yourfit/src/models/index.dart';
import 'package:yourfit/src/routing/router.gr.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/widgets/other/exercise/index.dart';

@RoutePage()
class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(_WorkoutsScreenController());
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      floatingActionButton: GetBuilder<_WorkoutsScreenController>(
        init: _WorkoutsScreenController(),
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
          label: const Text('New Plan', style: TextStyle(color: Colors.blue)),
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
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
                        level: c.currentUserStats?.level ?? 1,
                        xp: c.currentUserStats?.xp ?? 0,
                        xpToNext: c.currentUserStats?.xpToNext ?? 0,
                        streak: c.currentUserStats?.streak ?? 0,
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
                    explanation: "",
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
                    itemBuilder: (_, i) => ExerciseCard(
                      exercise: c.exercises[i],
                      onStart: (exercise) => context.router.navigate(
                        BasicExerciseRoute(
                          exercise: exercise,
                          onSetComplete: () => c.updateXp(exercise),
                          onExerciseComplete: () {},
                        ),
                      ),
                    ).paddingOnly(bottom: 16),
                  ),
                ),
            ],
          ),

          Positioned(
            right: 16,
            bottom: 92, // sits above the main FAB
            child: const QaMiniButton(),
          ),
        ],
      ),
    );
  }
}

class _WorkoutsScreenController extends GetxController {
  _WorkoutsScreenController();

  // ---- Screen State ----
  bool loading = false;
  List<ExerciseData> exercises = [];
  String? dayFocus; // label for UI (e.g., "Leg Day")
  UserStats? get currentUserStats => _currentUser.value?.stats;

  final Rx<UserData?> _currentUser = Get.find<AuthService>().currentUser;
  final ExerciseService _exerciseService = Get.find();
  final UserService _userService = Get.find();

  Future<void> generate() async {
    if (loading) return;
    loading = true;
    update();
    final canonicalFocus = await _canonicalFocusForToday();
    dayFocus = _labelForCanonical(canonicalFocus);
    try {
      final result = await _exerciseService.getExercises(_currentUser.value);
      exercises = result?.exercises ?? [];
    } on Error catch (e, st) {
      print("Generate: $e, $st");
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> tweakWorkout(String instruction) async {
    if (loading) return;
    loading = true;
    update();

    try {
      final canonicalFocus = await _canonicalFocusForToday();
      dayFocus = _labelForCanonical(canonicalFocus);

      final res = await _exerciseService.getExercises(
        _currentUser.value,
        count: exercises.length,
      );

      exercises = res?.exercises ?? [];
      // aiExplanation = res.explanation;
    } catch (e) {
      showSnackbar(e.toString(), AnimatedSnackBarType.error);
    } finally {
      loading = false;
      update();
    }
  }

  void updateXp(ExerciseData exercise) async {
    final gained =
        8 + (exercise.reps ~/ 5) + (_currentUser.value?.stats.streak ?? 0 ~/ 5);
    
    _currentUser.value?.stats.addXp(gained);
    await _userService.updateUser(_currentUser.value!);
  }

  // ----------------- Focus (from Roadmap prefs) -----------------
  Future<String?> _canonicalFocusForToday() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('workout_plans');
      if (raw == null) return null;

      final Map<String, dynamic> decoded =
          jsonDecode(raw) as Map<String, dynamic>;
      final key = _dateKey(DateTime.now());
      final v = decoded[key]?.toString();
      if (v == null) return null;
      return _canonFocus(v);
    } catch (e) {
      if (kDebugMode) print('focus load error: $e');
      return null;
    }
  }

  String _dateKey(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String _canonFocus(String v) {
    final s = v.toLowerCase();
    if (s.contains('upper') || s.contains('push') || s.contains('pull'))
      return 'upperBody';
    if (s.contains('leg') || s.contains('lower')) return 'legDay';
    if (s.contains('cardio') || s.contains('hiit') || s.contains('interval'))
      return 'cardio';
    if (s.contains('core') || s.contains('abs')) return 'core';
    if (s.contains('full')) return 'fullBody';
    if (s.contains('rest')) return 'rest';
    if (s.contains('yoga') || s.contains('stretch') || s.contains('mobility'))
      return 'yoga';
    return 'fullBody';
  }

  String? _labelForCanonical(String? canon) {
    switch (canon) {
      case 'upperBody':
        return 'Upper Body';
      case 'legDay':
        return 'Leg Day';
      case 'cardio':
        return 'Cardio';
      case 'core':
        return 'Core';
      case 'fullBody':
        return 'Full Body';
      case 'rest':
        return 'Rest Day';
      case 'yoga':
        return 'Yoga/Stretch';
      default:
        return null;
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
