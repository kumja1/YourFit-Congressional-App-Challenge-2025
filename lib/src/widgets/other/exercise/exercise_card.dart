// lib/src/screens/tabs/exercise/widgets/exercise_card.dart
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
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
    final screenWidth = MediaQuery.maybeWidthOf(context);
    return AnimatedButton(
      shadowColor: Colors.black12,
      backgroundColor: Colors.white,
      width: screenWidth,
      height: 80,
      borderRadius: 10,
      onPressed: () => onStart(exercise),
      child: ListTile(
        title: Text(exercise.name, style: const TextStyle(color: Colors.blue)),
        titleAlignment: ListTileTitleAlignment.titleHeight,
        subtitle: Text(
          '${exercise.sets} x ${exercise.reps}  •  ${exercise.state.setsDone}/${exercise.sets} sets',
          style: TextStyle(color: Colors.grey[400]),
        ),
        iconColor: Colors.blue,
        // children: [Text(exercise.summary)],
      ).responsiveConstrains(maxWidth: 290, maxHeight: 80),
    ).paddingAll(10);
  }
}
