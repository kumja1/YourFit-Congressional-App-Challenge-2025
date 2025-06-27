import 'package:dart_mappable/dart_mappable.dart';
import 'package:yourfit/src/models/exercise_data.dart';
import 'package:yourfit/src/models/month_data.dart';

part 'user_data.mapper.dart';

@MappableClass()
class UserData with UserDataMappable {
  late final String id;

  late final DateTime createdAt;

  late String firstName;

  late String lastName;

  late int age;

  late double height;

  late double weight;

  late double caloriesBurned;

  late double milesTraveled;

  late Map<String, MonthData> monthData;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.height,
    required this.weight,
    required this.caloriesBurned,
    required this.milesTraveled,
    required this.monthData,
  });

  static UserData fromMap(Map<String, dynamic> map) =>
      UserDataMapper.fromMap(map);
}
