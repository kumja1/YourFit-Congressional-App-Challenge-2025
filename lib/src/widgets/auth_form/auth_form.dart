import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_divider/text_divider.dart';
import 'package:yourfit/src/widgets/async_button/async_button.dart';

// ignore: must_be_immutable
class AuthForm extends StatelessWidget {
  final Widget? forgetPasswordButton;
  final List<Widget>? oauthButtons;
  final List<Widget>? fields;
  final Widget? createAccountButton;

  final Color? submitButtonForegroundColor;
  final Color? submitButtonBackgroundColor;
  final Future Function() onSubmit;
  final Text submitButtonText;

  final bool showFields;
  final bool showForgetPassword;
  final bool showCreateAccount;
  final bool showSubmitButton;
  final bool showOAuthButtons;

  const AuthForm({
    super.key,
    required this.onSubmit,
    required this.submitButtonText,
    this.fields,
    this.submitButtonBackgroundColor,
    this.submitButtonForegroundColor,
    this.oauthButtons,
    this.forgetPasswordButton,
    this.createAccountButton,
    this.showFields = true,
    this.showForgetPassword = true,
    this.showCreateAccount = true,
    this.showSubmitButton = true,
    this.showOAuthButtons = true,
  });

  @override
  Widget build(BuildContext context) => _buildForm();

  Widget _buildOAuth() {
    return Row(
      spacing: 30,
      mainAxisSize: MainAxisSize.min,
      children: oauthButtons!,
    );
  }

  Widget _buildForm() {
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
            Form(key: key, child: Column(children: fields!)),
          
          if (showSubmitButton) ...[
            const SizedBox(height: 20),
            AsyncButton(
              isThreeD: true,
              backgroundColor: submitButtonBackgroundColor ?? Colors.blue,
              foregroundColor: submitButtonForegroundColor ?? Colors.blue,
              animate: true,
              width: 250,
              loadingAnimation: true,
              height: 40,
              borderRadius: 50,
              child: submitButtonText,
              onPressed: () async => await onSubmit(),
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
            const SizedBox(height: 90),
            createAccountButton ??
                AsyncButton(
                  isThreeD: true,
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  animate: true,
                  width: 250,
                  height: 40,
                  borderRadius: 50,
                  child: const Text(
                    "New User? Create an Account",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed:
                      () async => await Future.delayed(Duration(seconds: 2)),
                ),
          ],
        ],
      ),
    );
  }
}
