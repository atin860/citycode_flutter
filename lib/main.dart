// ignore_for_file: avoid_print, unused_local_variable, must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_import

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:io' show Platform;

import 'package:city_code/Screens/Location_Dashboard_Screen.dart';
import 'package:city_code/Screens/change_language_screen.dart';
import 'package:city_code/Screens/chat_screen.dart';
import 'package:city_code/Screens/demoloco.dart';
import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/Screens/member_code_screen.dart';
import 'package:city_code/models/Location_Notificatio_Model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/upload_receipt_screen.dart';

// receive message when the app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data["details"]);
  // LocalNotificationService.display(message);
}
//const fetchBackground = "fetchBackground";

sendData() async {
  print("raunak");
}

String longitude = '00.00000';
String latitude = '00.00000';
late LocationPermission permission;
late bool serviceEnabled = false;
LocationNotificationModel? model;
/*Future<void> LocationNotification(double lat,double long) async {
  Map<String, String> jsonbody = {
    "userid":Constants.user_id,
    "lat1":lat.toString(),
    "lon1":long.toString(),


  };
  var network = NewVendorApiService();
  String urls =
      "http://cp.citycode.om/public/index.php/latlongnotification";
  var res = await http.post(Uri.parse(urls), body:jsonbody);
  // var res = await network.postresponse(urls, jsonbody);
      model =locationNotificationModelFromJson(res.body);
    String stat = model!.status.toString();
    if(stat.contains("201")){
      print("Succesfully Api");
      var title=model!.data!.title.toString();
      print(title);

    }else{
      print("Not Succesfully");
    }
  Fluttertoast.showToast(
      msg:  res.statusCode.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0);

  print(Constants.user_id);
  print(lat.toString());
  print(long.toString());
  print(res.body);
  print(res.statusCode);
  print("Succesfully");


}*/

Future<void> _getLocation() async {
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      //LocationNotification(position.latitude,position.longitude);
      print("rohanlat" + latitude);
      print("rohanlong" + longitude);
      print("rohanID" + Constants.user_id);
    } else {
      await Geolocator.openLocationSettings();
    }
  } else {
    permission = await Geolocator.requestPermission();
  }
}

const task = "firstTask";

///coment my code
/*void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "firstTask":
        _getLocation();
        //sendData();
        break;
      case Workmanager.iOSBackgroundTask:
        _getLocation();
        break;

    }
    return Future.value(true);
  });
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _getLocation();

  ///here comment
/*await Workmanager().initialize(
  callbackDispatcher,
 isInDebugMode: true,
);

  Workmanager().registerPeriodicTask(
      "1",
      task,
      frequency: Duration(seconds: 5),
      constraints: Constraints(networkType: NetworkType.connected)
  );*/

  late String longitude = '00.00000';
  late String latitude = '00.00000';
  late LocationPermission permission;
  late bool serviceEnabled = false;
  LocationNotificationModel? model;

  ///comenting code published
/*  Future<void> LocationNotification(double lat,double long) async {
    Map<String, String> jsonbody = {
      "userid":Constants.user_id,
      "lat1":lat.toString(),
      "lon1":long.toString(),

    };
    var network = NewVendorApiService();
    String urls =
        "http://cp.citycode.om/public/index.php/latlongnotification";
    var res = await http.post(Uri.parse(urls), body:jsonbody);


    print(Constants.user_id);
    print(lat.toString());
    print(long.toString());
    print(res.body);
    print(res.statusCode);
    print("Succesfully");


  }
  Future<void> _getLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        LocationNotification(position.latitude,position.longitude);
        print("rohanlat"+latitude);
        print("rohanlong"+longitude);
        print("rohanID"+Constants.user_id);
      } else {
        await Geolocator.openLocationSettings();
      }
    } else {
      permission = await Geolocator.requestPermission();
    }
  }
  var period = const Duration(seconds:5);
  Timer.periodic(period,(arg){
    _getLocation();
  });*/

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // systemNavigationBarColor: Color(s.blue),
    statusBarColor: Color(0xFFF2CC0F), // status bar color
  ));
  if (Platform.isIOS) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MaterialApp(
        title: 'City Code',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          // textTheme: TextTheme(
          //   bodyMedium:
          //   TextStyle(
          //     color: Colors.amberAccent,
          //     fontSize: 16.0,
          //     fontWeight: FontWeight.bold,
          //     fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
          //   ),
          // ),
        ),
        home: MyApp("0", "", "", "", "", "", "", "", ""),
      ),
    );
  });
  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  String page,
      company_name,
      company_image,
      sender_id,
      receiver_id,
      select_page,
      sender_image,
      isUserHome,
      isCompanyHome;

  MyApp(
      this.page,
      this.company_name,
      this.company_image,
      this.sender_id,
      this.receiver_id,
      this.select_page,
      this.sender_image,
      this.isUserHome,
      this.isCompanyHome,
      {Key? key})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int notiCount = 0;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _requestPermission() async {
    var settings = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    print('Notification settings: $settings');
  }

  void selectNotification(String? payload) async {
    if (payload != null) {
      final data = jsonDecode(payload);
      print("data:- $data");
      String type = data["notificationtype"];
      bool customerloggedIn = false;
      bool companyloggedIn = false;
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      if (type == "chat") {
        customerloggedIn = _prefs.getBool("isLogged_in") ?? false;
        companyloggedIn = _prefs.getBool("isBranchLoggedin") ?? false;
        if (customerloggedIn) {
          Constants.user_id = _prefs.getString("user_id") ?? "";
          Constants.name = _prefs.getString("name") ?? "";
          Constants.mobile_no = _prefs.getString("mobile") ?? "";
          Constants.city_code = _prefs.getString("city_code") ?? "";
          Constants.interest = _prefs.getString("interest") ?? "";
          Constants.language = _prefs.getString("language") ?? "en";

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Route newRoute = MaterialPageRoute(
                builder: (context) => MyApp(
                    "3",
                    data["company_name"],
                    data["company_image_base_url"] + data["company_logo"],
                    data["receiver_id"],
                    data["sender_id"],
                    "user",
                    "",
                    "1",
                    "0"));
            Navigator.of(context)
                .pushAndRemoveUntil(newRoute, (route) => false);
          });
        } else if (companyloggedIn) {
          Constants.branch_id = _prefs.getString("branch_id") ?? "";
          Constants.branch_name = _prefs.getString("name") ?? "";
          Constants.company_id = _prefs.getString("company_id") ?? "";
          Constants.mobile_no = _prefs.getString("mobile") ?? "";
          Constants.language = _prefs.getString("language") ?? "en";
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Route newRoute = MaterialPageRoute(
                builder: (context) => MyApp(
                    "3",
                    data["customer_name"],
                    data["customer_image_base_url"] + data["customer_image"],
                    data["receiver_id"],
                    data["sender_id"],
                    "company",
                    data["company_image_base_url"] + data["company_logo"],
                    "0",
                    "1"));
            Navigator.of(context)
                .pushAndRemoveUntil(newRoute, (route) => false);
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Route newRoute = MaterialPageRoute(
                builder: (context) =>
                    MyApp("0", "", "", "", "", "", "", "", ""));
            Navigator.of(context)
                .pushAndRemoveUntil(newRoute, (route) => false);
          });
        }
      } else {
        Constants.arb_companyname = data["arb_companyname"].toString();
        Constants.branchid = data["branchid"].toString();
        Constants.image = data["image"].toString();
        Constants.redeempoint = data["redeempoint"].toString();
        Constants.discount = data["discount"].toString();
        Constants.notification_id = data["notification_id"].toString();
        Constants.arb_branchname = data["arb_branchname"].toString();
        Constants.paidamount = data["paidamount"].toString();
        Constants.companyid = data["companyid"].toString();
        Constants.saveamount = data["saveamount"].toString();
        Constants.totalamount = data["totalamount"].toString();
        Constants.companyname = data["companyname"].toString();
        Constants.notificationtype = data["notificationtype"].toString();
        Constants.order_id = data["order_id"].toString();
        Constants.branchname = data["branchname"].toString();
        Constants.city_code = data["user_code"].toString();
        if (type == "user") {
          customerloggedIn = _prefs.getBool("isLogged_in") ?? false;
          if (customerloggedIn) {
            Constants.user_id = _prefs.getString("user_id") ?? "";
            Constants.name = _prefs.getString("name") ?? "";
            Constants.mobile_no = _prefs.getString("mobile") ?? "";
            Constants.city_code = _prefs.getString("city_code") ?? "";
            Constants.interest = _prefs.getString("interest") ?? "";
            Constants.language = _prefs.getString("language") ?? "en";
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Route newRoute = MaterialPageRoute(
                  builder: (context) =>
                      MyApp("1", "", "", "", "", "", "", "", ""));
              Navigator.of(context)
                  .pushAndRemoveUntil(newRoute, (route) => false);
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Route newRoute = MaterialPageRoute(
                  builder: (context) =>
                      MyApp("0", "", "", "", "", "", "", "", ""));
              Navigator.of(context)
                  .pushAndRemoveUntil(newRoute, (route) => false);
            });
          }
        } else if (type == "company") {
          companyloggedIn = _prefs.getBool("isBranchLoggedin") ?? false;
          if (companyloggedIn) {
            Constants.branch_id = _prefs.getString("branch_id") ?? "";
            Constants.branch_name = _prefs.getString("name") ?? "";
            Constants.company_id = _prefs.getString("company_id") ?? "";
            Constants.mobile_no = _prefs.getString("mobile") ?? "";
            Constants.language = _prefs.getString("language") ?? "en";
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Route newRoute = MaterialPageRoute(
                  builder: (context) =>
                      MyApp("2", "", "", "", "", "", "", "", ""));
              Navigator.of(context)
                  .pushAndRemoveUntil(newRoute, (route) => false);
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Route newRoute = MaterialPageRoute(
                  builder: (context) =>
                      MyApp("0", "", "", "", "", "", "", "", ""));
              Navigator.of(context)
                  .pushAndRemoveUntil(newRoute, (route) => false);
            });
          }
        }
      }
    }
  }

  _resetNotiCount() {
    notiCount = 0;
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // xyz(context);
    super.initState();
    _requestPermission();
    // gives the message which user taps and it opened the app from terminate state
    FirebaseMessaging.instance.getInitialMessage().then((message) => {
          if (message != null)
            {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                print(message.data["details"]);
                print("kya ho raha haai" + message.data["details"]);
                final data = jsonDecode(message.data["details"]);
                String type = data["notificationtype"];
                if (type == "chat") {
                  Constants.chat_data = message.data["details"];
                } else {
                  Constants.arb_companyname =
                      data["arb_companyname"].toString();
                  Constants.branchid = data["branchid"].toString();
                  Constants.image = data["image"].toString();
                  Constants.redeempoint = data["redeempoint"].toString();
                  Constants.discount = data["discount"].toString();
                  Constants.notification_id =
                      data["notification_id"].toString();
                  Constants.city_code = data["user_code"].toString();
                  Constants.arb_branchname = data["arb_branchname"].toString();
                  Constants.paidamount = data["paidamount"].toString();
                  Constants.companyid = data["companyid"].toString();
                  Constants.saveamount = data["saveamount"].toString();
                  Constants.totalamount = data["totalamount"].toString();
                  Constants.companyname = data["companyname"].toString();
                  Constants.notificationtype =
                      data["notificationtype"].toString();
                  Constants.order_id = data["order_id"].toString();
                  Constants.branchname = data["branchname"].toString();
                }
              }),
            }
        });

    //work only when app is in Foreground
    FirebaseMessaging.onMessage.listen((message) async {
      print("work only when app is in Foreground");
      print(message.data);
      if (Platform.isAndroid) {
        showNotification(message);
      }
    });

    // Work when the app is in background but opened and user taps on notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      if (notiCount == 0) {
        print(message.data["details"] + "details of: $message");
        final data = jsonDecode(message.data["details"]);
        String type = data["notificationtype"];
        bool customerloggedIn = false;
        bool companyloggedIn = false;
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        if (type == "chat") {
          customerloggedIn = _prefs.getBool("isLogged_in") ?? false;
          companyloggedIn = _prefs.getBool("isBranchLoggedin") ?? false;
          if (customerloggedIn) {
            Constants.user_id = _prefs.getString("user_id") ?? "";
            Constants.name = _prefs.getString("name") ?? "";
            Constants.mobile_no = _prefs.getString("mobile") ?? "";
            Constants.city_code = _prefs.getString("city_code") ?? "";
            Constants.interest = _prefs.getString("interest") ?? "";
            Constants.language = _prefs.getString("language") ?? "en";
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                notiCount = 1;
              });
              Future.delayed(const Duration(seconds: 5), () {
                _resetNotiCount();
              });
              // Get.to(MyApp("3", data["company_name"], data["company_image_base_url"] + data["company_logo"], data["receiver_id"], data["sender_id"], "user", "", "1", "0"));
              Route newRoute = MaterialPageRoute(
                  builder: (context) => MyApp(
                      "3",
                      data["company_name"],
                      data["company_image_base_url"] + data["company_logo"],
                      data["receiver_id"],
                      data["sender_id"],
                      "user",
                      "",
                      "1",
                      "0"));
              Navigator.of(context)
                  .pushAndRemoveUntil(newRoute, (route) => false);
            });
          } else if (companyloggedIn) {
            Constants.branch_id = _prefs.getString("branch_id") ?? "";
            Constants.branch_name = _prefs.getString("name") ?? "";
            Constants.company_id = _prefs.getString("company_id") ?? "";
            Constants.mobile_no = _prefs.getString("mobile") ?? "";
            Constants.language = _prefs.getString("language") ?? "en";
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                notiCount = 1;
              });
              Future.delayed(const Duration(seconds: 5), () {
                _resetNotiCount();
              });
              // Get.to(MyApp("3", data["customer_name"], data["customer_image_base_url"] + data["customer_image"], data["receiver_id"], data["sender_id"], "company", data["company_image_base_url"] + data["company_logo"], "0", "1"));
              Route newRoute = MaterialPageRoute(
                  builder: (context) => MyApp(
                      "3",
                      data["customer_name"],
                      data["customer_image_base_url"] + data["customer_image"],
                      data["receiver_id"],
                      data["sender_id"],
                      "company",
                      data["company_image_base_url"] + data["company_logo"],
                      "0",
                      "1"));
              Navigator.of(context)
                  .pushAndRemoveUntil(newRoute, (route) => false);
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                notiCount = 1;
              });
              Future.delayed(const Duration(seconds: 5), () {
                _resetNotiCount();
              });
              // Get.to(MyApp("0", "", "", "", "", "", "", "", ""));
              Route newRoute = MaterialPageRoute(
                  builder: (context) =>
                      MyApp("0", "", "", "", "", "", "", "", ""));
              Navigator.of(context)
                  .pushAndRemoveUntil(newRoute, (route) => false);
            });
          }
        } else {
          Constants.arb_companyname = data["arb_companyname"].toString();
          Constants.branchid = data["branchid"].toString();
          Constants.image = data["image"].toString();
          Constants.redeempoint = data["redeempoint"].toString();
          Constants.discount = data["discount"].toString();
          Constants.notification_id = data["notification_id"].toString();
          Constants.arb_branchname = data["arb_branchname"].toString();
          Constants.paidamount = data["paidamount"].toString();
          Constants.companyid = data["companyid"].toString();
          Constants.saveamount = data["saveamount"].toString();
          Constants.totalamount = data["totalamount"].toString();
          Constants.companyname = data["companyname"].toString();
          Constants.notificationtype = data["notificationtype"].toString();
          Constants.order_id = data["order_id"].toString();
          Constants.branchname = data["branchname"].toString();
          Constants.city_code = data["user_code"].toString();

          if (type == "user") {
            customerloggedIn = _prefs.getBool("isLogged_in") ?? false;
            if (customerloggedIn) {
              Constants.user_id = _prefs.getString("user_id") ?? "";
              Constants.name = _prefs.getString("name") ?? "";
              Constants.mobile_no = _prefs.getString("mobile") ?? "";
              Constants.city_code = _prefs.getString("city_code") ?? "";
              Constants.interest = _prefs.getString("interest") ?? "";
              Constants.language = _prefs.getString("language") ?? "en";
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                notiCount = 1;

                // setState(() {
                // });
                Future.delayed(const Duration(seconds: 5), () {
                  _resetNotiCount();
                });
                // Get.to(MyApp("1", "", "", "", "", "", "", "", ""));
                if (Platform.isAndroid) {
                  Route newRoute = MaterialPageRoute(
                      builder: (context) => HomeScreen("1", ""));
                  Navigator.of(context)
                      .pushAndRemoveUntil(newRoute, (route) => false);
                }
                if (Platform.isIOS) {
                  Route newRoute = MaterialPageRoute(
                      builder: (context) =>
                          MyApp("1", "", "", "", "", "", "", "", ""));
                  Navigator.of(context)
                      .pushAndRemoveUntil(newRoute, (route) => false);
                }
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  notiCount = 1;
                });
                Future.delayed(const Duration(seconds: 5), () {
                  _resetNotiCount();
                });
                // Get.to(MyApp("0", "", "", "", "", "", "", "", ""));
                Route newRoute = MaterialPageRoute(
                    builder: (context) =>
                        MyApp("0", "", "", "", "", "", "", "", ""));
                Navigator.of(context)
                    .pushAndRemoveUntil(newRoute, (route) => false);
              });
            }
          } else if (type == "company") {
            companyloggedIn = _prefs.getBool("isBranchLoggedin") ?? false;
            if (companyloggedIn) {
              Constants.branch_id = _prefs.getString("branch_id") ?? "";
              Constants.branch_name = _prefs.getString("name") ?? "";
              Constants.company_id = _prefs.getString("company_id") ?? "";
              Constants.mobile_no = _prefs.getString("mobile") ?? "";
              Constants.language = _prefs.getString("language") ?? "en";
              Constants.lang = _prefs.getString("lang") ?? "en";
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  notiCount = 1;
                });
                Future.delayed(const Duration(seconds: 5), () {
                  _resetNotiCount();
                });
                // Get.to(MyApp("2", "", "", "", "", "", "", "", ""));
                Route newRoute = MaterialPageRoute(
                    builder: (context) =>
                        MyApp("2", "", "", "", "", "", "", "", ""));
                Navigator.of(context)
                    .pushAndRemoveUntil(newRoute, (route) => false);
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  notiCount = 1;
                });
                Future.delayed(const Duration(seconds: 5), () {
                  _resetNotiCount();
                });
                // Get.to(MyApp("0", "", "", "", "", "", "", "", ""));
                Route newRoute = MaterialPageRoute(
                    builder: (context) =>
                        MyApp("0", "", "", "", "", "", "", "", ""));
                Navigator.of(context)
                    .pushAndRemoveUntil(newRoute, (route) => false);
              });
            }
          }
        }
      }

      // String type = data["notificationtype"];
      // bool customerloggedIn = false;
      // bool companyloggedIn = false;
      // SharedPreferences _prefs = await SharedPreferences.getInstance();
      //
      // Constants.arb_companyname = data["arb_companyname"].toString();
      // Constants.branchid = data["branchid"].toString();
      // Constants.image = data["image"].toString();
      // Constants.redeempoint = data["redeempoint"].toString();
      // Constants.discount = data["discount"].toString();
      // Constants.notification_id = data["notification_id"].toString();
      // Constants.arb_branchname = data["arb_branchname"].toString();
      // Constants.paidamount = data["paidamount"].toString();
      // Constants.companyid = data["companyid"].toString();
      // Constants.saveamount = data["saveamount"].toString();
      // Constants.totalamount = data["totalamount"].toString();
      // Constants.companyname = data["companyname"].toString();
      // Constants.notificationtype = data["notificationtype"].toString();
      // Constants.order_id = data["order_id"].toString();
      // Constants.branchname = data["branchname"].toString();
      //
      // if (type == "user") {
      //   customerloggedIn = _prefs.getBool("isLogged_in") ?? false;
      //   if (customerloggedIn) {
      //     Constants.user_id = _prefs.getString("user_id") ?? "";
      //     Constants.name = _prefs.getString("name") ?? "";
      //     Constants.mobile_no = _prefs.getString("mobile") ?? "";
      //     Constants.city_code = _prefs.getString("city_code") ?? "";
      //     Constants.interest = _prefs.getString("interest") ?? "";
      //     Constants.language = _prefs.getString("language") ?? "en";
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       // Route newRoute =
      //       // MaterialPageRoute(builder: (context) => MyApp("1"));
      //       // Navigator.of(context)
      //       //     .pushAndRemoveUntil(newRoute, (route) => false);
      //     });
      //   } else {
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       // Route newRoute =
      //       // MaterialPageRoute(builder: (context) => MyApp("0"));
      //       // Navigator.of(context)
      //       //     .pushAndRemoveUntil(newRoute, (route) => false);
      //     });
      //   }
      // } else if (type == "company") {
      //   companyloggedIn = _prefs.getBool("isBranchLoggedin") ?? false;
      //   if (companyloggedIn) {
      //     Constants.branch_id = _prefs.getString("branch_id") ?? "";
      //     Constants.branch_name = _prefs.getString("name") ?? "";
      //     Constants.company_id = _prefs.getString("company_id") ?? "";
      //     Constants.mobile_no = _prefs.getString("mobile") ?? "";
      //     Constants.language = _prefs.getString("language") ?? "en";
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       // Route newRoute =
      //       // MaterialPageRoute(builder: (context) => MyApp("2"));
      //       // Navigator.of(context)
      //       //     .pushAndRemoveUntil(newRoute, (route) => false);
      //     });
      //   } else {
      //     WidgetsBinding.instance?.addPostFrameCallback((_) {
      //       // Route newRoute =
      //       // MaterialPageRoute(builder: (context) => MyApp("0"));
      //       // Navigator.of(context)
      //       //     .pushAndRemoveUntil(newRoute, (route) => false);
      //     });
      //   }
      // }
    });
  }

  late final data;

  void showNotification(RemoteMessage message) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      'ic_stat_name',
    );

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      "city_code",
      "city_code",
      importance: Importance.high,
      priority: Priority.max,
      color: Color(0xFFF2CC0F),
      playSound: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(1, message.notification!.title,
        message.notification!.body, platformChannelSpecifics,
        payload: message.data["details"]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'City Code',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: widget.page == "0"
            ? SplashScreen(null)
            : widget.page == "1"
                ? HomeScreen("1", "")
                : widget.page == "2"
                    ? UploadReceiptScreen(
                        Constants.city_code,
                        Constants.paidamount,
                        Constants.redeempoint,
                        Constants.order_id,
                        Constants.image,
                        Constants.vip_code)
                    : ChatScreen(
                        widget.company_name,
                        widget.company_image,
                        widget.sender_id,
                        widget.receiver_id,
                        "",
                        "",
                        widget.select_page,
                        widget.sender_image,
                        widget.isUserHome,
                        widget.isCompanyHome));
  }
}

class SplashScreen extends StatefulWidget {
  RemoteMessage? message;

  SplashScreen(this.message, {Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  bool customerloggedIn = false;
  bool companyloggedIn = false;

  Future<void> getLogedIn() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (widget.message != null) {
      late final data;
      data = jsonDecode(widget.message!.data["details"]);
      String type = data["notificationtype"];
      bool customerloggedIn = false;
      bool companyloggedIn = false;
      if (type == "chat") {
        Constants.chat_data = widget.message!.data["details"];
        customerloggedIn = _prefs.getBool("isLogged_in") ?? false;
        companyloggedIn = _prefs.getBool("isBranchLoggedin") ?? false;
        if (customerloggedIn) {
          Constants.user_id = _prefs.getString("user_id") ?? "";
          Constants.name = _prefs.getString("name") ?? "";
          Constants.mobile_no = _prefs.getString("mobile") ?? "";
          Constants.city_code = _prefs.getString("city_code") ?? "";
          Constants.interest = _prefs.getString("interest") ?? "";
          Constants.language = _prefs.getString("language") ?? "en";
          Constants.lang = _prefs.getString("lang") ?? "en";
        } else if (companyloggedIn) {
          Constants.branch_id = _prefs.getString("branch_id") ?? "";
          Constants.branch_name = _prefs.getString("name") ?? "";
          Constants.company_id = _prefs.getString("company_id") ?? "";
          Constants.mobile_no = _prefs.getString("mobile") ?? "";
          Constants.language = _prefs.getString("language") ?? "en";
          Constants.lang = _prefs.getString("lang") ?? "en";
        }
      } else {
        Constants.arb_companyname = data["arb_companyname"].toString();
        Constants.branchid = data["branchid"].toString();
        Constants.image = data["image"].toString();
        Constants.redeempoint = data["redeempoint"].toString();
        Constants.discount = data["discount"].toString();
        Constants.notification_id = data["notification_id"].toString();
        Constants.arb_branchname = data["arb_branchname"].toString();
        Constants.paidamount = data["paidamount"].toString();
        Constants.companyid = data["companyid"].toString();
        Constants.saveamount = data["saveamount"].toString();
        Constants.totalamount = data["totalamount"].toString();
        Constants.companyname = data["companyname"].toString();
        Constants.notificationtype = data["notificationtype"].toString();
        Constants.order_id = data["order_id"].toString();
        Constants.branchname = data["branchname"].toString();
        if (type == "user") {
          customerloggedIn = _prefs.getBool("isLogged_in") ?? false;
          if (customerloggedIn) {
            Constants.user_id = _prefs.getString("user_id") ?? "";
            Constants.name = _prefs.getString("name") ?? "";
            Constants.mobile_no = _prefs.getString("mobile") ?? "";
            Constants.city_code = _prefs.getString("city_code") ?? "";
            Constants.interest = _prefs.getString("interest") ?? "";
            Constants.language = _prefs.getString("language") ?? "en";
            Constants.lang = _prefs.getString("lang") ?? "en";
          }
        } else if (type == "company") {
          companyloggedIn = _prefs.getBool("isBranchLoggedin") ?? false;
          if (companyloggedIn) {
            Constants.branch_id = _prefs.getString("branch_id") ?? "";
            Constants.branch_name = _prefs.getString("name") ?? "";
            Constants.company_id = _prefs.getString("company_id") ?? "";
            Constants.mobile_no = _prefs.getString("mobile") ?? "";
            Constants.language = _prefs.getString("language") ?? "en";
            Constants.lang = _prefs.getString("lang") ?? "en";
          }
        }
      }
    } else {
      customerloggedIn = _prefs.getBool("isLogged_in") ?? false;
      if (customerloggedIn) {
        Constants.user_id = _prefs.getString("user_id") ?? "";
        Constants.name = _prefs.getString("name") ?? "";
        Constants.mobile_no = _prefs.getString("mobile") ?? "";
        Constants.city_code = _prefs.getString("city_code") ?? "";
        Constants.interest = _prefs.getString("interest") ?? "";
        Constants.language = _prefs.getString("language") ?? "en";
        Constants.lang = _prefs.getString("lang") ?? "en";
      } else {
        companyloggedIn = _prefs.getBool("isBranchLoggedin") ?? false;
        if (companyloggedIn) {
          Constants.branch_id = _prefs.getString("branch_id") ?? "";
          Constants.branch_name = _prefs.getString("name") ?? "";
          Constants.company_id = _prefs.getString("company_id") ?? "";
          Constants.mobile_no = _prefs.getString("mobile") ?? "";
          Constants.language = _prefs.getString("language") ?? "en";
          Constants.lang = _prefs.getString("lang") ?? "en";
        }
      }
    }
    _userImpression();
  }

  @override
  void initState() {
    super.initState();
  }

  _userImpression() async {
    NetworkCheck networkCheck = NetworkCheck();
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/userimpression?userid=' +
              Constants.user_id));

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print("Splash Screen: $response_server");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var data;
    getLogedIn().then((value) => {
          Timer(const Duration(seconds: 1), () {
            if (Constants.chat_data.isNotEmpty) {
              data = jsonDecode(Constants.chat_data);
            }
            if (customerloggedIn) {
              if (Constants.chat_data.trim().isNotEmpty) {
                Route newRoute = MaterialPageRoute(
                    builder: (context) => ChatScreen(
                        data["company_name"],
                        data["company_image_base_url"] + data["company_logo"],
                        data["receiver_id"],
                        data["sender_id"],
                        "",
                        "",
                        "user",
                        "",
                        "1",
                        "0"));
                Navigator.of(context).pushReplacement(newRoute);
              } else if (Constants.notification_id.isNotEmpty) {
                Route newRoute = MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen("1", Constants.notificationtype));
                Navigator.of(context).pushReplacement(newRoute);
              } else {
                Route newRoute = MaterialPageRoute(
                    builder: (context) => HomeScreen("0", ""));
                Navigator.of(context).pushReplacement(newRoute);
              }
            } else if (companyloggedIn) {
              if (Constants.chat_data.isNotEmpty &&
                  Constants.chat_data != "[]") {
                Route newRoute = MaterialPageRoute(
                    builder: (context) => ChatScreen(
                        data["customer_name"],
                        data["customer_image_base_url"] +
                            data["customer_image"],
                        data["receiver_id"],
                        data["sender_id"],
                        "",
                        "",
                        "company",
                        data["company_image_base_url"] + data["company_logo"],
                        "0",
                        "1"));
                Navigator.of(context).pushReplacement(newRoute);
              } else if (Constants.notification_id.isNotEmpty) {
                Route newRoute = MaterialPageRoute(
                    builder: (context) => UploadReceiptScreen(
                        Constants.city_code,
                        Constants.paidamount,
                        Constants.redeempoint,
                        Constants.order_id,
                        Constants.image,
                        Constants.vip_code));
                Navigator.of(context).pushReplacement(newRoute);
              } else {
                Route newRoute = MaterialPageRoute(
                    builder: (context) => const MemberCodeScreen());
                Navigator.of(context).pushReplacement(newRoute);
              }
            } else {
              Route newRoute = MaterialPageRoute(
                  builder: (context) => ChangeLanguage(false));
              Navigator.of(context).pushReplacement(newRoute);
            }
          }),
          // Timer(
          //   const Duration(seconds: 5),
          //   () => Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(
          //       builder: (BuildContext context) => customerloggedIn
          //           ? Constants.chat_data.isNotEmpty ? ChatScreen(data["company_name"], data["company_image_base_url"] + data["company_logo"], data["receiver_id"], data["sender_id"], "", "", "user", "", "1", "0") : Constants.notification_id.isEmpty
          //               ? HomeScreen("0")
          //               : HomeScreen("1")
          //           : companyloggedIn
          //               ? Constants.chat_data.isNotEmpty ? ChatScreen(data["customer_name"], data["customer_image_base_url"] + data["customer_image"], data["receiver_id"], data["sender_id"], "", "", "company", data["company_image_base_url"] + data["company_logo"], "0", "1") : const MemberCodeScreen()
          //               : ChangeLanguage(false),
          //     ),
          //   ),
          // ),
        });
    return Scaffold(
      body: Center(
        child: Container(
          color: const Color(0xFFF2CC0F),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Image(image: AssetImage("images/app_icon.png")),
            ],
          ),
        ),
      ),
    );
  }
}
