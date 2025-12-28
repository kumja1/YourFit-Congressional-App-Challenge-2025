// NutritionSummarySliver(controller: s),
// QuickAddRowSliver(controller: s),
// GetBuilder<RoadmapController>(
// builder: (controller) => FoodSearchSliver(
// controller: controller.searchController,
// onSubmitted: (query) async {
// await controller.searchFood(query);
// },
// loading: controller.loadingSearch,
// ),
// ),
// FoodResultsSliver(controller: s),
// FoodEntriesSliver(controller: s),
//  Future<void> searchFood(String? query) async {
//       if (query == null || query.isEmpty) return;
//
//       loadingSearch = true;
//       searchResults = [];
//       update();
//
//       try {
//         // Search multiple data types for better results
//         final branded = await _searchUSDA(query, 'Branded');
//         final foundation = await _searchUSDA(query, 'Foundation,SR Legacy');
//
//         final combined = <FoodSearchResult>[...branded, ...foundation];
//
//         // Sort by relevance
//         final queryLower = query.toLowerCase();
//         combined.sort((a, b) {
//           final aName = a.name.toLowerCase();
//           final bName = b.name.toLowerCase();
//
//           // Exact matches first
//           if (aName == queryLower) return -1;
//           if (bName == queryLower) return 1;
//
//           // Starts with query
//           final aStarts = aName.startsWith(queryLower) ? 0 : 1;
//           final bStarts = bName.startsWith(queryLower) ? 0 : 1;
//           if (aStarts != bStarts) return aStarts - bStarts;
//
//           // Contains query earlier
//           final aIndex = aName.indexOf(queryLower);
//           final bIndex = bName.indexOf(queryLower);
//           if (aIndex != bIndex) return aIndex - bIndex;
//
//           // Branded items first (usually more accurate)
//           if (a.brand.isNotEmpty && b.brand.isEmpty) return -1;
//           if (b.brand.isNotEmpty && a.brand.isEmpty) return 1;
//
//           return 0;
//         });
//
//         searchResults = combined.take(25).toList();
//
//         if (searchResults.isEmpty) {
//           Get.snackbar(
//             'No Results',
//             'No foods found for "$query". Try a different search term.',
//             snackPosition: SnackPosition.BOTTOM,
//           );
//         }
//       } catch (e) {
//         e.printError();
//         showSnackbar(
//           'Could not search foods. Please check your internet connection.',
//           AnimatedSnackBarType.error,
//         );
//         searchResults = [];
//       }
//
//       loadingSearch = false;
//       update();
//     }
//
//     Future<List<FoodSearchResult>> _searchUSDA(String query,
//         String dataType,) async {
//       try {
//         final uri = Uri.parse(
//           ""
//         )
//                 .replace(
//               queryParameters: {
//                 'api_key': Env.usdaKey,
//                 'query': query,
//                 'dataType': dataType,
//                 'pageSize': '25',
//                 'sortBy': 'dataType.keyword',
//                 'sortOrder': 'asc',
//               },
//             );
//
//             final res = await http.get (uri).timeout(
//             const Duration(seconds: 10));
//
//         if (res.statusCode == 200) {
//           final data = jsonDecode(res.body);
//           final foods = (data['foods'] as List?) ?? [];
//
//           return foods
//               .map((f) {
//             try {
//               return FoodSearchResult.fromJson(f);
//             } catch (e) {
//               e.printError();
//               return null;
//             }
//           })
//               .whereType<FoodSearchResult>()
//               .where((f) => f.per100.kcal100 > 0)
//               .toList();
//         } else if (res.statusCode == 403) {
//           throw Exception(
//             'API key invalid. Get one from https://fdc.nal.usda.gov/api-key-signup.html',
//           );
//         }
//       } catch (e) {
//         print('USDA API error for $dataType: $e');
//       }
//
//       return [];
//     }
//
//     void addFoodFromResult({
//       required FoodSearchResult result,
//       required double serving,
//       required double servingQty,
//       required MealType meal,
//     }) {
//       final totalGrams = serving.grams * servingQty;
//       final factor = totalGrams / 100.0;
//
//       final e = MealData(
//         name: result.name,
//         brand: result.brand,
//         grams: totalGrams,
//         type: meal,
//         kcal: result..per100.kcal100 * factor,
//         proteinG: result.per100.protein100 * factor,
//         carbsG: result.per100.carbs100 * factor,
//         fatG: result.per100.fat100 * factor,
//         fiberG: result.per100.fiber100 * factor,
//         sugarG: result.per100.sugar100 * factor,
//         sodiumMg: result.per100.sodium100 * factor,
//         time: DateTime.now(),
//       );
//
//       entries.add(e);
//       _recomputeTotals();
//       _persistDay();
//       _addRecent(result);
//
//       // Clear search after adding
//       searchController.clear();
//       searchResults = [];
//
//       Get.snackbar(
//         'Added',
//         '${result.name} added to ${meal.label}',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: const Duration(seconds: 2),
//       );
//
//       update();
//     }
//
//     void addFoodFromPer100({
//       required FoodPer100 per100,
//       required double grams,
//       required MealType meal,
//     }) {
//       final factor = grams / 100.0;
//       final e = FoodEntry(
//         name: per100.name,
//         brand: per100.brand,
//         grams: grams,
//         meal: meal,
//         kcal: per100.kcal100 * factor,
//         proteinG: per100.protein100 * factor,
//         carbsG: per100.carbs100 * factor,
//         fatG: per100.fat100 * factor,
//         fiberG: per100.fiber100 * factor,
//         sugarG: per100.sugar100 * factor,
//         sodiumMg: per100.sodium100 * factor,
//         time: DateTime.now(),
//       );
//
//       entries.add(e);
//       _recomputeTotals();
//       _persistDay();
//       update();
//     }
//
//     void editEntry(int index, {double? grams, MealType? meal}) {
//       if (index < 0 || index >= entries.length) return;
//       final old = entries[index];
//
//       var updated = old;
//       if (grams != null && grams > 0) {
//         final per100 = FoodPer100(
//           name: old.name,
//           brand: old.brand,
//           kcal100: old.kcal * 100 / old.grams,
//           protein100: old.proteinG * 100 / old.grams,
//           carbs100: old.carbsG * 100 / old.grams,
//           fat100: old.fatG * 100 / old.grams,
//           fiber100: old.fiberG * 100 / old.grams,
//           sugar100: old.sugarG * 100 / old.grams,
//           sodium100: old.sodiumMg * 100 / old.grams,
//         );
//         final factor = grams / 100.0;
//         updated = old.copyWith(
//           grams: grams,
//           kcal: per100.kcal100 * factor,
//           proteinG: per100.protein100 * factor,
//           carbsG: per100.carbs100 * factor,
//           fatG: per100.fat100 * factor,
//           fiberG: per100.fiber100 * factor,
//           sugarG: per100.sugar100 * factor,
//           sodiumMg: per100.sodium100 * factor,
//         );
//       }
//       if (meal != null) {
//         updated = updated.copyWith(type: meal);
//       }
//
//       entries[index] = updated;
//       _recomputeTotals();
//       _persistDay();
//       update();
//     }
//
//     void removeEntry(int index) {
//       if (index < 0 || index >= entries.length) return;
//       entries.removeAt(index);
//       _recomputeTotals();
//       _persistDay();
//       update();
//     }
//
//     void _loadRecents() {
//       final raw = deviceService.getDevicePreference('recent_foods_v2');
//       recentFoods = [];
//       if (raw != null && raw.isNotEmpty) {
//         try {
//           final list = (jsonDecode(raw) as List)
//               .map((e) {
//             try {
//               final servings = ((e['servings'] as List?) ?? [])
//                   .map(
//                     (s) => ServingSize.fromJson(Map<String, dynamic>.from(s)),
//               )
//                   .toList();
//
//               return FoodSearchResult(
//                 fdcId: e['fdcId'] ?? '',
//                 name: e['name'] ?? '',
//                 brand: e['brand'] ?? '',
//                 category: e['category'] ?? '',
//                 servings: servings.isEmpty
//                     ? [ServingSize(amount: 100, unit: 'g', grams: 100)]
//                     : servings,
//                 per100: FoodPer100.fromJson(
//                   Map<String, dynamic>.from(e['per100']),
//                 ),
//               );
//             } catch (_) {
//               return null;
//             }
//           })
//               .whereType<FoodSearchResult>()
//               .toList();
//           recentFoods = list.take(15).toList();
//         } catch (e) {
//           print('Error loading recents: $e');
//         }
//       }
//     }
//
//     void _saveRecents() {
//       final list = recentFoods
//           .map(
//             (e) =>
//         {
//           'fdcId': e.fdcId,
//           'name': e.name,
//           'brand': e.brand,
//           'category': e.category,
//           'servings': e.servings.map((s) => s.toJson()).toList(),
//           'per100': e.per100.toJson(),
//         },
//       )
//           .toList();
//       deviceService.setDevicePreference('recent_foods_v2', jsonEncode(list));
//     }
//
//     void _addRecent(FoodSearchResult food) {
//       recentFoods.removeWhere(
//             (f) =>
//         f.name.toLowerCase() == food.name.toLowerCase() &&
//             f.brand.toLowerCase() == food.brand.toLowerCase(),
//       );
//       recentFoods.insert(0, food);
//       if (recentFoods.length > 20) {
//         recentFoods.removeRange(20, recentFoods.length);
//       }
//       _saveRecents();
//     }
//
//     void shareDay() {
//       final lines = <String>[];
//       lines.add("Day • $selectedDateName");
//       if (selectedWorkout != null) {
//         lines.add("Workout: ${selectedWorkout!.label}");
//       }
//       lines.add(
//         "Calories: ${totalCalories.toStringAsFixed(
//             0)}/${kcalTarget} • Protein: ${totalProtein.toStringAsFixed(0)}g",
//       );
//       lines.add("Meals:");
//       for (final m in MealType.values) {
//         final mealEntries = entries.where((e) => e.meal == m).toList();
//         if (mealEntries.isEmpty) continue;
//         lines.add("• ${m.label}");
//         for (final e in mealEntries) {
//           lines.add(
//             "  - ${e.name} ${e.grams.toStringAsFixed(0)}g • ${e.kcal
//                 .toStringAsFixed(0)} kcal",
//           );
//         }
//       }
//       lines.add("Water: ${waterMl} ml");
//       Share.share(lines.join("\n"));
//     }
// 
// Future<List<FoodSearchResult>> search(String query) async {
//   try {
//     Response response = await get(
//       Uri.parse("https://api.nal.usda.gov/fdc/v1/foods/search").replace(
//         queryParameters: {
//           "api_key": Env.usdaKey,
//           "data_type": "Foundation, Branded",
//           "query": query,
//           'pageSize': '25',
//           'sortBy': 'dataType.keyword',
//           'sortOrder': 'asc',
//         },
//       ),
//     ).timeout(const Duration(seconds: 10));
//
//     return (jsonDecode(response.body)["foods"] as List<dynamic>)
//         .map((food) => FoodSearchResult.fromMap(food))
//         .toList();
//   } on Error catch (e) {
//     e.printError();
//     return [];
//   }
// }
//
// Map<String, WorkoutFocus> _generateDefaultPlan() {
//   final plan = <String, WorkoutFocus>{};
//   final today = DateTime.now();
//
//   final pattern = [
//     WorkoutFocus.upperBody,
//     WorkoutFocus.cardio,
//     WorkoutFocus.leg,
//     WorkoutFocus.yoga,
//     WorkoutFocus.core,
//     WorkoutFocus.fullBody,
//     WorkoutFocus.rest,
//   ];
//
//   for (int i = 0; i < 30; i++) {
//     final date = today.add(Duration(days: i));
//     plan[_dateKey(date)] = pattern[i % pattern.length];
//   }
//
//   return plan;
// }
//
// Future<void> _savePlans(Map<String, WorkoutFocus> plans) async {
//   final Map<String, String> stringPlans = {};
//   plans.forEach((key, value) => stringPlans[key] = value.name);
//   await deviceService.setDevicePreference(
//     'workout_plans',
//     jsonEncode(stringPlans),
//   );
// }
//
// Future<void> _loadWorkoutPlans() async {
//   final saved = deviceService.getDevicePreference('workout_plans');
//   if (saved != null) {
//     final Map<String, dynamic> decoded = jsonDecode(saved);
//     workoutPlans = {};
//     decoded.forEach((key, value) {
//       final type = _parseWorkoutType(value.toString());
//       if (type != null) workoutPlans[key] = type;
//     });
//   }
//   update();
// }
//
// void _loadDay(DateTime d) {
//   final key = "food-${_dateKey(d)}";
//   entries = [];
//   final raw = deviceService.getDevicePreference(key);
//   if (raw != null) {
//     try {
//       final list = (jsonDecode(raw) as List)
//           .cast<Map>()
//           .map((e) => MealData.fromMap(e as Map<String, dynamic>))
//           .toList();
//       entries = list;
//     } catch (e) {
//       e.printError();
//       entries = [];
//     }
//   }
//
//   waterMl = deviceService.getDevicePreference("water-${_dateKey(d)}") ?? 0;
//   _recomputeTotals();
// }
//
// void _persistDay() {
//   final key = "food-${_dateKey(selectedDay)}";
//   final list = entries.map((e) => e.toJson()).toList();
//   deviceService.setDevicePreference(key, jsonEncode(list));
//   deviceService.setDevicePreference(
//     "water-${_dateKey(selectedDay)}",
//     waterMl,
//   );
// }
//
// void _recomputeTotals() {
//   totalCalories = 0;
//   totalProtein = 0;
//   totalCarbs = 0;
//   totalFat = 0;
//   totalFiber = 0;
//   totalSugar = 0;
//   totalSodium = 0;
//
//   for (final e in entries) {
//     totalCalories += e.kcal;
//     totalProtein += e.proteinG;
//     totalCarbs += e.carbsG;
//     totalFat += e.fatG;
//     totalFiber += e.fiberG;
//     totalSugar += e.sugarG;
//     totalSodium += e.sodiumMg;
//   }
//   update();
// }
//
// void _loadTargets() {
//   kcalTarget = deviceService.getDevicePreference('target_kcal') ?? kcalTarget;
//   proteinTarget =
//       deviceService.getDevicePreference('target_protein') ?? proteinTarget;
//   carbsTarget =
//       deviceService.getDevicePreference('target_carbs') ?? carbsTarget;
//   fatTarget = deviceService.getDevicePreference('target_fat') ?? fatTarget;
//   fiberTarget =
//       deviceService.getDevicePreference('target_fiber') ?? fiberTarget;
//   waterTargetMl =
//       deviceService.getDevicePreference('target_water') ?? waterTargetMl;
// }
//
// Future<void> setTargets({
//   required int kcal,
//   required int protein,
//   required int carbs,
//   required int fat,
//   required int fiber,
//   required int waterMl,
// }) async {
//   kcalTarget = kcal;
//   proteinTarget = protein;
//   carbsTarget = carbs;
//   fatTarget = fat;
//   fiberTarget = fiber;
//   waterTargetMl = waterMl;
//   await Future.wait([
//     deviceService.setDevicePreference('target_kcal', kcalTarget),
//     deviceService.setDevicePreference('target_protein', proteinTarget),
//     deviceService.setDevicePreference('target_carbs', carbsTarget),
//     deviceService.setDevicePreference('target_fat', fatTarget),
//     deviceService.setDevicePreference('target_fiber', fiberTarget),
//     deviceService.setDevicePreference('target_water', waterTargetMl),
//   ]);
//   update();
// }
//
// void addWater(int ml) {
//   waterMl = (waterMl + ml).clamp(0, 20000);
//   _persistDay();
//   update();
// }
//
// void removeWater(int ml) {
//   waterMl = (waterMl - ml).clamp(0, 20000);
//   _persistDay();
//   update();
// }
