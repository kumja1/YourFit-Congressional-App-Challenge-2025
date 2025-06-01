import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/screens/index.dart';
import 'package:yourfit/src/screens/tabs/roadmap_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<_HomeScreenController>(
        init: _HomeScreenController(),
        builder: (controller) => controller.screens[controller.currentIndex],
      ),
      bottomNavigationBar: GetBuilder<_HomeScreenController>(
        builder:
            (controller) => BottomNavigationBar(
              elevation: 5,
              landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
              currentIndex: controller.currentIndex,
              onTap: controller.setIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),


                  label: "Roadmap",
                ),
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

class _HomeScreenController extends GetxController {
  final List<Widget> screens = const [RoadmapScreen(), SignUpScreen()];
  int currentIndex = 0;

  void setIndex(int value) {
    currentIndex = value;
    update();
  }
}
