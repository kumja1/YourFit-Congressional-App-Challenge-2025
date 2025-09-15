import 'package:dart_mappable/dart_mappable.dart';

class DurationMapper extends SimpleMapper<Duration> {
  const DurationMapper();

  @override
  Object? encode(Duration self) => {"inSeconds": self.inSeconds};

  @override
  Duration decode(Object? self) => self is Map<String, dynamic>
      ? Duration(seconds: self["inSeconds"])
      : throw Exception("Invalid type");
}
