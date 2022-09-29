import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sg_motorcycle_parking/screens/forgotPassword/ForgotService.dart';
import 'package:sg_motorcycle_parking/screens/loginScreen/login.dart';

import 'confirmPasswordScreen.dart';

class checkForgetOTP extends StatefulWidget {
  @override
  State<checkForgetOTP> createState() => _checkForgetOTPState();
}

class _checkForgetOTPState extends State<checkForgetOTP> {

  TextEditingController otpController=new TextEditingController();
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
                checkOtp(),

                SizedBox(
                  height: 60,
                ),
                checkOtpButton(),
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
        'Check Your Email Enter OTP Here',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget checkOtpButton() {
    return SizedBox(
      height: 40,
      width: 140,
      child: MaterialButton(
        onPressed: () {

          if(otpController.text.isEmpty)
          {
            toast("Enter a OTP First");

            return;
          }


          _onLoading();

          ForgotService.checkForgetPasswordOtp(otpController.text).then((value)
          {
            Navigator.pop(context);
            if(value.condition==true)
            {
              Navigator.of(context)
                 .push(MaterialPageRoute(builder: (context) => ConfirmPasswordScreen(otpController.text)));
            }
            else
              {
                toast("OTP Not Matched");

              }

          });


          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => Login()));
        },
        color: Colors.red.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        child: Text(
          'Check',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget checkOtp() {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        child: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 3),
              hintText: 'Enter OTP',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ));
  }

  toast(msg)
  {
    Fluttertoast.showToast(
        msg: "${msg}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new SizedBox(width: 10,),
                new Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
