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
        bool upper = true,
        bool lower = true,
        bool numeric = true,
        bool special = true,
      }) {
    if (GetUtils.isNullOrBlank(value)!) {
      return "Password is required";
    }

    if (GetUtils.isLengthLessThan(value, minLength)) {
      return "Password length must be at least $minLength characters";
    }

    if (upper && !GetUtils.hasCapitalletter(value!)) {
      return "Password must contain at least one uppercase letter";
    }

    if (lower && !GetUtils.hasMatch(value!, r'[a-z]')) {
      return "Password must contain at least one lowercase letter";
    }

    if (numeric && !GetUtils.hasMatch(value!, r'[0-9]')) {
      return "Password must contain at least one number";
    }

    if (special && !GetUtils.hasMatch(value!, r'[!@#$%^&*(),.?":{}|<>]')) {
      return "Password must contain at least one special character";
    }

    return null;
  }
}