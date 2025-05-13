import 'package:custom_button_builder/custom_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/widgets/async_button/controller.dart';

class AsyncButton extends StatelessWidget {
  final Future Function()? onPressed;
  final Widget child;
  final bool loadingAnimation;
  final double width;
  final double height;
  final double borderRadius;
  final bool animate;
  final bool vibrate;
  final bool isThreeD;
  final Color foregroundColor;
  final Color backgroundColor;

  const AsyncButton({
    super.key,
    required this.child,
    this.onPressed,
    this.loadingAnimation = true,
    this.width = 200,
    this.height = 50,
    this.borderRadius = 20,
    this.animate = true,
    this.vibrate = true,
    this.isThreeD = true,
    this.foregroundColor = Colors.blue,
    this.backgroundColor = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AsyncButtonController());
    return CustomButton(
      onPressed: () => controller.handleOnPressed(onPressed, loadingAnimation),
      animate: animate,
      backgroundColor: foregroundColor,
      shadowColor: backgroundColor,
      height: height,
      width: width,
      isThreeD: isThreeD,
      borderRadius: borderRadius,
      child: Obx(
        () =>
            controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : child,
      ),
    );
  }
}
