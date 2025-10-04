import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yourfit/src/utils/extensions/widget_extension.dart';

class NumberFormField<T extends num> extends StatelessWidget {
  final Function(T value)? onChanged;
  final String? Function(T? value)? validator;
  final Function(T value)? onSaved;
  final String labelText;
  final T? initialValue;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;
  final double? height;

  const NumberFormField({
    super.key,
    required this.labelText,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.width = 360,
    this.height,
    this.onSaved,
    this.labelStyle = const TextStyle(color: Colors.black12),
    this.floatingLabelStyle = const TextStyle(color: Colors.blue),
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      ...inputFormatters ?? [],
    ],
    initialValue: initialValue.toString(),
    decoration: InputDecoration(
      labelStyle: labelStyle,
      labelText: labelText,
      floatingLabelStyle: floatingLabelStyle,
    ),
    onChanged: (s) {
      if (onChanged == null) return;
      onChanged!(num.parse(s) as T);
    },
    validator: (s) {
      if (s == null || validator == null) return "";
      return validator!(num.parse(s) as T);
    },
    onSaved: (s) {
      if (s == null || onSaved == null) return;
      onSaved!(num.parse(s) as T);
    },
  ).sized(width: width, height: height);
}
