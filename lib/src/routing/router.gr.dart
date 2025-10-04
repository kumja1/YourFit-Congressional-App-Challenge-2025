// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:collection/collection.dart' as _i15;
import 'package:flutter/material.dart' as _i13;
import 'package:yourfit/src/models/exercise/exercise_data.dart' as _i14;
import 'package:yourfit/src/screens/main_screen.dart' as _i3;
import 'package:yourfit/src/screens/other/auth/password_reset_screen.dart'
    as _i4;
import 'package:yourfit/src/screens/other/auth/signin_screen.dart' as _i7;
import 'package:yourfit/src/screens/other/auth/signup_screen.dart' as _i8;
import 'package:yourfit/src/screens/other/exercises/basic_exercise_screen.dart'
    as _i1;
import 'package:yourfit/src/screens/other/landing_screen.dart' as _i2;
import 'package:yourfit/src/screens/other/onboarding/welcome_screen.dart'
    as _i10;
import 'package:yourfit/src/screens/other/splash_screen.dart' as _i9;
import 'package:yourfit/src/screens/tabs/exercise_screen.dart' as _i11;
import 'package:yourfit/src/screens/tabs/profile_screen.dart' as _i5;
import 'package:yourfit/src/screens/tabs/roadmap_screen.dart' as _i6;

/// generated route for
/// [_i1.BasicExerciseScreen]
class BasicExerciseRoute extends _i12.PageRouteInfo<BasicExerciseRouteArgs> {
  BasicExerciseRoute({
    _i13.Key? key,
    required _i14.ExerciseData exercise,
    required _i13.VoidCallback onSetComplete,
    required _i13.VoidCallback onExerciseComplete,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         BasicExerciseRoute.name,
         args: BasicExerciseRouteArgs(
           key: key,
           exercise: exercise,
           onSetComplete: onSetComplete,
           onExerciseComplete: onExerciseComplete,
         ),
         initialChildren: children,
       );

  static const String name = 'BasicExerciseRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BasicExerciseRouteArgs>();
      return _i1.BasicExerciseScreen(
        key: args.key,
        exercise: args.exercise,
        onSetComplete: args.onSetComplete,
        onExerciseComplete: args.onExerciseComplete,
      );
    },
  );
}

class BasicExerciseRouteArgs {
  const BasicExerciseRouteArgs({
    this.key,
    required this.exercise,
    required this.onSetComplete,
    required this.onExerciseComplete,
  });

  final _i13.Key? key;

  final _i14.ExerciseData exercise;

  final _i13.VoidCallback onSetComplete;

  final _i13.VoidCallback onExerciseComplete;

  @override
  String toString() {
    return 'BasicExerciseRouteArgs{key: $key, exercise: $exercise, onSetComplete: $onSetComplete, onExerciseComplete: $onExerciseComplete}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BasicExerciseRouteArgs) return false;
    return key == other.key &&
        exercise == other.exercise &&
        onSetComplete == other.onSetComplete &&
        onExerciseComplete == other.onExerciseComplete;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      exercise.hashCode ^
      onSetComplete.hashCode ^
      onExerciseComplete.hashCode;
}

/// generated route for
/// [_i2.LandingScreen]
class LandingRoute extends _i12.PageRouteInfo<void> {
  const LandingRoute({List<_i12.PageRouteInfo>? children})
    : super(LandingRoute.name, initialChildren: children);

  static const String name = 'LandingRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i2.LandingScreen();
    },
  );
}

/// generated route for
/// [_i3.MainScreen]
class MainRoute extends _i12.PageRouteInfo<void> {
  const MainRoute({List<_i12.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i3.MainScreen();
    },
  );
}

/// generated route for
/// [_i4.PasswordResetScreen]
class PasswordResetRoute extends _i12.PageRouteInfo<void> {
  const PasswordResetRoute({List<_i12.PageRouteInfo>? children})
    : super(PasswordResetRoute.name, initialChildren: children);

  static const String name = 'PasswordResetRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i4.PasswordResetScreen();
    },
  );
}

/// generated route for
/// [_i5.ProfileScreen]
class ProfileRoute extends _i12.PageRouteInfo<void> {
  const ProfileRoute({List<_i12.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i5.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i6.RoadmapScreen]
class RoadmapRoute extends _i12.PageRouteInfo<void> {
  const RoadmapRoute({List<_i12.PageRouteInfo>? children})
    : super(RoadmapRoute.name, initialChildren: children);

  static const String name = 'RoadmapRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i6.RoadmapScreen();
    },
  );
}

/// generated route for
/// [_i7.SignInScreen]
class SignInRoute extends _i12.PageRouteInfo<void> {
  const SignInRoute({List<_i12.PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i7.SignInScreen();
    },
  );
}

/// generated route for
/// [_i8.SignUpScreen]
class SignUpRoute extends _i12.PageRouteInfo<SignUpRouteArgs> {
  SignUpRoute({
    _i13.Key? key,
    required Map<String, dynamic> onboardingData,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         SignUpRoute.name,
         args: SignUpRouteArgs(key: key, onboardingData: onboardingData),
         initialChildren: children,
       );

  static const String name = 'SignUpRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpRouteArgs>();
      return _i8.SignUpScreen(
        key: args.key,
        onboardingData: args.onboardingData,
      );
    },
  );
}

class SignUpRouteArgs {
  const SignUpRouteArgs({this.key, required this.onboardingData});

  final _i13.Key? key;

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
        const _i15.MapEquality().equals(onboardingData, other.onboardingData);
  }

  @override
  int get hashCode =>
      key.hashCode ^ const _i15.MapEquality().hash(onboardingData);
}

/// generated route for
/// [_i9.SplashScreen]
class SplashRoute extends _i12.PageRouteInfo<void> {
  const SplashRoute({List<_i12.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i9.SplashScreen();
    },
  );
}

/// generated route for
/// [_i10.WelcomeScreen]
class WelcomeRoute extends _i12.PageRouteInfo<void> {
  const WelcomeRoute({List<_i12.PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return _i10.WelcomeScreen();
    },
  );
}

/// generated route for
/// [_i11.WorkoutsScreen]
class WorkoutsRoute extends _i12.PageRouteInfo<void> {
  const WorkoutsRoute({List<_i12.PageRouteInfo>? children})
    : super(WorkoutsRoute.name, initialChildren: children);

  static const String name = 'WorkoutsRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i11.WorkoutsScreen();
    },
  );
}
