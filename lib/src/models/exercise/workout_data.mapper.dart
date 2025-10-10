// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'workout_data.dart';

class WorkoutFocusMapper extends EnumMapper<WorkoutFocus> {
  WorkoutFocusMapper._();

  static WorkoutFocusMapper? _instance;
  static WorkoutFocusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WorkoutFocusMapper._());
    }
    return _instance!;
  }

  static WorkoutFocus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  WorkoutFocus decode(dynamic value) {
    switch (value) {
      case r'leg':
        return WorkoutFocus.leg;
      case r'upperBody':
        return WorkoutFocus.upperBody;
      case r'cardio':
        return WorkoutFocus.cardio;
      case r'core':
        return WorkoutFocus.core;
      case r'fullBody':
        return WorkoutFocus.fullBody;
      case r'rest':
        return WorkoutFocus.rest;
      case r'yoga':
        return WorkoutFocus.yoga;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(WorkoutFocus self) {
    switch (self) {
      case WorkoutFocus.leg:
        return r'leg';
      case WorkoutFocus.upperBody:
        return r'upperBody';
      case WorkoutFocus.cardio:
        return r'cardio';
      case WorkoutFocus.core:
        return r'core';
      case WorkoutFocus.fullBody:
        return r'fullBody';
      case WorkoutFocus.rest:
        return r'rest';
      case WorkoutFocus.yoga:
        return r'yoga';
    }
  }
}

extension WorkoutFocusMapperExtension on WorkoutFocus {
  String toValue() {
    WorkoutFocusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<WorkoutFocus>(this) as String;
  }
}

class WorkoutDataMapper extends ClassMapperBase<WorkoutData> {
  WorkoutDataMapper._();

  static WorkoutDataMapper? _instance;
  static WorkoutDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WorkoutDataMapper._());
      ExerciseDataMapper.ensureInitialized();
      WorkoutFocusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'WorkoutData';

  static List<ExerciseData> _$exercises(WorkoutData v) => v.exercises;
  static const Field<WorkoutData, List<ExerciseData>> _f$exercises = Field(
    'exercises',
    _$exercises,
  );
  static WorkoutFocus _$focus(WorkoutData v) => v.focus;
  static const Field<WorkoutData, WorkoutFocus> _f$focus = Field(
    'focus',
    _$focus,
  );
  static double _$caloriesBurned(WorkoutData v) => v.caloriesBurned;
  static const Field<WorkoutData, double> _f$caloriesBurned = Field(
    'caloriesBurned',
    _$caloriesBurned,
  );
  static Duration _$duration(WorkoutData v) => v.duration;
  static const Field<WorkoutData, Duration> _f$duration = Field(
    'duration',
    _$duration,
  );
  static String _$summary(WorkoutData v) => v.summary;
  static const Field<WorkoutData, String> _f$summary = Field(
    'summary',
    _$summary,
  );

  @override
  final MappableFields<WorkoutData> fields = const {
    #exercises: _f$exercises,
    #focus: _f$focus,
    #caloriesBurned: _f$caloriesBurned,
    #duration: _f$duration,
    #summary: _f$summary,
  };

  static WorkoutData _instantiate(DecodingData data) {
    return WorkoutData(
      exercises: data.dec(_f$exercises),
      focus: data.dec(_f$focus),
      caloriesBurned: data.dec(_f$caloriesBurned),
      duration: data.dec(_f$duration),
      summary: data.dec(_f$summary),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static WorkoutData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WorkoutData>(map);
  }

  static WorkoutData fromJson(String json) {
    return ensureInitialized().decodeJson<WorkoutData>(json);
  }
}

mixin WorkoutDataMappable {
  String toJson() {
    return WorkoutDataMapper.ensureInitialized().encodeJson<WorkoutData>(
      this as WorkoutData,
    );
  }

  Map<String, dynamic> toMap() {
    return WorkoutDataMapper.ensureInitialized().encodeMap<WorkoutData>(
      this as WorkoutData,
    );
  }

  WorkoutDataCopyWith<WorkoutData, WorkoutData, WorkoutData> get copyWith =>
      _WorkoutDataCopyWithImpl<WorkoutData, WorkoutData>(
        this as WorkoutData,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return WorkoutDataMapper.ensureInitialized().stringifyValue(
      this as WorkoutData,
    );
  }

  @override
  bool operator ==(Object other) {
    return WorkoutDataMapper.ensureInitialized().equalsValue(
      this as WorkoutData,
      other,
    );
  }

  @override
  int get hashCode {
    return WorkoutDataMapper.ensureInitialized().hashValue(this as WorkoutData);
  }
}

extension WorkoutDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, WorkoutData, $Out> {
  WorkoutDataCopyWith<$R, WorkoutData, $Out> get $asWorkoutData =>
      $base.as((v, t, t2) => _WorkoutDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class WorkoutDataCopyWith<$R, $In extends WorkoutData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    ExerciseData,
    ExerciseDataCopyWith<$R, ExerciseData, ExerciseData>
  >
  get exercises;
  $R call({
    List<ExerciseData>? exercises,
    WorkoutFocus? focus,
    double? caloriesBurned,
    Duration? duration,
    String? summary,
  });
  WorkoutDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _WorkoutDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WorkoutData, $Out>
    implements WorkoutDataCopyWith<$R, WorkoutData, $Out> {
  _WorkoutDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WorkoutData> $mapper =
      WorkoutDataMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    ExerciseData,
    ExerciseDataCopyWith<$R, ExerciseData, ExerciseData>
  >
  get exercises => ListCopyWith(
    $value.exercises,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(exercises: v),
  );
  @override
  $R call({
    List<ExerciseData>? exercises,
    WorkoutFocus? focus,
    double? caloriesBurned,
    Duration? duration,
    String? summary,
  }) => $apply(
    FieldCopyWithData({
      if (exercises != null) #exercises: exercises,
      if (focus != null) #focus: focus,
      if (caloriesBurned != null) #caloriesBurned: caloriesBurned,
      if (duration != null) #duration: duration,
      if (summary != null) #summary: summary,
    }),
  );
  @override
  WorkoutData $make(CopyWithData data) => WorkoutData(
    exercises: data.get(#exercises, or: $value.exercises),
    focus: data.get(#focus, or: $value.focus),
    caloriesBurned: data.get(#caloriesBurned, or: $value.caloriesBurned),
    duration: data.get(#duration, or: $value.duration),
    summary: data.get(#summary, or: $value.summary),
  );

  @override
  WorkoutDataCopyWith<$R2, WorkoutData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _WorkoutDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

