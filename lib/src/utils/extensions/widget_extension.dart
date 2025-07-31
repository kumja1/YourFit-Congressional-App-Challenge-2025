import "package:flutter/material.dart";

extension WidgetExtensions on Widget {
  Widget sized({double? width, double? height}) =>
      SizedBox(width: width, height: height, child: this);
}
