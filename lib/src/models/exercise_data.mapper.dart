// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'exercise_data.dart';

class ExerciseDataMapper extends ClassMapperBase<ExerciseData> {
  ExerciseDataMapper._();

  static ExerciseDataMapper? _instance;
  static ExerciseDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExerciseDataMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ExerciseData';

  static Duration _$timeLeft(ExerciseData v) => v.timeLeft;
  static const Field<ExerciseData, Duration> _f$timeLeft =
      Field('timeLeft', _$timeLeft);
  static int _$intensity(ExerciseData v) => v.intensity;
  static const Field<ExerciseData, int> _f$intensity =
      Field('intensity', _$intensity);
  static double _$caloriesBurned(ExerciseData v) => v.caloriesBurned;
  static const Field<ExerciseData, double> _f$caloriesBurned =
      Field('caloriesBurned', _$caloriesBurned);
  static String _$name(ExerciseData v) => v.name;
  static const Field<ExerciseData, String> _f$name = Field('name', _$name);
  static bool _$isCompleted(ExerciseData v) => v.isCompleted;
  static const Field<ExerciseData, bool> _f$isCompleted =
      Field('isCompleted', _$isCompleted);

  @override
  final MappableFields<ExerciseData> fields = const {
    #timeLeft: _f$timeLeft,
    #intensity: _f$intensity,
    #caloriesBurned: _f$caloriesBurned,
    #name: _f$name,
    #isCompleted: _f$isCompleted,
  };

  static ExerciseData _instantiate(DecodingData data) {
    return ExerciseData(
        timeLeft: data.dec(_f$timeLeft),
        intensity: data.dec(_f$intensity),
        caloriesBurned: data.dec(_f$caloriesBurned),
        name: data.dec(_f$name),
        isCompleted: data.dec(_f$isCompleted));
  }

  @override
  final Function instantiate = _instantiate;

  static ExerciseData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExerciseData>(map);
  }

  static ExerciseData fromJson(String json) {
    return ensureInitialized().decodeJson<ExerciseData>(json);
  }
}

mixin ExerciseDataMappable {
  String toJson() {
    return ExerciseDataMapper.ensureInitialized()
        .encodeJson<ExerciseData>(this as ExerciseData);
  }

  Map<String, dynamic> toMap() {
    return ExerciseDataMapper.ensureInitialized()
        .encodeMap<ExerciseData>(this as ExerciseData);
  }

  ExerciseDataCopyWith<ExerciseData, ExerciseData, ExerciseData> get copyWith =>
      _ExerciseDataCopyWithImpl<ExerciseData, ExerciseData>(
          this as ExerciseData, $identity, $identity);
  @override
  String toString() {
    return ExerciseDataMapper.ensureInitialized()
        .stringifyValue(this as ExerciseData);
  }

  @override
  bool operator ==(Object other) {
    return ExerciseDataMapper.ensureInitialized()
        .equalsValue(this as ExerciseData, other);
  }

  @override
  int get hashCode {
    return ExerciseDataMapper.ensureInitialized()
        .hashValue(this as ExerciseData);
  }
}

extension ExerciseDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExerciseData, $Out> {
  ExerciseDataCopyWith<$R, ExerciseData, $Out> get $asExerciseData =>
      $base.as((v, t, t2) => _ExerciseDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ExerciseDataCopyWith<$R, $In extends ExerciseData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {Duration? timeLeft,
      int? intensity,
      double? caloriesBurned,
      String? name,
      bool? isCompleted});
  ExerciseDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ExerciseDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExerciseData, $Out>
    implements ExerciseDataCopyWith<$R, ExerciseData, $Out> {
  _ExerciseDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExerciseData> $mapper =
      ExerciseDataMapper.ensureInitialized();
  @override
  $R call(
          {Duration? timeLeft,
          int? intensity,
          double? caloriesBurned,
          String? name,
          bool? isCompleted}) =>
      $apply(FieldCopyWithData({
        if (timeLeft != null) #timeLeft: timeLeft,
        if (intensity != null) #intensity: intensity,
        if (caloriesBurned != null) #caloriesBurned: caloriesBurned,
        if (name != null) #name: name,
        if (isCompleted != null) #isCompleted: isCompleted
      }));
  @override
  ExerciseData $make(CopyWithData data) => ExerciseData(
      timeLeft: data.get(#timeLeft, or: $value.timeLeft),
      intensity: data.get(#intensity, or: $value.intensity),
      caloriesBurned: data.get(#caloriesBurned, or: $value.caloriesBurned),
      name: data.get(#name, or: $value.name),
      isCompleted: data.get(#isCompleted, or: $value.isCompleted));

  @override
  ExerciseDataCopyWith<$R2, ExerciseData, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ExerciseDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
