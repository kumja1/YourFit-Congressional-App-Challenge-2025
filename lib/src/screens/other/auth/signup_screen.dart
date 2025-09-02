import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;
import 'package:yourfit/src/models/auth/auth_response.dart';
import 'package:yourfit/src/models/auth/new_user_auth_response.dart';
import 'package:yourfit/src/routing/router.dart';
import 'package:yourfit/src/routing/routes.dart';
import 'package:yourfit/src/services/index.dart';
import 'package:yourfit/src/utils/constants/auth/auth_code.dart';
import 'package:yourfit/src/utils/constants/icons.dart';
import 'package:yourfit/src/utils/extensions/widget_extension.dart';
import 'package:yourfit/src/utils/functions/show_snackbar.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form_text_field.dart';
import 'package:yourfit/src/widgets/buttons/oauth_button.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  final Map<String, dynamic> onboardingData;

  const SignUpScreen({super.key, required this.onboardingData});

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
            icon: AppIcons.googleIcon,
            onPressed: () => controller.createAccount(
              onboardingData,
              provider: OAuthProvider.google,
            ),
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
          DateTimeField(
            onShowPicker: controller.showDateDialog,
            decoration: const InputDecoration(labelText: "Date of Birth"),
            onChanged: (value) => controller.dob = value,
            format: DateFormat.yMMMMEEEEd(),
            resetIcon: const Icon(Icons.close_rounded, color: Colors.blue),
          ).sized(width: 360),
          AuthFormTextField(
            labelText: "Email",
            onChanged: (value) => controller.email = value,
            validator: controller.validateEmail,
          ),
          AuthFormTextField(
            labelText: "Password",
            onChanged: (value) => controller.password = value,
            validator: controller.validatePassword,
            isPassword: controller.password.isEmpty ? false : true,
          ),
        ],
        onSubmitPressed: () async =>
            await controller.createAccount(onboardingData),
        submitButtonChild: const Text(
          "Create Account",
          style: TextStyle(color: Colors.white),
        ),
        onBottomButtonPressed: () => context.router.pushPath(Routes.signIn),
        bottomButtonChild: const Text(
          "Existing User? Sign in",
          style: TextStyle(color: Colors.black12),
        ),
      ).center().scrollable(),
    );
  }
}

class _SignUpScreenController extends AuthFormController {
  String name = "";
  DateTime? dob;

  final UserService userService = Get.find();
  final AppRouter router = Get.find();

  Future<void> createAccount(
    Map<String, dynamic> data, {
    OAuthProvider? provider,
  }) async {
    try {
      if (provider != null) {
        AuthResponse response = await signInWithOAuth(provider);
        if (response is! NewUserAuthResponse) {
          return;
        }

        if (response.code == AuthCode.error) {
          showSnackbar(response.error!, AnimatedSnackBarType.error);
          return;
        }

        await userService.createUserFromData(
          response.newUser,
          weight: data["weight"],
          height: data["height"],
          gender: data["gender"],
        );
        router.replacePath(Routes.main);
        return;
      }

      if (!validateForm()) {
        print("form not valid");
        return;
      }

      AuthResponse response = await authService.signUpWithPassword(
        email,
        password,
      );
      print("user signup");
      if (response.code == AuthCode.error) {
        print(response.error!);
        showSnackbar(response.error!, AnimatedSnackBarType.error);
        return;
      }
      print("user created");
      final nameParts = name.split(" ");
      await userService.createUser(
        nameParts[0],
        nameParts[1],
        data["weight"],
        data["height"],
        dob!,
        data["gender"],
        data["activityLevel"],
      );
      router.replacePath(Routes.main);
    } catch (e) {
      print(e);
      showSnackbar(e.toString(), AnimatedSnackBarType.error);
    }
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
