import 'package:dart_mappable/dart_mappable.dart';

part 'exercise_data.mapper.dart';

@MappableEnum()
enum ExerciseDifficulty { easy, medium, hard }

@MappableClass()
class ExerciseData with ExerciseDataMappable {
  final ExerciseDifficulty difficulty;
  final double caloriesBurned;
  final String instructions;
  final List<String> targetMuscles;
  final String name;
  final int sets;
  final int reps;

  ExerciseData({
    required this.difficulty,
    required this.caloriesBurned,
    required this.name,
    required this.instructions,
    required this.targetMuscles,
    required this.sets,
    required this.reps,
  });

  factory ExerciseData.fromJson(String json) =>
      ExerciseDataMapper.fromJson(json);

  factory ExerciseData.fromMap(Map<String, dynamic> map) =>
      ExerciseDataMapper.fromMap(map);
}
