import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;

import 'package:yourfit/src/models/auth/auth_response.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/utils/mixins/input_validation_mixin.dart';
import 'package:yourfit/src/screens/tabs/profile/profile_controller.dart';

class AuthFormController extends GetxController with InputValidationMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthService authService = Get.find();
  String email = '';
  String password = '';
  String? firstName = '';
  String? lastName = '';

  Future<void> _handleSignInResponse(AuthResponse response) async {
    print('🔵 _handleSignInResponse called with code: ${response.code}');

    if (response.code == AuthCode.error) {
      print('❌ Sign in failed with error: ${response.error}');
      showSnackbar(
        response.error ?? 'Sign in failed',
        AnimatedSnackBarType.error,
      );
      return;
    }

    if (response.code == AuthCode.success) {
      print('✅ Sign in successful, loading profile...');

      await _loadUserProfile();

      print('✅ Navigating to main...');

      await Get.offAllNamed(Routes.main);
    }
  }

  Future<void> _loadUserProfile() async {
    print('🔵 Loading user profile...');
    try {
      final profileController = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController(), permanent: true);

      await profileController.load();

      print('✅ Profile loaded successfully');

      await profileController.persist();
    } catch (e) {
      print('❌ Error loading user profile: $e');
      debugPrint('Error loading user profile: $e');
    }
  }

  Future<AuthResponse?> signInWithPassword() async {
    print('🔴 signInWithPassword called!');
    print('📧 Email: ${email.trim()}');
    print('🔑 Password length: ${password.length}');

    if (!validateForm()) {
      print('❌ Form validation failed');
      return null;
    }

    print('✅ Form valid, attempting sign in...');

    try {
      print('🔵 Calling authService.signInWithPassword...');

      AuthResponse response = await authService.signInWithPassword(
        email.trim(),
        password,
      );

      print('📝 Response code: ${response.code}');
      print('📝 Response error: ${response.error}');

      await _handleSignInResponse(response);
      return response;
    } catch (e) {
      print('💥 Exception in signInWithPassword: $e');
      showSnackbar(
        'Sign in failed: ${e.toString()}',
        AnimatedSnackBarType.error,
      );
      return AuthResponse(error: e.toString(), code: AuthCode.error);
    }
  }

  Future<AuthResponse> signInWithOAuth(OAuthProvider provider) async {
    print('🔵 signInWithOAuth called with provider: $provider');

    try {
      AuthResponse response = await authService.signInWithOAuth(provider);

      if (response.code == AuthCode.success) {
        await Future.delayed(const Duration(seconds: 2));

        if (authService.isSignedIn) {
          await _loadUserProfile();
          await Get.offAllNamed(Routes.main);
        } else {
          showSnackbar('OAuth sign in failed', AnimatedSnackBarType.error);
        }
      } else {
        await _handleSignInResponse(response);
      }

      return response;
    } catch (e) {
      print('💥 OAuth sign in exception: $e');
      showSnackbar(
        'OAuth sign in failed: ${e.toString()}',
        AnimatedSnackBarType.error,
      );
      return AuthResponse(error: e.toString(), code: AuthCode.error);
    }
  }

  Future<AuthResponse?> signUpWithPassword() async {
    print('🔵 signUpWithPassword called');

    if (!validateForm()) {
      print('❌ Form validation failed');
      return null;
    }

    try {
      AuthResponse response = await authService.signUpWithPassword(
        email.trim(),
        password,
      );

      if (response.code == AuthCode.success) {
        await _createInitialProfile();
        await Get.offAllNamed(Routes.main);
      } else {
        showSnackbar(
          response.error ?? 'Sign up failed',
          AnimatedSnackBarType.error,
        );
      }

      return response;
    } catch (e) {
      print('💥 Sign up exception: $e');
      showSnackbar(
        'Sign up failed: ${e.toString()}',
        AnimatedSnackBarType.error,
      );
      return AuthResponse(error: e.toString(), code: AuthCode.error);
    }
  }

  Future<void> _createInitialProfile() async {
    print('🔵 Creating initial profile...');
    try {
      final profileController = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController(), permanent: true);

      profileController.firstName = firstName;
      profileController.lastName = lastName;
      profileController.email = email;

      await profileController.persist();
      print('✅ Initial profile created');
    } catch (e) {
      print('❌ Error creating initial profile: $e');
      debugPrint('Error creating initial profile: $e');
    }
  }

  bool validateForm() {
    print('🔵 Validating form...');

    if (formKey.currentState == null) {
      print('❌ Form key current state is null');
      showSnackbar("An unexpected error occurred", AnimatedSnackBarType.error);
      return false;
    }

    final isValid = formKey.currentState!.validate();
    print('📝 Form validation result: $isValid');
    return isValid;
  }

  Future<void> signOut() async {
    print('🔵 Signing out...');
    try {
      await authService.signOut();
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().clear();
      }
      await Get.offAllNamed(Routes.signIn);
      print('✅ Sign out successful');
    } catch (e) {
      print('❌ Sign out failed: $e');
      showSnackbar(
        'Sign out failed: ${e.toString()}',
        AnimatedSnackBarType.error,
      );
    }
  }
}
