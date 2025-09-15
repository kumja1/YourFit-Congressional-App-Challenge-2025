import 'package:flutter/foundation.dart';

@immutable
class ExerciseItem {
  final String name;
  final String qty;
  const ExerciseItem({required this.name, required this.qty});
}

@immutable
class ExecProgress {
  final int done;
  final int total;
  const ExecProgress(this.done, this.total);
}
