// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/Screens/interest_screen.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class ShowDataScreen extends StatefulWidget {
  const ShowDataScreen({Key? key}) : super(key: key);

  @override
  _ShowDataScreenState createState() => _ShowDataScreenState();
}

class _ShowDataScreenState extends State<ShowDataScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF2CC0F),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Constants.language == "en"
                    ? "Successfully Registered"
                    : "تم التسجيل بنجاح",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.only(top: 40.0),
                child: Text(
                  Constants.language == "en"
                      ? "Your membership code"
                      : "رمز عضويتك",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40.0),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10.0, right: 12.0),
                      child: Container(
                        width: 100,
                        height: 40,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0)),
                        ),
                        child: Center(
                            child: Text(
                          Constants.city_code,
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        width: 25,
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2CC0F),
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.star,
                            color: Colors.black,
                            size: 19.0,
                          ),
                        ),
                      ),
                      bottom: 24.0,
                      left: 87.0,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Text(
                  Constants.language == "en"
                      ? "It is your code for every purchase"
                      : "رمز عضويتك هو رمزك لكل عملية شراء",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (Constants.interest.isNotEmpty) {
                      if (Constants.chat_data.isNotEmpty) {
                        var data = jsonDecode(Constants.chat_data);
                        Route route = MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                data["company_name"],
                                data["company_image_base_url"] +
                                    data["company_logo"],
                                data["receiver_id"],
                                data["sender_id"],
                                "",
                                "",
                                "user",
                                "",
                                "1",
                                "0"));
                        Navigator.pushReplacement(context, route);
                      } else if (Constants.notification_id.isNotEmpty) {
                        Route route = MaterialPageRoute(
                            builder: (context) => HomeScreen("1", ""));
                        Navigator.pushReplacement(context, route);
                      } else {
                        Route route = MaterialPageRoute(
                            builder: (context) => HomeScreen("0", ""));
                        Navigator.pushReplacement(context, route);
                      }
                    } else {
                      Route route = MaterialPageRoute(
                          builder: (context) =>
                              InterestScreen("show_data", ""));
                      Navigator.pushReplacement(context, route);
                    }
                  },
                  child: Text(
                    Constants.language == "en" ? "Continue" : "أستمرار",
                    style: TextStyle(
                      color: const Color(0xFFF2CC0F),
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                      fontSize: 18.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 0.0,
                    fixedSize: Size(MediaQuery.of(context).size.width, 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
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
