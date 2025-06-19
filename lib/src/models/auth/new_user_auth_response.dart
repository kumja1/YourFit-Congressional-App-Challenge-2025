import 'package:google_sign_in/google_sign_in.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';

import 'auth_response.dart';

class NewUserAuthResponse extends AuthResponse {
  final GoogleSignInAccount? newUser;

  NewUserAuthResponse({this.newUser, super.code = AuthCode.newUser});
}
