import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';

class UserData extends ChangeNotifier {
  late final String id;

  late final DateTime? createdAt;

  late String firstName;

  late String lastName;

  late int age;

  late double height;

  late double weight;

  late double caloriesBurned;

  late double milesTraveled;

  late Map<String, Map<String, Object>> exerciseData;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.height,
    required this.weight,
    required this.caloriesBurned,
    required this.milesTraveled,
    required this.exerciseData,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    var userData = UserData(
      firstName: json["first_name"],
      lastName: json["last_name"],
      age: json["age"],
      caloriesBurned: json["calories_burned"].toDouble(),
      height: json["height"],
      weight: json["weight"].toDouble(),
      milesTraveled: json["miles_traveled"].toDouble(),
      // roadmapIndex: json["roadmap_index"],
      exerciseData: !json["exercise_data"].isEmpty ? json["exercise_data"] : {},
    );

    userData.id = json["id"];
    userData.createdAt = DateTime.parse(json["created_at"]);

    return userData;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "age": age,
      "calories_burned": caloriesBurned,
      "height": height,
      "weight": weight,
      "miles_traveled": milesTraveled,
      "created_at": createdAt?.toIso8601String(),
      // "roadmap_index": roadmapIndex,
      "exercise_data": jsonEncode(exerciseData),
    };
  }
}
