import 'package:auto_route/auto_route.dart';
import 'package:auto_route/annotations.dart';
import 'package:injectable/injectable.dart';
import 'package:your_fit/src/screens/index.dart';

import 'app_router.gr.dart';


@singleton
@AutoRouterConfig()
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),

  ];
  @override
  RouteType get defaultRouteType => RouteType.material();
}