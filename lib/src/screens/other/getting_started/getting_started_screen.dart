import 'dart:convert';

import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide WidgetPaddingX;
import 'package:introduction_screen/introduction_screen.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/widgets/buttons/animated_button.dart';
import 'package:yourfit/src/widgets/onboarding_screen.dart';

import 'onboarding/user_info_onboarding_screen.dart';

class GettingStartedScreen extends StatelessWidget {
  const GettingStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_GettingStartedScreenController());

    return IntroductionScreen(
      bodyPadding: EdgeInsets.only(bottom: 0),
      key: controller.onboardingKey,
      rawPages: controller.pages,
      showDoneButton: false,
      showNextButton: false,
      isProgress: false,
      resizeToAvoidBottomInset: false,
      globalHeader: Stack(
        children: [
          GetBuilder<_GettingStartedScreenController>(
            builder: (controller) => StepProgressIndicator(
              size: 10,
              totalSteps: controller.pages.length,
              padding: 0,
              currentStep: controller.currentIndex,
              roundedEdges: const Radius.circular(10),
              crossAxisAlignment: CrossAxisAlignment.start,
              unselectedColor: Colors.black12,
              selectedColor: Colors.blue,
              progressDirection:
                  controller.previousIndex > controller.currentIndex
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            ),
          ).paddingAll(20),
          Align(
            alignment: Alignment.centerLeft,
            child: GetBuilder<_GettingStartedScreenController>(
              builder: (controller) => IconButton(
                onPressed: () =>
                    controller.onboardingKey.currentState?.previous(),
                icon: Icon(Icons.keyboard_arrow_left_rounded),
              ).showIf(controller.currentIndex > 1),
            ),
          ),
        ],
      ),
      globalFooter: SizedBox(
        height: 100,
        child: Material(
          color: Colors.white,
          elevation: 10,
          child: AnimatedButton(
            onPressed: () => controller.next(),
            child: const Text(
              "Continue",
              style: TextStyle(color: Colors.white),
            ),
          ).center(),
        ),
      ),
      onChange: controller.setCurrentIndex,
      onDone: () => Get.rootDelegate.offNamed(
        Routes.signUp,
        parameters: {"user_data": jsonEncode(controller.onboardingData)},
      ),
    );
  }
}

class _GettingStartedScreenController extends GetxController {
  final onboardingKey = GlobalKey<IntroductionScreenState>();
  final List<OnboardingScreen> pages = const [UserInfoOnboardingScreen()];

  int currentIndex = 0;
  int previousIndex = 0;
  Map<String, dynamic> onboardingData = {};

  void setCurrentIndex(int index) {
    previousIndex = currentIndex;
    currentIndex = index;

    onboardingData.addAll(pages[previousIndex].getData());
    update();
  }

  @override
  void dispose() {
    super.dispose();
    onboardingKey.currentState?.dispose();
  }

  void next() {
    bool progress = false;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => progress = pages[currentIndex].canProgress(),
    );
    if (progress) onboardingKey.currentState?.next();
  }
}
