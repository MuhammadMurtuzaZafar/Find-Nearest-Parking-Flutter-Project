// To parse this JSON data, do
//
//     final profileChangeModel = profileChangeModelFromJson(jsonString);

import 'dart:convert';

ProfileChangeModel profileChangeModelFromJson(String str) => ProfileChangeModel.fromJson(json.decode(str));

String profileChangeModelToJson(ProfileChangeModel data) => json.encode(data.toJson());

class ProfileChangeModel {
    ProfileChangeModel({
      required   this.condition,
      required  this.message,
    });

    bool condition;
    String message;

    factory ProfileChangeModel.fromJson(Map<String, dynamic> json) => ProfileChangeModel(
        condition: json["condition"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "condition": condition,
        "message": message,
    };
}
