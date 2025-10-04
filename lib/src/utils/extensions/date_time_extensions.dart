extension DateTimeExtensions on DateTime {
  String toImpreciseString() => "$year:$month:$day";
}

extension DurationExtensions on Duration {
  DateTime toDateTime() =>
      DateTime(1, 1, 1, inHours % 24, inMinutes % 60, inSeconds % 60);
}
