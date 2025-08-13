import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:columnbuilder/columnbuilder.dart';
import 'package:flutter/material.dart';

class AnimatedList extends StatelessWidget {
  final Duration duration;
  final Curve switchInCurve;
  final Curve switchOutCurve;
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;

  const AnimatedList({
    super.key,
    required this.duration,
    required this.itemBuilder,
    required this.itemCount,
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
  });

  @override
  Widget build(BuildContext context) => AnimatedSwitcherPlus.translationRight(
    duration: duration,
    switchOutCurve: switchOutCurve,
    switchInCurve: switchInCurve,
    offset: 1.5,
    child: ColumnBuilder(
      key: UniqueKey(),
      itemBuilder: itemBuilder,
      itemCount: itemCount,
    ),
  );
}
