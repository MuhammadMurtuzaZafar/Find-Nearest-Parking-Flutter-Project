import 'package:http/http.dart' as http;
import 'package:sg_motorcycle_parking/Api/api.dart';
import 'LoginModel.dart';
class Service{

  // complte Dashboard Data
  static Future<LoginModel> Login(Map<String, String> map) async {

    try {

      // final response = await http.get(tempbooking_url);

      var request = http.MultipartRequest('POST', Uri.parse('https://arcane-stream-32449.herokuapp.com/login'));

      request.fields.addAll(map);
      http.StreamedResponse response = await request.send();
      print("asdas ${response.statusCode}");

     // print(await response.stream.bytesToString());
      if (200 == response.statusCode) {
        //var asa=.toString();

        // 'dart:convert';
        final LoginModel users = loginModelFromJson(await response.stream.bytesToString());
        return users;
      }
      else
      {
        print("pnkaaaaaaa");
        return LoginModel(condition: false, jwtToken: "") ;
      }
    } catch (e) {

      print("pnka ${e.toString()}");
      return LoginModel(condition: false, jwtToken: "") ;
    }
  }
 
}