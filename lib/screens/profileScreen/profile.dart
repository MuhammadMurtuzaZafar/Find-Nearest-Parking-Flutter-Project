import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sg_motorcycle_parking/SharedPreferences/SharedUserData.dart';
import 'package:sg_motorcycle_parking/globalWidgets/drawer.dart';
import 'package:shimmer/shimmer.dart';

import 'ProfileService.dart';
import 'ProfileModel.dart';

class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFile;
  bool isPasswordChanging = false;
  bool isOldPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isReEnterNewPasswordVisible = false;


  TextEditingController _oldCon=new TextEditingController();
  TextEditingController _newCon=new TextEditingController();
  TextEditingController _reNewCon=new TextEditingController();
  bool _loading=true;
   User? user;
  var header = new Map<String, String>();

  String imageUrl="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     header = new Map<String, String>();
     ShareUserData.fetchData().then((v)
     {
     print("${v}");
      header['Authorization'] =   "${v}";
       ProfileService.fetchData(header).then((value) {

      if(value.condition==true)
      {
        user=value.user;
        setState(() {
          _loading=false;
        });
      }
      else
        {
          toast("Check Your Internet Connection Try Again");
        }


    });


   ProfileService.fetchProfileImage(header).then((value) {

      if(value.condition==true)
      {
      //  toast(value.profileImage);

        setState(() {
          imageUrl=value.profileImage;
        });
        
      }
      else
        {
          toast("Error on Image upload");
        }


    });

     });
   

   
    
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
      drawer: drawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.red.shade600),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                profilePicCircle(),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      name(),
                      SizedBox(
                        height: 15,
                      ),
                      emailAddress(),
                      SizedBox(
                        height: 15,
                      ),
                      changePassword(),
                    ],
                  ),
                )
              ],
            ),
          ),
          !isPasswordChanging
              ? SizedBox()
              : Center(
            child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 340,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffc4c4c4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Text(
                          'Change Password',
                          style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordChanging = false;
                            });
                          },
                          child: Container(
                              height: 20,
                              width: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.grey.shade600,
                                size: 13,
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    oldPasswordField(),
                    SizedBox(
                      height: 10,
                    ),
                    newPassword(),
                    SizedBox(
                      height: 10,
                    ),
                    reEnterNewPasswordField(),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    confirmButton(),
                  ],
                )),
          )
        ],
      ),
    );
  }
  /////////////////////////////////////////////////////////////////////////
  //////////////////////////////Widgets////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////



  void getImageFromGallery() async {
    var image = await _imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      
      _imageFile = File(image!.path);

    
    if(_imageFile!=null){
             var body = Map<String, dynamic>();
    
            _onLoading();

            ProfileService.changeProfile(header,_imageFile!).then((value) {
              if(value.condition==true)
              {
               
               Navigator.pop(context);
                toast("Profile Changed Successfully");
              }
              else
                {
               Navigator.pop(context);

                  toast("Try again!");

                }
            });
       
       
    }

      
    });
  }

  Widget profilePicCircle() {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        children: [
          Container(
            height: 90,
            width: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                image: _imageFile != null ?
                 DecorationImage(
                    fit: BoxFit.cover, image: FileImage(_imageFile!))
                    : 
                    imageUrl!=""?
                    DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(imageUrl))
                    :
                    null),
            child: _imageFile != null || imageUrl!=""
                ? SizedBox()
                : Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 60,
                  ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                getImageFromGallery();
              },
              child: Container(
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                    color: Colors.red.shade600, shape: BoxShape.circle),
                child: Icon(Icons.edit, size: 15, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget name() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name',
            style: TextStyle(color: Colors.red.shade600, fontSize: 15),
          ),
          _loading?
              Shimmer.fromColors(
                  child: Container(
                    width: double.infinity,
                    height: 15,
                    color: Colors.red,
                  ),
                  baseColor: Colors.grey.shade400,
                  highlightColor: Colors.grey.shade200,)
              :
          Text(
            "${user!.name}",
            style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 19,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget emailAddress() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: TextStyle(color: Colors.red.shade600, fontSize: 15),
          ),
          _loading?
          Shimmer.fromColors(
            child: Container(
              width: double.infinity,
              height: 15,
              color: Colors.red,
            ),
            baseColor: Colors.grey.shade400,
            highlightColor: Colors.grey.shade200,)
              :
          Text(
            '${user!.email}',
            style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 19,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget changePassword() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Change Password',
            style: TextStyle(color: Colors.red.shade600, fontSize: 15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _loading?
              Shimmer.fromColors(
                child: Container(
                  width: 100,
                  height: 15,
                  color: Colors.red,
                ),
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.grey.shade200,)
                  :
              Text(
                '********',
                style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isPasswordChanging = true;
                  });
                },
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.red.shade600,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget oldPasswordField() {
    return TextField(
      controller: _oldCon,
      obscureText: isOldPasswordVisible ? false : true,
      style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Enter old password',
        labelStyle: TextStyle(color: Colors.grey.shade800, fontSize: 13),
        suffixIconConstraints: BoxConstraints(maxWidth: 20),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isOldPasswordVisible = !isOldPasswordVisible;
            });
          },
          child: Icon(
            isOldPasswordVisible ? Icons.visibility : Icons.visibility_off,
            size: 18,
          ),
        ),
        contentPadding: EdgeInsets.only(left: 3),
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
            if(_oldCon.text.isEmpty)
            {
              toast("Enter a old Password First");
              return;
            }
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
            body['oldPassword'] = "${_oldCon.text.trim()}";
            body['newPassword'] = "${_newCon.text.trim()}";

            print("asdddddddd ${body}");
            _onLoading();

            ProfileService.changePasword(header,body).then((value) {
              Navigator.pop(context);
              if(value.condition==true)
              {
                setState((){
                  isPasswordChanging=false;
                });
                toast("Password Changed Successfully");
              }
              else
                {
                  toast("Try again!");

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
