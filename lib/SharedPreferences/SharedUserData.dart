
import 'dart:convert';

import 'package:sg_motorcycle_parking/screens/homeScreen/GetParking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareUserData
{
  static saveData(String val) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("gwtToken", val);
  }


 static Future<String> fetchData() async {
    SharedPreferences logType = await SharedPreferences.getInstance();
    return logType.getString("gwtToken")  ?? "" ;
  }
  static saveRecentData(List<GetParking> recentParkingList) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();


    sharedPreferences.setString("recentParking",getParkingToJson(recentParkingList));
  }


  static Future<List<GetParking>> fetchRecentData() async {
    SharedPreferences logType = await SharedPreferences.getInstance();
    return  getParkingFromJson(logType.getString("recentParking")  ?? "");
  }

}