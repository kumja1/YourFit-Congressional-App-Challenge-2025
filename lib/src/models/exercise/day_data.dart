import 'package:dart_mappable/dart_mappable.dart';
import 'package:yourfit/src/models/exercise/exercise_data.dart';

part 'day_data.mapper.dart';

@MappableClass()
class DayData with DayDataMappable {
  final List<ExerciseData> exercises;
  final double caloriesBurned;

  DayData({required this.exercises, required this.caloriesBurned});

  factory DayData.fromJson(String json) =>
      DayDataMapper.fromJson(json);

  factory DayData.fromMap(Map<String, dynamic> map) =>
      DayDataMapper.fromMap(map);
}
