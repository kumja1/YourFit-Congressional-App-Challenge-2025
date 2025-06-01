import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/routes.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/utils/mixins/input_validation_mixin.dart';

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
