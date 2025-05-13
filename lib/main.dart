import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/app_router.dart';
import 'package:yourfit/src/utils/functions/init_getx.dart';

void main() async {
  await initGetX();
  runApp(YourFitApp());
}

class YourFitApp extends StatelessWidget {
  final AppRouter router = Get.put(AppRouter());

  YourFitApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    getPages: router.routes,
    title: 'YourFit',
    theme: ThemeData(
      fontFamily: "Lilita",
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    ),
  );
}
