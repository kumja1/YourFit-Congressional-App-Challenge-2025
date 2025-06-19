import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:yourfit/src/routing/middleware/auth_middleware.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/screens/index.dart';

class Router {
  static final screens = [
    GetPage(
      name: Routes.initial,
      page: () => const SplashScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(name: Routes.landing, page: () => const HomeScreen()),
    GetPage(name: Routes.signIn, page: () => const SignInScreen()),
    GetPage(name: Routes.signUp, page: () => const SignUpScreen()),
    GetPage(
      name: Routes.forgetPassword,
      page: () => const ForgetPasswordScreen(),
    ),
    GetPage(
      name: Routes.resetPassword,
      page: () => const ResetPasswordScreen(),
    ),
    GetPage(name: Routes.home, page: () => const HomeScreen()),
  ];
}
