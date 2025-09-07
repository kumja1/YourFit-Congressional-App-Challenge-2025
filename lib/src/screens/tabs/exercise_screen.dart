import 'dart:async';
import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yourfit/src/models/day_data.dart';
import 'package:yourfit/src/models/exercise_data.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';

const String kGeminiApiKey = "AIzaSyCI-es8sI7XKwQwYiipkmLdlNH65MgExFo";
const String kModel = 'gemini-2.5-pro';
const Duration kHttpTimeout = Duration(seconds: 25);

final Map<String, dynamic> workoutContext = {
  "user": {
    "firstName": "John",
    "lastName": "Smith",
    "gender": "male",
    "dob": "1990-05-15",
    "age": 33,
    "heightCm": 180,
    "weightKg": 75,
    "totalCaloriesBurned": 50000,
    "milesTraveled": 500,
    "activityLevel": "moderate",
  },
  "plan": {
    "goal": "to run track and field at a college level",
    "experience": "intermediate",
    "daysPerWeek": 5,
    "intensity": "high",
    "equipment": ["dumbbells", "barbell", "resistance bands"],
    "injuries": [],
  },
};

String buildWorkoutPrompt(Map<String, dynamic> ctx) {
  return '''
You are an API. Respond ONLY with valid JSON. No explanations, no markdown.
Context:
${jsonEncode(ctx)}
Output format:
{"workouts":[{"name":"Bench Press","qty":"4x10"},{"name":"Plank","qty":"60s"}]}
Rules:
- Return 6 to 10 items.
- Use the top-level key "workouts" only.
- Each item has "name" and "qty" only.
- Match available "equipment" and consider any "injuries".
- "qty" is sets x reps like "4x8" or duration like "30m"/"45s".
- Use realistic volumes consistent with the given "experience" and "intensity" toward the "goal".
- Include compound lifts and at least one conditioning movement.
- No silly volumes like "2x" total reps or impossible durations.
Return strictly valid JSON with only the "workouts" array object.
''';
}

@RoutePage()
class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      _WorkoutsScreenController(getContext: () => context),
    );
    return Scaffold(
      floatingActionButton: GetBuilder<_WorkoutsScreenController>(
        builder: (c) => FloatingActionButton(
          onPressed: () => c.generate(),
          child: c.loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh),
        ),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: GetBuilder<_WorkoutsScreenController>(
            builder: (controller) => Column(
              children: [
                if (controller.lastError != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.06),
                      border: Border.all(color: Colors.red.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      controller.lastError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                Expanded(
                  child: controller.loading
                      ? const Center(
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : ListView.separated(
                          itemCount: controller.dayData?.exercises.length ?? 0,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final it = controller.dayData?.exercises[i];
                            if (it == null) return const SizedBox.shrink();
                            return Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 1.2,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        it.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${it.sets}x${it.reps}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkoutsScreenController extends GetxController {
  final BuildContext Function() getContext;
  _WorkoutsScreenController({required this.getContext});
  bool loading = false;
  DayData? dayData;
  String? lastError;
  ExerciseService exerciseService = Get.find();

  @override
  void onInit() {
    super.onInit();
    generate();
  }

  Future<void> generate() async {
    if (loading) return;
    loading = true;
    lastError = null;
    update();

    try {
      if (kGeminiApiKey.isEmpty) {
        throw Exception(
          'Missing GEMINI_API_KEY (use --dart-define=GEMINI_API_KEY=...)',
        );
      }
      dayData =
          await exerciseService.getExercises(
            UserData(
              firstName: "Grug",
              lastName: "Boogaman",
              gender: UserGender.male,
              dob: DateTime(1),
              age: 99,
              height: 100,
              weight: 226,
              physicalFitness: UserPhysicalFitness.moderate,
              equipment: ["stone", "boulder", "club", "spear"],
              disabilities: [
                "cancer",
                "blind",
                "deaf",
                "no arms or legs",
                "one lung",
                "athritus",
              ],
            ),
            intensity: ExerciseIntensity.high,
            additionalParameters: {
  "goal": "to be able to hunt wooly mammoths",
            },
          ) ??
          _fallbackDay(workoutContext);

      if (dayData!.exercises.isEmpty) throw Exception('Parsed empty workouts');
    } catch (e) {
      lastError = e.toString();
      dayData = _fallbackDay(workoutContext);
      showSnackbar(e.toString(), AnimatedSnackBarType.error);
    }
    loading = false;
    update();
  }

  String _extractJson(String s) {
    if (s.isEmpty) return "";
    var out = s.trim();
    if (out.startsWith("```") && out.endsWith("```")) {
      out = out.substring(out.indexOf('\n') + 1, out.length - 3);
    }
    final start = out.indexOf('{');
    if (start != -1) {
      final end = out.lastIndexOf('}');
      if (end != -1 && end > start) return out.substring(start, end + 1);
    }
    final listStart = out.indexOf('[');
    if (listStart != -1) {
      final listEnd = out.lastIndexOf(']');
      if (listEnd != -1 && listEnd > listStart)
        return '{"workouts":${out.substring(listStart, listEnd + 1)}}';
    }
    return "";
  }

  DayData _fallbackDay(Map<String, dynamic> ctx) {
    final plan = ctx['plan'] as Map<String, dynamic>;
    final equipment = (plan['equipment'] as List)
        .map((e) => e.toString().toLowerCase())
        .toList();

    final items = <ExerciseData>[];
    return DayData(exercises: items, caloriesBurned: 40);
  }
}
