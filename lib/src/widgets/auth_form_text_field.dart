import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthFormTextField extends GetWidget {
  final Function(String value)? onChanged;
  final String labelText;
  final TextStyle labelStyle;
  final bool isPassword;
  final Color passwordVisibilityColor;
  final String? Function(String? value)? validator;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  final _tag = UniqueKey().toString();

  AuthFormTextField({
    super.key,
    required this.labelText,
    this.onChanged,
    this.validator,
    this.isPassword = false,
    this.passwordVisibilityColor = Colors.blue,
    this.width = 360,
    this.height = 80,
    this.labelStyle = const TextStyle(
      color: Colors.black26,
      fontWeight: FontWeight.normal,
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_AuthFormTextFieldController(), tag: _tag);

    return SizedBox(
      width: width,
      height: height,
      child:
          !isPassword
              ? _buildField()
              : Stack(
                alignment: Alignment.center,
                children: [
                  _buildField(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => controller.togglePasswordVisibility(),
                      icon: GetBuilder<_AuthFormTextFieldController>(
                        tag: _tag,
                        builder:
                            (controller) => Icon(
                              controller.passwordVisible
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: passwordVisibilityColor,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildField() => GetBuilder<_AuthFormTextFieldController>(
    tag: _tag,
    builder:
        (controller) => TextFormField(
          obscureText: !controller.passwordVisible,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: labelStyle,
            errorStyle: const TextStyle(color: Colors.red),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.2, color: Colors.black12),
              borderRadius: borderRadius,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: borderRadius,
            ),
          ),
        ),
  );
}

class _AuthFormTextFieldController extends GetxController {
  bool passwordVisible = true;

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    update();
  }
}
