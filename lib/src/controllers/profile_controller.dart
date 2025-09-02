import 'package:get/get.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/services/user_service.dart';

class ProfileController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();
  final UserService _userService = Get.find<UserService>();

  String? firstName;
  String? lastName;
  String? gender; // 'male' | 'female'
  DateTime? dob;
  int? age;
  int? heightCm;
  int? weightKg;
  int? totalCaloriesBurned;
  int? milesTraveled;
  String? activityLevel; // minimal/light/moderate/intense
  String? goal;
  String? experience; // beginner/intermediate/advanced
  int? daysPerWeek;
  String? intensity; // low/moderate/high
  List<String> equipment = const [];
  List<String> injuries = const [];

  bool get isComplete =>
      (firstName?.isNotEmpty == true) &&
      (lastName?.isNotEmpty == true) &&
      (gender != null) &&
      (age != null) &&
      (heightCm != null) &&
      (weightKg != null) &&
      (activityLevel != null) &&
      (goal?.isNotEmpty == true) &&
      (experience != null) &&
      (daysPerWeek != null) &&
      (intensity != null);

  @override
  void onInit() {
    super.onInit();
    final u = _auth.currentUser.value;
    if (u != null) _setFromUser(u);

    _auth.currentUser.listen((u) {
      if (u != null) {
        _setFromUser(u);
        update();
      } else {
        _clear();
        update();
      }
    });
  }

  void _clear() {
    firstName = null;
    lastName = null;
    gender = null;
    dob = null;
    age = null;
    heightCm = null;
    weightKg = null;
    totalCaloriesBurned = null;
    milesTraveled = null;
    activityLevel = null;
    goal = null;
    experience = null;
    daysPerWeek = null;
    intensity = null;
    equipment = const [];
    injuries = const [];
  }

  void _setFromUser(UserData u) {
    firstName = u.firstName;
    lastName = u.lastName;
    gender = (u.gender == UserGender.female) ? 'female' : 'male';
    dob = u.dob;
    age = u.age;
    heightCm = (u.height).round();
    weightKg = (u.weight).round();
    totalCaloriesBurned = u.totalCaloriesBurned.round();
    milesTraveled = u.milesTraveled.round();
    activityLevel = switch (u.physicalActivity) {
      UserPhysicalActivity.light => 'light',
      UserPhysicalActivity.intense => 'intense',
      _ => 'moderate',
    };
  }

  Map<String, dynamic> toContext() {
    final user = <String, dynamic>{};
    if (firstName != null) user['firstName'] = firstName;
    if (lastName != null) user['lastName'] = lastName;
    if (gender != null) user['gender'] = gender;
    if (dob != null) user['dob'] = dob!.toIso8601String().substring(0, 10);
    if (age != null) user['age'] = age;
    if (heightCm != null) user['heightCm'] = heightCm;
    if (weightKg != null) user['weightKg'] = weightKg;
    if (totalCaloriesBurned != null) {
      user['totalCaloriesBurned'] = totalCaloriesBurned;
    }
    if (milesTraveled != null) user['milesTraveled'] = milesTraveled;
    if (activityLevel != null) user['activityLevel'] = activityLevel;

    final plan = <String, dynamic>{};
    if (goal != null) plan['goal'] = goal;
    if (experience != null) plan['experience'] = experience;
    if (daysPerWeek != null) plan['daysPerWeek'] = daysPerWeek;
    if (intensity != null) plan['intensity'] = intensity;
    plan['equipment'] = equipment;
    plan['injuries'] = injuries;

    return {"user": user, "plan": plan};
  }

  UserData? toUserDataOrNull() {
    if (!isComplete) return null;
    final g = (gender?.toLowerCase() == 'female')
        ? UserGender.female
        : UserGender.male;
    final act = (activityLevel ?? 'moderate').toLowerCase();
    final pa = switch (act) {
      'light' => UserPhysicalActivity.light,
      'intense' => UserPhysicalActivity.intense,
      _ => UserPhysicalActivity.moderate,
    };
    final existing = _auth.currentUser.value;
    return UserData(
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      gender: g,
      dob: dob ?? DateTime(2000, 1, 1),
      age: age ?? 0,
      height: (heightCm ?? 0).toDouble(),
      weight: (weightKg ?? 0).toDouble(),
      totalCaloriesBurned: (totalCaloriesBurned ?? 0).toDouble(),
      milesTraveled: (milesTraveled ?? 0).toDouble(),
      physicalActivity: pa,
      exerciseData: existing?.exerciseData ?? {},
    );
  }

  Future<void> persist() async {
    final existing = _auth.currentUser.value;
    if (existing == null) return;

    final merged = UserData(
      firstName: firstName ?? existing.firstName,
      lastName: lastName ?? existing.lastName,
      gender: (gender == 'female') ? UserGender.female : UserGender.male,
      dob: dob ?? existing.dob,
      age: age ?? existing.age,
      height: (heightCm?.toDouble()) ?? existing.height,
      weight: (weightKg?.toDouble()) ?? existing.weight,
      totalCaloriesBurned:
          (totalCaloriesBurned?.toDouble()) ?? existing.totalCaloriesBurned,
      milesTraveled: (milesTraveled?.toDouble()) ?? existing.milesTraveled,
      physicalActivity: switch ((activityLevel ?? '').toLowerCase()) {
        'light' => UserPhysicalActivity.light,
        'intense' => UserPhysicalActivity.intense,
        'moderate' => UserPhysicalActivity.moderate,
        _ => existing.physicalActivity,
      },
      exerciseData: existing.exerciseData,
    );

    await _userService.updateUser(merged);
    _auth.currentUser.value = merged;
  }
}
