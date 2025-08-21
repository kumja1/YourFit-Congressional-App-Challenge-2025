import 'package:auto_route/annotations.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:extensions_plus/extensions_plus.dart'
    show WidgetExtension, DateTimeExtension;
import 'package:flutter/material.dart' hide AnimatedList;
import 'package:get/get.dart'
    show
        Get,
        GetBuilder,
        Inst,
        GetxController,
        GetSingleTickerProviderStateMixin,
        GetNavigation,
        Rx;
import 'package:table_calendar/table_calendar.dart';
import 'package:yourfit/src/models/exercise_data.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/widgets/animated_list.dart';
import 'package:yourfit/src/widgets/buttons/animated_button.dart';
import 'package:yourfit/src/widgets/text_icon.dart';

@RoutePage()
class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_RoadmapScreenController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 30),
          child: Container(
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
            child: GetBuilder<_RoadmapScreenController>(
              init: _RoadmapScreenController(),
              builder: (controller) => TableCalendar(
                calendarFormat: CalendarFormat.month,
                focusedDay: DateTime.now(),
                firstDay: const ConstDateTime(2024),
                lastDay: const ConstDateTime(2050),
                rowHeight: 50,
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
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                startingDayOfWeek: StartingDayOfWeek.sunday,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  headerPadding: EdgeInsets.only(bottom: 15, top: 10),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.black26),
                  weekdayStyle: TextStyle(color: Colors.black26),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            Container(
              height: 50,
              width: 190,
              decoration: const BoxDecoration(
                border: BoxBorder.fromBorderSide(
                  BorderSide(color: Colors.black12, width: 1.5),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Center(child: Text("0")),
            ),
            Container(
              height: 50,
              width: 190,
              decoration: const BoxDecoration(
                border: BoxBorder.fromBorderSide(
                  BorderSide(color: Colors.black12, width: 1.5),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Center(
                child: TextIcon(
                  text: Text("0"),
                  icon: Icon(Icons.add),
                  helperText: "Calories burned",
                ),
              ),
            ),
          ],
        ).paddingOnly(bottom: 50),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<_RoadmapScreenController>(
              builder: (controller) => Text(
                controller.selectedDateName,
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
        ).paddingOnly(bottom: 15),
        GetBuilder<_RoadmapScreenController>(
          builder: (controller) => AnimatedList(
            duration: const Duration(milliseconds: 805),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            itemBuilder: (_, i) => AnimatedButton(
              height: 80,
              width: 400,
              shadowColor: Colors.black12,
              backgroundColor: Colors.white,
              borderRadius: 10,
              onPressed: () {},
              child: Text(
                "Pull Ups x 3",
                style: TextStyle(color: Colors.blue),
              ).align(Alignment.topLeft),
            ).paddingOnly(bottom: 10),
            itemCount: 4, //controller.selectedDateExercises.length,
          ),
        ),
      ],
    ).center().scrollable();
  }
}

class _RoadmapScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final Rx<UserData?> currentUser = Get.find<AuthService>().currentUser;
  List<ExerciseData> selectedDateExercises = [];

  String selectedDateName = "Today";

  void selectDate() async {
    final pick = await showDatePickerDialog(
      context: Get.context!,
      minDate: currentUser.value?.createdAt ?? const ConstDateTime(1970),
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

    selectedDateName = pick.isToday
        ? "Today"
        : pick.format(format: "MMMMEEEEd");

    if (currentUser.value != null) {
      selectedDateExercises =
          currentUser.value!.exerciseData[pick]!.days[pick.day]!.exercises;
    }
    update();
  }
}
