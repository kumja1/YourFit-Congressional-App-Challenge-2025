import "dart:async";

import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:get/get.dart";
import "package:maplibre_gl/maplibre_gl.dart";

class NavigationMap extends StatelessWidget {
  final LatLng end;
  final VoidCallback onEnd;

  const NavigationMap({super.key, required this.end, required this.onEnd});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_NavMapController(onEnd: onEnd));
    final start = LatLng(
      controller.lastPosition.latitude,
      controller.lastPosition.longitude,
    );
    return MapLibreMap(
      styleString:
          'https://raw.githubusercontent.com/openmaptiles/maptiler-3d-gl-style/refs/heads/master/style.json',
      onMapCreated: (c) => controller.mapController = c,
      initialCameraPosition: CameraPosition(target: start, zoom: 15),
      cameraTargetBounds: CameraTargetBounds(
        LatLngBounds(northeast: end, southwest: start),
      ),
    );
  }
}

class _NavMapController extends GetxController {
  late final MapLibreMapController mapController;
  late final Position lastPosition;
  late final StreamSubscription<Position> positionStream;
  final VoidCallback onEnd;

  _NavMapController({required this.onEnd});

  @override
  void onInit() async {
    super.onInit();

    lastPosition = await Geolocator.getCurrentPosition();
    final line = await mapController.addLine(
      LineOptions(
        geometry: [LatLng(lastPosition.latitude, lastPosition.longitude)],
        lineColor: "blue",

      ),
    );

    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(distanceFilter: 3),
        ).listen((position) async {
          if (Geolocator.distanceBetween(
                lastPosition.latitude,
                lastPosition.longitude,
                position.latitude,
                position.longitude,
              ) >
              12.5) // This is to ensure that they are running without aid
          {
            end(); // For now end the map when they cheat
          }
          
          await Future.wait([
          mapController.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(position.latitude, position.longitude),
            ),
          ),
          mapController.updateLine(line, LineOptions(
            geometry: [
              LatLng(lastPosition.latitude, lastPosition.longitude),
              LatLng(position.latitude, position.longitude),
            ],
            lineColor: "blue",
            
          ))
          ]);
        });
  }

  void end() {
    positionStream.cancel();
    onEnd();
  }

  @override
  void onClose() {
    end();
    super.onClose();
  }
}
