// To parse this JSON data, do
//
//     final getProfileModel = getProfileModelFromJson(jsonString);

import 'dart:convert';

GetProfileModel getProfileModelFromJson(String str) => GetProfileModel.fromJson(json.decode(str));

String getProfileModelToJson(GetProfileModel data) => json.encode(data.toJson());

class GetProfileModel {
    GetProfileModel({
       required this.condition,
       required this.profileImage,
    });

    bool condition;
    String profileImage;

    factory GetProfileModel.fromJson(Map<String, dynamic> json) => GetProfileModel(
        condition: json["condition"],
        profileImage: json["profileImage"],
    );

    Map<String, dynamic> toJson() => {
        "condition": condition,
        "profileImage": profileImage,
    };
}
