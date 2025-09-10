// lib/src/screens/tabs/roadmap/models/workout_type.dart
import 'package:flutter/material.dart';

enum WorkoutType {
  legDay('Leg Day', Colors.blue, Icons.directions_walk, 'LEG'),
  upperBody('Upper Body', Colors.green, Icons.fitness_center, 'UP'),
  cardio('Cardio', Colors.orange, Icons.directions_run, 'CRD'),
  core('Core', Colors.purple, Icons.self_improvement, 'CORE'),
  fullBody('Full Body', Colors.red, Icons.accessibility_new, 'FB'),
  rest('Rest Day', Colors.grey, Icons.hotel, 'REST'),
  yoga('Yoga/Stretch', Colors.teal, Icons.spa, 'YOG');

  final String label;
  final Color color;
  final IconData icon;
  final String abbrev;
  const WorkoutType(this.label, this.color, this.icon, this.abbrev);
}
