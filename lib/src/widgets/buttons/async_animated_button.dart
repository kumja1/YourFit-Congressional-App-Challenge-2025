import 'package:custom_button_builder/custom_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AsyncAnimatedButton extends StatelessWidget {
  final Future Function()? onPressed;
  final Widget child;
  final bool disabled;
  final bool showLoadingIndicator;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool animate;
  final bool vibrate;
  final bool isThreeD;
  final Color loadingIndicatorColor;
  final Color? foregroundColor;
  final Color? backgroundColor;

  final String _tag = UniqueKey().toString();

  AsyncAnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.showLoadingIndicator = true,
    this.disabled = false,
    this.width = 250,
    this.height = 40,
    this.borderRadius = 20,
    this.animate = true,
    this.vibrate = true,
    this.isThreeD = true,
    this.foregroundColor,
    this.backgroundColor,
    this.loadingIndicatorColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_AsyncAnimatedButtonController(), tag: _tag);
    return CustomButton(
      onPressed: () =>
          controller.handleOnPressed(onPressed, showLoadingIndicator),
      backgroundColor: foregroundColor ?? Colors.blue[600],
      shadowColor: backgroundColor ?? Colors.blue,
      height: height,
      width: width,
      animate: animate,
      isThreeD: isThreeD,
      borderRadius: borderRadius,
      child: GetBuilder<_AsyncAnimatedButtonController>(
        tag: _tag,
        builder: (controller) => controller.isLoading
            ? CircularProgressIndicator(color: loadingIndicatorColor)
            : child,
      ),
    );
  }
}

class _AsyncAnimatedButtonController extends GetxController {
  bool isLoading = false;

  Future<void> handleOnPressed(
    Future Function()? onPressed,
    bool loadingAnimation,
  ) async {
    {
      if (onPressed == null) return;

      if (loadingAnimation) {
        try {
          isLoading = true;
          update();

          onPressed();
        } finally {
          isLoading = false;
          update();
        }
      } else {
        onPressed();
      }
    }
  }
}
