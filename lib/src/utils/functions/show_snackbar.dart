import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

void showSnackbar(
  BuildContext? context,
  String message,
  AnimatedSnackBarType type, {
  Duration duration = const Duration(seconds: 5),
}) {
  if (context == null) {
    return;
  }

  AnimatedSnackBar.material(
    message,
    type: type,
    mobileSnackBarPosition: MobileSnackBarPosition.top,
    duration: duration,
  ).show(context);
}
