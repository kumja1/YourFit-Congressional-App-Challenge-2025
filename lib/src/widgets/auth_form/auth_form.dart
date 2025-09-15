import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;
import 'package:text_divider/text_divider.dart';
import 'package:yourfit/src/models/auth/auth_response.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/utils/objects/auth/auth_code.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/widgets/buttons/animated_button.dart';
import 'package:yourfit/src/widgets/buttons/async_animated_button.dart';

class AuthForm extends StatelessWidget {
  final List<Widget>? oauthButtons;
  final List<Widget>? fields;
  final double fieldsSpacing;
  final Key? formKey;

  final Color? submitButtonForegroundColor;
  final Color? submitButtonBackgroundColor;
  final Future Function()? onSubmitPressed;
  final Function()? onBottomButtonPressed;
  final EdgeInsets? submitButtonPadding;
  final Widget? submitButtonChild;
  final Widget? bottomButtonChild;
  final Widget? title;

  final bool showTitle;
  final bool showFields;
  final bool showBottomButton;
  final bool showSubmitButton;
  final bool showOAuth;

  const AuthForm({
    super.key,
    this.onSubmitPressed,
    this.submitButtonChild,
    this.showFields = true,
    this.showBottomButton = true,
    this.showSubmitButton = true,
    this.showTitle = true,
    this.showOAuth = true,
    this.fieldsSpacing = 10,
    this.submitButtonPadding,
    this.onBottomButtonPressed,
    this.fields,
    this.title,
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
                    style: TextStyle(color: Colors.black12),
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.black12,
                ),
              ).paddingSymmetric(vertical: 20),
            ],
            if (showFields && fields != null)
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Column(spacing: fieldsSpacing, children: fields!),
              ),

            if (showSubmitButton && submitButtonChild != null) ...[
              Padding(
                padding:
                    submitButtonPadding ??
                    const EdgeInsets.symmetric(vertical: 20),
                child: AsyncAnimatedButton(
                  backgroundColor:
                      submitButtonBackgroundColor ?? Colors.blueAccent,
                  foregroundColor: submitButtonForegroundColor ?? Colors.blue,
                  showLoadingIndicator: true,
                  borderRadius: 50,
                  onPressed: onSubmitPressed,
                  child: submitButtonChild!,
                ),
              ),
            ],
          ],
        ),
        if (showBottomButton) ...[
          Positioned.fill(
            child: AnimatedButton(
              width: 250,
              height: 40,
              shadowColor: Colors.black12,
              backgroundColor: Colors.white,
              borderRadius: 50,
              onPressed: onBottomButtonPressed,
              child:
                  bottomButtonChild ??
                  const Text(
                    "New User? Create an Account",
                    style: TextStyle(color: Colors.black12),
                  ),
            ).paddingOnly(bottom: 10),
          ),
        ],
      ],
    );
  }
}

class AuthFormController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthService authService = Get.find();
  String email = '';
  String password = '';

  Future<void> _handleSignInResponse(AuthResponse response) async {
    if (response.code == AuthCode.error) {
      showSnackbar(response.error!, AnimatedSnackBarType.error);
      return;
    }

    if (response.code == AuthCode.success) {
      await Get.toNamed(Routes.main);
    }
  }

  Future<AuthResponse?> signInWithPassword() async {
    if (!validateForm()) {
      return null;
    }

    AuthResponse response = await authService.signInWithPassword(
      email,
      password,
    );
    await _handleSignInResponse(response);
    return response;
  }

  Future<AuthResponse> signInWithOAuth(OAuthProvider provider) async {
    AuthResponse response = await authService.signInWithOAuth(provider);

    await Future.doWhile(
      () => !authService.isSignedIn,
    ).then((_) async => await _handleSignInResponse(response));
    return response;
  }

  bool validateForm() {
    if (formKey.currentState == null) {
      showSnackbar("An unexpected error occurred", AnimatedSnackBarType.error);
      return false;
    }

    return formKey.currentState!.validate();
  }

  String? validateEmail(String? value) {
    if (GetUtils.isNullOrBlank(value)!) {
      return "Email is required";
    }

    return !GetUtils.isEmail(value!) ? "Invalid email" : null;
  }

  String? validatePassword(
    String? value, {
    int minLength = 1,
    bool upper = false,
    bool lower = false,
    bool numeric = false,
    bool special = false,
  }) => validateString(
    value,
    valueType: "Password",
    lower: lower,
    minLength: minLength,
    numeric: numeric,
    special: special,
    upper: upper,
  );

  String? validateString(
    String? value, {
    String? valueType = "Value",
    int minLength = 1,
    bool space = false,
    bool upper = false,
    bool lower = false,
    bool numeric = false,
    bool special = false,
  }) {
    if (GetUtils.isNullOrBlank(value)!) {
      return "$valueType is required";
    }

    if (GetUtils.isLengthLessThan(value, minLength)) {
      return "$valueType length must be at least $minLength";
    }

    if (upper && !GetUtils.hasCapitalletter(value!)) {
      return "$valueType must contain at least one uppercase letter";
    }

    if (lower && !GetUtils.hasMatch(value!, r'[a-z]')) {
      return "$valueType must contain at least one lowercase letter";
    }

    if (space && !GetUtils.hasMatch(value, r'^\S+ \S+(?: \S+)*$')) {
      return "$valueType must contain a space between each word";
    }

    if (numeric && !GetUtils.isNum(value!)) {
      return "$valueType must be contain only numbers";
    }

    if (special && !GetUtils.hasMatch(value!, r'[!@#$%^&*(),.?":{}|<>]')) {
      return "$valueType must contain at least one special character";
    }

    return null;
  }
}
