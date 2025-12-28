// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'meal_data.dart';

class MealTypeMapper extends EnumMapper<MealType> {
  MealTypeMapper._();

  static MealTypeMapper? _instance;
  static MealTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MealTypeMapper._());
    }
    return _instance!;
  }

  static MealType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  MealType decode(dynamic value) {
    switch (value) {
      case r'breakfast':
        return MealType.breakfast;
      case r'lunch':
        return MealType.lunch;
      case r'dinner':
        return MealType.dinner;
      case r'snacks':
        return MealType.snacks;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(MealType self) {
    switch (self) {
      case MealType.breakfast:
        return r'breakfast';
      case MealType.lunch:
        return r'lunch';
      case MealType.dinner:
        return r'dinner';
      case MealType.snacks:
        return r'snacks';
    }
  }
}

extension MealTypeMapperExtension on MealType {
  String toValue() {
    MealTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<MealType>(this) as String;
  }
}

class MealDataMapper extends ClassMapperBase<MealData> {
  MealDataMapper._();

  static MealDataMapper? _instance;
  static MealDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MealDataMapper._());
      MealTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MealData';

  static String _$name(MealData v) => v.name;
  static const Field<MealData, String> _f$name = Field('name', _$name);
  static double _$kcal(MealData v) => v.kcal;
  static const Field<MealData, double> _f$kcal = Field('kcal', _$kcal);
  static double _$grams(MealData v) => v.grams;
  static const Field<MealData, double> _f$grams = Field('grams', _$grams);
  static double _$proteinG(MealData v) => v.proteinG;
  static const Field<MealData, double> _f$proteinG = Field(
    'proteinG',
    _$proteinG,
  );
  static double _$carbsG(MealData v) => v.carbsG;
  static const Field<MealData, double> _f$carbsG = Field('carbsG', _$carbsG);
  static double _$fatG(MealData v) => v.fatG;
  static const Field<MealData, double> _f$fatG = Field('fatG', _$fatG);
  static double _$fiberG(MealData v) => v.fiberG;
  static const Field<MealData, double> _f$fiberG = Field('fiberG', _$fiberG);
  static double _$sugarG(MealData v) => v.sugarG;
  static const Field<MealData, double> _f$sugarG = Field('sugarG', _$sugarG);
  static double _$sodiumMg(MealData v) => v.sodiumMg;
  static const Field<MealData, double> _f$sodiumMg = Field(
    'sodiumMg',
    _$sodiumMg,
  );
  static DateTime _$time(MealData v) => v.time;
  static const Field<MealData, DateTime> _f$time = Field('time', _$time);
  static MealType _$type(MealData v) => v.type;
  static const Field<MealData, MealType> _f$type = Field('type', _$type);
  static String _$brand(MealData v) => v.brand;
  static const Field<MealData, String> _f$brand = Field(
    'brand',
    _$brand,
    opt: true,
    def: '',
  );

  @override
  final MappableFields<MealData> fields = const {
    #name: _f$name,
    #kcal: _f$kcal,
    #grams: _f$grams,
    #proteinG: _f$proteinG,
    #carbsG: _f$carbsG,
    #fatG: _f$fatG,
    #fiberG: _f$fiberG,
    #sugarG: _f$sugarG,
    #sodiumMg: _f$sodiumMg,
    #time: _f$time,
    #type: _f$type,
    #brand: _f$brand,
  };

  static MealData _instantiate(DecodingData data) {
    return MealData(
      name: data.dec(_f$name),
      kcal: data.dec(_f$kcal),
      grams: data.dec(_f$grams),
      proteinG: data.dec(_f$proteinG),
      carbsG: data.dec(_f$carbsG),
      fatG: data.dec(_f$fatG),
      fiberG: data.dec(_f$fiberG),
      sugarG: data.dec(_f$sugarG),
      sodiumMg: data.dec(_f$sodiumMg),
      time: data.dec(_f$time),
      type: data.dec(_f$type),
      brand: data.dec(_f$brand),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MealData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MealData>(map);
  }

  static MealData fromJson(String json) {
    return ensureInitialized().decodeJson<MealData>(json);
  }
}

mixin MealDataMappable {
  String toJson() {
    return MealDataMapper.ensureInitialized().encodeJson<MealData>(
      this as MealData,
    );
  }

  Map<String, dynamic> toMap() {
    return MealDataMapper.ensureInitialized().encodeMap<MealData>(
      this as MealData,
    );
  }

  MealDataCopyWith<MealData, MealData, MealData> get copyWith =>
      _MealDataCopyWithImpl<MealData, MealData>(
        this as MealData,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MealDataMapper.ensureInitialized().stringifyValue(this as MealData);
  }

  @override
  bool operator ==(Object other) {
    return MealDataMapper.ensureInitialized().equalsValue(
      this as MealData,
      other,
    );
  }

  @override
  int get hashCode {
    return MealDataMapper.ensureInitialized().hashValue(this as MealData);
  }
}

extension MealDataValueCopy<$R, $Out> on ObjectCopyWith<$R, MealData, $Out> {
  MealDataCopyWith<$R, MealData, $Out> get $asMealData =>
      $base.as((v, t, t2) => _MealDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MealDataCopyWith<$R, $In extends MealData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? name,
    double? kcal,
    double? grams,
    double? proteinG,
    double? carbsG,
    double? fatG,
    double? fiberG,
    double? sugarG,
    double? sodiumMg,
    DateTime? time,
    MealType? type,
    String? brand,
  });
  MealDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MealDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MealData, $Out>
    implements MealDataCopyWith<$R, MealData, $Out> {
  _MealDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MealData> $mapper =
      MealDataMapper.ensureInitialized();
  @override
  $R call({
    String? name,
    double? kcal,
    double? grams,
    double? proteinG,
    double? carbsG,
    double? fatG,
    double? fiberG,
    double? sugarG,
    double? sodiumMg,
    DateTime? time,
    MealType? type,
    String? brand,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (kcal != null) #kcal: kcal,
      if (grams != null) #grams: grams,
      if (proteinG != null) #proteinG: proteinG,
      if (carbsG != null) #carbsG: carbsG,
      if (fatG != null) #fatG: fatG,
      if (fiberG != null) #fiberG: fiberG,
      if (sugarG != null) #sugarG: sugarG,
      if (sodiumMg != null) #sodiumMg: sodiumMg,
      if (time != null) #time: time,
      if (type != null) #type: type,
      if (brand != null) #brand: brand,
    }),
  );
  @override
  MealData $make(CopyWithData data) => MealData(
    name: data.get(#name, or: $value.name),
    kcal: data.get(#kcal, or: $value.kcal),
    grams: data.get(#grams, or: $value.grams),
    proteinG: data.get(#proteinG, or: $value.proteinG),
    carbsG: data.get(#carbsG, or: $value.carbsG),
    fatG: data.get(#fatG, or: $value.fatG),
    fiberG: data.get(#fiberG, or: $value.fiberG),
    sugarG: data.get(#sugarG, or: $value.sugarG),
    sodiumMg: data.get(#sodiumMg, or: $value.sodiumMg),
    time: data.get(#time, or: $value.time),
    type: data.get(#type, or: $value.type),
    brand: data.get(#brand, or: $value.brand),
  );

  @override
  MealDataCopyWith<$R2, MealData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MealDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

