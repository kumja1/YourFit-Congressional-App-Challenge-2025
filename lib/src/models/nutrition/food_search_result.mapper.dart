// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'food_search_result.dart';

class FoodSearchResultMapper extends ClassMapperBase<FoodSearchResult> {
  FoodSearchResultMapper._();

  static FoodSearchResultMapper? _instance;
  static FoodSearchResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FoodSearchResultMapper._());
      NutrientDataMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FoodSearchResult';

  static String _$fdcId(FoodSearchResult v) => v.fdcId;
  static const Field<FoodSearchResult, String> _f$fdcId = Field(
    'fdcId',
    _$fdcId,
  );
  static String _$name(FoodSearchResult v) => v.name;
  static const Field<FoodSearchResult, String> _f$name = Field(
    'name',
    _$name,
    key: r'description',
  );
  static String _$brand(FoodSearchResult v) => v.brand;
  static const Field<FoodSearchResult, String> _f$brand = Field(
    'brand',
    _$brand,
    key: r'brandName',
  );
  static String _$category(FoodSearchResult v) => v.category;
  static const Field<FoodSearchResult, String> _f$category = Field(
    'category',
    _$category,
    key: r'foodCategory',
  );
  static String _$servingSizeUnit(FoodSearchResult v) => v.servingSizeUnit;
  static const Field<FoodSearchResult, String> _f$servingSizeUnit = Field(
    'servingSizeUnit',
    _$servingSizeUnit,
  );
  static double _$servingSize(FoodSearchResult v) => v.servingSize;
  static const Field<FoodSearchResult, double> _f$servingSize = Field(
    'servingSize',
    _$servingSize,
  );
  static List<NutrientData> _$nutrients(FoodSearchResult v) => v.nutrients;
  static const Field<FoodSearchResult, List<NutrientData>> _f$nutrients = Field(
    'nutrients',
    _$nutrients,
    key: r'foodNutrients',
  );

  @override
  final MappableFields<FoodSearchResult> fields = const {
    #fdcId: _f$fdcId,
    #name: _f$name,
    #brand: _f$brand,
    #category: _f$category,
    #servingSizeUnit: _f$servingSizeUnit,
    #servingSize: _f$servingSize,
    #nutrients: _f$nutrients,
  };

  static FoodSearchResult _instantiate(DecodingData data) {
    return FoodSearchResult(
      fdcId: data.dec(_f$fdcId),
      name: data.dec(_f$name),
      brand: data.dec(_f$brand),
      category: data.dec(_f$category),
      servingSizeUnit: data.dec(_f$servingSizeUnit),
      servingSize: data.dec(_f$servingSize),
      nutrients: data.dec(_f$nutrients),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FoodSearchResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FoodSearchResult>(map);
  }

  static FoodSearchResult fromJson(String json) {
    return ensureInitialized().decodeJson<FoodSearchResult>(json);
  }
}

mixin FoodSearchResultMappable {
  String toJson() {
    return FoodSearchResultMapper.ensureInitialized()
        .encodeJson<FoodSearchResult>(this as FoodSearchResult);
  }

  Map<String, dynamic> toMap() {
    return FoodSearchResultMapper.ensureInitialized()
        .encodeMap<FoodSearchResult>(this as FoodSearchResult);
  }

  FoodSearchResultCopyWith<FoodSearchResult, FoodSearchResult, FoodSearchResult>
  get copyWith =>
      _FoodSearchResultCopyWithImpl<FoodSearchResult, FoodSearchResult>(
        this as FoodSearchResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FoodSearchResultMapper.ensureInitialized().stringifyValue(
      this as FoodSearchResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FoodSearchResultMapper.ensureInitialized().equalsValue(
      this as FoodSearchResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FoodSearchResultMapper.ensureInitialized().hashValue(
      this as FoodSearchResult,
    );
  }
}

extension FoodSearchResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FoodSearchResult, $Out> {
  FoodSearchResultCopyWith<$R, FoodSearchResult, $Out>
  get $asFoodSearchResult =>
      $base.as((v, t, t2) => _FoodSearchResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FoodSearchResultCopyWith<$R, $In extends FoodSearchResult, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    NutrientData,
    NutrientDataCopyWith<$R, NutrientData, NutrientData>
  >
  get nutrients;
  $R call({
    String? fdcId,
    String? name,
    String? brand,
    String? category,
    String? servingSizeUnit,
    double? servingSize,
    List<NutrientData>? nutrients,
  });
  FoodSearchResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FoodSearchResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FoodSearchResult, $Out>
    implements FoodSearchResultCopyWith<$R, FoodSearchResult, $Out> {
  _FoodSearchResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FoodSearchResult> $mapper =
      FoodSearchResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    NutrientData,
    NutrientDataCopyWith<$R, NutrientData, NutrientData>
  >
  get nutrients => ListCopyWith(
    $value.nutrients,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(nutrients: v),
  );
  @override
  $R call({
    String? fdcId,
    String? name,
    String? brand,
    String? category,
    String? servingSizeUnit,
    double? servingSize,
    List<NutrientData>? nutrients,
  }) => $apply(
    FieldCopyWithData({
      if (fdcId != null) #fdcId: fdcId,
      if (name != null) #name: name,
      if (brand != null) #brand: brand,
      if (category != null) #category: category,
      if (servingSizeUnit != null) #servingSizeUnit: servingSizeUnit,
      if (servingSize != null) #servingSize: servingSize,
      if (nutrients != null) #nutrients: nutrients,
    }),
  );
  @override
  FoodSearchResult $make(CopyWithData data) => FoodSearchResult(
    fdcId: data.get(#fdcId, or: $value.fdcId),
    name: data.get(#name, or: $value.name),
    brand: data.get(#brand, or: $value.brand),
    category: data.get(#category, or: $value.category),
    servingSizeUnit: data.get(#servingSizeUnit, or: $value.servingSizeUnit),
    servingSize: data.get(#servingSize, or: $value.servingSize),
    nutrients: data.get(#nutrients, or: $value.nutrients),
  );

  @override
  FoodSearchResultCopyWith<$R2, FoodSearchResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FoodSearchResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NutrientDataMapper extends ClassMapperBase<NutrientData> {
  NutrientDataMapper._();

  static NutrientDataMapper? _instance;
  static NutrientDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NutrientDataMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'NutrientData';

  static String _$name(NutrientData v) => v.name;
  static const Field<NutrientData, String> _f$name = Field(
    'name',
    _$name,
    key: r'nutrientName',
  );
  static String _$unit(NutrientData v) => v.unit;
  static const Field<NutrientData, String> _f$unit = Field(
    'unit',
    _$unit,
    key: r'unitName',
  );
  static double _$value(NutrientData v) => v.value;
  static const Field<NutrientData, double> _f$value = Field('value', _$value);

  @override
  final MappableFields<NutrientData> fields = const {
    #name: _f$name,
    #unit: _f$unit,
    #value: _f$value,
  };

  static NutrientData _instantiate(DecodingData data) {
    return NutrientData(
      name: data.dec(_f$name),
      unit: data.dec(_f$unit),
      value: data.dec(_f$value),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NutrientData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NutrientData>(map);
  }

  static NutrientData fromJson(String json) {
    return ensureInitialized().decodeJson<NutrientData>(json);
  }
}

mixin NutrientDataMappable {
  String toJson() {
    return NutrientDataMapper.ensureInitialized().encodeJson<NutrientData>(
      this as NutrientData,
    );
  }

  Map<String, dynamic> toMap() {
    return NutrientDataMapper.ensureInitialized().encodeMap<NutrientData>(
      this as NutrientData,
    );
  }

  NutrientDataCopyWith<NutrientData, NutrientData, NutrientData> get copyWith =>
      _NutrientDataCopyWithImpl<NutrientData, NutrientData>(
        this as NutrientData,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return NutrientDataMapper.ensureInitialized().stringifyValue(
      this as NutrientData,
    );
  }

  @override
  bool operator ==(Object other) {
    return NutrientDataMapper.ensureInitialized().equalsValue(
      this as NutrientData,
      other,
    );
  }

  @override
  int get hashCode {
    return NutrientDataMapper.ensureInitialized().hashValue(
      this as NutrientData,
    );
  }
}

extension NutrientDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NutrientData, $Out> {
  NutrientDataCopyWith<$R, NutrientData, $Out> get $asNutrientData =>
      $base.as((v, t, t2) => _NutrientDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NutrientDataCopyWith<$R, $In extends NutrientData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? unit, double? value});
  NutrientDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _NutrientDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NutrientData, $Out>
    implements NutrientDataCopyWith<$R, NutrientData, $Out> {
  _NutrientDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NutrientData> $mapper =
      NutrientDataMapper.ensureInitialized();
  @override
  $R call({String? name, String? unit, double? value}) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (unit != null) #unit: unit,
      if (value != null) #value: value,
    }),
  );
  @override
  NutrientData $make(CopyWithData data) => NutrientData(
    name: data.get(#name, or: $value.name),
    unit: data.get(#unit, or: $value.unit),
    value: data.get(#value, or: $value.value),
  );

  @override
  NutrientDataCopyWith<$R2, NutrientData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NutrientDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

