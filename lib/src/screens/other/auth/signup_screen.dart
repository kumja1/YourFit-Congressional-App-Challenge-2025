import 'package:const_date_time/const_date_time.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;
import 'package:yourfit/src/models/auth/auth_response.dart';
import 'package:yourfit/src/models/auth/new_user_auth_response.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/constants/icons.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form_text_field.dart';
import 'package:yourfit/src/widgets/buttons/oauth_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_SignUpScreenController());

    return Scaffold(
      body: AuthForm(
        formKey: controller.formKey,
        // title: const Text(
        // "Create your account",
        // style: TextStyle(fontSize: 30),
        // ).paddingSymmetric(vertical: 40),
        oauthButtons: [
          OAuthButton(
            icon: googleIcon,
            onPressed: () =>
                controller.createAccount(provider: OAuthProvider.google),
          ),
        ],
        fields: [
          AuthFormTextField(
            labelText: "Name",
            keyboardType: TextInputType.name,
            onChanged: (value) => controller.name = value,
            validator: (value) => controller.validateString(
              value,
              space: true,
              valueType: "Name",
            ),
          ),
          AuthFormTextField(
            labelText: "Email",
            onChanged: (value) => controller.email = value,
            validator: controller.validateEmail,
          ),
          Obx(
            () => AuthFormTextField(
              labelText: "Password",
              onChanged: (value) => controller.password.value = value,
              validator: controller.validatePassword,
              isPassword: controller.password.value.isEmpty ? false : true,
            ),
          ),
        ],
        onSubmitPressed: () async => controller.createAccount(),
        submitButtonChild: const Text(
          "Create Account",
          style: TextStyle(color: Colors.white),
        ),
        onBottomButtonPressed: () => Get.rootDelegate.toNamed(Routes.signIn),
        bottomButtonChild: const Text(
          "Existing User? Sign in",
          style: TextStyle(color: Colors.black26),
        ),
      ).center(),
    );
  }
}

class _SignUpScreenController extends AuthFormController {
  String name = "";

  final UserService _userService = Get.find();

  Future<void> createAccount({OAuthProvider? provider}) async {
    if (provider != null) {
      AuthResponse response = await signInWithOAuth(provider);
      if (response is! NewUserAuthResponse) {
        return;
      }

      await _userService.createUserFromData(response.newUser);
      return;
    }

    if (!validateForm()) {
      return;
    }

    final nameParts = name.split(" ");
  }

  Future<DateTime?> showDateDialog(
    BuildContext context,
    DateTime? _,
  ) async => await showDatePickerDialog(
    context: context,
    maxDate: const ConstDateTime(3000),
    minDate: const ConstDateTime(1900, 12, 31),
    initialDate: DateTime.now(),
    centerLeadingDate: true,
    daysOfTheWeekTextStyle: const TextStyle(
      color: Colors.black26,
      fontSize: 14,
    ),
    enabledCellsTextStyle: const TextStyle(color: Colors.black26, fontSize: 14),
    currentDateTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
    currentDateDecoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.black26,
    ),
    selectedCellDecoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.blue,
    ),
    leadingDateTextStyle: const TextStyle(fontSize: 20),
    slidersColor: Colors.black,
    splashRadius: 20,
  );
}
