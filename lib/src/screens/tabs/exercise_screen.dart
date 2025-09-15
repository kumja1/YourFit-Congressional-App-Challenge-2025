import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/models/exercise/day_data.dart';
import 'package:yourfit/src/models/exercise/exercise_data.dart';
import 'package:yourfit/src/models/exercise/month_data.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';

@RoutePage()
class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_ExerciseScreenController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      floatingActionButton: GetBuilder<_ExerciseScreenController>(
        init: _ExerciseScreenController(),
        builder: (c) => FloatingActionButton.extended(
          onPressed: () async => await c.generate(),
          icon: c.loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.blue,
                  ),
                )
              : const Icon(Icons.refresh),
          label: const Text('New Plan'),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Expanded(
                  child: GetBuilder<_ExerciseScreenController>(
                    builder: (c) => c.loading
                        ? const Center(
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : ListView.separated(
                            itemCount: c.exercises.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) {
                              final exercise = c.exercises[i];
                              return Opacity(
                                opacity: exercise.state.completed ? 0.55 : 1,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: const BorderSide(
                                      color: Colors.black12,
                                    ),
                                  ),
                                  child: ExpansionTile(
                                    leading: GestureDetector(
                                      onTap: () => c.openExec(i),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            height: 32,
                                            width: 32,
                                            child: CircularProgressIndicator(
                                              value: exercise.sets == 0
                                                  ? 0
                                                  : exercise.state.setsDone /
                                                        exercise.sets,
                                              strokeWidth: 3,
                                            ),
                                          ),
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                exercise.state.completed
                                                ? Colors.green
                                                : Colors.grey.shade300,
                                            child: Icon(
                                              exercise.state.completed
                                                  ? Icons.check
                                                  : Icons.timer_off,
                                              size: 18,
                                              color: exercise.state.completed
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    title: Text(
                                      exercise.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${exercise.reps} x ${exercise.sets} • Set ${exercise.state.setsDone}/${exercise.sets}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    children: [
                                      if (exercise.instructions.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(exercise.instructions),
                                        ),

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          12,
                                          0,
                                          12,
                                          12,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: FilledButton(
                                                onPressed:
                                                    exercise.state.completed
                                                    ? null
                                                    : () => c.openExec(i),
                                                child: Text(
                                                  exercise.state.completed
                                                      ? 'Completed'
                                                      : (c.settings.useTimer
                                                            ? 'Start Timer'
                                                            : (!exercise
                                                                      .state
                                                                      .completed
                                                                  ? 'Continue'
                                                                  : 'Start')),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            OutlinedButton(
                                              onPressed: () {},
                                              // c.resetExercise(i),
                                              child: const Text('Reset'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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

class SettingsData {
  bool useTimer;
  bool strict;
  SettingsData({required this.useTimer, required this.strict});
}

class _ExerciseScreenController extends GetxController {
  final Rx<UserData?> currentUser = Get.find<AuthService>().currentUser;
  bool loading = false;
  List<ExerciseData> exercises = [];
  ExerciseService exerciseService = Get.find<ExerciseService>();
  SettingsData settings = SettingsData(useTimer: false, strict: true);
  /**
    int xp = 0;
    int totalDone = 0;
    int streak = 0;
  */
  int suspiciousCount = 0;
  String? lastPerfectDay;
  List<String> badges = [];
  // Set<int> _doneToday = {};

  // String get accountKey => user.value?.id ?? "local";

  @override
  void onInit() {
    super.onInit();
    generate();
  }

  /**
    int get level => 1 + xp ~/ 100;
    int get xpToNext => 100 - (xp % 100);
    double get xpProgress => ((xp % 100) / 100).clamp(0.0, 1.0);
  
  */

  Future<void> generate() async {
    loading = true;
    update();
    try {
      final dayData = await exerciseService.getExercises(
        UserData(
          firstName: "Jesse",
          lastName: "Novak",
          gender: UserGender.male,
          dob: DateTime(1981),
          height: 195.58,
          weight: 205,
          physicalFitness: UserPhysicalFitness.moderate,
          disabilities: ["Chronic Leg Wound", "Sickler"],
          exerciseData: {
            "2025:9:10": MonthData(
              days: {
                0: DayData(
                  exercises: [
                    ExerciseData(
                      name: 'Modified Push-ups (Wall or Incline)',
                      reps: 8,
                      sets: 2,
                      instructions:
                          'Perform against wall or elevated surface to reduce strain. Keep body aligned and breathe steadily.',
                      difficulty: ExerciseDifficulty.easy,
                      intensity: ExerciseIntensity.low,
                      caloriesBurned: 25,
                      durationPerSet: Duration(minutes: 2),
                      type: ExerciseType.strength,
                    ),
                    ExerciseData(
                      name: 'Seated Upper Body Stretches',
                      reps: 5,
                      sets: 1,
                      instructions:
                          'Gentle arm circles, shoulder rolls, and neck stretches while seated. Avoid strain on legs.',
                      difficulty: ExerciseDifficulty.easy,
                      intensity: ExerciseIntensity.low,
                      caloriesBurned: 15,
                      durationPerSet: Duration(minutes: 5),
                      targetMuscles: ['shoulders', 'neck', 'arms'],
                      type: ExerciseType.flexibility,
                    ),
                    ExerciseData(
                      name: 'Chair-Supported Calf Raises',
                      reps: 6,
                      sets: 2,
                      instructions:
                          'Hold chair for support. Lift heels gently, avoid pressure on leg wound. Stop if any discomfort.',
                      difficulty: ExerciseDifficulty.easy,
                      intensity: ExerciseIntensity.low,
                      caloriesBurned: 20,
                      durationPerSet: Duration(minutes: 2),
                      targetMuscles: ['calves'],
                      type: ExerciseType.strength,
                    ),
                  ],
                  caloriesBurned: 60,
                ),
              },
            ),
          },
        ),
      );
      exercises = dayData!.exercises;
      currentUser.value?.addExerciseData(dayData);
    } catch (e) {
      showSnackbar(e.toString(), AnimatedSnackBarType.error);
    }
    loading = false;
    update();
  }

  Future<void> openExec(int index) async {
    if (exercises.isEmpty) return;

    /**
      await showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) => _ExecSheet(
          name: exercises[index].name,
          qty: "",
          state: s,
          settings: settings,
          onStart: () => _start(index),
          onHoldComplete: () => _holdComplete(index),
          onCancel: () => _cancel(index),
          onSkip: () => _skip(index),
        ),
      );
    */
    update();
  }
}

/**
  
    void _updateStreak() async {
      final len = dayData?.exercises.length ?? 0;
      if (len == 0) return;
      if (_doneToday.length == len) {
        final today = todayKey;
        if (lastPerfectDay == null) {
          /**
            streak = 1;
    
  */
        } else {
          final y = int.parse(lastPerfectDay!.substring(0, 4));
          final m = int.parse(lastPerfectDay!.substring(4, 6));
          final d = int.parse(lastPerfectDay!.substring(6, 8));
          final last = DateTime(y, m, d);
          final now = DateTime.now();
          final diff = DateTime(
            now.year,
            now.month,
            now.day,
          ).difference(DateTime(last.year, last.month, last.day)).inDays;
          /**
            streak = (diff == 1) ? streak + 1 : 1;
    
  */
        }
        lastPerfectDay = today;
        if (!badges.contains('Perfect Day')) badges.add('Perfect Day');
        /**
         if (streak >= 3 && !badges.contains('3-Day Streak'))
           badges.add('3-Day Streak');
         if (streak >= 7 && !badges.contains('7-Day Streak'))
           badges.add('7-Day Streak');
         if (streak >= 30 && !badges.contains('30-Day Streak'))
           badges.add('30-Day Streak');
       */
        await _saveBadges();
        await _saveStats();
      }
      update();
    }
*/
/**
  
    void _unlockBadges() async {
      /**
        if (totalDone >= 1 && !badges.contains('First Rep'))
          badges.add('First Rep');
        if (totalDone >= 10 && !badges.contains('x10')) badges.add('x10');
        if (totalDone >= 50 && !badges.contains('x50')) badges.add('x50');
        if (totalDone >= 100 && !badges.contains('x100')) badges.add('x100');
      */
      await _saveBadges();
    }
  
    Future<void> openSettings() async {
      await showModalBottomSheet(
        context: Get.context!,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => _SettingsSheet(
          data: settings,
          onChanged: (d) async {
            settings = d;
            await _saveSettings();
            update();
          },
        ),
      );
    }
  
    void _toast(String msg) {
      showSnackbar(msg, AnimatedSnackBarType.info);
    }
  
    Future<void> _loadAll() async {
      final prefs = await SharedPreferences.getInstance();
      final p = user.value?.id ?? "local";
      /**
       xp = prefs.getInt('xp_$p') ?? 0;
       totalDone = prefs.getInt('total_$p') ?? 0;
       streak = prefs.getInt('streak_$p') ?? 0;
     */
      lastPerfectDay = prefs.getString('lastPerfect_$p');
      badges = prefs.getStringList('badges_$p') ?? [];
      suspiciousCount = prefs.getInt('susp_$p') ?? 0;
      final useTimer = prefs.getBool('useTimer_$p') ?? false;
      final strict = prefs.getBool('strict_$p') ?? true;
      settings = SettingsData(useTimer: useTimer, strict: strict);
      final todayList = prefs.getStringList('done_${p}_$todayKey') ?? [];
      _doneToday = todayList
          .map((e) => int.tryParse(e) ?? -1)
          .where((e) => e >= 0)
          .toSet();
      update();
    }
  
    Future<void> _saveStats() async {
      final prefs = await SharedPreferences.getInstance();
      final p = user.value?.id ?? "local";
      /**
        await prefs.setInt('xp_$p', xp);
        await prefs.setInt('total_$p', totalDone);
        await prefs.setInt('streak_$p', streak);
      */
      await prefs.setInt('susp_$p', suspiciousCount);
      if (lastPerfectDay != null) {
        await prefs.setString('lastPerfect_$p', lastPerfectDay!);
      }
    }
  
    Future<void> _saveBadges() async {
      final prefs = await SharedPreferences.getInstance();
      final p = accountKey;
      await prefs.setStringList('badges_$p', badges);
    }
  
    Future<void> _saveDoneToday() async {
      final prefs = await SharedPreferences.getInstance();
      final p = accountKey;
      await prefs.setStringList(
        'done_${p}_$todayKey',
        _doneToday.map((e) => e.toString()).toList(),
      );
    }
  
    Future<void> _saveSettings() async {
      final prefs = await SharedPreferences.getInstance();
      final p = accountKey;
      await prefs.setBool('useTimer_$p', settings.useTimer);
      await prefs.setBool('strict_$p', settings.strict);
    }
  
    Future<void> _ensureTodayState() async {
      final prefs = await SharedPreferences.getInstance();
      final p = accountKey;
      final todayList = prefs.getStringList('done_${p}_$todayKey') ?? [];
      _doneToday = todayList
          .map((e) => int.tryParse(e) ?? -1)
          .where((e) => e >= 0)
          .toSet();
    }
*/

/**
  
  class _ExecSheet extends StatefulWidget {
    final String name;
    final String qty;
    final ExerciseState state;
    final SettingsData settings;
    final VoidCallback onStart;
    final VoidCallback onHoldComplete;
    final VoidCallback onCancel;
    final VoidCallback onSkip;
    const _ExecSheet({
      required this.name,
      required this.qty,
      required this.state,
      required this.settings,
      required this.onStart,
      required this.onHoldComplete,
      required this.onCancel,
      required this.onSkip,
    });
    @override
    State<_ExecSheet> createState() => _ExecSheetState();
  }
  
  class _ExecSheetState extends State<_ExecSheet> {
    @override
    Widget build(BuildContext context) {
      final s = widget.state;
      final mm = (s. ~/ 60).toString().padLeft(2, '0');
      final ss = (s.secLeft % 60).toString().padLeft(2, '0');
      final pct = s.perSec == 0 ? 0.0 : (s.perSec - s.secLeft) / s.perSec;
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              '${widget.qty} • Set ${s.done + 1 > s.total ? s.total : s.done + 1}/${s.total}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            if (widget.settings.useTimer)
              SizedBox(
                height: 140,
                width: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 140,
                      width: 140,
                      child: CircularProgressIndicator(
                        value: pct.clamp(0.0, 1.0),
                        strokeWidth: 8,
                      ),
                    ),
                    Text(
                      '$mm:$ss',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: s.active ? null : widget.onStart,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(
                      s.active
                          ? 'Running'
                          : (widget.settings.useTimer ? 'Start Timer' : 'Start'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: s.active ? widget.onCancel : widget.onSkip,
                    icon: Icon(s.active ? Icons.stop : Icons.skip_next),
                    label: Text(s.active ? 'Cancel' : 'Skip Set'),
                  ),
                ),
              ],yo i need some milk yo sucky suck suck
            ),
            const SizedBox(height: 8),
            if (!widget.settings.useTimer)
              GestureDetector(
                onLongPress: widget.onHoldComplete,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: s.active ? Colors.green : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Long-press to complete',
                    style: TextStyle(
                      color: s.active ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }
  
  class _SettingsSheet extends StatefulWidget {
    final SettingsData data;
    final ValueChanged<SettingsData> onChanged;
    const _SettingsSheet({required this.data, required this.onChanged});
    @override
    State<_SettingsSheet> createState() => _SettingsSheetState();
  }
  
  class _SettingsSheetState extends State<_SettingsSheet> {
    late bool useTimer = widget.data.useTimer;
    late bool strict = widget.data.strict;
    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Workout Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: useTimer,
              onChanged: (v) => setState(() => useTimer = v),
              title: const Text('Use timer per set'),
            ),
            SwitchListTile(
              value: strict,
              onChanged: (v) => setState(() => strict = v),
              title: const Text('Strict mode (harder anti-cheese)'),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => widget.onChanged(
                  SettingsData(useTimer: useTimer, strict: strict),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      );
    }
  }
  
*/
