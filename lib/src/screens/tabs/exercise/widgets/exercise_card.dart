import 'package:flutter/material.dart';
import '../models/exercise_models.dart';

class ExerciseCard extends StatelessWidget {
  final ExerciseItem exercise;
  final ExecProgress progress;
  final bool isDone;
  final VoidCallback onStart;
  final VoidCallback onYoutube;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.progress,
    required this.isDone,
    required this.onStart,
    required this.onYoutube,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(exercise.name),
        subtitle: Text(
          '${exercise.qty}  •  ${progress.done}/${progress.total} sets',
        ),
        trailing: Wrap(
          spacing: 6,
          children: [
            IconButton(
              icon: const Icon(Icons.ondemand_video),
              tooltip: 'YouTube tutorial',
              onPressed: onYoutube,
            ),
            FilledButton(
              onPressed: onStart,
              child: Text(isDone ? 'Done' : 'Start'),
            ),
          ],
        ),
      ),
    );
  }
}
