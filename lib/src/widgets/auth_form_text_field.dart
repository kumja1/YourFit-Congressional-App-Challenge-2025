import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthFormTextField extends StatelessWidget {
  final RxString value;
  final Text label;
  final bool isPassword;
  final Color passwordVisibilityColor;
  final String? Function(String? value)? validator;
  final double width;
  final double height;

  final _tag = UniqueKey().toString();

  AuthFormTextField({
    super.key,
    required this.value,
    required this.label,
    this.validator,
    this.isPassword = false,
    this.passwordVisibilityColor = Colors.blue,
    this.width = 360,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_AuthFormTextFieldController(), tag: _tag);

    return SizedBox(
      width: width,
      height: height,
      child:
          !isPassword
              ? _buildForm()
              : Stack(
            alignment: Alignment.center,
                children: [
                  _buildForm(),
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

  Widget _buildForm() => GetBuilder<_AuthFormTextFieldController>(
    tag: _tag,
    builder:
        (controller) => TextFormField(
          autovalidateMode: AutovalidateMode.onUnfocus,
          obscureText: !controller.passwordVisible,
          onChanged: (text) => value.value = text,
          decoration: InputDecoration(
            label: label,
            errorStyle: const TextStyle(color: Colors.red),

            floatingLabelStyle:  const TextStyle(color: Colors.blueAccent),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
  );
}

class _AuthFormTextFieldController extends GetxController {
  bool passwordVisible = false;

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    update();
  }
}
