// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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

class UserPhysicalActivityMapper extends EnumMapper<UserPhysicalActivity> {
  UserPhysicalActivityMapper._();

  static UserPhysicalActivityMapper? _instance;
  static UserPhysicalActivityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserPhysicalActivityMapper._());
    }
    return _instance!;
  }

  static UserPhysicalActivity fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  UserPhysicalActivity decode(dynamic value) {
    switch (value) {
      case r'minimal':
        return UserPhysicalActivity.minimal;
      case r'light':
        return UserPhysicalActivity.light;
      case r'moderate':
        return UserPhysicalActivity.moderate;
      case r'intense':
        return UserPhysicalActivity.intense;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(UserPhysicalActivity self) {
    switch (self) {
      case UserPhysicalActivity.minimal:
        return r'minimal';
      case UserPhysicalActivity.light:
        return r'light';
      case UserPhysicalActivity.moderate:
        return r'moderate';
      case UserPhysicalActivity.intense:
        return r'intense';
    }
  }
}

extension UserPhysicalActivityMapperExtension on UserPhysicalActivity {
  String toValue() {
    UserPhysicalActivityMapper.ensureInitialized();
    return MapperContainer.globals.toValue<UserPhysicalActivity>(this)
        as String;
  }
}

class UserDataMapper extends ClassMapperBase<UserData> {
  UserDataMapper._();

  static UserDataMapper? _instance;
  static UserDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserDataMapper._());
      UserGenderMapper.ensureInitialized();
      UserPhysicalActivityMapper.ensureInitialized();
      MonthDataMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserData';

  static String _$firstName(UserData v) => v.firstName;
  static const Field<UserData, String> _f$firstName =
      Field('firstName', _$firstName);
  static String _$lastName(UserData v) => v.lastName;
  static const Field<UserData, String> _f$lastName =
      Field('lastName', _$lastName);
  static UserGender _$gender(UserData v) => v.gender;
  static const Field<UserData, UserGender> _f$gender =
      Field('gender', _$gender);
  static DateTime _$dob(UserData v) => v.dob;
  static const Field<UserData, DateTime> _f$dob = Field('dob', _$dob);
  static int _$age(UserData v) => v.age;
  static const Field<UserData, int> _f$age = Field('age', _$age);
  static int _$height(UserData v) => v.height;
  static const Field<UserData, int> _f$height = Field('height', _$height);
  static double _$weight(UserData v) => v.weight;
  static const Field<UserData, double> _f$weight = Field('weight', _$weight);
  static double _$totalCaloriesBurned(UserData v) => v.totalCaloriesBurned;
  static const Field<UserData, double> _f$totalCaloriesBurned =
      Field('totalCaloriesBurned', _$totalCaloriesBurned);
  static double _$milesTraveled(UserData v) => v.milesTraveled;
  static const Field<UserData, double> _f$milesTraveled =
      Field('milesTraveled', _$milesTraveled);
  static UserPhysicalActivity _$activityLevel(UserData v) => v.activityLevel;
  static const Field<UserData, UserPhysicalActivity> _f$activityLevel =
      Field('activityLevel', _$activityLevel);
  static Map<DateTime, MonthData> _$exerciseData(UserData v) => v.exerciseData;
  static const Field<UserData, Map<DateTime, MonthData>> _f$exerciseData =
      Field('exerciseData', _$exerciseData);
  static String _$id(UserData v) => v.id;
  static const Field<UserData, String> _f$id =
      Field('id', _$id, mode: FieldMode.member);
  static DateTime _$createdAt(UserData v) => v.createdAt;
  static const Field<UserData, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, mode: FieldMode.member);

  @override
  final MappableFields<UserData> fields = const {
    #firstName: _f$firstName,
    #lastName: _f$lastName,
    #gender: _f$gender,
    #dob: _f$dob,
    #age: _f$age,
    #height: _f$height,
    #weight: _f$weight,
    #totalCaloriesBurned: _f$totalCaloriesBurned,
    #milesTraveled: _f$milesTraveled,
    #activityLevel: _f$activityLevel,
    #exerciseData: _f$exerciseData,
    #id: _f$id,
    #createdAt: _f$createdAt,
  };

  static UserData _instantiate(DecodingData data) {
    return UserData(
        firstName: data.dec(_f$firstName),
        lastName: data.dec(_f$lastName),
        gender: data.dec(_f$gender),
        dob: data.dec(_f$dob),
        age: data.dec(_f$age),
        height: data.dec(_f$height),
        weight: data.dec(_f$weight),
        totalCaloriesBurned: data.dec(_f$totalCaloriesBurned),
        milesTraveled: data.dec(_f$milesTraveled),
        activityLevel: data.dec(_f$activityLevel),
        exerciseData: data.dec(_f$exerciseData));
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
    return UserDataMapper.ensureInitialized()
        .encodeJson<UserData>(this as UserData);
  }

  Map<String, dynamic> toMap() {
    return UserDataMapper.ensureInitialized()
        .encodeMap<UserData>(this as UserData);
  }

  UserDataCopyWith<UserData, UserData, UserData> get copyWith =>
      _UserDataCopyWithImpl<UserData, UserData>(
          this as UserData, $identity, $identity);
  @override
  String toString() {
    return UserDataMapper.ensureInitialized().stringifyValue(this as UserData);
  }

  @override
  bool operator ==(Object other) {
    return UserDataMapper.ensureInitialized()
        .equalsValue(this as UserData, other);
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
  MapCopyWith<$R, DateTime, MonthData,
      MonthDataCopyWith<$R, MonthData, MonthData>> get exerciseData;
  $R call(
      {String? firstName,
      String? lastName,
      UserGender? gender,
      DateTime? dob,
      int? age,
      int? height,
      double? weight,
      double? totalCaloriesBurned,
      double? milesTraveled,
      UserPhysicalActivity? activityLevel,
      Map<DateTime, MonthData>? exerciseData});
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
  MapCopyWith<$R, DateTime, MonthData,
          MonthDataCopyWith<$R, MonthData, MonthData>>
      get exerciseData => MapCopyWith($value.exerciseData,
          (v, t) => v.copyWith.$chain(t), (v) => call(exerciseData: v));
  @override
  $R call(
          {String? firstName,
          String? lastName,
          UserGender? gender,
          DateTime? dob,
          int? age,
          int? height,
          double? weight,
          double? totalCaloriesBurned,
          double? milesTraveled,
          UserPhysicalActivity? activityLevel,
          Map<DateTime, MonthData>? exerciseData}) =>
      $apply(FieldCopyWithData({
        if (firstName != null) #firstName: firstName,
        if (lastName != null) #lastName: lastName,
        if (gender != null) #gender: gender,
        if (dob != null) #dob: dob,
        if (age != null) #age: age,
        if (height != null) #height: height,
        if (weight != null) #weight: weight,
        if (totalCaloriesBurned != null)
          #totalCaloriesBurned: totalCaloriesBurned,
        if (milesTraveled != null) #milesTraveled: milesTraveled,
        if (activityLevel != null) #activityLevel: activityLevel,
        if (exerciseData != null) #exerciseData: exerciseData
      }));
  @override
  UserData $make(CopyWithData data) => UserData(
      firstName: data.get(#firstName, or: $value.firstName),
      lastName: data.get(#lastName, or: $value.lastName),
      gender: data.get(#gender, or: $value.gender),
      dob: data.get(#dob, or: $value.dob),
      age: data.get(#age, or: $value.age),
      height: data.get(#height, or: $value.height),
      weight: data.get(#weight, or: $value.weight),
      totalCaloriesBurned:
          data.get(#totalCaloriesBurned, or: $value.totalCaloriesBurned),
      milesTraveled: data.get(#milesTraveled, or: $value.milesTraveled),
      activityLevel: data.get(#activityLevel, or: $value.activityLevel),
      exerciseData: data.get(#exerciseData, or: $value.exerciseData));

  @override
  UserDataCopyWith<$R2, UserData, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
