import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/routes.dart';
import 'package:yourfit/src/screens/index.dart';
import 'package:yourfit/src/utils/functions/init_getx.dart';

void main() async {
  await initGetX();
  runApp(const YourFitApp());
}

class YourFitApp extends StatelessWidget {
  const YourFitApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    defaultTransition: Transition.downToUp,

    getPages: [
      GetPage(name: Routes.initial, page: () => const HomeScreen()),
      GetPage(name: Routes.signIn, page: () => const SignInScreen()),
      GetPage(name: Routes.signUp, page: () => const SignUpScreen()),
      GetPage(name: Routes.forgetPassword, page: () => const ForgetPasswordScreen()),
      GetPage(name: Routes.resetPassword, page: () => const ResetPasswordScreen()),
      GetPage(name: Routes.home, page: () => const HomeScreen()),

    ],
    title: 'YourFit',
    theme:  ThemeData(
      fontFamily: "Lilita",
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
  );
}
