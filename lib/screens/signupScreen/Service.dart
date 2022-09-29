import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sg_motorcycle_parking/Api/api.dart';

import 'SignUpModel.dart';
class Service{

  // complte Dashboard Data
  static Future<SigunModel> SignUp(Map<String, String> map) async {

    try {

     // final response = await http.get(tempbooking_url);

      var request = http.MultipartRequest('POST', Uri.parse('https://arcane-stream-32449.herokuapp.com/signup'));

      request.fields.addAll(map);
      http.StreamedResponse response = await request.send();
      print(response.statusCode);

      if (200 == response.statusCode) {
        //var asa=.toString();

        // 'dart:convert';
        final SigunModel users = sigunModelFromJson(await response.stream.bytesToString());
        return users;
      }
      else
        {
          print("pnkaaaaaaa");
          return SigunModel(condition: false, jwtToken: "") ;
        }
    } catch (e) {

      print("pnka ${e.toString()}");
      return SigunModel(condition: false, jwtToken: "") ;
    }
  }
 
}