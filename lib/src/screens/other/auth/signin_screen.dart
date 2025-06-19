import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/utils/constants/icons.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form_text_field.dart';
import 'package:yourfit/src/widgets/oauth_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthFormController());

    return Scaffold(
      body: Center(
        child: AuthForm(
          formKey: controller.formKey,

          // title: const Text(
          //  "Sign in",
          //  style: TextStyle(fontSize: 30),
          // ).paddingSymmetric(vertical: 40),
          oauthButtons: [
            OAuthButton(
              icon: googleIcon,
              onPressed:
                  () async => controller.signInWithOAuth(OAuthProvider.google),
            ),
          ],
          fields: [
            AuthFormTextField(
              labelText: "Email",
              onChanged: (value) => controller.email.value = value,
              validator: controller.validateEmail,
            ),
            AuthFormTextField(
              labelText: "Password",
              onChanged: (value) => controller.password.value = value,
              validator:controller.validatePassword

            ),
          ],
          submitButtonChild: const Text(
            "Sign In",
            style: TextStyle(color: Colors.white),
          ),
          onSubmitPressed: () => controller.signInWithPassword(),
          onForgetPasswordPressed:
              () => Get.rootDelegate.toNamed(Routes.forgetPassword),
          onBottomButtonPressed: () => Get.rootDelegate.toNamed(Routes.signUp),
        ),
      ),
    );
  }
}
