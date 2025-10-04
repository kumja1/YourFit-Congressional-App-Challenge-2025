import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:yourfit/src/models/exercise/exercise_data.dart';
import 'package:yourfit/src/utils/extensions/date_time_extensions.dart';

@RoutePage()
class BasicExerciseScreen extends StatelessWidget {
  final ExerciseData exercise;
  final VoidCallback onSetComplete;
  final VoidCallback onExerciseComplete;

  const BasicExerciseScreen({
    super.key,
    required this.exercise,
    required this.onSetComplete,
    required this.onExerciseComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<_BasicExerciseScreenController>(
          init: _BasicExerciseScreenController(exercise, onExerciseComplete, onSetComplete),
          builder: (controller) => StepProgressIndicator(
            totalSteps: exercise.sets,
            currentStep: controller.setsDone,
            size: 5,
            unselectedColor: Colors.black12,
            selectedColor: Colors.blue,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: TimerCountdown(
            endTime: exercise.durationPerSet.toDateTime(),
            format: CountDownTimerFormat.minutesSeconds,
            timeTextStyle: const TextStyle(color: Colors.blue),
            colonsTextStyle: const TextStyle(color: Colors.blue),
          ),
        ),
        Row(children: []),
      ],
    );
  }
}

class _BasicExerciseScreenController extends GetxController {
  late int setsDone;
  late Timer timer;
  final ExerciseData exercise;
  final VoidCallback onSetComplete;
  final VoidCallback onExerciseComplete;

  _BasicExerciseScreenController(
    this.exercise,
    this.onExerciseComplete,
    this.onSetComplete,
  ) {
    setsDone = exercise.state.setsDone;
    timer = Timer.periodic(exercise.durationPerSet, (timer) {
      if (setsDone >= exercise.sets) {
        completeExercise();
        return;
      }

      completeSet();
    });
  }

  void completeExercise() {
    exercise.state.completed = true;
    timer.cancel();

    onExerciseComplete();
  }

  void completeSet() {
    setsDone++;
    exercise.state.setsDone = setsDone;
    onSetComplete();
    update();
  }

  @override
  void onClose() {
    timer.cancel();
  }
}
