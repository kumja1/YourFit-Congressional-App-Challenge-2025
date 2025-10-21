// lib/src/screens/tabs/exercise/workouts_screen.dart
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langchain/langchain.dart';
import 'package:yourfit/src/models/exercise/running_exercise_data.dart';
import 'package:yourfit/src/models/index.dart';
import 'package:yourfit/src/routing/router.gr.dart';
import 'package:yourfit/src/services/device_service.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/utils/objects/other/exercise/parameter.dart';
import 'package:yourfit/src/widgets/other/exercise/index.dart';

@RoutePage()
class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_ExerciseScreenController());
    return Scaffold(
      floatingActionButton: GetBuilder<_ExerciseScreenController>(
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
                      child: Obx(
                        () => CompactHeader(
                          level: controller.currentStats?.level ?? 1,
                          xp: controller.currentStats?.xp ?? 0,
                          xpToNext: controller.currentStats?.xpToNext ?? 0,
                          streak: controller.currentStats?.streak ?? 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TODAY'S FOCUS",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                          GetBuilder<_ExerciseScreenController>(
                            builder: (controller) =>
                                controller.workout?.focus == null
                                ? const SizedBox.shrink()
                                : Text(
                                    controller.workout!.focus.label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
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
                    loading: controller.loading,
                    explanation: "",
                    onTweak: controller.modifyWorkout,
                  ),
                ),
              ),

              controller.loading
                  ? const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                      sliver: SliverList.builder(
                        itemCount: controller.workout?.exercises.length ?? 0,
                        itemBuilder: (_, i) {
                          final exercise = controller.workout?.exercises[i];
                          return exercise == null
                              ? const SizedBox.shrink()
                              : ExerciseCard(
                                  exercise: exercise,
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
                                );
                        },
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
  final UserService userService = Get.find();
  final ExerciseService exerciseService = Get.find();
  final DeviceService deviceService = Get.find();
  final Rx<UserData?> currentUser = Get.find<AuthService>().currentUser;
  UserStats? get currentStats => currentUser.value?.stats;

  // ---- Screen State ----
  bool loading = false;
  WorkoutData? workout;

  @override
  void onReady() {
    /**
      final now = DateTime.now();
      final timestamp =
          deviceService.getDevicePreference<DateTime>(
            "last_generation",
            converter: (v) => DateTime.tryParse(v),
          ) ??
          now;
  
      if (now.difference(timestamp).inDays < 1) {
        return;
      }
  
      deviceService.setDevicePreference(
        "last_generation",
        now,
        converter: (d) => d.toIso8601String(),
      );
  */
  }

  Future<void> generate() async {
    
     if (loading) return;
     loading = true;
     update(["loading"]);
     try {
       final result = await exerciseService.getExercises(
         currentUser.value,
         difficulty: currentUser.value?.exercisesDifficulty,
         intensity: currentUser.value?.exercisesIntensity,
         focus: WorkoutFocus.cardio,
       );
 
       if (result == null) return;
       workout = result;
       update();
       Get.log(currentUser.value?.toJson() ?? "User null");
     } catch (e) {
       e.printError();
     } finally {
       loading = false;
       update(["loading"]);
     }
  
  }

  Future<void> modifyWorkout(String instruction) async {
    if (loading || workout == null) return;
    loading = true;
    update();

    try {
      /**
        final res = await exerciseService.getExercises(
          currentUser.value,
          prompt: instruction,
          additionalParams: {
            "current_workout": Parameter(
              description: "The workout to modify",
              value: workout?.toJson(),
            ),
          },
          count: workout!.exercises.length,
        );
  
        workout = res;
    */
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
