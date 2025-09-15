import 'package:yourfit/src/utils/objects/auth/auth_code.dart';

class AuthResponse {
  final String? error;

  final AuthCode code;

  AuthResponse({this.error, required this.code});
}
