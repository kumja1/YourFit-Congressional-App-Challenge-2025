import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:yourfit/src/models/exercise/exercise_data.dart';

part 'workout_data.mapper.dart';

@MappableEnum()
enum WorkoutType {
  leg('Leg Day', Colors.blue, Icons.directions_walk, 'LEG'),
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

@MappableClass()
class WorkoutData with WorkoutDataMappable {
  final List<ExerciseData> exercises;
  final double caloriesBurned;
  final WorkoutType type;
  final String summary;

  WorkoutData({
    required this.exercises,
    required this.type,
    required this.caloriesBurned,
    required this.summary,
  });

  factory WorkoutData.fromJson(String json) => WorkoutDataMapper.fromJson(json);

  factory WorkoutData.fromMap(Map<String, dynamic> map) =>
      WorkoutDataMapper.fromMap(map);
}
