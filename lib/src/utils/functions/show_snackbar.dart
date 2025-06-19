import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/animation.dart';
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
    desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
    animationCurve: Curves.easeInOutCubic,
  ).show(Get.context!);
}
