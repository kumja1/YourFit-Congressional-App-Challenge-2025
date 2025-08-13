import 'package:dart_mappable/dart_mappable.dart';
import 'package:yourfit/src/models/month_data.dart';

part 'user_data.mapper.dart';

@MappableEnum()
enum UserGender { male, female }

@MappableEnum()
enum UserPhysicalActivity {
  minimal("Minimal"),
  light("Light"),
  moderate("Moderate"),
  intense("Intense");

  const UserPhysicalActivity(this.level);
  final String level;

  @override
  String toString() => level;
}

@MappableClass()
class UserData with UserDataMappable {
  late final String id;

  late final DateTime createdAt;

  late String firstName;

  late String lastName;

  late UserGender gender;

  late int age;

  late DateTime dob;

  late int height;

  late double weight;

  late double totalCaloriesBurned;

  late double milesTraveled;

  late UserPhysicalActivity activityLevel;

  late Map<DateTime, MonthData> exerciseData;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.age,
    required this.height,
    required this.weight,
    required this.totalCaloriesBurned,
    required this.milesTraveled,
    required this.activityLevel,
    required this.exerciseData,
  });

  static UserData fromMap(Map<String, dynamic> map) =>
      UserDataMapper.fromMap(map);
}
