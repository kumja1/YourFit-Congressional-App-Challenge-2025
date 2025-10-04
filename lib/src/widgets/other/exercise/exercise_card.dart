// lib/src/screens/tabs/exercise/widgets/exercise_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/models/exercise/exercise_data.dart';
import 'package:yourfit/src/widgets/buttons/animated_button.dart';

class ExerciseCard extends StatelessWidget {
  final ExerciseData exercise;
  final Function(ExerciseData) onStart;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_ExerciseCardController());
    return AnimatedButton(
      shadowColor: Colors.amber,
      backgroundColor: Colors.amberAccent,
      width: 300,
      height: 50,
      borderRadius: 10,
      onPressed: () => onStart(exercise),
      child: ExpansionTile(
        onExpansionChanged: (v) => controller.toggleExpanded(),
        title: Text(exercise.name),
        subtitle: Text(
          '${exercise.sets} x ${exercise.reps}  •  ${exercise.state.setsDone}/${exercise.sets} sets',
        ),
        trailing: Wrap(
          spacing: 6,
          children: [
            IconButton(
              icon: const Icon(Icons.ondemand_video),
              tooltip: 'YouTube tutorial',
              onPressed: () {},
            ),
            FilledButton(
              onPressed: () {},
              child: Text(exercise.state.completed ? 'Done' : 'Start'),
            ),
          ],
        ),
        children: [Text(exercise.summary)],
      ),
    );
  }
}

class _ExerciseCardController extends GetxController {
  bool expanded = false;

  void toggleExpanded() {
    expanded = !expanded;
    update();
  }
}
