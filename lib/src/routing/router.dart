import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:yourfit/src/routing/middleware/auth_middleware.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/screens/index.dart';
import 'package:yourfit/src/screens/other/onboarding/welcome_screen.dart';

class Router {
  static final screens = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(name: Routes.landing, page: () => const LandingScreen()),
    GetPage(name: Routes.signIn, page: () => const SignInScreen()),
    GetPage(name: Routes.welcome, page: () => const WelcomeScreen()),
    GetPage(name: Routes.signUp, page: () => const SignUpScreen()),
    GetPage(
      name: Routes.passwordReset,
      page: () => const PasswordResetScreen(),
    ),
    GetPage(name: Routes.main, page: () => const MainScreen()),
  ];
}
