
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

@routePage
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Splash Screen'),
    );
  }
}