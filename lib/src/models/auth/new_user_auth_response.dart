import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/utils/objects/auth/auth_code.dart';

import 'auth_response.dart';

class NewUserAuthResponse extends AuthResponse {
  final UserData newUser;

  NewUserAuthResponse({required this.newUser, super.code = AuthCode.newUser});
}
