// ignore_for_file: unused_import, camel_case_types, unused_field, unused_local_variable, avoid_print, unnecessary_null_comparison

import 'package:city_code/Screens/auth_service.dart';
import 'package:city_code/Screens/customer_login_screen.dart';
import 'package:city_code/Screens/customer_registration.dart';
import 'package:city_code/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class socialregistration extends StatefulWidget {
  const socialregistration({Key? key}) : super(key: key);

  @override
  State<socialregistration> createState() => _socialregistrationState();
}

class _socialregistrationState extends State<socialregistration> {
  final googleSignIn = GoogleSignIn();
  // final authResult =  TwitterLogin();
  GoogleSignInAccount? _user;

  Future googleLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    final googleUser = await googleSignIn.signIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      user = userCredential.user!;
      String name = userCredential.user!.displayName.toString();
      String email = userCredential.user!.email.toString();
      String uid = userCredential.user!.uid.toString();
      String phone = userCredential.user!.phoneNumber.toString();

      print("user:::::::" + user.toString());
      print("displayemail:::: " + email);
      print("displayname:::: " + name);
      print("uid:::: " + uid);
      // print("token:::"+token!);
      print("phone::" + phone);

      if (user != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CustomerLogin()));
        /* setState(() {
          isLoading = true;
        });
        FirebaseMessaging.instance.getToken().then((value) {
          setState(() {
            token = value;
            callsocial(token!,name,email,uid);
          });
        });*/
      }
    } catch (e) {
      print(e);
    }
    /*   GoogleAuthProvider googleProvider = GoogleAuthProvider();
     return await FirebaseAuth.instance.signInWithPopup(googleProvider).then((value) {
       print("value:::"+value.user.toString());
     });*/

    await FirebaseAuth.instance.signInWithCredential(credential);
/*    notifyListeners();*/
  }

  @override
  Widget build(BuildContext context) {
    double loginWidth = 40.0;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF2CC0F),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF2CC0F),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          Constants.language == "en" ? "New Registration" : "تقرير القسيمة",
          style: TextStyle(
            color: Colors.black,
            fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
          ),
        ),
        actions: const <Widget>[
          /*   IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => HomeScreen("0"),
                ),
                    (route) => false,
              );
            },
            icon: Icon(CupertinoIcons.home),
            color: Colors.black,
          )*/
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.1,
          ),
          const Hero(
            tag: "next",
            child: Image(
              image: AssetImage("images/app_icon.png"),
            ),
          ),
          /* SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Constants.language == "en"
              ? const Text(
            "City Code",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "Roboto"),
          )
              : const Text(
            "تسجيل الدخول للأفراد",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "GSSFont"),
          ),*/
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: MaterialButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  elevation: 3,
                  minWidth: 30,
                  height: 40,
                  onPressed: () {
                    //Here goes the logic for Google SignIn discussed in the next section
                  },
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Image(
                        width: 45,
                        image: AssetImage("images/Facebook.png"),
                      ),
                      SizedBox(width: 50),
                      Text('Sign-in using Facebook',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: MaterialButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  elevation: 3,
                  minWidth: 30,
                  height: 40,
                  onPressed: () {
                    //Here goes the logic for Google SignIn discussed in the next section
                  },
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Image(
                        width: 45,
                        image: AssetImage("images/Googleimage.png"),
                      ),
                      SizedBox(width: 50),
                      Text('Sign-in using Google',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: MaterialButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  elevation: 3,
                  minWidth: 30,
                  height: 40,
                  onPressed: () {
                    //Here goes the logic for Google SignIn discussed in the next section
                  },
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Image(
                        width: 45,
                        image: AssetImage("images/Twitter.png"),
                      ),
                      SizedBox(width: 50),
                      Text('Sign-in using Twitter',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: MaterialButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  elevation: 3,
                  minWidth: 30,
                  height: 40,
                  onPressed: () {
                    //Here goes the logic for Google SignIn discussed in the next section
                  },
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Image(
                        width: 45,
                        image: AssetImage("images/instaphoto.png"),
                      ),
                      SizedBox(width: 50),
                      Text('Sign-in using Instagram',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.bounceOut,
                  child: MaterialButton(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    elevation: 3,
                    minWidth: 30,
                    height: 40,
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (context) => CustomerRegistration(
                                mobileNo: "",
                              ));
                      Navigator.pushReplacement(context, route);
                    },
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        SizedBox(width: 10),
                        Text('New Registaion',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    textColor: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
