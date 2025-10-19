import 'package:free_map/free_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:langchain/langchain.dart';
import 'package:osrm/osrm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yourfit/src/utils/extensions/position_extension.dart';

class DeviceService extends GetxService {
  final FmService geocoding = FmService();
  final Osrm routing = Osrm();

  late final SharedPreferences preferences;

  Future<void> initialize() async =>
      preferences = await SharedPreferences.getInstance();

  void setDevicePreference<T>(
    String key,
    T value, {
    String Function(T)? converter,
  }) {
    converter ??= (value) => value.toString();
    value is int
        ? preferences.setInt(key, value)
        : value is double
        ? preferences.setDouble(key, value)
        : value is bool
        ? preferences.setBool(key, value)
        : preferences.setString(key, converter(value));
  }

  T? getDevicePreference<T>(String key, {T? Function(String)? converter}) {
    if (!preferences.containsKey(key)) {
      return null;
    }
    try {
      converter ??= (value) => value as T;
      return T is int
          ? preferences.getInt(key) as T
          : T is double
          ? preferences.getDouble(key) as T
          : T is bool
          ? preferences.getBool(key) as T
          : converter(preferences.getString(key)!);
    } catch (_) {
      return null;
    }
  }

  Future<bool> _requestDeviceLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    if (preferences.containsKey("location_permission")) {
      return true;
    }

    final permission = await Geolocator.requestPermission();
    final denied =
        permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine;

    if (!denied) {
      setDevicePreference("location_permission", true);
    }

    return !denied;
  }

  Stream<Position> getDevicePositionStream() => Geolocator.getPositionStream();

  Future<List<Position>> getPositionsNearDevice() async {
    Position position = await getDevicePosition();
    NearestResponse response = await routing.nearest(
      NearestOptions(
        coordinate: (position.longitude, position.latitude),
        profile: OsrmRequestProfile.foot,
        number: 10,
      ),
    );

    response.waypoints.sort(
      (a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0),
    );
    return response.waypoints
        .map(
          (e) => Position(
            longitude: e.location!.$1,
            latitude: e.location!.$2,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
          )..distance = e.distance as double,
        )
        .toList();
  }

  Future<Position> getDevicePosition() async {
    if (!await _requestDeviceLocationPermission()) {
      return Position(
        latitude: 0,
        longitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<Position?> getDeviceLastPosition() async {
    if (!(await _requestDeviceLocationPermission())) {
      return null;
    }
    return await Geolocator.getLastKnownPosition();
  }
}
