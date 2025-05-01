import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_fit/src/utils/constants.dart';


export 'package:your_fit/src/services/auth_service.dart';


@InjectableInit(
  asExtension: true,
  preferRelativeImports: true,
  initializerName: "init",
)
Future<void> configureServices() async {
  
  getIt.init();
}
