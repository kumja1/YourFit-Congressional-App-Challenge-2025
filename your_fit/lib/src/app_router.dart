import 'package:auto_route/auto_route.dart';
import 'package:auto_route/annotations.dart';
import 'package:your_fit/src/screens/other/SplashScreen.dart';


@AutoRouterConfig()
class AppRouter extends RootStackRouter{
  
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          
          page: SplashScreen,
          initial: true,
        ),
        AutoRoute(
          page: HomeScreen,
        ),
        AutoRoute(
          page: SettingsScreen,
        ),
      ];
}