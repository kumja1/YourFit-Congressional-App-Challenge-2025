import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(
  String message,
  AnimatedSnackBarType type, {
  Duration duration = const Duration(seconds: 3),
}) {
  if (Get.context == null) {
    return;
  }
  
  AnimatedSnackBar(
    builder: (context) => Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.06),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    ),
  ).show(Get.context!);
}
