import 'package:const_date_time/const_date_time.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:extensions_plus/extensions_plus.dart'
    show DateTimeExtension, WidgetExtension;
import 'package:flutter/material.dart';
import 'package:get/get.dart'
    show Get, GetBuilder, Inst, GetxController, GetNavigation, Rx;
import 'package:table_calendar/table_calendar.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/services/auth_service.dart';

import '../../models/month_data.dart';

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_RoadmapScreenController());
    final containerDecoration = const BoxDecoration(
      border: Border.fromBorderSide(
        BorderSide(
          color: Colors.black12,
          width: 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
          style: BorderStyle.solid,
        ),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 30),
          child: Container(
            width: 400,
            decoration: containerDecoration,
            child: TableCalendar(
              calendarFormat: CalendarFormat.month,
              focusedDay: DateTime.now(),
              firstDay: const ConstDateTime(2024),
              lastDay: const ConstDateTime(2050),
              formatAnimationDuration: const Duration(milliseconds: 880),
              formatAnimationCurve: Curves.elasticInOut,
              calendarStyle: const CalendarStyle(
                weekendTextStyle: TextStyle(color: Colors.black26),
                defaultTextStyle: TextStyle(color: Colors.black26),
                todayDecoration: BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.sunday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronVisible: false,
                rightChevronVisible: false,
                headerPadding: EdgeInsets.only(bottom: 15, top: 10),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekendStyle: TextStyle(color: Colors.black26),
                weekdayStyle: TextStyle(color: Colors.black26),
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: containerDecoration,
              height: 50,
              child: Row(
                children: [
                  Image.asset("icons/calorie.png"),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GetBuilder<_RoadmapScreenController>(
                      builder: (controller) => Text.rich(
                        TextSpan(
                          text:
                              "${controller.currentExerciseData?.totalCaloriesBurned ?? 0} kcals burned",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<_RoadmapScreenController>(
              builder: (controller) => Text(
                controller.selectedDate.isToday
                    ? "Today"
                    : controller.selectedDate.format(format: "MMMMEEEEd"),
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
        ).paddingOnly(bottom: 10),
      ],
    ).center().scrollable();
  }
}

class _RoadmapScreenController extends GetxController {
  final Rx<UserData?> currentUser = Get.find<AuthService>().currentUser;

  MonthData? get currentExerciseData =>
      currentUser.value?.monthData[selectedDate.monthName()];

  DateTime selectedDate = DateTime.now();

  void selectDate() async {
    final pick = await showDatePickerDialog(
      context: Get.context!,
      minDate: currentUser.value?.createdAt ?? const ConstDateTime(1970),
      maxDate: const ConstDateTime(2050),
      initialDate: selectedDate,
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

    selectedDate = pick;
    update();
  }
}
