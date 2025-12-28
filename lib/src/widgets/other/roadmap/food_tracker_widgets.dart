// // lib/src/widgets/other/roadmap/food_tracker_widgets.dart
// import 'package:flutter/material.dart';
// import 'package:yourfit/src/models/nutrition/meal_data.dart';
// import 'package:yourfit/src/screens/tabs/roadmap_screen.dart';
//
// class NutritionSummarySliver extends StatelessWidget {
//   final RoadmapController controller;
//   const NutritionSummarySliver({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Nutrition Summary',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       controller.selectedDateName,
//                       style: const TextStyle(fontSize: 14, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 _buildMacroRow(
//                   'Calories',
//                   controller.totalCalories,
//                   controller.kcalTarget.toDouble(),
//                   'kcal',
//                   Colors.red,
//                 ),
//                 const SizedBox(height: 8),
//                 _buildMacroRow(
//                   'Protein',
//                   controller.totalProtein,
//                   controller.proteinTarget.toDouble(),
//                   'g',
//                   Colors.blue,
//                 ),
//                 const SizedBox(height: 8),
//                 _buildMacroRow(
//                   'Carbs',
//                   controller.totalCarbs,
//                   controller.carbsTarget.toDouble(),
//                   'g',
//                   Colors.orange,
//                 ),
//                 const SizedBox(height: 8),
//                 _buildMacroRow(
//                   'Fat',
//                   controller.totalFat,
//                   controller.fatTarget.toDouble(),
//                   'g',
//                   Colors.green,
//                 ),
//                 const SizedBox(height: 12),
//                 const Divider(),
//                 const SizedBox(height: 8),
//                 _buildWaterRow(controller),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMacroRow(String label, double current, double target, String unit, Color color) {
//     final percentage = (current / target * 100).clamp(0, 100);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//             Text(
//               '${current.toStringAsFixed(0)} / ${target.toStringAsFixed(0)} $unit',
//               style: const TextStyle(fontSize: 14),
//             ),
//           ],
//         ),
//         const SizedBox(height: 4),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(
//             value: percentage / 100,
//             backgroundColor: color.withOpacity(0.2),
//             valueColor: AlwaysStoppedAnimation<Color>(color),
//             minHeight: 8,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildWaterRow(RoadmapController controller) {
//     final percentage = (controller.waterMl / controller.waterTargetMl * 100).clamp(0, 100);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.water_drop, size: 18, color: Colors.blue),
//                 SizedBox(width: 4),
//                 Text(
//                   'Water',
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//             Text(
//               '${controller.waterMl} / ${controller.waterTargetMl} ml',
//               style: const TextStyle(fontSize: 14),
//             ),
//           ],
//         ),
//         const SizedBox(height: 4),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(
//             value: percentage / 100,
//             backgroundColor: Colors.blue.withOpacity(0.2),
//             valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
//             minHeight: 8,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class QuickAddRowSliver extends StatelessWidget {
//   final RoadmapController controller;
//   const QuickAddRowSliver({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Row(
//           children: [
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: () {},
//           // => controller.addWater(250),
//                 icon: const Icon(Icons.water_drop, size: 18),
//                 label: const Text('+250ml'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: () => controller.addWater(500),
//                 icon: const Icon(Icons.water_drop, size: 18),
//                 label: const Text('+500ml'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: OutlinedButton.icon(
//                 onPressed: controller.shareDay,
//                 icon: const Icon(Icons.share, size: 18),
//                 label: const Text('Share'),
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FoodSearchSliver extends StatelessWidget {
//   final Function(String?) onSubmitted;
//   final TextEditingController controller;
//   final bool loading;
//
//   const FoodSearchSliver({
//     super.key,
//     required this.onSubmitted,
//     required this.controller,
//     this.loading = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Card(
//           elevation: 1,
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Search Foods',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: controller,
//                         onSubmitted: onSubmitted,
//                         decoration: InputDecoration(
//                           hintText: 'banana, chicken breast, rice...',
//                           prefixIcon: const Icon(Icons.search),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     SizedBox(
//                       height: 48,
//                       child: ElevatedButton(
//                         onPressed: loading ? null : () => onSubmitted(controller.text),
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                         ),
//                         child: loading
//                             ? const SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(strokeWidth: 2),
//                               )
//                             : const Text('Search'),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Tip: Be specific (e.g., "grilled chicken" vs "chicken")',
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FoodResultsSliver extends StatelessWidget {
//   final RoadmapController controller;
//   const FoodResultsSliver({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     final results = controller.searchResults;
//     if (results.isEmpty) {
//       return const SliverToBoxAdapter(child: SizedBox.shrink());
//     }
//
//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       sliver: SliverList.builder(
//         itemCount: results.length,
//         itemBuilder: (context, i) {
//           final r = results[i];
//           return Card(
//             margin: const EdgeInsets.only(bottom: 8),
//             child: InkWell(
//               onTap: () => _showAddFoodDialog(context, r, controller),
//               borderRadius: BorderRadius.circular(8),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             r.name,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 15,
//                             ),
//                           ),
//                           if (r.brand.isNotEmpty) ...[
//                             const SizedBox(height: 2),
//                             Text(
//                               r.brand,
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                           const SizedBox(height: 4),
//                           Text(
//                             '${r.per100.kcal100.toStringAsFixed(0)} kcal · '
//                             '${r.per100.protein100.toStringAsFixed(1)}g protein · '
//                             '${r.per100.carbs100.toStringAsFixed(1)}g carbs',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.black54,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Icon(
//                       Icons.add_circle_outline,
//                       color: Colors.green,
//                       size: 28,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _showAddFoodDialog(BuildContext context, FoodSearchResult food, RoadmapController controller) {
//     int selectedServingIndex = 0;
//     double quantity = 1.0;
//     MealType selectedMeal = MealType.breakfast;
//
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) {
//           final serving = food.servings[selectedServingIndex];
//           final totalGrams = serving.grams * quantity;
//           final factor = totalGrams / 100.0;
//
//           return AlertDialog(
//             title: Text(food.name),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (food.brand.isNotEmpty) ...[
//                     Text(
//                       food.brand,
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                   const Text(
//                     'Meal',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<MealType>(
//                     value: selectedMeal,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     ),
//                     items: MealType.values.map((meal) {
//                       return DropdownMenuItem(
//                         value: meal,
//                         child: Text(meal.label),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         setState(() => selectedMeal = value);
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Serving Size',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<int>(
//                     initialValue: selectedServingIndex,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     ),
//                     items: food.servings.asMap().entries.map((entry) {
//                       final serving = entry.value;
//                       return DropdownMenuItem(
//                         value: entry.key,
//                         child: Text('${serving.label} (${serving.grams}g)'),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         setState(() => selectedServingIndex = value);
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Quantity',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           setState(() {
//                             quantity = (quantity - 0.5).clamp(0.1, 100);
//                           });
//                         },
//                         icon: const Icon(Icons.remove_circle_outline),
//                       ),
//                       Expanded(
//                         child: TextField(
//                           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                           textAlign: TextAlign.center,
//                           decoration: const InputDecoration(
//                             border: OutlineInputBorder(),
//                             contentPadding: EdgeInsets.symmetric(vertical: 8),
//                           ),
//                           controller: TextEditingController(text: quantity.toStringAsFixed(1)),
//                           onChanged: (value) {
//                             final parsed = double.tryParse(value);
//                             if (parsed != null && parsed > 0) {
//                               setState(() => quantity = parsed.clamp(0.1, 100));
//                             }
//                           },
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           setState(() {
//                             quantity = (quantity + 0.5).clamp(0.1, 100);
//                           });
//                         },
//                         icon: const Icon(Icons.add_circle_outline),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade50,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Nutritional Info',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 8),
//                         Text('Total: ${totalGrams.toStringAsFixed(0)}g'),
//                         Text('Calories: ${(food.per100.kcal100 * factor).toStringAsFixed(0)} kcal'),
//                         Text('Protein: ${(food.per100.protein100 * factor).toStringAsFixed(1)}g'),
//                         Text('Carbs: ${(food.per100.carbs100 * factor).toStringAsFixed(1)}g'),
//                         Text('Fat: ${(food.per100.fat100 * factor).toStringAsFixed(1)}g'),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   controller.addFoodFromResult(
//                     result: food,
//                     serving: serving,
//                     servingQty: quantity,
//                     meal: selectedMeal,
//                   );
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Add to Meal'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// class FoodEntriesSliver extends StatelessWidget {
//   final RoadmapController controller;
//   const FoodEntriesSliver({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     final entries = controller.entries;
//     if (entries.isEmpty) {
//       return const SliverToBoxAdapter(
//         child: Padding(
//           padding: EdgeInsets.all(32),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(Icons.restaurant_menu, size: 48, color: Colors.grey),
//                 SizedBox(height: 16),
//                 Text(
//                   'No meals logged yet',
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Search and add foods above to get started',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//
//     // Group entries by meal type
//     final groupedEntries = <MealType, List<NutritionData>>{};
//     for (final entry in entries) {
//       groupedEntries.putIfAbsent(entry.type, () => []).add(entry);
//     }
//
//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       sliver: SliverList(
//         delegate: SliverChildBuilderDelegate(
//           (context, index) {
//             final meals = MealType.values;
//             final meal = meals[index];
//             final mealEntries = groupedEntries[meal] ?? [];
//
//             if (mealEntries.isEmpty) return const SizedBox.shrink();
//
//             final mealTotal = mealEntries.fold<double>(
//               0,
//               (sum, entry) => sum + entry.kcal,
//             );
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         meal.label,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         '${mealTotal.toStringAsFixed(0)} kcal',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ...mealEntries.asMap().entries.map((entry) {
//                   final entryIndex = entries.indexOf(entry.value);
//                   final e = entry.value;
//
//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     child: ListTile(
//                       title: Text(e.name),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (e.brand.isNotEmpty) Text(e.brand),
//                           Text(
//                             '${e.grams.toStringAsFixed(0)}g • '
//                             '${e.kcal.toStringAsFixed(0)} kcal • '
//                             '${e.proteinG.toStringAsFixed(1)}g protein',
//                             style: const TextStyle(fontSize: 12),
//                           ),
//                         ],
//                       ),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete_outline, color: Colors.red),
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: const Text('Delete Entry'),
//                               content: Text('Remove ${e.name} from your log?'),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: const Text('Cancel'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     controller.removeEntry(entryIndex);
//                                     Navigator.pop(context);
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.red,
//                                   ),
//                                   child: const Text('Delete'),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   );
//                 }),
//               ],
//             );
//           },
//           childCount: MealType.values.length,
//         ),
//       ),
//     );
//   }
// }