import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;
import 'package:yourfit/src/models/auth/auth_response.dart';
import 'package:yourfit/src/models/auth/new_user_auth_response.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/constants/icons.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form_text_field.dart';
import 'package:yourfit/src/widgets/oauth_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_SignUpScreenController());

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: AuthForm(
                formKey: controller.formKey,
                showForgetPassword: false,
                // title: const Text(
                // "Create your account",
                // style: TextStyle(fontSize: 30),
                // ).paddingSymmetric(vertical: 40),
                oauthButtons: [
                  OAuthButton(
                    icon: googleIcon,
                    onPressed:
                        () => controller.createAccount(
                          provider: OAuthProvider.google,
                        ),
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
                    validator: (value) => controller.validatePassword(value),
                    isPassword: true,
                  ),

                  AuthFormTextField(
                    labelText: "Name",
                    onChanged: (value) => controller.name.value = value,
                  ),

                  AuthFormTextField(
                    labelText: "Age",
                    onChanged: (value) => controller.age.value = value,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),

                  DateTimeFormField(),
                ],
                onSubmitPressed: () async => controller.createAccount(),
                submitButtonChild: const Text(
                  "Create Account",
                  style: TextStyle(color: Colors.white),
                ),
                onBottomButtonPressed:
                    () => Get.rootDelegate.toNamed(Routes.signIn),
                bottomButtonChild: const Text(
                  "Existing User? Sign in",
                  style: TextStyle(color: Colors.black26),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpScreenController extends AuthFormController {
  final RxString name = ''.obs;
  final RxString age = ''.obs;

  final UserService _userService = Get.find();

  Future<void> createAccount({OAuthProvider? provider}) async {
    if (provider != null) {
      AuthResponse response = await signInWithOAuth(provider);
      if (response is NewUserAuthResponse) {}
    }
    if (!validateForm()) {
      return;
    }

    final nameParts = name.split(" ");
    if (nameParts.isEmpty || nameParts.any((s) => s.isEmpty)) {
      showSnackbar("Name is invalid", AnimatedSnackBarType.error);
      return;
    }

    // _userService.createUser(nameParts[0], lastName, weight, height, age)
  }
}
