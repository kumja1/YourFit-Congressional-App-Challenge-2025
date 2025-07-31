import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide WidgetPaddingX;
import 'package:yourfit/src/utils/extensions/widget_extension.dart';

class AuthFormTextField extends GetWidget {
  final Function(String value)? onChanged;
  final String labelText;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final bool isPassword;
  final Color passwordVisibilityColor;
  final String? initialValue;
  final String? Function(String? value)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final double? width;
  final double? height;
  final Widget? passwordChild;

  const AuthFormTextField({
    super.key,
    required this.labelText,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.isPassword = false,
    this.passwordVisibilityColor = Colors.blue,
    this.width = 360,
    this.height,
    this.passwordChild,
    this.initialValue,
    this.labelStyle = const TextStyle(color: Colors.black26),
    this.floatingLabelStyle = const TextStyle(color: Colors.blue),
  });

  @override
  Widget build(BuildContext context) =>
      GetBuilder<_AuthFormTextFieldController>(
        global: false,
        init: _AuthFormTextFieldController(),
        builder: (controller) => TextFormField(
          obscureText: !controller.passwordVisible,
          onChanged: onChanged,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            suffixIcon: !isPassword
                ? null
                : passwordChild ??
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => controller.togglePasswordVisibility(),
                        icon: Icon(
                          controller.passwordVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: passwordVisibilityColor,
                        ),
                      ),
            labelText: labelText,
            labelStyle: WidgetStateTextStyle.resolveWith(
              (state) => state.contains(WidgetState.error)
                  ? const TextStyle(color: Colors.red)
                  : labelStyle!,
            ),
            floatingLabelStyle: WidgetStateTextStyle.resolveWith(
              (state) => state.contains(WidgetState.error)
                  ? const TextStyle(color: Colors.red)
                  : floatingLabelStyle!,
            ),
          ),
        ),
      ).sized(width: width, height: height);
}

class _AuthFormTextFieldController extends GetxController {
  bool passwordVisible = true;

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    update();
  }
}
