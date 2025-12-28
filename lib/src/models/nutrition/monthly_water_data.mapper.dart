// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'monthly_water_data.dart';

class MonthlyWaterDataMapper extends ClassMapperBase<MonthlyWaterData> {
  MonthlyWaterDataMapper._();

  static MonthlyWaterDataMapper? _instance;
  static MonthlyWaterDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MonthlyWaterDataMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MonthlyWaterData';

  static const Field<MonthlyWaterData, String> _f$json = Field(
    'json',
    null,
    mode: FieldMode.param,
  );

  @override
  final MappableFields<MonthlyWaterData> fields = const {#json: _f$json};

  static MonthlyWaterData _instantiate(DecodingData data) {
    return MonthlyWaterData.fromJson(data.dec(_f$json));
  }

  @override
  final Function instantiate = _instantiate;

  static MonthlyWaterData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MonthlyWaterData>(map);
  }

  static MonthlyWaterData fromJson(String json) {
    return ensureInitialized().decodeJson<MonthlyWaterData>(json);
  }
}

mixin MonthlyWaterDataMappable {
  String toJson() {
    return MonthlyWaterDataMapper.ensureInitialized()
        .encodeJson<MonthlyWaterData>(this as MonthlyWaterData);
  }

  Map<String, dynamic> toMap() {
    return MonthlyWaterDataMapper.ensureInitialized()
        .encodeMap<MonthlyWaterData>(this as MonthlyWaterData);
  }

  MonthlyWaterDataCopyWith<MonthlyWaterData, MonthlyWaterData, MonthlyWaterData>
  get copyWith =>
      _MonthlyWaterDataCopyWithImpl<MonthlyWaterData, MonthlyWaterData>(
        this as MonthlyWaterData,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MonthlyWaterDataMapper.ensureInitialized().stringifyValue(
      this as MonthlyWaterData,
    );
  }

  @override
  bool operator ==(Object other) {
    return MonthlyWaterDataMapper.ensureInitialized().equalsValue(
      this as MonthlyWaterData,
      other,
    );
  }

  @override
  int get hashCode {
    return MonthlyWaterDataMapper.ensureInitialized().hashValue(
      this as MonthlyWaterData,
    );
  }
}

extension MonthlyWaterDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MonthlyWaterData, $Out> {
  MonthlyWaterDataCopyWith<$R, MonthlyWaterData, $Out>
  get $asMonthlyWaterData =>
      $base.as((v, t, t2) => _MonthlyWaterDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MonthlyWaterDataCopyWith<$R, $In extends MonthlyWaterData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({required String json});
  MonthlyWaterDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MonthlyWaterDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MonthlyWaterData, $Out>
    implements MonthlyWaterDataCopyWith<$R, MonthlyWaterData, $Out> {
  _MonthlyWaterDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MonthlyWaterData> $mapper =
      MonthlyWaterDataMapper.ensureInitialized();
  @override
  $R call({required String json}) => $apply(FieldCopyWithData({#json: json}));
  @override
  MonthlyWaterData $make(CopyWithData data) =>
      MonthlyWaterData.fromJson(data.get(#json));

  @override
  MonthlyWaterDataCopyWith<$R2, MonthlyWaterData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MonthlyWaterDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

