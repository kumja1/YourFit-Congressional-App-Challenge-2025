import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthCode { newUser, error, success }

class AuthResponse {
  final String? message;
  final AuthCode code;
  final User? supabaseUser;

  AuthResponse({this.message, required this.code, this.supabaseUser});
}
