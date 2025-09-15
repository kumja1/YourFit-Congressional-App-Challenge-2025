import 'package:flutter/material.dart';
import 'package:yourfit/src/models/exercise/exercise_data.dart';

class ExerciseExecSheet extends StatelessWidget {
  const ExerciseExecSheet({
    super.key,
    required this.exercise,
    required this.onCompleteSet,
    required this.onMarkDone,
  });
final ExerciseData exercise;
  final VoidCallback onCompleteSet;
  final VoidCallback onMarkDone;

  @override
  Widget build(BuildContext context) {
    final remaining = (exercise.sets - exercise.state.setsDone).clamp(0, exercise.sets);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(exercise.name,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text("${exercise.sets} x ${exercise.reps}", style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 12),
          Text(
            'Sets: ${exercise.state.setsDone} / ${exercise.sets}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: remaining <= 0
                      ? null
                      : () {
                          onCompleteSet();
                          if (remaining - 1 <= 0) {
                            Navigator.of(context).pop();
                          }
                        },
                  child: Text(remaining > 1 ? 'Complete Set' : 'Finish'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {
                  onMarkDone();
                  Navigator.of(context).pop();
                },
                child: const Text('Mark Done'),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
