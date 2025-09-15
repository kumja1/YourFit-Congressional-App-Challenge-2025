import 'package:dart_mappable/dart_mappable.dart';
import 'package:yourfit/src/models/exercise/month_data.dart';

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

@MappableClass(caseStyle: CaseStyle.snakeCase)
class UserData with UserDataMappable {
  late final String id;

  late final DateTime createdAt;

  late String firstName;

  late String lastName;

  late UserGender gender;

  late int age;

  late DateTime dob;

  late double height;

  late double weight;

  late double totalCaloriesBurned;

  late double milesTraveled;

  late UserPhysicalActivity physicalActivity;

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
    required this.physicalActivity,
    required this.exerciseData,
  });

  factory UserData.fromJson(String json) => UserDataMapper.fromJson(json);

  factory UserData.fromMap(Map<String, dynamic> map) =>
      UserDataMapper.fromMap(map);
}
