// lib/src/screens/tabs/roadmap/widgets/roadmap_calendar.dart
import 'package:const_date_time/const_date_time.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controllers/roadmap/roadmap_controller.dart';

class RoadmapCalendar extends StatelessWidget {
  final RoadmapController controller;
  const RoadmapCalendar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 12),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TableCalendar(
            calendarFormat: CalendarFormat.month,
            focusedDay: controller.focusedDay,
            firstDay: const ConstDateTime(2024),
            lastDay: const ConstDateTime(2050),
            rowHeight: 52,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              headerPadding: EdgeInsets.symmetric(vertical: 10),
            ),
            selectedDayPredicate: (d) => isSameDay(d, controller.selectedDay),
            onDaySelected: (sel, foc) => controller.onDaySelected(sel, foc),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, _) {
                final t = controller.getWorkoutForDate(date);
                if (t == null) return const SizedBox.shrink();
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: t.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: t.color.withOpacity(0.35),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      t.abbrev,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: t.color,
                        height: 1.0,
                      ),
                    ),
                  ),
                );
              },
            ),
            // Other styles from original file
          ),
        ),
      ),
    );
  }
}
