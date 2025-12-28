import 'dart:core';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'device_service.dart';

class HealthConnectService extends GetxService {
  final deviceService = DeviceService();
  final health = Health();

  Future<int> getTotalSteps({DateTime? from, DateTime? to}) async {
    if (!(await _requestHealthDataPermissions())) {
      return 0;
    }

    to ??= DateTime.now();
    from ??= to.subtract(const Duration(days: 1));
    return (await health.getTotalStepsInInterval(from, to))!;
  }

  Future<bool> _requestHealthDataPermissions() async {
    try {
      bool allowed = false;
      if (!(await health.isHealthConnectAvailable())) {
        await health.installHealthConnect();
      }

      if (deviceService.getDevicePreference<bool>("health_connect_enabled") ==
          true) {
        return true;
      }

      if (!(await health.isHealthDataHistoryAuthorized())) {
        allowed = await health.requestHealthDataHistoryAuthorization();
      }

      if (!(await health.isHealthDataInBackgroundAvailable())) {
        allowed = await health.requestHealthDataInBackgroundAuthorization();
      }

      if ((await health.hasPermissions(dataTypeKeysAndroid)) == false) {
        allowed = await health.requestAuthorization(
          dataTypeKeysAndroid,
          // permissions: [HealthDataAccess.] - Specify READ_WRITE permissions for HealthDataType.WORKOUT
        );
      }

      deviceService.setDevicePreference("health_connect_enabled", allowed);
      return allowed;
    } on Error catch (e) {
      e.printError();
      return false;
    }
  }
}
