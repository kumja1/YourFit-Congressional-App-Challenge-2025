import 'package:auto_route/auto_route.dart';
import 'package:yourfit/src/routing/guards/auth_guard.dart';
import 'package:yourfit/src/routing/router.gr.dart';
import 'package:yourfit/src/routing/routes.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: SplashRoute.page,
      path: Routes.splash,
      initial: true,
      guards: [AuthGuard()],
    ),
    AutoRoute(page: LandingRoute.page, path: Routes.landing),
    AutoRoute(page: WelcomeRoute.page, path: Routes.welcome),
    AutoRoute(page: SignInRoute.page, path: Routes.signIn),
    AutoRoute(page: SignUpRoute.page, path: Routes.signUp),
    AutoRoute(page: PasswordResetRoute.page, path: Routes.passwordReset),
    AutoRoute(
      page: MainRoute.page,
      path: Routes.main,
      children: [
        AutoRoute(page: RoadmapRoute.page, path: "roadmap"),
        AutoRoute(page: ExerciseRoute.page, path: "workouts"),
        AutoRoute(page: ProfileRoute.page, path: "profile"),
      ],
    ),
    AutoRoute(page: BasicExerciseRoute.page),
    AutoRoute(page: RunningExerciseRoute.page)
  ];
}
