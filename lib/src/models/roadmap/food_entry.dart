// lib/src/screens/tabs/roadmap/models/food_entry.dart

enum MealType {
  breakfast,
  lunch,
  dinner,
  snacks;

  String get label => switch (this) {
    MealType.breakfast => 'Breakfast',
    MealType.lunch => 'Lunch',
    MealType.dinner => 'Dinner',
    MealType.snacks => 'Snacks',
  };
}

class FoodEntry {
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

  final MealType meal;
  final DateTime time;

  FoodEntry({
    required this.name,
    this.brand = '',
    required this.kcal,
    required this.grams,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    required this.sugarG,
    required this.sodiumMg,
    required this.meal,
    required this.time,
  });

  FoodEntry copyWith({
    String? name,
    String? brand,
    double? kcal,
    double? grams,
    double? proteinG,
    double? carbsG,
    double? fatG,
    double? fiberG,
    double? sugarG,
    double? sodiumMg,
    MealType? meal,
    DateTime? time,
  }) {
    return FoodEntry(
      name: name ?? this.name,
      brand: brand ?? this.brand,
      kcal: kcal ?? this.kcal,
      grams: grams ?? this.grams,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      fiberG: fiberG ?? this.fiberG,
      sugarG: sugarG ?? this.sugarG,
      sodiumMg: sodiumMg ?? this.sodiumMg,
      meal: meal ?? this.meal,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "brand": brand,
    "kcal": kcal,
    "grams": grams,
    "proteinG": proteinG,
    "carbsG": carbsG,
    "fatG": fatG,
    "fiberG": fiberG,
    "sugarG": sugarG,
    "sodiumMg": sodiumMg,
    "meal": meal.name,
    "time": time.toIso8601String(),
  };

  factory FoodEntry.fromJson(Map<String, dynamic> j) => FoodEntry(
    name: j["name"]?.toString() ?? "",
    brand: j["brand"]?.toString() ?? "",
    kcal: (j["kcal"] as num?)?.toDouble() ?? 0,
    grams: (j["grams"] as num?)?.toDouble() ?? 0,
    proteinG: (j["proteinG"] as num?)?.toDouble() ?? 0,
    carbsG: (j["carbsG"] as num?)?.toDouble() ?? 0,
    fatG: (j["fatG"] as num?)?.toDouble() ?? 0,
    fiberG: (j["fiberG"] as num?)?.toDouble() ?? 0,
    sugarG: (j["sugarG"] as num?)?.toDouble() ?? 0,
    sodiumMg: (j["sodiumMg"] as num?)?.toDouble() ?? 0,
    meal: _parseMeal(j["meal"]),
    time: DateTime.tryParse(j["time"]?.toString() ?? "") ?? DateTime.now(),
  );

  static MealType _parseMeal(dynamic v) {
    final s = v?.toString().toLowerCase() ?? '';
    switch (s) {
      case 'breakfast':
        return MealType.breakfast;
      case 'lunch':
        return MealType.lunch;
      case 'dinner':
        return MealType.dinner;
      case 'snacks':
        return MealType.snacks;
      default:
        return MealType.lunch;
    }
  }
}

// Used for recents: nutrition per 100g
class FoodPer100 {
  final String name;
  final String brand;
  final double kcal100;
  final double protein100;
  final double carbs100;
  final double fat100;
  final double fiber100;
  final double sugar100;
  final double sodium100; // mg per 100g

  FoodPer100({
    required this.name,
    required this.brand,
    required this.kcal100,
    required this.protein100,
    required this.carbs100,
    required this.fat100,
    required this.fiber100,
    required this.sugar100,
    required this.sodium100,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "brand": brand,
    "kcal100": kcal100,
    "protein100": protein100,
    "carbs100": carbs100,
    "fat100": fat100,
    "fiber100": fiber100,
    "sugar100": sugar100,
    "sodium100": sodium100,
  };

  factory FoodPer100.fromJson(Map<String, dynamic> j) => FoodPer100(
    name: j["name"]?.toString() ?? "",
    brand: j["brand"]?.toString() ?? "",
    kcal100: (j["kcal100"] as num?)?.toDouble() ?? 0,
    protein100: (j["protein100"] as num?)?.toDouble() ?? 0,
    carbs100: (j["carbs100"] as num?)?.toDouble() ?? 0,
    fat100: (j["fat100"] as num?)?.toDouble() ?? 0,
    fiber100: (j["fiber100"] as num?)?.toDouble() ?? 0,
    sugar100: (j["sugar100"] as num?)?.toDouble() ?? 0,
    sodium100: (j["sodium100"] as num?)?.toDouble() ?? 0,
  );
}
