import 'package:dart_mappable/dart_mappable.dart';
import 'package:extensions_plus/extensions_plus.dart';

part 'meal_data.mapper.dart';

@MappableEnum()
enum MealType {
  breakfast,
  lunch,
  dinner,
  snacks;

  String get label => name.toTitleCase();
}

@MappableClass()
class MealData with MealDataMappable {
  final String name;
  final String brand;
  final double kcal;
  final double grams;

  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final double sugarG;
  final double sodiumMg;

  final MealType type;
  final DateTime time;

 const MealData({
    required this.name,
    required this.kcal,
    required this.grams,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    required this.sugarG,
    required this.sodiumMg,
    required this.time,
    required this.type,
    this.brand = '',
  });

  factory MealData.fromJson(String json) => MealDataMapper.fromJson(json);

  factory MealData.fromMap(Map<String, dynamic> map) =>
      MealDataMapper.fromMap(map);
}