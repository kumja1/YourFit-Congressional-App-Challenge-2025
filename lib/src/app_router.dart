import 'package:get/get.dart';
import 'package:yourfit/src/screens/index.dart';

class AppRouter {
  List<GetPage> routes = [
    GetPage(name: '/', page: () => const SignInScreen()),
    GetPage(name: "/signin_screen", page: () => const SignInScreen()),
    GetPage(name: "/signup_screen", page: () => const SignUpScreen()),
    GetPage(name: "/reset_password_screen", page: () => const ResetPasswordScreen()),
    GetPage(name: "/home_screen", page: () => const HomeScreen()),

  ];
}
