import 'package:custom_button_builder/custom_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:text_divider/text_divider.dart';
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
            _buildOAuth(),
            const SizedBox(height: 20),
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
            ),
            const SizedBox(height: 20),
          ],

          if (showFields && fields != null)
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUnfocus,
              child: Column(children: fields!),
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

  Widget _buildOAuth() {
    return Row(
      spacing: 30,
      mainAxisSize: MainAxisSize.min,
      children: oauthButtons!,
    );
  }
}
