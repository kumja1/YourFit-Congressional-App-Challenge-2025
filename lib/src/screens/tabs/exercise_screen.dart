import 'dart:async';
import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/controllers/profile_controller.dart';

const String kGeminiApiKey = "AIzaSyCI-es8sI7XKwQwYiipkmLdlNH65MgExFo";
const String kModel = 'gemini-2.5-flash';
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

class ExerciseInfo {
  final String name;
  final String? imageUrl;
  final List<String> steps;
  final List<String> videoQueries;
  ExerciseInfo({
    required this.name,
    this.imageUrl,
    this.steps = const [],
    this.videoQueries = const [],
  });
}

String buildWorkoutPrompt(Map<String, dynamic> ctx) {
  return '''
You are an API. Respond ONLY with valid JSON. No explanations, no markdown.
Context:
${jsonEncode(ctx)}
Output format:
{"workouts":[{"name":"Bench Press","qty":"4x10"},{"name":"Plank","qty":"60s"}]}
Rules:
- Return exactly one top-level object with key "workouts"
- "workouts" must be a non-empty array
- Each item has "name" and "qty" only
- Do not include any extra keys or text
''';
}

@RoutePage()
class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});
  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  late final WorkoutsCtrl ctrl;

  @override
  void initState() {
    super.initState();
    final profile = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController(), permanent: true);
    ctrl = Get.isRegistered<WorkoutsCtrl>()
        ? Get.find<WorkoutsCtrl>()
        : Get.put(WorkoutsCtrl(getContext: () => context, profile: profile));
    WidgetsBinding.instance.addPostFrameCallback((_) => ctrl.generate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GetBuilder<WorkoutsCtrl>(
        builder: (c) => FloatingActionButton.extended(
          onPressed: () => c.generate(),
          icon: c.loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
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
            child: GetBuilder<WorkoutsCtrl>(
              builder: (c) => Column(
                children: [
                  if (c.lastError != null)
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
                        c.lastError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  _Header(
                    level: c.level,
                    xp: c.xp,
                    xpToNext: c.xpToNext,
                    progress: c.xpProgress,
                    streak: c.streak,
                    badges: c.badges,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: c.loading
                        ? const Center(
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : ListView.separated(
                            itemCount: c.dayData?.exercises.length ?? 0,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) {
                              final it = c.dayData!.exercises[i];
                              final done = c.isDone(i);
                              final prog = c.progressFor(i);
                              return FutureBuilder<ExerciseInfo?>(
                                future: c.fetchInfo(it),
                                builder: (context, snap) {
                                  final info = snap.data;
                                  return Opacity(
                                    opacity: done ? 0.55 : 1,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        side: const BorderSide(
                                          color: Colors.black12,
                                        ),
                                      ),
                                      child: ExpansionTile(
                                        leading: GestureDetector(
                                          onTap: () => c.openTimer(i),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                value: prog.setsTotal == 0
                                                    ? 0
                                                    : prog.setsDone /
                                                          prog.setsTotal,
                                                strokeWidth: 3,
                                              ),
                                              CircleAvatar(
                                                radius: 16,
                                                backgroundColor: done
                                                    ? Colors.green
                                                    : Colors.grey.shade300,
                                                child: Icon(
                                                  done
                                                      ? Icons.check
                                                      : Icons.timer,
                                                  size: 18,
                                                  color: done
                                                      ? Colors.white
                                                      : Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        title: Text(
                                          it.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${it.qty}  •  Set ${prog.setsDone + 1 > prog.setsTotal ? prog.setsTotal : prog.setsDone + 1}/${prog.setsTotal}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        children: [
                                          if (info?.imageUrl != null)
                                            Image.network(
                                              info!.imageUrl!,
                                              height: 180,
                                              fit: BoxFit.cover,
                                            ),
                                          if (info != null &&
                                              info.steps.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: info.steps
                                                    .map((s) => Text("• $s"))
                                                    .toList(),
                                              ),
                                            ),
                                          if (info != null &&
                                              info.videoQueries.isNotEmpty)
                                            Wrap(
                                              spacing: 8,
                                              children: info.videoQueries
                                                  .take(2)
                                                  .map((q) {
                                                    return OutlinedButton.icon(
                                                      icon: const Icon(
                                                        Icons.ondemand_video,
                                                      ),
                                                      label: const Text(
                                                        'YouTube',
                                                      ),
                                                      onPressed: () =>
                                                          _openUrl(q),
                                                    );
                                                  })
                                                  .toList(),
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
                                                  child: FilledButton.icon(
                                                    onPressed: () =>
                                                        c.openTimer(i),
                                                    icon: const Icon(
                                                      Icons.play_arrow,
                                                    ),
                                                    label: Text(
                                                      done
                                                          ? 'Completed'
                                                          : (prog.running
                                                                ? 'Running...'
                                                                : 'Start Set'),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                OutlinedButton(
                                                  onPressed: () =>
                                                      c.resetExercise(i),
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
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(String query) async {
    final url =
        'https://www.youtube.com/results?search_query=${Uri.encodeQueryComponent(query)}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _Header extends StatelessWidget {
  final int level;
  final int xp;
  final int xpToNext;
  final double progress;
  final int streak;
  final List<String> badges;
  const _Header({
    super.key,
    required this.level,
    required this.xp,
    required this.xpToNext,
    required this.progress,
    required this.streak,
    required this.badges,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Lvl $level',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.deepOrange,
                    ),
                    Text(
                      '$streak day streak',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '$xp XP',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(value: progress, minHeight: 10),
            ),
            const SizedBox(height: 6),
            Text(
              '${(progress * 100).round()}% to next ($xpToNext XP)',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            if (badges.isNotEmpty)
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: badges.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(badges[i]),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SetProgress {
  final int setsTotal;
  final int setsDone;
  final bool running;
  final int secondsLeft;
  const SetProgress({
    required this.setsTotal,
    required this.setsDone,
    required this.running,
    required this.secondsLeft,
  });
}

class TimerState {
  int setsTotal;
  int setsDone;
  int perSetSec;
  bool running;
  int secondsLeft;
  Timer? t;
  TimerState({
    required this.setsTotal,
    required this.setsDone,
    required this.perSetSec,
    required this.running,
    required this.secondsLeft,
  });
}

class WorkoutsCtrl extends GetxController {
  final BuildContext Function() getContext;
  final ProfileController profile;
  WorkoutsCtrl({required this.getContext, required this.profile});
  bool loading = false;
  DayData? dayData;
  String? lastError;
  ExerciseService? svc;
  final Map<String, ExerciseInfo?> _cache = {};
  final Map<int, TimerState> _timers = {};
  int xp = 0;
  int totalDone = 0;
  int streak = 0;
  String? lastPerfectDay;
  List<String> badges = [];
  Set<int> _doneToday = {};

  @override
  void onInit() {
    super.onInit();
    svc = Get.isRegistered<ExerciseService>()
        ? Get.find<ExerciseService>()
        : null;
    _loadProgress();
  }

  @override
  void onClose() {
    for (final s in _timers.values) {
      s.t?.cancel();
    }
    super.onClose();
  }

  String get todayKey {
    final n = DateTime.now();
    return '${n.year}${n.month.toString().padLeft(2, '0')}${n.day.toString().padLeft(2, '0')}';
  }

  int get level => 1 + xp ~/ 100;
  int get xpToNext => 100 - (xp % 100);
  double get xpProgress => ((xp % 100) / 100).clamp(0.0, 1.0);

  bool isDone(int index) => _doneToday.contains(index);

  SetProgress progressFor(int index) {
    final s = _timers[index];
    if (s == null)
      return const SetProgress(
        setsTotal: 0,
        setsDone: 0,
        running: false,
        secondsLeft: 0,
      );
    return SetProgress(
      setsTotal: s.setsTotal,
      setsDone: s.setsDone,
      running: s.running,
      secondsLeft: s.secondsLeft,
    );
  }

  Future<void> generate() async {
    if (loading) return;
    loading = true;
    lastError = null;
    update();
    try {
      final user = profile.toUserDataOrNull();
      if (user == null)
        throw Exception(
          'Please complete your profile (age, height, weight, activity, goal, etc.) before generating workouts.',
        );
      try {
        if (svc != null) await svc!.getExercises(user);
      } catch (_) {}
      final ctx = profile.toContext();
      final dd = await callGemini(buildWorkoutPrompt(ctx));
      dayData = dd ?? fallbackPlan(ctx);
      if (dayData!.exercises.isEmpty) dayData = fallbackPlan(ctx);
      if ((dayData?.exercises.length ?? 0) == 0)
        throw Exception('No workouts generated');
      await _ensureTodayState();
      _initTimers();
    } catch (e) {
      lastError = e.toString();
    }
    loading = false;
    update();
  }

  void _initTimers() {
    _timers.clear();
    final list = dayData?.exercises ?? [];
    for (int i = 0; i < list.length; i++) {
      final parsed = _parseQty(list[i].qty);
      _timers[i] = TimerState(
        setsTotal: parsed.item1,
        setsDone: 0,
        perSetSec: parsed.item2,
        running: false,
        secondsLeft: parsed.item2,
      );
    }
  }

  Tuple2<int, int> _parseQty(String qty) {
    final q = qty.toLowerCase().replaceAll(' ', '');
    int sets = 1;
    int perSec = 45;
    final rxSetsReps = RegExp(r'^(\d+)x(\d+)$');
    final rxSetsSec = RegExp(r'^(\d+)x(\d+)s$');
    final rxOnlySec = RegExp(r'^(\d+)s$');
    final m1 = rxSetsSec.firstMatch(q);
    if (m1 != null) {
      sets = int.tryParse(m1.group(1) ?? '') ?? 3;
      perSec = int.tryParse(m1.group(2) ?? '') ?? 45;
      return Tuple2(sets, perSec);
    }
    final m2 = rxOnlySec.firstMatch(q);
    if (m2 != null) {
      sets = 1;
      perSec = int.tryParse(m2.group(1) ?? '') ?? 45;
      return Tuple2(sets, perSec);
    }
    final m3 = rxSetsReps.firstMatch(q);
    if (m3 != null) {
      sets = int.tryParse(m3.group(1) ?? '') ?? 3;
      final reps = int.tryParse(m3.group(2) ?? '') ?? 10;
      perSec = (reps * 3).clamp(20, 90);
      return Tuple2(sets, perSec);
    }
    return Tuple2(sets, perSec);
  }

  Future<ExerciseInfo?> fetchInfo(ExerciseItem it) async {
    if (_cache.containsKey(it.name)) return _cache[it.name];
    final ai = await aiSummary(it.name);
    final img = await lookupImage(it.name);
    final info = ExerciseInfo(
      name: ai['canonical_name']?.toString().isNotEmpty == true
          ? ai['canonical_name'].toString()
          : it.name,
      steps: (ai['steps'] as List?)?.map((e) => e.toString()).toList() ?? [],
      videoQueries:
          (ai['youtube_search_queries'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      imageUrl: img,
    );
    _cache[it.name] = info;
    return info;
  }

  Future<Map<String, dynamic>> aiSummary(String name) async {
    final payload = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {
              "text":
                  '''
You are an API. Return strict JSON only.
Input: "$name"
Output schema:
{
 "canonical_name": "string",
 "steps": ["string"],
 "youtube_search_queries": ["string"]
}
''',
            },
          ],
        },
      ],
      "generationConfig": {
        "temperature": 0.1,
        "topP": 0.5,
        "topK": 40,
        "responseMimeType": "application/json",
        "candidateCount": 1,
        "responseSchema": {
          "type": "OBJECT",
          "properties": {
            "canonical_name": {"type": "STRING"},
            "steps": {
              "type": "ARRAY",
              "items": {"type": "STRING"},
            },
            "youtube_search_queries": {
              "type": "ARRAY",
              "items": {"type": "STRING"},
            },
          },
          "required": ["canonical_name", "steps"],
        },
      },
    };
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$kModel:generateContent?key=$kGeminiApiKey',
    );
    final res = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(payload),
        )
        .timeout(kHttpTimeout);
    if (res.statusCode != 200) return {};
    final decoded = jsonDecode(res.body);
    final parts =
        (decoded['candidates'] as List?)?.first?['content']?['parts']
            as List? ??
        const [];
    final text = parts.map((p) => p['text']?.toString() ?? '').join();
    final map = parseJson(text);
    if (map is Map<String, dynamic>) return map;
    return {};
  }

  Future<String?> lookupImage(String query) async {
    try {
      final q = Uri.encodeQueryComponent(query);
      final uri = Uri.parse(
        'https://wger.de/api/v2/exercise/?language=2&status=2&limit=1&search=$q',
      );
      final res = await http.get(uri).timeout(kHttpTimeout);
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final results = (data['results'] as List?) ?? const [];
      if (results.isEmpty) return null;
      final id = results.first['id'] as int?;
      if (id == null) return null;
      final imgUri = Uri.parse(
        'https://wger.de/api/v2/exerciseimage/?exercise=$id&limit=1',
      );
      final imgRes = await http.get(imgUri).timeout(kHttpTimeout);
      if (imgRes.statusCode != 200) return null;
      final imgs = (jsonDecode(imgRes.body)['results'] as List?) ?? const [];
      if (imgs.isEmpty) return null;
      return imgs.first['image']?.toString();
    } catch (_) {
      return null;
    }
  }

  Future<DayData?> callGemini(String prompt) async {
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
        "temperature": 0.1,
        "topP": 0.5,
        "topK": 40,
        "candidateCount": 1,
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
        if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
        final decoded = jsonDecode(res.body);
        final parts =
            (decoded['candidates'] as List?)?.first?['content']?['parts']
                as List? ??
            const [];
        final text = parts.map((p) => p['text']?.toString() ?? '').join();
        final obj = parseJson(text);
        if (obj is Map<String, dynamic>) {
          final dd = DayData.fromJson(obj);
          if (dd.exercises.isNotEmpty) return dd;
        }
        throw Exception('parse');
      } catch (e) {
        lastErr = Exception(e.toString());
        await Future.delayed(Duration(milliseconds: 250 * (attempt + 1)));
      }
    }
    if (lastErr != null) throw lastErr;
    return null;
  }

  dynamic parseJson(String raw) {
    final t = raw.trim();
    final cleaned = t
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .replaceAll('\u200b', '')
        .replaceAll('\ufeff', '')
        .trim();
    try {
      return jsonDecode(cleaned);
    } catch (_) {}
    final obj = extractJson(cleaned);
    if (obj != null) {
      try {
        return jsonDecode(obj);
      } catch (_) {}
    }
    final workoutsObj = extractWorkoutsJson(cleaned);
    if (workoutsObj != null) {
      try {
        return jsonDecode(workoutsObj);
      } catch (_) {}
    }
    return null;
  }

  String? extractJson(String s) {
    int i = s.indexOf('{');
    if (i < 0) return null;
    int depth = 0;
    bool inStr = false;
    for (int j = i; j < s.length; j++) {
      final c = s[j];
      if (c == '"' && (j == 0 || s[j - 1] != '\\')) inStr = !inStr;
      if (inStr) continue;
      if (c == '{') depth++;
      if (c == '}') {
        depth--;
        if (depth == 0) return s.substring(i, j + 1);
      }
    }
    return null;
  }

  String? extractWorkoutsJson(String s) {
    final k = s.indexOf('"workouts"');
    if (k < 0) return null;
    int lb = s.indexOf('[', k);
    if (lb < 0) return null;
    int depth = 0;
    bool inStr = false;
    for (int j = lb; j < s.length; j++) {
      final c = s[j];
      if (c == '"' && (j == 0 || s[j - 1] != '\\')) inStr = !inStr;
      if (inStr) continue;
      if (c == '[') depth++;
      if (c == ']') {
        depth--;
        if (depth == 0) {
          final arr = s.substring(lb, j + 1);
          return '{"workouts":$arr}';
        }
      }
    }
    return null;
  }

  Future<void> openTimer(int index) async {
    if (dayData == null) return;
    final s = _timers[index];
    if (s == null) return;
    await showModalBottomSheet(
      context: getContext(),
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _TimerSheet(
        name: dayData!.exercises[index].name,
        qty: dayData!.exercises[index].qty,
        state: s,
        onStart: () => startSet(index),
        onCancel: () => cancelTimer(index),
        onSkip: () => skipToNextSet(index),
      ),
    );
    update();
  }

  void startSet(int index) {
    final s = _timers[index];
    if (s == null) return;
    if (s.running) return;
    if (s.setsDone >= s.setsTotal) return;
    s.running = true;
    if (s.secondsLeft <= 0) s.secondsLeft = s.perSetSec;
    s.t?.cancel();
    s.t = Timer.periodic(const Duration(seconds: 1), (tt) {
      if (s.secondsLeft > 0) {
        s.secondsLeft -= 1;
        update();
      } else {
        tt.cancel();
        s.t = null;
        s.running = false;
        s.setsDone += 1;
        s.secondsLeft = s.perSetSec;
        update();
        _checkExerciseComplete(index);
      }
    });
    update();
  }

  void cancelTimer(int index) {
    final s = _timers[index];
    if (s == null) return;
    s.t?.cancel();
    s.t = null;
    s.running = false;
    update();
  }

  void skipToNextSet(int index) {
    final s = _timers[index];
    if (s == null) return;
    if (s.setsDone < s.setsTotal) {
      s.t?.cancel();
      s.t = null;
      s.running = false;
      s.setsDone += 1;
      s.secondsLeft = s.perSetSec;
      update();
      _checkExerciseComplete(index);
    }
  }

  void resetExercise(int index) async {
    final s = _timers[index];
    if (dayData == null || s == null) return;
    s.t?.cancel();
    s.t = null;
    final parsed = _parseQty(dayData!.exercises[index].qty);
    s.setsTotal = parsed.item1;
    s.setsDone = 0;
    s.perSetSec = parsed.item2;
    s.running = false;
    s.secondsLeft = parsed.item2;
    if (_doneToday.remove(index)) {
      await _saveDoneToday();
    }
    update();
  }

  void _checkExerciseComplete(int index) async {
    final s = _timers[index];
    if (s == null) return;
    if (s.setsDone >= s.setsTotal) {
      if (!_doneToday.contains(index)) {
        _doneToday.add(index);
        await _saveDoneToday();
        xp += 10;
        totalDone += 1;
        await _saveTotals();
        unlockBadges();
        updateStreak();
      }
    }
  }

  void updateStreak() async {
    final len = dayData?.exercises.length ?? 0;
    if (len == 0) return;
    if (_doneToday.length == len) {
      final today = todayKey;
      if (lastPerfectDay == null) {
        streak = 1;
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
        streak = (diff == 1) ? streak + 1 : 1;
      }
      lastPerfectDay = today;
      if (!badges.contains('Perfect Day')) badges.add('Perfect Day');
      if (streak >= 3 && !badges.contains('3-Day Streak'))
        badges.add('3-Day Streak');
      if (streak >= 7 && !badges.contains('7-Day Streak'))
        badges.add('7-Day Streak');
      if (streak >= 30 && !badges.contains('30-Day Streak'))
        badges.add('30-Day Streak');
      await _saveBadges();
      await _saveTotals();
    }
  }

  void unlockBadges() async {
    if (totalDone >= 1 && !badges.contains('First Rep'))
      badges.add('First Rep');
    if (totalDone >= 10 && !badges.contains('x10')) badges.add('x10');
    if (totalDone >= 50 && !badges.contains('x50')) badges.add('x50');
    if (totalDone >= 100 && !badges.contains('x100')) badges.add('x100');
    await _saveBadges();
  }

  DayData fallbackPlan(Map<String, dynamic> ctx) {
    final days = (ctx['days_per_week'] is int && ctx['days_per_week'] > 0)
        ? ctx['days_per_week'] as int
        : 3;
    final base = <ExerciseItem>[
      ExerciseItem(name: 'Push-ups', qty: '3x12'),
      ExerciseItem(name: 'Bodyweight Squat', qty: '3x15'),
      ExerciseItem(name: 'Plank', qty: '3x45s'),
      ExerciseItem(name: 'Walking Lunges', qty: '3x12'),
      ExerciseItem(name: 'Glute Bridge', qty: '3x12'),
    ];
    return DayData(exercises: base.take(days >= 4 ? 5 : 4).toList());
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    xp = prefs.getInt('gf_xp') ?? 0;
    totalDone = prefs.getInt('gf_total') ?? 0;
    streak = prefs.getInt('gf_streak') ?? 0;
    lastPerfectDay = prefs.getString('gf_lastPerfect');
    badges = prefs.getStringList('gf_badges') ?? [];
    final todayList = prefs.getStringList('gf_done_${todayKey}') ?? [];
    _doneToday = todayList
        .map((e) => int.tryParse(e) ?? -1)
        .where((e) => e >= 0)
        .toSet();
    update();
  }

  Future<void> _saveTotals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('gf_xp', xp);
    await prefs.setInt('gf_total', totalDone);
    await prefs.setInt('gf_streak', streak);
    if (lastPerfectDay != null)
      await prefs.setString('gf_lastPerfect', lastPerfectDay!);
  }

  Future<void> _saveBadges() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('gf_badges', badges);
  }

  Future<void> _saveDoneToday() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'gf_done_${todayKey}',
      _doneToday.map((e) => e.toString()).toList(),
    );
  }

  Future<void> _ensureTodayState() async {
    final prefs = await SharedPreferences.getInstance();
    final todayList = prefs.getStringList('gf_done_${todayKey}') ?? [];
    _doneToday = todayList
        .map((e) => int.tryParse(e) ?? -1)
        .where((e) => e >= 0)
        .toSet();
  }
}

class _TimerSheet extends StatefulWidget {
  final String name;
  final String qty;
  final TimerState state;
  final VoidCallback onStart;
  final VoidCallback onCancel;
  final VoidCallback onSkip;
  const _TimerSheet({
    required this.name,
    required this.qty,
    required this.state,
    required this.onStart,
    required this.onCancel,
    required this.onSkip,
  });
  @override
  State<_TimerSheet> createState() => _TimerSheetState();
}

class _TimerSheetState extends State<_TimerSheet> {
  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final mm = (s.secondsLeft ~/ 60).toString().padLeft(2, '0');
    final ss = (s.secondsLeft % 60).toString().padLeft(2, '0');
    final pct = s.perSetSec == 0
        ? 0.0
        : (s.perSetSec - s.secondsLeft) / s.perSetSec;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 12,
      ),
      child: StatefulBuilder(
        builder: (ctx, setLocal) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${widget.qty} • Set ${s.setsDone + 1 > s.setsTotal ? s.setsTotal : s.setsDone + 1}/${s.setsTotal}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
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
                      onPressed: s.running ? null : widget.onStart,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(s.running ? 'Running' : 'Start'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: s.running ? widget.onCancel : widget.onSkip,
                      icon: Icon(s.running ? Icons.stop : Icons.skip_next),
                      label: Text(s.running ? 'Cancel' : 'Skip Set'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class Tuple2<A, B> {
  final A item1;
  final B item2;
  const Tuple2(this.item1, this.item2);
}
