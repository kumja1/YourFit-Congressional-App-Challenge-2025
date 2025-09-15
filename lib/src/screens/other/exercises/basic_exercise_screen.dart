import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:yourfit/src/models/exercise/exercise_data.dart';
import 'package:yourfit/src/utils/extensions/date_time_extensions.dart';

class BasicExerciseScreen extends StatelessWidget {
  final ExerciseData exercise;

  const BasicExerciseScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<_BasicExerciseScreenController>(
          init: _BasicExerciseScreenController(exercise),
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

  _BasicExerciseScreenController(this.exercise) {
    setsDone = exercise.state.setsDone;
    timer = Timer.periodic(exercise.durationPerSet, (timer) {
      if (setsDone >= exercise.sets) {
        handleExerciseCompleted();
        return;
      }

      handleSetCompleted();
    });
  }

  void handleExerciseCompleted() {
    exercise.state.completed = true;

    timer.cancel();
  }

  void handleSetCompleted() {
    setsDone++;
    exercise.state.setsDone = setsDone;
    update();
  }

  @override
  void onClose() {
    timer.cancel();
  }
}
