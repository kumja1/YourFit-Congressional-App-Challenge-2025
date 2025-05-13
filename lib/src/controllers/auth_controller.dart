import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';

class AuthController extends GetxController {
  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final AuthService _authService = Get.find<AuthService>();

  RxBool passwordVisible = false.obs;
  
  void togglePasswordVisible() =>
      passwordVisible.value = !passwordVisible.value;

  Future<void> _handleSignInResponse(
    ({AuthCode code, String? error}) response,
  ) async {
    if (response.code == AuthCode.error) {
      showSnackbar(
        formState.currentContext,
        response.error!,
        AnimatedSnackBarType.error,
      );
      return;
    }

    if (response.code == AuthCode.success) {
      await Future.doWhile(() => _authService.currentUser.value == null);
      await Get.toNamed("/home_screen");
    }

    await Get.toNamed("/signup_screen");
  }

  Future<void> signInWithPassword() async {
    if (!formState.currentState!.validate()) {
      showSnackbar(
        formState.currentContext,
        "Invalid email or password",
        AnimatedSnackBarType.error,
      );
      return;
    }

    ({AuthCode code, String? error}) response = await _authService
        .signInWithPassword(email.value, password.value);
    await _handleSignInResponse(response);
  }

  Future<void> signInWithOAuth(OAuthProvider provider) async {
    ({AuthCode code, String? error}) response = await _authService
        .signInWithOAuth(provider);
    await _handleSignInResponse(response);
  }

  String? validateEmail(String? value) {
    if (GetUtils.isNullOrBlank(value)!) {
      return "Email is required";
    }

    return !GetUtils.isEmail(value!) ? "Invalid email" : null;
  }

  String? validatePassword(
    String? value, {
    int minLength = 8,
    bool upper = true,
    bool lower = true,
    bool numeric = true,
    bool special = true,
  }) {
    if (GetUtils.isNullOrBlank(value)!) {
      return "Password is required";
    }

    if (GetUtils.isLengthLessThan(value, minLength)) {
      return "Password length must be at least $minLength characters";
    }

    if (upper && !GetUtils.hasCapitalletter(value!)) {
      return "Password must contain at least one uppercase letter";
    }

    if (lower && !GetUtils.hasMatch(value!, r'[a-z]')) {
      return "Password must contain at least one lowercase letter";
    }

    if (numeric && !GetUtils.hasMatch(value!, r'[0-9]')) {
      return "Password must contain at least one number";
    }

    if (special && !GetUtils.hasMatch(value!, r'[!@#$%^&*(),.?":{}|<>]')) {
      return "Password must contain at least one special character";
    }

    return null;
  }
}
