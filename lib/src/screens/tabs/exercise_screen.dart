// lib/src/screens/tabs/exercise/workouts_screen.dart

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:free_map/free_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yourfit/src/models/exercise/running_exercise_data.dart';
import 'package:yourfit/src/models/index.dart';
import 'package:yourfit/src/routing/router.gr.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/widgets/other/exercise/index.dart';

@RoutePage()
class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(_ExerciseScreenController());
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      floatingActionButton: GetBuilder<_ExerciseScreenController>(
        init: _ExerciseScreenController(),
        id: "loading",
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
                        level: c.currentStats?.level ?? 1,
                        xp: c.currentStats?.xp ?? 0,
                        xpToNext: c.currentStats?.xpToNext ?? 0,
                        streak: c.currentStats?.streak ?? 0,
                      ),
                    ),
                  ),
                ),
              ),

              if (c.workoutFocus != null && c.workoutFocus!.label.isNotEmpty)
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
                                c.workoutFocus!.label,
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
                  sliver: GetBuilder<_ExerciseScreenController>(
                    id: "exercises",
                    builder: (controller) => SliverPadding(
                      padding: EdgeInsetsGeometry.only(bottom: 16),
                      sliver: SliverList.builder(
                        itemCount: controller.exercises.length,
                        itemBuilder: (_, i) => ExerciseCard(
                          exercise: controller.exercises[i],
                          onStart: (exercise) => context.router.push(
                            exercise is RunningExerciseData
                                ? RunningExerciseRoute(
                                    exercise: exercise,
                                    onSetComplete: () =>
                                        controller.updateXp(exercise),
                                    onExerciseComplete: () {},
                                  )
                                : BasicExerciseRoute(
                                    exercise: exercise,
                                    onSetComplete: () =>
                                        controller.updateXp(exercise),
                                    onExerciseComplete: () {},
                                  ),
                          ),
                        ),
                      ),
                    ),
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

class _ExerciseScreenController extends GetxController {
  _ExerciseScreenController();

  WorkoutFocus? workoutFocus; // label for UI (e.g., "Leg Day")
  final Rx<UserData?> currentUser = Get.find<AuthService>().currentUser;
  final ExerciseService exerciseService = Get.find();
  final UserService userService = Get.find();
  final FmService geocodingService = Get.find();
  final SharedPreferences preferences = Get.find();

  // ---- Screen State ----
  bool loading = false;
  List<ExerciseData> exercises = [
    RunningExerciseData(
      difficulty: ExerciseDifficulty.medium,
      intensity: ExerciseIntensity.high,
      type: ExerciseType.cardio,
      caloriesBurned: 300.0,
      name: "Waterfront Lake Loop Run",
      instructions:
          "Run the Waterfront Lake Loop at a steady pace. Focus on consistent breathing and maintaining good form. Warm up before starting and cool down after completing the loop.",
      summary:
          "A 3.3-mile outdoor run improving cardiovascular endurance and leg strength",
      sets: 1,
      reps: 1,
      duration: Duration(minutes: 30),
      targetMuscles: ["legs", "core", "cardiovascular system"],
      equipment: ["running shoes"],
      restIntervals: [RestInterval(duration: Duration(seconds: 90), restAt: 1)],
      distance: 3.3, // miles
      speed: 9, // average speed in minutes per mile
      destination: "Waterfront Lake Loop, Short Pump, VA",
    ),
  ];
  UserStats? get currentStats => currentUser.value?.stats;

  @override
  void onInit() async {
    super.onInit();

    if (preferences.containsKey("location_permission")) {
      return;
    }

    final permission = await Geolocator.requestPermission();
    final denied =
        permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine;

    if (!denied) {
      preferences.setBool("location_permission", true);
    }

    final now = DateTime.now();
    final timestamp =
        DateTime.tryParse(preferences.getString("last_generation") ?? "") ??
        now;

    if (now.difference(timestamp).inDays < 1) {
      return;
    }

    preferences.setString("last_generation", now.toIso8601String());
    await generate();
  }

  Future<void> generate() async {
    if (loading) return;
    loading = true;
    update(["loading"]);
    workoutFocus = await exerciseService.getWorkoutFocus(currentUser.value);
    try {
      final currentPosition = await Geolocator.getCurrentPosition();
      final result = await exerciseService.getExercises(
        currentUser.value,
        additionalParameters: {
          "user_address": await geocodingService.getAddress(
            lat: currentPosition.latitude,
            lng: currentPosition.longitude,
          ),
        },
      );
      exercises = result?.exercises ?? [];
      update(["exercises"]);
      print(currentUser.value);
    } on Error catch (e, st) {
      print("Generate: $e, $st");
    } finally {
      loading = false;
      update(["loading"]);
    }
  }

  Future<void> tweakWorkout(String instruction) async {
    if (loading) return;
    loading = true;
    update();

    try {
      final res = await exerciseService.getExercises(
        currentUser.value,
        count: exercises.length,
        additionalParameters: {"instruction": instruction},
      );

      exercises = res?.exercises ?? [];
    } catch (e) {
      showSnackbar(e.toString(), AnimatedSnackBarType.error);
    } finally {
      loading = false;
      update();
    }
  }

  void updateXp(ExerciseData exercise) async {
    final gained =
        8 + (exercise.reps ~/ 5) + (currentUser.value?.stats.streak ?? 0 ~/ 5);

    currentUser.value?.stats.addXp(gained);
    await userService.updateUser(currentUser.value!);
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
