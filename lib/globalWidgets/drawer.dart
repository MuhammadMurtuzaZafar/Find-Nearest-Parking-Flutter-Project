import 'package:flutter/material.dart';
import 'package:sg_motorcycle_parking/SharedPreferences/SharedUserData.dart';
import 'package:sg_motorcycle_parking/screens/homeScreen/home.dart';
import 'package:sg_motorcycle_parking/screens/loginScreen/login.dart';
import 'package:sg_motorcycle_parking/screens/profileScreen/profile.dart';
import 'package:url_launcher/url_launcher.dart';

Widget drawer(context) {
  return Drawer(
    child: Container(
      padding: EdgeInsets.fromLTRB(20, 20, 5, 0),
      height: double.infinity,
      width: double.infinity,
      color: Colors.red.shade600,
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          profileButton(context),
          SizedBox(
            height: 26,
          ),
          searchButton(context),
          SizedBox(
            height: 26,
          ),
          sendFeedbackButton(context),
          SizedBox(
            height: 26,
          ),
          logoutButton(context),
        ],
      ),
    ),
  );
}

///////////////////////////////////////////////////////////////////////
///////////////////////Drawer Widgets///////////////////////////////////////
///////////////////////////////////////////////////////////////////////

Widget profileButton(context) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => profile()));
    },
    child: Row(
      children: [
        Icon(
          Icons.person,
          color: Colors.white,
          size: 30,
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 19),
        )
      ],
    ),
  );
}

Widget searchButton(context) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => home()));

    },
    child: Row(
      children: [
        Icon(
          Icons.search,
          color: Colors.white,
          size: 30,
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          'Search',
          style: TextStyle(color: Colors.white, fontSize: 19),
        )
      ],
    ),
  );
}

Widget sendFeedbackButton(context) {
  return GestureDetector(
    onTap: () {
      openGmail();
    },
    child: Row(
      children: [
        Icon(
          Icons.feedback,
          color: Colors.white,
          size: 30,
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          'Send Feedback',
          style: TextStyle(color: Colors.white, fontSize: 19),
        )
      ],
    ),
  );
}
Future<void> openGmail()async{

  const uri ='mailto:motorcycleparkingsg@gmail.com';
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    throw 'Could not launch $uri';
  }

}


Widget logoutButton(context) {
  return GestureDetector (
    onTap: () {
      print("gg");

      ShareUserData.saveData("");
      Navigator.of(context).pop();

                    Navigator.of(context)
                       .push(MaterialPageRoute(builder: (context) => Login()));    },
    child: Row(
      children: [
        Icon(
          Icons.logout,
          color: Colors.white,
          size: 30,
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          'Logout',
          style: TextStyle(color: Colors.white, fontSize: 19),
        )
      ],
    ),
  );
}
