import 'dart:convert';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../widgets/profile/profile_section_card.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController(), permanent: true);

    return Scaffold(
      appBar: _AppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Obx(
            () => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (controller.error.value != null)
                  _ErrorBanner(message: controller.error.value!),

                _ProfileHeader(controller: controller),
                const SizedBox(height: 16),

                _GoalSection(controller: controller),
                const SizedBox(height: 16),

                _TrainingSection(controller: controller),
                const SizedBox(height: 16),

                _EquipmentSection(controller: controller),
                const SizedBox(height: 16),

                _JsonDebugCard(data: controller.toContext()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return AppBar(
      title: const Text('Profile'),
      centerTitle: true,
      actions: [
        Obx(
          () => IconButton(
            onPressed: controller.loading.value ? null : controller.load,
            icon: const Icon(Icons.refresh),
          ),
        ),
        Obx(
          () => IconButton(
            onPressed: controller.loading.value ? null : () => _save(context),
            icon: const Icon(Icons.save),
          ),
        ),
      ],
    );
  }

  Future<void> _save(BuildContext context) async {
    final controller = Get.find<ProfileController>();
    await controller.persist();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved')));
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ProfileHeader extends StatelessWidget {
  final ProfileController controller;

  const _ProfileHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = controller.profile.value;
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
              IconButton(
                onPressed: controller.loading.value
                    ? null
                    : () => _EditDialog.basics(context, controller),
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _getInitials(String? first, String? last) {
    final a = (first?.isNotEmpty ?? false) ? first![0] : 'U';
    final b = (last?.isNotEmpty ?? false) ? last![0] : '';
    return '$a$b'.toUpperCase();
  }

  String _getFullName(String? first, String? last) {
    final parts = [first, last].where((e) => e?.trim().isNotEmpty ?? false);
    return parts.isEmpty ? '—' : parts.join(' ');
  }

  String _formatValue(num? value, {String suffix = ''}) =>
      value == null ? '—' : '$value$suffix';
}

class _GoalSection extends StatelessWidget {
  final ProfileController controller;

  const _GoalSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ProfileSectionCard(
        title: 'Goal',
        trailing: IconButton(
          onPressed: controller.loading.value
              ? null
              : () => _EditDialog.goal(context, controller),
          icon: const Icon(Icons.edit),
        ),
        child: Text(
          controller.profile.value.goal ?? '—',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _TrainingSection extends StatelessWidget {
  final ProfileController controller;

  const _TrainingSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = controller.profile.value;
      return ProfileSectionCard(
        title: 'Training',
        trailing: IconButton(
          onPressed: controller.loading.value
              ? null
              : () => _EditDialog.training(context, controller),
          icon: const Icon(Icons.edit),
        ),
        child: Column(
          children: [
            _InfoTile('Activity', profile.activityLevel ?? '—'),
            _InfoTile('Experience', profile.experience ?? '—'),
            _InfoTile('Days / week', profile.daysPerWeek?.toString() ?? '—'),
            _InfoTile('Intensity', profile.intensity ?? '—'),
          ],
        ),
      );
    });
  }
}

class _EquipmentSection extends StatelessWidget {
  final ProfileController controller;

  const _EquipmentSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ProfileSectionCard(
        title: 'Equipment & Injuries',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _EditDialog.equipment(context, controller),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => _EditDialog.injuries(context, controller),
              icon: const Icon(Icons.healing),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TagGroup(
              label: 'Equipment',
              tags: controller.profile.value.equipment,
            ),
            const SizedBox(height: 12),
            _TagGroup(
              label: 'Injuries',
              tags: controller.profile.value.injuries,
            ),
          ],
        ),
      ),
    );
  }
}

class _EditDialog {
  static void basics(BuildContext context, ProfileController controller) {
    final profile = controller.profile.value;
    _show(
      context: context,
      title: 'Edit Basics',
      fields: {
        'firstName': _Field.text('First name', profile.firstName),
        'lastName': _Field.text('Last name', profile.lastName),
        'gender': _Field.dropdown('Gender', profile.gender ?? 'male', [
          'male',
          'female',
        ]),
        'age': _Field.number('Age', profile.age),
        'heightCm': _Field.number('Height (cm)', profile.heightCm),
        'weightKg': _Field.number('Weight (kg)', profile.weightKg),
      },
      onSave: (values) {
        controller.profile.update((p) {
          p?.firstName = values['firstName'];
          p?.lastName = values['lastName'];
          p?.gender = values['gender'];
          p?.age = values['age'];
          p?.heightCm = values['heightCm'];
          p?.weightKg = values['weightKg'];
        });
      },
    );
  }

  static void goal(BuildContext context, ProfileController controller) {
    _show(
      context: context,
      title: 'Edit Goal',
      fields: {
        'goal': _Field.text('Goal', controller.profile.value.goal, maxLines: 3),
      },
      onSave: (values) {
        controller.profile.update((p) => p?.goal = values['goal']);
      },
    );
  }

  static void training(BuildContext context, ProfileController controller) {
    final profile = controller.profile.value;
    _show(
      context: context,
      title: 'Edit Training',
      fields: {
        'activityLevel': _Field.dropdown(
          'Activity',
          profile.activityLevel ?? 'moderate',
          ['minimal', 'light', 'moderate', 'intense'],
        ),
        'experience': _Field.dropdown(
          'Experience',
          profile.experience ?? 'beginner',
          ['beginner', 'intermediate', 'advanced'],
        ),
        'daysPerWeek': _Field.number('Days / week', profile.daysPerWeek),
        'intensity': _Field.dropdown(
          'Intensity',
          profile.intensity ?? 'moderate',
          ['low', 'moderate', 'high'],
        ),
      },
      onSave: (values) {
        controller.profile.update((p) {
          p?.activityLevel = values['activityLevel'];
          p?.experience = values['experience'];
          p?.daysPerWeek = values['daysPerWeek'];
          p?.intensity = values['intensity'];
        });
      },
    );
  }

  static void equipment(BuildContext context, ProfileController controller) {
    _show(
      context: context,
      title: 'Edit Equipment',
      fields: {
        'equipment': _Field.list(
          'Equipment (comma-separated)',
          controller.profile.value.equipment,
        ),
      },
      onSave: (values) {
        controller.profile.update((p) => p?.equipment = values['equipment']);
      },
    );
  }

  static void injuries(BuildContext context, ProfileController controller) {
    _show(
      context: context,
      title: 'Edit Injuries',
      fields: {
        'injuries': _Field.list(
          'Injuries (comma-separated)',
          controller.profile.value.injuries,
        ),
      },
      onSave: (values) {
        controller.profile.update((p) => p?.injuries = values['injuries']);
      },
    );
  }

  static void _show({
    required BuildContext context,
    required String title,
    required Map<String, _Field> fields,
    required void Function(Map<String, dynamic>) onSave,
  }) {
    final controller = Get.find<ProfileController>();
    final formKey = GlobalKey<FormState>();
    final values = <String, dynamic>{};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          MediaQuery.of(ctx).viewInsets.bottom + 12,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              ...fields.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: e.value.build((value) => values[e.key] = value),
                ),
              ),
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
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          formKey.currentState?.save();
                          onSave(values);
                          await controller.persist();
                          if (ctx.mounted) Navigator.pop(ctx);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field {
  final String label;
  final dynamic initial;
  final FieldType type;
  final int maxLines;
  final List<String>? items;

  const _Field._({
    required this.label,
    this.initial,
    required this.type,
    this.maxLines = 1,
    this.items,
  });

  static _Field text(String label, dynamic initial, {int maxLines = 1}) =>
      _Field._(
        label: label,
        initial: initial,
        type: FieldType.text,
        maxLines: maxLines,
      );

  static _Field number(String label, int? initial) =>
      _Field._(label: label, initial: initial, type: FieldType.number);

  static _Field dropdown(String label, String initial, List<String> items) =>
      _Field._(
        label: label,
        initial: initial,
        type: FieldType.dropdown,
        items: items,
      );

  static _Field list(String label, List<String> initial) => _Field._(
    label: label,
    initial: initial.join(', '),
    type: FieldType.list,
    maxLines: 2,
  );

  Widget build(Function(dynamic) onSaved) {
    switch (type) {
      case FieldType.text:
      case FieldType.list:
        return TextFormField(
          initialValue: initial?.toString(),
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          onSaved: (v) => onSaved(
            type == FieldType.list
                ? _parseList(v ?? '')
                : v?.trim().isEmpty ?? true
                ? null
                : v?.trim(),
          ),
        );

      case FieldType.number:
        return TextFormField(
          initialValue: initial?.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          validator: (v) {
            if (v?.isNotEmpty ?? false) {
              if (int.tryParse(v!) == null) return 'Enter a valid number';
            }
            return null;
          },
          onSaved: (v) => onSaved(
            v?.trim().isEmpty ?? true ? null : int.tryParse(v!.trim()),
          ),
        );

      case FieldType.dropdown:
        return DropdownButtonFormField<String>(
          value: initial,
          items: items!
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          onSaved: (v) => onSaved(v),
          onChanged: (String? value) {},
        );
    }
  }

  static List<String> _parseList(String text) =>
      text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
}

enum FieldType { text, number, dropdown, list }

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile(this.label, this.value);

  @override
  Widget build(BuildContext context) => Container(
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

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.06),
      border: Border.all(color: Colors.red.withOpacity(0.2)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(message, style: const TextStyle(color: Colors.red)),
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
