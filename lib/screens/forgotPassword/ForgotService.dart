import 'package:http/http.dart' as http;
import 'package:sg_motorcycle_parking/Api/api.dart';

import 'dart:convert';

class ForgotService{

  // complte Dashboard Data
  static Future<ForgotModel> forgotEmail(Map<String, String> map) async {

    try {

      // final response = await http.get(tempbooking_url);

      var request = http.MultipartRequest('POST', Uri.parse('https://arcane-stream-32449.herokuapp.com/forgetPasswordEmail'));

      request.fields.addAll(map);
      http.StreamedResponse response = await request.send();
      print("asdas ${response.statusCode}");

     // print(await response.stream.bytesToString());
      if (200 == response.statusCode) {
        //var asa=.toString();

        // 'dart:convert';
        final ForgotModel users = forgotModelFromJson(await response.stream.bytesToString());
        return users;
      }
      else
      {
        return ForgotModel(condition: false) ;
      }
    } catch (e) {

      return ForgotModel(condition: false) ;
    }
  }



  static Future<ForgotModel> checkForgetPasswordOtp(String otp) async {

    try {

      // final response = await http.get(tempbooking_url);

      var request = http.MultipartRequest('POST', Uri.parse('https://arcane-stream-32449.herokuapp.com/checkForgetPasswordOtp'));

      request.fields.addAll({
        'otp': '$otp'
      });
      http.StreamedResponse response = await request.send();
      print("ootp ${response.statusCode}");

      // print(await response.stream.bytesToString());
      if (200 == response.statusCode) {
        //var asa=.toString();

        // 'dart:convert';
        final ForgotModel users = forgotModelFromJson(await response.stream.bytesToString());
        return users;
      }
      else
      {
        return ForgotModel(condition: false) ;
      }
    } catch (e) {

      return ForgotModel(condition: false) ;
    }
  }


  static Future<ForgotModel> resetPassword(Map<String, String> map) async {

    try {

      // final response = await http.get(tempbooking_url);

      var request = http.MultipartRequest('POST', Uri.parse('https://arcane-stream-32449.herokuapp.com/confirmPassword'));

      request.fields.addAll(map);
      http.StreamedResponse response = await request.send();
      print("asdas ${response.statusCode}");

      //print(await response.stream.bytesToString());
      if (200 == response.statusCode) {
        //var asa=.toString();

        // 'dart:convert';
        final ForgotModel users = forgotModelFromJson(await response.stream.bytesToString());
        return users;
      }
      else
      {
        return ForgotModel(condition: false) ;
      }
    } catch (e) {

      return ForgotModel(condition: false) ;
    }
  }


}

ForgotModel forgotModelFromJson(String str) => ForgotModel.fromJson(json.decode(str));

String forgotModelToJson(ForgotModel data) => json.encode(data.toJson());

class ForgotModel {
    ForgotModel({
       required this.condition,
    });

    bool condition;

    factory ForgotModel.fromJson(Map<String, dynamic> json) => ForgotModel(
        condition: json["condition"],
    );

    Map<String, dynamic> toJson() => {
        "condition": condition,
    };
}
