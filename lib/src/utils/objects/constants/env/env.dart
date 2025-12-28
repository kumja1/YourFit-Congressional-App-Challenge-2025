import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(obfuscate: true, useConstantCase: true)
class Env {
  @EnviedField()
  static final String supabaseKey = _Env.supabaseKey;

  @EnviedField()
  static final String supabaseUrl = _Env.supabaseUrl;

  @EnviedField()
  static final String geminiKey = _Env.geminiKey;

  @EnviedField()
  static final String usdaKey = _Env.usdaKey;

  @EnviedField()
  static final String openRouteKey = _Env.openRouteKey;

  @EnviedField()
  static final String mapTilerKey = _Env.mapTilerKey;
}
