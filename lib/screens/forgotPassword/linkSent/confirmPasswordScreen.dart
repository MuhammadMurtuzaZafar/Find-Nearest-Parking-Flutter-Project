import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sg_motorcycle_parking/SharedPreferences/SharedUserData.dart';
import 'package:sg_motorcycle_parking/globalWidgets/drawer.dart';
import 'package:sg_motorcycle_parking/screens/loginScreen/login.dart';
import 'package:shimmer/shimmer.dart';

import '../ForgotService.dart';



class ConfirmPasswordScreen extends StatefulWidget {

  String? otp;
  ConfirmPasswordScreen(this.otp);

  @override
  _ConfirmPasswordScreenState createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {




  TextEditingController _newCon=new TextEditingController();
  TextEditingController _reNewCon=new TextEditingController();
  bool isReEnterNewPasswordVisible=false;
  bool isNewPasswordVisible=false;
  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();




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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            text(),
            SizedBox(
              height: 15,
            ),
            newPassword(),
            SizedBox(
              height: 15,
            ),
            reEnterNewPasswordField(),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 20,
            ),
            confirmButton()
          ],
        ),
      ),
    );
  }
  /////////////////////////////////////////////////////////////////////////
  //////////////////////////////Widgets////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////



  Widget text() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        'Enter A New Password',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }




  Widget newPassword() {
    return TextField(
      controller: _newCon,
      obscureText: isNewPasswordVisible ? false : true,

      style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Enter new password',
        labelStyle: TextStyle(color: Colors.grey.shade800, fontSize: 13),
        suffixIconConstraints: BoxConstraints(maxWidth: 20),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isNewPasswordVisible = !isNewPasswordVisible;
            });
          },
          child: Icon(
            isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
            size: 18,
          ),
        ),
        contentPadding: EdgeInsets.only(left: 3),
      ),
    );
  }

  Widget reEnterNewPasswordField() {
    return TextField(
      controller: _reNewCon,
      obscureText: isReEnterNewPasswordVisible ? false : true,

      style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Re-enter new password',
        labelStyle: TextStyle(color: Colors.grey.shade800, fontSize: 13),
        suffixIconConstraints: BoxConstraints(maxWidth: 20),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isReEnterNewPasswordVisible = !isReEnterNewPasswordVisible;
            });
          },
          child: Icon(
            isReEnterNewPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            size: 18,
          ),
        ),
        contentPadding: EdgeInsets.only(left: 3),
      ),
    );
  }

  Widget confirmButton() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 40,
        width: 110,
        child: MaterialButton(
          onPressed: () {

            if(_newCon.text.isEmpty)
            {
              toast("Enter a New Password First");
              return;
            }
            if(_reNewCon.text.isEmpty)
            {
              toast("ReEnter a Password First");
              return;
            }
            if(_newCon.text!=_reNewCon.text)
            {
              toast("Password Not match");
              return;
            }
            if(_newCon.text.length<5)
            {
              toast("Enter 6 digit password");
              return;
            }

            var body = new Map<String, String>();
            body['newPassword'] = "${_newCon.text.trim()}";
            body['confirmPassword'] = "${_reNewCon.text.trim()}";
            body['otp'] = "${widget.otp}";

            _onLoading();

            ForgotService.resetPassword(body).then((value) {
              Navigator.pop(context);
              if(value.condition==true)
              {
                toast("Password Change Successfully");
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Login()));

              }
              else
                {
                  toast("Something wrong, Try Again!");

                }

            });
       
       
          },
          color: Colors.red.shade600,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
          child: Text(
            'Confirm',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
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
