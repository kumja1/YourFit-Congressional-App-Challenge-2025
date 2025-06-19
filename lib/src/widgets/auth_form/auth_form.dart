import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;
import 'package:text_divider/text_divider.dart';
import 'package:yourfit/src/models/auth/auth_response.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/utils/mixins/input_validation_mixin.dart';
import 'package:yourfit/src/widgets/animated_button.dart';
import 'package:yourfit/src/widgets/async_button.dart';

class AuthForm extends StatelessWidget {
  final List<Widget>? oauthButtons;
  final List<Widget>? fields;
  final double fieldsSpacing;
  final Key? formKey;

  final Color? submitButtonForegroundColor;
  final Color? submitButtonBackgroundColor;
  final Future Function() onSubmitPressed;
  final Function()? onBottomButtonPressed;
  final Function()? onForgetPasswordPressed;
  final Widget submitButtonChild;
  final Widget? bottomButtonChild;
  final Widget? title;
  final Widget? forgetPassword;

  final bool showTitle;
  final bool showFields;
  final bool showForgetPassword;
  final bool showBottomButton;
  final bool showSubmitButton;
  final bool showOAuth;

  const AuthForm({
    super.key,
    required this.onSubmitPressed,
    required this.submitButtonChild,
    this.showFields = true,
    this.showForgetPassword = true,
    this.showBottomButton = true,
    this.showSubmitButton = true,
    this.showTitle = true,
    this.showOAuth = true,
    this.fieldsSpacing = 10,
    this.onBottomButtonPressed,
    this.onForgetPasswordPressed,
    this.fields,
    this.title,
    this.forgetPassword,
    this.submitButtonBackgroundColor,
    this.submitButtonForegroundColor,
    this.oauthButtons,
    this.bottomButtonChild,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showTitle && title != null) title!,
            if (showOAuth && oauthButtons != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: oauthButtons!,
              ),
              const SizedBox(
                width: 420,
                child: TextDivider(
                  text: Text(
                    "OR",
                    style: TextStyle(color: Colors.black26),
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.black12,
                ),
              ).paddingSymmetric(vertical: 20),
            ],
            if (showFields && fields != null)
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(spacing: fieldsSpacing, children: fields!),
              ),

            if (showSubmitButton) ...[
              const SizedBox(height: 20),
              AsyncButton(
                isThreeD: true,
                backgroundColor:
                    submitButtonBackgroundColor ?? Colors.blueAccent,
                foregroundColor: submitButtonForegroundColor ?? Colors.blue,
                animate: true,
                showLoadingIndicator: true,
                borderRadius: 50,
                onPressed: onSubmitPressed,
                child: submitButtonChild,
              ),
            ],

            if (showForgetPassword) ...[
              const SizedBox(height: 5),
              forgetPassword ??
                  TextButton(
                    onPressed: onForgetPasswordPressed,
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.black26,
                        decorationColor: Colors.black26,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
            ],
          ],
        ),
        if (showBottomButton) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedButton(
              width: 250,
              height: 40,
              isThreeD: true,
              shadowColor: Colors.black12,
              backgroundColor: Colors.white,
              animate: true,
              borderRadius: 50,
              onPressed: onBottomButtonPressed,
              child:
                  bottomButtonChild ??
                  const Text(
                    "New User? Create an Account",
                    style: TextStyle(color: Colors.black26),
                  ),
            ).paddingOnly(bottom: 10),
          ),
        ],
      ],
    );
  }
}

class AuthFormController extends GetxController with InputValidationMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthService authService = Get.find();

  Future<void> _handleSignInResponse(AuthResponse response) async {
    if (response.code == AuthCode.error) {
      showSnackbar(response.error!, AnimatedSnackBarType.error);
      return;
    }

    if (response.code == AuthCode.success) {
      await Get.toNamed(Routes.home);
    }
  }

  Future<AuthResponse?> signInWithPassword() async {
    if (!validateForm()) {
      return null;
    }

    AuthResponse response = await authService.signInWithPassword(
      email.value,
      password.value,
    );
    await _handleSignInResponse(response);
    return response;
  }

  Future<AuthResponse> signInWithOAuth(OAuthProvider provider) async {
    AuthResponse response = await authService.signInWithOAuth(provider);

    await Future.doWhile(() => !authService.isSignedIn);
    await _handleSignInResponse(response);
    return response;
  }

  bool validateForm() {
    if (formKey.currentState == null) {
      showSnackbar("An unexpected error occurred", AnimatedSnackBarType.error);
      return false;
    }

    return formKey.currentState!.validate();
  }
}
