import 'package:custom_button_builder/custom_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/routing/routes.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,

          children: [
            const Text.rich(
              TextSpan(
                text: "Get ",
                style: TextStyle(fontSize: 30, color: Colors.black),
                children: [
                  TextSpan(text: "fit "),
                  TextSpan(
                    text: "your ",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.double,
                      decorationColor: Colors.blueAccent,
                    ),
                  ),
                  TextSpan(text: "way"),
                ],
              ),
            ),
            CustomButton(
              width: 200,
              height: 20,
              animate: true,
              isThreeD: true,
              borderRadius: 20,
              onPressed: () => Get.rootDelegate.toNamed(Routes.onboarding),
              backgroundColor: Colors.blueAccent,
              shadowColor: Colors.blue,
              child: const Text(
                "Get Started",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
