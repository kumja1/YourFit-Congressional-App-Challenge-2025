import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/models/auth/auth_response.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/utils/mixins/input_validation_mixin.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form_text_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_ForgetPasswordScreenController());

    return Scaffold(
      body: Center(
        child: AuthForm(
          title: const Text(
            "Forget Password",
            style: TextStyle(fontSize: 30),
          ).paddingOnly(bottom: 20),
          showBottomButton: false,
          showForgetPassword: false,
          showOAuth: false,
          fields: [
            AuthFormTextField(
              onChanged: (value) => controller.email.value = value,
              labelText: "Email",
            ),
          ],
          onSubmitPressed: () => controller.sendPasswordResetForEmail(),
          submitButtonChild: const Text(
            "Send Password Reset",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _ForgetPasswordScreenController extends GetxController
    with InputValidationMixin {
  final AuthService _authService = Get.find();

  Future<void> sendPasswordResetForEmail() async {
    AuthResponse response = await _authService.sendPasswordReset(email.value);

    if (response.code == AuthCode.error) {
      showSnackbar(response.error!, AnimatedSnackBarType.error);
      return;
    }

    showSnackbar(
      "Check email for password reset",
      AnimatedSnackBarType.success,
    );
  }
}
