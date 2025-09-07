import 'package:extensions_plus/extensions_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'package:yourfit/src/models/user_data.dart';

class UserService {
  final _userTable = Supabase.instance.client.from("user_data");

  Future<UserData> createUser(
    String firstName,
    String lastName,
    double weight,
    double height,
    DateTime dob,
    UserGender gender,
    UserPhysicalFitness activityLevel,
  ) async {
    try {
      UserData user = UserData(
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dob: dob,
        age: dob.age,
        weight: weight,
        height: height,
        physicalFitness: activityLevel,
      );

      return await createUserFromData(user);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<UserData> createUserFromData(
    UserData user, {
    String? firstName,
    String? lastName,
    double? weight,
    double? height,
    DateTime? dob,
    UserGender? gender,
    UserPhysicalFitness? physicalFitness,
  }) async {
    user = user.copyWith(
      firstName: firstName,
      lastName: lastName,
      weight: weight,
      height: height,
      dob: dob,
      age: dob?.age,
      gender: gender,
      physicalFitness: physicalFitness,
    );

    await _userTable.insert(user.toMap());
    return user;
  }

  Future<bool> updateUser(UserData user) async {
    try {
      await _userTable.update(user.toMap()).eq("id", user.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserData?> getUser(String id) async {
    try {
      var response = await _userTable.select().eq("id", id);
      return UserData.fromMap(response.first);
    } catch (e) {
      return null;
    }
  }
}
