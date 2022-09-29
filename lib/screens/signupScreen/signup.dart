import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sg_motorcycle_parking/SharedPreferences/SharedUserData.dart';
import 'package:sg_motorcycle_parking/screens/homeScreen/home.dart';
import 'package:sg_motorcycle_parking/screens/loginScreen/login.dart';
import 'Service.dart';
import 'SignUpModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isVisible = false;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    name.dispose();
    email.dispose();
    password.dispose();
  }
  bool load=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
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
                nameField(name),
                SizedBox(
                  height: 20,
                ),
                emailField(email),
                SizedBox(
                  height: 20,
                ),
                createPasswordField(password),
                SizedBox(
                  height: 30,
                ),
                registerAccountButton(name, email, password),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 5,
                ),
                loginHere()

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
      child: Text(
        'Please Enter Your Info To Register',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget nameField(name) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        child: TextField(
          controller: name,
          style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 3),
              hintText: 'Name',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ));
  }

  Widget emailField(email) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        child: TextField(
          controller: email,
          style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 3),
              hintText: 'Email Address',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ));
  }

  Widget createPasswordField(password) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        child: TextField(
          controller: password,
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
              hintText: 'Create Password',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ));
  }

  Widget registerAccountButton(TextEditingController name,TextEditingController email,TextEditingController password) {
    return SizedBox(
      height: 40,
      width: 140,
      child: MaterialButton(
        onPressed: () {


          if(name.text.isEmpty)
          {
            toast("Fill Name");
            return;
          }

          if(email.text.isEmpty)
          {
            toast("Fill Email");
            return;
          }

          if(password.text.isEmpty)
          {
            toast("Fill Password first");
            return;
          }

          if(password.text.length<6)
          {
            toast("Password must be grete then 5");
            return;
          }


          if(name.text !="" && email.text != "" && password.text!="")
          {
            _onLoading();

            var map = new Map<String, String>();
            map['name'] = "${name.text}";
            map['email'] = "${email.text}";
            map['password'] = "${password.text}";

            Service.SignUp(map).then((res) {
              SigunModel s=res;
              print("kjkj ${res.jwtToken}");
              setState(() {
                if (s.condition==true) {

                  load=false;
                   ShareUserData.saveData(res.jwtToken);
                  Navigator.pop(context);
                  //Navigator.pop(context);
                  Navigator.of(context).pop();
                  Navigator.of(context)
                     .push(MaterialPageRoute(builder: (context) => home()));
                  toast("Registered Successfully");
                } else {

                  load=false;
                  Navigator.pop(context);
                  toast("Try Again Another Email");
                }
              });
            });
          }
          else
            {
              toast("Please Fill All First");
            }

          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => home()));
        },
        color: Colors.red.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        child: Text(
          'Register Account',
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
  Widget loginHere() {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Login()));
      },
      child: Text(
        'Login Here',
        style: TextStyle(
            fontSize: 13,
            color: Colors.red.shade600,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
