import 'dart:convert';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:yourfit/src/controllers/profile_controller.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController profile;

  int xp = 0;
  int streak = 0;
  int total = 0;
  List<String> badges = [];
  bool loadingStats = true;

  @override
  void initState() {
    super.initState();
    profile = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController(), permanent: true);
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final ctx = profile.toContext();
    final uid =
        (ctx['uid'] ?? ctx['email'] ?? ctx['user_id'] ?? '').toString().trim();
    final key = uid.isEmpty ? 'local' : uid;

    xp = prefs.getInt('xp_$key') ?? 0;
    streak = prefs.getInt('streak_$key') ?? 0;
    total = prefs.getInt('total_$key') ?? 0;
    badges = prefs.getStringList('badges_$key') ?? [];

    setState(() => loadingStats = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.colorScheme.primary;

    return GetBuilder<ProfileController>(
      builder: (_) {
        final initials = _initials(profile.firstName, profile.lastName);
        final name = _fullName(profile.firstName, profile.lastName);

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
            elevation: 0,
          ),
          body: RefreshIndicator(
            onRefresh: _loadStats,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _HeaderHero(
                  initials: initials,
                  name: name,
                  subtitle: profile.goal ?? 'Set your goal',
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    children: [
                      loadingStats
                          ? _loadingCard(context)
                          : _statsCard(context),
                      const SizedBox(height: 16),
                      _sectionCard(
                        context,
                        title: 'Training',
                        trailing: IconButton(
                          onPressed: _editTraining,
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit training',
                        ),
                        child: LayoutBuilder(
                          builder: (c, cons) {
                            final twoCols = cons.maxWidth >= 520;
                            final items = <Widget>[
                              _kvTile('Activity', profile.activityLevel ?? '—'),
                              _kvTile('Experience', profile.experience ?? '—'),
                              _kvTile(
                                'Days / week',
                                profile.daysPerWeek?.toString() ?? '—',
                              ),
                              _kvTile('Intensity', profile.intensity ?? '—'),
                            ];
                            if (twoCols) {
                              return GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 3.6,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: items,
                              );
                            }
                            return Column(
                              children: items
                                  .map((w) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: w,
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _sectionCard(
                        context,
                        title: 'Basics',
                        trailing: IconButton(
                          onPressed: _editBasics,
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit basics',
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _pill(_val(profile.age, suffix: ' yrs')),
                            _pill(_val(profile.heightCm, suffix: ' cm')),
                            _pill(_val(profile.weightKg, suffix: ' kg')),
                            _pill(profile.gender ?? '—'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _sectionCard(
                        context,
                        title: 'Equipment & Injuries',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: _editEquipRemote,
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit equipment',
                            ),
                            IconButton(
                              onPressed: _editInjuries,
                              icon: const Icon(Icons.healing),
                              tooltip: 'Edit injuries',
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _tagGroup('Equipment', profile.equipment),
                            const SizedBox(height: 12),
                            _tagGroup('Injuries', profile.injuries),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _sectionCard(
                        context,
                        title: 'Profile Context',
                        trailing: IconButton(
                          onPressed: _editGoal,
                          icon: const Icon(Icons.flag_outlined),
                          tooltip: 'Edit goal',
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            color: theme.colorScheme.surfaceVariant
                                .withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            const JsonEncoder.withIndent('  ')
                                .convert(profile.toContext()),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
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
  }

  Widget _loadingCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.black12),
      ),
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _statsCard(BuildContext context) {
    final theme = Theme.of(context);
    final lvl = 1 + xp ~/ 100;
    final pct = ((xp % 100) / 100).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.08),
            theme.colorScheme.primaryContainer.withOpacity(0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                _metricPill(
                  icon: Icons.workspace_premium,
                  label: 'Level',
                  value: 'Lvl $lvl',
                ),
                const SizedBox(width: 10),
                _metricPill(
                  icon: Icons.local_fire_department,
                  label: 'Streak',
                  value: '$streak days',
                ),
                const Spacer(),
                Text(
                  '$xp XP',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 12,
                backgroundColor: theme.colorScheme.surfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(pct * 100).round()}% to next (${100 - (xp % 100)} XP)',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _tileCard(context, 'Completed', '$total')),
                const SizedBox(width: 12),
                Expanded(
                  child: _tileCard(
                    context,
                    'Badges',
                    badges.isEmpty ? '—' : '${badges.length}',
                  ),
                ),
              ],
            ),
            if (badges.isNotEmpty) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: badges
                      .map(
                        (b) => Chip(
                          label: Text(b),
                          avatar: const Icon(Icons.verified, size: 16),
                          side: const BorderSide(color: Colors.black12),
                          backgroundColor:
                              theme.colorScheme.surface.withOpacity(0.9),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _loadStats,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricPill({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _tileCard(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  String _initials(String? first, String? last) {
    final a = (first?.isNotEmpty == true) ? first!.characters.first : 'U';
    final b = (last?.isNotEmpty == true) ? last!.characters.first : '';
    return ('$a$b').toUpperCase();
  }

  String _fullName(String? first, String? last) {
    final parts = [first, last]
        .where((e) => (e ?? '').trim().isNotEmpty)
        .toList();
    return parts.isEmpty ? '—' : parts.join(' ');
  }

  String _val(num? v, {String suffix = ''}) => (v == null) ? '—' : '$v$suffix';

  Widget _sectionCard(
    BuildContext context, {
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800)),
                const Spacer(),
                if (trailing != null) trailing,
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _kvTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w800),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagGroup(String label, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.grey.shade700, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        tags.isEmpty
            ? const Text('—')
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags
                    .map(
                      (e) => Chip(
                        label: Text(e),
                        side: const BorderSide(color: Colors.black12),
                        backgroundColor: Colors.grey.shade100,
                      ),
                    )
                    .toList(),
              ),
      ],
    );
  }

  void _editBasics() {
    final first = TextEditingController(text: profile.firstName ?? '');
    final last = TextEditingController(text: profile.lastName ?? '');
    String gender = profile.gender ?? 'male';
    final age = TextEditingController(
      text: (profile.age == null) ? '' : profile.age.toString(),
    );
    final height = TextEditingController(
      text: (profile.heightCm == null) ? '' : profile.heightCm.toString(),
    );
    final weight = TextEditingController(
      text: (profile.weightKg == null) ? '' : profile.weightKg.toString(),
    );
    _sheet(
      title: 'Edit basics',
      content: Column(
        children: [
          Row(
            children: [
              Expanded(child: _tf('First name', first)),
              const SizedBox(width: 12),
              Expanded(child: _tf('Last name', last)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _dropdown('Gender', gender, const [
                  'male',
                  'female',
                ], (v) => gender = v),
              ),
              const SizedBox(width: 12),
              Expanded(child: _num('Age', age)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _num('Height (cm)', height)),
              const SizedBox(width: 12),
              Expanded(child: _num('Weight (kg)', weight)),
            ],
          ),
        ],
      ),
      onSave: () async {
        profile.firstName =
            first.text.trim().isEmpty ? null : first.text.trim();
        profile.lastName = last.text.trim().isEmpty ? null : last.text.trim();
        profile.gender = gender;
        profile.age = int.tryParse(age.text.trim());
        profile.heightCm = int.tryParse(height.text.trim());
        profile.weightKg = int.tryParse(weight.text.trim());
        await profile.persist();
        profile.update();
        await _loadStats();
      },
    );
  }

  void _editGoal() {
    final goal = TextEditingController(text: profile.goal ?? '');
    _sheet(
      title: 'Edit goal',
      content: _tf('Goal', goal, maxLines: 3),
      onSave: () async {
        profile.goal = goal.text.trim().isEmpty ? null : goal.text.trim();
        await profile.persist();
        profile.update();
        await _loadStats();
      },
    );
  }

  void _editTraining() {
    String activity = profile.activityLevel ?? 'moderate';
    String experience = profile.experience ?? 'beginner';
    final days = TextEditingController(
      text: (profile.daysPerWeek == null) ? '' : profile.daysPerWeek.toString(),
    );
    String intensity = profile.intensity ?? 'moderate';
    _sheet(
      title: 'Edit training',
      content: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _dropdown('Activity', activity, const [
                  'minimal',
                  'light',
                  'moderate',
                  'intense',
                ], (v) => activity = v),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _dropdown('Experience', experience, const [
                  'beginner',
                  'intermediate',
                  'advanced',
                ], (v) => experience = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _num('Days / week', days)),
              const SizedBox(width: 12),
              Expanded(
                child: _dropdown('Intensity', intensity, const [
                  'low',
                  'moderate',
                  'high',
                ], (v) => intensity = v),
              ),
            ],
          ),
        ],
      ),
      onSave: () async {
        profile.activityLevel = activity;
        profile.experience = experience;
        profile.daysPerWeek = int.tryParse(days.text.trim());
        profile.intensity = intensity;
        await profile.persist();
        profile.update();
        await _loadStats();
      },
    );
  }

  Future<void> _editEquipRemote() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
          top: 12,
        ),
        child: _EquipmentPickerRemote(initialSelected: profile.equipment),
      ),
    );
    if (result != null) {
      profile.equipment = result;
      await profile.persist();
      profile.update();
      setState(() {});
    }
  }

  void _editInjuries() {
    final inj = TextEditingController(text: profile.injuries.join(', '));
    _sheet(
      title: 'Edit injuries',
      content: _tf('Injuries (comma-separated)', inj, maxLines: 2),
      onSave: () async {
        profile.injuries = inj.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        await profile.persist();
        profile.update();
      },
    );
  }

  void _sheet({
    required String title,
    required Widget content,
    required VoidCallback onSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final bottom = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, bottom + 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              content,
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        onSave();
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tf(String label, TextEditingController c, {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _num(String label, TextEditingController c) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String> onChanged,
  ) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _HeaderHero extends StatelessWidget {
  final String initials;
  final String name;
  final String subtitle;
  const _HeaderHero({
    required this.initials,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grad = LinearGradient(
      colors: [
        theme.colorScheme.primary,
        theme.colorScheme.secondary,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      decoration: BoxDecoration(gradient: grad),
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: Colors.white,
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> editEquipmentRemote(
  BuildContext context, {
  required List<String> initial,
  required ValueChanged<List<String>> onSave,
}) async {
  final result = await showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
        top: 12,
      ),
      child: _EquipmentPickerRemote(initialSelected: initial),
    ),
  );
  if (result != null) onSave(result);
}

class _EquipmentPickerRemote extends StatefulWidget {
  final List<String> initialSelected;
  const _EquipmentPickerRemote({required this.initialSelected});
  @override
  State<_EquipmentPickerRemote> createState() => _EquipmentPickerRemoteState();
}

class _EquipmentPickerRemoteState extends State<_EquipmentPickerRemote> {
  final TextEditingController _searchCtrl = TextEditingController();
  late final Set<String> _selected = widget.initialSelected.toSet();
  List<String> _catalog = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      _catalog = await _fetchEquipmentCatalog();
    } catch (e) {
      _error = e.toString();
    }
    setState(() {
      _loading = false;
    });
  }

  Future<List<String>> _fetchEquipmentCatalog() async {
    final List<String> items = [];
    String? url = 'https://wger.de/api/v2/equipment/?limit=200';
    int guard = 0;
    while (url != null && guard < 12) {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final results = (data['results'] as List?) ?? const [];
      for (final r in results) {
        final name = r['name']?.toString().trim();
        if (name != null && name.isNotEmpty) items.add(name);
      }
      url = data['next']?.toString();
      guard++;
    }
    final out = items.toSet().toList();
    out.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return out;
  }

  Iterable<String> _optionsFor(String query) {
    final q = query.trim().toLowerCase();
    final base = _catalog.where((e) => !_selected.contains(e));
    if (q.isEmpty) return base.take(15);
    return base.where((e) => e.toLowerCase().contains(q)).take(15);
  }

  void _add(String item) {
    final v = item.trim();
    if (v.isEmpty) return;
    setState(() => _selected.add(v));
    _searchCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SizedBox(
        height: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Edit equipment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      );
    }
    if (_error != null) {
      return SizedBox(
        height: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Edit equipment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const Text('Failed to load catalog:'),
            Text('$_error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Edit equipment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue v) => _optionsFor(v.text),
            onSelected: _add,
            fieldViewBuilder: (ctx, textController, focusNode, onSubmit) {
              return TextField(
                controller: textController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: 'Add equipment',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (textController.text.isNotEmpty) {
                        _add(textController.text);
                        textController.clear();
                      }
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (val) {
                  if (val.isNotEmpty) {
                    _add(val);
                    textController.clear();
                  }
                },
              );
            },
            optionsViewBuilder: (ctx, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 280,
                      minWidth: 320,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (ctx, i) {
                        final opt = options.elementAt(i);
                        return ListTile(
                          dense: true,
                          title: Text(opt),
                          onTap: () => onSelected(opt),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selected
                  .map(
                    (e) => Chip(
                      label: Text(e),
                      onDeleted: () => setState(() => _selected.remove(e)),
                      side: const BorderSide(color: Colors.black12),
                      backgroundColor: Colors.grey.shade100,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () =>
                      Navigator.pop(context, _selected.toList()),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
