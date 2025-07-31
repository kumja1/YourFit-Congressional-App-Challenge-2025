import 'package:flutter/foundation.dart';
import 'package:get/instance_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/constants/env/env.dart';

Future<void> initServices() async {
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey);
  await GoogleSignIn.instance.initialize(
    serverClientId: kIsWeb
        ? null
        : "49363448521-ka0refci22k8s3mvvkq1uisdbn06g6vh.apps.googleusercontent.com",
    clientId:
        "49363448521-ka0refci22k8s3mvvkq1uisdbn06g6vh.apps.googleusercontent.com",
  );
  Get.lazyPut(() => AuthService());
  Get.lazyPut(() => UserService());
}
