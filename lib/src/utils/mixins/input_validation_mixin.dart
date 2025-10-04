import 'package:get/get_utils/src/get_utils/get_utils.dart';

mixin InputValidationMixin {
  String? validateEmail(String? value) {
    if (GetUtils.isNullOrBlank(value)!) {
      return "Email is required";
    }

    return !GetUtils.isEmail(value!) ? "Invalid email" : null;
  }

  String? validatePassword(
    String? value, {
    int minLength = 1,
    bool upper = false,
    bool lower = false,
    bool numeric = false,
    bool special = false,
  }) => validateString(
    value,
    valueName: "Password",
    lower: lower,
    minLength: minLength,
    numeric: numeric,
    special: special,
    upper: upper,
  );

  String? validateNumber(
    num? value, {
    String? param = "Value",
    int minLength = 1,
    bool space = false,
    bool upper = false,
    bool lower = false,
    bool numeric = false,
    bool special = false,
  }) =>
      validateString(value.toString(), valueName: param, minLength: minLength);

  String? validateString(
    String? value, {
    String? valueName = "Value",
    String? message,
    int minLength = 1,
    bool space = false,
    bool upper = false,
    bool lower = false,
    bool numeric = false,
    bool special = false,
  }) {
    if (GetUtils.isNullOrBlank(value)!) {
      return "$valueName is required";
    }

    if (GetUtils.isLengthLessThan(value, minLength)) {
      return "$valueName ${message ?? "length must be at least $minLength"}";
    }

    if (upper && !GetUtils.hasCapitalletter(value!)) {
      return "$valueName ${message ?? "must contain at least one uppercase letter"}";
    }

    if (lower && !GetUtils.hasMatch(value!, r'[a-z]')) {
      return "$valueName ${message ?? "must contain at least one lowercase letter"}";
    }

    if (space && !GetUtils.hasMatch(value, r'^\S+ \S+(?: \S+)*$')) {
      return "$valueName ${message ?? "must contain a space between each word"}";
    }

    if (numeric && !GetUtils.isNum(value!)) {
      return "$valueName ${message ?? "must be contain only numbers"}";
    }

    if (special && !GetUtils.hasMatch(value!, r'[!@#$%^&*(),.?":{}|<>]')) {
      return "$valueName must contain at least one special character";
    }

    return null;
  }
}
