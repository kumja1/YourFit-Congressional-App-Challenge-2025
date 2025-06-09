import 'package:custom_button_builder/custom_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AsyncButton extends StatelessWidget {
  final Future Function()? onPressed;
  final Widget child;
  final bool showLoadingIndicator;
  final double width;
  final double height;
  final double borderRadius;
  final bool animate;
  final bool vibrate;
  final bool isThreeD;
  final Color loadingIndicatorColor;
  final Color foregroundColor;
  final Color backgroundColor;

  final String _tag = UniqueKey().toString();

  AsyncButton({
    super.key,
    required this.child,
    this.onPressed,
    this.showLoadingIndicator = true,
    this.width = 200,
    this.height = 20,
    this.borderRadius = 20,
    this.animate = true,
    this.vibrate = true,
    this.isThreeD = true,
    this.foregroundColor = Colors.blueAccent,
    this.backgroundColor = Colors.blue,
    this.loadingIndicatorColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_AsyncButtonController(), tag: _tag);
    return CustomButton(
      onPressed:
          () => controller.handleOnPressed(
            onPressed ?? () async {},
            showLoadingIndicator,
          ),
      backgroundColor: foregroundColor,
      shadowColor: backgroundColor,
      height: height,
      width: width,
      animate: animate,
      isThreeD: isThreeD,
      borderRadius: borderRadius,
      child: GetBuilder<_AsyncButtonController>(
        tag: _tag,
        builder:
            (controller) =>
                controller.isLoading
                    ? CircularProgressIndicator(color: loadingIndicatorColor)
                    : child,
      ),
    );
  }
}

class _AsyncButtonController extends GetxController {
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

         await onPressed();
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
