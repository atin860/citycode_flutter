// ignore_for_file: prefer_final_fields, non_constant_identifier_names, avoid_print, unnecessary_string_escapes

import 'dart:convert';

import 'package:city_code/Screens/change_language_screen.dart';
import 'package:city_code/Screens/change_location.dart';
import 'package:city_code/Screens/confirmation_screen.dart';
import 'package:city_code/Screens/interest_screen.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../models/otp_model.dart';
import 'home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<String> settingsList = [
    Constants.language == "en" ? "Change mobile number" : "تغيير رقم الجوال",
    Constants.language == "en" ? "Change the language" : "تغيير اللغة",
    Constants.language == "en" ? "Change location" : "تغيير الموقع",
    Constants.language == "en" ? "Set interests" : "حدد الاهتمامات",
    Constants.language == "en" ? "Delete account" : "حذف الحساب",
  ];

  bool _isLoading = false, isChangeNumber = false, isDeleteAccount = false;

  TextEditingController _MobileNoController = TextEditingController();
  late String version = "";

  Future<void> _getNewOtp() async {
    final body = {
      "mobileno": _MobileNoController.text,
      "customer": "customer",
      "user_id": Constants.user_id,
      "language": Constants.language
    };

    final response = await http.post(
      Uri.parse('http://185.188.127.11/public/index.php/ApiUsers/newgetotp'),
      body: body,
    );

    var response_server = jsonDecode(response.body);

    if (kDebugMode) {
      print(response_server);
    }

    if (response.statusCode == 201) {
      if (response_server["status"] == 201) {
        setState(() {
          _isLoading = true;
        });
        Route route = MaterialPageRoute(
            builder: (context) => ConfirmationScreen(
                _MobileNoController.text, "Change Mobile Number", "", true));
        Navigator.push(context, route);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Otp_model> _getOtp() async {
    final response = await http.get(Uri.parse(
        'http://185.188.127.11/public/index.php/apigetotp?mobileno=' +
            Constants.mobile_no +
            '&customer=customer'));
    if (response.statusCode == 201) {
      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }
      if (response_server["status"] == 201) {
        setState(() {
          _isLoading = false;
        });
        String otp = response_server["optno"];
        print("OTP:- $otp");
        Route route = MaterialPageRoute(
            builder: (context) => ConfirmationScreen(
                Constants.mobile_no, "Delete Account", otp, true));
        Navigator.push(context, route);
        return Otp_model.fromJson(jsonDecode(response.body));
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load album');
    }
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    if (isChangeNumber || isDeleteAccount) {
      setState(() {
        isChangeNumber = false;
        isDeleteAccount = false;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    _getVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor:
            isDeleteAccount ? const Color(0xFFF2CC0F) : Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFFF2CC0F),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.arrow_left),
            color: Colors.black,
            onPressed: () {
              if (isChangeNumber || isDeleteAccount) {
                setState(() {
                  isChangeNumber = false;
                  isDeleteAccount = false;
                });
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            isChangeNumber
                ? Constants.language == "en"
                    ? "Change Mobile Number"
                    : "تغيير رقم الجوال"
                : isDeleteAccount
                    ? Constants.language == "en"
                        ? "Delete Account"
                        : "حذف الحساب"
                    : Constants.language == "en"
                        ? "Settings"
                        : "إعدادات",
            style: TextStyle(
              fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => HomeScreen("0", ""),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(CupertinoIcons.home),
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Directionality(
                textDirection: Constants.language == "en"
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: isDeleteAccount
                    ? deleteAccountWidget(context, width, height)
                    : isChangeNumber
                        ? chengeNumberWidget(context, width, height)
                        : settingsScreen(context, width, height),
              ),
              Visibility(
                visible: _isLoading,
                child: Center(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10.0),
                    child: const CircularProgressIndicator(
                      color: Color(0xFFF2CC0F),
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

  Future<void> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  Widget settingsScreen(BuildContext context, double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: const Image(
            image: AssetImage("images/setting.png"),
          ),
          margin: const EdgeInsets.only(top: 20.0),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10.0),
          alignment: Alignment.center,
          child: Text(
            Constants.language == "en" ? "Settings" : "إعدادات",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 20.0),
            itemCount: settingsList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: InkWell(
                      onTap: () {
                        if (settingsList[index] == "Change mobile number" ||
                            settingsList[index] == "تغيير رقم الجوال") {
                          setState(() {
                            isChangeNumber = true;
                          });
                        } else if (settingsList[index] ==
                                "Change the language" ||
                            settingsList[index] == "تغيير اللغة") {
                          Route route = MaterialPageRoute(
                              builder: (context) => ChangeLanguage(true));
                          Navigator.push(context, route);
                        } else if (settingsList[index] == "Change location" ||
                            settingsList[index] == "تغيير الموقع") {
                          Route route = MaterialPageRoute(
                              builder: (context) => ChangeLocation(true));
                          Navigator.push(context, route);
                        } else if (settingsList[index] == "Set interests" ||
                            settingsList[index] == "حدد الاهتمامات") {
                          Route route = MaterialPageRoute(
                              builder: (context) =>
                                  InterestScreen("settings", ""));
                          Navigator.push(context, route);
                        } else if (settingsList[index] == "Delete account" ||
                            settingsList[index] == "حذف الحساب") {
                          setState(() {
                            isDeleteAccount = true;
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            settingsList[index],
                            style: TextStyle(
                              color: settingsList[index] == "Delete account" ||
                                      settingsList[index] == "حذف الحساب"
                                  ? Colors.red
                                  : Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontSize: 16.0,
                            ),
                          ),
                          const Icon(
                            CupertinoIcons.right_chevron,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: settingsList[index] == "Delete account" ||
                            settingsList[index] == "حذف الحساب"
                        ? true
                        : false,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 1.0,
                color: Colors.black,
              );
            },
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: Text(
              "Version: " + version,
              //     "Version: 2.9.3 ",
              style: const TextStyle(color: Color(0xFFFFAE00), fontSize: 20.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget chengeNumberWidget(BuildContext context, double width, double height) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                TextField(
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 14.0,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                  controller: _MobileNoController,
                  textDirection: Constants.language == "en"
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Constants.language == "en"
                        ? "Enter new mobile number"
                        : "أدخل رقم الهاتف المحمول الجديد",
                    hintStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 14.0,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont"),
                    isDense: true,
                  ),
                  textAlign: Constants.language == "en"
                      ? TextAlign.left
                      : TextAlign.right,
                ),
                Container(
                  width: width,
                  height: 1.0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                if (_MobileNoController.text.isNotEmpty) {
                  if (_MobileNoController.text.length == 8) {
                    _getNewOtp();
                  } else {
                    _alertDialog(Constants.language == "en"
                        ? "Please enter valid mobile number"
                        : "الرجاء إدخال رقم هاتف محمول صحيح");
                  }
                } else {
                  _alertDialog(Constants.language == "en"
                      ? "Please enter mobile number"
                      : "الرجاء إدخال رقم الهاتف المحمول");
                }
              },
              child: Text(
                Constants.language == "en" ? "Submit" : "إرسال",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontSize: 18.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2CC0F),
                elevation: 0.0,
                textStyle: const TextStyle(color: Colors.black),
                fixedSize: Size(MediaQuery.of(context).size.width, 30.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget deleteAccountWidget(
      BuildContext context, double width, double height) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Constants.language == "en"
                ? "Are you sure you want to delete the account?"
                : "هل أنت متأكد أنك تريد \ حذف الحساب؟",
            style: TextStyle(
                color: Colors.black,
                fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                fontWeight: FontWeight.bold,
                fontSize: 22.0),
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              onPressed: () {
                _getOtp();
              },
              child: Text(
                Constants.language == "en" ? "Yes" : "نعم",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontSize: 18.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2CC0F),
                elevation: 0.0,
                padding: const EdgeInsets.only(
                    left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isDeleteAccount = false;
                });
              },
              child: Text(
                Constants.language == "en" ? "No" : "لا",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontSize: 18.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2CC0F),
                elevation: 0.0,
                padding: const EdgeInsets.only(
                    left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _alertDialog(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
