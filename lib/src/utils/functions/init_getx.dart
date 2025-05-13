import 'package:get/instance_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/widgets/async_button/controller.dart';
import 'package:yourfit/src/controllers/auth_controller.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/utils/constants/env/env.dart';

Future<void> initGetX() async {
  await initServices();
  initControllers();
}

Future<void> initServices() async {
  Get.lazyPut(() => AuthService());
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey);
}

void initControllers() {
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => AsyncButtonController());
}
