import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;
import 'package:yourfit/src/models/auth/auth_response.dart';
import 'package:yourfit/src/models/auth/new_user_auth_response.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/services/user_service.dart';
import 'package:yourfit/src/utils/objects/auth/auth_code.dart';
import 'package:yourfit/src/utils/objects/auth/auth_error.dart';
import 'package:yourfit/src/utils/objects/variables.dart';

class AuthService extends GetxService {
  final GoTrueClient _auth = supabaseClient.auth;
  final UserService _userService = Get.find();
  final Rx<UserData?> currentUser = Rx<UserData?>(null);

  bool get isSignedIn => currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    _auth.onAuthStateChange.listen((event) async {
      switch (event.event) {
        case AuthChangeEvent.tokenRefreshed:
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
  ) async => await _tryCatch(() async {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      return AuthResponse(code: AuthCode.error, error: AuthError.userNotFound);
    }
    return AuthResponse(code: AuthCode.success, error: null);
  });

  Future<AuthResponse> signUpWithPassword(
    String email,
    String password,
  ) async => await _tryCatch(() async {
    final response = await _auth.signUp(email: email, password: password);
    if (response.user == null) {
      return AuthResponse(code: AuthCode.error, error: AuthError.userNotFound);
    }

    return AuthResponse(code: AuthCode.success, error: null);
  });

  Future<AuthResponse> signOut() async => await _tryCatch(() async {
    await _auth.signOut();
    return AuthResponse(code: AuthCode.success, error: null);
  });

  Future<AuthResponse> sendPasswordReset(
    String email, {
    String? redirectTo,
  }) async => await _tryCatch(() async {
    await _auth.resetPasswordForEmail(email, redirectTo: redirectTo);
    return AuthResponse(code: AuthCode.success, error: null);
  });

  Future<AuthResponse> resetPassword(String newPassword) async =>
      await _tryCatch(() async {
        await _auth.updateUser(UserAttributes(password: newPassword));
        return AuthResponse(code: AuthCode.success, error: null);
      });

  Future<AuthResponse> refreshSession() async => await _tryCatch(() async {
    final session = await _auth.refreshSession();
    if (session.user == null) {
      return AuthResponse(code: AuthCode.error, error: AuthError.userNotFound);
    }
    return AuthResponse(code: AuthCode.success, error: null);
  });


  Future<AuthResponse> _signInWithWebOAuth(OAuthProvider provider) async =>
      await _tryCatch(() async {
        final origin = Uri.base;
        final redirect = Uri(
          scheme: origin.scheme,
          host: origin.host,
          port: (origin.hasPort && origin.port != 80 && origin.port != 443)
              ? origin.port
              : null,
          path: '/',
          fragment: 'main', // -> /#/main
        ).toString();

        final success = await _auth.signInWithOAuth(
          provider,
          redirectTo: redirect,
          queryParams: const {'prompt': 'consent'},
        );

        if (!success) {
          return AuthResponse(
            code: AuthCode.error,
            error: AuthError.userNotFound,
          );
        }

        return AuthResponse(code: AuthCode.success, error: null);
      });
  Future<AuthResponse> signInWithOAuth(OAuthProvider provider) async => kIsWeb
      ? _signInWithWebOAuth(provider)
      : switch (provider) {
          (OAuthProvider.google) => await _signInWithGoogleOAuth(),
          _ => AuthResponse(
            code: AuthCode.error,
            error: AuthError.invalidOAuthProvider,
          ),
        };

  Future<AuthResponse> _signInWithGoogleOAuth() async =>
      await _tryCatch(() async {
        final scopes = const [
          PeopleServiceApi.userGenderReadScope,
          PeopleServiceApi.userinfoProfileScope,
          PeopleServiceApi.userBirthdayReadScope,
        ];

        final account = await GoogleSignIn.instance.authenticate(
          scopeHint: scopes,
        );

        final authentication = account.authentication;
        final authorization = await GoogleSignIn.instance.authorizationClient
            .authorizationForScopes(scopes);

        if (authorization == null) {
          return AuthResponse(
            code: AuthCode.error,
            error: AuthError.googleSignInError,
          );
        }
        if (authentication.idToken == null) {
          return AuthResponse(
            code: AuthCode.error,
            error: AuthError.googleSignInError,
          );
        }

        final response = await _auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: authentication.idToken!,
          accessToken: authorization.accessToken,
        );

        final existingUser = await _userService.getUser(response.user!.id);
        final bool isNewUser = existingUser == null;

        if (isNewUser) {
          final peopleApi = PeopleServiceApi(
            authorization.authClient(scopes: scopes),
          );

          final Person person = await peopleApi.people.get(
            'people/me',
            personFields: 'birthdays,genders,names',
          );

          final name = person.names?.first;
          final gender = person.genders?.first;
          final dob = person.birthdays?.first;

          if (name == null || gender == null || dob == null) {
            return AuthResponse(
              code: AuthCode.error,
              error: AuthError.googleSignInError,
            );
          }

          final dobDateTime = DateTime.parse(dob.date.toString());
          return NewUserAuthResponse(
            newUser: UserData(
              firstName: name.givenName ?? '',
              lastName: name.familyName ?? '',
              gender: UserGenderMapper.fromValue(gender.value ?? 'male'),
              dob: dobDateTime,
              height: 0,
              weight: 0,
              physicalFitness: UserPhysicalFitness.minimal,
            ),
          );
        }

        return AuthResponse(code: AuthCode.success, error: null);
      });

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
