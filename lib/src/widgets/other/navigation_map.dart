import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:yourfit/src/services/device_service.dart';
import 'package:yourfit/src/utils/index.dart';

class NavigationMap extends StatelessWidget {
  final ({
  Position start,
  Map<String, dynamic> segmentJson,
  DirectionRouteSegment segment,
  GeoJsonFeatureGeometry geometry,
  })
  route;
  final VoidCallback onDestinationReached;

  const NavigationMap({
    super.key,
    required this.route,
    required this.onDestinationReached,
  });

  @override
  Widget build(BuildContext context) {
    try {
      Get.log("Controller initialized with start: ${route.start}");
      return GetBuilder<_NavigationMapController>(
        init: _NavigationMapController(
          route: route,
          onDestinationReached: onDestinationReached,
        ),
        builder: (controller) =>
            FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                cameraConstraint: CameraConstraint.containCenter(
                  bounds: LatLngBounds.fromPoints(controller.routeGeometry),
                ),
                initialCenter: LatLng(
                    route.start.latitude, route.start.longitude),
                minZoom: 18,
                initialZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  "https://api.maptiler.com/maps/streets-v4/{z}/{x}/{y}@2x.png?key=${Env
                      .mapTilerKey}",
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: controller.routeGeometry,
                      color: Colors.blue,
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                    ),
                  ],
                ),
                CurrentLocationLayer(
                  style: const LocationMarkerStyle(
                    showAccuracyCircle: false,
                    markerDirection: MarkerDirection.heading,
                    markerSize: Size.square(30),
                    marker: DecoratedIcon(
                      icon: Icon(Icons.navigation_rounded, color: Colors.blue),
                      decoration: IconDecoration(
                        border: IconBorder(color: Colors.white, width: 5),
                      ),
                    )
                  ),
                  alignDirectionOnUpdate: AlignOnUpdate.always,
                  alignPositionOnUpdate: AlignOnUpdate.always,
                  errorHandler: (e) {
                    e.printError();
                    return e;
                  },
                  positionStream: controller.stream?.map(
                        (pos) =>
                        LocationMarkerPosition(
                          latitude: pos.latitude,
                          longitude: pos.longitude,
                          accuracy: pos.accuracy,
                        ),
                  ),
                ),
              ],
            ),
      );
    } on Error catch (e) {
      e.printError();
      return const SizedBox.shrink();
    }
  }
}

class _NavigationMapController extends GetxController {
  final DeviceService deviceService = Get.find();
  final ({
  Position start,
  Map<String, dynamic> segmentJson,
  DirectionRouteSegment segment,
  GeoJsonFeatureGeometry geometry,
  })
  route;
  final VoidCallback onDestinationReached;
  final MapController mapController = MapController();
  late List<LatLng> routeGeometry;
  late StreamSubscription<Position> subscription;
  Stream<Position>? stream;


  _NavigationMapController({
    required this.onDestinationReached,
    required this.route,
  }) : routeGeometry = route.geometry.coordinates.first
      .map((c) => LatLng(c.latitude, c.longitude))
      .toList();

  @override
  void onReady() {
    try {
      Get.log("Starting navigation");
      final steps = route.segment.steps;
      final stepsJson = (route.segmentJson["steps"] as List<dynamic>)
          .map((step) => Map<String, dynamic>.from(step as Map))
          .toList();

      Get.log("Route has ${steps.length} steps");
      stream = deviceService.getDevicePositionStream()?.asBroadcastStream();
      if (stream == null) {
        return;
      }

      DirectionRouteSegmentStep currentStep = steps.first;
      int currentIndex = 0;

      subscription = stream!.listen((position) async {
        // if (lastPosition.)
        ORSCoordinate maneuverCoords = ORSCoordinate.fromList(
          stepsJson[currentIndex]["maneuver"]["location"],
        );

        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          maneuverCoords.latitude,
          maneuverCoords.longitude,
        );

        Get.log("Current position: $position");
        Get.log("Next maneuver at: $maneuverCoords");
        Get.log("Distance from next maneuver: $distance");

        try {
          bool isNear = distance <= 5;
          if (!isNear) {
            if (currentStep.instruction.isBlank == true) {
              return;
            }

            await deviceService.speak(
              currentStep.instruction.trim(),
              isNavigation: true,
            );
            return;
          }

          if (isNear && currentIndex == steps.length - 1) {
            Get.log("Reached final destination");
            onRouteEnd();
            return;
          }

          currentStep = steps[++currentIndex];
          Get.log("Moving to step $currentIndex");
        } on Error catch (e) {
          e.printError();
          showSnackbar(e.toString(), AnimatedSnackBarType.error);
        }
      });
    } on Error catch (e) {
      e.printError();
      showSnackbar(e.toString(), AnimatedSnackBarType.error);
    }
  }

  void onRouteEnd() {
    Get.log("Navigation completed");
    subscription.cancel();
    onDestinationReached();
  }
}
