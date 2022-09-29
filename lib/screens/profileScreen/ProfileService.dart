import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sg_motorcycle_parking/Api/api.dart';
import 'package:sg_motorcycle_parking/screens/profileScreen/GetProfileModel.dart';

import 'ProfileChangeModel.dart';
import 'ProfileModel.dart';
import 'ChangePaswordModel.dart';


import 'dart:ffi';
import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
class ProfileService{

  // complte Dashboard Data
  static Future<ProfileModel> fetchData(Map<String, String> map) async {

    try {

     // final response = await http.get(tempbooking_url);

      var request = http.Request('GET', Uri.parse('https://arcane-stream-32449.herokuapp.com/getProfileInfo'));

      request.headers.addAll(map);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);

      if (200 == response.statusCode) {
        //var asa=.toString();

        // 'dart:convert';
        final ProfileModel users = profileModelFromJson(await response.stream.bytesToString());
        return users;
      }
      else
        {
          print("pnkaaaaaaa");
          return ProfileModel(condition: false,user:User(email: "",name: "",profileImage: "",v: 0));
        }
    } catch (e) {

      print("pnka ${e.toString()}");
      return ProfileModel(condition: false,user:User(email: "",name: "",profileImage: "",v: 0));
    }
  }
 
 
 static Future<GetProfileModel> fetchProfileImage(Map<String, String> header) async {

    try {

     // final response = await http.get(tempbooking_url);

      var request = http.Request('GET', Uri.parse('https://arcane-stream-32449.herokuapp.com/getProfileImage'));

      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();
      print("myImage ${response.statusCode}");

      if (200 == response.statusCode) {
        //var asa=.toString();

        // 'dart:convert';
        final GetProfileModel users = getProfileModelFromJson(await response.stream.bytesToString());
        return users;
      }
      else
        {
          print("pnkaaaaaaa");
          return GetProfileModel(condition: false,profileImage: "");
        }
    } catch (e) {

      print("pnka ${e.toString()}");
      return GetProfileModel(condition: false,profileImage: "");
    }
  }




  static Future<ChangePaswordModel> changePasword(Map<String, String> headar,Map<String, String> body) async {

    try {


      var request = http.MultipartRequest('POST', Uri.parse('https://arcane-stream-32449.herokuapp.com/changePassword'));
      request.fields.addAll(body);
      print(headar.toString());
      request.headers.addAll(headar);

      http.StreamedResponse response = await request.send();

      print(response.statusCode);

   //  print(await response.stream.bytesToString());
      if (200 == response.statusCode) {
        //var asa=.toString();

        // 'dart:convert';
        final ChangePaswordModel users = changePasswordModelFromJson(await response.stream.bytesToString());
        return users;
      }
      else
      {
        print("pnkaaaaaaa");
        return ChangePaswordModel(condition: false,message: "");
      }
    } catch (e) {

      print("pnka ${e.toString()}");
      return ChangePaswordModel(condition: false,message: "");
    }
  }




 static Future<ProfileChangeModel> changeProfile(Map<String, String> headar,File  imageFile) async {

    try {

 
 
 // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("https://arcane-stream-32449.herokuapp.com/changeProfileImage");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    request.headers.addAll(headar);
    // send
    var response = await request.send();
    print(response.statusCode); 
    print("ooo");
   //  print(await response.stream.bytesToString());
      if (200 == response.statusCode) {
        //var asa=.toString();

        // 'dart:convert';
        final ProfileChangeModel users = profileChangeModelFromJson(await response.stream.bytesToString()) ;
        return users;
      }
      else
      {
        print("pnkaaaaaaa");
        return ProfileChangeModel(condition: false,message: "");
      }
    } catch (e) {

      print("pnka ${e.toString()}");
      return ProfileChangeModel(condition: false,message: "");
    }
  }

}