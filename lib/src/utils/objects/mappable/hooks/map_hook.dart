import 'package:dart_mappable/dart_mappable.dart';
import 'package:get/get.dart';

class MapHook extends MappingHook {
  const MapHook();

  @override
  Object? beforeEncode(Object? value) {
    if (value is! Map<dynamic, dynamic>) {
      return super.beforeEncode(value);
    }

    return value.map(
      (key, value) => MapEntry(key.toString(), value),
    );
  }

  @override
  Object? afterDecode(Object? value) {
    if (value is! Map<dynamic, dynamic>) {
      return super.afterDecode(value);
    }
    return value.map(
      (key, value) =>
          MapEntry(GetUtils.isNum(key) ? num.parse(key) : key, value),
    );
  }
}
