import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/routing/router.dart';
import 'package:yourfit/src/utils/functions/init_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const YourFitApp());
}

class YourFitApp extends StatelessWidget {
  const YourFitApp({super.key});

  AppRouter get _router => Get.put(AppRouter(navigatorKey: Get.key));

  @override
  Widget build(BuildContext context) => GetMaterialApp.router(
    routerDelegate: _router.delegate(),
    routeInformationParser: _router.defaultRouteParser(),
    routeInformationProvider: _router.routeInfoProvider(),
    title: 'YourFit',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: "Lilita",
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: WidgetStateTextStyle.resolveWith(
          (states) => states.contains(WidgetState.error)
              ? const TextStyle(color: Colors.red)
              : const TextStyle(color: Colors.black12),
        ),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith(
          (states) => states.contains(WidgetState.error)
              ? const TextStyle(color: Colors.red)
              : const TextStyle(color: Colors.blue),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        focusColor: Colors.transparent,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: Colors.black12),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );
}
