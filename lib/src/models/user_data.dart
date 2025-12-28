import 'package:dart_mappable/dart_mappable.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:yourfit/src/models/exercise/workout_data.dart';
import 'package:yourfit/src/models/exercise/exercise_data.dart';
import 'package:yourfit/src/models/exercise/monthly_workout_data.dart';
import 'package:yourfit/src/models/nutrition/monthly_water_data.dart';

part 'user_data.mapper.dart';

@MappableEnum()
enum UserGender {
  male,
  female;

  factory UserGender.fromValue(String value) =>
      UserGenderMapper.fromValue(value);
}

@MappableEnum()
enum UserPhysicalFitness {
  minimal,
  light,
  moderate,
  extreme;

  factory UserPhysicalFitness.fromValue(String value) =>
      UserPhysicalFitnessMapper.fromValue(value);
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class UserData with UserDataMappable {
  final String id;

  final DateTime createdAt;

  final Map<String, MonthlyWorkoutData> workoutData;

  final Map<String, MonthlyWaterData> waterData;

  final UserStats stats;

  String get fullName => "$firstName $lastName";

  String get intials => fullName.initials;

  int get age => dob.age;

  double get bmi =>
      (weight * 0.45359237) / ((height / 100.0) * (height / 100.0));

  String firstName;

  String lastName;

  UserGender gender;

  DateTime dob;

  /// Height in cm
  double height;

  /// Weight in lbs
  double weight;

  UserPhysicalFitness physicalFitness;

  String goal;

  int exerciseDaysPerWeek;

  ExerciseDifficulty exercisesDifficulty;

  ExerciseIntensity exercisesIntensity;

  List<String> disabilities;
  List<String> equipment;

  UserData({
    required this.id,
    required this.createdAt,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.height,
    required this.weight,
    required this.physicalFitness,
    required this.stats,
    this.goal = "",
    this.exerciseDaysPerWeek = 3,
    this.exercisesIntensity = ExerciseIntensity.low,
    this.exercisesDifficulty = ExerciseDifficulty.easy,
    this.workoutData = const {},
    this.waterData = const {},
    this.disabilities = const [],
    this.equipment = const [],
  });

  void addWorkoutData(WorkoutData workoutData) {
    final now = DateTime.now();
    final monthData = getMonthlyWorkout(now);
    monthData.workouts[now.day.toString()] = workoutData;
  }

  WorkoutData? getWorkoutData(DateTime date) {
    final monthData = getMonthlyWorkout(date);
    return monthData.workouts[date.day.toString()];
  }

  MonthlyWorkoutData getMonthlyWorkout(DateTime date) =>
      workoutData["${date.year}.${date.month}"] ??= MonthlyWorkoutData(workouts: {});

  factory UserData.fromJson(String json) => UserDataMapper.fromJson(json);

  factory UserData.fromMap(Map<String, dynamic> map) =>
      UserDataMapper.fromMap(map);
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class UserStats with UserStatsMappable {
  double totalCaloriesBurned;
  double milesTraveled;

  int level;
  int xp;
  int xpToNext;
  int streak;

  UserStats({
    this.milesTraveled = 0,
    this.totalCaloriesBurned = 0,
    this.xp = 0,
    this.xpToNext = 120,
    this.level = 1,
    this.streak = 0,
  });

  void addXp(int amount) {
    xp += amount;
    while (xp >= xpToNext) {
      xp -= xpToNext;
      level += 1;
      xpToNext = _calcNextLevelXp(level);
    }
  }

  int _calcNextLevelXp(int lvl) =>
      (xpToNext + (lvl - 1) * 40).clamp(xpToNext, 999999);

  factory UserStats.fromJson(String json) => UserStatsMapper.fromJson(json);

  factory UserStats.fromMap(Map<String, dynamic> map) =>
      UserStatsMapper.fromMap(map);
}
