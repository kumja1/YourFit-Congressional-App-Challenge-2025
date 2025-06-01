import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/controllers/auth_form_controller.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/widgets/auth_form.dart';
import 'package:yourfit/src/widgets/auth_form_text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_ResetPasswordScreenController());

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Reset Password", style: TextStyle(fontSize: 30)),
          const SizedBox(height: 60.0),
          AuthForm(
            showBottomButton: false,
            showForgetPassword: false,
            showOAuthButtons: false,
            fields: [
              AuthFormTextField(
                onChanged: (value) => controller.password.value = value,
                labelText: "New Password",
              ),
            ],
            onSubmitPressed: () => controller.resetPassword(),
            submitButtonChild: const Text(
              "Reset Password",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResetPasswordScreenController extends AuthFormController {
  Future<void> resetPassword() async {
    ({AuthCode code, String? error}) response = await authService.resetPassword(
      password.value,
    );

    if (response.code == AuthCode.error) {
      showSnackbar(response.error!, AnimatedSnackBarType.error);
      return;
    }

    showSnackbar("Password Reset!", AnimatedSnackBarType.success);
  }
}
