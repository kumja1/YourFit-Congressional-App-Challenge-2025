import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/instance_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'package:yourfit/src/services/device_service.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/objects/constants/env/env.dart';

Future<void> initServices() async {
  initLoggingService();

  // Initialize Supabase, Google Sign In
  await Future.wait([
    Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey),
    GoogleSignIn.instance.initialize(
      serverClientId: kIsWeb
          ? null
          : "49363448521-ka0refci22k8s3mvvkq1uisdbn06g6vh.apps.googleusercontent.com",
      clientId:
          "49363448521-ka0refci22k8s3mvvkq1uisdbn06g6vh.apps.googleusercontent.com",
    ),
  ]);

  Get.lazyPut(() => AuthService());
  Get.lazyPut(() => UserService());
  Get.lazyPut(() => ExerciseService());
  Get.putAsync(() async {
    final deviceService = DeviceService();

    await deviceService.initPreferences();
    return deviceService;
  });
}

Future<void> initBackgroundServices() async {
  Workmanager workManager = Get.put(Workmanager());
  workManager.initialize(
    () => workManager.executeTask((task, data) async {
      return true;
    }),
  );
}

void initLoggingService() {
  final expression = RegExp(r'[\[\]]');
  Get.log = (String msg, {bool? isError}) {
    log(
      "[${Frame.caller(2).member?.replaceAll(expression, "")}]: $msg",
      name: "YOURFIT",
      level: 0,
    );
  };
}
