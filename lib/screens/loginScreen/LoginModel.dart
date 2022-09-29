// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
       required this.condition,
       required this.jwtToken,
    });

    bool condition;
    String jwtToken;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        condition: json["condition"],
        jwtToken: json["jwtToken"],
    );

    Map<String, dynamic> toJson() => {
        "condition": condition,
        "jwtToken": jwtToken,
    };
}
