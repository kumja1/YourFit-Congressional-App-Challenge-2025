import 'package:get/instance_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/constants/env/env.dart';

Future<void> initServices() async {
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey);
  Get.lazyPut(() => AuthService());
  Get.lazyPut(() => UserService());
  Get.lazyPut(() => ExerciseService());
}
