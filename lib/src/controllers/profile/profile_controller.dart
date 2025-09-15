import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  late final profile = ProfileData().obs;

  final loading = false.obs;
  final error = Rxn<String>();

  final _supabase = Supabase.instance.client;
  User? get _currentUser => _supabase.auth.currentUser;

  static const String _tableName = 'profiles';
  static const String _userIdColumn = 'user_id';

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    if (!_validateUser()) return;

    loading.value = true;
    error.value = null;

    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq(_userIdColumn, _currentUser!.id)
          .maybeSingle();

      if (response != null) {
        profile.value = ProfileData.fromSupabase(response, _currentUser!);
      } else {
        profile.value = ProfileData.fromUser(_currentUser!);
        await _createProfile();
      }
    } catch (e) {
      error.value = 'Failed to load profile: $e';
      print(error.value);
    } finally {
      loading.value = false;
    }
  }

  Future<void> persist() async {
    if (!_validateUser()) return;

    loading.value = true;
    error.value = null;

    try {
      await _supabase
          .from(_tableName)
          .upsert(
            profile.value.toSupabase(_currentUser!.id),
            onConflict: _userIdColumn,
          );
    } catch (e) {
      error.value = 'Failed to save profile: $e';
      print(error.value);
    } finally {
      loading.value = false;
    }
  }

  Future<void> _createProfile() async {
    try {
      await _supabase
          .from(_tableName)
          .insert(profile.value.toSupabase(_currentUser!.id, isNew: true));
    } catch (e) {
      print('Error creating profile: $e');
    }
  }

  bool _validateUser() {
    if (_currentUser == null) {
      error.value = 'No user signed in';
      loading.value = false;
      return false;
    }
    return true;
  }

  void clear() {
    profile.value = ProfileData();
    error.value = null;
    loading.value = false;
  }

  String? get firstName => profile.value.firstName;
  String? get lastName => profile.value.lastName;
  String? get email => profile.value.email;
  String? get gender => profile.value.gender;
  int? get age => profile.value.age;
  int? get heightCm => profile.value.heightCm;
  int? get weightKg => profile.value.weightKg;
  String? get goal => profile.value.goal;
  String? get activityLevel => profile.value.activityLevel;
  String? get experience => profile.value.experience;
  int? get daysPerWeek => profile.value.daysPerWeek;
  String? get intensity => profile.value.intensity;
  List<String> get equipment => profile.value.equipment;
  List<String> get injuries => profile.value.injuries;

  set firstName(String? v) => profile.update((p) => p?.firstName = v);
  set lastName(String? v) => profile.update((p) => p?.lastName = v);
  set email(String? v) => profile.update((p) => p?.email = v);
  set gender(String? v) => profile.update((p) => p?.gender = v);
  set age(int? v) => profile.update((p) => p?.age = v);
  set heightCm(int? v) => profile.update((p) => p?.heightCm = v);
  set weightKg(int? v) => profile.update((p) => p?.weightKg = v);
  set goal(String? v) => profile.update((p) => p?.goal = v);
  set activityLevel(String? v) => profile.update((p) => p?.activityLevel = v);
  set experience(String? v) => profile.update((p) => p?.experience = v);
  set daysPerWeek(int? v) => profile.update((p) => p?.daysPerWeek = v);
  set intensity(String? v) => profile.update((p) => p?.intensity = v);
  set equipment(List<String> v) => profile.update((p) => p?.equipment = v);
  set injuries(List<String> v) => profile.update((p) => p?.injuries = v);

  Map<String, dynamic> toContext() => profile.value.toContext();
}

class ProfileData {
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  int? age;
  int? heightCm;
  int? weightKg;
  String? goal;
  String? activityLevel;
  String? experience;
  int? daysPerWeek;
  String? intensity;
  List<String> equipment;
  List<String> injuries;

  ProfileData({
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.age,
    this.heightCm,
    this.weightKg,
    this.goal,
    this.activityLevel,
    this.experience,
    this.daysPerWeek,
    this.intensity,
    List<String>? equipment,
    List<String>? injuries,
  }) : equipment = equipment ?? [],
       injuries = injuries ?? [];

  factory ProfileData.fromSupabase(Map<String, dynamic> data, User user) {
    return ProfileData(
      firstName: data['first_name'] ?? user.userMetadata?['first_name'],
      lastName: data['last_name'] ?? user.userMetadata?['last_name'],
      email: data['email'] ?? user.email,
      gender: data['gender'],
      age: data['age'],
      heightCm: data['height_cm'],
      weightKg: data['weight_kg'],
      goal: data['goal'],
      activityLevel: data['activity_level'],
      experience: data['experience'],
      daysPerWeek: data['days_per_week'],
      intensity: data['intensity'],
      equipment: List<String>.from(data['equipment'] ?? []),
      injuries: List<String>.from(data['injuries'] ?? []),
    );
  }

  factory ProfileData.fromUser(User user) {
    return ProfileData(
      firstName: user.userMetadata?['first_name'],
      lastName: user.userMetadata?['last_name'],
      email: user.email,
    );
  }

  Map<String, dynamic> toSupabase(String userId, {bool isNew = false}) {
    final now = DateTime.now().toIso8601String();
    final data = {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'gender': gender,
      'age': age,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'goal': goal,
      'activity_level': activityLevel,
      'experience': experience,
      'days_per_week': daysPerWeek,
      'intensity': intensity,
      'equipment': equipment,
      'injuries': injuries,
      'updated_at': now,
    };

    if (isNew) {
      data['created_at'] = now;
    }

    return data;
  }

  Map<String, dynamic> toContext() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'goal': goal,
      'activityLevel': activityLevel,
      'experience': experience,
      'daysPerWeek': daysPerWeek,
      'intensity': intensity,
      'equipment': equipment,
      'injuries': injuries,
    };
  }

  ProfileData copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? gender,
    int? age,
    int? heightCm,
    int? weightKg,
    String? goal,
    String? activityLevel,
    String? experience,
    int? daysPerWeek,
    String? intensity,
    List<String>? equipment,
    List<String>? injuries,
  }) {
    return ProfileData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
      experience: experience ?? this.experience,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      intensity: intensity ?? this.intensity,
      equipment: equipment ?? this.equipment,
      injuries: injuries ?? this.injuries,
    );
  }
}
