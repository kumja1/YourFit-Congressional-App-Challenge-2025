import 'package:const_date_time/const_date_time.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/utils/extensions/widget_extension.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form.dart';
import 'package:yourfit/src/widgets/auth_form/auth_form_text_field.dart';
import 'package:yourfit/src/widgets/onboarding_screen.dart';

class UserInfoOnboardingScreen extends OnboardingScreen {
  const UserInfoOnboardingScreen({super.key});

  _InformationOnboardingScreenController get _controller =>
      Get.put(_InformationOnboardingScreenController());

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      formKey: _controller.formKey,
      showSubmitButton: false,
      fields: [
        SizedBox(
          width: 360,
          child: DateTimeField(
            onShowPicker: _controller.showDateDialog,
            decoration: const InputDecoration(labelText: "Date of Birth"),
            onChanged: (value) => _controller.dob = value,
            format: DateFormat.yMMMMEEEEd(),
          ),
        ),
        DropdownButtonFormField(
          icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.blue),
          items: const [
            DropdownMenuItem(value: UserGender.male, child: Text("Male")),
            DropdownMenuItem(value: UserGender.female, child: Text("Female")),
          ],
          decoration: const InputDecoration(labelText: "Gender"),
          onChanged: (value) => _controller.gender = value,
          validator: (value) => _controller.validateString(value?.toValue()),
        ).sized(width: 360),
        AuthFormTextField(
          labelText: "Weight",
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) => _controller.weight = double.parse(value),
        ),
        AuthFormTextField(
          labelText: "Height",
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) => _controller.height = int.parse(value),
        ),
      ],
    ).center();
  }

  @override
  Map<String, dynamic> getData() => {
    "dob": _controller.dob,
    "weight": _controller.weight,
    "height": _controller.height,
  };

  @override
  bool canProgress() => _controller.validateForm();
}

class _InformationOnboardingScreenController extends AuthFormController {
  DateTime? dob;
  UserGender? gender;
  double weight = 0;
  int height = 0;

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
