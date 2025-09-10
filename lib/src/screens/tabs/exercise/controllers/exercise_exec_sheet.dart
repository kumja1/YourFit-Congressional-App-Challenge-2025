import 'package:flutter/material.dart';

class ExerciseExecSheet extends StatelessWidget {
  const ExerciseExecSheet({
    super.key,
    required this.name,
    required this.qty,
    required this.completedSets,
    required this.totalSets,
    required this.onCompleteSet,
    required this.onMarkDone,
  });

  final String name;
  final String qty;
  final int completedSets;
  final int totalSets;
  final VoidCallback onCompleteSet;
  final VoidCallback onMarkDone;

  @override
  Widget build(BuildContext context) {
    final remaining = (totalSets - completedSets).clamp(0, totalSets);
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
          Text(name,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(qty, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 12),
          Text(
            'Sets: $completedSets / $totalSets',
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
