// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.condition,
    required this.user,
  });

  bool condition;
  User user;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    condition: json["condition"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "condition": condition,
    "user": user.toJson(),
  };
}

class User {
  User({
    required  this.name,
    required  this.email,
    required this.profileImage,
    required this.v,
  });

  String name;
  String email;
  dynamic profileImage;
  int v;

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    profileImage: json["profileImage"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "profileImage": profileImage,
    "__v": v,
  };
}
