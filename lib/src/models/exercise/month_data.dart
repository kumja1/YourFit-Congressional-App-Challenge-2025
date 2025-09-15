import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:yourfit/src/utils/objects/mappable/hooks/map_hook.dart';

import 'day_data.dart';

part 'month_data.mapper.dart';

@MappableClass()
class MonthData with MonthDataMappable {

  @MappableField(hook: MapHook())
  final Map<int, DayData> days;

  double get caloriesBurned =>
      days.values.sum((day) => day.caloriesBurned).toDouble();

  MonthData({required this.days});

  factory MonthData.fromJson(String json) => MonthDataMapper.fromJson(json);

  factory MonthData.fromMap(Map<String, dynamic> map) =>
      MonthDataMapper.fromMap(map);
}
