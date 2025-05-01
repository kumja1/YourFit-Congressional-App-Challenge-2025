import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_fit/src/utils/constants.dart';

class AuthService {
 final SupabaseClient supabaseClient  = getIt<SupabaseClient>();

  Future<void> signInWithEmail(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.error != null) {
        throw response.error!;
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      if (response..error != null) {
        throw response.error!;
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }
}