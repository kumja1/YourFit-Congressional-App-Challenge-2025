import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:yourfit/src/routing/middleware/auth_middleware.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/screens/index.dart';

class Router {
  static final screens = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(name: Routes.welcome, page: () => const WelcomeScreen()),
    GetPage(name: Routes.main, page: () => const MainScreen()),
    GetPage(name: Routes.signIn, page: () => const SignInScreen()),
    GetPage(name: Routes.signUp, page: () => const SignUpScreen()),
    GetPage(
      name: Routes.passwordReset,
      page: () => const PasswordResetScreen(),
    ),
  ];
}
