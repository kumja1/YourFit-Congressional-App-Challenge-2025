import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'package:yourfit/src/models/user_data.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  Future<UserData> createUser(
    String firstName,
    String lastName,
    double weight,
    double height,
    int age,
  ) async {
    UserData user = UserData(
      firstName: firstName,
      lastName: lastName,
      age: age,
      weight: weight,
      height: height,
      caloriesBurned: 0,
      exerciseData: {},
      milesTraveled: 0,
    );

    await _supabase.from("user_data").insert(user.toJson());
    return user;
  }

  Future<bool> saveUser(UserData user) async {
    try {
      await _supabase.from("user_data").update(user.toJson()).eq("id", user.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserData?> getUser(String id) async {
    try {
      var response = await _supabase.from("user_data").select().eq("id", id);
      return UserData.fromJson(response.first);
    } catch (e) {
      return null;
    }
  }

  Future<bool> hasUser(String firstName, String lastName) async {
    try {
      await _supabase.from("user_data").select("first_name, last_name").match({
        "first_name": firstName,
        "last_name": lastName,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
