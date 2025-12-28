import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/routing/router.dart';
import 'package:yourfit/src/utils/functions/init_services.dart';

void main() async {
  await initServices();
  runApp(const YourFitApp());
}

class YourFitApp extends StatelessWidget {
  const YourFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRouter router = Get.put(AppRouter(navigatorKey: Get.key));

    return GetMaterialApp.router(
      routerDelegate: router.delegate(),
      routeInformationParser: router.defaultRouteParser(),
      routeInformationProvider: router.routeInfoProvider(),
      title: 'YourFit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Lilita",
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
        ),
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
        dropdownMenuTheme: const DropdownMenuThemeData(menuStyle: MenuStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
        ),
        )
      ),
    ));
  }
}
