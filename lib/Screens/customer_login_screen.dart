import 'dart:convert';
import 'dart:io';

import 'package:city_code/Screens/confirmation_screen.dart';
import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/models/user_data.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'customer_registration.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({Key? key}) : super(key: key);

  @override
  _CustomerLoginState createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  TextEditingController mobileNoController = TextEditingController();

  late String language = "en";
  String isSkipVisible = "0";
  NetworkCheck networkCheck = NetworkCheck();

  _getLanguage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      language = _prefs.getString("language") ?? "en";
    });
  }

  bool _isLoading = false;

  @override
  void initState() {
    if (Platform.isIOS) {
      getSkip();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    _getLanguage();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF2CC0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2CC0F),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Platform.isIOS
              ? isSkipVisible == "8"
                  ? TextButton(
                      //ISSKIPPIS CHANGED 3 TO 4
                      onPressed: () {
                        Constants.user_id = "238";
                        Route newRoute = MaterialPageRoute(
                            builder: (context) => HomeScreen("0", ""));
                        Navigator.pushAndRemoveUntil(
                            context, newRoute, (route) => false);
                      },
                      child: Text(
                        Constants.language == "en" ? "SKIP" : "",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                      ),
                    )
                  : Container()
              : Container(),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.10,
                    ),
                    const Image(
                      image: AssetImage("images/app_icon.png"),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    language == "en"
                        ? const Text(
                            "Log in for individuals",
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
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Column(
                      children: [
                        Container(
                          child: language == "en"
                              ? const Text(
                                  /*"Please enter your mobile number and  press continue to get  a word the one- time  secret",*/
                                  "Please enter your mobile number and press continue to get the one time password.",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 14.0,
                                      fontFamily: "Roboto"),
                                  textAlign: TextAlign.center,
                                )
                              : const Text(
                                  "الرجاء إدخال رقم الهاتف والضغط على تأكيد للحصول على كلمة المرور للمرة الواحدة ",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black45,
                                      fontFamily: "GSSFont"),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                        const Text(
                          "(OTP)",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black45,
                              fontFamily: "GSSFont"),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 40.0,
                          child: Text(
                            "+968",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                          child: Icon(
                            CupertinoIcons.chevron_down,
                            size: 16.0,
                            color: Colors.black45,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          width: 280.0,
                          child: TextField(
                            controller: mobileNoController,
                            keyboardType: TextInputType.phone,
                            maxLines: 1,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: Constants.language == "en"
                                  ? 'Enter Mobile Number'
                                  : "ادخل رقم الهاتف",
                              hintStyle: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont"),
                            ),
                            onChanged: (value) async {
                              final pref =
                                  await SharedPreferences.getInstance();

                              if (value.length == 8) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                pref.setString(
                                    'mblno', mobileNoController.text);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      height: 1.0,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    buttonsContainer(context, width, height)
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
    );
  }

  Container buttonsContainer(
      BuildContext context, double width, double height) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      height: MediaQuery.of(context).size.height * 0.18,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            width: width * 0.80,
            height: 50.0,
            child: ElevatedButton(
              onPressed: () {
                if (language == "en") {
                  if (mobileNoController.text.isNotEmpty) {
                    if (mobileNoController.text.length == 8) {
                      setState(() {
                        _isLoading = true;
                      });
                      getUserData(mobileNoController.text, "customer", context);
                    } else {
                      _alertDialog("Invalid mobile number!", context);
                    }
                  } else {
                    _alertDialog(
                        "Please enter 8 digit mobile number!", context);
                  }
                } else {
                  if (mobileNoController.text.isNotEmpty) {
                    if (mobileNoController.text.length == 8) {
                      setState(() {
                        _isLoading = true;
                      });
                      getUserData(mobileNoController.text, "customer", context);
                    } else {
                      _alertDialog("رقم الجوال غير صالح!", context);
                    }
                  } else {
                    _alertDialog("الرجاء إدخال رقم هاتف متحرك مكون من 8 أرقام!",
                        context);
                  }
                }
              },
              child: language == "en"
                  ? const Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Roboto",
                        fontSize: 18.0,
                      ),
                    )
                  : const Text(
                      "أستمرار",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "GSSFont",
                        fontSize: 18.0,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2CC0F),
                elevation: 0.0,
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
          Container(
            margin: EdgeInsets.only(top: height * 0.02),
            child: SizedBox(
              width: width * 0.80,
              height: 50,
              child: Hero(
                tag: "next",
                child: ElevatedButton(
                  onPressed: () {
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>socialregistration()));
                    Route route = MaterialPageRoute(
                        builder: (context) => CustomerRegistration(
                              mobileNo: mobileNoController.text,
                            ));
                    Navigator.pushReplacement(context, route);
                  },
                  child: language == "en"
                      ? const Text(
                          "New Registration",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto",
                            fontSize: 18.0,
                          ),
                        )
                      : const Text(
                          "تسجيل جديد",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "GSSFont",
                            fontSize: 18.0,
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2CC0F),
                    elevation: 0.0,
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
            ),
          ),
        ],
      ),
    );
  }

  void _alertDialog(String message, BuildContext context) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    ).then((value) {
      // Navigation logic after toast is shown
      String mobileNo = mobileNoController.text.trim();
      if (mobileNo.length == 8) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CustomerRegistration(mobileNo: mobileNoController.text),
          ),
        );
      }
    });
  }

  Future<UserData> getUserData(
      String mobileNo, String customer, BuildContext context) async {
    bool isConnected = await networkCheck.isNetworkConnected();

    if (isConnected) {
      final body = {"mobileno": mobileNo, "customer": customer};

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/ApiUsers/getmobdata'),
        body: body,
      );

      var responseServer = jsonDecode(response.body);

      if (kDebugMode) {
        print(responseServer);
      }

      // ...

      if (response.statusCode == 201) {
        if (responseServer["status"] == 201) {
          setState(() {
            _isLoading = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ConfirmationScreen(mobileNo, "customerLogin", "", false),
            ),
          );
          return UserData.fromJson(json.decode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });

          if (language == "en") {
            _alertDialog("Please register as a new user", context);
          } else {
            _alertDialog("الرجاء التسجيل كمستخدم جديد", context);
          }

          throw Exception('Failed to load album');
        }
      } else {
        // ...

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 404) {
          _alertDialog(
            Constants.language == "en"
                ? "Please register as a new user"
                : "الرجاء التسجيل كمستخدم جديد",
            context,
          );
        } else {
          _alertDialog(
            Constants.language == "en" ? "Something went wrong" : "هناك خطأ ما",
            context,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CustomerRegistration(
                mobileNo: '',
              ),
            ),
          );
        }

        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      _alertDialog(
        Constants.language == "en"
            ? "Please connect to the internet"
            : "الرجاء الاتصال بالإنترنت",
        context,
      );

      throw Exception('Failed to load album');
    }
  }

  Future<void> getSkip() async {
    bool isConnected = await networkCheck.isNetworkConnected();

    if (isConnected) {
      final response = await http.get(
        Uri.parse('http://185.188.127.11/public/index.php/iosskip'),
      );

      var responseServer = jsonDecode(response.body);

      if (kDebugMode) {
        print("skip : " + responseServer.toString());
      }

      if (response.statusCode == 201) {
        setState(() {
          isSkipVisible = responseServer["data"].toString();
        });
      } else {
        setState(() {
          isSkipVisible = "0";
        });
      }
    } else {
      setState(() {
        isSkipVisible = "0";
      });
    }
  }

  // _alertDialog(String message) {
  //   Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.grey,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }
}
