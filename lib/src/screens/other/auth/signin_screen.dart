import 'package:auto_route/auto_route.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/utils/constants/icons.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form_text_field.dart';
import 'package:yourfit/src/widgets/buttons/oauth_button.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthFormController());

    return Scaffold(
      body: AuthForm(
        formKey: controller.formKey,

        // title: const Text(
        //  "Sign in",
        //  style: TextStyle(fontSize: 30),
        // ).paddingSymmetric(vertical: 40),
        oauthButtons: [
          OAuthButton(
            icon: AppIcons.googleIcon,
            onPressed: () async =>
                controller.signInWithOAuth(OAuthProvider.google),
          ),
        ],
        fields: [
          AuthFormTextField(
            labelText: "Email",
            onChanged: (value) => controller.email = value,
            validator: controller.validateEmail,
          ),
          AuthFormTextField(
            labelText: "Password",
            isPassword: true,
            onChanged: (value) => controller.password = value,
            validator: controller.validatePassword,
            passwordChild: TextButton(
              onPressed: () => Get.rootDelegate.toNamed(Routes.passwordReset),
              style: const ButtonStyle(
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
              ),
              child: const Text(
                "Forgot?",
                style: TextStyle(color: Colors.black12, fontSize: 16.2),
              ),
            ),
          ),
        ],
        submitButtonChild: const Text(
          "Sign In",
          style: TextStyle(color: Colors.white),
        ),
        onSubmitPressed: () => controller.signInWithPassword(),
        onBottomButtonPressed: () => context.router.pushPath(Routes.welcome),
      ).center(),
    );
  }
}
