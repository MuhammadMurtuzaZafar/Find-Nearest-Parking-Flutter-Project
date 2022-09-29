// To parse this JSON data, do
//
//     final changePasswordModel = changePasswordModelFromJson(jsonString);

import 'dart:convert';

ChangePaswordModel changePasswordModelFromJson(String str) => ChangePaswordModel.fromJson(json.decode(str));

String changePasswordModelToJson(ChangePaswordModel data) => json.encode(data.toJson());

class ChangePaswordModel {
  ChangePaswordModel({
  required   this.condition,
    required  this.message,
  });

  bool condition;
  String message;

  factory ChangePaswordModel.fromJson(Map<String, dynamic> json) => ChangePaswordModel(
    condition: json["condition"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "condition": condition,
    "message": message,
  };
}
