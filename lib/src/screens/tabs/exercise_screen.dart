import 'dart:async';
import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';

const String kGeminiApiKey = "AIzaSyCI-es8sI7XKwQwYiipkmLdlNH65MgExFo";
const String kModel = 'gemini-2.5-pro';
const Duration kHttpTimeout = Duration(seconds: 25);

class ExerciseItem {
  final String name;
  final String qty;
  ExerciseItem({required this.name, required this.qty});
  factory ExerciseItem.fromJson(Map<String, dynamic> j) => ExerciseItem(
    name: j['name']?.toString() ?? '',
    qty: j['qty']?.toString() ?? '',
  );
}

class DayData {
  final List<ExerciseItem> exercises;
  DayData({required this.exercises});
  factory DayData.fromJson(dynamic data) {
    if (data is Map) {
      final listRaw = data['workouts'] ?? data['exercises'];
      if (listRaw is List) {
        final list = listRaw
            .map((e) => ExerciseItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        return DayData(exercises: list);
      }
    }
    if (data is List) {
      final list = data
          .map((e) => ExerciseItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return DayData(exercises: list);
    }
    return DayData(exercises: []);
  }
}

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
                                    it.qty,
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
      await exerciseService.getExercises(
      UserData(
        firstName: "John",
        lastName: "Smith",
        gender: UserGender.male,
        dob: DateTime.now(),
        age: 33,
        height: 180,
        weight: 75,
        totalCaloriesBurned: 50000,
        milesTraveled: 500,
        physicalActivity: UserPhysicalActivity.moderate,
        exerciseData: {},
      ),
    );
      final parsed = await _callGeminiWithRetries(
        buildWorkoutPrompt(workoutContext),
      );
      dayData = parsed ?? _fallbackDay(workoutContext);
      if (dayData!.exercises.isEmpty) throw Exception('Parsed empty workouts');
    } catch (e) {
      lastError = e.toString();
      dayData = _fallbackDay(workoutContext);
      showSnackbar(e.toString(), AnimatedSnackBarType.error);
    }
    loading = false;
    update();
  }

  Future<DayData?> _callGeminiWithRetries(String prompt) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$kModel:generateContent?key=$kGeminiApiKey',
    );
    final payload = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": prompt},
          ],
        },
      ],
      "generationConfig": {
        "temperature": 0.2,
        "responseMimeType": "application/json",
        "responseSchema": {
          "type": "OBJECT",
          "properties": {
            "workouts": {
              "type": "ARRAY",
              "items": {
                "type": "OBJECT",
                "properties": {
                  "name": {"type": "STRING"},
                  "qty": {"type": "STRING"},
                },
                "required": ["name", "qty"],
              },
            },
          },
          "required": ["workouts"],
        },
      },
      "safetySettings": [
        {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_NONE"},
        {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_NONE"},
        {
          "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
          "threshold": "BLOCK_NONE",
        },
        {
          "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
          "threshold": "BLOCK_NONE",
        },
      ],
    };

    Exception? lastErr;
    for (int attempt = 0; attempt < 3; attempt++) {
      try {
        final res = await http
            .post(
              uri,
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(payload),
            )
            .timeout(kHttpTimeout);
        if (res.statusCode != 200)
          throw Exception('HTTP ${res.statusCode}: ${res.body}');
        final decoded = jsonDecode(res.body);
        final block = decoded['promptFeedback']?['blockReason']?.toString();
        if (block != null && block.isNotEmpty)
          throw Exception('Blocked: $block');

        final candidates = decoded['candidates'] as List?;
        if (candidates == null || candidates.isEmpty)
          throw Exception('No candidates');

        String text = '';
        final parts = candidates[0]['content']?['parts'] as List?;
        if (parts != null && parts.isNotEmpty) {
          for (final p in parts) {
            final t = p['text']?.toString();
            if (t != null && t.trim().isNotEmpty) {
              text = t;
              break;
            }
          }
        }
        if (text.isEmpty) throw Exception('Empty model response');

        final jsonStr = _extractJson(text);
        if (jsonStr.isEmpty) throw Exception('No JSON found');
        final data = jsonDecode(jsonStr);
        final dd = DayData.fromJson(data);
        if (dd.exercises.isEmpty) throw Exception('No exercises parsed');
        return dd;
      } on TimeoutException {
        lastErr = Exception('Request timed out');
      } catch (e) {
        lastErr = e is Exception ? e : Exception(e.toString());
        await Future.delayed(Duration(milliseconds: 350 * (attempt + 1)));
      }
    }
    if (lastErr != null) throw lastErr;
    return null;
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
    final hasBar =
        equipment.contains('pull-up bar') || equipment.contains('barbell');
    final items = <ExerciseItem>[
      if (hasBar) ExerciseItem(name: "Pull-Ups (assisted)", qty: "3x5"),
      ExerciseItem(name: "Back Squat or Goblet Squat", qty: "4x8"),
      ExerciseItem(name: "Bench Press or DB Press", qty: "4x8"),
      ExerciseItem(name: "Row (Barbell/DB)", qty: "3x10"),
      ExerciseItem(name: "RDL (Barbell/DB)", qty: "3x8"),
      ExerciseItem(name: "Plank", qty: "3x45s"),
      ExerciseItem(name: "Bike/Run", qty: "12m"),
    ];
    return DayData(exercises: items);
  }
}
