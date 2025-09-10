// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:collection/collection.dart' as _i13;
import 'package:flutter/material.dart' as _i12;
import 'package:yourfit/src/screens/main_screen.dart' as _i2;
import 'package:yourfit/src/screens/other/auth/password_reset_screen.dart'
    as _i3;
import 'package:yourfit/src/screens/other/auth/signin_screen.dart' as _i6;
import 'package:yourfit/src/screens/other/auth/signup_screen.dart' as _i7;
import 'package:yourfit/src/screens/other/landing_screen.dart' as _i1;
import 'package:yourfit/src/screens/other/onboarding/welcome_screen.dart'
    as _i9;
import 'package:yourfit/src/screens/other/splash_screen.dart' as _i8;
import 'package:yourfit/src/screens/tabs/exercise/exercise_screen.dart' as _i10;
import 'package:yourfit/src/screens/tabs/profile/profile_screen.dart' as _i4;
import 'package:yourfit/src/screens/tabs/roadmap/roadmap_screen.dart' as _i5;

/// generated route for
/// [_i1.LandingScreen]
class LandingRoute extends _i11.PageRouteInfo<void> {
  const LandingRoute({List<_i11.PageRouteInfo>? children})
    : super(LandingRoute.name, initialChildren: children);

  static const String name = 'LandingRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i1.LandingScreen();
    },
  );
}

/// generated route for
/// [_i2.MainScreen]
class MainRoute extends _i11.PageRouteInfo<void> {
  const MainRoute({List<_i11.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.MainScreen();
    },
  );
}

/// generated route for
/// [_i3.PasswordResetScreen]
class PasswordResetRoute extends _i11.PageRouteInfo<void> {
  const PasswordResetRoute({List<_i11.PageRouteInfo>? children})
    : super(PasswordResetRoute.name, initialChildren: children);

  static const String name = 'PasswordResetRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i3.PasswordResetScreen();
    },
  );
}

/// generated route for
/// [_i4.ProfileScreen]
class ProfileRoute extends _i11.PageRouteInfo<void> {
  const ProfileRoute({List<_i11.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i4.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i5.RoadmapScreen]
class RoadmapRoute extends _i11.PageRouteInfo<void> {
  const RoadmapRoute({List<_i11.PageRouteInfo>? children})
    : super(RoadmapRoute.name, initialChildren: children);

  static const String name = 'RoadmapRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i5.RoadmapScreen();
    },
  );
}

/// generated route for
/// [_i6.SignInScreen]
class SignInRoute extends _i11.PageRouteInfo<void> {
  const SignInRoute({List<_i11.PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i6.SignInScreen();
    },
  );
}

/// generated route for
/// [_i7.SignUpScreen]
class SignUpRoute extends _i11.PageRouteInfo<SignUpRouteArgs> {
  SignUpRoute({
    _i12.Key? key,
    required Map<String, dynamic> onboardingData,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         SignUpRoute.name,
         args: SignUpRouteArgs(key: key, onboardingData: onboardingData),
         initialChildren: children,
       );

  static const String name = 'SignUpRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpRouteArgs>();
      return _i7.SignUpScreen(
        key: args.key,
        onboardingData: args.onboardingData,
      );
    },
  );
}

class SignUpRouteArgs {
  const SignUpRouteArgs({this.key, required this.onboardingData});

  final _i12.Key? key;

  final Map<String, dynamic> onboardingData;

  @override
  String toString() {
    return 'SignUpRouteArgs{key: $key, onboardingData: $onboardingData}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SignUpRouteArgs) return false;
    return key == other.key &&
        const _i13.MapEquality().equals(onboardingData, other.onboardingData);
  }

  @override
  int get hashCode =>
      key.hashCode ^ const _i13.MapEquality().hash(onboardingData);
}

/// generated route for
/// [_i8.SplashScreen]
class SplashRoute extends _i11.PageRouteInfo<void> {
  const SplashRoute({List<_i11.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i8.SplashScreen();
    },
  );
}

/// generated route for
/// [_i9.WelcomeScreen]
class WelcomeRoute extends _i11.PageRouteInfo<void> {
  const WelcomeRoute({List<_i11.PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i9.WelcomeScreen();
    },
  );
}

/// generated route for
/// [_i10.WorkoutsScreen]
class WorkoutsRoute extends _i11.PageRouteInfo<void> {
  const WorkoutsRoute({List<_i11.PageRouteInfo>? children})
    : super(WorkoutsRoute.name, initialChildren: children);

  static const String name = 'WorkoutsRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i10.WorkoutsScreen();
    },
  );
}
