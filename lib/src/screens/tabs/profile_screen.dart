import 'package:auto_route/annotations.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide WidgetPaddingX;
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/utils/mixins/input_validation_mixin.dart';
import 'package:yourfit/src/widgets/textfields/number_form_field.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_ProfileScreenController());
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 16,
          children: [
            _ProfileHeader(controller: controller),
            const SizedBox(height: 16),

            _GoalSection(controller: controller),
            const SizedBox(height: 16),

            _TrainingSection(controller: controller),
            const SizedBox(height: 16),

            _EquipmentSection(controller: controller),
            const SizedBox(height: 16),
          ],
        ),
      ).scrollable(),
    );
  }
}

class _ProfileScreenController extends GetxController
    with InputValidationMixin {
  final Rx<UserData?> currentUser = Get.find<AuthService>().currentUser;
  final formKey = GlobalKey<FormState>();

  void editBasics() async {
    if (currentUser.value == null) return;

    await showBottomFormSheet(
      title: 'Edit Basics',
      fields: [
        TextFormField(
          initialValue: currentUser.value!.firstName,
          decoration: const InputDecoration(labelText: 'First name'),
          validator: (v) => validateString(v, valueName: "First Name"),
          onSaved: (v) =>
              currentUser.update((user) => user?.firstName = v!.trim()),
        ),
        TextFormField(
          initialValue: currentUser.value!.lastName,
          decoration: const InputDecoration(labelText: 'Last name'),
          validator: (v) => validateString(v, valueName: "Last Name"),
          onSaved: (v) =>
              currentUser.update((user) => user?.lastName = v!.trim()),
        ),
        DropdownButtonFormField<UserGender>(
          initialValue: currentUser.value?.gender,
          items: [UserGender.male, UserGender.female]
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name.toTitleCase()),
                ),
              )
              .toList(),
          decoration: const InputDecoration(
            labelText: 'Gender',
            border: OutlineInputBorder(),
          ),
          onSaved: (v) =>
              currentUser.update((user) => v == null ? null : user?.gender = v),
          onChanged: null,
        ),
        NumberFormField(
          initialValue: currentUser.value?.height,
          labelText: 'Height (cm)',
          onSaved: (v) => currentUser.update((user) => user?.height = v),
        ),
        NumberFormField(
          initialValue: currentUser.value?.weight,
          labelText: 'Weight (kg)',
          onSaved: (v) => currentUser.update((user) => user?.weight = v),
        ),
      ],
    );
  }

  void editGoal() async {
    if (currentUser.value == null) return;

    await showBottomFormSheet(
      title: 'Edit Goal',
      fields: [
        TextFormField(
          initialValue: currentUser.value?.goal,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Goal',
            border: OutlineInputBorder(),
          ),
          onSaved: (v) =>
              currentUser.update((user) => user?.goal = v?.trim() ?? ""),
        ),
      ],
    );
  }

  void editTraining() async {
    if (currentUser.value == null) return;

    await showBottomFormSheet(
      title: 'Edit Training',
      fields: [
        DropdownButtonFormField<UserPhysicalFitness>(
          initialValue: currentUser.value?.physicalFitness,
          items: UserPhysicalFitness.values
              .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
              .toList(),
          decoration: const InputDecoration(labelText: 'Activity'),
          onSaved: (v) => currentUser.update(
            (user) => v == null ? null : user?.physicalFitness = v,
          ),
          onChanged: null,
        ),
        NumberFormField(
          initialValue: currentUser.value?.exerciseDaysPerWeek,
          labelText: 'Days / week',
          onSaved: (v) =>
              currentUser.update((user) => user?.exerciseDaysPerWeek = v),
        ),
      ],
    );
  }

  void editEquipment() async {
    if (currentUser.value == null) return;

    await showBottomFormSheet(
      title: 'Edit Equipment',
      fields: [
        TextFormField(
          initialValue: (currentUser.value!.equipment).join(', '),
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Equipment (comma-separated)',
            border: OutlineInputBorder(),
          ),
          onSaved: (v) => currentUser.update((user) {
            user?.equipment.clear();
            user?.equipment.addAll(
              v == null || v.isEmpty ? [] : v.removeAllWhitespace.split(","),
            );
          }),
        ),
      ],
    );
  }

  void editDisabilities() {
    if (currentUser.value == null) return;

    showBottomFormSheet(
      title: 'Edit Disabilities',
      fields: [
        TextFormField(
          initialValue: (currentUser.value!.disabilities).join(', '),
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Disabilities (comma-separated)',
            border: OutlineInputBorder(),
          ),
          validator: (v) => validateString(v, valueName: "Disabilities"),
          onSaved: (v) => currentUser.update((user) {
            user?.disabilities.clear();
            user?.disabilities.addAll(
              v!.isEmpty ? [] : v.removeAllWhitespace.split(","),
            );
          }),
        ),
      ],
    );
  }

  Future<void> showBottomFormSheet({
    required String title,
    required List<Widget> fields,
  }) async => await showModalBottomSheet(
    context: Get.context!,
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
            ...fields.map(
              (field) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: field,
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
                        if (ctx.mounted) Navigator.pop(ctx);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ).scrollable(),
      ),
    ),
  );
}

class _ProfileSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _ProfileSectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final _ProfileScreenController controller;
  final Rx<UserData?> currentUser;

  _ProfileHeader({required this.controller})
    : currentUser = controller.currentUser;

  @override
  Widget build(BuildContext context) {
    return currentUser.value == null
        ? const SizedBox.shrink()
        : Card(
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
                    child: Obx(
                      () => Text(
                        currentUser.value?.intials ?? "",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            currentUser.value?.fullName ?? "-",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _Pill(
                                _formatValue(
                                  currentUser.value?.age,
                                  suffix: ' yrs',
                                ),
                              ),
                              _Pill(
                                _formatValue(
                                  currentUser.value?.height,
                                  suffix: ' cm',
                                ),
                              ),
                              _Pill(
                                _formatValue(
                                  currentUser.value?.weight,
                                  suffix: ' kg',
                                ),
                              ),
                              _Pill(
                                currentUser.value?.gender.name.toTitleCase() ??
                                    '—',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.editBasics(),
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          );
  }

  String _formatValue(num? value, {String suffix = ''}) =>
      value == null ? '—' : '$value$suffix';
}

class _GoalSection extends StatelessWidget {
  final _ProfileScreenController controller;
  final Rx<UserData?> currentUser;

  _GoalSection({required this.controller})
    : currentUser = controller.currentUser;

  @override
  Widget build(BuildContext context) {
    return currentUser.value == null
        ? const SizedBox.shrink()
        : _ProfileSectionCard(
            title: 'Goal',
            trailing: IconButton(
              onPressed: () => controller.editGoal(),
              icon: const Icon(Icons.edit),
            ),
            child: Obx(
              () => Text(
                currentUser.value?.goal ?? '—',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
  }
}

class _TrainingSection extends StatelessWidget {
  final _ProfileScreenController controller;
  final Rx<UserData?> currentUser;

  _TrainingSection({required this.controller})
    : currentUser = controller.currentUser;

  @override
  Widget build(BuildContext context) {
    return currentUser.value == null
        ? const SizedBox.shrink()
        : _ProfileSectionCard(
            title: 'Training',
            trailing: IconButton(
              onPressed: () => controller.editTraining(),
              icon: const Icon(Icons.edit),
            ),
            child: Column(
              children: [
                Obx(
                  () => _InfoTile(
                    'Fitness',
                    currentUser.value?.physicalFitness.name ?? '—',
                  ),
                ),
                Obx(
                  () => _InfoTile(
                    'Days / week',
                    currentUser.value?.exerciseDaysPerWeek.toString() ?? '—',
                  ),
                ),
                Obx(
                  () => _InfoTile(
                    'Intensity',
                    currentUser.value?.exercisesIntensity.name.toTitleCase() ??
                        '—',
                  ),
                ),
              ],
            ),
          );
  }
}

class _EquipmentSection extends StatelessWidget {
  final _ProfileScreenController controller;
  final Rx<UserData?> currentUser;

  _EquipmentSection({required this.controller})
    : currentUser = controller.currentUser;

  @override
  Widget build(BuildContext context) {
    return currentUser.value == null
        ? const SizedBox.shrink()
        : _ProfileSectionCard(
            title: 'Equipment & Disabilties',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => controller.editEquipment(),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => controller.editDisabilities(),
                  icon: const Icon(Icons.healing),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => _TagGroup(
                    label: 'Equipment',
                    tags: currentUser.value!.equipment,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => _TagGroup(
                    label: 'Disabilities',
                    tags: currentUser.value!.disabilities,
                  ),
                ),
              ],
            ),
          );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile(this.label, this.value);

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black12),
      color: Colors.white12,
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
    ).paddingAll(12),
  );
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill(this.text);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: const BoxDecoration(
      border: Border.fromBorderSide(BorderSide(color: Colors.black12)),
      color: Colors.white60,
      borderRadius: BorderRadius.all(Radius.circular(999)),
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
