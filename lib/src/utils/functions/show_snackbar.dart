import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:get/get.dart';

void showSnackbar(
  String message,
  AnimatedSnackBarType type, {
  Duration duration = const Duration(seconds: 3),
}) {
  if (Get.context == null) {
    return;
  }

  AnimatedSnackBar.material(
    message,
    type: type,
    mobileSnackBarPosition: MobileSnackBarPosition.top,
    duration: duration,
    snackBarStrategy: RemoveSnackBarStrategy(),
  ).show(Get.context!);
}
