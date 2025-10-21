// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_data.dart';

class UserGenderMapper extends EnumMapper<UserGender> {
  UserGenderMapper._();

  static UserGenderMapper? _instance;
  static UserGenderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserGenderMapper._());
    }
    return _instance!;
  }

  static UserGender fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  UserGender decode(dynamic value) {
    switch (value) {
      case r'male':
        return UserGender.male;
      case r'female':
        return UserGender.female;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(UserGender self) {
    switch (self) {
      case UserGender.male:
        return r'male';
      case UserGender.female:
        return r'female';
    }
  }
}

extension UserGenderMapperExtension on UserGender {
  String toValue() {
    UserGenderMapper.ensureInitialized();
    return MapperContainer.globals.toValue<UserGender>(this) as String;
  }
}

class UserPhysicalFitnessMapper extends EnumMapper<UserPhysicalFitness> {
  UserPhysicalFitnessMapper._();

  static UserPhysicalFitnessMapper? _instance;
  static UserPhysicalFitnessMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserPhysicalFitnessMapper._());
    }
    return _instance!;
  }

  static UserPhysicalFitness fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  UserPhysicalFitness decode(dynamic value) {
    switch (value) {
      case r'minimal':
        return UserPhysicalFitness.minimal;
      case r'light':
        return UserPhysicalFitness.light;
      case r'moderate':
        return UserPhysicalFitness.moderate;
      case r'extreme':
        return UserPhysicalFitness.extreme;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(UserPhysicalFitness self) {
    switch (self) {
      case UserPhysicalFitness.minimal:
        return r'minimal';
      case UserPhysicalFitness.light:
        return r'light';
      case UserPhysicalFitness.moderate:
        return r'moderate';
      case UserPhysicalFitness.extreme:
        return r'extreme';
    }
  }
}

extension UserPhysicalFitnessMapperExtension on UserPhysicalFitness {
  String toValue() {
    UserPhysicalFitnessMapper.ensureInitialized();
    return MapperContainer.globals.toValue<UserPhysicalFitness>(this) as String;
  }
}

class UserDataMapper extends ClassMapperBase<UserData> {
  UserDataMapper._();

  static UserDataMapper? _instance;
  static UserDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserDataMapper._());
      UserGenderMapper.ensureInitialized();
      UserPhysicalFitnessMapper.ensureInitialized();
      UserStatsMapper.ensureInitialized();
      ExerciseIntensityMapper.ensureInitialized();
      ExerciseDifficultyMapper.ensureInitialized();
      MonthDataMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserData';

  static String _$id(UserData v) => v.id;
  static const Field<UserData, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(UserData v) => v.createdAt;
  static const Field<UserData, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static String _$firstName(UserData v) => v.firstName;
  static const Field<UserData, String> _f$firstName = Field(
    'firstName',
    _$firstName,
    key: r'first_name',
  );
  static String _$lastName(UserData v) => v.lastName;
  static const Field<UserData, String> _f$lastName = Field(
    'lastName',
    _$lastName,
    key: r'last_name',
  );
  static UserGender _$gender(UserData v) => v.gender;
  static const Field<UserData, UserGender> _f$gender = Field(
    'gender',
    _$gender,
  );
  static DateTime _$dob(UserData v) => v.dob;
  static const Field<UserData, DateTime> _f$dob = Field('dob', _$dob);
  static double _$height(UserData v) => v.height;
  static const Field<UserData, double> _f$height = Field('height', _$height);
  static double _$weight(UserData v) => v.weight;
  static const Field<UserData, double> _f$weight = Field('weight', _$weight);
  static UserPhysicalFitness _$physicalFitness(UserData v) => v.physicalFitness;
  static const Field<UserData, UserPhysicalFitness> _f$physicalFitness = Field(
    'physicalFitness',
    _$physicalFitness,
    key: r'physical_fitness',
  );
  static UserStats _$stats(UserData v) => v.stats;
  static const Field<UserData, UserStats> _f$stats = Field('stats', _$stats);
  static String _$goal(UserData v) => v.goal;
  static const Field<UserData, String> _f$goal = Field(
    'goal',
    _$goal,
    opt: true,
    def: "",
  );
  static int _$exerciseDaysPerWeek(UserData v) => v.exerciseDaysPerWeek;
  static const Field<UserData, int> _f$exerciseDaysPerWeek = Field(
    'exerciseDaysPerWeek',
    _$exerciseDaysPerWeek,
    key: r'exercise_days_per_week',
    opt: true,
    def: 3,
  );
  static ExerciseIntensity _$exercisesIntensity(UserData v) =>
      v.exercisesIntensity;
  static const Field<UserData, ExerciseIntensity> _f$exercisesIntensity = Field(
    'exercisesIntensity',
    _$exercisesIntensity,
    key: r'exercises_intensity',
    opt: true,
    def: ExerciseIntensity.low,
  );
  static ExerciseDifficulty _$exercisesDifficulty(UserData v) =>
      v.exercisesDifficulty;
  static const Field<UserData, ExerciseDifficulty> _f$exercisesDifficulty =
      Field(
        'exercisesDifficulty',
        _$exercisesDifficulty,
        key: r'exercises_difficulty',
        opt: true,
        def: ExerciseDifficulty.easy,
      );
  static Map<String, MonthData> _$workoutData(UserData v) => v.workoutData;
  static const Field<UserData, Map<String, MonthData>> _f$workoutData = Field(
    'workoutData',
    _$workoutData,
    key: r'workout_data',
    opt: true,
    def: const {},
  );
  static List<String> _$disabilities(UserData v) => v.disabilities;
  static const Field<UserData, List<String>> _f$disabilities = Field(
    'disabilities',
    _$disabilities,
    opt: true,
    def: const [],
  );
  static List<String> _$equipment(UserData v) => v.equipment;
  static const Field<UserData, List<String>> _f$equipment = Field(
    'equipment',
    _$equipment,
    opt: true,
    def: const [],
  );
  static String _$fullName(UserData v) => v.fullName;
  static const Field<UserData, String> _f$fullName = Field(
    'fullName',
    _$fullName,
    key: r'full_name',
    mode: FieldMode.member,
  );
  static String _$intials(UserData v) => v.intials;
  static const Field<UserData, String> _f$intials = Field(
    'intials',
    _$intials,
    mode: FieldMode.member,
  );
  static int _$age(UserData v) => v.age;
  static const Field<UserData, int> _f$age = Field(
    'age',
    _$age,
    mode: FieldMode.member,
  );
  static double _$bmi(UserData v) => v.bmi;
  static const Field<UserData, double> _f$bmi = Field(
    'bmi',
    _$bmi,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<UserData> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #firstName: _f$firstName,
    #lastName: _f$lastName,
    #gender: _f$gender,
    #dob: _f$dob,
    #height: _f$height,
    #weight: _f$weight,
    #physicalFitness: _f$physicalFitness,
    #stats: _f$stats,
    #goal: _f$goal,
    #exerciseDaysPerWeek: _f$exerciseDaysPerWeek,
    #exercisesIntensity: _f$exercisesIntensity,
    #exercisesDifficulty: _f$exercisesDifficulty,
    #workoutData: _f$workoutData,
    #disabilities: _f$disabilities,
    #equipment: _f$equipment,
    #fullName: _f$fullName,
    #intials: _f$intials,
    #age: _f$age,
    #bmi: _f$bmi,
  };

  static UserData _instantiate(DecodingData data) {
    return UserData(
      id: data.dec(_f$id),
      createdAt: data.dec(_f$createdAt),
      firstName: data.dec(_f$firstName),
      lastName: data.dec(_f$lastName),
      gender: data.dec(_f$gender),
      dob: data.dec(_f$dob),
      height: data.dec(_f$height),
      weight: data.dec(_f$weight),
      physicalFitness: data.dec(_f$physicalFitness),
      stats: data.dec(_f$stats),
      goal: data.dec(_f$goal),
      exerciseDaysPerWeek: data.dec(_f$exerciseDaysPerWeek),
      exercisesIntensity: data.dec(_f$exercisesIntensity),
      exercisesDifficulty: data.dec(_f$exercisesDifficulty),
      workoutData: data.dec(_f$workoutData),
      disabilities: data.dec(_f$disabilities),
      equipment: data.dec(_f$equipment),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserData>(map);
  }

  static UserData fromJson(String json) {
    return ensureInitialized().decodeJson<UserData>(json);
  }
}

mixin UserDataMappable {
  String toJson() {
    return UserDataMapper.ensureInitialized().encodeJson<UserData>(
      this as UserData,
    );
  }

  Map<String, dynamic> toMap() {
    return UserDataMapper.ensureInitialized().encodeMap<UserData>(
      this as UserData,
    );
  }

  UserDataCopyWith<UserData, UserData, UserData> get copyWith =>
      _UserDataCopyWithImpl<UserData, UserData>(
        this as UserData,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserDataMapper.ensureInitialized().stringifyValue(this as UserData);
  }

  @override
  bool operator ==(Object other) {
    return UserDataMapper.ensureInitialized().equalsValue(
      this as UserData,
      other,
    );
  }

  @override
  int get hashCode {
    return UserDataMapper.ensureInitialized().hashValue(this as UserData);
  }
}

extension UserDataValueCopy<$R, $Out> on ObjectCopyWith<$R, UserData, $Out> {
  UserDataCopyWith<$R, UserData, $Out> get $asUserData =>
      $base.as((v, t, t2) => _UserDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserDataCopyWith<$R, $In extends UserData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UserStatsCopyWith<$R, UserStats, UserStats> get stats;
  MapCopyWith<
    $R,
    String,
    MonthData,
    MonthDataCopyWith<$R, MonthData, MonthData>
  >
  get workoutData;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get disabilities;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get equipment;
  $R call({
    String? id,
    DateTime? createdAt,
    String? firstName,
    String? lastName,
    UserGender? gender,
    DateTime? dob,
    double? height,
    double? weight,
    UserPhysicalFitness? physicalFitness,
    UserStats? stats,
    String? goal,
    int? exerciseDaysPerWeek,
    ExerciseIntensity? exercisesIntensity,
    ExerciseDifficulty? exercisesDifficulty,
    Map<String, MonthData>? workoutData,
    List<String>? disabilities,
    List<String>? equipment,
  });
  UserDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserData, $Out>
    implements UserDataCopyWith<$R, UserData, $Out> {
  _UserDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserData> $mapper =
      UserDataMapper.ensureInitialized();
  @override
  UserStatsCopyWith<$R, UserStats, UserStats> get stats =>
      $value.stats.copyWith.$chain((v) => call(stats: v));
  @override
  MapCopyWith<
    $R,
    String,
    MonthData,
    MonthDataCopyWith<$R, MonthData, MonthData>
  >
  get workoutData => MapCopyWith(
    $value.workoutData,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(workoutData: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get disabilities => ListCopyWith(
    $value.disabilities,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(disabilities: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get equipment =>
      ListCopyWith(
        $value.equipment,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(equipment: v),
      );
  @override
  $R call({
    String? id,
    DateTime? createdAt,
    String? firstName,
    String? lastName,
    UserGender? gender,
    DateTime? dob,
    double? height,
    double? weight,
    UserPhysicalFitness? physicalFitness,
    UserStats? stats,
    String? goal,
    int? exerciseDaysPerWeek,
    ExerciseIntensity? exercisesIntensity,
    ExerciseDifficulty? exercisesDifficulty,
    Map<String, MonthData>? workoutData,
    List<String>? disabilities,
    List<String>? equipment,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (createdAt != null) #createdAt: createdAt,
      if (firstName != null) #firstName: firstName,
      if (lastName != null) #lastName: lastName,
      if (gender != null) #gender: gender,
      if (dob != null) #dob: dob,
      if (height != null) #height: height,
      if (weight != null) #weight: weight,
      if (physicalFitness != null) #physicalFitness: physicalFitness,
      if (stats != null) #stats: stats,
      if (goal != null) #goal: goal,
      if (exerciseDaysPerWeek != null)
        #exerciseDaysPerWeek: exerciseDaysPerWeek,
      if (exercisesIntensity != null) #exercisesIntensity: exercisesIntensity,
      if (exercisesDifficulty != null)
        #exercisesDifficulty: exercisesDifficulty,
      if (workoutData != null) #workoutData: workoutData,
      if (disabilities != null) #disabilities: disabilities,
      if (equipment != null) #equipment: equipment,
    }),
  );
  @override
  UserData $make(CopyWithData data) => UserData(
    id: data.get(#id, or: $value.id),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    firstName: data.get(#firstName, or: $value.firstName),
    lastName: data.get(#lastName, or: $value.lastName),
    gender: data.get(#gender, or: $value.gender),
    dob: data.get(#dob, or: $value.dob),
    height: data.get(#height, or: $value.height),
    weight: data.get(#weight, or: $value.weight),
    physicalFitness: data.get(#physicalFitness, or: $value.physicalFitness),
    stats: data.get(#stats, or: $value.stats),
    goal: data.get(#goal, or: $value.goal),
    exerciseDaysPerWeek: data.get(
      #exerciseDaysPerWeek,
      or: $value.exerciseDaysPerWeek,
    ),
    exercisesIntensity: data.get(
      #exercisesIntensity,
      or: $value.exercisesIntensity,
    ),
    exercisesDifficulty: data.get(
      #exercisesDifficulty,
      or: $value.exercisesDifficulty,
    ),
    workoutData: data.get(#workoutData, or: $value.workoutData),
    disabilities: data.get(#disabilities, or: $value.disabilities),
    equipment: data.get(#equipment, or: $value.equipment),
  );

  @override
  UserDataCopyWith<$R2, UserData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UserStatsMapper extends ClassMapperBase<UserStats> {
  UserStatsMapper._();

  static UserStatsMapper? _instance;
  static UserStatsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserStatsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserStats';

  static double _$milesTraveled(UserStats v) => v.milesTraveled;
  static const Field<UserStats, double> _f$milesTraveled = Field(
    'milesTraveled',
    _$milesTraveled,
    key: r'miles_traveled',
    opt: true,
    def: 0,
  );
  static double _$totalCaloriesBurned(UserStats v) => v.totalCaloriesBurned;
  static const Field<UserStats, double> _f$totalCaloriesBurned = Field(
    'totalCaloriesBurned',
    _$totalCaloriesBurned,
    key: r'total_calories_burned',
    opt: true,
    def: 0,
  );
  static int _$xp(UserStats v) => v.xp;
  static const Field<UserStats, int> _f$xp = Field(
    'xp',
    _$xp,
    opt: true,
    def: 0,
  );
  static int _$xpToNext(UserStats v) => v.xpToNext;
  static const Field<UserStats, int> _f$xpToNext = Field(
    'xpToNext',
    _$xpToNext,
    key: r'xp_to_next',
    opt: true,
    def: 120,
  );
  static int _$level(UserStats v) => v.level;
  static const Field<UserStats, int> _f$level = Field(
    'level',
    _$level,
    opt: true,
    def: 1,
  );
  static int _$streak(UserStats v) => v.streak;
  static const Field<UserStats, int> _f$streak = Field(
    'streak',
    _$streak,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<UserStats> fields = const {
    #milesTraveled: _f$milesTraveled,
    #totalCaloriesBurned: _f$totalCaloriesBurned,
    #xp: _f$xp,
    #xpToNext: _f$xpToNext,
    #level: _f$level,
    #streak: _f$streak,
  };

  static UserStats _instantiate(DecodingData data) {
    return UserStats(
      milesTraveled: data.dec(_f$milesTraveled),
      totalCaloriesBurned: data.dec(_f$totalCaloriesBurned),
      xp: data.dec(_f$xp),
      xpToNext: data.dec(_f$xpToNext),
      level: data.dec(_f$level),
      streak: data.dec(_f$streak),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserStats fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserStats>(map);
  }

  static UserStats fromJson(String json) {
    return ensureInitialized().decodeJson<UserStats>(json);
  }
}

mixin UserStatsMappable {
  String toJson() {
    return UserStatsMapper.ensureInitialized().encodeJson<UserStats>(
      this as UserStats,
    );
  }

  Map<String, dynamic> toMap() {
    return UserStatsMapper.ensureInitialized().encodeMap<UserStats>(
      this as UserStats,
    );
  }

  UserStatsCopyWith<UserStats, UserStats, UserStats> get copyWith =>
      _UserStatsCopyWithImpl<UserStats, UserStats>(
        this as UserStats,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserStatsMapper.ensureInitialized().stringifyValue(
      this as UserStats,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserStatsMapper.ensureInitialized().equalsValue(
      this as UserStats,
      other,
    );
  }

  @override
  int get hashCode {
    return UserStatsMapper.ensureInitialized().hashValue(this as UserStats);
  }
}

extension UserStatsValueCopy<$R, $Out> on ObjectCopyWith<$R, UserStats, $Out> {
  UserStatsCopyWith<$R, UserStats, $Out> get $asUserStats =>
      $base.as((v, t, t2) => _UserStatsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserStatsCopyWith<$R, $In extends UserStats, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    double? milesTraveled,
    double? totalCaloriesBurned,
    int? xp,
    int? xpToNext,
    int? level,
    int? streak,
  });
  UserStatsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserStatsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserStats, $Out>
    implements UserStatsCopyWith<$R, UserStats, $Out> {
  _UserStatsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserStats> $mapper =
      UserStatsMapper.ensureInitialized();
  @override
  $R call({
    double? milesTraveled,
    double? totalCaloriesBurned,
    int? xp,
    int? xpToNext,
    int? level,
    int? streak,
  }) => $apply(
    FieldCopyWithData({
      if (milesTraveled != null) #milesTraveled: milesTraveled,
      if (totalCaloriesBurned != null)
        #totalCaloriesBurned: totalCaloriesBurned,
      if (xp != null) #xp: xp,
      if (xpToNext != null) #xpToNext: xpToNext,
      if (level != null) #level: level,
      if (streak != null) #streak: streak,
    }),
  );
  @override
  UserStats $make(CopyWithData data) => UserStats(
    milesTraveled: data.get(#milesTraveled, or: $value.milesTraveled),
    totalCaloriesBurned: data.get(
      #totalCaloriesBurned,
      or: $value.totalCaloriesBurned,
    ),
    xp: data.get(#xp, or: $value.xp),
    xpToNext: data.get(#xpToNext, or: $value.xpToNext),
    level: data.get(#level, or: $value.level),
    streak: data.get(#streak, or: $value.streak),
  );

  @override
  UserStatsCopyWith<$R2, UserStats, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserStatsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

