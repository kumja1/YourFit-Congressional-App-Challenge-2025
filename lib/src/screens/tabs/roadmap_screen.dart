import 'package:const_date_time/const_date_time.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:extensions_plus/extensions_plus.dart' show DateTimeExtension;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/widgets/dropdown_calendar.dart';

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_RoadmapScreenController());

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DropdownCalendar(
            child: Align(alignment: Alignment.bottomLeft, child: Text("Hello")),
          ).paddingOnly(bottom: 30, top: 60),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GetBuilder<_RoadmapScreenController>(
                builder:
                    (controller) => Text(
                      controller.daySectionTitle,
                      style: const TextStyle(fontSize: 20),
                    ),
              ),
              IconButton(
                onPressed: controller.selectDate,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 29.5,
                  height: 29.5,
                ),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoadmapScreenController extends GetxController {
  final AuthService _authService = Get.find();
  String daySectionTitle = "Today";

  void selectDate() async {
    final pick = await showDatePickerDialog(
      context: Get.context!,
      minDate:
          _authService.currentUser.value?.createdAt ??
          const ConstDateTime(1970),
      maxDate: const ConstDateTime(2050),
      initialDate: DateTime.now(),
      centerLeadingDate: true,
      daysOfTheWeekTextStyle: const TextStyle(
        color: Colors.black26,
        fontSize: 14,
      ),
      enabledCellsTextStyle: const TextStyle(
        color: Colors.black26,
        fontSize: 14,
      ),
      currentDateTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      currentDateDecoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      selectedCellDecoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      leadingDateTextStyle: const TextStyle(fontSize: 20),
      slidersColor: Colors.black,
      splashRadius: 20,
    );

    if (pick == null) {
      return;
    }
    daySectionTitle = pick.isToday ? "Today" : pick.format(format: "MMMMEEEEd");
    update();
  }
}
