import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'package:yourfit/src/models/exercise/exercise_data.dart';
import 'package:yourfit/src/models/exercise/monthly_workout_data.dart';
import 'package:yourfit/src/models/user_data.dart';

class UserService {
  final _userTable = Supabase.instance.client.from("user_data");

  Future<UserData?> createUser(
    String id,
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
        id: id,
        createdAt: DateTime.now(),
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dob: dob,
        weight: weight,
        height: height,
        physicalFitness: activityLevel,
        stats: UserStats(),
      );

      return await createUserFromData(user);
    } on Error catch (e) {
      e.printError();
      return null;
    }
  }

  Future<UserData> createUserFromData(
    UserData user, {
    String? id,
    DateTime? createdAt,
    String? firstName,
    String? lastName,
    double? weight,
    double? height,
    DateTime? dob,
    UserGender? gender,
    UserPhysicalFitness? physicalFitness,
    String? goal,
    int? exerciseDaysPerWeek,
    ExerciseIntensity? exercisesIntensity,
    Map<String, MonthlyWorkoutData>? workoutData,
    Map<String, MonthlyWorkoutData>? waterData,
    List<String>? disabilities,
    List<String>? equipment,
  }) async {
    user = user.copyWith(
      id: id,
      firstName: firstName,
      lastName: lastName,
      weight: weight,
      height: height,
      dob: dob,
      gender: gender,
      physicalFitness: physicalFitness,
      disabilities: disabilities,
      equipment: equipment,
      goal: goal,
      exerciseDaysPerWeek: exerciseDaysPerWeek,
      exercisesIntensity: exercisesIntensity,
      workoutData: workoutData,
    );

    try {
      await _userTable.insert(user.toMap());
    } on Error catch (e) {
      e.printError();
    }
    return user;
  }

  Future<bool> updateUser(UserData user) async {
    try {
      await _userTable.update(user.toMap()).eq("id", user.id);
      return true;
    } on Error catch (e) {
      e.printError();
      return false;
    }
  }

  Future<UserData?> getUser(String id) async {
    try {
      final response = await _userTable.select().eq("id", id);
      response.printInfo();
      return UserData.fromMap(response.first);
    } on Error catch (e) {
      e.printError();
      return null;
    }
  }
}
