import 'package:flutter/material.dart';

class ProgressBanner extends StatelessWidget {
  final int level;
  final int xp;
  final int nextLevelXp;
  const ProgressBanner({
    super.key,
    required this.level,
    required this.xp,
    required this.nextLevelXp,
  });

  @override
  Widget build(BuildContext context) {
    final progress = xp / nextLevelXp;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Level $level',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(value: progress.clamp(0.0, 1.0)),
          const SizedBox(height: 6),
          Text('$xp / $nextLevelXp XP'),
        ],
      ),
    );
  }
}
