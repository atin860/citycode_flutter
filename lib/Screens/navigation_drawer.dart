// ignore_for_file: avoid_print, unused_field, non_constant_identifier_names

import 'dart:convert';

import 'package:city_code/Screens/CartlistScreenUi.dart';
import 'package:city_code/Screens/contact_us.dart';
import 'package:city_code/Screens/favourite_screen.dart';
import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/Screens/my_points_screen.dart';
import 'package:city_code/Screens/personal_profile.dart';
import 'package:city_code/Screens/protfolio_screen.dart';
import 'package:city_code/Screens/settings_screen.dart';
import 'package:city_code/Screens/vip_code_screen.dart';
import 'package:city_code/Screens/welcome_screen.dart';
import 'package:city_code/Screens/who_we_are_screen.dart';
import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/navigation_model.dart';
import 'package:city_code/models/user_details_model.dart';
import 'package:city_code/models/user_transaction_code_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawers extends StatefulWidget {
  const NavigationDrawers({Key? key}) : super(key: key);

  @override
  _NavigationDrawersState createState() => _NavigationDrawersState();
}

class _NavigationDrawersState extends State<NavigationDrawers> {
  List<NavigationModel> navigationList = [
    NavigationModel("images/home.png",
        Constants.language == "en" ? "Home" : "الصفحة الرئيسية"),
    NavigationModel("images/profile.png",
        Constants.language == "en" ? "Personal profile" : "الملف الشخصي"),
    NavigationModel("images/favorite.png",
        Constants.language == "en" ? "My favourite" : "المفضل لدي"),
    NavigationModel("images/celebrity.png", "VIP code"),
    NavigationModel(
        "images/portfolio.png",
        Constants.language == "en"
            ? "My portfolio"
            : "إجمالي المدخرات"), //أعمالي
    NavigationModel("images/points.png",
        Constants.language == "en" ? "My points" : "نقاطي"),
    // NavigationModel("images/cartlist.png",
    //     Constants.language == "en" ? "Cart List" : "قائمة العربة"),
    // NavigationModel("images/orderlist.png",
    //     Constants.language == "en" ? "My Order" : "نقاطي"),
    NavigationModel("images/setting.png",
        Constants.language == "en" ? "Settings" : "إعدادات"),
    NavigationModel("images/contact.png",
        Constants.language == "en" ? "Contact us" : "اتصل بنا"),
    NavigationModel("images/about_us.png",
        Constants.language == "en" ? "Who we are" : "من نحن"),
    NavigationModel(
        "images/signout.png", Constants.language == "en" ? "Sign out" : "خروج"),
  ];
  int tempindex = 0;
  var vipcode = "";

  List<Userdetail>? demolist = [];
  Future<void> getdata() async {
    String url =
        "http://185.188.127.11/public/index.php/ApiUsers/" + Constants.user_id;
    var network = NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = User_details_model.fromJson(res);

    setState(() {
      demolist = vlist.userdetail!;
      vipcode = demolist![tempindex].vipCode.toString();
    });

    print("user details" + res!.toString());
  }

  late Future<UserTransactionCodeModel> codeModel;
  bool _isLoading = false;

  @override
  void initState() {
    if (demolist != null && demolist!.isNotEmpty) {
      for (int i = 0; i < demolist!.length; i++) {
        setState(() {
          tempindex = i;
          print(demolist);
        });
      }
    }

    getdata();
    super.initState();
  }

  Future<UserTransactionCodeModel> getQrCode(BuildContext context) async {
    final response = await http.get(
      Uri.parse(
          'http://185.188.127.11/public/index.php/TransactionCode?userid=' +
              Constants.user_id),
    );

    var responseServer = jsonDecode(response.body);

    if (kDebugMode) {
      print(responseServer);
    }

    final body = {
      "order_id": "",
      "userid": Constants.user_id,
      "usertransactioncode": "",
      "companyid": "",
      "companyname": "",
      "arb_companyname": "",
      "branchid": "",
      "branchname": "",
      "arb_branchname": "",
      "discount": "",
      "totalamount": "",
      "paidamount": "",
      "usertransactionstatus": ""
    };

    if (kDebugMode) {
      print("JsonBody :- " + jsonEncode(body));
    }

    if (response.statusCode == 201) {
      if (responseServer["status"] == 201) {
        if (kDebugMode) {
          print("data response :- " + responseServer["data"].toString());
        }
        if (responseServer["data"]["usertransactionstatus"] == "true") {
          await _showDialog(
              context,
              jsonEncode(responseServer["data"]).toString(),
              responseServer["data"]["usertransactioncode"]);
        } else {
          await _showDialog(context, jsonEncode(body), "");
        }
        return UserTransactionCodeModel.fromJson(json.decode(response.body));
      } else {
        setState(() {
          _isLoading = false;
        });
        await _showDialog(context, jsonEncode(body), "");

        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      await _showDialog(context, jsonEncode(body), "");
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.70,
      child: Drawer(
        child: Container(
          height: height,
          color: const Color(0xFFF2CC0F),
          child: Column(
            children: [
              Image(
                image: const AssetImage("images/app_icon.png"),
                height: height * 0.20,
              ),
              Text(
                Constants.language == "en" ? "Your Code" : "الكود الخاص بك",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16.0,
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.only(top: 10.0, right: 12.0),
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
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
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
                          left: 87.0,
                        ),
                      ],
                    ),
                    /* IconButton(
                      onPressed: () async {
                        bool result = await InternetConnectionChecker().hasConnection;
                        if (result) {
                          getQrCode(context);
                        } else {
                          final body = {
                            "order_id": "",
                            "userid" : Constants.user_id,
                            "usertransactioncode" : "",
                            "companyid" : "",
                            "companyname" : "",
                            "arb_companyname": "",
                            "branchid": "",
                            "branchname": "",
                            "arb_branchname": "",
                            "discount": "",
                            "totalamount": "",
                            "paidamount": "",
                            "usertransactionstatus": ""
                          };
                          await _showDialog(context, jsonEncode(body), "");
                        }
                      },
                      icon: const Icon(
                        CupertinoIcons.qrcode,
                        size: 50.0,
                      ),
                    ),*/

                    ///my qr code
                    IconButton(
                      onPressed: () async {
                        final dataqr = {
                          "citycodeqr": Constants.city_code,
                          "vipcodeqr": vipcode.toString(),
                        };
                        bool result =
                            await InternetConnectionChecker().hasConnection;
                        if (result) {
                          _ShowDialog(
                              context,
                              jsonEncode(Constants.city_code).toString(),
                              jsonEncode(dataqr).toString());
                          //getQrCode(context);
                        } else {}
                      },
                      icon: const Icon(
                        CupertinoIcons.qrcode,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                height: 1.0,
                color: Colors.black12,
                margin: const EdgeInsets.only(top: 10.0),
              ),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          final pref = await SharedPreferences.getInstance();
                          pref.setBool('fromDrawer', false);
                          if (navigationList[index].title == "Home" ||
                              navigationList[index].title ==
                                  "الصفحة الرئيسية") {
                            Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    HomeScreen("0", ""),
                              ),
                              (route) => false,
                            );
                          } else if (navigationList[index].title ==
                                  "My favourite" ||
                              navigationList[index].title == "المفضل لدي") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const FavouriteScreen(),
                              ),
                            );
                          } else if (navigationList[index].title ==
                              "VIP code") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    VipCodeScreen_2(false, "", "navigation"),
                              ),
                            );
                          } else if (navigationList[index].title ==
                              "My Order") {
                            final pref = await SharedPreferences.getInstance();
                            pref.setBool('fromDrawer', true);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomeScreen('0', ''),
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const OrderListScreen(),
                              ),
                            );
                          } else if (navigationList[index].title ==
                                  "Personal profile" ||
                              navigationList[index].title == "الملف الشخصي") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const PersonalProfileScreen(),
                              ),
                            );
                          } else if /*(navigationList[index].title ==
                              "My portfolio" ||
                              navigationList[index].title == "أعمالي")*/
                              (navigationList[index].title == "My portfolio" ||
                                  navigationList[index].title ==
                                      "إجمالي المدخرات") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const PortfolioScreen(),
                              ),
                            );
                          } else if (navigationList[index].title ==
                                  "My points" ||
                              navigationList[index].title == "نقاطي") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const MyPointsScreen(),
                              ),
                            );
                          } else if (navigationList[index].title ==
                                  "Settings" ||
                              navigationList[index].title == "إعدادات") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const SettingsScreen(),
                              ),
                            );
                          } else if (navigationList[index].title ==
                                  "Contact us" ||
                              navigationList[index].title == "اتصل بنا") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const ContactUsScreen(),
                              ),
                            );
                          } else if (navigationList[index].title ==
                                  "Who we are" ||
                              navigationList[index].title == "من نحن") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const WhoWeAreScreen(),
                              ),
                            );
                          } else if (navigationList[index].title ==
                              "Cart List") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const CartListScreenui(),
                              ),
                            );
                          } else {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content: Text(Constants.language == "en"
                                    ? 'Are you sure you want to sign out?'
                                    : "هل أنت متأكد أنك تريد الخروج؟"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'No');
                                    },
                                    child: Text(
                                      Constants.language == "en" ? 'No' : "لا",
                                      style: TextStyle(
                                          color: const Color(0xFFF2CC0F),
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont"),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      SharedPreferences _prefs =
                                          await SharedPreferences.getInstance();
                                      _prefs.clear();
                                      _prefs.setString(
                                          "language", Constants.language);
                                      Route newRoute = MaterialPageRoute(
                                          builder: (context) =>
                                              const WelcomeScreen());
                                      Navigator.pushAndRemoveUntil(
                                          context, newRoute, (route) => false);
                                    },
                                    child: Text(
                                      Constants.language == "en"
                                          ? 'Yes'
                                          : "نعم",
                                      style: TextStyle(
                                          color: const Color(0xFFF2CC0F),
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont"),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image(
                                image: AssetImage(navigationList[index].image),
                                width: 24.0,
                                height: 24.0,
                              ),
                              Container(
                                child: Text(
                                  navigationList[index].title,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                  ),
                                ),
                                margin: const EdgeInsets.only(
                                    left: 14.0, right: 14.0),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        width: width,
                        height: 1.0,
                        color: Colors.black12,
                      );
                    },
                    itemCount: navigationList.length),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context, String data, String transactionCode) {
    Dialog purchaseDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: SizedBox(
        height: 500,
        child: Column(
          children: <Widget>[
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(),
                  IconButton(
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    icon: const Icon(CupertinoIcons.clear_circled_solid),
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 270,
              child: Text(
                Constants.language == "en"
                    ? "Your transaction code is :"
                    : ": رمز معاملتك هو",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                transactionCode,
                style: const TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: QrImage(
                data: data,
                version: QrVersions.auto,
                size: 320,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Text(
                Constants.language == "en"
                    ? "Your transaction code is valid only for 5 minutes"
                    : "رمز معاملتك صالح لمدة 5 دقائق فقط",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );

    showDialog(
        context: context, builder: (BuildContext context) => purchaseDialog);
  }

  /// my qr code about city code...
  _ShowDialog(BuildContext context, var data, String vipcodedata) {
    Dialog purchaseDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: SizedBox(
        height: 450,
        child: Column(
          children: <Widget>[
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(),
                  IconButton(
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    icon: const Icon(CupertinoIcons.clear_circled_solid),
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            /*SizedBox(
              width: 270,
              child: Text(
                Constants.language == "en"
                    ? "Your transaction code is :"
                    : ": رمز معاملتك هو",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily:
                  Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),*/
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: const Text(
                "",
                // vipcodedata,
                // vipcodedata.toString(),
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: GestureDetector(
                onTap: () {
                  print("databhai:" + data.toString());
                },
                child: QrImage(
                  data: vipcodedata,
                  version: QrVersions.auto,
                  size: 320,
                ),
              ),
            ),
            /*Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Text(
                Constants.language == "en"
                    ? "Your QR code"
                    : "رمز معاملتك صالح لمدة 5 دقائق فقط",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                ),
                textAlign: TextAlign.center,
              ),
            ),*/
          ],
        ),
      ),
    );

    showDialog(
        context: context, builder: (BuildContext context) => purchaseDialog);
  }
}
