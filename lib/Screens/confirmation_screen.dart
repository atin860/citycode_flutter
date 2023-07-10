// ignore_for_file: unnecessary_import, must_be_immutable, non_constant_identifier_names, avoid_print, unused_local_variable, avoid_unnecessary_containers

import 'dart:convert';

import 'package:city_code/Screens/member_code_screen.dart';
import 'package:city_code/Screens/show_data_screen.dart';
import 'package:city_code/Screens/welcome_screen.dart';
import 'package:city_code/models/otp_model.dart';
import 'package:city_code/models/verify_otp_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmationScreen extends StatefulWidget {
  String mobile_no, page, otp;
  bool isOtp;

  ConfirmationScreen(this.mobile_no, this.page, this.otp, this.isOtp,
      {Key? key})
      : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  bool otp_screen = false, _isLoading = false;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 300;
  late CountdownTimerController controller;
  NetworkCheck networkCheck = NetworkCheck();

  Future<Otp_model> _getOtp(String customer) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/apigetotp?mobileno=' +
              widget.mobile_no +
              '&customer=$customer'));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
          if (!otp_screen) {
            setState(() {
              otp_screen = true;
              _isLoading = false;
              if (widget.page == "Delete Account") {
                widget.otp = response_server["optno"];
              }
            });
          }
          endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 300;
          controller.endTime = endTime;
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

  Future<void> _getNewOtp() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "mobileno": widget.mobile_no,
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
          if (!otp_screen) {
            setState(() {
              otp_screen = true;
              _isLoading = false;
              if (widget.page == "Delete Account") {
                widget.otp = response_server["optno"];
              }
            });
          }
          endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 300;
          controller.endTime = endTime;
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
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
    }
  }

  Future<Verify_otp_model> verifyOtp(String mobile_no, String password,
      String customer, BuildContext context) async {
    final Map<String, String> body;

    bool isConnected = await networkCheck.isNetworkConnected();

    if (isConnected) {
      if (widget.isOtp) {
        if (widget.page == "companyLogin") {
          body = {
            "mobile": mobile_no,
            "password": password,
            "customer": customer
          };
        } else {
          body = {
            "mobileno": mobile_no,
            "password": password,
            "customer": customer,
            "user_id": Constants.user_id,
            "language": Constants.language
          };
        }
      } else {
        body = {
          "mobile": mobile_no,
          "password": password,
          "customer": customer
        };
      }

      final http.Response response;

      if (widget.isOtp) {
        if (widget.page == "companyLogin") {
          response = await http.post(
            Uri.parse('http://185.188.127.11/public/index.php/apilogin'),
            body: body,
          );
        } else {
          response = await http.post(
            Uri.parse(
                'http://185.188.127.11/public/index.php/ApiUsers/newgetotpverify'),
            body: body,
          );
        }
      } else {
        response = await http.post(
          Uri.parse('http://185.188.127.11/public/index.php/apilogin'),
          body: body,
        );
      }

      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }

        if (response_server["status"] == 201) {
          SharedPreferences _prefs = await SharedPreferences.getInstance();

          if (widget.page == "companyLogin") {
            _prefs.setString("branch_id", Constants.branch_id);
            _prefs.setString("name", Constants.branch_name);
            _prefs.setString("company_id", Constants.company_id);
            _prefs.setString("mobile", Constants.mobile_no);
            _prefs.setBool("isBranchLoggedin", true);
            _prefs.setString("language", Constants.language);
          } else {
            Constants.user_id = response_server["user_detail"]["id"].toString();
            Constants.name = response_server["user_detail"]["name"];
            Constants.city_code = response_server["user_detail"]["city_code"];
            Constants.interest = response_server["user_detail"]["interest"];
            Constants.mobile_no = widget.mobile_no;
            _prefs.setString("user_id", response_server["user_detail"]["id"]);
            _prefs.setString("name", response_server["user_detail"]["name"]);
            _prefs.setString(
                "city_code", response_server["user_detail"]["city_code"]);
            _prefs.setString(
                "interest", response_server["user_detail"]["interest"]);
            _prefs.setString("mobile", widget.mobile_no);
            _prefs.setBool("isLogged_in", true);
          }
          setState(() {
            _isLoading = false;
          });

          if (widget.page == "companyLogin") {
            _alertDialog(Constants.language == "en"
                ? "Login Successful"
                : "تم تسجيل الدخول بنجاح");
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const MemberCodeScreen(),
              ),
              (route) => false,
            );
          } else {
            _alertDialog(Constants.language == "en"
                ? "Login Successful"
                : "تم تسجيل الدخول بنجاح");
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const ShowDataScreen(),
              ),
              (route) => false,
            );
          }

          return Verify_otp_model.fromJson(json.decode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });
          if (Constants.language == "en") {
            _alertDialog("Login Failed");
          } else {
            _alertDialog("فشل عملية الدخول");
          }
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (Constants.language == "en") {
          _alertDialog("Something went wrong");
        } else {
          _alertDialog("هناك خطأ ما");
        }
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

  Future<void> postDeleteAccount(BuildContext context) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {"user_id": Constants.user_id};

      final http.Response response;

      response = await http.post(
        Uri.parse(
            'http://185.188.127.11/public/index.php/ApiUsers/DeleteUserApi'),
        body: body,
      );

      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }

        if (response_server["status"] == 201) {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.clear();
          _prefs.setString("language", Constants.language);

          Constants.user_id = "";
          Constants.name = "";
          Constants.city_code = "";
          Constants.interest = "";
          Constants.mobile_no = "";

          setState(() {
            _isLoading = false;
          });

          _alertDialog(Constants.language == "en"
              ? "Account deleted successfully"
              : "تم حذف الحساب بنجاح");
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const WelcomeScreen(),
            ),
            (route) => false,
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          if (Constants.language == "en") {
            _alertDialog("Account not deleted");
          } else {
            _alertDialog("لم يتم حذف الحساب");
          }
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (Constants.language == "en") {
          _alertDialog("Something went wrong");
        } else {
          _alertDialog("هناك خطأ ما");
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

  void onEnd() {}

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    if (otp_screen) {
      if (widget.isOtp) {
        return true;
      } else {
        setState(() {
          Navigator.pop(context);
          //  otp_screen = false;
        });
        return false;
      }
    } else {
      return true;
    }
  }

  @override
  void initState() {
    if (widget.page == "Change Mobile Number") {
      _getNewOtp();
    } else {
      if (widget.page == "companyLogin") {
        print("compnyotp");
        //_getOtp("company");
      } else {
        print("costpmerotp");
        _getOtp("customer");
      }
    }
    setState(() {
      otp_screen = true;
      // otp_screen = widget.isOtp;
    });
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
                      SizedBox(
                        height: height * 0.10,
                      ),
                      const Image(
                        image: AssetImage("images/app_icon.png"),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Text(
                        otp_screen
                            ? Constants.language == "en"
                                ? "Enter the one-time verification code"
                                : "أدخل رمز التحقق لمرة واحدة"
                            : Constants.language == "en"
                                ? "Confirm phone number"
                                : "قم بتأكيد رقم الهاتف",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont"),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Column(
                        children: [
                          Container(
                            child: Text(
                              otp_screen
                                  ? Constants.language == "en"
                                      ? "Enter the 4-digit verification code that was sent to the number"
                                      : "ادخل الرمز المكون من اربعة ارقام الذي تم ارساله على رقم"
                                  : Constants.language == "en"
                                      ? "One Time Password (OTP) will be sent.\n At the following number:"
                                      : " سيتم إرسال كلمة المرور لمرة واحدة على الرقم التالي ",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 14.0,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            otp_screen
                                ? Constants.language == "en"
                                    ? "Your Mobile No. " + widget.mobile_no
                                    : "هاتفك النقال. " + widget.mobile_no
                                : Constants.language == "ar"
                                    ? "(OTP)"
                                    : "",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black45,
                                fontFamily: otp_screen ? "Roboto" : "GSSFont"),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Visibility(
                        visible: !otp_screen,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.05,
                            ),
                            Text(
                              widget.mobile_no,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontFamily: "Roboto"),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: otp_screen,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.05,
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                isDense: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.length == 4) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (widget.page == "Delete Account") {
                                    if (value == widget.otp) {
                                      postDeleteAccount(context);
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      _alertDialog(Constants.language == "en"
                                          ? "Invalid OTP"
                                          : "OTP غير صحيح");
                                    }
                                  }
                                  if (widget.page == "companyLogin") {
                                    verifyOtp(widget.mobile_no, value,
                                        "company", context);
                                  } else {
                                    verifyOtp(widget.mobile_no, value,
                                        "customer", context);
                                  }
                                }
                              },
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        ///here i am changing otp_screen to !otp_screen
                        visible: !otp_screen,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.05,
                            ),
                            CountdownTimer(
                              controller: controller,
                              endTime: endTime,
                              widgetBuilder:
                                  (context, CurrentRemainingTime? time) {
                                if (time == null) {
                                  return const Text('min: 0, sec: 0');
                                }
                                return Text(
                                    'min: ${time.min}, sec: ${time.sec}');
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          if (widget.page == "Change Mobile Number") {
                            _getNewOtp();
                          } else {
                            if (widget.page == "companyLogin") {
                              //_getOtp("company");
                            } else {
                              // _getOtp("customer");
                            }
                          }
                        },
                        child: Text(
                          otp_screen
                              ? Constants.language == "en"
                                  ? "Resend OTP"
                                  : "إعادة إرسال OTP"
                              : Constants.language == "en"
                                  ? "Use OTP"
                                  : "استخدم OTP",
                          style: TextStyle(
                            color: otp_screen
                                ? const Color(0xFFF2CC0F)
                                : Colors.black,
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont",
                            fontSize: 18.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: otp_screen
                              ? Colors.black
                              : const Color(0xFFF2CC0F),
                          elevation: 0.0,
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 50.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
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
