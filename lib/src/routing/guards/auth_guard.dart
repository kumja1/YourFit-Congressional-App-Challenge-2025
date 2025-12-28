import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/routing/index.dart';
import 'package:yourfit/src/services/index.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthService _authService = Get.find();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    await _authService.refreshSession();
    if (_authService.isSignedIn) {
      resolver.next();
      return;
    }

    router.replacePath(Routes.landing);
  }
}
