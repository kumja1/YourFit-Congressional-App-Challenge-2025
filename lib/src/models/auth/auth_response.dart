import 'package:yourfit/src/utils/constants/auth/auth_code.dart';

class AuthResponse {
  final String? error;

  final AuthCode code;

  AuthResponse({this.error, required this.code});
}
