import 'package:dart_mappable/dart_mappable.dart';

part 'monthly_water_data.mapper.dart';

@MappableClass()
class MonthlyWaterData with MonthlyWaterDataMappable {
  factory MonthlyWaterData.fromJson(String json) =>
      MonthlyWaterDataMapper.fromJson(json);

  factory MonthlyWaterData.fromMap(Map<String, dynamic> map) =>
      MonthlyWaterDataMapper.fromMap(map);
}
