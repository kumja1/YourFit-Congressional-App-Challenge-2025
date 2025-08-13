import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  final Widget text;

  final Icon icon;

  final String? helperText;

  final TextStyle? helperStyle;

  final double spacing;

  const TextIcon({
    super.key,
    required this.text,
    required this.icon,
    this.helperText,
    this.helperStyle,
    this.spacing = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: spacing,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            text.align(Alignment.centerLeft),
            Align(
              widthFactor: 1,
              alignment: Alignment.bottomLeft,
              child: Text(
                helperText!,
                style:
                    helperStyle ??
                    const TextStyle(color: Colors.black12, fontSize: 12),
                textAlign: TextAlign.justify,
              ),
            ).showIf(helperText != null),
          ],
        ),
      ],
    ).center();
  }
}
