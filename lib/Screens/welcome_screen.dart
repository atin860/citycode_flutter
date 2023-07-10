// ignore_for_file: unused_local_variable

import 'package:city_code/Screens/company_login_screen.dart';
import 'package:city_code/Screens/customer_login_screen.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late String language = "en";

  _getLanguage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      language = _prefs.getString("language") ?? "en";
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    _getLanguage();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2CC0F),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: const Color(0xFFF2CC0F),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Image(image: AssetImage("images/app_icon.png")),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: language == "en"
                    ? const Text(
                        "Welcome to the CityCode Family",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 18.0,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Text(
                        "مرحبا بك في عائلة ستي كود",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 18.0,
                          fontFamily: "GSSFont",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              language == "en"
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => const CustomerLogin());
                              Navigator.push(context, route);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              width: width * 0.65,
                              height: 50.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0, top: 10.0, bottom: 10.0),
                                    child: const Image(
                                      image: AssetImage("images/user.png"),
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.45,
                                    margin: const EdgeInsets.only(
                                        right: 10.0, top: 10.0, bottom: 10.0),
                                    child: const Text(
                                      "Entry of persons",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto",
                                          fontSize: 18.0),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => const CompanyLogin());
                              Navigator.push(context, route);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              width: width * 0.65,
                              height: 50.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0, top: 10.0, bottom: 10.0),
                                    child: const Image(
                                      image: AssetImage("images/ic_home.png"),
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.45,
                                    margin: const EdgeInsets.only(
                                        right: 10.0, top: 10.0, bottom: 10.0),
                                    child: const Text(
                                      "Entering Company",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto",
                                        fontSize: 18.0,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => const CustomerLogin());
                              Navigator.push(context, route);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              width: width * 0.65,
                              height: 50.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width * 0.45,
                                    margin: const EdgeInsets.only(
                                        left: 20.0, top: 10.0, bottom: 10.0),
                                    child: const Text(
                                      "دخول الأشخاص",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "GSSFont",
                                          fontSize: 18.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 20.0, top: 10.0, bottom: 10.0),
                                    child: const Image(
                                      image: AssetImage("images/user.png"),
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences _prefs =
                                  await SharedPreferences.getInstance();
                              _prefs.setString("language", "en");
                              Constants.language = "en";
                              Route route = MaterialPageRoute(
                                  builder: (context) => const CompanyLogin());
                              Navigator.push(context, route);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              width: width * 0.65,
                              height: 50.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width * 0.45,
                                    margin: const EdgeInsets.only(
                                        left: 20.0, top: 10.0, bottom: 10.0),
                                    child: const Text(
                                      "دخول الشركة",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "GSSFont",
                                          fontSize: 18.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 20.0, top: 10.0, bottom: 10.0),
                                    child: const Image(
                                      image: AssetImage("images/ic_home.png"),
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
