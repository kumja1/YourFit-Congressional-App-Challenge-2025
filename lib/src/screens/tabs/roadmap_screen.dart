import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roadmap')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: 160,
                    width: 360,
                    decoration: const BoxDecoration(
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: Colors.black26,
                          width: 1.5,
                          strokeAlign: BorderSide.strokeAlignInside,
                          style: BorderStyle.solid,
                        ),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: GetBuilder<_RoadmapScreenController>(
                      init: _RoadmapScreenController(),
                      builder:
                          (controller) => TableCalendar(
                            calendarFormat: CalendarFormat.week,
                            focusedDay: controller.focusedDate,
                            firstDay: DateTime(2024),
                            lastDay: DateTime(2050),
                            selectedDayPredicate:
                                (day) =>
                                    isSameDay(controller.selectedDate, day),
                            onDaySelected: (day, focusedDay) {
                              controller.setSelectedDay(day);
                              controller.setFocusedDay(focusedDay);
                            },
                            startingDayOfWeek: StartingDayOfWeek.sunday,
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                            ),
                            rangeSelectionMode: RangeSelectionMode.enforced,
                          ),
                    ),
                  ),
                  const Positioned(
                    bottom: 1,
                    right: 4,
                    child: Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Overview", style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(height: 20),
              const Wrap(
                alignment: WrapAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: Colors.black26,
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignInside,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('o'),
                              //Image.asset('assets/images/running_icon.png', width: 2
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        height: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: Colors.black26,
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignInside,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [SizedBox(width: 10), Text('e')],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 360,
                        height: 170,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: Color.fromARGB(255, 84, 83, 83),
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignInside,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Daily Goal',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'if you keep your goal for e then you',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [Text('should burn e')],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoadmapScreenController extends GetxController {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();

  void setSelectedDay(DateTime day) {
    selectedDate = day;
    update();
  }

  void setFocusedDay(DateTime day) {
    focusedDate = day;
    update();
  }
}
