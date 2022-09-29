import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sg_motorcycle_parking/screens/loginScreen/login.dart';

class LinkSent extends StatefulWidget {
  @override
  State<LinkSent> createState() => _LinkSentState();
}

class _LinkSentState extends State<LinkSent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                text(),
                SizedBox(
                  height: 60,
                ),
                backToLoginButton(),
              ],
            ),
          ),
        ),
      )),
    );
  }

  /////////////////////////////////////////////////////////////////////////
  //////////////////////////////Widgets////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////

  Widget text() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        'An Email with the password reset link has been sent yo your email.',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget backToLoginButton() {
    return SizedBox(
      height: 40,
      width: 140,
      child: MaterialButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Login()));
        },
        color: Colors.red.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        child: Text(
          'Back to Login',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
