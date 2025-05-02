import 'package:flutter/material.dart';
import 'package:your_fit/src/app_router.dart';
import 'package:your_fit/src/utils/constants.dart';
import 'package:your_fit/src/utils/get_it/get_it.dart';

void main() {
  configureServices();
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      routerConfig: _appRouter.config(),
    );
  }
}

