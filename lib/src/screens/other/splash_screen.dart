import 'package:auto_route/annotations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' as m;

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Splash Screen'));
  }
}
