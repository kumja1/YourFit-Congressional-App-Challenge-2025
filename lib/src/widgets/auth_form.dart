import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_divider/text_divider.dart';
import 'package:yourfit/src/widgets/async_button.dart';
import 'package:yourfit/src/widgets/auth_form_text_field.dart';

class AuthForm extends StatelessWidget {
  final Widget? forgetPasswordButton;
  final List<Widget>? oauthButtons;
  final List<AuthFormTextField>? fields;
  final Widget? createAccountButton;
  final Key? formKey;

  final Color? submitButtonForegroundColor;
  final Color? submitButtonBackgroundColor;
  final Future Function() onSubmitPressed;
  final Future Function()? onCreateAccountPressed;
  final Text submitButtonText;

  final bool showFields;
  final bool showForgetPassword;
  final bool showCreateAccount;
  final bool showSubmitButton;
  final bool showOAuthButtons;

  const AuthForm({
    super.key,
    required this.onSubmitPressed,
    required this.submitButtonText,
    this.showFields = true,
    this.showForgetPassword = true,
    this.showCreateAccount = true,
    this.showSubmitButton = true,
    this.showOAuthButtons = true,
    this.onCreateAccountPressed,
    this.fields,
    this.submitButtonBackgroundColor,
    this.submitButtonForegroundColor,
    this.oauthButtons,
    this.forgetPasswordButton,
    this.createAccountButton,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            if (showOAuthButtons && oauthButtons != null) ...[
              _buildOAuth(),
              const SizedBox(height: 15),
              const SizedBox(
                width: 420,
                child: TextDivider(
                  text: Text(
                    "OR",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (showFields && fields != null)
              Form(key: formKey, child: Column(children: fields!)),

            if (showSubmitButton) ...[
              const SizedBox(height: 20),
              AsyncButton(
                isThreeD: true,
                backgroundColor: submitButtonBackgroundColor ?? Colors.blue,
                foregroundColor: submitButtonForegroundColor ?? Colors.blue,
                animate: true,
                width: 250,
                showLoadingIndicator: true,
                height: 40,
                borderRadius: 50,
                onPressed: onSubmitPressed,
                child: submitButtonText,
              ),
            ],

            if (showForgetPassword) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Get.toNamed("/reset_password_screen"),
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
            if (showCreateAccount) ...[
              const SizedBox(height: 60),
              createAccountButton ??
                  AsyncButton(
                    isThreeD: true,
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    showLoadingIndicator: true,
                    animate: true,
                    width: 250,
                    height: 40,
                    borderRadius: 50,
                    onPressed: onCreateAccountPressed,
                    child: const Text(
                      "New User? Create an Account",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
            ],
          ],
        ),
    );
  }

  Widget _buildOAuth() {
    return Row(
      spacing: 30,
      mainAxisSize: MainAxisSize.min,
      children: oauthButtons!,
    );
  }
}
