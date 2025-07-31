// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'month_data.dart';

class MonthDataMapper extends ClassMapperBase<MonthData> {
  MonthDataMapper._();

  static MonthDataMapper? _instance;
  static MonthDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MonthDataMapper._());
      DayDataMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MonthData';

  static Map<int, DayData> _$days(MonthData v) => v.days;
  static const Field<MonthData, Map<int, DayData>> _f$days =
      Field('days', _$days);

  @override
  final MappableFields<MonthData> fields = const {
    #days: _f$days,
  };

  static MonthData _instantiate(DecodingData data) {
    return MonthData(days: data.dec(_f$days));
  }

  @override
  final Function instantiate = _instantiate;

  static MonthData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MonthData>(map);
  }

  static MonthData fromJson(String json) {
    return ensureInitialized().decodeJson<MonthData>(json);
  }
}

mixin MonthDataMappable {
  String toJson() {
    return MonthDataMapper.ensureInitialized()
        .encodeJson<MonthData>(this as MonthData);
  }

  Map<String, dynamic> toMap() {
    return MonthDataMapper.ensureInitialized()
        .encodeMap<MonthData>(this as MonthData);
  }

  MonthDataCopyWith<MonthData, MonthData, MonthData> get copyWith =>
      _MonthDataCopyWithImpl<MonthData, MonthData>(
          this as MonthData, $identity, $identity);
  @override
  String toString() {
    return MonthDataMapper.ensureInitialized()
        .stringifyValue(this as MonthData);
  }

  @override
  bool operator ==(Object other) {
    return MonthDataMapper.ensureInitialized()
        .equalsValue(this as MonthData, other);
  }

  @override
  int get hashCode {
    return MonthDataMapper.ensureInitialized().hashValue(this as MonthData);
  }
}

extension MonthDataValueCopy<$R, $Out> on ObjectCopyWith<$R, MonthData, $Out> {
  MonthDataCopyWith<$R, MonthData, $Out> get $asMonthData =>
      $base.as((v, t, t2) => _MonthDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MonthDataCopyWith<$R, $In extends MonthData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, int, DayData, DayDataCopyWith<$R, DayData, DayData>> get days;
  $R call({Map<int, DayData>? days});
  MonthDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MonthDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MonthData, $Out>
    implements MonthDataCopyWith<$R, MonthData, $Out> {
  _MonthDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MonthData> $mapper =
      MonthDataMapper.ensureInitialized();
  @override
  MapCopyWith<$R, int, DayData, DayDataCopyWith<$R, DayData, DayData>>
      get days => MapCopyWith(
          $value.days, (v, t) => v.copyWith.$chain(t), (v) => call(days: v));
  @override
  $R call({Map<int, DayData>? days}) =>
      $apply(FieldCopyWithData({if (days != null) #days: days}));
  @override
  MonthData $make(CopyWithData data) =>
      MonthData(days: data.get(#days, or: $value.days));

  @override
  MonthDataCopyWith<$R2, MonthData, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MonthDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
