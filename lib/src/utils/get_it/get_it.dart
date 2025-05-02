import 'package:injectable/injectable.dart';
import 'package:your_fit/src/utils/get_it/get_it.config.dart';
import 'package:your_fit/src/utils/constants.dart';


@InjectableInit(
  asExtension: true,
  preferRelativeImports: true,
  initializerName: "init",
)
Future<void> configureServices() async {
  
  getIt.init();
}
