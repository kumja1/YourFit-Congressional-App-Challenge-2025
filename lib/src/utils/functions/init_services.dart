import 'package:get/instance_manager.dart';
import 'package:yourfit/src/services/index.dart';

Future<void> initServices() async {
  Get.lazyPut(() => AuthService());
  Get.lazyPut(() => UserService());
  Get.lazyPut(() => ExerciseService());
}
