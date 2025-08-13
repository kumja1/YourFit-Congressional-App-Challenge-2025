import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcons {
  static final googleIcon = const SvgPicture(
    SvgAssetLoader("icons/auth/google.svg"),
    width: 29,
    height: 29,
  );

  static final intensityIcon = const ImageIcon(
    AssetImage("icons/intensity.png"),
  );

  static final calorieIcon = const ImageIcon(AssetImage("icons/calorie.png"));
}
