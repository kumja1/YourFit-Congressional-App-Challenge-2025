import 'package:get/get.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';

class AuthMiddleware extends GetMiddleware {
  final AuthService _authService = Get.find();

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    final response = await _authService.refreshSession();
    if (response.code == AuthCode.error) {
      return GetNavConfig.fromRoute(Routes.welcome);
    }

    return GetNavConfig.fromRoute(Routes.main);
  }
}
