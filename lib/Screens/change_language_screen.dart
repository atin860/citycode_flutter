// ignore_for_file: must_be_immutable

import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/Screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class ChangeLanguage extends StatefulWidget {
  bool isHome;

  ChangeLanguage(this.isHome, {Key? key}) : super(key: key);

  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF2CC0F),
        title: const Text(
          "Change The Language",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  _prefs.setString("language", "ar");
                  Constants.language = "ar";
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("lang", "ar");
                  Constants.lang = "ar";
                  if (widget.isHome) {
                    Route newRoute = MaterialPageRoute(
                        builder: (context) => Constants.notification_id.isEmpty
                            ? HomeScreen("0", "")
                            : HomeScreen("1", ""));
                    Navigator.pushAndRemoveUntil(
                        context, newRoute, (route) => false);
                  } else {
                    Route newRoute = MaterialPageRoute(
                        builder: (context) => const WelcomeScreen());
                    Navigator.push(context, newRoute);
                  }
                },
                child: const Text(
                  "العربية",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "GSSFont",
                      fontSize: 18.0),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: InkWell(
                  onTap: () async {
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    _prefs.setString("language", "en");
                    Constants.language = "en";
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("lang", "en");
                    Constants.lang = "en";
                    if (widget.isHome) {
                      Route newRoute = MaterialPageRoute(
                          builder: (context) =>
                              Constants.notification_id.isEmpty
                                  ? HomeScreen("0", "")
                                  : HomeScreen("1", ""));
                      Navigator.pushAndRemoveUntil(
                          context, newRoute, (route) => false);
                    } else {
                      Route newRoute = MaterialPageRoute(
                          builder: (context) => const WelcomeScreen());
                      Navigator.push(context, newRoute);
                    }
                  },
                  child: const Text(
                    "English",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
