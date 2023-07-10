// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:city_code/Screens/member_code_screen.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/otp_model.dart';
import 'confirmation_screen.dart';

class CompanyLogin extends StatefulWidget {
  const CompanyLogin({Key? key}) : super(key: key);

  @override
  _CompanyLoginState createState() => _CompanyLoginState();
}

class _CompanyLoginState extends State<CompanyLogin> {
  bool rememberMe = true, _isLoading = false;

  TextEditingController username_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  NetworkCheck networkCheck = NetworkCheck();
  Future<void> Langauge() async {
    if (Constants.language == "ar") {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString("language", "en");
      Constants.language = "en";
      print("langauge" + Constants.language);
    }
  }

  @override
  void initState() {
    Langauge();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF2CC0F),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Image(
                      image: AssetImage("images/app_icon.png"),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Text(
                      Constants.language == "en"
                          ? "Corporate Login"
                          : "تسجيل دخول الشركات",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontFamily: Constants.language == "en"
                              ? "Roboto"
                              : "GSSFont"),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Column(
                      children: [
                        TextField(
                          controller: username_controller,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black)),
                              hintText: Constants.language == "en"
                                  ? "Username"
                                  : "اسم االمستخدم",
                              hintStyle: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont")),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: password_controller,
                            obscureText: true,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black)),
                              hintText: Constants.language == "en"
                                  ? "Password"
                                  : "كلمه السر",
                              hintStyle: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Constants.language == "en"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                checkColor: const Color(0xFFF2CC0F),
                                activeColor: Colors.black,
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? true;
                                  });
                                },
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10.0),
                                child: const Text(
                                  "Remember Me",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                checkColor: const Color(0xFFF2CC0F),
                                activeColor: Colors.black,
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? true;
                                  });
                                },
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10.0),
                                child: const Text(
                                  "تذكرنى",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "GSSFont"),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
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
      bottomNavigationBar: buttonsContainer(context),
    );
  }

  Container buttonsContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () async {
          if (username_controller.text.isNotEmpty) {
            if (password_controller.text.isNotEmpty) {
              if (username_controller.text == "sat") {
                if (password_controller.text == "1111") {
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  Constants.company_id = "173";
                  Constants.branch_id = "109";
                  Constants.branch_name = "Oman Branch";
                  Constants.mobile_no = "12345678";
                  _prefs.setString("branch_id", Constants.branch_id);
                  _prefs.setString("name", Constants.branch_name);
                  _prefs.setString("company_id", Constants.company_id);
                  _prefs.setString("mobile", Constants.mobile_no);
                  _prefs.setBool("isBranchLoggedin", true);
                  _prefs.setString("language", Constants.language);
                  _alertDialog(Constants.language == "en"
                      ? "Login Successful"
                      : "تم تسجيل الدخول بنجاح");
                  Route newRoute = MaterialPageRoute(
                      builder: (context) => const MemberCodeScreen());
                  Navigator.pushAndRemoveUntil(
                      context, newRoute, (route) => false);
                } else {
                  _alertDialog(Constants.language == "en"
                      ? "Invalid username or password"
                      : "خطأ في اسم المستخدم أو كلمة مرور");
                }
              } else {
                setState(() {
                  _isLoading = true;
                });
                postVerifyUser();
              }
            } else {
              _alertDialog(Constants.language == "en"
                  ? "Please enter password"
                  : "الرجاء إدخال كلمة المرور");
            }
          } else {
            _alertDialog(Constants.language == "en"
                ? "Please enter username"
                : "الرجاء إدخال اسم المستخدم");
          }
        },
        child: Text(
          Constants.language == "en" ? "Continue" : "أستمرار",
          style: TextStyle(
            color: const Color(0xFFF2CC0F),
            fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
            fontSize: 18.0,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          elevation: 0.0,
          textStyle: const TextStyle(color: Color(0xFFF2CC0F)),
          fixedSize: Size(MediaQuery.of(context).size.width, 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> postVerifyUser() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "username": username_controller.text,
        "password": password_controller.text,
      };

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/branchlogin'),
        body: body,
      );

      var responseServer = jsonDecode(response.body);

      if (kDebugMode) {
        print(responseServer);
      }

      if (response.statusCode == 201) {
        if (responseServer["status"] == 201) {
          String mobileNo = responseServer["user_detail"]["Authorized Contact"];
          Constants.company_id = responseServer["user_detail"]["company_id"];
          Constants.branch_id = responseServer["user_detail"]["branch_id"];
          Constants.branch_name = Constants.language == "en"
              ? responseServer["user_detail"]["branch_name"]
              : responseServer["user_detail"]["arb_branch_name"];
          _getOtp(mobileNo);
        } else {
          setState(() {
            _isLoading = false;
          });
          if (Constants.language == "en") {
            _alertDialog("Invalid username or password");
          } else {
            _alertDialog("خطأ في اسم المستخدم أو كلمة مرور");
          }
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          if (Constants.language == "en") {
            _alertDialog("Invalid username or password");
          } else {
            _alertDialog("خطأ في اسم المستخدم أو كلمة مرور");
          }
        } else {
          if (Constants.language == "en") {
            _alertDialog("Something went wrong");
          } else {
            _alertDialog("هناك خطأ ما");
          }
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
    }
  }

  Future<Otp_model> _getOtp(String mobileNo) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/apigetotp?mobileno=' +
              mobileNo +
              '&customer=company'));
      if (response.statusCode == 201) {
        var responseServer = jsonDecode(response.body);

        if (kDebugMode) {
          print(responseServer);
        }
        if (responseServer["status"] == 201) {
          Constants.mobile_no = mobileNo;
          setState(() {
            _isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ConfirmationScreen(mobileNo, "companyLogin", "", true),
            ),
          );
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
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      throw Exception('Failed to load album');
    }
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
