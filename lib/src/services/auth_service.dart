import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;
import 'package:yourfit/src/models/auth/auth_response.dart';
import 'package:yourfit/src/models/auth/new_user_auth_response.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/services/user_service.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';
import 'package:yourfit/src/utils/constants/auth/auth_error.dart';
import 'package:yourfit/src/utils/constants/variables.dart';

class AuthService extends GetxService {
  final GoTrueClient _auth = supabaseClient.auth;
  final UserService _userService = Get.find();
  final Rx<UserData?> currentUser = Rx(null);

  bool get isSignedIn => currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    _auth.onAuthStateChange.listen((event) async {
      switch (event.event) {
        case AuthChangeEvent.signedIn:
          currentUser.value = await _userService.getUser(
            event.session!.user.id,
          );
          break;

        case AuthChangeEvent.passwordRecovery:
        case AuthChangeEvent.signedOut:
          currentUser.value = null;
          break;

        default:
          break;
      }
    });
  }

  Future<AuthResponse> signInWithPassword(
    String email,
    String password,
  ) async {
    return await _tryCatch(() async {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return AuthResponse(code: AuthCode.error, error: AuthError.userNotFound);
      }

      currentUser.value = await _userService.getUser(response.user!.id);
      return AuthResponse(code: AuthCode.success, error: null);

      });
  }

  Future<AuthResponse> signUpWithPassword(
    String email,
    String password,
  ) async {
    return await _tryCatch(() async {
      var response = await _auth.signUp(email: email, password: password);
      if (response.user == null) {
        return AuthResponse(code: AuthCode.error, error: AuthError.userNotFound);
      }

      return AuthResponse(code: AuthCode.success, error: null);
    });
  }

  Future<AuthResponse> signOut() async {
    return await _tryCatch(() async {
      await _auth.signOut();
      return AuthResponse(code: AuthCode.success, error: null);
    });
  }

  Future<AuthResponse> sendPasswordReset(
    String email, {
    String? redirectTo,
  }) async {
    return await _tryCatch(() async {
      await _auth.resetPasswordForEmail(email, redirectTo: redirectTo);
      return AuthResponse(code: AuthCode.success, error: null);
    });
  }

  Future<AuthResponse> resetPassword(
    String newPassword,
  ) async {
    return await _tryCatch(() async {
      await _auth.updateUser(UserAttributes(password: newPassword));
      return AuthResponse(code: AuthCode.success, error: null);
    });
  }

  Future<AuthResponse> refreshSession() async {
    return await _tryCatch(() async {
      final session = await _auth.refreshSession();
      if (session.user == null) {
        return AuthResponse(code: AuthCode.error, error: AuthError.userNotFound);
      }

      currentUser.value = await _userService.getUser(session.user!.id);
      return AuthResponse(code: AuthCode.success, error: null);
    });
  }

  Future<AuthResponse> signInWithOAuth(
    OAuthProvider provider,
  ) async =>
      kIsWeb
          ? _signInWithWebOAuth(provider)
          : switch (provider) {
            (OAuthProvider.google) => await _signInWithGoogleOAuth(),
            _ => AuthResponse(code: AuthCode.error, error: AuthError.invalidOAuthProvider),
          };

  Future<AuthResponse> _signInWithWebOAuth(
    OAuthProvider provider,
  ) async {
    return await _tryCatch(() async {
      var success = await _auth.signInWithOAuth(provider, redirectTo: null);
      if (!success) {
        return AuthResponse(code: AuthCode.error, error: AuthError.userNotFound);
      }

      return AuthResponse(code: AuthCode.success, error: null);
    });
  }

  Future<AuthResponse> _signInWithGoogleOAuth() async {
    const webClientId =
        "49363448521-20k81sovvas4r2aji7nhrd6sbe0pb0b1.apps.googleusercontent.com";
    const iosClientId =
        "49363448521-ka0refci22k8s3mvvkq1uisdbn06g6vh.apps.googleusercontent.com";

    var googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    return await _tryCatch(() async {
      var account = await googleSignIn.signIn();

      if (account == null) {
        return AuthResponse(code: AuthCode.error, error: AuthError.googleSignInError);
      }

      var authentication = await account.authentication;
      var idToken = authentication.idToken;
      var accessToken = authentication.accessToken;

      if (idToken == null || accessToken == null) {
        return AuthResponse(code: AuthCode.error, error: AuthError.googleSignInError);
      }

      await _auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      List<String> nameParts = account.displayName!.split(" ");
      String firstName = nameParts[0];
      String lastName = nameParts[1];

      bool hasUser = await _userService.hasUser(firstName, lastName);
      if (!hasUser) {
        return NewUserAuthResponse(newUser: account);
      }

      return AuthResponse(code: AuthCode.success, error: null);
    });
  }

  Future<AuthResponse> _tryCatch(
    Future<AuthResponse> Function() callback,
  ) async {
    try {
      return await callback();
    } on AuthException catch (e) {
      return AuthResponse(code: AuthCode.error, error: e.message);
    }
  }
}
