import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/constants/icons.dart';
import 'package:yourfit/src/widgets/auth_form.dart';
import 'package:yourfit/src/widgets/auth_form_text_field.dart';
import 'package:yourfit/src/widgets/oauth_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_SignUpScreenController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Create your account", style: TextStyle(fontSize: 30)),
            const SizedBox(height: 50),
            AuthForm(
              oauthButtons: [
                OAuthButton(
                  icon: googleIcon,
                  onPressed:
                      () async =>
                          controller.signInWithOAuth(OAuthProvider.google),
                ),
                const OAuthButton(icon: Icon(SimpleIcons.apple)),
                const OAuthButton(
                  icon: Icon(
                    SimpleIcons.facebook,
                    color: SimpleIconColors.facebook,
                  ),
                ),
              ],
              fields: [
                AuthFormTextField(
                  labelText: "Email",
                  validator: controller.validateEmail,
                ),
                AuthFormTextField(
                  labelText: "Password",
                  validator:
                      (value) =>
                          controller.validatePassword(value, minLength: 1),
                  isPassword: true,
                ),
                AuthFormTextField(
                  labelText: "Name",
                  validator:
                      (value) => controller.validateString(value, minLength: 1),
                ),
              ],
              onSubmitPressed: () async => controller.createAccount(),
              submitButtonChild: const Text(
                "Create Account",
                style: TextStyle(color: Colors.white),
              ),
              onBottomButtonPressed: () => Get.rootDelegate.toNamed(Routes.signIn),
              bottomButtonChild: const Text(
                "Existing User? Sign in",
                style: TextStyle(color: Colors.black26),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignUpScreenController extends AuthFormController {
  final RxString name = ''.obs;
  final RxString age = ''.obs;

  final UserService _userService = Get.find();

  Future<void> createAccount() async {}
}
