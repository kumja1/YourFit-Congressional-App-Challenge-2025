import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:yourfit/src/models/exercise/running_exercise_data.dart';
import 'package:yourfit/src/screens/other/exercises/basic_exercise_screen.dart';
import 'package:yourfit/src/widgets/other/navigation_map.dart';

@RoutePage()
class RunningExerciseScreen extends BasicExerciseScreen {
  RunningExerciseScreen({
    super.key,
    required super.exercise,
    required super.onSetComplete,
    required super.onExerciseComplete,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      _RunningExerciseScreenController(
        exercise: exercise as RunningExerciseData,
      ),
    );
    return Scaffold(
      body: NavigationMap(end: controller.destination, onEnd: () {}),
    );
  }
}

class _RunningExerciseScreenController extends GetxController {
  late final LatLng destination;
  final RunningExerciseData exercise;

  _RunningExerciseScreenController({required this.exercise});

  @override
  void onInit() async {
    super.onInit();
    List<Location> locations = await locationFromAddress(exercise.destination);
    destination = LatLng(locations[0].latitude, locations[0].longitude);
  }
}
