import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sg_motorcycle_parking/screens/forgotPassword/ForgotService.dart';
import 'package:sg_motorcycle_parking/screens/forgotPassword/linkSent/checkForgetOTP.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController emailEditController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            iconTheme: IconThemeData(color: Colors.black, size: 23),
          ),
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    topText(),
                    SizedBox(
                      height: 60,
                    ),
                    emailField(),
                    SizedBox(
                      height: 40,
                    ),
                    ResetPasswordButton(),
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

  Widget topText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Please Enter Your Registered Email',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'We Will send you A link to reset your password',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget emailField() {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        child: TextField(
          controller: emailEditController,
          style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 3),
              hintText: 'Email Address',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ));
  }

  Widget ResetPasswordButton() {
    return SizedBox(
      height: 40,
      width: 140,
      child: MaterialButton(
        onPressed: () {
         
          if(emailEditController.text.isEmpty)
          {
            toast("Enter Email First");
            return;
          }
            var map = new Map<String, String>();
            map['email'] = '${emailEditController.text}';
          _onLoading();
            ForgotService.forgotEmail(map).then((value) {
              Navigator.pop(context);
              if(value.condition==true)
              {

                toast("Email Sent");

                 Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => checkForgetOTP()));


              }
              else
              {
                toast("Enter a valid Email");

              }
            });
        },
        color: Colors.red.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        child: Text(
          'Reset Password',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
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
