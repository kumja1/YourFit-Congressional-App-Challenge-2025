import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(obfuscate: true, useConstantCase: true)
class Env {
  @EnviedField(varName: "SUPABASE_API_KEY")
  static final String supabaseKey = _Env.supabaseKey;
  @EnviedField(varName: "SUPABASE_PROJECT_URL")
  static final String supabaseUrl = _Env.supabaseUrl;
}