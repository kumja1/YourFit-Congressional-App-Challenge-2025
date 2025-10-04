import 'package:flutter/cupertino.dart';

abstract class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Map<String, dynamic>? getData();
  bool canProgress() => false;
}
