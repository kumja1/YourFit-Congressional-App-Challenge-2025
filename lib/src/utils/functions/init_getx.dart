import 'package:get/instance_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/controllers/auth_form_controller.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/utils/constants/env/env.dart';

Future<void> initGetX() async {
  await initServices();
  initControllers();
}

Future<void> initServices() async {
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey);
  Get.lazyPut(() => AuthService());
}

void initControllers() {
  Get.put(AuthFormController());
}
