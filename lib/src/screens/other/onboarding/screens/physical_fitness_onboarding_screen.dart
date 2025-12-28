import 'package:choice/choice.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/widgets/other/animated_choice_chip.dart';
import 'package:yourfit/src/widgets/other/onboarding_screen.dart';

class PhysicalFitnessOnboardingScreen extends OnboardingScreen {
  const PhysicalFitnessOnboardingScreen({super.key});

  // ignore: library_private_types_in_public_api
  _PhysicalFitnessOnboardingScreenController get controller =>
      Get.put(_PhysicalFitnessOnboardingScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_PhysicalFitnessOnboardingScreenController>(
      init: _PhysicalFitnessOnboardingScreenController(),
      builder: (controller) => InlineChoice<UserPhysicalFitness>.single(
        value: controller.selectedChoice,
        onChanged: controller.setChoice,
        itemCount: controller.choices.length,
        itemBuilder: (choiceController, i) => AnimatedChoiceChip(
          selected: choiceController.selected(controller.choices[i]),
          onSelected: choiceController.onSelected(controller.choices[i]),
          selectedShadowColor: Colors.blue.shade300,
          selectedColor: Colors.blue.shade50,
          selectedLabelColor: Colors.blue,
          shadowColor: Colors.black12,
          backgroundColor: Colors.white,
          labelText: controller.choices[i].name.toTitleCase(),
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
  Map<String, dynamic> getData() => {
    "physicalFitness": controller.selectedChoice,
  };

  @override
  bool canProgress() => controller.selectedChoice != null;
}

class _PhysicalFitnessOnboardingScreenController extends GetxController {
  final choices = [
    UserPhysicalFitness.minimal,
    UserPhysicalFitness.light,
    UserPhysicalFitness.moderate,
    UserPhysicalFitness.extreme,
  ];

  UserPhysicalFitness? selectedChoice;

  void setChoice(UserPhysicalFitness? value) {
    selectedChoice = value;
    update();
  }
}
