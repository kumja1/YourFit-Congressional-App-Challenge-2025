import 'package:dart_mappable/dart_mappable.dart';
import 'package:yourfit/src/models/exercise_data.dart';

part 'month_data.mapper.dart';

@MappableClass()
class MonthData with MonthDataMappable {
  final Map<String, ExerciseData> exercises;
  final double totalCaloriesBurned;

  MonthData({required this.exercises, required this.totalCaloriesBurned});
}
