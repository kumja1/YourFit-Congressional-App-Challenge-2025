import 'package:dart_mappable/dart_mappable.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:yourfit/src/models/exercise_data.dart';

import 'day_data.dart';

part 'month_data.mapper.dart';

@MappableClass()
class MonthData with MonthDataMappable {
  final Map<int, DayData> days;

  double get caloriesBurned =>
      days.values.sum((day) => day.caloriesBurned).toDouble();

  MonthData({required this.days});
}
