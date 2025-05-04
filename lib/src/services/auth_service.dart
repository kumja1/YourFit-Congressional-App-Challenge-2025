import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/utils/constants/constants.dart';

@singleton
class AuthService {
  final GoTrueClient _auth = supabaseClient.auth;

  Future<void> signInWithPassword(String email, String password) async {
    await _auth.signInWithPassword(email: email, password: password);
  }
}
