import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:custom_button_builder/custom_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:text_divider/text_divider.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/utils/mixins/input_validation_mixin.dart';
import 'package:yourfit/src/widgets/async_button.dart';

class AuthForm extends StatelessWidget {
  final Widget? forgetPasswordButton;
  final List<Widget>? oauthButtons;
  final List<Widget>? fields;
  final Key? formKey;

  final Color? submitButtonForegroundColor;
  final Color? submitButtonBackgroundColor;
  final Future Function() onSubmitPressed;
  final Function()? onBottomButtonPressed;
  final Function()? onForgetPasswordPressed;
  final Widget submitButtonChild;
  final Widget? bottomButtonChild;

  final bool showFields;
  final bool showForgetPassword;
  final bool showBottomButton;
  final bool showSubmitButton;
  final bool showOAuthButtons;

  const AuthForm({
    super.key,
    required this.onSubmitPressed,
    required this.submitButtonChild,
    this.showFields = true,
    this.showForgetPassword = true,
    this.showBottomButton = true,
    this.showSubmitButton = true,
    this.showOAuthButtons = true,
    this.onBottomButtonPressed,
    this.onForgetPasswordPressed,
    this.fields,
    this.submitButtonBackgroundColor,
    this.submitButtonForegroundColor,
    this.oauthButtons,
    this.forgetPasswordButton,
    this.bottomButtonChild,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          if (showOAuthButtons && oauthButtons != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 30,
              children: oauthButtons!,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: 420,
                child: TextDivider(
                  text: Text(
                    "OR",
                    style: TextStyle(color: Colors.black26),
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.black12,
                ),
              ),
            ),
          ],

          if (showFields && fields != null)
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUnfocus,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: fields!,
              ),
            ),

          if (showSubmitButton) ...[
            const SizedBox(height: 20),
            AsyncButton(
              isThreeD: true,
              backgroundColor: submitButtonBackgroundColor ?? Colors.blueAccent,
              foregroundColor: submitButtonForegroundColor ?? Colors.blue,
              animate: true,
              width: 250,
              showLoadingIndicator: true,
              height: 40,
              borderRadius: 50,
              onPressed: onSubmitPressed,
              child: submitButtonChild,
            ),
          ],

          if (showForgetPassword) ...[
            const SizedBox(height: 10),
            TextButton(
              onPressed: onForgetPasswordPressed,
              style: const ButtonStyle(
                textStyle: WidgetStatePropertyAll(
                  TextStyle(color: Colors.blue),
                ),
              ),
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
          if (showBottomButton) ...[
            const SizedBox(height: 60),
            CustomButton(
              isThreeD: true,
              shadowColor: Colors.black12,
              backgroundColor: Colors.white,
              animate: true,
              width: 250,
              height: 40,
              borderRadius: 50,
              onPressed: onBottomButtonPressed,
              child:
                  bottomButtonChild ??
                  const Text(
                    "New User? Create an Account",
                    style: TextStyle(color: Colors.black26),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class AuthFormController extends GetxController with InputValidationMixin {
  final ObjectKey formKey = ObjectKey(null);
  final AuthService authService = Get.find();

  Future<void> _handleSignInResponse(
    ({AuthCode code, String? error}) response,
  ) async {
    if (response.code == AuthCode.error) {
      showSnackbar(response.error!, AnimatedSnackBarType.error);
      return;
    }

    if (response.code == AuthCode.success) {
      await Get.toNamed(Routes.home);
    }
  }

  Future<void> signInWithPassword() async {
    if (!(formKey.value as FormState).validate()) {
      showSnackbar("Invalid email or password", AnimatedSnackBarType.error);
      return;
    }

    ({AuthCode code, String? error}) response = await authService
        .signInWithPassword(email.value, password.value);
    await _handleSignInResponse(response);
  }

  Future<void> signInWithOAuth(OAuthProvider provider) async {
    ({AuthCode code, String? error}) response = await authService
        .signInWithOAuth(provider);

    await Future.doWhile(() => !authService.isSignedIn);

    await _handleSignInResponse(response);
  }
}
