import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/widgets/dropdown_calendar.dart';

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_RoadmapScreenController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        DropdownCalendar(
          onDaySelected: controller.setSectionTitle,
          child: const Text("Hello"),
        ),
        const SizedBox(height: 30),
        Center(
          child: Align(
            alignment: Alignment.centerLeft,
            child: GetBuilder<_RoadmapScreenController>(
              builder:
                  (controller) => Text(
                    controller.daySectionTitle,
                    style: const TextStyle(fontSize: 20),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoadmapScreenController extends GetxController {
  String daySectionTitle = "Today";

  void setSectionTitle(String value) {
    daySectionTitle = value;
    update();
  }
}
