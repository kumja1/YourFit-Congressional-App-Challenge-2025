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

class ExerciseDataMapper extends ClassMapperBase<ExerciseData> {
  ExerciseDataMapper._();

  static ExerciseDataMapper? _instance;
  static ExerciseDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExerciseDataMapper._());
      ExerciseDifficultyMapper.ensureInitialized();
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
  static List<String> _$targetMuscles(ExerciseData v) => v.targetMuscles;
  static const Field<ExerciseData, List<String>> _f$targetMuscles = Field(
    'targetMuscles',
    _$targetMuscles,
  );
  static int _$sets(ExerciseData v) => v.sets;
  static const Field<ExerciseData, int> _f$sets = Field('sets', _$sets);
  static int _$reps(ExerciseData v) => v.reps;
  static const Field<ExerciseData, int> _f$reps = Field('reps', _$reps);

  @override
  final MappableFields<ExerciseData> fields = const {
    #difficulty: _f$difficulty,
    #caloriesBurned: _f$caloriesBurned,
    #name: _f$name,
    #instructions: _f$instructions,
    #targetMuscles: _f$targetMuscles,
    #sets: _f$sets,
    #reps: _f$reps,
  };

  static ExerciseData _instantiate(DecodingData data) {
    return ExerciseData(
      difficulty: data.dec(_f$difficulty),
      caloriesBurned: data.dec(_f$caloriesBurned),
      name: data.dec(_f$name),
      instructions: data.dec(_f$instructions),
      targetMuscles: data.dec(_f$targetMuscles),
      sets: data.dec(_f$sets),
      reps: data.dec(_f$reps),
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
  $R call({
    ExerciseDifficulty? difficulty,
    double? caloriesBurned,
    String? name,
    String? instructions,
    List<String>? targetMuscles,
    int? sets,
    int? reps,
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
  $R call({
    ExerciseDifficulty? difficulty,
    double? caloriesBurned,
    String? name,
    String? instructions,
    List<String>? targetMuscles,
    int? sets,
    int? reps,
  }) => $apply(
    FieldCopyWithData({
      if (difficulty != null) #difficulty: difficulty,
      if (caloriesBurned != null) #caloriesBurned: caloriesBurned,
      if (name != null) #name: name,
      if (instructions != null) #instructions: instructions,
      if (targetMuscles != null) #targetMuscles: targetMuscles,
      if (sets != null) #sets: sets,
      if (reps != null) #reps: reps,
    }),
  );
  @override
  ExerciseData $make(CopyWithData data) => ExerciseData(
    difficulty: data.get(#difficulty, or: $value.difficulty),
    caloriesBurned: data.get(#caloriesBurned, or: $value.caloriesBurned),
    name: data.get(#name, or: $value.name),
    instructions: data.get(#instructions, or: $value.instructions),
    targetMuscles: data.get(#targetMuscles, or: $value.targetMuscles),
    sets: data.get(#sets, or: $value.sets),
    reps: data.get(#reps, or: $value.reps),
  );

  @override
  ExerciseDataCopyWith<$R2, ExerciseData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ExerciseDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

