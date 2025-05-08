import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/utils/constants/constants.dart';

@singleton
class AuthService {
  final GoTrueClient _auth = supabaseClient.auth;

  Future<void> signInWithPassword(String email, String password) async {
    await _auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUpWithPassword(String email, String password) async {
    await _auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.resetPasswordForEmail(email);
  }

  Future<void> signInWithOAuth(OAuthProvider provider) async {
    await _auth.signInWithOAuth(provider);
  }
}
