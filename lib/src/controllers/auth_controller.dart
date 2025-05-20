import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/utils/mixins/input_validation_mixin.dart';

class AuthController extends GetxController with InputValidationMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthService _authService = Get.find();

  Future<void> _handleSignInResponse(
    ({AuthCode code, String? error}) response,
  ) async {
    if (response.code == AuthCode.error) {
      showSnackbar(
        formKey.currentContext,
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
    if (!formKey.currentState!.validate()) {
      showSnackbar(
        formKey.currentContext,
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
}
