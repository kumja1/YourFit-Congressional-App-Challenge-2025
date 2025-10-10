import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/models/auth/auth_response.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/utils/index.dart';
import 'package:yourfit/src/widgets/index.dart';

@RoutePage()
class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_PasswordResetScreenController());

    bool resetPassword = bool.parse(Get.parameters["resetPassword"] ?? "false");
    return Scaffold(
      body: Center(
        child: AuthForm(
          formKey: controller.formKey,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: resetPassword
                ? const Text("Reset Password", style: TextStyle(fontSize: 30))
                : const Text("Forget Password", style: TextStyle(fontSize: 30)),
          ),
          showBottomButton: false,
          showOAuth: false,
          fields: [
            AuthFormTextField(
              onChanged: (value) => resetPassword
                  ? controller.password = value
                  : controller.email = value,
              labelText: resetPassword ? "New Password" : "Email",
              validator: resetPassword ? null : controller.validateEmail,
            ),
          ],
          onSubmitPressed: () => resetPassword
              ? controller.resetPassword()
              : controller.sendPasswordReset(),
          submitButtonChild: resetPassword
              ? const Text(
                  "Reset Password",
                  style: TextStyle(color: Colors.white),
                )
              : const Text(
                  "Send Password Reset",
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}

class _PasswordResetScreenController extends AuthFormController {
  Future<void> resetPassword() async {
    if (!validateForm()) {
      return;
    }

    AuthResponse response = await authService.resetPassword(password);
    if (response.code == AuthCode.error) {
      showSnackbar(response.message!, AnimatedSnackBarType.error);
      return;
    }

    showSnackbar("Password Reset", AnimatedSnackBarType.success);
  }

  Future<void> sendPasswordReset() async {
    if (!validateForm()) {
      return;
    }

    AuthResponse response = await authService.sendPasswordReset(
      email,
      redirectTo: "${Routes.passwordReset}?resetPassword=true",
    );

    if (response.code == AuthCode.error) {
      showSnackbar(response.message!, AnimatedSnackBarType.error);
      return;
    }

    showSnackbar("Check your email", AnimatedSnackBarType.success);
  }
}
