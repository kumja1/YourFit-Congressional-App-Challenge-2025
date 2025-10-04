import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:yourfit/src/utils/objects/mappable/map_hook.dart';
import 'package:yourfit/src/utils/objects/mappable/duration_mapper.dart';

part 'exercise_data.mapper.dart';

@MappableEnum()
enum ExerciseDifficulty {
  easy,
  medium,
  hard;

  factory ExerciseDifficulty.fromValue(String value) =>
      ExerciseDifficultyMapper.fromValue(value);
}

@MappableEnum()
enum ExerciseIntensity {
  low,
  medium,
  high;

  factory ExerciseIntensity.fromValue(String value) =>
      ExerciseIntensityMapper.fromValue(value);
}

@MappableEnum()
enum ExerciseType {
  strength,
  cardio,
  flexibility,
  balance;

  factory ExerciseType.fromValue(String value) =>
      ExerciseTypeMapper.fromValue(value);
}

@MappableClass(includeCustomMappers: [DurationMapper()])
class ExerciseData with ExerciseDataMappable {
  final ExerciseDifficulty difficulty;
  final ExerciseIntensity intensity;
  final ExerciseType type;
  final Duration durationPerSet;
  final double caloriesBurned;
  final String instructions;
  final String summary;

  @MappableField(hook: MapHook())
  final List<RestInterval> restIntervals;
  final List<String> equipment;
  final List<String> targetMuscles;
  final String name;
  final int sets;
  final int reps;
  final ExerciseState state;

  ExerciseData({
    required this.difficulty,
    required this.intensity,
    required this.type,
    required this.caloriesBurned,
    required this.name,
    required this.instructions,
    required this.summary,
    required this.sets,
    required this.reps,
    required this.durationPerSet,
    this.targetMuscles = const [],
    this.equipment = const [],
    this.restIntervals = const [],
  }) : state = ExerciseState(completed: false, setsDone: 0);

  factory ExerciseData.fromJson(String json) =>
      ExerciseDataMapper.fromJson(json);

  factory ExerciseData.fromMap(Map<String, dynamic> map) =>
      ExerciseDataMapper.fromMap(map);
}

@MappableClass(includeCustomMappers: [DurationMapper()])
class RestInterval with RestIntervalMappable {
  final Duration duration;
  final int restAt;
  RestInterval({required this.duration, required this.restAt});

  factory RestInterval.fromJson(String json) =>
      RestIntervalMapper.fromJson(json);

  factory RestInterval.fromMap(Map<String, dynamic> map) =>
      RestIntervalMapper.fromMap(map);
}

@MappableClass()
class ExerciseState with ExerciseStateMappable {
  bool completed;
  int setsDone;

  ExerciseState({required this.completed, required this.setsDone});

  factory ExerciseState.fromJson(String json) =>
      ExerciseStateMapper.fromJson(json);

  factory ExerciseState.fromMap(Map<String, dynamic> map) =>
      ExerciseStateMapper.fromMap(map);
}
