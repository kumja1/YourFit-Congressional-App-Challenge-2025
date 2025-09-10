import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
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

  List<String> equipment = [];
  List<String> injuries = [];

  bool loading = false;
  String? error;

  final _supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    try {
      loading = true;
      error = null;
      update();

      final user = _supabase.auth.currentUser;
      if (user == null) {
        error = 'No user signed in';
        loading = false;
        update();
        return;
      }

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (response != null) {
        firstName = response['first_name'] ?? user.userMetadata?['first_name'];
        lastName = response['last_name'] ?? user.userMetadata?['last_name'];
        email = response['email'] ?? user.email;
        gender = response['gender'];
        age = response['age'];
        heightCm = response['height_cm'];
        weightKg = response['weight_kg'];
        goal = response['goal'];
        activityLevel = response['activity_level'];
        experience = response['experience'];
        daysPerWeek = response['days_per_week'];
        intensity = response['intensity'];
        equipment = List<String>.from(response['equipment'] ?? []);
        injuries = List<String>.from(response['injuries'] ?? []);
      } else {
        firstName = user.userMetadata?['first_name'];
        lastName = user.userMetadata?['last_name'];
        email = user.email;

        await _createProfile(user.id);
      }
    } catch (e) {
      error = 'Failed to load profile: $e';
      print(error);
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> _createProfile(String userId) async {
    try {
      await _supabase.from('profiles').insert({
        'user_id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error creating profile: $e');
    }
  }

  Future<void> persist() async {
    try {
      loading = true;
      error = null;
      update();

      final user = _supabase.auth.currentUser;
      if (user == null) {
        error = 'No user signed in';
        loading = false;
        update();
        return;
      }

      final data = {
        'user_id': user.id,
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
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('profiles').upsert(data, onConflict: 'user_id');
    } catch (e) {
      error = 'Failed to save profile: $e';
      print(error);
    } finally {
      loading = false;
      update();
    }
  }

  void clear() {
    firstName = null;
    lastName = null;
    email = null;
    gender = null;
    age = null;
    heightCm = null;
    weightKg = null;
    goal = null;
    activityLevel = null;
    experience = null;
    daysPerWeek = null;
    intensity = null;
    equipment = [];
    injuries = [];
    error = null;
    loading = false;
    update();
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
}
