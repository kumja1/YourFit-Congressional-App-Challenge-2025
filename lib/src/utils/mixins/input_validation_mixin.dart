import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

mixin InputValidationMixin {
  final RxString email = ''.obs;
  final RxString password = ''.obs;

  String? validateEmail(String? value) {
    if (GetUtils.isNullOrBlank(value)!) {
      return "Email is required";
    }

    return !GetUtils.isEmail(value!) ? "Invalid email" : null;
  }

  String? validatePassword(
    String? value, {
    int minLength = 8,
    bool upper = false,
    bool lower = false,
    bool numeric = false,
    bool special = false,
  }) => validateString(
    value,
    stringType: "Password",
    lower: lower,
    minLength: minLength,
    numeric: numeric,
    special: special,
    upper: upper,
  );

  String? validateString(
    String? value, {
    String? stringType = "Value",
    int minLength = 8,
    bool upper = true,
    bool lower = true,
    bool numeric = true,
    bool special = true,
  }) {
    if (GetUtils.isNullOrBlank(value)!) {
      return "$stringType is required";
    }

    if (GetUtils.isLengthLessThan(value, minLength)) {
      return "$stringType length must be at least $minLength";
    }

    if (upper && !GetUtils.hasCapitalletter(value!)) {
      return "$stringType must contain at least one uppercase letter";
    }

    if (lower && !GetUtils.hasMatch(value!, r'[a-z]')) {
      return "$stringType must contain at least one lowercase letter";
    }

    if (numeric && !GetUtils.hasMatch(value!, r'[0-9]')) {
      return "$stringType must contain at least one number";
    }

    if (special && !GetUtils.hasMatch(value!, r'[!@#$%^&*(),.?":{}|<>]')) {
      return "$stringType must contain at least one special character";
    }

    return null;
  }
}
