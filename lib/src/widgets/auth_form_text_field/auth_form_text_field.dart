import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/widgets/auth_form_text_field/controller.dart';

class AuthFormTextField extends StatelessWidget {
  final RxString value;
  final Text label;
  final bool isPassword;
  final Color passwordVisibilityColor;
  final String? Function(String? value) validator;
  final double width;
  final double height;

  const AuthFormTextField({
    super.key,
    required this.value,
    required this.validator,
    required this.label,
    this.isPassword = false,
    this.passwordVisibilityColor = Colors.blue,
    this.width = 360,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthFormTextFieldController());
    if (!isPassword) {
      return _buildField(controller);
    }

    return Stack(
      children: [
        _buildField(controller),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed:
                () =>
                    controller.passwordVisible.value =
                        !controller.passwordVisible.value,
            icon: Obx(
              () => Icon(
                controller.passwordVisible.value
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: passwordVisibilityColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(AuthFormTextFieldController controller) => SizedBox(
    width: width,
    height: height,
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUnfocus,
      obscureText: !controller.passwordVisible.value,
      initialValue: value.value,
      onChanged: (val) => value.value = val,
      validator: (value) => validator(value),
      decoration: InputDecoration(
        label: label,
        floatingLabelStyle: WidgetStateTextStyle.resolveWith(
          (state) =>
              state.contains(WidgetState.error)
                  ? const TextStyle(color: Colors.red)
                  : const TextStyle(color: Colors.blueAccent),
        ),
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
