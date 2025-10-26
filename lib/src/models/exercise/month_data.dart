import 'package:dart_mappable/dart_mappable.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'workout_data.dart';

part 'month_data.mapper.dart';

@MappableClass()
class MonthData with MonthDataMappable {
  final Map<String, WorkoutData> workouts;

  double get caloriesBurned =>
      workouts.values.sum((workout) => workout.caloriesBurned).toDouble();

  MonthData({required this.workouts});

  factory MonthData.fromJson(String json) => MonthDataMapper.fromJson(json);
  factory MonthData.fromMap(Map<String, dynamic> map) =>
      MonthDataMapper.fromMap(map);
}
