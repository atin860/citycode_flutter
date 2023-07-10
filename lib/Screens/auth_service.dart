// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:city_code/Screens/customer_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            print("done");
            return const CustomerLogin();
          } else {
            print("lost");
            return const CustomerLogin();
          }
        });
  }

  signINwihgoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();
    var email = googleUser!.email.toString();
    print("email" + email.toString());
    //auth detail request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    //create new creadiatils
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    if (email != null) {
      print("donebhai");
    } else {
      print("eroor");
    }
    //once sign in return the usercreaditials
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signout() {
    FirebaseAuth.instance.signOut();
  }
}
