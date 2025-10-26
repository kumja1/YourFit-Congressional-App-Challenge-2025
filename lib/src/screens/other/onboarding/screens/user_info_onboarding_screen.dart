import 'package:const_date_time/const_date_time.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/widgets/other/auth_form.dart';
import 'package:yourfit/src/widgets/other/onboarding_screen.dart';
import 'package:yourfit/src/widgets/textfields/number_form_field.dart';

class UserInfoOnboardingScreen extends OnboardingScreen {
  const UserInfoOnboardingScreen({super.key});

  _UserInfoOnboardingScreenController get _controller =>
      Get.put(_UserInfoOnboardingScreenController());

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      formKey: _controller.formKey,
      showSubmitButton: false,
      showBottomButton: false,
      fields: [
        FormBuilderDropdown(
          name: "gender",
          icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.blue),
          items: const [
            DropdownMenuItem(value: UserGender.male, child: Text("Male")),
            DropdownMenuItem(value: UserGender.female, child: Text("Female")),
          ],
          decoration: const InputDecoration(labelText: "Gender"),
          validator: FormBuilderValidators.required(
            errorText: "Gender is required",
          ),
        ).constrains(maxWidth: 360),
        NumberFormField<double>(
          name: "weight",
          labelText: "Weight (lb)",
        ),
        NumberFormField<double>(
          name: "height",
          labelText: "Height (cm)",
        ),
      ],
    ).center();
  }

  @override
  Map<String, dynamic> getData() =>
      _controller.formKey.currentState?.value ?? {};

  @override
  bool canProgress() => _controller.validateForm();
}

class _UserInfoOnboardingScreenController extends AuthFormController {
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
