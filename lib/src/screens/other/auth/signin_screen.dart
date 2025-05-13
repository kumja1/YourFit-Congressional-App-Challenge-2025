import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/controllers/auth_controller.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form.dart';
import 'package:yourfit/src/widgets/auth_form_text_field/auth_form_text_field.dart';

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
            showSubmitButton: true,
            showCreateAccount: true,
            showForgetPassword: true,
            showOAuthButtons: true,
            fields: [
              AuthFormTextField(
                label: const Text("Email"),
                value: controller.email,
                validator: (value) => controller.validateEmail(value),
              ),
              
              AuthFormTextField(
                label: const Text("Password"),
                value: controller.password,
                validator: (value) => controller.validatePassword(value),
                isPassword: true,
              ),
            ],
            submitButtonText: const Text(
              "Sign In",
              style: TextStyle(color: Colors.white),
            ),
            onSubmit: () => controller.signInWithPassword(),
          ),
        ],
      ),
    );
  }
}
