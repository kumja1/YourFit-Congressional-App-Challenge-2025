import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide WidgetPaddingX;
import 'package:introduction_screen/introduction_screen.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/screens/other/onboarding/screens/activity_level_onboarding_screen.dart';
import 'package:yourfit/src/screens/other/onboarding/screens/user_info_onboarding_screen.dart';
import 'package:yourfit/src/widgets/buttons/animated_button.dart';
import 'package:yourfit/src/widgets/onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_WelcomeScreenController());

    return IntroductionScreen(
      key: controller.onboardingKey,
      bodyPadding: EdgeInsets.only(bottom: 0),
      animationDuration: 800,
      rawPages: controller.pages,
      showDoneButton: false,
      showNextButton: false,
      isProgress: false,
      globalHeader: Row(
        spacing: 2,
        children: [
          GetBuilder<_WelcomeScreenController>(
            builder: (controller) => IconButton(
              onPressed: () =>
                  controller.onboardingKey.currentState?.previous(),
              icon: Icon(
                Icons.keyboard_arrow_left_rounded,
                color: Colors.black26,
              ),
            ).showIf(controller.currentIndex >= 1),
          ),
          GetBuilder<_WelcomeScreenController>(
            builder: (controller) => StepProgressIndicator(
              size: 10,
              totalSteps: controller.pages.length,
              padding: 0,
              currentStep: controller.currentIndex,
              roundedEdges: const Radius.circular(10),
              crossAxisAlignment: CrossAxisAlignment.start,
              unselectedColor: Colors.black12,
              selectedColor: Colors.blue,
              progressDirection: TextDirection.ltr,
            ),
          ).paddingAll(20).expanded(),
        ],
      ),
      globalFooter: SizedBox(
        height: 100,
        child: AnimatedButton(
          onPressed: () => controller.next(),
          child: const Text("Continue", style: TextStyle(color: Colors.white)),
        ).center(),
      ),
    );
  }
}

class _WelcomeScreenController extends GetxController {
  final onboardingKey = GlobalKey<IntroductionScreenState>();
  final List<OnboardingScreen> pages = const [
    UserInfoOnboardingScreen(),
    ActivityLevelOnboardingScreen(),
  ];

  int currentIndex = 0;
  int previousIndex = 0;
  Map<String, dynamic> onboardingData = {};

  void setCurrentIndex(int index) {
    previousIndex = currentIndex;
    currentIndex = index;
    update();

    final data = pages[previousIndex].getData();
    if (data != null) {
      onboardingData.addAll(data);
    }
  }

  @override
  void dispose() {
    super.dispose();
    onboardingKey.currentState?.dispose();
  }

  void next() async {
    bool progress = pages[currentIndex].canProgress();
    if (progress) {
      setCurrentIndex(currentIndex + 1);
      onboardingKey.currentState?.next();
      if (currentIndex == pages.length) {
        await Get.rootDelegate.toNamed(
          Routes.signUp,
          arguments: onboardingData,
        );
      }
    }
  }
}
