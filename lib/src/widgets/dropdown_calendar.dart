import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class DropdownCalendar extends StatelessWidget {
  final Curve dropdownAnimationCurve;
  final Duration dropdownAnimationDuration;
  final bool changeCalendarFormat;
  final Widget child;

  const DropdownCalendar({
    super.key,
    required this.child,
    this.changeCalendarFormat = true,
    this.dropdownAnimationCurve = Curves.elasticInOut,
    this.dropdownAnimationDuration = const Duration(milliseconds: 880),
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_DropdownCalendarController());

    return Container(
      width: 400,
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            color: Colors.black12,
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
            style: BorderStyle.solid,
          ),
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          AnimatedSize(
            alignment: Alignment.topCenter,
            duration: dropdownAnimationDuration,
            curve: dropdownAnimationCurve,
            child: GetBuilder<_DropdownCalendarController>(
              builder:
                  (controller) => TableCalendar(
                    calendarFormat: controller.calenderFormat,
                    focusedDay: DateTime.now(),
                    firstDay: DateTime(2024),
                    lastDay: DateTime(2050),
                    formatAnimationDuration: Duration.zero,
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
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekendStyle: TextStyle(color: Colors.black26),
                      weekdayStyle: TextStyle(color: Colors.black26),
                    ),
                  ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: 21.5,
                height: 21.5,
              ),
              icon: GetBuilder<_DropdownCalendarController>(
                builder:
                    (controller) => Icon(
                      controller.dropdown
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                    ),
              ),
              color: Colors.blue,
              onPressed: () => controller.toggleDropdown(changeCalendarFormat),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownCalendarController extends GetxController {
  CalendarFormat calenderFormat = CalendarFormat.week;
  bool dropdown = false;

  void toggleDropdown(bool changeFormat) {
    if (changeFormat) {
      calenderFormat =
          calenderFormat == CalendarFormat.week
              ? CalendarFormat.month
              : CalendarFormat.week;
    }
    dropdown = !dropdown;
    update();
  }
}
