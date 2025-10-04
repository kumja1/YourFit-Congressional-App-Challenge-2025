// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'exercise_data.dart';

class ExerciseDifficultyMapper extends EnumMapper<ExerciseDifficulty> {
  ExerciseDifficultyMapper._();

  static ExerciseDifficultyMapper? _instance;
  static ExerciseDifficultyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExerciseDifficultyMapper._());
    }
    return _instance!;
  }

  static ExerciseDifficulty fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ExerciseDifficulty decode(dynamic value) {
    switch (value) {
      case r'easy':
        return ExerciseDifficulty.easy;
      case r'medium':
        return ExerciseDifficulty.medium;
      case r'hard':
        return ExerciseDifficulty.hard;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ExerciseDifficulty self) {
    switch (self) {
      case ExerciseDifficulty.easy:
        return r'easy';
      case ExerciseDifficulty.medium:
        return r'medium';
      case ExerciseDifficulty.hard:
        return r'hard';
    }
  }
}

extension ExerciseDifficultyMapperExtension on ExerciseDifficulty {
  String toValue() {
    ExerciseDifficultyMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ExerciseDifficulty>(this) as String;
  }
}

class ExerciseIntensityMapper extends EnumMapper<ExerciseIntensity> {
  ExerciseIntensityMapper._();

  static ExerciseIntensityMapper? _instance;
  static ExerciseIntensityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExerciseIntensityMapper._());
    }
    return _instance!;
  }

  static ExerciseIntensity fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ExerciseIntensity decode(dynamic value) {
    switch (value) {
      case r'low':
        return ExerciseIntensity.low;
      case r'medium':
        return ExerciseIntensity.medium;
      case r'high':
        return ExerciseIntensity.high;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ExerciseIntensity self) {
    switch (self) {
      case ExerciseIntensity.low:
        return r'low';
      case ExerciseIntensity.medium:
        return r'medium';
      case ExerciseIntensity.high:
        return r'high';
    }
  }
}

extension ExerciseIntensityMapperExtension on ExerciseIntensity {
  String toValue() {
    ExerciseIntensityMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ExerciseIntensity>(this) as String;
  }
}

class ExerciseTypeMapper extends EnumMapper<ExerciseType> {
  ExerciseTypeMapper._();

  static ExerciseTypeMapper? _instance;
  static ExerciseTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExerciseTypeMapper._());
    }
    return _instance!;
  }

  static ExerciseType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ExerciseType decode(dynamic value) {
    switch (value) {
      case r'strength':
        return ExerciseType.strength;
      case r'cardio':
        return ExerciseType.cardio;
      case r'flexibility':
        return ExerciseType.flexibility;
      case r'balance':
        return ExerciseType.balance;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ExerciseType self) {
    switch (self) {
      case ExerciseType.strength:
        return r'strength';
      case ExerciseType.cardio:
        return r'cardio';
      case ExerciseType.flexibility:
        return r'flexibility';
      case ExerciseType.balance:
        return r'balance';
    }
  }
}

extension ExerciseTypeMapperExtension on ExerciseType {
  String toValue() {
    ExerciseTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ExerciseType>(this) as String;
  }
}

class ExerciseDataMapper extends ClassMapperBase<ExerciseData> {
  ExerciseDataMapper._();

  static ExerciseDataMapper? _instance;
  static ExerciseDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExerciseDataMapper._());
      MapperContainer.globals.useAll([DurationMapper()]);
      ExerciseDifficultyMapper.ensureInitialized();
      ExerciseIntensityMapper.ensureInitialized();
      ExerciseTypeMapper.ensureInitialized();
      RestIntervalMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExerciseData';

  static ExerciseDifficulty _$difficulty(ExerciseData v) => v.difficulty;
  static const Field<ExerciseData, ExerciseDifficulty> _f$difficulty = Field(
    'difficulty',
    _$difficulty,
  );
  static ExerciseIntensity _$intensity(ExerciseData v) => v.intensity;
  static const Field<ExerciseData, ExerciseIntensity> _f$intensity = Field(
    'intensity',
    _$intensity,
  );
  static ExerciseType _$type(ExerciseData v) => v.type;
  static const Field<ExerciseData, ExerciseType> _f$type = Field(
    'type',
    _$type,
  );
  static double _$caloriesBurned(ExerciseData v) => v.caloriesBurned;
  static const Field<ExerciseData, double> _f$caloriesBurned = Field(
    'caloriesBurned',
    _$caloriesBurned,
  );
  static String _$name(ExerciseData v) => v.name;
  static const Field<ExerciseData, String> _f$name = Field('name', _$name);
  static String _$instructions(ExerciseData v) => v.instructions;
  static const Field<ExerciseData, String> _f$instructions = Field(
    'instructions',
    _$instructions,
  );
  static String _$summary(ExerciseData v) => v.summary;
  static const Field<ExerciseData, String> _f$summary = Field(
    'summary',
    _$summary,
  );
  static int _$sets(ExerciseData v) => v.sets;
  static const Field<ExerciseData, int> _f$sets = Field('sets', _$sets);
  static int _$reps(ExerciseData v) => v.reps;
  static const Field<ExerciseData, int> _f$reps = Field('reps', _$reps);
  static Duration _$durationPerSet(ExerciseData v) => v.durationPerSet;
  static const Field<ExerciseData, Duration> _f$durationPerSet = Field(
    'durationPerSet',
    _$durationPerSet,
  );
  static List<String> _$targetMuscles(ExerciseData v) => v.targetMuscles;
  static const Field<ExerciseData, List<String>> _f$targetMuscles = Field(
    'targetMuscles',
    _$targetMuscles,
    opt: true,
    def: const [],
  );
  static List<String> _$equipment(ExerciseData v) => v.equipment;
  static const Field<ExerciseData, List<String>> _f$equipment = Field(
    'equipment',
    _$equipment,
    opt: true,
    def: const [],
  );
  static List<RestInterval> _$restIntervals(ExerciseData v) => v.restIntervals;
  static const Field<ExerciseData, List<RestInterval>> _f$restIntervals = Field(
    'restIntervals',
    _$restIntervals,
    opt: true,
    def: const [],
    hook: MapHook(),
  );
  static ExerciseState _$state(ExerciseData v) => v.state;
  static const Field<ExerciseData, ExerciseState> _f$state = Field(
    'state',
    _$state,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<ExerciseData> fields = const {
    #difficulty: _f$difficulty,
    #intensity: _f$intensity,
    #type: _f$type,
    #caloriesBurned: _f$caloriesBurned,
    #name: _f$name,
    #instructions: _f$instructions,
    #summary: _f$summary,
    #sets: _f$sets,
    #reps: _f$reps,
    #durationPerSet: _f$durationPerSet,
    #targetMuscles: _f$targetMuscles,
    #equipment: _f$equipment,
    #restIntervals: _f$restIntervals,
    #state: _f$state,
  };

  static ExerciseData _instantiate(DecodingData data) {
    return ExerciseData(
      difficulty: data.dec(_f$difficulty),
      intensity: data.dec(_f$intensity),
      type: data.dec(_f$type),
      caloriesBurned: data.dec(_f$caloriesBurned),
      name: data.dec(_f$name),
      instructions: data.dec(_f$instructions),
      summary: data.dec(_f$summary),
      sets: data.dec(_f$sets),
      reps: data.dec(_f$reps),
      durationPerSet: data.dec(_f$durationPerSet),
      targetMuscles: data.dec(_f$targetMuscles),
      equipment: data.dec(_f$equipment),
      restIntervals: data.dec(_f$restIntervals),
    );
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
    return ExerciseDataMapper.ensureInitialized().encodeJson<ExerciseData>(
      this as ExerciseData,
    );
  }

  Map<String, dynamic> toMap() {
    return ExerciseDataMapper.ensureInitialized().encodeMap<ExerciseData>(
      this as ExerciseData,
    );
  }

  ExerciseDataCopyWith<ExerciseData, ExerciseData, ExerciseData> get copyWith =>
      _ExerciseDataCopyWithImpl<ExerciseData, ExerciseData>(
        this as ExerciseData,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ExerciseDataMapper.ensureInitialized().stringifyValue(
      this as ExerciseData,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExerciseDataMapper.ensureInitialized().equalsValue(
      this as ExerciseData,
      other,
    );
  }

  @override
  int get hashCode {
    return ExerciseDataMapper.ensureInitialized().hashValue(
      this as ExerciseData,
    );
  }
}

extension ExerciseDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExerciseData, $Out> {
  ExerciseDataCopyWith<$R, ExerciseData, $Out> get $asExerciseData =>
      $base.as((v, t, t2) => _ExerciseDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ExerciseDataCopyWith<$R, $In extends ExerciseData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get targetMuscles;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get equipment;
  ListCopyWith<
    $R,
    RestInterval,
    RestIntervalCopyWith<$R, RestInterval, RestInterval>
  >
  get restIntervals;
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
    Duration? durationPerSet,
    List<String>? targetMuscles,
    List<String>? equipment,
    List<RestInterval>? restIntervals,
  });
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
    Duration? durationPerSet,
    List<String>? targetMuscles,
    List<String>? equipment,
    List<RestInterval>? restIntervals,
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
      if (durationPerSet != null) #durationPerSet: durationPerSet,
      if (targetMuscles != null) #targetMuscles: targetMuscles,
      if (equipment != null) #equipment: equipment,
      if (restIntervals != null) #restIntervals: restIntervals,
    }),
  );
  @override
  ExerciseData $make(CopyWithData data) => ExerciseData(
    difficulty: data.get(#difficulty, or: $value.difficulty),
    intensity: data.get(#intensity, or: $value.intensity),
    type: data.get(#type, or: $value.type),
    caloriesBurned: data.get(#caloriesBurned, or: $value.caloriesBurned),
    name: data.get(#name, or: $value.name),
    instructions: data.get(#instructions, or: $value.instructions),
    summary: data.get(#summary, or: $value.summary),
    sets: data.get(#sets, or: $value.sets),
    reps: data.get(#reps, or: $value.reps),
    durationPerSet: data.get(#durationPerSet, or: $value.durationPerSet),
    targetMuscles: data.get(#targetMuscles, or: $value.targetMuscles),
    equipment: data.get(#equipment, or: $value.equipment),
    restIntervals: data.get(#restIntervals, or: $value.restIntervals),
  );

  @override
  ExerciseDataCopyWith<$R2, ExerciseData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ExerciseDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RestIntervalMapper extends ClassMapperBase<RestInterval> {
  RestIntervalMapper._();

  static RestIntervalMapper? _instance;
  static RestIntervalMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RestIntervalMapper._());
      MapperContainer.globals.useAll([DurationMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'RestInterval';

  static Duration _$duration(RestInterval v) => v.duration;
  static const Field<RestInterval, Duration> _f$duration = Field(
    'duration',
    _$duration,
  );
  static int _$restAt(RestInterval v) => v.restAt;
  static const Field<RestInterval, int> _f$restAt = Field('restAt', _$restAt);

  @override
  final MappableFields<RestInterval> fields = const {
    #duration: _f$duration,
    #restAt: _f$restAt,
  };

  static RestInterval _instantiate(DecodingData data) {
    return RestInterval(
      duration: data.dec(_f$duration),
      restAt: data.dec(_f$restAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RestInterval fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RestInterval>(map);
  }

  static RestInterval fromJson(String json) {
    return ensureInitialized().decodeJson<RestInterval>(json);
  }
}

mixin RestIntervalMappable {
  String toJson() {
    return RestIntervalMapper.ensureInitialized().encodeJson<RestInterval>(
      this as RestInterval,
    );
  }

  Map<String, dynamic> toMap() {
    return RestIntervalMapper.ensureInitialized().encodeMap<RestInterval>(
      this as RestInterval,
    );
  }

  RestIntervalCopyWith<RestInterval, RestInterval, RestInterval> get copyWith =>
      _RestIntervalCopyWithImpl<RestInterval, RestInterval>(
        this as RestInterval,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RestIntervalMapper.ensureInitialized().stringifyValue(
      this as RestInterval,
    );
  }

  @override
  bool operator ==(Object other) {
    return RestIntervalMapper.ensureInitialized().equalsValue(
      this as RestInterval,
      other,
    );
  }

  @override
  int get hashCode {
    return RestIntervalMapper.ensureInitialized().hashValue(
      this as RestInterval,
    );
  }
}

extension RestIntervalValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RestInterval, $Out> {
  RestIntervalCopyWith<$R, RestInterval, $Out> get $asRestInterval =>
      $base.as((v, t, t2) => _RestIntervalCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RestIntervalCopyWith<$R, $In extends RestInterval, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Duration? duration, int? restAt});
  RestIntervalCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RestIntervalCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RestInterval, $Out>
    implements RestIntervalCopyWith<$R, RestInterval, $Out> {
  _RestIntervalCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RestInterval> $mapper =
      RestIntervalMapper.ensureInitialized();
  @override
  $R call({Duration? duration, int? restAt}) => $apply(
    FieldCopyWithData({
      if (duration != null) #duration: duration,
      if (restAt != null) #restAt: restAt,
    }),
  );
  @override
  RestInterval $make(CopyWithData data) => RestInterval(
    duration: data.get(#duration, or: $value.duration),
    restAt: data.get(#restAt, or: $value.restAt),
  );

  @override
  RestIntervalCopyWith<$R2, RestInterval, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RestIntervalCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ExerciseStateMapper extends ClassMapperBase<ExerciseState> {
  ExerciseStateMapper._();

  static ExerciseStateMapper? _instance;
  static ExerciseStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExerciseStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ExerciseState';

  static bool _$completed(ExerciseState v) => v.completed;
  static const Field<ExerciseState, bool> _f$completed = Field(
    'completed',
    _$completed,
  );
  static int _$setsDone(ExerciseState v) => v.setsDone;
  static const Field<ExerciseState, int> _f$setsDone = Field(
    'setsDone',
    _$setsDone,
  );

  @override
  final MappableFields<ExerciseState> fields = const {
    #completed: _f$completed,
    #setsDone: _f$setsDone,
  };

  static ExerciseState _instantiate(DecodingData data) {
    return ExerciseState(
      completed: data.dec(_f$completed),
      setsDone: data.dec(_f$setsDone),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ExerciseState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExerciseState>(map);
  }

  static ExerciseState fromJson(String json) {
    return ensureInitialized().decodeJson<ExerciseState>(json);
  }
}

mixin ExerciseStateMappable {
  String toJson() {
    return ExerciseStateMapper.ensureInitialized().encodeJson<ExerciseState>(
      this as ExerciseState,
    );
  }

  Map<String, dynamic> toMap() {
    return ExerciseStateMapper.ensureInitialized().encodeMap<ExerciseState>(
      this as ExerciseState,
    );
  }

  ExerciseStateCopyWith<ExerciseState, ExerciseState, ExerciseState>
  get copyWith => _ExerciseStateCopyWithImpl<ExerciseState, ExerciseState>(
    this as ExerciseState,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ExerciseStateMapper.ensureInitialized().stringifyValue(
      this as ExerciseState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExerciseStateMapper.ensureInitialized().equalsValue(
      this as ExerciseState,
      other,
    );
  }

  @override
  int get hashCode {
    return ExerciseStateMapper.ensureInitialized().hashValue(
      this as ExerciseState,
    );
  }
}

extension ExerciseStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExerciseState, $Out> {
  ExerciseStateCopyWith<$R, ExerciseState, $Out> get $asExerciseState =>
      $base.as((v, t, t2) => _ExerciseStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ExerciseStateCopyWith<$R, $In extends ExerciseState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? completed, int? setsDone});
  ExerciseStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ExerciseStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExerciseState, $Out>
    implements ExerciseStateCopyWith<$R, ExerciseState, $Out> {
  _ExerciseStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExerciseState> $mapper =
      ExerciseStateMapper.ensureInitialized();
  @override
  $R call({bool? completed, int? setsDone}) => $apply(
    FieldCopyWithData({
      if (completed != null) #completed: completed,
      if (setsDone != null) #setsDone: setsDone,
    }),
  );
  @override
  ExerciseState $make(CopyWithData data) => ExerciseState(
    completed: data.get(#completed, or: $value.completed),
    setsDone: data.get(#setsDone, or: $value.setsDone),
  );

  @override
  ExerciseStateCopyWith<$R2, ExerciseState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ExerciseStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

