// lib/src/screens/tabs/exercise/controllers/workouts_controller.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yourfit/src/models/exercise/exercise_data.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/services/exercise_service.dart';

import 'exercise_exec_sheet.dart';
import '../../models/exercise/exercise_models.dart';

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

class WorkoutsScreenController extends GetxController {
  WorkoutsScreenController();

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
  List<ExerciseData> exercises = [];
  String? dayFocus; // label for UI (e.g., "Leg Day")

  // ---- Progress State ----
  final Map<int, int> _completedSets = {};
  final Set<int> _doneExercises = {};
  final List<String> _history = [];

  final Rx<UserData?> currentUser = Get.find<AuthService>().currentUser;
  final ExerciseService _exerciseService = Get.find();

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

  // ----------------- Public helpers -----------------
  ExecProgress progressFor(int i) {
    final ex = exercises.length > i ? exercises[i] : null;
    if (ex == null) return const ExecProgress(0, 1);
    final totalSets = ex.sets;
    final done = _completedSets[i] ?? 0;
    return ExecProgress(done.clamp(0, totalSets), totalSets);
  }

  bool isDone(int i) {
    final ex = (exercises.length ?? 0) > i ? exercises[i] : null;
    if (ex == null) return false;
    final totalSets = ex.sets;
    return (_completedSets[i] ?? 0) >= totalSets || _doneExercises.contains(i);
  }

  // ----------------- Actions -----------------
  Future<void> generate() async {
    if (loading) return;
    loading = true;
    lastError = null;
    update();
    final canonicalFocus = await _canonicalFocusForToday();
    dayFocus = _labelForCanonical(canonicalFocus);
    try {
      final result = await _exerciseService.getExercises(currentUser.value);
      exercises = result?.exercises ?? [];
    } on Error catch (e, st) {
      print("Generate: $e, $st");
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> tweakWorkout(String instruction) async {
    if (loading) return;
    loading = true;
    lastError = null;
    update();

    try {
      final canonicalFocus = await _canonicalFocusForToday();
      dayFocus = _labelForCanonical(canonicalFocus);

      final res = await _exerciseService.getExercises(
        currentUser.value,
        count: exercises.length,
      );

      exercises = res?.exercises ?? [];
      // aiExplanation = res.explanation;
      _completedSets
        ..clear()
        ..addEntries(List.generate(exercises.length, (i) => MapEntry(i, 0)));
      _doneExercises.clear();
    } catch (e) {
      lastError = 'Failed to tweak workout: $e';
    } finally {
      loading = false;
      update();
    }
  }

  // ----------------- Execution -----------------
  void openExec(int index) {
    final ex = exercises.length > index ? exercises[index] : null;
    if (ex == null) return;

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ExerciseExecSheet(
        exercise: ex,
        onCompleteSet: () => completeSet(index),
        onMarkDone: () => markExerciseDone(index),
      ),
    );
  }

  void completeSet(int index) {
    final ex = exercises.length > index ? exercises[index] : null;
    if (ex == null) return;

    final total = ex.sets;
    final cur = ex.state.setsDone + 1;

    final gained = 8 + (ex.reps ~/ 5) + (streak ~/ 5);
    _addXp(gained);

    if (_history.length > 20) _history.removeAt(0);

    _saveStoredData();
    update();
  }

  void markExerciseDone(int index) {
    final ex = exercises.length > index ? exercises[index] : null;
    if (ex == null) return;

    final total = ex.sets;
    final cur = ex.state.setsDone;

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
    final total = exercises.length;
    if (total == 0) return 0;
    int done = 0;
    for (var i = 0; i < total; i++) {
      if (isDone(i)) done++;
    }
    return done / total;
  }

  bool get isWorkoutComplete {
    final total = exercises.length;
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
    final n = exercises.length;
    _completedSets.addEntries(List.generate(n, (i) => MapEntry(i, 0)));
    update();
  }

  void skipExercise(int index) {
    final n = exercises.length;
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
