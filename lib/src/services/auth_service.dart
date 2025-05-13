import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/services/user_service.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';
import 'package:yourfit/src/utils/constants/auth/auth_error.dart';
import 'package:yourfit/src/utils/constants/variables.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxService {
  final GoTrueClient _auth = supabaseClient.auth;
  final UserService _userService = Get.put(UserService());
  final Rx<UserData?> currentUser = Rx(null);

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

        case AuthChangeEvent.signedOut:
          currentUser.value = null;
          break;

        default:
          break;
      }
    });
  }

  Future<({AuthCode code, String? error})> signInWithPassword(
    String email,
    String password,
  ) async {
    try {
      var response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return (code: AuthCode.error, error: AuthError.userNotFound);
      }

      currentUser.value = await _userService.getUser(response.user!.id);
      return (code: AuthCode.success, error: null);
    } on AuthException catch (e) {
      return (code: AuthCode.error, error: e.message);
    }
  }

  Future<({AuthCode code, String? error})> signUpWithPassword(
    String email,
    String password,
  ) async {
    try {
      var response = await _auth.signUp(email: email, password: password);
      if (response.user == null) {
        return (code: AuthCode.error, error: AuthError.userNotFound);
      }

      currentUser.value = await _userService.getUser(response.user!.id);
      return (code: AuthCode.success, error: null);
    } on AuthException catch (e) {
      return (code: AuthCode.error, error: e.message);
    }
  }

  Future<({AuthCode code, String? error})> signOut() async {
    try {
      currentUser.value = null;
      await _auth.signOut();

      return (code: AuthCode.success, error: null);
    } on AuthException catch (e) {
      return (code: AuthCode.error, error: e.message);
    }
  }

  Future<({AuthCode code, String? error})> sendPasswordResetEmail(
    String email,
  ) async {
    try {
      await _auth.resetPasswordForEmail(email);
      return (code: AuthCode.success, error: null);
    } on AuthException catch (e) {
      return (code: AuthCode.error, error: e.message);
    }
  }

  Future<({AuthCode code, String? error})> signInWithOAuth(
    OAuthProvider provider,
  ) async =>
      kIsWeb
          ? _signInWithWebOAuth(provider)
          : switch (provider) {
            (OAuthProvider.google) => await _signInWithGoogleOAuth(),
            _ => (code: AuthCode.error, error: AuthError.invalidOAuthProvider),
          };

  Future<({AuthCode code, String? error})> _signInWithWebOAuth(
    OAuthProvider provider,
  ) async {
    try {
      var success = await _auth.signInWithOAuth(provider, redirectTo: null);
      if (!success) {
        return (code: AuthCode.error, error: AuthError.userNotFound);
      }

      return (code: AuthCode.success, error: null);
    } on AuthException catch (e) {
      return (code: AuthCode.error, error: e.message);
    }
  }

  Future<({AuthCode code, String? error})> _signInWithGoogleOAuth() async {
    const webClientId =
        "49363448521-20k81sovvas4r2aji7nhrd6sbe0pb0b1.apps.googleusercontent.com";
    const iosClientId =
        "49363448521-ka0refci22k8s3mvvkq1uisdbn06g6vh.apps.googleusercontent.com";

    var googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    try {
      var account = await googleSignIn.signIn();

      if (account == null) {
        return (code: AuthCode.error, error: AuthError.googleSignInError);
      }

      var authentication = await account.authentication;
      var idToken = authentication.idToken;
      var accessToken = authentication.accessToken;

      if (idToken == null || accessToken == null) {
        return (code: AuthCode.error, error: AuthError.googleSignInError);
      }

      await _auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      List<String> names = account.displayName!.split(" ");
      String firstName = names[0];
      String lastName = names[1];

      bool hasUser = await _userService.hasUser(firstName, lastName);
      if (!hasUser) {
        return (code: AuthCode.newUser, error: null);
      }

      return (code: AuthCode.success, error: null);
    } on AuthException catch (e) {
      return (code: AuthCode.error, error: e.message);
    }
  }
}
