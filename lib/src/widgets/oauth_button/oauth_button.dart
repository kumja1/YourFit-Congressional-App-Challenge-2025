import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/widgets/async_button/async_button.dart';

class OAuthButton extends GetWidget {
  final Widget icon;
  final Future Function()? onPressed;
  final Text? label;
  final double width;
  final double height;
  final double borderRadius;
  final Color foregroundColor;
  final Color backgroundColor;

  const OAuthButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.label,
    this.width = 100,
    this.height = 40,
    this.borderRadius = 30,
    this.foregroundColor = Colors.white,
    this.backgroundColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return AsyncButton(
      animate: true,
      vibrate: true,
      isThreeD: true,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      foregroundColor: foregroundColor,
      height: height,
      width: width,
      loadingAnimation: true,
      onPressed: onPressed,
      child: Row(
        children: [
          icon,
          if (label != null) ...[const SizedBox(width: 10), label!],
        ],
      ),
    );
  }
}
