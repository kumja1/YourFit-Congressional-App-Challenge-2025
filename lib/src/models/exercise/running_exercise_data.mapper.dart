// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'running_exercise_data.dart';

class RunningExerciseDataMapper
    extends SubClassMapperBase<RunningExerciseData> {
  RunningExerciseDataMapper._();

  static RunningExerciseDataMapper? _instance;
  static RunningExerciseDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RunningExerciseDataMapper._());
      ExerciseDataMapper.ensureInitialized().addSubMapper(_instance!);
      ExerciseDifficultyMapper.ensureInitialized();
      ExerciseIntensityMapper.ensureInitialized();
      ExerciseTypeMapper.ensureInitialized();
      RestIntervalMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RunningExerciseData';

  static ExerciseDifficulty _$difficulty(RunningExerciseData v) => v.difficulty;
  static const Field<RunningExerciseData, ExerciseDifficulty> _f$difficulty =
      Field('difficulty', _$difficulty);
  static ExerciseIntensity _$intensity(RunningExerciseData v) => v.intensity;
  static const Field<RunningExerciseData, ExerciseIntensity> _f$intensity =
      Field('intensity', _$intensity);
  static ExerciseType _$type(RunningExerciseData v) => v.type;
  static const Field<RunningExerciseData, ExerciseType> _f$type = Field(
    'type',
    _$type,
  );
  static double _$caloriesBurned(RunningExerciseData v) => v.caloriesBurned;
  static const Field<RunningExerciseData, double> _f$caloriesBurned = Field(
    'caloriesBurned',
    _$caloriesBurned,
  );
  static String _$name(RunningExerciseData v) => v.name;
  static const Field<RunningExerciseData, String> _f$name = Field(
    'name',
    _$name,
  );
  static String _$instructions(RunningExerciseData v) => v.instructions;
  static const Field<RunningExerciseData, String> _f$instructions = Field(
    'instructions',
    _$instructions,
  );
  static String _$summary(RunningExerciseData v) => v.summary;
  static const Field<RunningExerciseData, String> _f$summary = Field(
    'summary',
    _$summary,
  );
  static int _$sets(RunningExerciseData v) => v.sets;
  static const Field<RunningExerciseData, int> _f$sets = Field('sets', _$sets);
  static int _$reps(RunningExerciseData v) => v.reps;
  static const Field<RunningExerciseData, int> _f$reps = Field('reps', _$reps);
  static Duration _$duration(RunningExerciseData v) => v.duration;
  static const Field<RunningExerciseData, Duration> _f$duration = Field(
    'duration',
    _$duration,
  );
  static List<String> _$targetMuscles(RunningExerciseData v) => v.targetMuscles;
  static const Field<RunningExerciseData, List<String>> _f$targetMuscles =
      Field('targetMuscles', _$targetMuscles, opt: true, def: const []);
  static List<String> _$equipment(RunningExerciseData v) => v.equipment;
  static const Field<RunningExerciseData, List<String>> _f$equipment = Field(
    'equipment',
    _$equipment,
    opt: true,
    def: const [],
  );
  static List<RestInterval> _$restIntervals(RunningExerciseData v) =>
      v.restIntervals;
  static const Field<RunningExerciseData, List<RestInterval>> _f$restIntervals =
      Field(
        'restIntervals',
        _$restIntervals,
        opt: true,
        def: const [],
        hook: MapHook(),
      );
  static String _$destination(RunningExerciseData v) => v.destination;
  static const Field<RunningExerciseData, String> _f$destination = Field(
    'destination',
    _$destination,
  );
  static double _$distance(RunningExerciseData v) => v.distance;
  static const Field<RunningExerciseData, double> _f$distance = Field(
    'distance',
    _$distance,
  );
  static int _$speed(RunningExerciseData v) => v.speed;
  static const Field<RunningExerciseData, int> _f$speed = Field(
    'speed',
    _$speed,
  );
  static ExerciseState _$state(RunningExerciseData v) => v.state;
  static const Field<RunningExerciseData, ExerciseState> _f$state = Field(
    'state',
    _$state,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<RunningExerciseData> fields = const {
    #difficulty: _f$difficulty,
    #intensity: _f$intensity,
    #type: _f$type,
    #caloriesBurned: _f$caloriesBurned,
    #name: _f$name,
    #instructions: _f$instructions,
    #summary: _f$summary,
    #sets: _f$sets,
    #reps: _f$reps,
    #duration: _f$duration,
    #targetMuscles: _f$targetMuscles,
    #equipment: _f$equipment,
    #restIntervals: _f$restIntervals,
    #destination: _f$destination,
    #distance: _f$distance,
    #speed: _f$speed,
    #state: _f$state,
  };

  @override
  final String discriminatorKey = 'base';
  @override
  final dynamic discriminatorValue = 'RunningExerciseData';
  @override
  late final ClassMapperBase superMapper =
      ExerciseDataMapper.ensureInitialized();

  static RunningExerciseData _instantiate(DecodingData data) {
    return RunningExerciseData(
      difficulty: data.dec(_f$difficulty),
      intensity: data.dec(_f$intensity),
      type: data.dec(_f$type),
      caloriesBurned: data.dec(_f$caloriesBurned),
      name: data.dec(_f$name),
      instructions: data.dec(_f$instructions),
      summary: data.dec(_f$summary),
      sets: data.dec(_f$sets),
      reps: data.dec(_f$reps),
      duration: data.dec(_f$duration),
      targetMuscles: data.dec(_f$targetMuscles),
      equipment: data.dec(_f$equipment),
      restIntervals: data.dec(_f$restIntervals),
      destination: data.dec(_f$destination),
      distance: data.dec(_f$distance),
      speed: data.dec(_f$speed),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RunningExerciseData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RunningExerciseData>(map);
  }

  static RunningExerciseData fromJson(String json) {
    return ensureInitialized().decodeJson<RunningExerciseData>(json);
  }
}

mixin RunningExerciseDataMappable {
  String toJson() {
    return RunningExerciseDataMapper.ensureInitialized()
        .encodeJson<RunningExerciseData>(this as RunningExerciseData);
  }

  Map<String, dynamic> toMap() {
    return RunningExerciseDataMapper.ensureInitialized()
        .encodeMap<RunningExerciseData>(this as RunningExerciseData);
  }

  RunningExerciseDataCopyWith<
    RunningExerciseData,
    RunningExerciseData,
    RunningExerciseData
  >
  get copyWith =>
      _RunningExerciseDataCopyWithImpl<
        RunningExerciseData,
        RunningExerciseData
      >(this as RunningExerciseData, $identity, $identity);
  @override
  String toString() {
    return RunningExerciseDataMapper.ensureInitialized().stringifyValue(
      this as RunningExerciseData,
    );
  }

  @override
  bool operator ==(Object other) {
    return RunningExerciseDataMapper.ensureInitialized().equalsValue(
      this as RunningExerciseData,
      other,
    );
  }

  @override
  int get hashCode {
    return RunningExerciseDataMapper.ensureInitialized().hashValue(
      this as RunningExerciseData,
    );
  }
}

extension RunningExerciseDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RunningExerciseData, $Out> {
  RunningExerciseDataCopyWith<$R, RunningExerciseData, $Out>
  get $asRunningExerciseData => $base.as(
    (v, t, t2) => _RunningExerciseDataCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class RunningExerciseDataCopyWith<
  $R,
  $In extends RunningExerciseData,
  $Out
>
    implements ExerciseDataCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get targetMuscles;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get equipment;
  @override
  ListCopyWith<
    $R,
    RestInterval,
    RestIntervalCopyWith<$R, RestInterval, RestInterval>
  >
  get restIntervals;
  @override
  $R call({
    ExerciseDifficulty? difficulty,
    ExerciseIntensity? intensity,
    ExerciseType? type,
    double? caloriesBurned,
    String? name,
    String? instructions,
    String? summary,
    int? sets,
    int? reps,
    Duration? duration,
    List<String>? targetMuscles,
    List<String>? equipment,
    List<RestInterval>? restIntervals,
    String? destination,
    double? distance,
    int? speed,
  });
  RunningExerciseDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RunningExerciseDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RunningExerciseData, $Out>
    implements RunningExerciseDataCopyWith<$R, RunningExerciseData, $Out> {
  _RunningExerciseDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RunningExerciseData> $mapper =
      RunningExerciseDataMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get targetMuscles => ListCopyWith(
    $value.targetMuscles,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(targetMuscles: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get equipment =>
      ListCopyWith(
        $value.equipment,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(equipment: v),
      );
  @override
  ListCopyWith<
    $R,
    RestInterval,
    RestIntervalCopyWith<$R, RestInterval, RestInterval>
  >
  get restIntervals => ListCopyWith(
    $value.restIntervals,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(restIntervals: v),
  );
  @override
  $R call({
    ExerciseDifficulty? difficulty,
    ExerciseIntensity? intensity,
    ExerciseType? type,
    double? caloriesBurned,
    String? name,
    String? instructions,
    String? summary,
    int? sets,
    int? reps,
    Duration? duration,
    List<String>? targetMuscles,
    List<String>? equipment,
    List<RestInterval>? restIntervals,
    String? destination,
    double? distance,
    int? speed,
  }) => $apply(
    FieldCopyWithData({
      if (difficulty != null) #difficulty: difficulty,
      if (intensity != null) #intensity: intensity,
      if (type != null) #type: type,
      if (caloriesBurned != null) #caloriesBurned: caloriesBurned,
      if (name != null) #name: name,
      if (instructions != null) #instructions: instructions,
      if (summary != null) #summary: summary,
      if (sets != null) #sets: sets,
      if (reps != null) #reps: reps,
      if (duration != null) #duration: duration,
      if (targetMuscles != null) #targetMuscles: targetMuscles,
      if (equipment != null) #equipment: equipment,
      if (restIntervals != null) #restIntervals: restIntervals,
      if (destination != null) #destination: destination,
      if (distance != null) #distance: distance,
      if (speed != null) #speed: speed,
    }),
  );
  @override
  RunningExerciseData $make(CopyWithData data) => RunningExerciseData(
    difficulty: data.get(#difficulty, or: $value.difficulty),
    intensity: data.get(#intensity, or: $value.intensity),
    type: data.get(#type, or: $value.type),
    caloriesBurned: data.get(#caloriesBurned, or: $value.caloriesBurned),
    name: data.get(#name, or: $value.name),
    instructions: data.get(#instructions, or: $value.instructions),
    summary: data.get(#summary, or: $value.summary),
    sets: data.get(#sets, or: $value.sets),
    reps: data.get(#reps, or: $value.reps),
    duration: data.get(#duration, or: $value.duration),
    targetMuscles: data.get(#targetMuscles, or: $value.targetMuscles),
    equipment: data.get(#equipment, or: $value.equipment),
    restIntervals: data.get(#restIntervals, or: $value.restIntervals),
    destination: data.get(#destination, or: $value.destination),
    distance: data.get(#distance, or: $value.distance),
    speed: data.get(#speed, or: $value.speed),
  );

  @override
  RunningExerciseDataCopyWith<$R2, RunningExerciseData, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _RunningExerciseDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

