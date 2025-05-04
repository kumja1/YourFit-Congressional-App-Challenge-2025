import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/utils/get_it/get_it.config.dart';
import 'package:yourfit/src/utils/constants/constants.dart';

@InjectableInit(
  asExtension: true,
  preferRelativeImports: true,
  initializerName: "init",
)
Future<void> configureServices() async {
  getIt.init();
}
