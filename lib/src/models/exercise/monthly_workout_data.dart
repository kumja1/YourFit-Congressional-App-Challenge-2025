import 'package:dart_mappable/dart_mappable.dart';
import 'package:extensions_plus/extensions_plus.dart';

import 'workout_data.dart';

part 'monthly_workout_data.mapper.dart';

@MappableClass()
class MonthlyWorkoutData with MonthlyWorkoutDataMappable {
  final Map<String, WorkoutData> workouts;

  double get caloriesBurned =>
      workouts.values.sum((workout) => workout.caloriesBurned).toDouble();

  MonthlyWorkoutData({required this.workouts});

  factory MonthlyWorkoutData.fromJson(String json) =>
      MonthlyWorkoutDataMapper.fromJson(json);

  factory MonthlyWorkoutData.fromMap(Map<String, dynamic> map) =>
      MonthlyWorkoutDataMapper.fromMap(map);
}
