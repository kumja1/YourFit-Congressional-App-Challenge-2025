import 'package:flutter/material.dart' hide Router;
import 'package:get/get.dart';
import 'package:yourfit/src/routing/router.dart';
import 'package:yourfit/src/utils/functions/init_getx.dart';

void main() async {
  await initGetX();
  runApp(const YourFitApp());
}

class YourFitApp extends StatelessWidget {
  const YourFitApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp.router(
    getPages: Router.screens,
    title: 'YourFit',
    theme: ThemeData(
      fontFamily: "Lilita",
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
  );
}
