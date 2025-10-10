import 'package:auto_route/auto_route.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide WidgetPaddingX;
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:yourfit/src/models/exercise/exercise_data.dart';

@RoutePage()
class BasicExerciseScreen extends StatelessWidget {
  final ExerciseData exercise;
  final VoidCallback onSetComplete;
  final VoidCallback onExerciseComplete;

  final _tag = UniqueKey().toString();

  BasicExerciseScreen({
    super.key,
    required this.exercise,
    required this.onSetComplete,
    required this.onExerciseComplete,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      _BasicExerciseScreenController(
        exercise,
        onExerciseComplete,
        onSetComplete,
      ),
      tag: _tag,
    );
    return Scaffold(
      body: Column(
        children: [
          GetBuilder<_BasicExerciseScreenController>(
            tag: _tag,
            builder: (controller) => StepProgressIndicator(
              size: 10,
              totalSteps: controller.exercise.sets,
              padding: 0,
              currentStep: controller.exercise.state.setsDone,
              roundedEdges: const Radius.circular(10),
              crossAxisAlignment: CrossAxisAlignment.start,
              unselectedColor: Colors.grey[200]!,
              selectedColor: Colors.blue,
              progressDirection: TextDirection.ltr,
            ).paddingOnly(left: 30, right: 30, top: 20),
          ),
          Align(
            alignment: Alignment.center,
            child: CircularCountDownTimer(
              duration: controller.exercise.duration.inSeconds,
              autoStart: true,
              controller: controller.countdownController,
              isReverse: true,
              isReverseAnimation: true,
              isTimerTextShown: true,
              textFormat: CountdownTextFormat.MM_SS,
              onComplete: controller.completeSet,
              ringColor: Colors.grey[200]!,
              fillColor: Colors.blue,
              backgroundColor: Colors.transparent,
              strokeWidth: 12.0,
              strokeCap: StrokeCap.round,
              textStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              width: 90,
              height: 90,
            ),
          ).flexible(),
        ],
      ),
    );
  }
}

class _BasicExerciseScreenController extends GetxController {
  final ExerciseData exercise;
  final VoidCallback onSetComplete;
  final VoidCallback onExerciseComplete;
  final CountDownController countdownController = CountDownController();

  _BasicExerciseScreenController(
    this.exercise,
    this.onExerciseComplete,
    this.onSetComplete,
  );

  void completeExercise() {
    exercise.state.completed = true;
    onExerciseComplete();
  }

  void completeSet() {
    if (exercise.state.setsDone++ >= exercise.sets) {
      completeExercise();
      return;
    }
    update();
    onSetComplete();
    countdownController.restart();
  }
}
