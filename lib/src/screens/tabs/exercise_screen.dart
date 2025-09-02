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
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => ctrl.openSettings(),
          ),
        ],
      ),
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
                    suspicious: c.suspiciousCount,
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
                              final p = c.progressFor(i);
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
                                          onTap: () => c.openExec(i),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                height: 32,
                                                width: 32,
                                                child:
                                                    CircularProgressIndicator(
                                                      value: p.total == 0
                                                          ? 0
                                                          : p.done / p.total,
                                                      strokeWidth: 3,
                                                    ),
                                              ),
                                              CircleAvatar(
                                                radius: 16,
                                                backgroundColor: done
                                                    ? Colors.green
                                                    : Colors.grey.shade300,
                                                child: Icon(
                                                  done
                                                      ? Icons.check
                                                      : Icons.timer_off,
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
                                          '${it.qty} • Set ${p.done + 1 > p.total ? p.total : p.done + 1}/${p.total}',
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
                                                  child: FilledButton(
                                                    onPressed: done
                                                        ? null
                                                        : () => c.openExec(i),
                                                    child: Text(
                                                      done
                                                          ? 'Completed'
                                                          : (c.settings.useTimer
                                                                ? 'Start Timer'
                                                                : (p.active
                                                                      ? 'Continue'
                                                                      : 'Start')),
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
  final int suspicious;
  const _Header({
    super.key,
    required this.level,
    required this.xp,
    required this.xpToNext,
    required this.progress,
    required this.streak,
    required this.badges,
    required this.suspicious,
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
            Row(
              children: [
                if (badges.isNotEmpty)
                  Expanded(
                    child: SizedBox(
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
                  ),
                if (suspicious > 0)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 6),
                        Text('$suspicious suspicious'),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExecProgress {
  final int total;
  final int done;
  final bool active;
  final int secLeft;
  const ExecProgress({
    required this.total,
    required this.done,
    required this.active,
    required this.secLeft,
  });
}

class ExecState {
  int total;
  int done;
  int perSec;
  bool active;
  int secLeft;
  DateTime? startedAt;
  Timer? t;
  ExecState({
    required this.total,
    required this.done,
    required this.perSec,
    required this.active,
    required this.secLeft,
    this.startedAt,
  });
}

class SettingsData {
  bool useTimer;
  bool strict;
  SettingsData({required this.useTimer, required this.strict});
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
  final Map<int, ExecState> _exec = {};
  SettingsData settings = SettingsData(useTimer: false, strict: true);
  int xp = 0;
  int totalDone = 0;
  int streak = 0;
  int suspiciousCount = 0;
  String? lastPerfectDay;
  List<String> badges = [];
  Set<int> _doneToday = {};

  @override
  void onInit() {
    super.onInit();
    svc = Get.isRegistered<ExerciseService>()
        ? Get.find<ExerciseService>()
        : null;
    _loadAll();
  }

  @override
  void onClose() {
    for (final s in _exec.values) {
      s.t?.cancel();
    }
    super.onClose();
  }

  String get accountKey {
    final ctx = profile.toContext();
    final uid = (ctx['uid'] ?? ctx['email'] ?? ctx['user_id'] ?? '')
        .toString()
        .trim();
    return uid.isEmpty ? 'local' : uid;
  }

  String get todayKey {
    final n = DateTime.now();
    return '${n.year}${n.month.toString().padLeft(2, '0')}${n.day.toString().padLeft(2, '0')}';
  }

  int get level => 1 + xp ~/ 100;
  int get xpToNext => 100 - (xp % 100);
  double get xpProgress => ((xp % 100) / 100).clamp(0.0, 1.0);

  bool isDone(int index) => _doneToday.contains(index);

  ExecProgress progressFor(int index) {
    final s = _exec[index];
    if (s == null)
      return const ExecProgress(total: 0, done: 0, active: false, secLeft: 0);
    return ExecProgress(
      total: s.total,
      done: s.done,
      active: s.active,
      secLeft: s.secLeft,
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
      final dd = await _callGemini(buildWorkoutPrompt(ctx));
      dayData = dd ?? _fallback(ctx);
      if (dayData!.exercises.isEmpty) dayData = _fallback(ctx);
      if ((dayData?.exercises.length ?? 0) == 0)
        throw Exception('No workouts generated');
      await _ensureTodayState();
      _initExec();
      await _saveStats();
    } catch (e) {
      lastError = e.toString();
    }
    loading = false;
    update();
  }

  void _initExec() {
    _exec.clear();
    final list = dayData?.exercises ?? [];
    for (int i = 0; i < list.length; i++) {
      final p = _parseQty(list[i].qty);
      _exec[i] = ExecState(
        total: p.item1,
        done: 0,
        perSec: p.item2,
        active: false,
        secLeft: p.item2,
        startedAt: null,
      );
    }
  }

  Tuple2<int, int> _parseQty(String qty) {
    final q = qty.toLowerCase().replaceAll(' ', '');
    int sets = 1;
    int perSec = 45;
    final r1 = RegExp(r'^(\d+)x(\d+)$');
    final r2 = RegExp(r'^(\d+)x(\d+)s$');
    final r3 = RegExp(r'^(\d+)s$');
    final m2 = r2.firstMatch(q);
    if (m2 != null) {
      sets = int.tryParse(m2.group(1) ?? '') ?? 3;
      perSec = int.tryParse(m2.group(2) ?? '') ?? 45;
      return Tuple2(sets, perSec);
    }
    final m3 = r3.firstMatch(q);
    if (m3 != null) {
      sets = 1;
      perSec = int.tryParse(m3.group(1) ?? '') ?? 45;
      return Tuple2(sets, perSec);
    }
    final m1 = r1.firstMatch(q);
    if (m1 != null) {
      sets = int.tryParse(m1.group(1) ?? '') ?? 3;
      final reps = int.tryParse(m1.group(2) ?? '') ?? 10;
      perSec = (reps * 3).clamp(20, 90);
      return Tuple2(sets, perSec);
    }
    return Tuple2(sets, perSec);
  }

  Future<ExerciseInfo?> fetchInfo(ExerciseItem it) async {
    if (_cache.containsKey(it.name)) return _cache[it.name];
    final ai = await _aiSummary(it.name);
    final img = await _lookupImage(it.name);
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

  Future<Map<String, dynamic>> _aiSummary(String name) async {
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
    final map = _parseJson(text);
    if (map is Map<String, dynamic>) return map;
    return {};
  }

  Future<String?> _lookupImage(String query) async {
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

  Future<DayData?> _callGemini(String prompt) async {
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
        final obj = _parseJson(text);
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

  dynamic _parseJson(String raw) {
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
    final obj = _extractJson(cleaned);
    if (obj != null) {
      try {
        return jsonDecode(obj);
      } catch (_) {}
    }
    final workoutsObj = _extractWorkoutsJson(cleaned);
    if (workoutsObj != null) {
      try {
        return jsonDecode(workoutsObj);
      } catch (_) {}
    }
    return null;
  }

  String? _extractJson(String s) {
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

  String? _extractWorkoutsJson(String s) {
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

  Future<void> openExec(int index) async {
    if (dayData == null) return;
    final s = _exec[index];
    if (s == null) return;
    await showModalBottomSheet(
      context: getContext(),
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _ExecSheet(
        name: dayData!.exercises[index].name,
        qty: dayData!.exercises[index].qty,
        state: s,
        settings: settings,
        onStart: () => _start(index),
        onHoldComplete: () => _holdComplete(index),
        onCancel: () => _cancel(index),
        onSkip: () => _skip(index),
      ),
    );
    update();
  }

  void _start(int index) {
    final s = _exec[index];
    if (s == null) return;
    if (s.active) return;
    if (s.done >= s.total) return;
    s.active = true;
    s.startedAt = DateTime.now();
    if (settings.useTimer) {
      if (s.secLeft <= 0) s.secLeft = s.perSec;
      s.t?.cancel();
      s.t = Timer.periodic(const Duration(seconds: 1), (tt) {
        if (s.secLeft > 0) {
          s.secLeft -= 1;
          update();
        } else {
          tt.cancel();
          s.t = null;
          s.active = false;
          s.done += 1;
          s.secLeft = s.perSec;
          update();
          _finishSet(index, enforced: true);
        }
      });
    } else {
      s.secLeft = s.perSec;
      update();
    }
  }

  void _holdComplete(int index) {
    final s = _exec[index];
    if (s == null) return;
    if (!s.active) return;
    final elapsed = s.startedAt == null
        ? 0
        : DateTime.now().difference(s.startedAt!).inSeconds;
    final minDwell = settings.strict
        ? (s.perSec * 0.75).round()
        : (s.perSec * 0.5).round();
    if (settings.useTimer) return;
    if (elapsed < minDwell) {
      suspiciousCount += 1;
      _toast('Too fast');
      update();
      _saveStats();
      return;
    }
    s.active = false;
    s.done += 1;
    s.secLeft = s.perSec;
    _finishSet(index, enforced: false);
    update();
  }

  void _cancel(int index) {
    final s = _exec[index];
    if (s == null) return;
    s.t?.cancel();
    s.t = null;
    s.active = false;
    update();
  }

  void _skip(int index) {
    final s = _exec[index];
    if (s == null) return;
    if (s.done < s.total) {
      s.t?.cancel();
      s.t = null;
      s.active = false;
      s.done += 1;
      s.secLeft = s.perSec;
      _finishSet(index, enforced: true);
      update();
    }
  }

  void resetExercise(int index) async {
    final s = _exec[index];
    if (dayData == null || s == null) return;
    s.t?.cancel();
    s.t = null;
    final p = _parseQty(dayData!.exercises[index].qty);
    s.total = p.item1;
    s.done = 0;
    s.perSec = p.item2;
    s.active = false;
    s.secLeft = p.item2;
    if (_doneToday.remove(index)) {
      await _saveDoneToday();
      await _saveStats();
    }
    update();
  }

  void _finishSet(int index, {required bool enforced}) async {
    final s = _exec[index];
    if (s == null) return;
    if (s.done >= s.total) {
      if (!_doneToday.contains(index)) {
        final fast = s.startedAt == null
            ? false
            : DateTime.now().difference(s.startedAt!).inSeconds <
                  (s.perSec * 0.5);
        if (settings.strict && fast) suspiciousCount += 1;
        _doneToday.add(index);
        xp += 10;
        totalDone += 1;
        await _saveDoneToday();
        await _saveStats();
        _unlockBadges();
        _updateStreak();
      }
    }
  }

  void _updateStreak() async {
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
      await _saveStats();
    }
    update();
  }

  void _unlockBadges() async {
    if (totalDone >= 1 && !badges.contains('First Rep'))
      badges.add('First Rep');
    if (totalDone >= 10 && !badges.contains('x10')) badges.add('x10');
    if (totalDone >= 50 && !badges.contains('x50')) badges.add('x50');
    if (totalDone >= 100 && !badges.contains('x100')) badges.add('x100');
    await _saveBadges();
  }

  DayData _fallback(Map<String, dynamic> ctx) {
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

  Future<void> openSettings() async {
    await showModalBottomSheet(
      context: getContext(),
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
    ScaffoldMessenger.of(getContext()).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }

  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final p = accountKey;
    xp = prefs.getInt('xp_$p') ?? 0;
    totalDone = prefs.getInt('total_$p') ?? 0;
    streak = prefs.getInt('streak_$p') ?? 0;
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
    final p = accountKey;
    await prefs.setInt('xp_$p', xp);
    await prefs.setInt('total_$p', totalDone);
    await prefs.setInt('streak_$p', streak);
    await prefs.setInt('susp_$p', suspiciousCount);
    if (lastPerfectDay != null)
      await prefs.setString('lastPerfect_$p', lastPerfectDay!);
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
}

class _ExecSheet extends StatefulWidget {
  final String name;
  final String qty;
  final ExecState state;
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
    final mm = (s.secLeft ~/ 60).toString().padLeft(2, '0');
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
            ],
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

class Tuple2<A, B> {
  final A item1;
  final B item2;
  const Tuple2(this.item1, this.item2);
}
