// To parse this JSON data, do
//
//     final sigunModel = sigunModelFromJson(jsonString);

import 'dart:convert';

SigunModel sigunModelFromJson(String str) => SigunModel.fromJson(json.decode(str));

String sigunModelToJson(SigunModel data) => json.encode(data.toJson());

class SigunModel {
    SigunModel({
       required this.condition,
       required this.jwtToken,
    });

    bool condition;
    String jwtToken;

    factory SigunModel.fromJson(Map<String, dynamic> json) => SigunModel(
        condition: json["condition"],
        jwtToken: json["jwtToken"],
    );

    Map<String, dynamic> toJson() => {
        "condition": condition,
        "jwtToken": jwtToken,
    };
}
