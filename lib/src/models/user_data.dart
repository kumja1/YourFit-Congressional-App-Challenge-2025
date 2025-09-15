import 'package:dart_mappable/dart_mappable.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:yourfit/src/models/exercise/day_data.dart';
import 'package:yourfit/src/models/exercise/month_data.dart';

part 'user_data.mapper.dart';

@MappableEnum()
enum UserGender {
  male,
  female;

  factory UserGender.fromValue(String value) =>
      UserGenderMapper.fromValue(value);
}

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

  factory UserPhysicalFitness.fromValue(String value) =>
      UserPhysicalFitnessMapper.fromValue(value);
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class UserData with UserDataMappable {
  late final String id;

  late final DateTime createdAt;

  final String firstName;

  final String lastName;

  final String fullName;

  final UserGender gender;

  final DateTime dob;

  final int age;

  final double height;

  final double weight;

  final double totalCaloriesBurned;

  final double milesTraveled;

  final UserPhysicalFitness physicalFitness;

  final Map<String, MonthData> exerciseData;

  final List<String> disabilities;

  final List<String> equipment;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.height,
    required this.weight,
    required this.physicalFitness,
    this.totalCaloriesBurned = 0,
    this.milesTraveled = 0,
    this.exerciseData = const {},
    this.disabilities = const [],
    this.equipment = const [],
  }) : fullName = '$firstName $lastName',
       age = dob.age;
  
  void addExerciseData(DayData dayData) {
    final now = DateTime.now();
    final monthData = getMonthData(now);
    monthData.days[now.day] ??= dayData;
  }
  
  /// Returns the exercise data for a day
  DayData getExerciseData(DateTime date) {
    final monthData = getMonthData(date);
    return monthData.days[date.day]!;
  }

  MonthData getMonthData(DateTime date) =>
      exerciseData["${date.year}.${date.month}"] ??= MonthData(days: {});

  @override
  String toString() => fullName;

  factory UserData.fromJson(String json) => UserDataMapper.fromJson(json);

  factory UserData.fromMap(Map<String, dynamic> map) =>
      UserDataMapper.fromMap(map);
}
