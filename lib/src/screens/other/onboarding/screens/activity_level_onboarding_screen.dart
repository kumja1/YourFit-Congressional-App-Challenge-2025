import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/widgets/animated_choice_chip.dart';
import 'package:yourfit/src/widgets/onboarding_screen.dart';

class ActivityLevelOnboardingScreen extends OnboardingScreen {
  const ActivityLevelOnboardingScreen({super.key});

  _ActivityLevelOnboardingScreenController get _controller =>
      Get.put(_ActivityLevelOnboardingScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_ActivityLevelOnboardingScreenController>(
      init: _ActivityLevelOnboardingScreenController(),
      builder: (_) => InlineChoice<UserPhysicalActivity>.single(
        value: _controller.selectedChoice,
        onChanged: _controller.setChoice,
        itemCount: _controller.choices.length,
        itemBuilder: (controller, i) => AnimatedChoiceChip(
          selected: controller.selected(_controller.choices[i]),
          onSelected: controller.onSelected(_controller.choices[i]),
          selectedShadowColor: Colors.blue.shade300,
          selectedColor: Colors.blue.shade50,
          selectedLabelColor: Colors.blue,
          shadowColor: Colors.black12,
          backgroundColor: Colors.white,
          labelText: _controller.choices[i].toString(),
        ),
        listBuilder: (itemBuilder, count) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 15,
          children: List.generate(count, itemBuilder),
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> getData() {
    return {"activityLevel": _controller.selectedChoice};
  }

  @override
  bool canProgress() => _controller.selectedChoice != null;
}

class _ActivityLevelOnboardingScreenController extends GetxController {
  final choices = [
    UserPhysicalActivity.minimal,
    UserPhysicalActivity.light,
    UserPhysicalActivity.moderate,
    UserPhysicalActivity.intense,
  ];

  UserPhysicalActivity? selectedChoice;

  void setChoice(UserPhysicalActivity? value) {
    selectedChoice = value;
    update();
  }
}
