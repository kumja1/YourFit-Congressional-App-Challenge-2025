import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialOnboardingScreen extends GetView<_InitialOnboardingScreenController> {
  const InitialOnboardingScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Enter your name"),
        const SizedBox(height: 20),
      ],
    );
  }
}


class _InitialOnboardingScreenController extends GetxController {
  RxString name = ''.obs;
  GlobalKey<FormFieldState> formFieldState = GlobalKey();

  void t(){
  }
}