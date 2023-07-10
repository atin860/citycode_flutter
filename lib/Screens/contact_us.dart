// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'dart:convert';

import 'package:city_code/models/city_code_contact_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'home_screen.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  bool _isLoading = true;
  late Future<City_code_contact_model> contact_details = _getContactDetails();
  String phone = "";
  String whatsapp = "";
  String instagram = "";
  String mail = "";
  String location = "";

  NetworkCheck networkCheck = NetworkCheck();

  TextEditingController mobile_no_controller = TextEditingController();
  TextEditingController suggestion_controller = TextEditingController();

  Future<City_code_contact_model> _getContactDetails() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(
        Uri.parse('http://185.188.127.11/public/index.php/Contact'),
      );

      var responseServer = jsonDecode(response.body);

      if (kDebugMode) {
        print(responseServer);
      }

      if (response.statusCode == 201) {
        if (responseServer["status"] == 201) {
          return City_code_contact_model.fromJson(json.decode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });
          if (Constants.language == "en") {
            _alertDialog("No data found");
          } else {
            _alertDialog("لاتوجد بيانات");
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

  Future<void> postSubmitData(BuildContext context) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "userid": Constants.user_id,
        "email": "test",
        "mobile": mobile_no_controller.text,
        "details": suggestion_controller.text
      };

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/ApiContactus'),
        body: body,
      );

      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }

        if (response_server["status"] == 201) {
          setState(() {
            _isLoading = false;
          });
          _alertShow(context, "success");
        } else {
          setState(() {
            _isLoading = false;
          });
          _alertShow(context, "failed");
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _alertShow(context, "failed");
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
    suggestion_controller.clear();
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

  _alertShow(BuildContext context, String type) {
    CoolAlert.show(
      backgroundColor: const Color(0xFFF2CC0F),
      context: context,
      type: type == "success" ? CoolAlertType.success : CoolAlertType.error,
      text: type == "success"
          ? Constants.language == "en"
              ? "Message has been sent"
              : "تم ارسال الرسالة"
          : Constants.language == "en"
              ? "Message not sent"
              : "لم يتم إرسال الرسالة",
      confirmBtnText: Constants.language == "en" ? "Continue" : "أستمرار",
      barrierDismissible: true,
      confirmBtnColor: const Color(0xFFF2CC0F),
      confirmBtnTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont"),
      onConfirmBtnTap: () {
        if (type == "success") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen("0", "")));
          Navigator.of(context, rootNavigator: true).pop();
          //_alertShow(context,type);
          //Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen("0"));
          //  Navigator.of(context, rootNavigator: true).pop();
          //Navigator.pushAndRemoveUntil(context, newRoute, (route) => true);
          //Navigator.popAndPushNamed(context,"newRoute");
          /*  Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen("0"),
            ),
                (route) => false,
          );*/
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  void initState() {
    contact_details.then((value) => {
          setState(() {
            phone = value.contactUs!.phone!;
            whatsapp = value.contactUs!.whatsapp!;
            instagram = value.contactUs!.instagram!;
            mail = value.contactUs!.mail!;
            location = value.contactUs!.location!;
            _isLoading = false;
          }),
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2CC0F),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          Constants.language == "en" ? "Contact us" : "اتصل بنا",
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
          )
        ],
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: Constants.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const Image(
                      image: AssetImage("images/app_icon.png"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        Constants.language == "en"
                            ? "We are always ready to help you"
                            : "نحن مستعدون لمساعدتك دائما",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        Constants.language == "en"
                            ? "Contact us through any of the following support channels"
                            : "اتصل عبر أي من قنوات الدعم التالية",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: phone.isNotEmpty ? 1 : 0,
                            child: Visibility(
                              visible: phone.isNotEmpty ? true : false,
                              child: InkWell(
                                onTap: () {
                                  if (phone.isNotEmpty) {
                                    launch(('tel://$phone'));
                                  }
                                },
                                child: const Image(
                                  image: AssetImage("images/phone.png"),
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: whatsapp.isNotEmpty ? 1 : 0,
                            child: Visibility(
                              visible: whatsapp.isNotEmpty ? true : false,
                              child: InkWell(
                                onTap: () {
                                  if (whatsapp.isNotEmpty) {
                                    launch((whatsapp), forceSafariVC: false);
                                  }
                                },
                                child: const Image(
                                  image: AssetImage("images/whatsapp.png"),
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: instagram.isNotEmpty ? 1 : 0,
                            child: Visibility(
                              visible: instagram.isNotEmpty ? true : false,
                              child: InkWell(
                                onTap: () {
                                  if (instagram.isNotEmpty) {
                                    launch(
                                      instagram,
                                      universalLinksOnly: true,
                                    );
                                  }
                                },
                                child: const Image(
                                  image: AssetImage("images/insta.png"),
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: mail.isNotEmpty ? 1 : 0,
                            child: Visibility(
                              visible: mail.isNotEmpty ? true : false,
                              child: InkWell(
                                onTap: () {
                                  if (mail.isNotEmpty) {
                                    launch(('mailto:$mail'));
                                  }
                                },
                                child: const Image(
                                  image: AssetImage("images/mail.png"),
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: location.isNotEmpty ? 1 : 0,
                            child: Visibility(
                              visible: location.isNotEmpty ? true : false,
                              child: InkWell(
                                onTap: () {
                                  if (location.isNotEmpty) {
                                    launch(location);
                                  }
                                },
                                child: const Image(
                                  image: AssetImage("images/location.png"),
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 20.0),
                      child: TextField(
                        controller: mobile_no_controller,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
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
                              ? "Mobile Number"
                              : "رقم الهاتف المحمول",
                          hintStyle: const TextStyle(color: Colors.black45),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0),
                      child: Text(
                        Constants.language == "en"
                            ? "Write down the details of your request"
                            : "اكتب تفاصيل طلبك",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                        textAlign: Constants.language == "en"
                            ? TextAlign.left
                            : TextAlign.right,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 20.0),
                      child: TextField(
                        controller: suggestion_controller,
                        cursorColor: Colors.black,
                        maxLines: 6,
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
                                ? "Problem /  Suggestion here"
                                : "مشكلة / اقتراح هنا",
                            hintStyle: const TextStyle(color: Colors.black45)),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      margin: const EdgeInsets.only(
                          left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (mobile_no_controller.text.isNotEmpty) {
                            if (mobile_no_controller.text.length == 8) {
                              if (suggestion_controller.text.isNotEmpty) {
                                postSubmitData(context);
                              } else {
                                _alertDialog(Constants.language == "en"
                                    ? "Enter Enquiry Detials"
                                    : "أدخل تفاصيل الاستفسار");
                              }
                            } else {
                              _alertDialog(Constants.language == "en"
                                  ? "Please enter valid mobile number"
                                  : "الرجاء إدخال رقم هاتف محمول صحيح");
                            }
                          } else {
                            _alertDialog(Constants.language == "en"
                                ? "Enter Mobile Number"
                                : "أدخل رقم الهاتف المحمول");
                          }
                          // suggestion_controller.clear();
                        },
                        child: Text(
                          Constants.language == "en" ? "SEND" : "إرسال",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont",
                            fontSize: 18.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFFF2CC0F),
                          elevation: 0.0,
                          textStyle: const TextStyle(color: Color(0xFFF2CC0F)),
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
}
