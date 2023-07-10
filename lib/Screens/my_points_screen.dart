// ignore_for_file: unused_import, non_constant_identifier_names, avoid_unnecessary_containers, avoid_print, deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:city_code/Screens/book_now_sceen.dart';
import 'package:city_code/Screens/buy_ponts.dart';
import 'package:city_code/Screens/points.dart';
import 'package:city_code/Screens/web_view_screen.dart';
import 'package:city_code/models/company_details_model.dart';
import 'package:city_code/models/transfer_points_model.dart';
import 'package:city_code/models/user_details_model.dart';
import 'package:city_code/models/user_redeem_points_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/home_banner_model.dart';
import '../utils/keyboard_overlay.dart';
import 'chat_screen.dart';
import 'home_screen.dart';
import 'offer_details_screen.dart';

class MyPointsScreen extends StatefulWidget {
  const MyPointsScreen({Key? key}) : super(key: key);

  String get company_name => "";

  /*String company_name;
  MyPointsScreen( this.company_name,{Key? key}):super(key:key);*/

  @override
  _MyPointsScreenState createState() => _MyPointsScreenState();
}

class _MyPointsScreenState extends State<MyPointsScreen> {
  bool _isLoading = true,
      transferPoints = false,
      redeemPoints = false,
      company_info = false;
  late Future<User_redeem_points_model> redeem_points = getRedeemPoints();
  late Future<User_details_model> user_details = getUserDetails();
  List<Companylist>? companylist = [];
  String product_base_url = "";
  String company_base_url = "";
  String total_points = "0";
  String company_id = "";
  int position = 0;
  int _currentPosition = 0;
  List<Banner_list>? bannerList = [];
  String banner_base_url = "";
  TextEditingController suggestion_controller = TextEditingController();
  String location = "",
      phone = "",
      whatsapp = "",
      email = "",
      instagram = "",
      snapchat = "";
  FocusNode numberFocusNode = FocusNode();

  String get company_image => "";

  // String get branch_id => "";

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  NetworkCheck networkCheck = NetworkCheck();

  TextEditingController member_code_controller = TextEditingController();
  TextEditingController points_controller = TextEditingController();

  Future<User_details_model> getUserDetails() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(
        Uri.parse('http://185.188.127.11/public/index.php/ApiUsers/' +
            Constants.user_id),
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 200) {
        if (response_server["status"] == 201) {
          return User_details_model.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to load album');
        }
      } else {
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

  Future<CompanyDetailsModel> _getCompanyDetails() async {
    final response = await http.get(
      Uri.parse(
          'http://185.188.127.11/public/index.php/ApiCompany/' + company_id),
    );

    var responseServer = jsonDecode(response.body);

    if (kDebugMode) {
      print(responseServer);
    }

    if (response.statusCode == 200) {
      if (responseServer["status"] == 201) {
        return CompanyDetailsModel.fromJson(json.decode(response.body));
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

  Future<User_redeem_points_model> getRedeemPoints() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(
        Uri.parse(
            'http://185.188.127.11/public/index.php/ApiProducts?show_inredeem=1'),
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 201) {
        if (response_server["status"] == 201) {
          return User_redeem_points_model.fromJson(json.decode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });
          if (Constants.language == "en") {
            _alertDialog("No Data Found");
          } else {
            _alertDialog("لاتوجد بيانات");
          }
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          if (Constants.language == "en") {
            _alertDialog("No Data Found");
          } else {
            _alertDialog("لاتوجد بيانات");
          }
        } else {
          if (Constants.language == "en") {
            _alertDialog("Something went wrong");
          } else {
            _alertDialog("هناك خطأ ما");
          }
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

  Future<TransferPointsModel> getTransferPoints(BuildContext context) async {
    final body = {
      "sender_user_id": Constants.user_id,
      "point": points_controller.text,
      "rcvr_code": member_code_controller.text
    };
    final response = await http.post(
      Uri.parse('http://185.188.127.11/public/index.php/transferPoint'),
      body: body,
    );

    var response_server = jsonDecode(response.body);

    if (kDebugMode) {
      print(response_server);
    }

    if (response.statusCode == 201) {
      if (response_server["status"] == 201) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Constants.language == "en"
                ? "Transfer Successful"
                : "تم النقل بنجاح"),
            content: Text(Constants.language == "en"
                ? points_controller.text +
                    " Points Successfully transferred to " +
                    member_code_controller.text
                : points_controller.text +
                    " تم تحويل النقاط بنجاح إلى " +
                    member_code_controller.text),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  // Route newRoute =
                  //     MaterialPageRoute(builder: (context) => HomeScreen("0"));
                  // Navigator.pushAndRemoveUntil(
                  //     context, newRoute, (route) => false);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
        return TransferPointsModel.fromJson(json.decode(response.body));
      } else {
        setState(() {
          _isLoading = false;
        });
        if (Constants.language == "en") {
          _alertDialog("No Data Found");
        } else {
          _alertDialog("لاتوجد بيانات");
        }
        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == 404) {
        if (Constants.language == "en") {
          _alertDialog("No Data Found");
        } else {
          _alertDialog("لاتوجد بيانات");
        }
      } else {
        if (Constants.language == "en") {
          _alertDialog("Something went wrong");
        } else {
          _alertDialog("هناك خطأ ما");
        }
      }
      throw Exception('Failed to load album');
    }
  }

  Future<void> postSubmitData() async {
    final body = {
      "userid": Constants.user_id,
      "companyid": company_id,
      "details": suggestion_controller.text
    };

    final response = await http.post(
      Uri.parse('http://185.188.127.11/public/index.php/ApiCompanyenquiry'),
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
        _alertDialog(Constants.language == "en"
            ? "Enquiry submitted successfully"
            : "تم إرسال الاستفسار بنجاح");
      } else {
        setState(() {
          _isLoading = false;
        });
        _alertDialog(Constants.language == "en"
            ? "Enquiry submission failed"
            : "فشل تقديم الاستفسار");
        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Enquiry submission failed"
          : "فشل تقديم الاستفسار");
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

  @override
  void initState() {
    user_details.then((value) => {
          if (value.userdetail != null && value.userdetail!.isNotEmpty)
            {
              setState(() {
                total_points = value.userdetail![0].totalpoint!;
              }),
            }
        });
    redeem_points.then((value) => {
          if (value.companylist != null && value.companylist!.isNotEmpty)
            {
              for (int i = 0; i < value.companylist!.length; i++)
                {
                  companylist!.add(value.companylist![i]),
                }
            },
          setState(() {
            product_base_url = value.imageBaseUrl!;
            company_base_url = value.companyBaseUrl!;
            _isLoading = false;
          }),
        });
    numberFocusNode.addListener(() {
      bool hasFocus = numberFocusNode.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    numberFocusNode.dispose();
    super.dispose();
  }

  Future<Home_banner_model> getHomeBanner(String screen) async {
    final body = {
      "user_id": Constants.user_id,
      "language": Constants.language == "en" ? "english" : "arb"
    };

    final response = await http.post(
      Uri.parse(
          'http://185.188.127.11/public/index.php/ApiAdvertise/newBanner'),
      body: body,
    );

    var response_server = jsonDecode(response.body);

    if (kDebugMode) {
      print(response_server);
    }

    if (response.statusCode == 201) {
      if (response_server["status"] == 201) {
        return Home_banner_model.fromJson(json.decode(response.body));
      } else {
        if (Constants.language == "en") {
          _alertDialog("No banners available");
        } else {
          _alertDialog("لا توجد لافتات متاحة");
        }
        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        if (screen == "company") {
          _currentPosition = 0;
          redeemPoints = false;
          company_info = true;
          _isLoading = false;
        }
      });
      if (Constants.language == "en") {
        _alertDialog("Something went wrong");
      } else {
        _alertDialog("هناك خطأ ما");
      }
      throw Exception('Failed to load album');
    }
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    if (transferPoints) {
      setState(() {
        transferPoints = false;
      });
      return false;
    } else if (redeemPoints) {
      setState(() {
        redeemPoints = false;
      });
      return false;
    } else if (company_info) {
      setState(() {
        company_info = false;
        redeemPoints = true;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor:
            transferPoints ? const Color(0xFFF2CC0F) : Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFFF2CC0F),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.arrow_left),
            color: Colors.black,
            onPressed: () {
              if (transferPoints) {
                setState(() {
                  transferPoints = false;
                });
              } else if (redeemPoints) {
                setState(() {
                  redeemPoints = false;
                });
              } else if (company_info) {
                setState(() {
                  company_info = false;
                  redeemPoints = true;
                });
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            Constants.language == "en"
                ? transferPoints
                    ? "Transfering points"
                    : redeemPoints
                        ? "Redeeming Points"
                        : company_info
                            ? "Company Info"
                            : "My Points"
                : transferPoints
                    ? "تحويل النقاط"
                    : redeemPoints
                        ? "استبدال النقاط"
                        : company_info
                            ? "معلومات الشركة"
                            : "نقاطي",
            style: TextStyle(
              color: Colors.black,
              fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
            ),
          ),
          actions: <Widget>[
            Visibility(
              visible: !transferPoints,
              child: IconButton(
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
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Directionality(
            textDirection: Constants.language == "en"
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: Stack(
              children: [
                Visibility(
                  visible: !transferPoints && !redeemPoints && !company_info,
                  child: SizedBox(
                    height: height,
                    child: Column(
                      children: [
                        Container(
                          color: const Color(0xFFF2CC0F),
                          child: Column(
                            children: [
                              const Image(
                                image: AssetImage("images/app_icon.png"),
                              ),
                              Text(
                                Constants.language == "en"
                                    ? "Total Points"
                                    : "مجمل النقاط",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  total_points,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        transferPoints = true;
                                      });
                                    },
                                    child: Container(
                                      // width: width,
                                      margin: const EdgeInsets.only(
                                          top: 5.0,
                                          left: 10.0,
                                          right: 10.0,
                                          bottom: 10.0),
                                      child: Text(
                                        Constants.language == "en"
                                            ? "Transfer Points"
                                            : "تحويل النقاط",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          decoration: TextDecoration.underline,
                                        ),
                                        textAlign: Constants.language == "en"
                                            ? TextAlign.left
                                            : TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  /* InkWell(
                                    onTap: () {
                                      setState(() {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BuyPoints()));
                                      });
                                    },
                                    child: Container(
                                    //  width: width,
                                     margin: const EdgeInsets.only(
                                          top: 5.0,
                                          left: 10.0,
                                          right: 10.0,
                                          bottom: 10.0),
                                      child: Text(
                                        Constants.language == "en"
                                            ? "Buy Points"
                                            : "تحويل النقاط",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          decoration: TextDecoration.underline,
                                        ),
                                        textAlign: Constants.language == "en"
                                            ? TextAlign.left
                                            : TextAlign.right,
                                      ),
                                    ),
                                  ),*/
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: width,
                          margin: const EdgeInsets.only(
                              top: 5.0, left: 10.0, right: 10.0, bottom: 10.0),
                          child: Text(
                            Constants.language == "en"
                                ? "Redeeming Points"
                                : "استبدال النقاط",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                            ),
                            textAlign: Constants.language == "en"
                                ? TextAlign.right
                                : TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            shrinkWrap: true,
                            itemCount: companylist!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    /*  print("name:::::"+Constants.language == "en"
                                        ? companylist![index]
                                        .companyName!);*/
                                    position = index;
                                    _isLoading = false;
                                    redeemPoints = true;
                                    transferPoints = false;
                                    company_id = companylist![index].companyId!;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, top: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: width / 4,
                                        height: 124,
                                        margin: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              /*   margin:
                                            const EdgeInsets.only(left: 0.5, right: 0.5,top: 0.5,bottom: 0.5),
                                              padding: const EdgeInsets.all(5.0),
                                             // padding: const EdgeInsets.only(left: 10.0, right: 50.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color(0xFFF2CC0F),
                                                ),

                                                color: const Color(0xFFE6D997)

                                              ),*/

                                              //color: Color(0xFFE6D997),
                                              child: Center(
                                                child: Text(
                                                  Constants.language == "en"
                                                      ? "Price"
                                                      : "السعر",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          Constants.language ==
                                                                  "en"
                                                              ? "Roboto"
                                                              : "GSSFontS"),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 150,
                                              height: 1,
                                              color: Colors.black,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Text(
                                                  companylist![index].price! +
                                                      " OMR"),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: const Text("+"),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Text(companylist![index]
                                                      .prRedeempoint! +
                                                  " Points"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 1.0,
                                        height: 144,
                                        color: Colors.black,
                                      ),
                                      Container(
                                        width: width / 4,
                                        height: 124,
                                        margin: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              Constants.language == "en"
                                                  ? companylist![index]
                                                      .productName!
                                                  : companylist![index]
                                                      .arbProductName!,

                                              // Constants.language == "en"
                                              //     ? companylist![index]
                                              //         .productName!
                                              //     : companylist![index]
                                              //         .arbProductName!,

                                              style: TextStyle(
                                                fontSize:
                                                    13.0, //efited by rohan
                                                //overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    Constants.language == "en"
                                                        ? "Roboto"
                                                        : "Roboto",
                                              ),
                                              overflow:
                                                  TextOverflow.ellipsis, //
                                              maxLines: 2, //edited by rohan
                                              softWrap: false, //
                                            ),
                                            Image(
                                              width: 100,
                                              height: 90, //edited by rohan
                                              image: NetworkImage(
                                                  product_base_url +
                                                      companylist![index]
                                                          .picture!),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 1.0,
                                        height: 144,
                                        color: Colors.black,
                                      ),
                                      Container(
                                        width: width / 4,
                                        height: 124,

                                        margin: const EdgeInsets.all(10.0),
                                        //margin:EdgeInsets.only(bottom: 10,top: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              /* margin:
                                              const EdgeInsets.only(left: 1, right: 0.5,top: 0.5,bottom: 0.5),
                                              padding: const EdgeInsets.all(5.0),
                                              // padding: const EdgeInsets.only(left: 10.0, right: 50.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: const Color(0xFFF2CC0F),
                                                  ),

                                                  color: const Color(0xFFE6D997)

                                              ),*/
                                              child: Text(
                                                Constants.language == "en"
                                                    ? companylist![index]
                                                        .companyName!
                                                    : companylist![index]
                                                        .companyArbName!,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      Constants.language == "en"
                                                          ? "Roboto"
                                                          : "GSSFont",
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              width: 80,
                                              height: 1,
                                              color: Colors.black,
                                            ),
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  company_base_url +
                                                      companylist![index]
                                                          .companyPicture!),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: transferPoints,
                  child: transferPointsWidget(width, height),
                ),
                Visibility(
                  visible: redeemPoints,
                  child: redeemingPointsWidget(
                    width,
                    height,
                  ),
                ),
                Visibility(
                  visible: company_info,
                  child: companyInfoWidget(context, width, height),
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
        bottomNavigationBar: Visibility(
          visible: transferPoints,
          child: Container(
            margin:
                const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: ElevatedButton(
              onPressed: () {
                if (member_code_controller.text.isNotEmpty) {
                  if (member_code_controller.text.length == 5) {
                    if (member_code_controller.text != Constants.city_code) {
                      if (points_controller.text.isNotEmpty) {
                        int a = int.parse(points_controller.text);
                        int b = int.parse(total_points);
                        if (a <= b && a != 0 && b != 0) {
                          getTransferPoints(context);
                        } else {
                          _alertDialog(Constants.language == "en"
                              ? "You have not enough points to transfer"
                              : "أجمالي النقاط لديك غير كافية للتحويل");
                        }
                      } else {
                        _alertDialog(Constants.language == "en"
                            ? "Please enter points to transfer"
                            : "الرجاء إدخال النقاط للتحويل");
                      }
                    } else {
                      _alertDialog(Constants.language == "en"
                          ? "You cannot transfer points to yourself"
                          : "لا يمكنك تحويل النقاط إلى نفسك");
                    }
                  } else {
                    _alertDialog(Constants.language == "en"
                        ? "Please enter valid city code of member"
                        : "الرجاء إدخال رمز مدينة صالح للعضو");
                  }
                } else {
                  _alertDialog(Constants.language == "en"
                      ? "Please enter city code of member"
                      : "الرجاء إدخال رمز المدينة للعضو");
                }
              },
              child: Text(
                Constants.language == "en" ? "Continue" : "أستمرار",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontSize: 18.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2CC0F),
                elevation: 0.0,
                fixedSize: Size(MediaQuery.of(context).size.width, 40.0),
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
        ),
      ),
    );
  }

  Widget redeemingPointsWidget(double width, double height) {
    return Container(
      child: Column(
        children: [
          Container(
            height: height * 0.25,
            color: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: companylist!.isNotEmpty
                  ? Image(
                      image: NetworkImage(
                          product_base_url + companylist![position].picture!),
                      width: width,
                      height: height * 0.25,
                      fit: BoxFit.fill,
                    )
                  : Container(),
            ),
          ),

          //Edited Rohan

          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          Container(
            width: width,
            color: const Color(0xFFF2CC0F),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* Container(
                     // margin: const EdgeInsets.only(left: 2.5, right: 2.5),
                    //  padding: const EdgeInsets.all(10.0),
                       margin: const EdgeInsets.all(5),
                     // alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {

                          Route route = MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                //  widget.company_name,

                                  companylist![_currentPosition].companyName!,
                                  company_base_url+companylist![_currentPosition].companyPicture!,
                                  //company_image,
                                   Constants.user_id,
                               //   companylist![_currentPosition].id!,
                                  //  Constants.branch_id,
                                  companylist![_currentPosition]. companyId!,
                                  //companylist![_currentPosition].companyId!,

                                  "",
                                  "",
                                  "user",
                                  "", "0", "0"));
                          Navigator.push(context, route);
                          print("Company name"+companylist![_currentPosition].companyName!);
                          print("company id:::::"+companylist![_currentPosition].id!);
                          print("company branchID:::::"+   companylist![_currentPosition].companyId!);
                        },
                        child: const Image(
                          image: AssetImage("images/chat_icon.png"),
                          width: 30.0,
                          height: 30.0,
                        ),
                      ),
                    ),*/
                InkWell(
                  onTap: () {
                    setState(() {
                      _isLoading = true;
                    });
                    setState(() {
                      _isLoading = true;
                    });
                    _getCompanyDetails().then((value) => {
                          if (value.companydetails != null &&
                              value.companydetails!.isNotEmpty)
                            {
                              setState(() {
                                location = value.companydetails![0].cLocation!;
                                phone = value.companydetails![0].mobile!;
                                whatsapp = value.companydetails![0].whatsapp!;
                                email = value.companydetails![0].email!;
                                instagram = value.companydetails![0].instagram!;
                                snapchat = value.companydetails![0].snapchat!;
                              }),
                            },
                          getHomeBanner("company").then((value) => {
                                if (value.bannerList != null &&
                                    value.bannerList!.isNotEmpty)
                                  {
                                    bannerList!.clear(),
                                    for (int i = 0;
                                        i < value.bannerList!.length;
                                        i++)
                                      {
                                        setState(() {
                                          bannerList!.add(value.bannerList![i]);
                                        }),
                                      }
                                  },
                                setState(() {
                                  banner_base_url = value.imageBaseUrl ?? "";
                                  _currentPosition = 0;
                                  redeemPoints = false;
                                  company_info = true;
                                  _isLoading = false;
                                })
                              }),
                          setState(() {
                            _isLoading = false;
                          }),
                        });
                  },
                  child: Container(
                    // margin: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      Constants.language == "en"
                          ? "Company Info"
                          : "معلومات الشركة",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16.0,
                        color: Colors.black,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                /*Container(
                      margin: const EdgeInsets.only(left: 70.0, right: 5.0),
                      child: Text(
                        Constants.language == "en"
                            ? "BOOK NOW"
                            : "معلومات الشركة",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16.0,
                          color: Colors.black,
                          fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),*/
                /*Container(
                      //margin: const EdgeInsets.all(10.0),
                     margin: EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: () {
                         */ /* String product_details = Constants.language ==
                              "en"
                              ? "Product Name: " +
                              productlist![index].productName!
                              : productlist![index]
                              .arbProductName!
                              .isNotEmpty
                              ? "اسم المنتج: " +
                              productlist![index].arbProductName!
                              : "اسم المنتج: " +
                              productlist![index].productName!;
                          String description2 = Constants.language == "en"
                              ? "\nDescription: " +
                              productlist![index].description!
                              : productlist![index]
                              .arbDescription!
                              .isNotEmpty
                              ? "\nالوصف: " +
                              productlist![index].arbDescription!
                              : "\nالوصف: " +
                              productlist![index].description!;
                          String description3 = Constants.language == "en"
                              ? "\nOriginal price: " +
                              price1.toString() +
                              "\nDiscounted price: " +
                              price2.toString()
                              : "\nالسعر الأصلي: " +
                              price1.toString() +
                              "\nالسعر بعد التخفيض: " +
                              price2.toString();*/ /*
                          Route route = MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  //widget.company_name,
                                companylist![_currentPosition].companyName!,
                                  //company_image,
                                  company_base_url+companylist![_currentPosition].companyPicture!,
                                  Constants.user_id,
                                  //branch_id,

                                  companylist![_currentPosition].companyId!,
                                  product_base_url + companylist![position].picture!,

                                  companylist![_currentPosition].description!,
                                  "user",
                                  "", "0", "0"));
                          Navigator.push(context, route);
                        },
                        child: Text(
                          Constants.language == "en"
                              ? "BOOK NOW"
                              : "احجز الآن",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont",
                            fontSize: 12.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFFF2CC0F),
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.black,
                             // width:0.5,
                            ),
                          ),
                          //fixedSize: Size(width, 10.0),
                        ),
                      ),
                    ),*/
              ],
            ),
          ),

          // Till here edited by rohan
          Container(
            margin: const EdgeInsets.only(left: 2.5, right: 2.5),
            padding: const EdgeInsets.all(10.0),
            // margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Route route = MaterialPageRoute(
                    builder: (context) => ChatScreen(
                        //  widget.company_name,

                        companylist![_currentPosition].companyName!,
                        company_base_url +
                            companylist![_currentPosition].companyPicture!,
                        //company_image,
                        Constants.user_id,
                        //companylist![_currentPosition].id!,
                        //  Constants.branch_id,
                        companylist![_currentPosition].companyId!,
                        //companylist![_currentPosition].companyId!,

                        "",
                        "",
                        "user",
                        "",
                        "0",
                        "0"));
                Navigator.push(context, route);
                print("Company name" +
                    companylist![_currentPosition].companyName!);
                print("company id:::::" + companylist![_currentPosition].id!);
                print("company branchID:::::" +
                    companylist![_currentPosition].companyId!);
              },
              child: const Image(
                image: AssetImage("images/chat_icon.png"),
                width: 30.0,
                height: 30.0,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  width: width,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      Constants.language == "en"
                          ? "Redeeming points    "
                          //  : "استبدال النقاط",
                          : "سعر المنتج", //Edited by rohan
                      style: TextStyle(
                        color: Colors.black45,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                      ),
                      textAlign: Constants.language == "en"
                          ? TextAlign.left
                          : TextAlign.right,
                    ),
                  ),
                ),
                ListView.builder(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                                shape: const RoundedRectangleBorder(
                                    //  side: const BorderSide(color: Colors.black),
                                    //    borderRadius: BorderRadius.circular(20),
                                    ),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: width / 2.5,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),

                                            // borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                                          ),
                                          child: Center(
                                              child: Text(companylist![position]
                                                  .price!)),
                                        ),
                                        Container(
                                          width: width / 2.5,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            //  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))
                                          ),
                                          child: Center(
                                              child: Text(companylist![position]
                                                  .prRedeempoint!)),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          width: width / 2.5,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            //   borderRadius: BorderRadius.only(topRight: Radius.circular(10))
                                          ),
                                          child: Center(
                                            child: Text(
                                                Constants.language == "en"
                                                    ? "OMR"
                                                    : "ريال عماني"),
                                          ),
                                        ),
                                        Container(
                                          width: width / 2.5,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            //borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))
                                          ),
                                          child: Center(
                                            child: Text(
                                                Constants.language == "en"
                                                    ? "Point"
                                                    : "نقطة"),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      );
                    }),
                /*  Container(
                  width: width,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: companylist!.isNotEmpty
                          ? Text(
                              Constants.language == "en"
                                  //? "Price " +
                                    //  companylist![position].price! +
                                  ? companylist![position].price!  +
                                   " Omani Rial"    +
                                      " + " +
                                      companylist![position].prRedeempoint! +
                                      " Point"
                                //  : " نقطة" +
                              :companylist![position].prRedeempoint! +" نقطة "
                                      +
                                      " + " +companylist![position].price!+
                                      " ريال عماني" ,
                                     // companylist![position].price! +
                                     // " السعر",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.center)
                          : Container(),
                    ),
                  ),
                ),*/
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    width: width,
                    child: Text(
                      Constants.language == "en"
                          ? "Product details"
                          : "تفاصيل المنتج",
                      style: TextStyle(
                        color: Colors.black45,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                      ),
                      textAlign: Constants.language == "en"
                          ? TextAlign.left
                          : TextAlign.right,
                    ),
                  ),
                ),
                Container(
                  width: width,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 150,
                      width: width,
                      padding: const EdgeInsets.all(10.0),
                      child: companylist!.isNotEmpty
                          ? Text(
                              Constants.language == "en"
                                  ? companylist![position].description!
                                  : companylist![position].arbDescription!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                              textAlign: Constants.language == "en"
                                  ? TextAlign.left
                                  : TextAlign.right,
                            )
                          : Container(),
                    ),
                  ),
                ),
                Container(
                  width: width / 0.5,
                  //margin: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      var companynem = Constants.language == "en"
                          ? companylist![_currentPosition].companyName!
                          : companylist![_currentPosition].companyArbName!;

                      var companydescription = Constants.language == "en"
                          ? companylist![position].description!
                          : companylist![position].arbDescription!;

                      String product_details = Constants.language == "en"
                          ? "Product Name: " +
                              //productlist![index].productName!
                              //    : productlist![index]
                              //  .arbProductName!
                              //  .isNotEmpty
                              companylist![position].productName!
                          : companylist![position].arbProductName!.isEmpty
                              ? "اسم المنتج: " +
                                  companylist![position].arbProductName!
                              //     productlist![index].arbProductName!
                              : "اسم المنتج: " +
                                  companylist![position].productName!;
                      // productlist![index].productName!;
                      String description2 = Constants.language == "en"
                          ? "\nDescription: " +
                              companylist![position].description!
                          : companylist![position].arbDescription!.isNotEmpty
                              //     productlist![index].description!
                              //    : productlist![index]
                              //    .arbDescription!
                              //  .isNotEmpty
                              ? "\nالوصف: " +
                                  companylist![position].arbDescription!
                              //   productlist![index].arbDescription!
                              : "\nالوصف: " +
                                  companylist![position].description!;
                      //productlist![index].description!;
                      String description3 = Constants.language == "en"
                          ? "\nOriginal price: " +
                              companylist![position].price.toString() +
                              //price1.toString() +
                              "\nDiscounted price: " +
                              companylist![position].price.toString()
                          //price2.toString()
                          : "\nالسعر الأصلي: " +
                              companylist![position].price.toString() +
                              //price1.toString() +
                              "\nالسعر بعد التخفيض: " +
                              companylist![position].price.toString();
                      /* String product_details = Constants.language ==
                          "en"
                          ? "Product Name: " +
                          productlist![index].productName!
                          : productlist![index]
                          .arbProductName!
                          .isNotEmpty
                          ? "اسم المنتج: " +
                          productlist![index].arbProductName!
                          : "اسم المنتج: " +
                          productlist![index].productName!;
                      String description2 = Constants.language == "en"
                          ? "\nDescription: " +
                          productlist![index].description!
                          : productlist![index]
                          .arbDescription!
                          .isNotEmpty
                          ? "\nالوصف: " +
                          productlist![index].arbDescription!
                          : "\nالوصف: " +
                          productlist![index].description!;
                      String description3 = Constants.language == "en"
                          ? "\nOriginal price: " +
                          price1.toString() +
                          "\nDiscounted price: " +
                          price2.toString()
                          : "\nالسعر الأصلي: " +
                          price1.toString() +
                          "\nالسعر بعد التخفيض: " +
                          price2.toString();
                      var priceone=price1;
                      var pricetwo=price2;
                      String productname=productlist![index].productName!;
                      String arbproductname= productlist![index].arbProductName!;
                      String description=productlist![index].description!;
                      var points=productlist![index].prRedeempoint!;
                      var productid=productlist![index].id.toString();
                      var product_mobile=productlist![index].productcostmobile.toString();
                      print("productmobile____"+product_mobile);
                      var productdiscountmobile=productlist![index].productdiscountmobile.toString();
                      var branchid=productlist![index].branchId.toString();
                      var companyid=productlist![index].companyId.toString();*/
                      Route route = MaterialPageRoute(
                          builder: (context) => booknow(
                                "cartid",
                                companynem,
                                company_base_url +
                                    companylist![_currentPosition]
                                        .companyPicture!,
                                Constants.user_id,
                                companylist![_currentPosition]
                                    .branchId
                                    .toString(),
                                product_base_url +
                                    companylist![position].picture!,
                                product_details + description2 + description3,
                                "user",
                                "",
                                "0",
                                "0",
                                companylist![_currentPosition].originalPrice!,
                                "1.00",
                                companylist![_currentPosition].productName!,
                                companydescription,
                                companylist![_currentPosition]
                                    .companyName!
                                    .toString(),
                                companylist![_currentPosition].arbProductName!,
                                companynem,
                                "points",
                                companylist![_currentPosition].id!,
                                companylist![_currentPosition].price!,
                                companylist![_currentPosition].prRedeempoint!,
                                companylist![_currentPosition]
                                    .branchId
                                    .toString(),
                                companylist![_currentPosition]
                                    .companyId
                                    .toString(),
                                "",
                                "",
                                "",
                                "1",
                              ));
                      Navigator.push(context, route);

                      ///chat code here......
                      /* String product_details = Constants.language ==
                              "en"
                              ? "Product Name: " +
                              //productlist![index].productName!
                          //    : productlist![index]
                            //  .arbProductName!
                            //  .isNotEmpty
                              companylist![position].productName!
                      :companylist![position].arbProductName!
                      .isEmpty
                              ? "اسم المنتج: " +
                      companylist![position].arbProductName!
                         //     productlist![index].arbProductName!
                              : "اسم المنتج: " +
                          companylist![position].productName!;
                             // productlist![index].productName!;
                          String description2 = Constants.language == "en"
                              ? "\nDescription: " +
                      companylist![position].description!
                          :companylist![position].arbDescription!
                          .isNotEmpty
                         //     productlist![index].description!
                          //    : productlist![index]
                          //    .arbDescription!
                            //  .isNotEmpty
                              ? "\nالوصف: " +
                      companylist![position].arbDescription!
                           //   productlist![index].arbDescription!
                              : "\nالوصف: " +
                              companylist![position].description!;
                              //productlist![index].description!;
                          String description3 = Constants.language == "en"
                              ? "\nOriginal price: " +
                              companylist![position].price.toString()+
                              //price1.toString() +
                              "\nDiscounted price: " +
                      companylist![position].price.toString()
                              //price2.toString()
                              : "\nالسعر الأصلي: " +
                              companylist![position].price.toString()+
                              //price1.toString() +
                              "\nالسعر بعد التخفيض: " +
                                  companylist![position].price.toString();
                              //price2.toString();
                      Route route = MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            //widget.company_name,
                              companylist![_currentPosition].companyName!,
                              //company_image,
                              company_base_url+companylist![_currentPosition].companyPicture!,
                              Constants.user_id,
                              //branch_id,

                              companylist![_currentPosition].companyId!,
                              product_base_url + companylist![position].picture!,
                              product_details +
                                  description2 +
                                  description3,

                           //   companylist![_currentPosition].description!,
                              "user",
                              "", "0", "0"));
                      Navigator.push(context, route);*/
                    },
                    child: Text(
                      Constants.language == "en" ? "BOOK NOW" : "احجز الآن",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontSize: 18.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2CC0F),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                      fixedSize: Size(width, 30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget transferPointsWidget(double width, double height) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 10.0, right: 12.0),
                      child: Container(
                        width: 85,
                        height: 40,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          color: const Color(0xFFF2CC0F),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0)),
                        ),
                        child: Center(
                          child: Text(
                            Constants.city_code,
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
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
                      left: 225.0,
                    ),
                  ],
                ),
                Container(
                  margin:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Text(
                    Constants.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                  child: Text(
                    Constants.language == "en" ? "Total Points" : "مجمل النقاط",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                  child: Text(
                    total_points,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                  child: Text(
                    Constants.language == "en"
                        ? "The code of the member to whome you want to transfer points"
                        : "رمز العضو الذي تريد تحويل النقاط إليه",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont"),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: TextField(
                    controller: member_code_controller,
                    textCapitalization: TextCapitalization.characters,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white)),
                      hintText: Constants.language == "en"
                          ? "Enter Member Code"
                          : "أدخل رمز العضو",
                      hintStyle: TextStyle(
                        color: Colors.black45,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Text(
                    Constants.language == "en"
                        ? "The number of points to be transferred"
                        : "عدد النقاط المراد تحويلها",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont"),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: TextField(
                    focusNode: Platform.isIOS ? numberFocusNode : null,
                    controller: points_controller,
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white)),
                      hintText: Constants.language == "en"
                          ? "Enter Points to transfer"
                          : "أدخل النقاط للتحويل",
                      hintStyle: TextStyle(
                        color: Colors.black45,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget companyInfoWidget(BuildContext context, double width, double height) {
    return Visibility(
      visible: company_info,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: height * 0.25,
                    viewportFraction: 1.0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPosition = index;
                      });
                    },
                  ),
                  items: bannerList!
                      .map(
                        (e) => ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  if (e.inApp == "true") {
                                    Route route = MaterialPageRoute(
                                        builder: (context) =>
                                            OfferDetailsScreen(
                                                "",
                                                e.companyId!,
                                                "",
                                                "",
                                                "",
                                                "city",
                                                "",
                                                "",
                                                "",
                                                ""));
                                    Navigator.push(context, route);
                                  } else {
                                    if (e.url!.isNotEmpty) {
                                      if (e.url!
                                          .contains("https://instagram.com/")) {
                                        String trimmed_url = e.url!.replaceAll(
                                            "https://instagram.com/", "");
                                        var split_url = trimmed_url.split("?");
                                        String native_url =
                                            "instagram://user?username=${split_url[0]}";
                                        if (await canLaunch(native_url)) {
                                          launch(native_url);
                                        } else {
                                          launch(
                                            e.url!,
                                            universalLinksOnly: true,
                                          );
                                        }
                                      } else {
                                        Route route = MaterialPageRoute(
                                            builder: (context) =>
                                                WebViewScreen("", e.url!));
                                        Navigator.push(context, route);
                                      }
                                    }
                                  }
                                },
                                child: Image(
                                  image:
                                      NetworkImage(banner_base_url + e.banner!),
                                  width: width,
                                  height: height,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                Positioned(
                  bottom: 1.0,
                  left: width * 0.40,
                  right: width * 0.40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(
                      bannerList!,
                      (index, url) {
                        return Container(
                          width: 5.0,
                          height: 5.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPosition == index
                                ? Colors.black
                                : Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  constraints: const BoxConstraints(),
                  iconSize: 30.0,
                  icon: const Icon(CupertinoIcons.location),
                  color: Colors.black,
                  onPressed: () async {
                    if (location.isNotEmpty) {
                      String query = Uri.encodeComponent(location);
                      String googleUrl =
                          "https://www.google.com/maps/search/?api=1&query=$query";
                      if (await canLaunch(googleUrl)) {
                        await launch(googleUrl);
                      }
                    }
                  },
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 30.0,
                  icon: const Icon(Icons.share),
                  color: Colors.black,
                  onPressed: () {
                    Share.share(
                        "Download the CityCode Application from the below link :- https://heylink.me/citycode");
                  },
                ),
              ],
            ),
          ),
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
            child: Text(
              Constants.language == "en"
                  ? "General information about the company"
                  : "معلومات عامة عن الشركة",
              style: TextStyle(
                color: Colors.black,
                fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
              ),
              textAlign:
                  Constants.language == "en" ? TextAlign.left : TextAlign.right,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    width: width,
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0),
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
                                  launch("tel://$phone");
                                }
                              },
                              child: const Image(
                                image: AssetImage("images/phone.png"),
                                width: 35.0,
                                height: 35.0,
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
                                  launch("https://wa.me/$whatsapp");
                                }
                              },
                              child: const Image(
                                image: AssetImage("images/whatsapp.png"),
                                width: 35.0,
                                height: 35.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: email.isNotEmpty ? 1 : 0,
                          child: Visibility(
                            visible: email.isNotEmpty ? true : false,
                            child: InkWell(
                              onTap: () {
                                if (email.isNotEmpty) {
                                  launch("mailto:" + email);
                                }
                              },
                              child: const Image(
                                image: AssetImage("images/mail.png"),
                                width: 35.0,
                                height: 35.0,
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
                                  launch(instagram);
                                }
                              },
                              child: const Image(
                                image: AssetImage("images/insta.png"),
                                width: 35.0,
                                height: 35.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: snapchat.isNotEmpty ? 1 : 0,
                          child: Visibility(
                            visible: snapchat.isNotEmpty ? true : false,
                            child: InkWell(
                              onTap: () {
                                if (snapchat.isNotEmpty) {
                                  launch(snapchat);
                                }
                              },
                              child: const Image(
                                image: AssetImage("images/snapchat.png"),
                                width: 35.0,
                                height: 35.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width,
                    margin: const EdgeInsets.only(
                        top: 20.0, left: 10.0, right: 10.0),
                    child: Text(
                      Constants.language == "en"
                          ? "Inquiry type"
                          : "نوع الاستفسار",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                      ),
                      textAlign: Constants.language == "en"
                          ? TextAlign.left
                          : TextAlign.right,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: suggestion_controller,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.black)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.black)),
                        hintText: Constants.language == "en"
                            ? "Problem / Suggestion here"
                            : "مشكلة / اقتراح هنا",
                        hintStyle: TextStyle(
                          color: Colors.black45,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                      ),
                      maxLines: 5,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    margin: const EdgeInsets.only(
                        left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (suggestion_controller.text.isNotEmpty) {
                          postSubmitData();
                        } else {
                          _alertDialog(Constants.language == "en"
                              ? "Please enter enquiry / suggestion"
                              : "الرجاء إدخال الاستفسار / الاقتراح");
                        }
                      },
                      child: Text(
                        Constants.language == "en" ? "Submit" : "إرسال",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
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
          ),
        ],
      ),
    );
  }
}
