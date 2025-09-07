import 'package:dart_mappable/dart_mappable.dart';
import 'package:yourfit/src/models/month_data.dart';

part 'user_data.mapper.dart';

@MappableEnum()
enum UserGender { male, female }

@MappableEnum()
enum UserPhysicalFitness {
  minimal("Minimal"),
  light("Light"),
  moderate("Moderate"),
  extreme("Extreme");

  const UserPhysicalFitness(this.level);
  final String level;

  @override
  String toString() => level;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class UserData with UserDataMappable {
  late final String id;

  late final DateTime createdAt;

  final String firstName;

  final String lastName;

  final UserGender gender;

  final int age;

  final DateTime dob;

  final double height;

  final double weight;

  final double totalCaloriesBurned;

  final double milesTraveled;

  final UserPhysicalFitness physicalFitness;

  final Map<DateTime, MonthData> exerciseData;

  final List<String> disabilities;

  final List<String> equipment;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.age,
    required this.height,
    required this.weight,
    required this.physicalFitness,
    this.totalCaloriesBurned = 0,
    this.milesTraveled = 0,
    this.exerciseData = const {},
    this.disabilities = const [],
    this.equipment = const [],
  });

  factory UserData.fromJson(String json) => UserDataMapper.fromJson(json);

  factory UserData.fromMap(Map<String, dynamic> map) =>
      UserDataMapper.fromMap(map);
}
