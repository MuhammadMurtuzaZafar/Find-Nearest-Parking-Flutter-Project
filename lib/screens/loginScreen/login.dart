import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sg_motorcycle_parking/SharedPreferences/SharedUserData.dart';
import 'package:sg_motorcycle_parking/screens/forgotPassword/forgot_password.dart';
import 'package:sg_motorcycle_parking/screens/homeScreen/home.dart';
import 'package:sg_motorcycle_parking/screens/signupScreen/signup.dart';
import 'package:http/http.dart' as http;
import 'LoginService.dart';
import 'LoginModel.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isVisible = false;

  final emailText = TextEditingController();
  final passwordText = TextEditingController();

  //MARK:API Call

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
                topText(),
                SizedBox(
                  height: 30,
                ),
                emailField(),
                SizedBox(
                  height: 20,
                ),
                passwordField(),
                SizedBox(
                  height: 10,
                ),
                forgotPassword(),
                SizedBox(
                  height: 30,
                ),
                signinButton(),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Doesn\'t have an account?',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 5,
                ),
                registerHereButton()
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
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        'SG',
        style: TextStyle(
            color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Motorcycle ',
            style: TextStyle(
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Text(
            ' Parking',
            style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ]);
  }

  Widget emailField() {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        child: TextField(
          controller: emailText,
          style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 3),
              hintText: 'Email Address',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ));
  }

  Widget passwordField() {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        child: TextField(
          controller: passwordText,
          obscureText: isVisible ? false : true,
          style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
          decoration: InputDecoration(
              suffixIconConstraints: BoxConstraints(maxWidth: 20),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                child: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  size: 18,
                ),
              ),
              contentPadding: EdgeInsets.only(left: 3),
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ));
  }

  Widget forgotPassword() {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ForgotPassword()));
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Forgot password?',
              style:
                  TextStyle(fontSize: 12, decoration: TextDecoration.underline),
            ),
          ),
        ));
  }

  Widget signinButton() {
    return SizedBox(
      height: 40,
      width: 110,
      child: MaterialButton(
        onPressed: () {
            print(emailText.text);
            if(emailText.text.isEmpty)
            {
              toast("Enter Email First");
              return;
            }
            if(passwordText.text.isEmpty)
            {
              toast("Enter Email First");
              return;
            }
            if(passwordText.text.length<6){
              toast("Enter 6 digit Password");
              return;
            }

            if(emailText.text!="" && passwordText.text!="") {
              _onLoading();

              var map = new Map<String, String>();
              map['email'] = '${emailText.text}';
              map['password'] = '${passwordText.text}';

              Service.Login(map).then((res) {

                setState(() {
                  if (res.condition==true)  {


                    toast("Login Success");

                     ShareUserData.saveData(res.jwtToken);

                   // toast("Login Success ${res.jwtToken}");

                    Navigator.pop(context);
                    Navigator.of(context).pop();

                    Navigator.of(context)
                       .push(MaterialPageRoute(builder: (context) => home()));


                  } else {
                    Navigator.pop(context);
                    toast("Email or Password is incorrect !");
                  }
                });
              });
            }
            else
              {

                toast("Fill All First");
              }
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => home()));
        },
        color: Colors.red.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        child: Text(
          'Sign in',
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
  Widget registerHereButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Signup()));
      },
      child: Text(
        'Register Here',
        style: TextStyle(
            fontSize: 13,
            color: Colors.red.shade600,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
