import 'package:auto_route/annotations.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/widgets/buttons/animated_button.dart';

@RoutePage()
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Welcome",
            style: TextStyle(fontSize: 50, color: Colors.black),
          ).align(Alignment.center).expanded(),
          AnimatedButton(
            borderRadius: 20,
            onPressed: () => Get.rootDelegate.toNamed(Routes.signUp),
            child: const Text(
              "Continue",
              style: TextStyle(color: Colors.white),
            ),
          ),
          AnimatedButton(
            borderRadius: 20,
            backgroundColor: Colors.white,
            shadowColor: Colors.black12,
            onPressed: () => Get.rootDelegate.toNamed(Routes.signIn),
            child: Text("Sign In", style: TextStyle(color: Colors.blue)),
          ),
          const SizedBox(height: 20),
        ],
      ).center(),
    );
  }
}
