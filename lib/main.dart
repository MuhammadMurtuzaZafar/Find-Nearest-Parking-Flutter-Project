import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sg_motorcycle_parking/providerBloc/provider_bloc.dart';
import 'package:sg_motorcycle_parking/screens/loginScreen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SharedPreferences/SharedUserData.dart';

import 'package:sg_motorcycle_parking/screens/homeScreen/home.dart';
void main() {
 // await ShareUserData.init();
 // print(ShareUserData.jwtToken);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool islogin=false;
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();

     autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? gwtToken = prefs.getString('gwtToken');

    if (gwtToken != null) {
      setState(() {
        islogin = true;
      });
      return;
    }
  }
  @override
  Widget build(BuildContext context)  {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);


    return ChangeNotifierProvider  (
      create: (context) => providerBloc(),
      child: MaterialApp  (
        debugShowCheckedModeBanner: false,
        home: !islogin? Login():home(),
      ),
    );
  }}
