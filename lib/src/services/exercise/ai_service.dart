// lib/src/screens/tabs/exercise/ai_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:yourfit/src/controllers/profile/profile_controller.dart';
import '../../models/exercise/exercise_models.dart';

class AiUserContext {
  final int age;
  final double heightCm;
  final double weightKg;
  const AiUserContext({
    required this.age,
    required this.heightCm,
    required this.weightKg,
  });
}

const String kGeminiApiKey = "AIzaSyCI-es8sI7XKwQwYiipkmLdlNH65MgExFo";
const String kModel = 'gemini-2.5-flash';
const bool kUseJsonMode = false;

class AiWorkoutResult {
  final DayData workout;
  final String explanation;
  AiWorkoutResult({required this.workout, required this.explanation});
}

class AiWorkoutService {
  final _howToCache = <String, String>{};

  Future<String> summarizeExercise({
    required ExerciseItem exercise,
    required AiUserContext user,
    ProfileController? profile,
  }) async {
    final key = (exercise.name).trim();
    if (_howToCache.containsKey(key)) return _howToCache[key]!;
    final text = await _callGemini(_buildHowToPrompt(exercise, user, profile));
    _howToCache[key] = text.trim();
    return _howToCache[key]!;
  }

  Future<String> regenerateExerciseSummary({
    required ExerciseItem exercise,
    required AiUserContext user,
    ProfileController? profile,
  }) async {
    final key = (exercise.name).trim();
    final text = await _callGemini(_buildHowToPrompt(exercise, user, profile));
    _howToCache[key] = text.trim();
    return _howToCache[key]!;
  }

  String _buildHowToPrompt(
    ExerciseItem ex,
    AiUserContext user,
    ProfileController? profile,
  ) {
    final goal = profile?.goal ?? 'general fitness';
    final exp = profile?.experience ?? 'beginner';
    final intensity = profile?.intensity ?? 'moderate';
    final equipment = (profile?.equipment ?? 'bodyweight').toString();
    final injuries = (profile?.injuries ?? 'none').toString();

    return '''
You are an in-app coach. Explain **how to perform** the exercise safely and effectively.
Add no additional text other than the list
User: age ${user.age}, ${user.heightCm} cm, ${user.weightKg} kg; goal $goal; experience $exp; intensity $intensity; equipment $equipment; injuries $injuries.
Exercise: "${ex.name}"  Qty: "${ex.qty}"

Constraints:
- Keep it plain text, no markdown whatsoever (no ** , bold text, etc)
- Make it a very short step by step list
- Max ~700 characters.
- Respect injuries/equipment. If unsafe for likely injuries, suggest a safer swap.

Answer:
''';
  }

  Future<AiWorkoutResult> generateWorkout({
    required AiUserContext user,
    ProfileController? profile,
    List<String>? history,
    String? focusLabel,
  }) async {
    final prompt = _buildGeneratePrompt(user, profile, history, focusLabel);
    final text = await _callGemini(prompt);

    final parsed = _parseStrictJson(text);
    final normalized = _normalizeWorkoutPayload(parsed);

    final exercises = _extractExercises(normalized);
    if (exercises.isEmpty) {
      throw const FormatException('AI returned no workouts/exercises.');
    }

    final explanation =
        (normalized['explanation'] ?? _defaultExplanation(user, profile))
            .toString();

    return AiWorkoutResult(
      workout: DayData(exercises: exercises),
      explanation: explanation,
    );
  }

  Future<AiWorkoutResult> tweakWorkout({
    required DayData current,
    required String instruction,
    required AiUserContext user,
    ProfileController? profile,
    String? focusLabel,
  }) async {
    final prompt = _buildTweakPrompt(
      current,
      instruction,
      user,
      profile,
      focusLabel,
    );
    final text = await _callGemini(prompt);

    final parsed = _parseStrictJson(text);
    final normalized = _normalizeWorkoutPayload(parsed);

    final exercises = _extractExercises(normalized);
    if (exercises.isEmpty) {
      throw const FormatException('AI tweak returned no workouts/exercises.');
    }

    final explanation =
        (normalized['explanation'] ?? 'Workout modified as requested.')
            .toString();

    return AiWorkoutResult(
      workout: DayData(exercises: exercises),
      explanation: explanation,
    );
  }

  // Concise Q&A
  Future<String> answerQuestion({
    required AiUserContext user,
    required String question,
    ProfileController? profile,
  }) async {
    final goal = profile?.goal ?? 'general fitness';
    final exp = profile?.experience ?? 'beginner';
    final intensity = profile?.intensity ?? 'moderate';
    final equipment = (profile?.equipment ?? 'bodyweight').toString();
    final injuries = (profile?.injuries ?? 'none').toString();

    final prompt =
        '''
You are a concise fitness Q&A assistant inside a mobile app.
User context: age ${user.age}, ${user.heightCm} cm, ${user.weightKg} kg; goal $goal; experience $exp; intensity $intensity; equipment $equipment; injuries $injuries.

Answer the user's question in 1–3 short sentences or up to 4 bullet points. Prioritize clear, practical guidance for beginners. Avoid medical diagnosis. If unsafe, advise to skip or lower load. Keep under 500 characters. Plain text only.

Q: $question
A:
''';

    final text = await _callGemini(prompt);
    return text;
  }

  // ---------- Prompts / transport / parsing ----------
  String _buildGeneratePrompt(
    AiUserContext user,
    ProfileController? profile,
    List<String>? history,
    String? focusLabel,
  ) {
    final recentWorkouts = (history ?? const [])
        .where((e) => e.trim().isNotEmpty)
        .take(5)
        .join('; ');

    final goal = profile?.goal ?? 'general fitness';
    final exp = profile?.experience ?? 'beginner';
    final intensity = profile?.intensity ?? 'moderate';
    final equipment = (profile?.equipment ?? 'bodyweight').toString();
    final injuries = (profile?.injuries ?? 'none').toString();

    final focusLine = (focusLabel == null || focusLabel.isEmpty)
        ? ''
        : 'Day focus (MUST FOLLOW): $focusLabel\n';

    return '''
Return STRICT JSON only. No prose. No markdown.

User:
- Age: ${user.age}, Height: ${user.heightCm} cm, Weight: ${user.weightKg} kg
- Goal: $goal
- Experience: $exp
- Intensity: $intensity
- Equipment: $equipment
- Injuries/limits: $injuries
$focusLine
Recent workouts: ${recentWorkouts.isEmpty ? 'none' : recentWorkouts}

Rules:
- MUST return 6-10 exercises.
- The "workouts" array must NEVER be empty.
- If user constraints make a focused workout impossible, you MUST return a general, safe, full-body bodyweight routine instead and explain the substitution in the "explanation" field.
- Respect equipment and injuries.
- Make sure it adapts to the users ski;; and intensity
- Use field "qty" like "4x8-10" / "3x12" / "45s".
- No duplicate exercises.

JSON shape EXACTLY:
{
  "workouts": [{"name":"Exercise","qty":"3x12"}],
  "explanation": "2-3 concise sentences"
}
''';
  }

  String _buildTweakPrompt(
    DayData current,
    String instruction,
    AiUserContext user,
    ProfileController? profile,
    String? focusLabel,
  ) {
    final goal = profile?.goal ?? 'general fitness';
    final exp = profile?.experience ?? 'beginner';
    final intensity = profile?.intensity ?? 'moderate';
    final equipment = (profile?.equipment ?? 'bodyweight').toString();
    final injuries = (profile?.injuries ?? 'none').toString();

    final focusLine = (focusLabel == null || focusLabel.isEmpty)
        ? ''
        : 'Keep day focus in mind: $focusLabel\n';

    return '''
Return STRICT JSON only. No prose. No markdown.

User:
- Age: ${user.age}, Height: ${user.heightCm} cm, Weight: ${user.weightKg} kg
- Goal: $goal, Experience: $exp, Intensity: $intensity
- Equipment: $equipment, Injuries: $injuries
$focusLine
Instruction: "$instruction"

Current workout:
${jsonEncode({
      "workouts": current.exercises.map((e) => {"name": e.name, "qty": e.qty}).toList(),
    })}

Rules:
- Keep 6-10 total exercises. The "workouts" array must not be empty.
- Respect equipment/injuries.
- "qty" must be compact like "4x8-10" or "45s".

JSON shape EXACTLY:
{
  "workouts": [{"name":"Exercise","qty":"3x12"}],
  "explanation": "1-2 sentences on changes"
}
''';
  }

  Future<String> _callGemini(String prompt) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$kModel:generateContent?key=$kGeminiApiKey',
    );

    final payload = <String, dynamic>{
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": prompt},
          ],
        },
      ],
      "generationConfig": {
        "temperature": 0.4,
        if (kUseJsonMode) "response_mime_type": "application/json",
      },
    };

    if (kDebugMode) {
      debugPrint('=== Gemini Request Body ===');
      debugPrint(const JsonEncoder.withIndent('  ').convert(payload));
    }

    final res = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 40));

    if (kDebugMode) {
      debugPrint('=== Gemini Response ${res.statusCode} ===');
      debugPrint(
        res.body.length > 4000 ? res.body.substring(0, 4000) : res.body,
      );
    }

    if (res.statusCode != 200) {
      throw Exception('AI request failed (${res.statusCode}): ${res.body}');
    }

    final body = jsonDecode(res.body);
    final parts = body['candidates']?[0]?['content']?['parts'];
    if (parts == null || parts is! List || parts.isEmpty) {
      throw const FormatException('Empty AI response (no parts).');
    }

    final text = parts[0]?['text'];
    if (text == null || text is! String || text.trim().isEmpty) {
      throw const FormatException('Empty AI response (no text).');
    }

    return text;
  }

  Map<String, dynamic> _parseStrictJson(String raw) {
    String t = raw.trim();

    if (t.startsWith('```')) {
      final i = t.indexOf('\n');
      if (i != -1) t = t.substring(i + 1);
      if (t.endsWith('```')) t = t.substring(0, t.length - 3);
    }

    try {
      final obj = jsonDecode(t);
      if (obj is Map<String, dynamic>) return obj;
    } catch (_) {}

    final start = t.indexOf('{');
    final end = t.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      final slice = t.substring(start, end + 1);
      final obj = jsonDecode(slice);
      if (obj is Map<String, dynamic>) return obj;
    }

    throw const FormatException('Could not parse AI JSON payload.');
  }

  Map<String, dynamic> _normalizeWorkoutPayload(Map<String, dynamic> m) {
    final out = <String, dynamic>{
      "explanation": m["explanation"] ?? m["reason"] ?? m["summary"] ?? "",
    };

    final dynamic rawList =
        m["workouts"] ??
        m["exercises"] ??
        m["items"] ??
        m["plan"] ??
        m["routine"];

    if (rawList is List) {
      out["workouts"] = rawList;
      return out;
    }

    if (m["day"] is Map &&
        (m["day"]["exercises"] is List || m["day"]["workouts"] is List)) {
      out["workouts"] = (m["day"]["exercises"] ?? m["day"]["workouts"]) as List;
      return out;
    }

    if (rawList is Map) {
      out["workouts"] = rawList.values.toList();
      return out;
    }

    if (m.containsKey("name") &&
        (m.containsKey("qty") ||
            m.containsKey("sets") ||
            m.containsKey("reps"))) {
      out["workouts"] = [m];
      return out;
    }

    out["workouts"] = const [];
    return out;
  }

  List<ExerciseItem> _extractExercises(Map<String, dynamic> normalized) {
    final raw = normalized["workouts"];
    if (raw is! List) return const [];

    final List<ExerciseItem> items = [];
    for (final e in raw) {
      if (e == null) continue;

      if (e is String) {
        final parts = e.trim().split(RegExp(r'\s+'));
        if (parts.length >= 2) {
          final qty = parts.last;
          final name = e.substring(0, e.length - qty.length).trim();
          if (name.isNotEmpty && qty.isNotEmpty) {
            items.add(ExerciseItem(name: name, qty: qty));
            continue;
          }
        }

        items.add(ExerciseItem(name: e, qty: '3x10'));
        continue;
      }

      if (e is Map) {
        String name = (e["name"] ?? e["exercise"] ?? e["title"] ?? "")
            .toString()
            .trim();
        String qty = (e["qty"] ?? "").toString().trim();

        qty = qty.isNotEmpty
            ? qty
            : _composeQty(
                sets: e["sets"]?.toString(),
                reps: e["reps"]?.toString(),
                duration: e["time"]?.toString() ?? e["duration"]?.toString(),
              );

        if (name.isEmpty) continue;
        if (qty.isEmpty) qty = '3x10';

        items.add(ExerciseItem(name: name, qty: qty));
      }
    }

    final seen = <String>{};
    final deduped = <ExerciseItem>[];
    for (final it in items) {
      final key = it.name.toLowerCase().trim();
      if (seen.add(key)) deduped.add(it);
    }

    return deduped.length > 10 ? deduped.take(10).toList() : deduped;
  }

  String _composeQty({String? sets, String? reps, String? duration}) {
    sets = (sets ?? '').trim();
    reps = (reps ?? '').trim();
    duration = (duration ?? '').trim();

    if (duration.isNotEmpty) return duration;
    if (sets.isNotEmpty && reps.isNotEmpty) return '${sets}x$reps';
    if (sets.isNotEmpty) return '${sets}x10';
    if (reps.isNotEmpty) return '3x$reps';
    return '3x10';
  }

  String _defaultExplanation(AiUserContext user, ProfileController? profile) {
    final goal = profile?.goal ?? 'general fitness';
    final exp = profile?.experience ?? 'beginner';
    return 'Plan tailored for a $exp level targeting $goal (age ${user.age}).';
  }
}
