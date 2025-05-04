import 'package:flutter/material.dart';
import 'package:yourfit/src/app_router.dart';
import 'package:yourfit/src/utils/constants/constants.dart';
import 'package:yourfit/src/utils/get_it/get_it.dart';

void main() async {
  await configureServices();
  runApp(YourFitApp());
}

class YourFitApp extends StatelessWidget {
  YourFitApp({super.key});

  final AppRouter _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'YourFit',
      theme: ThemeData(
        
        fontFamily: "Lilita",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      routerConfig: _appRouter.config(),
    );
  }
}
