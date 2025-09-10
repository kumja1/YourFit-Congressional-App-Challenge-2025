import 'dart:convert';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import 'profile_section_card.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController profile;

  @override
  void initState() {
    super.initState();
    profile = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController(), permanent: true);
    profile.load();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (p) => Scaffold(
        appBar: _buildAppBar(p),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (p.error != null) _ErrorBanner(error: p.error!),
                _ProfileHeader(
                  profile: p,
                  onEdit: p.loading ? null : _editBasics,
                ),
                const SizedBox(height: 16),
                ProfileSectionCard(
                  title: 'Goal',
                  trailing: _editButton(p.loading ? null : _editGoal),
                  child: Text(
                    p.goal ?? '—',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ProfileSectionCard(
                  title: 'Training',
                  trailing: _editButton(p.loading ? null : _editTraining),
                  child: Column(
                    children: [
                      _kvTile('Activity', p.activityLevel ?? '—'),
                      _kvTile('Experience', p.experience ?? '—'),
                      _kvTile('Days / week', p.daysPerWeek?.toString() ?? '—'),
                      _kvTile('Intensity', p.intensity ?? '—'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ProfileSectionCard(
                  title: 'Equipment & Injuries',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _editButton(_editEquipment),
                      IconButton(
                        onPressed: _editInjuries,
                        icon: const Icon(Icons.healing),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TagGroup(label: 'Equipment', tags: p.equipment),
                      const SizedBox(height: 12),
                      _TagGroup(label: 'Injuries', tags: p.injuries),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _JsonDebugCard(data: profile.toContext()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(ProfileController p) => AppBar(
    title: Text('Profile'),
    centerTitle: true,
    actions: [
      IconButton(
        onPressed: p.loading ? null : p.load,
        icon: const Icon(Icons.refresh),
      ),
      IconButton(
        onPressed: p.loading ? null : _save,
        icon: const Icon(Icons.save),
      ),
    ],
  );

  Future<void> _save() async {
    await profile.persist();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Saved')));
  }

  Widget _editButton(VoidCallback? onPressed) =>
      IconButton(onPressed: onPressed, icon: const Icon(Icons.edit));

  Widget _kvTile(String label, String value) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black12),
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );

  void _editBasics() => _showEditSheet(
    title: 'Edit basics',
    fields: [
      _RowFields([
        _TextField('First name', profile.firstName),
        _TextField('Last name', profile.lastName),
      ]),
      _RowFields([
        _DropdownField('Gender', profile.gender ?? 'male', const [
          'male',
          'female',
        ]),
        _NumberField('Age', profile.age),
      ]),
      _RowFields([
        _NumberField('Height (cm)', profile.heightCm),
        _NumberField('Weight (kg)', profile.weightKg),
      ]),
    ],
    onSave: (values) {
      profile
        ..firstName = values['First name']
        ..lastName = values['Last name']
        ..gender = values['Gender']
        ..age = values['Age'] as int?
        ..heightCm = values['Height (cm)'] as int?
        ..weightKg = values['Weight (kg)'] as int?;
    },
  );

  void _editGoal() => _showEditSheet(
    title: 'Edit goal',
    fields: [_TextField('Goal', profile.goal, maxLines: 3)],
    onSave: (values) => profile.goal = values['Goal'],
  );

  void _editTraining() => _showEditSheet(
    title: 'Edit training',
    fields: [
      _RowFields([
        _DropdownField('Activity', profile.activityLevel ?? 'moderate', const [
          'minimal',
          'light',
          'moderate',
          'intense',
        ]),
        _DropdownField('Experience', profile.experience ?? 'beginner', const [
          'beginner',
          'intermediate',
          'advanced',
        ]),
      ]),
      _RowFields([
        _NumberField('Days / week', profile.daysPerWeek),
        _DropdownField('Intensity', profile.intensity ?? 'moderate', const [
          'low',
          'moderate',
          'high',
        ]),
      ]),
    ],
    onSave: (values) {
      profile
        ..activityLevel = values['Activity']
        ..experience = values['Experience']
        ..daysPerWeek = values['Days / week'] as int?
        ..intensity = values['Intensity'];
    },
  );

  void _editEquipment() => _showEditSheet(
    title: 'Edit equipment',
    fields: [
      _TextField(
        'Equipment (comma-separated)',
        profile.equipment.join(', '),
        maxLines: 2,
      ),
    ],
    onSave: (values) => profile.equipment = _parseList(
      values['Equipment (comma-separated)'] ?? '',
    ),
  );

  void _editInjuries() => _showEditSheet(
    title: 'Edit injuries',
    fields: [
      _TextField(
        'Injuries (comma-separated)',
        profile.injuries.join(', '),
        maxLines: 2,
      ),
    ],
    onSave: (values) => profile.injuries = _parseList(
      values['Injuries (comma-separated)'] ?? '',
    ),
  );

  List<String> _parseList(String text) =>
      text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  void _showEditSheet({
    required String title,
    required List<_FieldConfig> fields,
    required void Function(Map<String, dynamic>) onSave,
  }) {
    final controllers = <String, dynamic>{};
    final values = <String, dynamic>{};

    for (final field in fields) {
      if (field is _RowFields) {
        for (final f in field.fields) {
          _initField(f, controllers, values);
        }
      } else {
        _initField(field, controllers, values);
      }
    }

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
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...fields.map((f) => _buildField(f, controllers, values)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        _collectValues(controllers, values);
                        onSave(values);
                        await profile.persist();
                        profile.update();
                        if (!mounted) return;
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                      child: Text('Save'),
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

  void _initField(
    _FieldConfig field,
    Map<String, dynamic> controllers,
    Map<String, dynamic> values,
  ) {
    if (field is _TextField || field is _NumberField) {
      final initial = field is _TextField
          ? field.initial
          : (field as _NumberField).initial?.toString();
      controllers[field.label] = TextEditingController(text: initial ?? '');
    } else if (field is _DropdownField) {
      values[field.label] = field.initial;
    }
  }

  Widget _buildField(
    _FieldConfig field,
    Map<String, dynamic> controllers,
    Map<String, dynamic> values,
  ) {
    if (field is _RowFields) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children:
              field.fields
                  .expand(
                    (f) => [
                      Expanded(
                        child: _buildSingleField(f, controllers, values),
                      ),
                      const SizedBox(width: 12),
                    ],
                  )
                  .toList()
                ..removeLast(),
        ),
      );
    }
    return _buildSingleField(field, controllers, values);
  }

  Widget _buildSingleField(
    _FieldConfig field,
    Map<String, dynamic> controllers,
    Map<String, dynamic> values,
  ) {
    if (field is _TextField) {
      return TextField(
        controller: controllers[field.label],
        maxLines: field.maxLines,
        decoration: InputDecoration(
          labelText: field.label,
          border: const OutlineInputBorder(),
        ),
      );
    } else if (field is _NumberField) {
      return TextField(
        controller: controllers[field.label],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: field.label,
          border: const OutlineInputBorder(),
        ),
      );
    } else if (field is _DropdownField) {
      return StatefulBuilder(
        builder: (context, setState) => InputDecorator(
          decoration: InputDecoration(
            labelText: field.label,
            border: const OutlineInputBorder(),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: values[field.label],
              items: field.items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => values[field.label] = v),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _collectValues(
    Map<String, dynamic> controllers,
    Map<String, dynamic> values,
  ) {
    controllers.forEach((key, controller) {
      if (controller is! TextEditingController) return;
      final text = controller.text.trim();

      const numberKeys = {'Age', 'Height (cm)', 'Weight (kg)', 'Days / week'};

      if (numberKeys.contains(key)) {
        values[key] = text.isEmpty ? null : int.tryParse(text);
      } else {
        values[key] = text.isEmpty ? null : text;
      }
    });
  }
}

abstract class _FieldConfig {
  final String label;
  const _FieldConfig(this.label);
}

class _TextField extends _FieldConfig {
  final String? initial;
  final int maxLines;
  const _TextField(String label, this.initial, {this.maxLines = 1})
    : super(label);
}

class _NumberField extends _FieldConfig {
  final int? initial;
  const _NumberField(String label, this.initial) : super(label);
}

class _DropdownField extends _FieldConfig {
  final String initial;
  final List<String> items;
  const _DropdownField(String label, this.initial, this.items) : super(label);
}

class _RowFields extends _FieldConfig {
  final List<_FieldConfig> fields;
  const _RowFields(this.fields) : super('');
}

class _ProfileHeader extends StatelessWidget {
  final ProfileController profile;
  final VoidCallback? onEdit;

  const _ProfileHeader({required this.profile, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(profile.firstName, profile.lastName);
    final fullName = _getFullName(profile.firstName, profile.lastName);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Pill(_formatValue(profile.age, suffix: ' yrs')),
                      _Pill(_formatValue(profile.heightCm, suffix: ' cm')),
                      _Pill(_formatValue(profile.weightKg, suffix: ' kg')),
                      _Pill(profile.gender ?? '—'),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
          ],
        ),
      ),
    );
  }

  String _getInitials(String? first, String? last) {
    final a = first?.isNotEmpty == true ? first!.characters.first : 'U';
    final b = last?.isNotEmpty == true ? last!.characters.first : '';
    return '$a$b'.toUpperCase();
  }

  String _getFullName(String? first, String? last) {
    final parts = [
      first,
      last,
    ].where((e) => e?.trim().isNotEmpty == true).toList();
    return parts.isEmpty ? '—' : parts.join(' ');
  }

  String _formatValue(num? value, {String suffix = ''}) =>
      value == null ? '—' : '$value$suffix';
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill(this.text);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black12),
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
    ),
  );
}

class _TagGroup extends StatelessWidget {
  final String label;
  final List<String> tags;

  const _TagGroup({required this.label, required this.tags});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      tags.isEmpty
          ? Text('—')
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

class _ErrorBanner extends StatelessWidget {
  final String error;
  const _ErrorBanner({required this.error});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.06),
      border: Border.all(color: Colors.red.withOpacity(0.2)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(error, style: const TextStyle(color: Colors.red)),
  );
}

class _JsonDebugCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _JsonDebugCard({required this.data});

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Colors.black12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        const JsonEncoder.withIndent('  ').convert(data),
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    ),
  );
}
