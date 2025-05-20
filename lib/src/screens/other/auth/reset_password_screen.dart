import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/utils/mixins/input_validation_mixin.dart';
import 'package:yourfit/src/widgets/auth_form.dart';
import 'package:yourfit/src/widgets/auth_form_text_field.dart';

class ResetPasswordScreen extends GetWidget<_ResetPasswordScreenController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Reset Password", style: TextStyle(fontSize: 30)),
        const SizedBox(height: 60.0),
        AuthForm(
          showCreateAccount: false,
          showForgetPassword: false,
          showOAuthButtons: false,
          fields: [
            AuthFormTextField(
              value: controller.email,
              label: const Text("Email"),
              validator: controller.validateEmail,
            ),
          ],
          onSubmitPressed: () => controller.resetPasswordForEmail(),
          submitButtonText: const Text(
            "Reset Password",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _ResetPasswordScreenController extends GetxController
    with InputValidationMixin {
  final AuthService _authService = Get.find();

  Future<void> resetPasswordForEmail() async {
    ({AuthCode code, String? error}) response = await _authService
        .sendPasswordReset(email.value);

    if (response.code == AuthCode.error) {
      showSnackbar(Get.context, response.error!, AnimatedSnackBarType.error);
      return;
    }

    showSnackbar(
      Get.context,
      "Check email for password reset",
      AnimatedSnackBarType.success,
    );
  }
}
