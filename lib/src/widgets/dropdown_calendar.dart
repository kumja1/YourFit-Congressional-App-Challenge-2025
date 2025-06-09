import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DropdownCalendar extends StatelessWidget {
  final Function(String)? onDaySelected;
  final Curve dropdownAnimationCurve;
  final Duration dropdownAnimationDuration;
  final bool changeCalendarFormat;
  final Widget child;

  const DropdownCalendar({
    super.key,
    required this.child,
    this.onDaySelected,
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
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: GetBuilder<_DropdownCalendarController>(
                  builder:
                      (controller) => TableCalendar(
                        formatAnimationCurve: dropdownAnimationCurve,
                        formatAnimationDuration: dropdownAnimationDuration,
                        calendarFormat: controller.calenderFormat,
                        focusedDay: DateTime.now(),
                        firstDay: DateTime(2024),
                        lastDay: DateTime(2050),
                        selectedDayPredicate:
                            (day) => isSameDay(controller.selectedDate, day),
                        onDaySelected:
                            (day, _) =>
                                controller.setSelectedDay(day, onDaySelected),

                        calendarStyle: const CalendarStyle(
                          weekendTextStyle: TextStyle(color: Colors.black26),
                          defaultTextStyle: TextStyle(color: Colors.black26),
                          selectedDecoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
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
              Positioned(
                bottom: 0,
                right: 0,
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
                  onPressed:
                      () => controller.toggleDropdown(changeCalendarFormat),
                ),
              ),
            ],
          ),

          GetBuilder<_DropdownCalendarController>(
            builder:
                (controller) =>
                    controller.dropdown ? child : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _DropdownCalendarController extends GetxController {
  DateTime selectedDate = DateTime.now();
  CalendarFormat calenderFormat = CalendarFormat.week;
  bool dropdown = false;

  void setSelectedDay(DateTime day, Function(String)? callback) {
    selectedDate = day;
    final dayName =
        !isSameDay(day, DateTime.now())
            ? DateFormat.MMMMEEEEd().format(day)
            : "Today";

    if (callback != null) {
      callback(dayName);
    }
    update();
  }

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
