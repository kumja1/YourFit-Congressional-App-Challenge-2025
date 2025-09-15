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
      MonthDataMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserData';

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
  static double _$totalCaloriesBurned(UserData v) => v.totalCaloriesBurned;
  static const Field<UserData, double> _f$totalCaloriesBurned = Field(
    'totalCaloriesBurned',
    _$totalCaloriesBurned,
    key: r'total_calories_burned',
    opt: true,
    def: 0,
  );
  static double _$milesTraveled(UserData v) => v.milesTraveled;
  static const Field<UserData, double> _f$milesTraveled = Field(
    'milesTraveled',
    _$milesTraveled,
    key: r'miles_traveled',
    opt: true,
    def: 0,
  );
  static Map<String, MonthData> _$exerciseData(UserData v) => v.exerciseData;
  static const Field<UserData, Map<String, MonthData>> _f$exerciseData = Field(
    'exerciseData',
    _$exerciseData,
    key: r'exercise_data',
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
  static String _$id(UserData v) => v.id;
  static const Field<UserData, String> _f$id = Field(
    'id',
    _$id,
    mode: FieldMode.member,
  );
  static DateTime _$createdAt(UserData v) => v.createdAt;
  static const Field<UserData, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
    mode: FieldMode.member,
  );
  static String _$fullName(UserData v) => v.fullName;
  static const Field<UserData, String> _f$fullName = Field(
    'fullName',
    _$fullName,
    key: r'full_name',
    mode: FieldMode.member,
  );
  static int _$age(UserData v) => v.age;
  static const Field<UserData, int> _f$age = Field(
    'age',
    _$age,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<UserData> fields = const {
    #firstName: _f$firstName,
    #lastName: _f$lastName,
    #gender: _f$gender,
    #dob: _f$dob,
    #height: _f$height,
    #weight: _f$weight,
    #physicalFitness: _f$physicalFitness,
    #totalCaloriesBurned: _f$totalCaloriesBurned,
    #milesTraveled: _f$milesTraveled,
    #exerciseData: _f$exerciseData,
    #disabilities: _f$disabilities,
    #equipment: _f$equipment,
    #id: _f$id,
    #createdAt: _f$createdAt,
    #fullName: _f$fullName,
    #age: _f$age,
  };

  static UserData _instantiate(DecodingData data) {
    return UserData(
      firstName: data.dec(_f$firstName),
      lastName: data.dec(_f$lastName),
      gender: data.dec(_f$gender),
      dob: data.dec(_f$dob),
      height: data.dec(_f$height),
      weight: data.dec(_f$weight),
      physicalFitness: data.dec(_f$physicalFitness),
      totalCaloriesBurned: data.dec(_f$totalCaloriesBurned),
      milesTraveled: data.dec(_f$milesTraveled),
      exerciseData: data.dec(_f$exerciseData),
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
  MapCopyWith<
    $R,
    String,
    MonthData,
    MonthDataCopyWith<$R, MonthData, MonthData>
  >
  get exerciseData;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get disabilities;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get equipment;
  $R call({
    String? firstName,
    String? lastName,
    UserGender? gender,
    DateTime? dob,
    double? height,
    double? weight,
    UserPhysicalFitness? physicalFitness,
    double? totalCaloriesBurned,
    double? milesTraveled,
    Map<String, MonthData>? exerciseData,
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
  MapCopyWith<
    $R,
    String,
    MonthData,
    MonthDataCopyWith<$R, MonthData, MonthData>
  >
  get exerciseData => MapCopyWith(
    $value.exerciseData,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(exerciseData: v),
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
    String? firstName,
    String? lastName,
    UserGender? gender,
    DateTime? dob,
    double? height,
    double? weight,
    UserPhysicalFitness? physicalFitness,
    double? totalCaloriesBurned,
    double? milesTraveled,
    Map<String, MonthData>? exerciseData,
    List<String>? disabilities,
    List<String>? equipment,
  }) => $apply(
    FieldCopyWithData({
      if (firstName != null) #firstName: firstName,
      if (lastName != null) #lastName: lastName,
      if (gender != null) #gender: gender,
      if (dob != null) #dob: dob,
      if (height != null) #height: height,
      if (weight != null) #weight: weight,
      if (physicalFitness != null) #physicalFitness: physicalFitness,
      if (totalCaloriesBurned != null)
        #totalCaloriesBurned: totalCaloriesBurned,
      if (milesTraveled != null) #milesTraveled: milesTraveled,
      if (exerciseData != null) #exerciseData: exerciseData,
      if (disabilities != null) #disabilities: disabilities,
      if (equipment != null) #equipment: equipment,
    }),
  );
  @override
  UserData $make(CopyWithData data) => UserData(
    firstName: data.get(#firstName, or: $value.firstName),
    lastName: data.get(#lastName, or: $value.lastName),
    gender: data.get(#gender, or: $value.gender),
    dob: data.get(#dob, or: $value.dob),
    height: data.get(#height, or: $value.height),
    weight: data.get(#weight, or: $value.weight),
    physicalFitness: data.get(#physicalFitness, or: $value.physicalFitness),
    totalCaloriesBurned: data.get(
      #totalCaloriesBurned,
      or: $value.totalCaloriesBurned,
    ),
    milesTraveled: data.get(#milesTraveled, or: $value.milesTraveled),
    exerciseData: data.get(#exerciseData, or: $value.exerciseData),
    disabilities: data.get(#disabilities, or: $value.disabilities),
    equipment: data.get(#equipment, or: $value.equipment),
  );

  @override
  UserDataCopyWith<$R2, UserData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

