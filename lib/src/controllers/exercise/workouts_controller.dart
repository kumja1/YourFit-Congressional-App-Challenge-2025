// lib/src/screens/tabs/exercise/controllers/workouts_controller.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yourfit/src/controllers/profile/profile_controller.dart';

import 'exercise_exec_sheet.dart';
import '../../models/exercise/exercise_models.dart';
import '../../services/exercise/ai_service.dart';

typedef BuildContextGetter = BuildContext Function();

class SummaryState {
  final bool loading;
  final String? text;
  final String? error;
  const SummaryState({this.loading = false, this.text, this.error});

  SummaryState copyWith({bool? loading, String? text, String? error}) =>
      SummaryState(
        loading: loading ?? this.loading,
        text: text ?? this.text,
        error: error,
      );
}

class WorkoutsCtrl extends GetxController {
  WorkoutsCtrl({required this.getContext});
  final BuildContextGetter getContext;

  // ---- Gamification ----
  int level = 1;
  int xp = 0;
  int xpToNext = 120;
  int streak = 0;
  double get xpProgress => xpToNext == 0 ? 0 : xp / xpToNext;

  // ---- Screen State ----
  bool loading = false;
  String? lastError;
  String aiExplanation = '';
  DayData? dayData;
  String? dayFocus; // label for UI (e.g., "Leg Day")

  // ---- Progress State ----
  final Map<int, int> _completedSets = {};
  final Set<int> _doneExercises = {};
  final List<String> _history = [];

  // ---- NEW: per-exercise summary state ----
  final Map<String, SummaryState> _summaries = {};

  AiWorkoutService get _ai => _aiSvc ??= AiWorkoutService();
  AiWorkoutService? _aiSvc;

  @override
  void onInit() {
    super.onInit();
    _loadStoredData();
  }

  // ----------------- Persistence -----------------
  Future<void> _loadStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      level = prefs.getInt('user_level') ?? 1;
      xp = prefs.getInt('user_xp') ?? 0;
      xpToNext = prefs.getInt('user_xp_to_next') ?? 120;
      streak = prefs.getInt('user_streak') ?? 0;

      final historyJson = prefs.getString('workout_history');
      if (historyJson != null) {
        final List<dynamic> decoded = jsonDecode(historyJson);
        _history
          ..clear()
          ..addAll(decoded.map((e) => e.toString()));
      }
    } catch (e) {
      if (kDebugMode) print('loadStoredData error: $e');
    }
  }

  Future<void> _saveStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_level', level);
      await prefs.setInt('user_xp', xp);
      await prefs.setInt('user_xp_to_next', xpToNext);
      await prefs.setInt('user_streak', streak);
      await prefs.setString('workout_history', jsonEncode(_history));
    } catch (e) {
      if (kDebugMode) print('saveStoredData error: $e');
    }
  }

  // ----------------- Resolve minimal user context for AI -----------------
  Future<AiUserContext> _resolveUserContext() async {
    int age = 25;
    double height = 170;
    double weight = 70;

    try {
      if (Get.isRegistered<ProfileController>()) {
        final p = Get.find<ProfileController>();
        try {
          await p.load();
        } catch (_) {}
        if (p.age != null && p.age! > 0) age = p.age!;
        if (p.heightCm != null && p.heightCm! > 0)
          height = p.heightCm!.toDouble();
        if (p.weightKg != null && p.weightKg! > 0)
          weight = p.weightKg!.toDouble();
      }
    } catch (_) {}

    try {
      final prefs = await SharedPreferences.getInstance();
      final a = prefs.getInt('user_age');
      final h = prefs.getDouble('user_height');
      final w = prefs.getDouble('user_weight');
      if (a != null && a > 0) age = a;
      if (h != null && h > 0) height = h;
      if (w != null && w > 0) weight = w;
    } catch (_) {}

    return AiUserContext(age: age, heightCm: height, weightKg: weight);
  }

  // ----------------- Public helpers -----------------
  ExecProgress progressFor(int i) {
    final ex = (dayData?.exercises.length ?? 0) > i
        ? dayData!.exercises[i]
        : null;
    if (ex == null) return const ExecProgress(0, 1);
    final totalSets = _setsFromQty(ex.qty);
    final done = _completedSets[i] ?? 0;
    return ExecProgress(done.clamp(0, totalSets), totalSets);
  }

  bool isDone(int i) {
    final ex = (dayData?.exercises.length ?? 0) > i
        ? dayData!.exercises[i]
        : null;
    if (ex == null) return false;
    final totalSets = _setsFromQty(ex.qty);
    return (_completedSets[i] ?? 0) >= totalSets || _doneExercises.contains(i);
  }

  SummaryState summaryFor(ExerciseItem ex) {
    final key = (ex.name).trim();
    return _summaries[key] ?? const SummaryState();
  }

  Future<void> loadSummary(ExerciseItem ex, {bool force = false}) async {
    final key = (ex.name).trim();
    if (!force && (_summaries[key]?.text?.isNotEmpty ?? false)) return;

    _summaries[key] = const SummaryState(loading: true);
    update();

    try {
      final userCtx = await _resolveUserContext();
      final profile = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : null;

      final text = force
          ? await _ai.regenerateExerciseSummary(
              exercise: ex,
              user: userCtx,
              profile: profile,
            )
          : await _ai.summarizeExercise(
              exercise: ex,
              user: userCtx,
              profile: profile,
            );

      _summaries[key] = SummaryState(loading: false, text: text);
    } catch (e) {
      _summaries[key] = SummaryState(loading: false, error: '$e');
    }
    update();
  }

  // ----------------- Actions -----------------
  Future<void> generate() async {
    if (loading) return;
    loading = true;
    lastError = null;
    update();

    try {
      final userCtx = await _resolveUserContext();
      final canonicalFocus = await _canonicalFocusForToday();
      dayFocus = _labelForCanonical(canonicalFocus);

      final profile = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : null;

      final result = await _ai.generateWorkout(
        user: userCtx,
        profile: profile,
        history: _history,
        focusLabel: canonicalFocus,
      );

      dayData = result.workout;
      aiExplanation = result.explanation;

      _completedSets
        ..clear()
        ..addEntries(
          List.generate(dayData!.exercises.length, (i) => MapEntry(i, 0)),
        );
      _doneExercises.clear();

      // Clear summaries for previous plan
      _summaries.clear();
    } catch (e, st) {
      lastError = 'Failed to generate workout: $e';
      if (kDebugMode) {
        print('Generate error: $e');
        print(st);
      }
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> tweakWorkout(String instruction) async {
    if (dayData == null || loading) return;
    loading = true;
    lastError = null;
    update();

    try {
      final userCtx = await _resolveUserContext();
      final canonicalFocus = await _canonicalFocusForToday();
      dayFocus = _labelForCanonical(canonicalFocus);
      final profile = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : null;

      final res = await _ai.tweakWorkout(
        current: dayData!,
        instruction: instruction,
        user: userCtx,
        profile: profile,
        focusLabel: canonicalFocus,
      );

      dayData = res.workout;
      aiExplanation = res.explanation;
      _completedSets
        ..clear()
        ..addEntries(
          List.generate(dayData!.exercises.length, (i) => MapEntry(i, 0)),
        );
      _doneExercises.clear();

      // Reset summaries since exercises changed
      _summaries.clear();
    } catch (e) {
      lastError = 'Failed to tweak workout: $e';
    } finally {
      loading = false;
      update();
    }
  }

  // ----------------- Execution -----------------
  void openExec(int index) {
    final ctx = getContext();
    final ex = (dayData?.exercises.length ?? 0) > index
        ? dayData!.exercises[index]
        : null;
    if (ex == null) return;

    final totalSets = _setsFromQty(ex.qty);
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ExerciseExecSheet(
        name: ex.name,
        qty: ex.qty,
        completedSets: _completedSets[index] ?? 0,
        totalSets: totalSets,
        onCompleteSet: () => completeSet(index),
        onMarkDone: () => markExerciseDone(index),
      ),
    );
  }

  void completeSet(int index) {
    final ex = (dayData?.exercises.length ?? 0) > index
        ? dayData!.exercises[index]
        : null;
    if (ex == null) return;

    final total = _setsFromQty(ex.qty);
    final cur = (_completedSets[index] ?? 0) + 1;
    _completedSets[index] = cur.clamp(0, total);

    final reps = _repsFromQty(ex.qty);
    final gained = 8 + (reps ~/ 5) + (streak ~/ 5);
    _addXp(gained);

    _history.add("${ex.name} ${ex.qty}");
    if (_history.length > 20) _history.removeAt(0);

    if ((_completedSets[index] ?? 0) >= total) {
      _doneExercises.add(index);
    }

    _saveStoredData();
    update();
  }

  void markExerciseDone(int index) {
    final ex = (dayData?.exercises.length ?? 0) > index
        ? dayData!.exercises[index]
        : null;
    if (ex == null) return;

    final total = _setsFromQty(ex.qty);
    final cur = _completedSets[index] ?? 0;

    if (cur < total) {
      final missing = (total - cur).clamp(0, total);
      for (int i = 0; i < missing; i++) {
        completeSet(index);
      }
    } else {
      _doneExercises.add(index);
      _saveStoredData();
      update();
    }
  }

  // ----------------- XP helpers -----------------
  void _addXp(int amount) {
    xp += amount;
    while (xp >= xpToNext) {
      xp -= xpToNext;
      level += 1;
      xpToNext = _calcNextLevelXp(level);
    }
  }

  int _calcNextLevelXp(int lvl) {
    final base = 120;
    return (base + (lvl - 1) * 40).clamp(120, 999999);
  }

  // ----------------- Qty parsing -----------------
  int _setsFromQty(String qty) {
    final s = qty.toLowerCase().trim();
    if (RegExp(r'(\d+)\s*(s|sec|secs|min|m|minutes?)$').hasMatch(s)) return 1;
    final m = RegExp(r'(\d+)\s*x').firstMatch(s);
    return int.tryParse(m?.group(1) ?? '') ?? 3;
  }

  int _repsFromQty(String qty) {
    final durSec = RegExp(r'(\d+)\s*(s|sec|secs)$').firstMatch(qty);
    if (durSec != null) return int.tryParse(durSec.group(1) ?? '') ?? 30;

    final durMin = RegExp(r'(\d+)\s*(min|m|minutes?)$').firstMatch(qty);
    if (durMin != null) return (int.tryParse(durMin.group(1) ?? '') ?? 1) * 60;

    final m = RegExp(r'x\s*(\d+)(?:-(\d+))?').firstMatch(qty);
    if (m == null) return 10;
    final a = int.tryParse(m.group(1) ?? '') ?? 10;
    final b = int.tryParse(m.group(2) ?? '') ?? a;
    return ((a + b) / 2).round();
  }

  // ----------------- Focus (from Roadmap prefs) -----------------
  Future<String?> _canonicalFocusForToday() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('workout_plans');
      if (raw == null) return null;

      final Map<String, dynamic> decoded =
          jsonDecode(raw) as Map<String, dynamic>;
      final key = _dateKey(DateTime.now());
      final v = decoded[key]?.toString();
      if (v == null) return null;
      return _canonFocus(v);
    } catch (e) {
      if (kDebugMode) print('focus load error: $e');
      return null;
    }
  }

  String _dateKey(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String _canonFocus(String v) {
    final s = v.toLowerCase();
    if (s.contains('upper') || s.contains('push') || s.contains('pull'))
      return 'upperBody';
    if (s.contains('leg') || s.contains('lower')) return 'legDay';
    if (s.contains('cardio') || s.contains('hiit') || s.contains('interval'))
      return 'cardio';
    if (s.contains('core') || s.contains('abs')) return 'core';
    if (s.contains('full')) return 'fullBody';
    if (s.contains('rest')) return 'rest';
    if (s.contains('yoga') || s.contains('stretch') || s.contains('mobility'))
      return 'yoga';
    return 'fullBody';
  }

  String? _labelForCanonical(String? canon) {
    switch (canon) {
      case 'upperBody':
        return 'Upper Body';
      case 'legDay':
        return 'Leg Day';
      case 'cardio':
        return 'Cardio';
      case 'core':
        return 'Core';
      case 'fullBody':
        return 'Full Body';
      case 'rest':
        return 'Rest Day';
      case 'yoga':
        return 'Yoga/Stretch';
      default:
        return null;
    }
  }

  // ----------------- Utilities -----------------
  double get workoutCompletionPercentage {
    final total = dayData?.exercises.length ?? 0;
    if (total == 0) return 0;
    int done = 0;
    for (var i = 0; i < total; i++) {
      if (isDone(i)) done++;
    }
    return done / total;
  }

  bool get isWorkoutComplete {
    final total = dayData?.exercises.length ?? 0;
    if (total == 0) return false;
    for (var i = 0; i < total; i++) {
      if (!isDone(i)) return false;
    }
    return true;
  }

  int get totalCompletedSets =>
      _completedSets.values.fold(0, (sum, sets) => sum + sets);

  void resetWorkoutProgress() {
    _completedSets.clear();
    _doneExercises.clear();
    final n = dayData?.exercises.length ?? 0;
    _completedSets.addEntries(List.generate(n, (i) => MapEntry(i, 0)));
    update();
  }

  void skipExercise(int index) {
    final n = dayData?.exercises.length ?? 0;
    if (index < 0 || index >= n) return;
    _doneExercises.add(index);
    _saveStoredData();
    update();
  }

  @override
  void onClose() {
    _saveStoredData();
    super.onClose();
  }
}
