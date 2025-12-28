// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'monthly_workout_data.dart';

class MonthlyWorkoutDataMapper extends ClassMapperBase<MonthlyWorkoutData> {
  MonthlyWorkoutDataMapper._();

  static MonthlyWorkoutDataMapper? _instance;
  static MonthlyWorkoutDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MonthlyWorkoutDataMapper._());
      WorkoutDataMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MonthlyWorkoutData';

  static Map<String, WorkoutData> _$workouts(MonthlyWorkoutData v) =>
      v.workouts;
  static const Field<MonthlyWorkoutData, Map<String, WorkoutData>> _f$workouts =
      Field('workouts', _$workouts);

  @override
  final MappableFields<MonthlyWorkoutData> fields = const {
    #workouts: _f$workouts,
  };

  static MonthlyWorkoutData _instantiate(DecodingData data) {
    return MonthlyWorkoutData(workouts: data.dec(_f$workouts));
  }

  @override
  final Function instantiate = _instantiate;

  static MonthlyWorkoutData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MonthlyWorkoutData>(map);
  }

  static MonthlyWorkoutData fromJson(String json) {
    return ensureInitialized().decodeJson<MonthlyWorkoutData>(json);
  }
}

mixin MonthlyWorkoutDataMappable {
  String toJson() {
    return MonthlyWorkoutDataMapper.ensureInitialized()
        .encodeJson<MonthlyWorkoutData>(this as MonthlyWorkoutData);
  }

  Map<String, dynamic> toMap() {
    return MonthlyWorkoutDataMapper.ensureInitialized()
        .encodeMap<MonthlyWorkoutData>(this as MonthlyWorkoutData);
  }

  MonthlyWorkoutDataCopyWith<
    MonthlyWorkoutData,
    MonthlyWorkoutData,
    MonthlyWorkoutData
  >
  get copyWith =>
      _MonthlyWorkoutDataCopyWithImpl<MonthlyWorkoutData, MonthlyWorkoutData>(
        this as MonthlyWorkoutData,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MonthlyWorkoutDataMapper.ensureInitialized().stringifyValue(
      this as MonthlyWorkoutData,
    );
  }

  @override
  bool operator ==(Object other) {
    return MonthlyWorkoutDataMapper.ensureInitialized().equalsValue(
      this as MonthlyWorkoutData,
      other,
    );
  }

  @override
  int get hashCode {
    return MonthlyWorkoutDataMapper.ensureInitialized().hashValue(
      this as MonthlyWorkoutData,
    );
  }
}

extension MonthlyWorkoutDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MonthlyWorkoutData, $Out> {
  MonthlyWorkoutDataCopyWith<$R, MonthlyWorkoutData, $Out>
  get $asMonthlyWorkoutData => $base.as(
    (v, t, t2) => _MonthlyWorkoutDataCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class MonthlyWorkoutDataCopyWith<
  $R,
  $In extends MonthlyWorkoutData,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<
    $R,
    String,
    WorkoutData,
    WorkoutDataCopyWith<$R, WorkoutData, WorkoutData>
  >
  get workouts;
  $R call({Map<String, WorkoutData>? workouts});
  MonthlyWorkoutDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MonthlyWorkoutDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MonthlyWorkoutData, $Out>
    implements MonthlyWorkoutDataCopyWith<$R, MonthlyWorkoutData, $Out> {
  _MonthlyWorkoutDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MonthlyWorkoutData> $mapper =
      MonthlyWorkoutDataMapper.ensureInitialized();
  @override
  MapCopyWith<
    $R,
    String,
    WorkoutData,
    WorkoutDataCopyWith<$R, WorkoutData, WorkoutData>
  >
  get workouts => MapCopyWith(
    $value.workouts,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(workouts: v),
  );
  @override
  $R call({Map<String, WorkoutData>? workouts}) =>
      $apply(FieldCopyWithData({if (workouts != null) #workouts: workouts}));
  @override
  MonthlyWorkoutData $make(CopyWithData data) =>
      MonthlyWorkoutData(workouts: data.get(#workouts, or: $value.workouts));

  @override
  MonthlyWorkoutDataCopyWith<$R2, MonthlyWorkoutData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MonthlyWorkoutDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

