import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(obfuscate: true, useConstantCase: true)
class Env {
  @EnviedField(varName: "SUPABASE_KEY")
  static final String supabaseKey = _Env.supabaseKey;
  @EnviedField(varName: "SUPABASE_URL")
  static final String supabaseUrl = _Env.supabaseUrl;
}
