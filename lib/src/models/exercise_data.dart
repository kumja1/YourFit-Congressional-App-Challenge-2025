import 'package:dart_mappable/dart_mappable.dart';

part 'exercise_data.mapper.dart';

@MappableClass()
class ExerciseData with ExerciseDataMappable {
  final bool isCompleted;
  final Duration timeLeft;
  final int intensity;
  final double caloriesBurned;
  final String name;

  ExerciseData({
    required this.timeLeft,
    required this.intensity,
    required this.caloriesBurned,
    required this.name,
    required this.isCompleted,
  });
}
