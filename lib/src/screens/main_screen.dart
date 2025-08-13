import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/screens/other/onboarding/welcome_screen.dart';
import 'package:yourfit/src/screens/tabs/roadmap_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<_MainScreenController>(
        init: _MainScreenController(),
        builder: (controller) => controller.screens[controller.currentIndex],
      ),
      bottomNavigationBar: GetBuilder<_MainScreenController>(
        builder: (controller) => BottomNavigationBar(
          elevation: 5,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          currentIndex: controller.currentIndex,
          onTap: controller.setIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Roadmap"),
            BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit_sharp),
              label: "Test",
            ),
          ],
        ),
      ),
    );
  }
}

class _MainScreenController extends GetxController {
  final List<Widget> screens = const [RoadmapScreen(), WelcomeScreen()];
  int currentIndex = 0;

  void setIndex(int value) {
    currentIndex = value;
    update();
  }
}
