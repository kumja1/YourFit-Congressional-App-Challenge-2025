// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'day_data.dart';

class DayDataMapper extends ClassMapperBase<DayData> {
  DayDataMapper._();

  static DayDataMapper? _instance;
  static DayDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DayDataMapper._());
      ExerciseDataMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DayData';

  static List<ExerciseData> _$exercises(DayData v) => v.exercises;
  static const Field<DayData, List<ExerciseData>> _f$exercises =
      Field('exercises', _$exercises);
  static double _$caloriesBurned(DayData v) => v.caloriesBurned;
  static const Field<DayData, double> _f$caloriesBurned =
      Field('caloriesBurned', _$caloriesBurned);

  @override
  final MappableFields<DayData> fields = const {
    #exercises: _f$exercises,
    #caloriesBurned: _f$caloriesBurned,
  };

  static DayData _instantiate(DecodingData data) {
    return DayData(
        exercises: data.dec(_f$exercises),
        caloriesBurned: data.dec(_f$caloriesBurned));
  }

  @override
  final Function instantiate = _instantiate;

  static DayData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DayData>(map);
  }

  static DayData fromJson(String json) {
    return ensureInitialized().decodeJson<DayData>(json);
  }
}

mixin DayDataMappable {
  String toJson() {
    return DayDataMapper.ensureInitialized()
        .encodeJson<DayData>(this as DayData);
  }

  Map<String, dynamic> toMap() {
    return DayDataMapper.ensureInitialized()
        .encodeMap<DayData>(this as DayData);
  }

  DayDataCopyWith<DayData, DayData, DayData> get copyWith =>
      _DayDataCopyWithImpl<DayData, DayData>(
          this as DayData, $identity, $identity);
  @override
  String toString() {
    return DayDataMapper.ensureInitialized().stringifyValue(this as DayData);
  }

  @override
  bool operator ==(Object other) {
    return DayDataMapper.ensureInitialized()
        .equalsValue(this as DayData, other);
  }

  @override
  int get hashCode {
    return DayDataMapper.ensureInitialized().hashValue(this as DayData);
  }
}

extension DayDataValueCopy<$R, $Out> on ObjectCopyWith<$R, DayData, $Out> {
  DayDataCopyWith<$R, DayData, $Out> get $asDayData =>
      $base.as((v, t, t2) => _DayDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DayDataCopyWith<$R, $In extends DayData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, ExerciseData,
      ExerciseDataCopyWith<$R, ExerciseData, ExerciseData>> get exercises;
  $R call({List<ExerciseData>? exercises, double? caloriesBurned});
  DayDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DayDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DayData, $Out>
    implements DayDataCopyWith<$R, DayData, $Out> {
  _DayDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DayData> $mapper =
      DayDataMapper.ensureInitialized();
  @override
  ListCopyWith<$R, ExerciseData,
          ExerciseDataCopyWith<$R, ExerciseData, ExerciseData>>
      get exercises => ListCopyWith($value.exercises,
          (v, t) => v.copyWith.$chain(t), (v) => call(exercises: v));
  @override
  $R call({List<ExerciseData>? exercises, double? caloriesBurned}) =>
      $apply(FieldCopyWithData({
        if (exercises != null) #exercises: exercises,
        if (caloriesBurned != null) #caloriesBurned: caloriesBurned
      }));
  @override
  DayData $make(CopyWithData data) => DayData(
      exercises: data.get(#exercises, or: $value.exercises),
      caloriesBurned: data.get(#caloriesBurned, or: $value.caloriesBurned));

  @override
  DayDataCopyWith<$R2, DayData, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DayDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
