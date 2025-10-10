import 'package:dart_mappable/dart_mappable.dart';
import 'package:yourfit/src/models/exercise/index.dart';
import 'package:yourfit/src/utils/objects/mappable/hooks/map_hook.dart';
part 'running_exercise_data.mapper.dart';

@MappableClass(discriminatorKey: "running")
class RunningExerciseData extends ExerciseData
    with RunningExerciseDataMappable {
  final double distance;
  final int speed;
  final String destination;

  RunningExerciseData({
    required super.difficulty,
    required super.intensity,
    required super.type,
    required super.caloriesBurned,
    required super.name,
    required super.instructions,
    required super.summary,
    required super.sets,
    required super.reps,
    required super.duration,
    super.targetMuscles,
    super.equipment,
    super.restIntervals,
    required this.destination,
    required this.distance,
    required this.speed,
  });

  factory RunningExerciseData.fromMap(Map<String, dynamic> map) =>
      RunningExerciseDataMapper.fromMap(map);

  factory RunningExerciseData.fromJson(String json) =>
      RunningExerciseDataMapper.fromJson(json);
}
