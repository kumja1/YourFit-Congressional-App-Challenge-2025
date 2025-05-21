import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/controllers/auth_controller.dart';
import 'package:yourfit/src/widgets/auth_form.dart';
import 'package:yourfit/src/widgets/auth_form_text_field.dart';

class SignInScreen extends GetView<AuthController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Sign in", style: TextStyle(fontSize: 30)),
          const SizedBox(height: 60.0),
          AuthForm(
            formKey: controller.formKey,
            showSubmitButton: true,
            showForgetPassword: true,
            showOAuthButtons: false,
            fields: [
              AuthFormTextField(
                label: const Text("Email"),
                value: controller.email,
                validator: controller.validateEmail,
              ),

              AuthFormTextField(
                label: const Text("Password"),
                height: 70,
                value: controller.password,
                isPassword: true,
              ),
            ],
            submitButtonText: const Text(
              "Sign In",
              style: TextStyle(color: Colors.white),
            ),
            onSubmitPressed: () => controller.signInWithPassword(),
            onForgetPasswordPressed: () async => Get.toNamed("/reset_password_screen"),
          ),
        ],
      ),
    );
  }
}
