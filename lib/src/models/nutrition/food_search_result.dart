import 'package:dart_mappable/dart_mappable.dart';

part 'food_search_result.mapper.dart';

@MappableClass()
class FoodSearchResult with FoodSearchResultMappable {
  final String fdcId;

  @MappableField(key: "description")
  final String name;

  @MappableField(key: "brandName")
  final String brand;

  @MappableField(key: "foodCategory")
  final String category;

  final String servingSizeUnit;
  final double servingSize;

  @MappableField(key: "foodNutrients")
  final List<NutrientData> nutrients;

  const FoodSearchResult({
    required this.fdcId,
    required this.name,
    required this.brand,
    required this.category,
    required this.servingSizeUnit,
    required this.servingSize,
    required this.nutrients,
  });

  factory FoodSearchResult.fromJson(String json) =>
      FoodSearchResultMapper.fromJson(json);

  factory FoodSearchResult.fromMap(Map<String, dynamic> map) =>
      FoodSearchResultMapper.fromMap(map);
}

@MappableClass()
class NutrientData with NutrientDataMappable {
  @MappableField(key: 'nutrientName')
  final String name;

  @MappableField(key: 'unitName')
  final String unit;

  @MappableField(key: 'value')
  final double value;

  const NutrientData({
    required this.name,
    required this.unit,
    required this.value,
  });
}
