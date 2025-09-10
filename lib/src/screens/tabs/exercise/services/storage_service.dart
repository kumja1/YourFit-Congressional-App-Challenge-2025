import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yourfit/src/screens/tabs/exercise/models/exercise_models.dart';
import 'package:yourfit/src/screens/tabs/roadmap/models/workout_type.dart';
import 'package:yourfit/src/screens/tabs/roadmap/roadmap_screen.dart';

class WorkoutStorageService {
  final String accountKey;
  late SharedPreferences _prefs;
  bool _initialized = false;

  WorkoutStorageService({required this.accountKey});

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  Future<Map<String, dynamic>> loadStats() async {
    await _ensureInitialized();

    return {
      'xp': _prefs.getInt('${accountKey}_xp') ?? 0,
      'streak': _prefs.getInt('${accountKey}_streak') ?? 0,
      'lastPerfect': _prefs.getString('${accountKey}_lastPerfect'),
    };
  }

  Future<void> saveStats(int xp, int streak, String? lastPerfectDay) async {
    await _ensureInitialized();

    await _prefs.setInt('${accountKey}_xp', xp);
    await _prefs.setInt('${accountKey}_streak', streak);
    if (lastPerfectDay != null) {
      await _prefs.setString('${accountKey}_lastPerfect', lastPerfectDay);
    }
  }

  Future<List<String>> loadWorkoutHistory() async {
    await _ensureInitialized();

    final history = _prefs.getStringList('${accountKey}_workout_history') ?? [];
    return history.take(7).toList();
  }

  Future<void> saveWorkoutToHistory(DayData workout) async {
    await _ensureInitialized();

    final history = _prefs.getStringList('${accountKey}_workout_history') ?? [];
    final workoutSummary = workout.exercises.map((e) => e.name).join(', ');

    history.insert(0, workoutSummary);

    if (history.length > 30) {
      history.removeRange(30, history.length);
    }

    await _prefs.setStringList('${accountKey}_workout_history', history);
  }

  Future<Set<int>> loadTodayProgress(String dateKey) async {
    await _ensureInitialized();

    final key = '${accountKey}_progress_$dateKey';
    final saved = _prefs.getString(key);

    if (saved != null && saved.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(saved);
        return decoded.cast<int>().toSet();
      } catch (e) {
        print('Error loading today progress: $e');
        return {};
      }
    }

    return {};
  }

  Future<void> saveTodayProgress(
    String dateKey,
    Set<int> completedIndices,
  ) async {
    await _ensureInitialized();

    try {
      final key = '${accountKey}_progress_$dateKey';
      await _prefs.setString(key, jsonEncode(completedIndices.toList()));
    } catch (e) {
      print('Error saving today progress: $e');
    }
  }

  Future<Map<String, String>> loadWorkoutPlans() async {
    await _ensureInitialized();

    final saved = _prefs.getString('workout_plans');
    if (saved != null && saved.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(saved);
        return decoded.cast<String, String>();
      } catch (e) {
        print('Error loading workout plans: $e');
        return {};
      }
    }

    return {};
  }

  Future<void> saveWorkoutPlans(Map<String, String> plans) async {
    await _ensureInitialized();
    try {
      await _prefs.setString('workout_plans', jsonEncode(plans));
    } catch (e) {
      print('Error saving workout plans: $e');
    }
  }

  Future<WorkoutType?> getWorkoutTypeForDate(DateTime date) async {
    await _ensureInitialized();

    try {
      final plans = await loadWorkoutPlans();
      final dateKey = _formatDateKey(date);
      final typeString = plans[dateKey];

      if (typeString != null && typeString.isNotEmpty) {
        try {
          return WorkoutType.values.firstWhere(
            (t) => t.name == typeString,
            orElse: () => throw StateError('No matching WorkoutType found'),
          );
        } catch (e) {
          print('No matching WorkoutType found for: $typeString');
          return null;
        }
      }
    } catch (e) {
      print('Error getting workout type for date: $e');
    }

    return null;
  }

  Future<void> clearAllData() async {
    await _ensureInitialized();

    try {
      final keys = _prefs
          .getKeys()
          .where((key) => key.startsWith(accountKey))
          .toList();
      for (final key in keys) {
        await _prefs.remove(key);
      }
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }

  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> saveCompletedWorkout({
    required String dateKey,
    required DayData workout,
    required int exercisesCompleted,
    required int totalExercises,
    required WorkoutType? type,
  }) async {
    await _ensureInitialized();

    try {
      final completionData = {
        'date': dateKey,
        'completed': exercisesCompleted,
        'total': totalExercises,
        'percentage': totalExercises > 0
            ? (exercisesCompleted / totalExercises * 100).round()
            : 0,
        'type': type?.name,
        'exercises': workout.exercises.map((e) => e.name).toList(),
      };

      await _prefs.setString(
        '${accountKey}_completion_$dateKey',
        jsonEncode(completionData),
      );
    } catch (e) {
      print('Error saving completed workout: $e');
    }
  }

  Future<Map<String, dynamic>?> loadCompletionData(String dateKey) async {
    await _ensureInitialized();

    try {
      final saved = _prefs.getString('${accountKey}_completion_$dateKey');
      if (saved != null && saved.isNotEmpty) {
        return jsonDecode(saved);
      }
    } catch (e) {
      print('Error loading completion data: $e');
    }

    return null;
  }

  Future<Map<String, dynamic>> getWorkoutStats({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await _ensureInitialized();

    int totalWorkouts = 0;
    int completedWorkouts = 0;
    int totalExercises = 0;
    int completedExercises = 0;
    Map<String, int> typeCount = {};

    try {
      for (
        DateTime date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(const Duration(days: 1))
      ) {
        final dateKey = _formatDateKey(date);
        final completionData = await loadCompletionData(dateKey);

        if (completionData != null) {
          totalWorkouts++;
          if (((completionData['percentage'] as int?) ?? 0) >= 80) {
            completedWorkouts++;
          }

          totalExercises += (completionData['total'] as int?) ?? 0;
          completedExercises += (completionData['completed'] as int?) ?? 0;

          final type = completionData['type'] as String?;
          if (type != null && type.isNotEmpty) {
            typeCount[type] = (typeCount[type] ?? 0) + 1;
          }
        }
      }
    } catch (e) {
      print('Error getting workout stats: $e');
    }

    return {
      'totalWorkouts': totalWorkouts,
      'completedWorkouts': completedWorkouts,
      'completionRate': totalWorkouts > 0
          ? (completedWorkouts / totalWorkouts * 100).round()
          : 0,
      'totalExercises': totalExercises,
      'completedExercises': completedExercises,
      'exerciseCompletionRate': totalExercises > 0
          ? (completedExercises / totalExercises * 100).round()
          : 0,
      'workoutTypeDistribution': typeCount,
    };
  }
}
