// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_final_fields, unused_field, avoid_print, deprecated_member_use, unnecessary_new, avoid_unnecessary_containers, unused_local_variable, avoid_types_as_parameter_names, prefer_typing_uninitialized_variables, unused_label, unrelated_type_equality_checks, body_might_complete_normally_catch_error, dead_code, unused_element, unnecessary_brace_in_string_interps, unused_import

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart' as badge;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:city_code/Network/network.dart';
import 'package:city_code/Screens/book_now_sceen.dart';
import 'package:city_code/Screens/chat_screen.dart';
import 'package:city_code/Screens/couponhomescreen.dart';
import 'package:city_code/Screens/filter_screen.dart';
import 'package:city_code/Screens/navigation_drawer.dart';
import 'package:city_code/Screens/vip_code_screen.dart';
import 'package:city_code/Screens/web_view_screen.dart';
import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/order_list_model.dart';
import 'package:city_code/models/cartlistcompany_model.dart';
import 'package:city_code/models/cartlistmodel.dart';
import 'package:city_code/models/cartsummerymodel.dart';
import 'package:city_code/models/company_details_model.dart';
import 'package:city_code/models/company_details_model_1.dart';
import 'package:city_code/models/company_list_model.dart';
import 'package:city_code/models/couponlistmodel.dart';
import 'package:city_code/models/deletecart_model.dart';
import 'package:city_code/models/favourite_model.dart';
import 'package:city_code/models/home_banner_model.dart';
//import 'package:city_code/models/new_offers_model.dart';
import 'package:city_code/models/notification_list_model.dart';
import 'package:city_code/models/offers_model.dart';
import 'package:city_code/models/online_shop_model.dart';
import 'package:city_code/models/online_shop_offer_ads_model.dart';
import 'package:city_code/models/qaunttymodel.dart';
import 'package:city_code/models/vip_list_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/date.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_update/in_app_update.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/ads_list_model.dart';
import '../models/advertisement_model.dart';
import '../models/new_offers_model.dart';
import '../models/offer_with_ads_model.dart';
import '../models/offers_list.dart';
import 'CartlistScreenUi.dart';
import 'offer_details_screen.dart';

class HomeScreen extends StatefulWidget {
  String isNotification, type;

  HomeScreen(this.isNotification, this.type, {Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int? initialIndex = 0;
  bool comingFromDrawerToOrder = false;

  String total_notification = "0",
      purchase_notification = "0",
      city_notification = "0",
      company_notification = "0",
      chat_notification = "0";
  bool _isMessage = false;
  late Future<Home_banner_model> home_banner;
  List<Banner_list>? bannerList = [];
  int _currentPosition = 0;
  String banner_base_url = "";
  late TabController _tabController;
  late TabController _tabMessageController;
  NetworkCheck networkCheck = NetworkCheck();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GlobalKey _scaffoldKey = GlobalKey();
  String inapp = "";
  AppUpdateInfo? _updateInfo;
  var companyid = "";
  var branchid = "";
  List<Notification_list>? notificationList = [];
  var company_base_url = "http://cp.citycode.om/public/company/";

  bool _flexibleUpdateAvailable = false;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      // _alertDialog("crossed: 1");
      _updateInfo = info;
      // _alertDialog("new version: ${_updateInfo!.availableVersionCode}");
      if (_updateInfo!.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        // _alertDialog("crossed: 2");
        if (_updateInfo!.flexibleUpdateAllowed) {
          // _alertDialog("crossed flexible: 1");
          InAppUpdate.startFlexibleUpdate().then((_) {
            // _alertDialog("crossed flexible: 2");
            setState(() {
              _flexibleUpdateAvailable = true;
            });
            InAppUpdate.completeFlexibleUpdate().then((_) {
              // _alertDialog("crossed flexible complete: 1");
            }).catchError((e) {
              // _alertDialog("failed flexible complete: 1" + e.toString());
              // print(e.toString());
            });
          }).catchError((e) {
            // _alertDialog("failed flexible: 2" + e.toString());
            // print(e.toString());
          });
        } else {
          // _alertDialog("failed flexible: 1, going intermediate");
          InAppUpdate.performImmediateUpdate()
              .then((value) => {
                    // _alertDialog("crossed initiate: 1"),
                  })
              .catchError((e) {});
        }
      } else {
        // _alertDialog("failed: 2");
      }
    }).catchError((e) {
      // _alertDialog("failed: 1" + e.toString());
      // print(e.toString());
    });
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  comingToOrderFromDrawer() async {
    final pref = await SharedPreferences.getInstance();
    comingFromDrawerToOrder = pref.getBool("fromDrawer") ?? false;
    if (comingFromDrawerToOrder == true) {
      _isMessage = true;
      initialIndex = 4;
      // if (comingFromDrawerToOrder == true) {
      _tabController = TabController(
          length: 7, vsync: this, initialIndex: initialIndex ?? 0);
      _tabMessageController = TabController(
          length: 7, vsync: this, initialIndex: initialIndex ?? 0);
      // }
    } else if (widget.type == 'cartbook') {
      initialIndex = 3;
      _isMessage = true;

      _tabController = TabController(
          length: 7, vsync: this, initialIndex: initialIndex ?? 0);
      _tabMessageController = TabController(
          length: 7, vsync: this, initialIndex: initialIndex ?? 0);
    } else {
      _tabController = TabController(length: 7, vsync: this, initialIndex: 0);
      _tabMessageController =
          TabController(length: 7, vsync: this, initialIndex: 0);
    }
    setState(() {});
  }

  Future<Notification_list_model> _getNotificationList() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/NotificationList?userid=' +
              Constants.user_id));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }

        if (response_server["status"] == 201) {
          return Notification_list_model.fromJson(jsonDecode(response.body));
        } else {
          throw Exception('Failed to load album');
        }
      } else {
        throw Exception('Failed to load album');
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> _getChatCount() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/messagecount?userid=${Constants.user_id}&send_by=user&seenstatus=unseen'));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }

        if (response_server["status"] == 201) {
          if (response_server["messagecount"] == "0") {
            chat_notification = response_server["messagecount"];
          }
        } else {
          throw Exception('Failed to load album');
        }
      } else {
        throw Exception('Failed to load album');
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  var reedim = "";
  var typenotification = "";
  var title = "";
  var text = "";
  var imagebaseurl = "";
  var notificationpicture = "";
  var imageurl = "";
  var companylogo = "";
  _getNotificationCount() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String noti = "0";
    noti = _prefs.getString("total_notification") ?? "0";
    purchase_notification = _prefs.getString("purchase_notification") ?? "0";
    city_notification = _prefs.getString("city_notification") ?? "0";
    company_notification = _prefs.getString("company_notification") ?? "0";
    String chat = _prefs.getString("chat_notification") ?? "0";
    int purchase = 0, city = 0, company = 0, total = 0;
    await _getChatCount();
    _getNotificationList().then((value) => {
          if (value.notificationlist != null &&
              value.notificationlist!.isNotEmpty)
            {
              print("babaaa" + total.toString()),
              title = value.notificationlist![0].title.toString(),
              text = value.notificationlist![0].text.toString(),
              imagebaseurl = value.imageBaseUrl.toString(),
              notificationpicture =
                  value.notificationlist![0].notifyimage.toString(),
              imageurl = value.notificationlist![0].image_url.toString(),
              companylogo = value.notificationlist![0].companyLogo.toString(),
              print("datababa" + title.toString()),
              if (int.parse(noti) <
                  (value.notificationlist!.length +
                      int.parse(chat_notification)))
                {
                  total =
                      (int.parse(value.notificationlist!.length.toString()) +
                          int.parse(chat_notification)),
                  total_notification = total.toString(),
                  _prefs.setString("total_notification",
                      value.notificationlist!.length.toString()),
                  print("babaaa" + total.toString()),
                }
              else
                {
                  total_notification = "0",
                },
              for (int i = 0; i < value.notificationlist!.length; i++)
                {
                  if (value.notificationlist![i].type == "purchase")
                    {
                      purchase++,
                    },
                  if (value.notificationlist![i].type == "city")
                    {
                      typenotification =
                          value.notificationlist![i].type.toString(),
                      reedim =
                          value.notificationlist![i].reddemPoint.toString(),
                      print("dta:::" + reedim),
                      print("title" + title.toString()),
                      city++,
                    },
                  if (value.notificationlist![i].type == "company")
                    {
                      company++,
                    },
                },
              if (int.parse(purchase_notification) < purchase)
                {
                  _prefs.setString(
                      "purchase_notification", purchase.toString()),
                  purchase_notification = purchase.toString(),
                }
              else
                {
                  purchase_notification = "0",
                },
              if (int.parse(city_notification) < city)
                {
                  _prefs.setString("city_notification", city.toString()),
                  city_notification = city.toString(),
                }
              else
                {
                  city_notification = "0",
                },
              if (int.parse(company_notification) < company)
                {
                  _prefs.setString("company_notification", company.toString()),
                  company_notification = company.toString(),
                }
              else
                {
                  company_notification = "0",
                },
              if (int.parse(chat) < int.parse(chat_notification))
                {
                  _prefs.setString("chat_notification", company.toString()),
                }
              else
                {
                  chat_notification = "0",
                }
            }
        });
  }

  int readyindex = 0;

  @override
  void initState() {
    comingToOrderFromDrawer();

    Network().getVersion();
    Network().appVersion(
      Constants.user_id,
    );
    if (widget.type == "cartbook") {
      setState(() {
        _isMessage = true;
      });
    }
    getUserNotificationlist();

    print("Notifications" + widget.isNotification);
    _getNotificationCount();
    // if (comingFromDrawerToOrder == true) {
    _tabController =
        TabController(length: 7, vsync: this, initialIndex: initialIndex ?? 0);
    _tabMessageController =
        TabController(length: 7, vsync: this, initialIndex: initialIndex ?? 0);
    //   setState(() {});
    // } else {
    //   _tabController =
    //       TabController(length: 7, vsync: this, initialIndex: 0 ?? 0);
    //   _tabMessageController =
    //       TabController(length: 7, vsync: this, initialIndex: 0 ?? 0);
    //   setState(() {});
    // }

    home_banner = getHomeBanner();
    home_banner.then((value) => {
          if (value.bannerList != null && value.bannerList!.isNotEmpty)
            {
              bannerList!.clear(),
              for (int i = 0; i < value.bannerList!.length; i++)
                {
                  bannerList!.add(value.bannerList![i]),
                  readyindex = i,
                }
            },
          banner_base_url = value.imageBaseUrl ?? "",
          print("basee uurl" + banner_base_url)
        });
    _firebaseMessaging.getToken().then((value) => {
          print("token:- " + value!),
          update_token(value),
        });
    if (Platform.isAndroid) {
      // _alertDialog("Entered check");
      checkForUpdate();
    }

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabMessageController.dispose();
    super.dispose();
  }

  bool isTablet = false;

  _textMethiodDialog(BuildContext context, int index, double width) async {
    await Future.delayed(const Duration(seconds: 2), () {});
    print("typenotification" + typenotification.toString());

    if (widget.type == "city") {
      print("else condition");

      ///here notificationpop
      _ShowDialog(_scaffoldKey.currentContext!, width);
    } else {
      print("first condition");

      ///here peerchased popup
      if (Platform.isIOS) {
        print("for IOS");
        acceptOffer(Constants.order_id);
        _showDialog(_scaffoldKey.currentContext!, width, index);
      } else {
        print("for ANDROID");
        acceptOffer(Constants.order_id);
        _showDialog(_scaffoldKey.currentContext!, width, index);
      }
    }

    //  _showDialog(_scaffoldKey.currentContext!, width,index);
    // _ShowDialog(_scaffoldKey.currentContext!, width);
    // _ShowDialog(_scaffoldKey.currentContext!, readyindex, width);
  }

  _ShowDialog(BuildContext context, double width) {
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      //this right here
      child: Visibility(
        visible: (int.parse(reedim.isEmpty ? "0" : reedim)) >= 0 ? true : false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          width: MediaQuery.of(context).size.width * 0.90,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        children: [
                          /*notificationList![readyindex].companyLogo!.isNotEmpty
                                              ? CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(company_base_url +
                                                notificationList![readyindex].companyLogo!),
                                          )
                                              :*/
                          companylogo.isNotEmpty
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                      imagebaseurl + companylogo.toString()),
                                )
                              : const Image(
                                  image:
                                      AssetImage("images/circle_app_icon.png"),
                                  width: 70.0,
                                  height: 55.0,
                                ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              //"hello",
                              // widget.which_page == "city" ?
                              //  notificationList![index].title!:
                              /* Constants.language == "en"
                                                  ? notificationList![readyindex].companyName!
                                                  : notificationList![readyindex].companyArbName!,*/
                              Constants.language == "en"
                                  ? title.toString()
                                  : title.toString(),
                              style: TextStyle(
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () async {
                              //  print("company url:"+company_base_url);
                              //   print("image :"+Constants.user_id);
                              //   print("Description::::::"+notificationList![readyindex].text!);
                              //print("imageurl"+image_url);
                              //  print(notification_id);
                              /* if (e.inApp == "true") {
                              Route route = MaterialPageRoute(
                                  builder: (context) =>
                                      OfferDetailsScreen(
                                          "",
                                          e.companyId!,
                                          "",
                                          "",
                                          "",
                                          "city"));
                              Navigator.push(context, route);
                            } else {
                              if (e.url!.isNotEmpty) {
                                if (e.url!.contains(
                                    "https://instagram.com/")) {
                                  String trimmed_url = e.url!
                                      .replaceAll(
                                      "https://instagram.com/",
                                      "");
                                  var split_url =
                                  trimmed_url.split("?");
                                  String native_url =
                                      "instagram://user?username=${split_url[0]}";
                                  if (await canLaunch(
                                      native_url)) {
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
                                          WebViewScreen(
                                              "", e.url!));
                                  Navigator.push(context, route);
                                }
                              }
                            }*/

                              /* String trimmed_url = company_base_url!
                                .replaceAll(
                                "https://instagram.com/",
                                "");
                            var split_url =
                            trimmed_url.split("?");
                            String native_url =
                                "instagram://user?username=${split_url[0]}";
                            print("native url:"+native_url);

                            if (await canLaunch(
                                native_url)) {
                              launch(native_url);
                            } else {
                              // Route route = MaterialPageRoute(
                              //     builder: (context) =>
                              //         WebViewScreen(
                              //             "", company_base_url!));
                              // Navigator.push(context, route);
                              // launch(
                              //   company_base_url,
                              //   universalLinksOnly: true,
                              // );
                            }*/

                              /*if (e.url!.isNotEmpty) {
                              if (company_base_url.contains(
                                  "https://instagram.com/")) {
                                String trimmed_url = company_base_url!
                                    .replaceAll(
                                    "https://instagram.com/",
                                    "");
                                var split_url =
                                trimmed_url.split("?");
                                String native_url =
                                    "instagram://user?username=${split_url[0]}";
                                if (await canLaunch(
                                    native_url)) {
                                  launch(native_url);
                                } else {
                                  launch(
                                    company_base_url,
                                    universalLinksOnly: true,
                                  );
                                }
                              } else {
                                Route route = MaterialPageRoute(
                                    builder: (context) =>
                                        WebViewScreen(
                                            "", company_base_url!));
                                Navigator.push(context, route);
                              }
                            }*/

                              /* if (await canLaunch(url))
                            await launch(url);
                            else
                            // can't launch url, there is some error
                            throw "Could not launch $url";*/
                              /* Route route = MaterialPageRoute(
                                    builder: (context) => OfferDetailsScreen());
                            Navigator.push(context, route);*/
                              // Navigator.push(context,MaterialPageRoute(builder: (context) async =>OfferDetailsScreen));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(
                                  top: 10.0, left: 10.0, right: 10.0),
                              child: Text(
                                //  "hello1",
                                //  notificationList![readyindex].text!,
                                text.toString(),
                                style: TextStyle(
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                ),
                                textAlign: TextAlign.left,
                                //   overflow: TextOverflow.ellipsis,
                                // maxLines:1,
                                //  softWrap: false,
                              ),
                            ),
                          ),

                          //items:bannerList!
                          //  .map((e)
                          GestureDetector(
                            onTap: () async {
                              // String StateUrl = 'View App' ;
                              //   String image=notificationList![readyindex].image_url!;
                              //  String inapp=notificationList![readyindex].companyId!;
                              //  String type=notificationList![readyindex].type!;
                              //  String name=notificationList![readyindex].companyName!;

                              //   const image = "https://www.flutter.io";
                              print("hello");
                              // print(image_url);
                              //   print("imageurl:"+notificationList![readyindex].image_url!);

                              /*  Uri _url = Uri.parse(image);
                                              if (inapp== Constants.company_id || type=="city" ) {
                                                Route route = MaterialPageRoute(
                                                    builder: (context) =>
                                                        OfferDetailsScreen(
                                                            name,
                                                            inapp,
                                                            "",
                                                            "",
                                                            "",
                                                            "city"));
                                                Navigator.push(context, route);
                                              }
                                              else if (await canLaunch(_url.toString())) {
                                                launch(_url.toString());
                                              }*/

                              /* if (image.isNotEmpty||image!= null){
                             if (Platform.isAndroid){
                              if(await canLaunch(image)){
                                launch(image);
                              }
                                   }

                           }
                           else{
                             print("error");

                           }*/

                              /* if (image!.isNotEmpty) {
        if (image!.contains(
            "https://")) {
          String trimmed_url = image!
              .replaceAll(
              "https://",
              "");
          var split_url =
          trimmed_url.split("?");
          String native_url =
              "http://${split_url[0]}";
          print("native url"+native_url);
          if (await canLaunch(
              native_url)) {
            launch(native_url);
          } else {
            launch(
              image!,
              universalLinksOnly: true,
            );
          }
        }
    }*/

                              /*    final url = notificationList![index].image_url!;
                           if()
                           if (await canLaunch(url))
                             await launch(url);
                           else
                             // can't launch url, there is some error
                             throw "Could not launch $url";*/
                              /*if (image.isNotEmpty||image!= null){
                             if (Platform.isAndroid){
                               if(await canLaunch(image)){
                                 launch(image);
                               }
                             }

                           }
                           else{
                             print("error");

                           }*/
                              /*String StateUrl = 'View App' ;
                            var image=notificationList![index].image_url!;
                                try {
                                if(await canLaunch(image)) await launch(image);
                                } catch(e){
                                setState(() {
                                StateUrl = e.toString() ;
                                });
                                throw e;}*/

                              /*if (await canLaunch(image))
                            await launch(image);
                            else
                            // can't launch url, there is some error
                            throw "Could not launch $image";*/

                              //    print(image_url);
                              //  print(userid);
                              /* if (e.inApp == "true") {
                              Route route = MaterialPageRoute(
                                  builder: (context) =>
                                      OfferDetailsScreen(
                                          "",
                                          e.companyId!,
                                          "",
                                          "",
                                          "",
                                          "city"));
                              Navigator.push(context, route);
                            } else {
                              if (e.url!.isNotEmpty) {
                                if (e.url!.contains(
                                    "https://instagram.com/")) {
                                  String trimmed_url = e.url!
                                      .replaceAll(
                                      "https://instagram.com/",
                                      "");
                                  var split_url =
                                  trimmed_url.split("?");
                                  String native_url =
                                      "instagram://user?username=${split_url[0]}";
                                  if (await canLaunch(
                                  native_url)) {
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
                            WebViewScreen(
                            "", e.url!));
                            Navigator.push(context, route);
                            }
                          }
                          }*/
                            },
                            child: Visibility(
                              visible: notificationpicture.isNotEmpty
                                  //notificationList![readyindex].notifyimage!.isNotEmpty
                                  ? true
                                  : false,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, top: 10.0),
                                /* child: Image(
                                                  image: NetworkImage(company_base_url +
                                                      notificationList![readyindex].notifyimage!),
                                                ),*/
                                child: Image(
                                  image: NetworkImage(imagebaseurl +
                                      notificationpicture.toString()),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 10.0, top: 30),
                      height: 35.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text(
                          Constants.language == "en" ? "CLOSE" : "أستمرار",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont",
                            fontSize: 18.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF2CC0F),
                          textStyle: const TextStyle(color: Color(0xFFF2CC0F)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            // side: const BorderSide(
                            //   color: Colors.black,
                            //   width: 1.0,
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                /*    Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:<Widget>[
              Container(
              margin:
              const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          height: 35.0,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text(
              Constants.language == "en" ? "CLOSE" : "أستمرار",
              style: TextStyle(
                color: Colors.black,
                fontFamily:
                Constants.language == "en" ? "Roboto" : "GSSFont",
                fontSize: 18.0,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFFF2CC0F),
              textStyle: const TextStyle(color: Color(0xFFF2CC0F)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                // side: const BorderSide(
                //   color: Colors.black,
                //   width: 1.0,
                // ),
              ),
            ),
          ),
        ),
                  ]
              ),*/
              ],
            ),
          ),
        ),
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  int count = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // if (comingFromDrawerToOrder == true && count == 0 && _isMessage == true) {
    //   count++;
    //   _tabController = TabController(length: 7, vsync: this, initialIndex: 4);
    //   _tabMessageController =
    //       TabController(length: 7, vsync: this, initialIndex: 4);
    //   // setState(() {});
    // } else {
    //   _tabController = TabController(length: 7, vsync: this, initialIndex: 0);
    //   _tabMessageController =
    //       TabController(length: 7, vsync: this, initialIndex: 0);
    // }
    if (widget.isNotification == "1") {
      setState(() {
        widget.isNotification = "0";
      });
      // Navigator.push(context, http.MaterialPageRoute(builder: (context)=>NotificationListScreen("chats")));
      _textMethiodDialog(context, readyindex, width);
    }
    return Directionality(
      textDirection:
          Constants.language == "en" ? TextDirection.ltr : TextDirection.rtl,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          key: _scaffoldKey,
          // backgroundColor: Colors.teal,
          backgroundColor: const Color(0xFFF2CC0F),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF2CC0F),
            flexibleSpace: SafeArea(
              child: InkWell(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => const FilterScreen());
                  Navigator.push(context, route);
                },
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 6.0),
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(
                          top: 8.0, left: 50.0, right: 50.0, bottom: 8.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: const Icon(
                        CupertinoIcons.search,
                        color: Colors.black,
                      ),
                    ),
                    // Center(
                    //   child: Container(
                    //       child: Text(
                    //     Constants.skip == "1"
                    //         ? "Select Location"
                    //         : 'Delivering to ' + Constants.nameOfusers,
                    //     style: const TextStyle(
                    //         color: Colors.grey,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 16),
                    //   )),
                    // )
                  ],
                ),
              ),
            ),
            actions: [
              Visibility(
                visible: !_isMessage,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (_isMessage) {
                        _isMessage = false;
                      } else {
                        _isMessage = true;
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 12.0, top: 8.0, bottom: 5.0, left: 12.0),
                    child: badge.Badge(
                      shape: badge.BadgeShape.square,
                      showBadge: total_notification == "0" ? false : true,
                      badgeContent: Text(
                        total_notification,
                        style: const TextStyle(color: Colors.white),
                      ),
                      child: const Image(
                        image: AssetImage("images/messenger_icon.png"),
                        width: 30.0,
                        height: 30.0,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _isMessage,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.home),
                  color: Colors.black,
                  onPressed: () async {
                    comingFromDrawerToOrder = false;
                    final pref = await SharedPreferences.getInstance();
                    pref.setBool("fromDrawer", false);

                    if (_isMessage) {
                      setState(() {
                        _isMessage = false;
                      });
                    }
                    comingToOrderFromDrawer();
                    widget.type = '';
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          drawer: const NavigationDrawers(),
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                            autoPlayAnimationDuration:
                                const Duration(seconds: 1),
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
                                          print("url:" + e.url!);
                                          inapp = e.inApp.toString();
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
                                              if (e.url!.contains(
                                                  "https://instagram.com/")) {
                                                String trimmed_url = e.url!
                                                    .replaceAll(
                                                        "https://instagram.com/",
                                                        "");
                                                var split_url =
                                                    trimmed_url.split("?");
                                                String native_url =
                                                    "instagram://user?username=${split_url[0]}";
                                                print(
                                                    "native ulr:" + native_url);
                                                if (await canLaunch(
                                                    native_url)) {
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
                                                        WebViewScreen(
                                                            "", e.url!));
                                                Navigator.push(context, route);
                                              }
                                            }
                                          }
                                          bannercall(int.parse(
                                              bannerList![_currentPosition]
                                                  .bannerId!));

                                          print("call::::::");
                                          print(bannercall);
                                        },
                                        child: Image(
                                          image: NetworkImage(
                                              banner_base_url + e.banner!),
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
                  Visibility(
                    visible: !_isMessage,
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 1.0, right: 1.0),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 5.0),
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: InkWell(
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          const FilterScreen());
                                  Navigator.push(context, route);
                                },
                                child: const Image(
                                  image: AssetImage("images/filter.png"),
                                  width: 27.0,
                                  height: 27.0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: width * 0.883,
                            margin: const EdgeInsets.only(
                                left: 3.0, right: 0.0), //chg
                            child: DefaultTabController(
                              length: 7,
                              child: Column(
                                children: [
                                  TabBar(
                                    onTap: (value) {
                                      setState(() {});
                                    },
                                    isScrollable: true,
                                    indicatorColor: Colors.black,
                                    controller: _tabController,
                                    labelColor: Colors.black,
                                    unselectedLabelColor: Colors.black,
                                    tabs: [
                                      Tab(
                                        child: Text(
                                          Constants.language == "en"
                                              ? "Public Offers"
                                              : "العروض العامة",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont"),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          Constants.language == "en"
                                              ? "Coupon Offers"
                                              : "كوبونات",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont"),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          Constants.language == "en"
                                              ? "Yellow Friday"
                                              : "الجمعة الصفراء",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont"),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          Constants.language == "en"
                                              ? "VIP Code"
                                              : "VIP Code",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont"),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          Constants.language == "en"
                                              ? "New Offers"
                                              : "التخفيضات الجديدة",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont"),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          Constants.language == "en"
                                              ? "Online Shop"
                                              : "تسوق اونلاين",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont"),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          Constants.language == "en"
                                              ? "Support Local"
                                              : "ادعم المحلي",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isMessage,
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 1.0, right: 1.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.95,
                            margin: const EdgeInsets.only(left: 4.0),
                            child: DefaultTabController(
                              length: 7,
                              child: Column(
                                children: [
                                  TabBar(
                                    onTap: (value) {
                                      setState(() {});
                                    },
                                    isScrollable: true,
                                    indicatorColor: Colors.black,
                                    controller: _tabMessageController,
                                    labelColor: Colors.black,
                                    unselectedLabelColor: Colors.black,
                                    tabs: [
                                      Tab(
                                        child: Container(
                                          child: badge.Badge(
                                            showBadge:
                                                purchase_notification == "0"
                                                    ? false
                                                    : true,
                                            shape: badge.BadgeShape.square,
                                            position:
                                                badge.BadgePosition.topEnd(
                                                    top: -15, end: -19),
                                            badgeContent: Text(
                                              purchase_notification,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            child: Text(
                                              Constants.language == "en"
                                                  ? "Notification"
                                                  : "إشعارات",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      Constants.language == "en"
                                                          ? "Roboto"
                                                          : "GSSFont"),
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 0.1, right: 0.1),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          Constants.language == "en"
                                              ? "Coupons"
                                              : "كوبونات",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont"),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 1.0, right: 1.0),
                                          child: badge.Badge(
                                            shape: badge.BadgeShape.square,
                                            position:
                                                badge.BadgePosition.topEnd(
                                                    top: -15, end: -19),
                                            showBadge: city_notification == "0"
                                                ? false
                                                : true,
                                            badgeContent: Text(
                                              city_notification,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13.0),
                                            ),
                                            child: Text(
                                              Constants.language == "en"
                                                  ? "CityCode"
                                                  : "ستي كود",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      Constants.language == "en"
                                                          ? "Roboto"
                                                          : "GSSFont"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Tab(
                                      //   child: Text(
                                      //     Constants.language == "en"
                                      //         ? "Cart List"
                                      //         : "قائمة عربة التسوق",
                                      //     textAlign: TextAlign.center,
                                      //     style: TextStyle(
                                      //         fontSize: 14,
                                      //         fontWeight: FontWeight.bold,
                                      //         fontFamily:
                                      //             Constants.language == "en"
                                      //                 ? "Roboto"
                                      //                 : "GSSFont"),
                                      //   ),
                                      // ),
                                      // Tab(
                                      //   child: Text(
                                      //     Constants.language == "en"
                                      //         ? "My Orders"
                                      //         : "قائمة عربة التسوق",
                                      //     textAlign: TextAlign.center,
                                      //     style: TextStyle(
                                      //         fontSize: 14,
                                      //         fontWeight: FontWeight.bold,
                                      //         fontFamily:
                                      //             Constants.language == "en"
                                      //                 ? "Roboto"
                                      //                 : "GSSFont"),
                                      //   ),
                                      // ),
                                      Tab(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 1.0, right: 1.0),
                                          child: badge.Badge(
                                            shape: badge.BadgeShape.square,
                                            showBadge: chat_notification == "0"
                                                ? false
                                                : true,
                                            position:
                                                badge.BadgePosition.topEnd(
                                                    top: -15, end: -19),
                                            badgeContent: Text(
                                              chat_notification,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            ),
                                            child: Text(
                                              Constants.language == "en"
                                                  ? "Chats"
                                                  : "الدردشات",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      Constants.language == "en"
                                                          ? "Roboto"
                                                          : "GSSFont"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 1.0, right: 1.0),
                                          child: badge.Badge(
                                            shape: badge.BadgeShape.square,
                                            showBadge:
                                                company_notification == "0"
                                                    ? false
                                                    : true,
                                            position:
                                                badge.BadgePosition.topEnd(
                                                    top: -15, end: -19),
                                            badgeContent: Text(
                                              company_notification,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            ),
                                            child: Text(
                                              Constants.language == "en"
                                                  ? "Companies"
                                                  : "شركات",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      Constants.language == "en"
                                                          ? "Roboto"
                                                          : "GSSFont"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

//jvihf p7tqit50r72y5p9yauyu yrg4ue4 rguy4tgegr4yugeyeguhgrhjguhdbguhhreguiugyheun 3583pt5 345t3879  Screen visib;e from here

                  Visibility(
                    visible: !_isMessage,
                    child: Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          OffersScreen("city"),
                          OffersScreen("coupon"),
                          OffersScreen("friday"),
                          const VipCodeScreen(),
                          OffersScreen("new"),
                          const OnlineShopScreen(),
                          OffersScreen("homebusiness"),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isMessage,
                    child: Expanded(
                      child: TabBarView(
                        controller: _tabMessageController,
                        children: [
                          NotificationListScreen("purchase"),
                          Couponsshowscreen(
                            companyid: companyid,
                            branchid: branchid,
                          ),
                          NotificationListScreen("city"),
                          // const CartListScreenui(),
                          //   const CartlistScreen(),
                          //My orders
                          // const OrderListScreen(),
                          NotificationListScreen("chats"),
                          NotificationListScreen("company"),
                          // Horizontalline(companyid: companyid, branchid: branchid),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Visibility(
              //   visible: _isLoading,
              //   child: Center(
              //     child: Container(
              //       color: Colors.white,
              //       padding: const EdgeInsets.all(10.0),
              //       child: const CircularProgressIndicator(
              //         color: Color(0xFFF2CC0F),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context, double width, int index) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            //this right here
            child: SizedBox(
              height: 550,
              width: width,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      SizedBox(
                        height: 90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(),
                            IconButton(
                              iconSize: 30.0,
                              onPressed: () {
                                print("namebhai" +
                                    notificationListHome![index].companyName!);
                                Constants.arb_companyname = "";
                                Constants.branchid = "";
                                Constants.image = "";
                                Constants.redeempoint = "";
                                Constants.discount = "";
                                Constants.notification_id = "";
                                Constants.arb_branchname = "";
                                Constants.paidamount = "";
                                Constants.companyid = "";
                                Constants.saveamount = "";
                                Constants.totalamount = "";
                                Constants.companyname = "";
                                Constants.notificationtype = "";
                                Constants.order_id = "";
                                Constants.branchname = "";
                                Navigator.of(dialogContext, rootNavigator: true)
                                    .pop();
                              },
                              icon: const Icon(
                                  CupertinoIcons.clear_circled_solid),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 96,
                        top: 10.0,
                        right: 96,
                        child: Center(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 20.0, right: 12.0),
                                child: Container(
                                  width: width * 0.25,
                                  height: 45,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2CC0F),
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
                                  )),
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  width: 30,
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
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                                bottom: 24.0,
                                left: 77.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      Constants.language == "en"
                          ? "About to take advantage of discounts"
                          : "على وشك الاستفاده من خصومات",
                      style: TextStyle(
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      Constants.language == "en"
                          ? Constants.companyname
                          : Constants.arb_companyname.isNotEmpty
                              ? Constants.arb_companyname
                              : Constants.companyname,
                      style: TextStyle(
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      Constants.language == "en"
                          ? Constants.branchname
                          : Constants.arb_branchname.isNotEmpty
                              ? Constants.arb_branchname
                              : Constants.branchname,
                      style: TextStyle(
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 220.0,
                    margin: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2CC0F),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                notificationListHome![index]
                                            .coupontype
                                            .toString() ==
                                        "coupon"
                                    ? Constants.language == "en"
                                        ? "Coupon Amount"
                                        : "الخصم"
                                    : Constants.language == "en"
                                        ? "Discount"
                                        : "الخصم",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  notificationListHome![index]
                                              .coupontype
                                              .toString() ==
                                          "coupon"
                                      ? Constants.discount
                                      : Constants.discount + "%",
                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          height: 1.0,
                          color: Colors.black,
                        ),
                        Visibility(
                          visible:
                              (int.parse(reedim.isEmpty ? "0" : reedim)) >= 0
                                  ? false
                                  : true,
                          /*Visibility(
                          visible: int.parse(Constants.redeempoint) > 0
                              ? false
                              : true,*/
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                child: Column(
                                  children: [
                                    Text(
                                      Constants.language == "en"
                                          ? "Amount Before Discount"
                                          : "المبلغ قبل الخصم",
                                      style: TextStyle(
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        Constants.totalamount,
                                        style: const TextStyle(
                                            fontFamily: "Roboto"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                height: 1.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        notificationListHome![index].coupontype.toString() ==
                                "coupon"
                            ? Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          Constants.language == "en"
                                              ? "Purchasing Amount"
                                              : "المبلغ قبل الخصم",
                                          style: TextStyle(
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont",
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            Constants.totalamount,
                                            style: const TextStyle(
                                                fontFamily: "Roboto"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    height: 1.0,
                                    color: Colors.black,
                                  ),
                                ],
                              )
                            : Container(),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                Constants.language == "en"
                                    ? "Amount To Pay"
                                    : "المبلغ للدفع",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  Constants.paidamount,
                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          height: 1.0,
                          color: Colors.black,
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Text(
                                Constants.language == "en"
                                    ? "Use Points"
                                    : "استخدم النقاط",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  Constants.redeempoint,
                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 20.0),
                    child: Text(
                      Constants.language == "en"
                          ? "Payment Succesfully."
                          : "نجاح الدفع.",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 20.0),
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        Constants.language == "en" ? "Done" : "قبول",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                          fontSize: 18.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFF2CC0F),
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

                  /// comenting
                  /*Container(
                    margin: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 20.0),
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        bool isSuccess = await acceptOffer(Constants.order_id);
                        Constants.arb_companyname = "";
                        Constants.branchid = "";
                        Constants.image = "";
                        Constants.redeempoint = "";
                        Constants.discount = "";
                        Constants.notification_id = "";
                        Constants.arb_branchname = "";
                        Constants.paidamount = "";
                        Constants.companyid = "";
                        Constants.saveamount = "";
                        Constants.totalamount = "";
                        Constants.companyname = "";
                        Constants.notificationtype = "";
                        Constants.order_id = "";
                        Constants.branchname = "";
                        if (isSuccess) {
                          Navigator.of(dialogContext, rootNavigator: true)
                              .pop();
                        }
                      },
                      child: Text(
                        Constants.language == "en" ? "Accepts" : "قبول",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                          fontSize: 18.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF2CC0F),
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
                  ),*/
                ],
              ),
            ),
          );
        });
  }

  var coupontype = "r";
  int tindex = 0;
  List<Notification_list>? notificationListHome = [];
  Future<void> getUserNotificationlist() async {
    String url =
        "http://185.188.127.11/public/index.php/NotificationList?userid=" +
            Constants.user_id;
    var network = new NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = Notification_list_model.fromJson(res);
    var stat = vlist.status.toString();
    notificationListHome = vlist.notificationlist!;
    setState(() {});
    /* for(var data in notificationListHome! ){
      coupontype=data.companyName!;
    }*/
    if (vlist.notificationlist != null && vlist.notificationlist!.isNotEmpty) {
      notificationListHome = vlist.notificationlist!;
      print("hereone");
      for (int i = 0; i < notificationListHome!.length; i++) {
        setState(() {
          print("heretwo");
          tindex = i;
          //couponlist();
          // print("datff"+couponamount);
        });
      }
    }

    print("rohan");
    print("companydetailsrrs" + res!.toString());
    coupontype = notificationListHome![tindex].companyName.toString();
    print("namecoupon" + coupontype.toString());
    /* if(stat.contains("201")){

      // totalamount=couponreportlist![index].couponAmount!;
      print(notificationListHome);

      print("okkkk");
     */ /* if (notificationListHome != null && notificationListHome!.length > 0)
      {
        for (int i = 0; i < notificationListHome!.length; i++)
        {
          coupontype=notificationListHome![i].companyName.toString();
        //  tindex=i;
        }

    }*/ /*
      coupontype=notificationListHome![tindex].companyName.toString();
      for(var data in notificationListHome! ) {

        coupontype=data.coupontype.toString();



      }
      print("coupontype"+coupontype.toString());
    }*/
  }

  Future<bool> acceptOffer(String order_id) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "od_id": order_id,
        "status": "true",
        "notificationtype": "company"
      };

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/accept'),
        body: body,
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 201) {
        if (response_server["status"] == 201) {
          if (Constants.language == "en") {
            _alertDialog("Offer Accepted");
          } else {
            _alertDialog("تم القبول");
          }
          return true;
        } else {
          if (Constants.language == "en") {
            _alertDialog("Failed to accept offer");
          } else {
            _alertDialog("فشل قبول العرض");
          }
          return false;
        }
      } else {
        if (response.statusCode == 404) {
          if (Constants.language == "en") {
            _alertDialog("Failed to accept offer");
          } else {
            _alertDialog("فشل قبول العرض");
          }
        } else {
          if (Constants.language == "en") {
            _alertDialog("Something went wrong");
          } else {
            _alertDialog("هناك خطأ ما");
          }
        }
        return false;
      }
    } else {
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      return false;
    }
  }

  Future<void> update_token(String token) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {"mobileno": Constants.mobile_no, "android_token": token};

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/updatetoken'),
        body: body,
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 201) {
        if (response_server["status"] == 201) {
        } else {
          throw Exception('Failed to load album');
        }
      } else {
        throw Exception('Failed to load album');
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Home_banner_model> getHomeBanner() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
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
        if (Constants.language == "en") {
          _alertDialog("Something went wrong");
        } else {
          _alertDialog("هناك خطأ ما");
        }
        throw Exception('Failed to load album');
      }
    } else {
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

  Future bannercall(int bannerId) async {
    final body = {
      "bannerId": bannerId,
    };

    final response = await http.get(
      Uri.parse('http://185.188.127.11/public/index.php/bannercount?bannerId=' +
          bannerId.toString()),
    );
    print("respose:::::");
    print(response);
  }
}

class OffersScreen extends StatefulWidget {
  String coupon_type;

  OffersScreen(this.coupon_type, {Key? key}) : super(key: key);

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  bool _isLoading = true, _isPaginationLoading = false;
  late Future<Offers_model> public_offers = _getPublicOffers();
  late Future<Favourite_model> favourite_offers = _getFavouriteOffers();
  List<OffersListModel>? offersList = [];
  List<OffersListModel>? offersList_ads = [];
  List<Favouratelist>? favList = [];
  List<OfferAdsModel> offerads_model = [];
  List<AdsListModel> adsList = [];
  String company_image_base_url = "";
  String ads_image_base_url = "";
  NetworkCheck networkCheck = NetworkCheck();
  int _pageSize = 0, page = 1, maxPage = 0;
  var scrollcontroller = ScrollController();

  var coupondata = "";
  Future bannercount(int bannerId) async {
    final body = {
      "bannerId": bannerId,
    };

    final response = await http.get(
      Uri.parse(
          'http://185.188.127.11/public/index.php/countviewbanner?add_id=' +
              bannerId.toString()),
    );
    print("respose:::::");
    print(response);
  }

  Future<Offers_model> _getPublicOffers() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      if (widget.coupon_type == "friday") {
        var date = DateTime.now();
        if (date.weekday == DateTime.thursday ||
            date.weekday == DateTime.friday) {
          final response = await http.get(Uri.parse(
              'http://185.188.127.11/public/index.php/ApiOffers?coupon_type=' +
                  widget.coupon_type));
          print("respense::::;;");
          if (response.statusCode == 201) {
            var response_server = jsonDecode(response.body);

            if (kDebugMode) {
              print(response_server);
            }
            if (response_server["status"] == 201) {
              return Offers_model.fromJson(jsonDecode(response.body));
            } else {
              setState(() {
                _isLoading = false;
              });
              throw Exception('Failed to load album');
              print("respense::::;;");
            }
          } else {
            setState(() {
              _isLoading = false;
            });
            throw Exception('Failed to load album');
            print("respense::::;;");
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          throw Exception('Failed to load album');
        }
      } else {
        final response = await http.get(Uri.parse(
            'http://185.188.127.11/public/index.php/ApiOffers?coupon_type=' +
                widget.coupon_type));
        if (response.statusCode == 201) {
          var response_server = jsonDecode(response.body);

          if (kDebugMode) {
            print(response_server);
          }

          if (response_server["status"] == 201) {
            return Offers_model.fromJson(jsonDecode(response.body));
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
          if (response.statusCode == 404) {
            if (Constants.language == "en") {
              _alertDialog("No Offers Available");
            } else {
              _alertDialog("لا توجد عروض متاحة");
            }
          } else {
            if (Constants.language == "en") {
              _alertDialog("Something went wrong");
            } else {
              _alertDialog("هناك خطأ ما");
            }
          }
          throw Exception('Failed to load album');
          print("respense::::;;");
        }
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

  Future<NewOffersModel> _getNewOffers(int pageKey) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      if (widget.coupon_type == "friday") {
        var date = DateTime.now();
        if (date.weekday == DateTime.thursday ||
            date.weekday == DateTime.friday) {
          //  final response = await http.get(Uri.parse(
          //  'http://185.188.127.11/public/index.php/ApiOffers?coupon_type=' +
          //    widget.coupon_type));
          // print(widget.coupon_type);
          //  print(pageKey);
          final response = await http.get(Uri.parse(
              "http://185.188.127.11/public/index.php/apigetoffers?coupon_type=${widget.coupon_type}&page=$pageKey"));

          /*final response = await http.get(Uri.parse(
              "http://185.188.127.11/public/index.php/apigetoffers?coupon_type=${widget.coupon_type}&page=$pageKey"));*/
          print(response);
          if (response.statusCode == 201) {
            var response_server = jsonDecode(response.body);

            if (kDebugMode) {
              print(response_server);
            }
            if (response_server["status"] == 201) {
              print("executed");
              return NewOffersModel.fromJson(jsonDecode(response.body));
              // return Offers_model.fromJson(jsonDecode(response.body));
              print("page");
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
          throw Exception('Failed to load album');
        }
      } else {
        final response = await http.get(Uri.parse(
            "http://185.188.127.11/public/index.php/apigetoffers?coupon_type=${widget.coupon_type}&page=$pageKey&userid=${Constants.user_id}"));
        if (response.statusCode == 201) {
          var response_server = jsonDecode(response.body);

          if (kDebugMode) {
            print(response_server);
          }

          if (response_server["status"] == 201) {
            print("page" + pageKey.toString());
            return NewOffersModel.fromJson(jsonDecode(response.body));
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
          if (response.statusCode == 404) {
            if (Constants.language == "en") {
              print("copounsss" + widget.coupon_type);
              _alertDialog("No Offers Available..");
            } else {
              _alertDialog("لا توجد عروض متاحة");
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

  Future<AdvertisementModel> _getAds() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(
          Uri.parse('http://185.188.127.11/public/index.php/getdashboardadd'));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
          return AdvertisementModel.fromJson(jsonDecode(response.body));
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

  Future<Favourite_model> _getFavouriteOffers() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/ApiFavorate?customer_id=' +
              Constants.user_id));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
          return Favourite_model.fromJson(jsonDecode(response.body));
        } else {
          int count = 0;
          int n = 0, a = 0;
          // _getPublicOffers().then((value) => {
          //       if (value.offers != null && value.offers!.length > 0)
          //         {
          //           for (int i = 0; i < value.offers!.length; i++)
          //             {
          //               if (value.offers![i].companyId! != "173")
          //                 {
          //                   offersList!.add(OffersListModel(
          //                       value.offers![i].id!,
          //                       value.offers![i].companyId!,
          //                       value.offers![i].branchId!,
          //                       value.offers![i].couponType!,
          //                       value.offers![i].companyDiscount!,
          //                       value.offers![i].comission!,
          //                       value.offers![i].customerDiscount!,
          //                       value.offers![i].discountDetail!,
          //                       value.offers![i].description!,
          //                       value.offers![i].arbDescription!,
          //                       value.offers![i].startDate!,
          //                       value.offers![i].endDate!,
          //                       value.offers![i].timing!,
          //                       value.offers![i].onlineLink!,
          //                       value.offers![i].playstoreLink!,
          //                       value.offers![i].iosLink!,
          //                       value.offers![i].huawaiLink!,
          //                       value.offers![i].priority!,
          //                       value.offers![i].priorityStart!,
          //                       value.offers![i].priorityEnd!,
          //                       value.offers![i].hMobileNo!,
          //                       value.offers![i].hWhatsappNo!,
          //                       value.offers![i].hInstagram!,
          //                       value.offers![i].hEmail!,
          //                       value.offers![i].hLocation!,
          //                       value.offers![i].hArabLocation!,
          //                       value.offers![i].hImage!,
          //                       value.offers![i].mall!,
          //                       value.offers![i].mallName!,
          //                       value.offers![i].mallNameArabic!,
          //                       value.offers![i].custmise!,
          //                       value.offers![i].offerNameCust!,
          //                       value.offers![i].offerNameCustArabic!,
          //                       value.offers![i].discountdisplay!,
          //                       value.offers![i].companyName!,
          //                       value.offers![i].companyArbName!,
          //                       value.offers![i].displayName!,
          //                       value.offers![i].displayArbName!,
          //                       value.offers![i].companylogo!,
          //                       value.offers![i].viewCount!,
          //                       value.offers![i].category!,
          //                       value.offers![i].discountEnDetail!,
          //                       value.offers![i].discountArbDetail!,
          //                       value.offers![i].userFav!,
          //                       value.offers![i].customerId!,
          //                       value.offers![i].remainingday!,
          //                       value.offers![i].remaininghours!,
          //                       value.offers![i].remainingminutes!,
          //                       "0")),
          //                 },
          //             },
          //           count = offersList!.length,
          //           for (int i = 0; i < count; i++)
          //             {
          //               for (int j = i + 1; j < count; j++)
          //                 {
          //                   if (offersList![i].id == offersList![j].id)
          //                     {
          //                       offersList!.removeAt(j),
          //                       count--,
          //                     }
          //                 },
          //               for (int j = i + 1; j < count; j++)
          //                 {
          //                   if (offersList![i].companyId ==
          //                           offersList![j].companyId &&
          //                       offersList![i].discountdisplay ==
          //                           offersList![j].discountdisplay)
          //                     {
          //                       offersList!.removeAt(j),
          //                       count--,
          //                     }
          //                 },
          //             },
          //           count = offersList!.length,
          //           for (int i = 0; i < count; i++)
          //             {
          //               for (int j = i + 1; j < count; j++)
          //                 {
          //                   if (offersList![i].companyId ==
          //                           offersList![j].companyId &&
          //                       offersList![i].discountdisplay ==
          //                           offersList![j].discountdisplay)
          //                     {
          //                       offersList!.removeAt(j),
          //                       count--,
          //                     }
          //                 },
          //             },
          //           if (favList != null && favList!.isNotEmpty)
          //             {
          //               // for (int i = 0; i < favList!.length; i++)
          //               //   {
          //               //     for (int j = 0; j < offersList!.length; j++)
          //               //       {
          //               //         if (favList![i].offerId == offersList![j].id)
          //               //           {
          //               //             fav[j] = "1",
          //               //           }
          //               //       }
          //               //   },
          //             },
          //         },
          //       _getAds().then((value) => {
          //             ads_image_base_url = value.imageBaseUrl!,
          //             if (value.adsList != null && value.adsList!.length > 0)
          //               {
          //                 for (int i = 0; i < value.adsList!.length; i++)
          //                   {
          //                     adsList.add(AdsListModel(
          //                         value.adsList![i].addId!,
          //                         value.adsList![i].addName!,
          //                         value.adsList![i].addImage!,
          //                         value.adsList![i].url!,
          //                         value.adsList![i].status!,
          //                         value.adsList![i].createdDate!,
          //                         value.adsList![i].updatedDate!)),
          //                   },
          //                 if (adsList != null && adsList.length > 0)
          //                   {
          //                     setState(() {
          //                       for (int i = 0; i < offersList!.length; i++) {
          //                         n++;
          //                         if (n == 1) {
          //                           offersList_ads = [];
          //                         }
          //                         if (i == (offersList!.length - 1) && n < 18) {
          //                           offersList_ads!.add(offersList![i]);
          //                           if (a < adsList.length) {
          //                             offerads_model.add(OfferAdsModel(
          //                                 adsList[a], offersList_ads!, "1"));
          //                           } else {
          //                             adsList.add(AdsListModel(
          //                                 "", "", "", "", "", "", ""));
          //                             offerads_model.add(OfferAdsModel(
          //                                 adsList[a], offersList_ads!, "0"));
          //                           }
          //                           n = 0;
          //                           a++;
          //                         } else if (n < 18) {
          //                           offersList_ads!.add(offersList![i]);
          //                         } else if (n == 18) {
          //                           offersList_ads!.add(offersList![i]);
          //                           if (a < adsList.length) {
          //                             offerads_model.add(OfferAdsModel(
          //                                 adsList[a], offersList_ads!, "1"));
          //                           } else {
          //                             adsList.add(AdsListModel(
          //                                 "", "", "", "", "", "", ""));
          //                             offerads_model.add(OfferAdsModel(
          //                                 adsList[a], offersList_ads!, "0"));
          //                           }
          //                           n = 0;
          //                           a++;
          //                         }
          //                       }
          //                     }),
          //                   },
          //               }
          //           }),
          //       setState(() {
          //         company_image_base_url = value.imageBaseUrl!;
          //         _isLoading = false;
          //       }),
          //     });
          // setState(() {
          //   _isLoading = false;
          // });
          throw Exception('Failed to load album');
        }
      } else {
        int count = 0;
        int n = 0, a = 0;
        // _getPublicOffers().then((value) => {
        //       if (value.offers != null && value.offers!.length > 0)
        //         {
        //           for (int i = 0; i < value.offers!.length; i++)
        //             {
        //               if (value.offers![i].companyId! != "173")
        //                 {
        //                   offersList!.add(OffersListModel(
        //                       value.offers![i].id!,
        //                       value.offers![i].companyId!,
        //                       value.offers![i].branchId!,
        //                       value.offers![i].couponType!,
        //                       value.offers![i].companyDiscount!,
        //                       value.offers![i].comission!,
        //                       value.offers![i].customerDiscount!,
        //                       value.offers![i].discountDetail!,
        //                       value.offers![i].description!,
        //                       value.offers![i].arbDescription!,
        //                       value.offers![i].startDate!,
        //                       value.offers![i].endDate!,
        //                       value.offers![i].timing!,
        //                       value.offers![i].onlineLink!,
        //                       value.offers![i].playstoreLink!,
        //                       value.offers![i].iosLink!,
        //                       value.offers![i].huawaiLink!,
        //                       value.offers![i].priority!,
        //                       value.offers![i].priorityStart!,
        //                       value.offers![i].priorityEnd!,
        //                       value.offers![i].hMobileNo!,
        //                       value.offers![i].hWhatsappNo!,
        //                       value.offers![i].hInstagram!,
        //                       value.offers![i].hEmail!,
        //                       value.offers![i].hLocation!,
        //                       value.offers![i].hArabLocation!,
        //                       value.offers![i].hImage!,
        //                       value.offers![i].mall!,
        //                       value.offers![i].mallName!,
        //                       value.offers![i].mallNameArabic!,
        //                       value.offers![i].custmise!,
        //                       value.offers![i].offerNameCust!,
        //                       value.offers![i].offerNameCustArabic!,
        //                       value.offers![i].discountdisplay!,
        //                       value.offers![i].companyName!,
        //                       value.offers![i].companyArbName!,
        //                       value.offers![i].displayName!,
        //                       value.offers![i].displayArbName!,
        //                       value.offers![i].companylogo!,
        //                       value.offers![i].viewCount!,
        //                       value.offers![i].category!,
        //                       value.offers![i].discountEnDetail!,
        //                       value.offers![i].discountArbDetail!,
        //                       value.offers![i].userFav!,
        //                       value.offers![i].customerId!,
        //                       value.offers![i].remainingday!,
        //                       value.offers![i].remaininghours!,
        //                       value.offers![i].remainingminutes!,
        //                       "0")),
        //                 },
        //             },
        //           count = offersList!.length,
        //           for (int i = 0; i < count; i++)
        //             {
        //               for (int j = i + 1; j < count; j++)
        //                 {
        //                   if (offersList![i].id == offersList![j].id)
        //                     {
        //                       offersList!.removeAt(j),
        //                       count--,
        //                     }
        //                 },
        //             },
        //           count = offersList!.length,
        //           for (int i = 0; i < count; i++)
        //             {
        //               for (int j = i + 1; j < count; j++)
        //                 {
        //                   if (offersList![i].companyId ==
        //                           offersList![j].companyId &&
        //                       offersList![i].discountdisplay ==
        //                           offersList![j].discountdisplay)
        //                     {
        //                       offersList!.removeAt(j),
        //                       count--,
        //                     }
        //                 },
        //             },
        //           if (favList != null && favList!.isNotEmpty)
        //             {
        //               // for (int i = 0; i < favList!.length; i++)
        //               //   {
        //               //     for (int j = 0; j < offersList!.length; j++)
        //               //       {
        //               //         if (favList![i].offerId == offersList![j].id)
        //               //           {
        //               //             fav[j] = "1",
        //               //           }
        //               //       }
        //               //   },
        //             },
        //         },
        //       _getAds().then((value) => {
        //             ads_image_base_url = value.imageBaseUrl!,
        //             if (value.adsList != null && value.adsList!.length > 0)
        //               {
        //                 for (int i = 0; i < value.adsList!.length; i++)
        //                   {
        //                     adsList.add(AdsListModel(
        //                         value.adsList![i].addId!,
        //                         value.adsList![i].addName!,
        //                         value.adsList![i].addImage!,
        //                         value.adsList![i].url!,
        //                         value.adsList![i].status!,
        //                         value.adsList![i].createdDate!,
        //                         value.adsList![i].updatedDate!)),
        //                   },
        //                 if (adsList != null && adsList.length > 0)
        //                   {
        //                     setState(() {
        //                       for (int i = 0; i < offersList!.length; i++) {
        //                         n++;
        //                         if (n == 1) {
        //                           offersList_ads = [];
        //                         }
        //                         if (i == (offersList!.length - 1) && n < 18) {
        //                           offersList_ads!.add(offersList![i]);
        //                           if (a < adsList.length) {
        //                             offerads_model.add(OfferAdsModel(
        //                                 adsList[a], offersList_ads!, "1"));
        //                           } else {
        //                             adsList.add(AdsListModel(
        //                                 "", "", "", "", "", "", ""));
        //                             offerads_model.add(OfferAdsModel(
        //                                 adsList[a], offersList_ads!, "0"));
        //                           }
        //                           n = 0;
        //                           a++;
        //                         } else if (n < 18) {
        //                           offersList_ads!.add(offersList![i]);
        //                         } else if (n == 18) {
        //                           offersList_ads!.add(offersList![i]);
        //                           if (a < adsList.length) {
        //                             offerads_model.add(OfferAdsModel(
        //                                 adsList[a], offersList_ads!, "1"));
        //                           } else {
        //                             adsList.add(AdsListModel(
        //                                 "", "", "", "", "", "", ""));
        //                             offerads_model.add(OfferAdsModel(
        //                                 adsList[a], offersList_ads!, "0"));
        //                           }
        //                           n = 0;
        //                           a++;
        //                         }
        //                       }
        //                     }),
        //                   },
        //               }
        //           }),
        //       setState(() {
        //         company_image_base_url = value.imageBaseUrl!;
        //         _isLoading = false;
        //       }),
        //     });
        // setState(() {
        //   _isLoading = false;
        // });
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

  Future<bool> _addOrRemoveFavOffer(int parent_index, int index) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final Map<String, String?> body;
      if (offerads_model.isNotEmpty) {
        body = {
          "customer_id": Constants.user_id,
          "company_id":
              offerads_model[parent_index].offersList![index].companyId,
          "offer_id": offerads_model[parent_index].offersList![index].id,
        };
      } else {
        body = {
          "customer_id": Constants.user_id,
          "company_id": offersList![index].companyId,
          "offer_id": offersList![index].id,
        };
      }

      final http.Response response;
      if (offerads_model.isNotEmpty) {
        if (offerads_model[parent_index].offersList![index].isfavorate == "0") {
          response = await http.post(
            Uri.parse('http://185.188.127.11/public/index.php/ApiFavorate'),
            body: body,
          );
        } else {
          response = await http.post(
            Uri.parse('http://185.188.127.11/public/index.php/removefavourate'),
            body: body,
          );
        }
      } else {
        if (offersList![index].isFav == "0") {
          response = await http.post(
            Uri.parse('http://185.188.127.11/public/index.php/ApiFavorate'),
            body: body,
          );
          print("hellp");
        } else {
          response = await http.post(
            Uri.parse('http://185.188.127.11/public/index.php/removefavourate'),
            body: body,
          );
        }
      }

      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }

        if (response_server["status"] == 201) {
          if (offerads_model.isNotEmpty) {
            if (offerads_model[parent_index].offersList![index].isfavorate ==
                "0") {
              if (Constants.language == "en") {
                _alertDialog("Added Successfully");
              } else {
                _alertDialog("اضيف بنجاح");
              }
              setState(() {
                offerads_model[parent_index].offersList![index].isfavorate =
                    "1";
                _isLoading = false;
              });
              return true;
            } else {
              if (Constants.language == "en") {
                _alertDialog("Removed Successfully");
              } else {
                _alertDialog("تمت إزالته بنجاح");
              }
              setState(() {
                offerads_model[parent_index].offersList![index].isfavorate =
                    "0";
                _isLoading = false;
              });
              return false;
            }
          } else {
            if (offersList![index].isFav == "0") {
              if (Constants.language == "en") {
                _alertDialog("Added Successfully");
              } else {
                _alertDialog("اضيف بنجاح");
              }
              setState(() {
                offersList![index].isFav = "1";
                _isLoading = false;
              });
              return true;
            } else {
              if (Constants.language == "en") {
                _alertDialog("Removed Successfully");
              } else {
                _alertDialog("تمت إزالته بنجاح");
              }
              setState(() {
                offersList![index].isFav = "0";
                _isLoading = false;
              });
              return false;
            }
          }
        } else {
          if (offerads_model.isNotEmpty) {
            if (offerads_model[parent_index].offersList![index].isfavorate ==
                "0") {
              setState(() {
                offerads_model[parent_index].offersList![index].isfavorate =
                    "0";
                _isLoading = false;
              });
              if (Constants.language == "en") {
                _alertDialog("Failed to add favourite");
              } else {
                _alertDialog("فشل إضافة المفضلة");
              }
              return false;
            } else {
              setState(() {
                offerads_model[parent_index].offersList![index].isfavorate =
                    "1";
                _isLoading = false;
              });
              if (Constants.language == "en") {
                _alertDialog("Failed to remove favourite");
              } else {
                _alertDialog("فشل إزالة المفضلة");
              }
              return true;
            }
          } else {
            if (offersList![index].isFav == "0") {
              setState(() {
                offersList![index].isFav = "0";
                _isLoading = false;
              });
              if (Constants.language == "en") {
                _alertDialog("Failed to add favourite");
              } else {
                _alertDialog("فشل إضافة المفضلة");
              }
              return false;
            } else {
              setState(() {
                offersList![index].isFav = "1";
                _isLoading = false;
              });
              if (Constants.language == "en") {
                _alertDialog("Failed to remove favourite");
              } else {
                _alertDialog("فشل إزالة المفضلة");
              }
              return true;
            }
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
        if (offerads_model.isNotEmpty) {
          if (offerads_model[parent_index].offersList![index].isfavorate ==
              "0") {
            return false;
          } else {
            return true;
          }
        } else {
          if (offersList![index].isFav == "0") {
            return false;
          } else {
            return true;
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
      if (offersList![index].isFav == "0") {
        return false;
      } else {
        return true;
      }
    }
  }

  @override
  void initState() {
    int count;
    int n = 0, a = 0, per_page = 0;
    var contains;
    _getNewOffers(page).then((value) => {
          if (mounted)
            {
              setState(() {
                if (value.offers != null && value.offers!.isNotEmpty) {
                  offerads_model.add(
                      OfferAdsModel(value.dashAdvertise!, value.offers!, "1"));
                }
                if (page == 1) {
                  company_image_base_url = value.imageBaseUrl!;
                  ads_image_base_url = value.addImageBaseUrl!;
                  _pageSize = int.parse(value.totalRecord!);
                  per_page = value.perpageRecord!;
                  // Edited by rohan 22/07/22 for pagination 18 records ...
                  maxPage = (_pageSize).round();
                  int maxdouble = (maxPage / 18).ceil();
                  maxdouble = (maxdouble.round());
                  print("max" + maxPage.toString());
                  print("pagesize" + _pageSize.toString());
                  print("maxpagee" + maxdouble.toString());
                  maxPage = maxdouble;
                }
                _isLoading = false;
              }),
            }
          else
            {
              if (value.offers != null && value.offers!.isNotEmpty)
                {
                  offerads_model.add(
                      OfferAdsModel(value.dashAdvertise!, value.offers!, "1")),
                },
              if (page == 1)
                {
                  company_image_base_url = value.imageBaseUrl!,
                  ads_image_base_url = value.addImageBaseUrl!,
                  _pageSize = int.parse(value.totalRecord!),
                  per_page = value.perpageRecord!,
                  maxPage = (_pageSize / per_page).round(),
                  print("alert::::::")
                },
              _isLoading = false,
            }
        });
    // _getFavouriteOffers().then((value) => {
    //       if (value.favouratelist != null && value.favouratelist!.length > 0)
    //         {
    //           for (int i = 0; i < value.favouratelist!.length; i++)
    //             {favList!.add(value.favouratelist![i])}
    //         },
    //       _getPublicOffers().then((value) => {
    //             if (value.offers != null && value.offers!.length > 0)
    //               {
    //                 for (int i = 0; i < value.offers!.length; i++)
    //                   {
    //                     if (value.offers![i].companyId! != "173")
    //                       {
    //                         contains = favList!.where((element) =>
    //                             element.offerId == value.offers![i].id),
    //                         if (contains.isNotEmpty)
    //                           {
    //                             offersList!.add(OffersListModel(
    //                                 value.offers![i].id!,
    //                                 value.offers![i].companyId!,
    //                                 value.offers![i].branchId!,
    //                                 value.offers![i].couponType!,
    //                                 value.offers![i].companyDiscount!,
    //                                 value.offers![i].comission!,
    //                                 value.offers![i].customerDiscount!,
    //                                 value.offers![i].discountDetail!,
    //                                 value.offers![i].description!,
    //                                 value.offers![i].arbDescription!,
    //                                 value.offers![i].startDate!,
    //                                 value.offers![i].endDate!,
    //                                 value.offers![i].timing!,
    //                                 value.offers![i].onlineLink!,
    //                                 value.offers![i].playstoreLink!,
    //                                 value.offers![i].iosLink!,
    //                                 value.offers![i].huawaiLink!,
    //                                 value.offers![i].priority!,
    //                                 value.offers![i].priorityStart!,
    //                                 value.offers![i].priorityEnd!,
    //                                 value.offers![i].hMobileNo!,
    //                                 value.offers![i].hWhatsappNo!,
    //                                 value.offers![i].hInstagram!,
    //                                 value.offers![i].hEmail!,
    //                                 value.offers![i].hLocation!,
    //                                 value.offers![i].hArabLocation!,
    //                                 value.offers![i].hImage!,
    //                                 value.offers![i].mall!,
    //                                 value.offers![i].mallName!,
    //                                 value.offers![i].mallNameArabic!,
    //                                 value.offers![i].custmise!,
    //                                 value.offers![i].offerNameCust!,
    //                                 value.offers![i].offerNameCustArabic!,
    //                                 value.offers![i].discountdisplay!,
    //                                 value.offers![i].companyName!,
    //                                 value.offers![i].companyArbName!,
    //                                 value.offers![i].displayName!,
    //                                 value.offers![i].displayArbName!,
    //                                 value.offers![i].companylogo!,
    //                                 value.offers![i].viewCount!,
    //                                 value.offers![i].category!,
    //                                 value.offers![i].discountEnDetail!,
    //                                 value.offers![i].discountArbDetail!,
    //                                 value.offers![i].userFav!,
    //                                 value.offers![i].customerId!,
    //                                 value.offers![i].remainingday!,
    //                                 value.offers![i].remaininghours!,
    //                                 value.offers![i].remainingminutes!,
    //                                 "1")),
    //                           }
    //                         else
    //                           {
    //                             offersList!.add(OffersListModel(
    //                                 value.offers![i].id!,
    //                                 value.offers![i].companyId!,
    //                                 value.offers![i].branchId!,
    //                                 value.offers![i].couponType!,
    //                                 value.offers![i].companyDiscount!,
    //                                 value.offers![i].comission!,
    //                                 value.offers![i].customerDiscount!,
    //                                 value.offers![i].discountDetail!,
    //                                 value.offers![i].description!,
    //                                 value.offers![i].arbDescription!,
    //                                 value.offers![i].startDate!,
    //                                 value.offers![i].endDate!,
    //                                 value.offers![i].timing!,
    //                                 value.offers![i].onlineLink!,
    //                                 value.offers![i].playstoreLink!,
    //                                 value.offers![i].iosLink!,
    //                                 value.offers![i].huawaiLink!,
    //                                 value.offers![i].priority!,
    //                                 value.offers![i].priorityStart!,
    //                                 value.offers![i].priorityEnd!,
    //                                 value.offers![i].hMobileNo!,
    //                                 value.offers![i].hWhatsappNo!,
    //                                 value.offers![i].hInstagram!,
    //                                 value.offers![i].hEmail!,
    //                                 value.offers![i].hLocation!,
    //                                 value.offers![i].hArabLocation!,
    //                                 value.offers![i].hImage!,
    //                                 value.offers![i].mall!,
    //                                 value.offers![i].mallName!,
    //                                 value.offers![i].mallNameArabic!,
    //                                 value.offers![i].custmise!,
    //                                 value.offers![i].offerNameCust!,
    //                                 value.offers![i].offerNameCustArabic!,
    //                                 value.offers![i].discountdisplay!,
    //                                 value.offers![i].companyName!,
    //                                 value.offers![i].companyArbName!,
    //                                 value.offers![i].displayName!,
    //                                 value.offers![i].displayArbName!,
    //                                 value.offers![i].companylogo!,
    //                                 value.offers![i].viewCount!,
    //                                 value.offers![i].category!,
    //                                 value.offers![i].discountEnDetail!,
    //                                 value.offers![i].discountArbDetail!,
    //                                 value.offers![i].userFav!,
    //                                 value.offers![i].customerId!,
    //                                 value.offers![i].remainingday!,
    //                                 value.offers![i].remaininghours!,
    //                                 value.offers![i].remainingminutes!,
    //                                 "0")),
    //                           }
    //                       },
    //                   },
    //                 count = offersList!.length,
    //                 for (int i = 0; i < count; i++)
    //                   {
    //                     for (int j = i + 1; j < count; j++)
    //                       {
    //                         if (offersList![i].id == offersList![j].id)
    //                           {
    //                             offersList!.removeAt(j),
    //                             count--,
    //                           }
    //                       },
    //                     for (int j = i + 1; j < count; j++)
    //                       {
    //                         if (offersList![i].companyId ==
    //                                 offersList![j].companyId &&
    //                             offersList![i].discountdisplay ==
    //                                 offersList![j].discountdisplay)
    //                           {
    //                             offersList!.removeAt(j),
    //                             count--,
    //                           }
    //                       },
    //                     // for (int i = 0; i < favList!.length; i++)
    //                     //   {
    //                     //     for (int j = 0; j < offersList!.length; j++)
    //                     //       {
    //                     //         if (favList![i].offerId == offersList![j].id)
    //                     //           {
    //                     //             fav[j] = "1",
    //                     //           }
    //                     //       }
    //                     //   }
    //                   }
    //               },
    //             _getAds().then((value) => {
    //                   ads_image_base_url = value.imageBaseUrl!,
    //                   if (value.adsList != null && value.adsList!.length > 0)
    //                     {
    //                       for (int i = 0; i < value.adsList!.length; i++)
    //                         {
    //                           adsList.add(AdsListModel(
    //                               value.adsList![i].addId!,
    //                               value.adsList![i].addName!,
    //                               value.adsList![i].addImage!,
    //                               value.adsList![i].url!,
    //                               value.adsList![i].status!,
    //                               value.adsList![i].createdDate!,
    //                               value.adsList![i].updatedDate!)),
    //                         },
    //                       if (adsList != null && adsList.length > 0)
    //                         {
    //                           for (int i = 0; i < offersList!.length; i++)
    //                             {
    //                               n++,
    //                               if (n == 1)
    //                                 {
    //                                   offersList_ads = [],
    //                                 },
    //                               if (i == (offersList!.length - 1) && n < 18)
    //                                 {
    //                                   offersList_ads!.add(offersList![i]),
    //                                   if (a < adsList.length)
    //                                     {
    //                                       offerads_model.add(OfferAdsModel(
    //                                           adsList[a],
    //                                           offersList_ads!,
    //                                           "1")),
    //                                     }
    //                                   else
    //                                     {
    //                                       adsList.add(AdsListModel(
    //                                           "", "", "", "", "", "", "")),
    //                                       offerads_model.add(OfferAdsModel(
    //                                           adsList[a],
    //                                           offersList_ads!,
    //                                           "0")),
    //                                     },
    //                                   n = 0,
    //                                   a++,
    //                                 }
    //                               else if (n < 18)
    //                                 {
    //                                   offersList_ads!.add(offersList![i]),
    //                                 }
    //                               else if (n == 18)
    //                                 {
    //                                   offersList_ads!.add(offersList![i]),
    //                                   if (a < adsList.length)
    //                                     {
    //                                       offerads_model.add(OfferAdsModel(
    //                                           adsList[a],
    //                                           offersList_ads!,
    //                                           "1")),
    //                                     }
    //                                   else
    //                                     {
    //                                       adsList.add(AdsListModel(
    //                                           "", "", "", "", "", "", "")),
    //                                       offerads_model.add(OfferAdsModel(
    //                                           adsList[a],
    //                                           offersList_ads!,
    //                                           "0")),
    //                                     },
    //                                   n = 0,
    //                                   a++,
    //                                 },
    //                             },
    //                         },
    //                     }
    //                 }),
    //             company_image_base_url = value.imageBaseUrl!,
    //             _isLoading = false,
    //           }),
    //     });
    scrollcontroller.addListener(pagination);
    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        (page < maxPage)) {
      setState(() {
        _isPaginationLoading = true;
        page += 1;
        _getNewOffers(page).then((value) => {
              if (mounted)
                {
                  setState(() {
                    if (value.offers != null && value.offers!.isNotEmpty) {
                      offerads_model.add(OfferAdsModel(
                          value.dashAdvertise!, value.offers!, "1"));
                    }
                    _isPaginationLoading = false;
                  }),
                }
              else
                {
                  if (value.offers != null && value.offers!.isNotEmpty)
                    {
                      offerads_model.add(OfferAdsModel(
                          value.dashAdvertise!, value.offers!, "1")),
                    },
                  _isPaginationLoading = false,
                }
            });
      });
    }
  }

  var count = "";
  List<Companydetails>? companydetail = [];

  Future<void> getCompany(var companyid) async {
    String url =
        "http://185.188.127.11/public/index.php/ApiCompany/" + companyid;
    var network = new NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = CompanyDetailsModel.fromJson(res);
    var stat = vlist.status.toString();
    if (stat.contains("201")) {
      // totalamount=couponreportlist![index].couponAmount!;

      print("okkkk");

      for (var data in companydetail!) {
        count = data.viewCount.toString();
        print("viewhere" + count);
      }
    }

    setState(() {
      //  couponreportlist = vlist.userCouponList!;
    });

    print("companydetailsrr" + res!.toString());
  }

  List<CouponList> couponlist = [];

/*  Future<Couponlistmodel> couponsavailbler(var companyid,var branchid) async{
    Map<String,String> jsonbody={
      "companyid":companyid,
      "branchid":branchid,
    };
    String url="http://cp.citycode.om/public/index.php/couponlist";
    var network= new NewVendorApiService();
    var response= await network.postresponse(url, jsonbody);
    var model=Couponlistmodel.fromJson(response);
    var status= model.status.toString();
    setState(() {
      _isLoading=true;
    });
    if(status.contains("201")){
      print("couponslist"+response.toString());
      setState(() {
        _isLoading=false;
      });
    }else{
      throw Exception('Failed to load album');
    }

  }*/
  Future<void> couponlistavailable(
      var companyid, var branchid, int parent_index, int index) async {
    Map<String, String> jsonbody = {
      "companyid": companyid,
      "branchid": branchid,
    };
    String url = "http://cp.citycode.om/public/index.php/couponlist";
    var network = new NewVendorApiService();
    var response = await network.postresponse(url, jsonbody);
    var model = Couponlistmodel.fromJson(response);
    var status = model.status.toString();
    if (status.contains("404")) {
      _alertDialog(Constants.language == "en"
          ? "Coupons Not Available"
          : "القسائم غير متوفرة");
    }
    setState(() {
      _isLoading = false;
    });

    if (status.contains("201")) {
      setState(() {
        couponlist = model.couponList!;
      });
      print("couponslist" + response.toString());
      setState(() {
        _isLoading = false;
      });
      if (couponlist.isNotEmpty) {
        print("heretwo");

        print("rohan" + count.toString());
        Route route = MaterialPageRoute(
            builder: (context) => OfferDetailsScreen(
                Constants.language == "en"
                    ? offerads_model[parent_index]
                        .offersList![index]
                        .displayName!
                    : offerads_model[parent_index]
                            .offersList![index]
                            .displayArbName!
                            .isNotEmpty
                        ? offerads_model[parent_index]
                            .offersList![index]
                            .displayArbName!
                        : offerads_model[parent_index]
                            .offersList![index]
                            .displayName!,
                offerads_model[parent_index].offersList![index].companyId!,
                offerads_model[parent_index]
                    .offersList![index]
                    .discountdisplay!,
                offerads_model[parent_index].offersList![index].id!,
                offerads_model[parent_index].offersList![index].isfavorate!,
                "offers",
                "",
                coupondata,
                "",
                ""));
        Navigator.push(context, route);
      } else {
        _alertDialog(Constants.language == "en"
            ? "Coupons Not Available"
            : "القسائم غير متوفرة");
      }
    }
  }

  @override
  void dispose() {
    scrollcontroller.dispose();
    super.dispose();
  }

  var companyid = "";
  var branchid = "";
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        ListView.builder(
          shrinkWrap: true,
          controller: scrollcontroller,
          itemCount: offerads_model.length,
          itemBuilder: (BuildContext context, int parent_index) {
            return Column(
              children: [
                if (widget.coupon_type == "homebusiness")
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: offerads_model[parent_index].offersList!.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: width / 500,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      companyid = offerads_model[parent_index]
                          .offersList![index]
                          .companyId!;
                      branchid = offerads_model[parent_index]
                          .offersList![index]
                          .branchId!;
                      return InkWell(
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => OfferDetailsScreen(
                                  Constants.language == "en"
                                      ? offerads_model[parent_index]
                                          .offersList![index]
                                          .companyName!
                                      : offerads_model[parent_index]
                                              .offersList![index]
                                              .companyArbName!
                                              .isNotEmpty
                                          ? offerads_model[parent_index]
                                              .offersList![index]
                                              .companyArbName!
                                          : offerads_model[parent_index]
                                              .offersList![index]
                                              .companyName!,
                                  offerads_model[parent_index]
                                      .offersList![index]
                                      .companyId!,
                                  offerads_model[parent_index]
                                      .offersList![index]
                                      .discountdisplay!,
                                  offerads_model[parent_index]
                                      .offersList![index]
                                      .id!,
                                  offerads_model[parent_index]
                                      .offersList![index]
                                      .isfavorate!,
                                  "home",
                                  "",
                                  coupondata,
                                  "",
                                  ""));
                          Navigator.push(context, route);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          // color: Colors.green,
                          color: const Color(0xFFE6D997),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: height * 0.103,
                                child: CircleAvatar(
                                  radius: width * 0.10,
                                  backgroundImage: NetworkImage(
                                      company_image_base_url +
                                          offerads_model[parent_index]
                                              .offersList![index]
                                              .companylogo!),
                                ),
                                margin: const EdgeInsets.only(
                                    left: 2.0, right: 2.0, top: 2.0),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  Constants.language == "en"
                                      ? offerads_model[parent_index]
                                          .offersList![index]
                                          .displayName!
                                      : offerads_model[parent_index]
                                              .offersList![index]
                                              .displayArbName!
                                              .isNotEmpty
                                          ? offerads_model[parent_index]
                                              .offersList![index]
                                              .displayArbName!
                                          : offerads_model[parent_index]
                                              .offersList![index]
                                              .displayName!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : offerads_model[parent_index]
                                                  .offersList![index]
                                                  .displayArbName!
                                                  .isNotEmpty
                                              ? "GSSFont"
                                              : "Roboto",
                                      fontWeight: FontWeight.bold,
                                      //fontSize: 16.0
                                      fontSize: 14.0),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(2.0),
                                margin: const EdgeInsets.only(
                                    left: 1.0, right: 1.0, bottom: 7),
                                width: width * 0.20,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Column(
                                  children: [
                                    Text(
                                      Constants.language == "en"
                                          ? "Views"
                                          : "مشاهدة",
                                      style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .viewCount!,
                                      style: const TextStyle(
                                        fontSize: 8.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                else if (widget.coupon_type == "coupon")
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: offerads_model[parent_index].offersList!.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: width / 657,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          var qty = offerads_model[parent_index]
                              .offersList![index]
                              .couponquantity
                              .toString();
                          print("qty" + qty.toString());
                          /* couponsavailbler( companyid, branchid)?.then((value) => {
                      if(value.couponList!=null&&value.couponList!.isNotEmpty){

                      }
                    });*/
                          var companyid = offerads_model[parent_index]
                              .offersList![index]
                              .companyId!;
                          var branchid = offerads_model[parent_index]
                              .offersList![index]
                              .branchId!;
                          couponlistavailable(
                              companyid, branchid, parent_index, index);
                          setState(() {
                            _isLoading = true;
                          });
                          getCompany(offerads_model[parent_index]
                              .offersList![index]
                              .companyId!);
                          print("hereone");
                          coupondata = offerads_model[parent_index]
                              .offersList![index]
                              .couponstatus
                              .toString();

                          if (widget.coupon_type == "friday") {
                            var date = DateTime.now();
                            if (date.weekday == DateTime.friday) {
                              print("herefriday");
                              Route route = MaterialPageRoute(
                                  builder: (context) => OfferDetailsScreen(
                                      Constants.language == "en"
                                          ? offerads_model[parent_index]
                                              .offersList![index]
                                              .companyName!
                                          : offerads_model[parent_index]
                                                  .offersList![index]
                                                  .companyArbName!
                                                  .isNotEmpty
                                              ? offerads_model[parent_index]
                                                  .offersList![index]
                                                  .companyArbName!
                                              : offerads_model[parent_index]
                                                  .offersList![index]
                                                  .companyName!,
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .companyId!,
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .discountdisplay!,
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .id!,
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .isfavorate!,
                                      "offers",
                                      "",
                                      coupondata,
                                      "",
                                      ""));
                              Navigator.push(context, route);
                            } else {
                              _alertDialog(Constants.language == "en"
                                  ? "The offer will be available on Friday"
                                  : "العرض متاح يوم الجمعة");
                            }
                          } else {
                            print("Company name::::::::::" +
                                offerads_model[parent_index]
                                    .offersList![index]
                                    .companyName!);
                            /* if(couponlist.isNotEmpty){}

                      else{
                        _alertDialog(Constants.language == "en"
                            ? "Coupons Not Available"
                            : "القسائم غير متوفرة");
                      }*/
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: const Color(0xFFE6D997),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        offerads_model[parent_index]
                                                    .offersList![index]
                                                    .couponstatus ==
                                                "1"
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    color: Colors.lightGreen,
                                                    child: const Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Coupon",
                                                          style: TextStyle(
                                                              fontSize: 5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ))),
                                              )
                                            : Container(),
                                        LikeButton(
                                          onTap: (bool) {
                                            return _addOrRemoveFavOffer(
                                                parent_index, index);
                                          },
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          size: width * 0.06,
                                          isLiked: offerads_model[parent_index]
                                                      .offersList![index]
                                                      .isfavorate! ==
                                                  "1"
                                              ? true
                                              : false,
                                          circleColor: const CircleColor(
                                              start: Color(0xff00ddff),
                                              end: Color(0xff0099cc)),
                                          bubblesColor: const BubblesColor(
                                            dotPrimaryColor: Color(0xff33b5e5),
                                            dotSecondaryColor:
                                                Color(0xff0099cc),
                                          ),
                                          likeBuilder: (bool isLiked) {
                                            return Icon(
                                              isLiked
                                                  ? CupertinoIcons.heart_fill
                                                  : CupertinoIcons.heart,
                                              color: isLiked
                                                  ? Colors.red
                                                  : Colors.black,
                                              size: width * 0.06,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    /* Visibility(
                                visible:offerads_model[parent_index]
                                    .offersList![index].couponstatus== "0" ? false : true,
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 58,right: 20,bottom:7,top: 53),
                                    height: 80,
                                    width: 80,

                                    foregroundDecoration:  RotatedCornerDecoration(

                                      color: Colors.lightGreen,
                                      geometry: const BadgeGeometry(width: 45, height: 40, cornerRadius: 7,alignment: BadgeAlignment.bottomRight),
                                      textSpan: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '"  "\n',
                                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.redAccent),
                                          ),
                                          TextSpan(
                                            text:   '" "\n',
                                            style: TextStyle(fontSize: 4, fontStyle: FontStyle.italic, letterSpacing: 0.5, color: Colors.white),
                                          ),
                                          TextSpan(
                                            text:   "    Coupon\n",
                                            style: TextStyle(fontSize: 4, fontStyle: FontStyle.italic, letterSpacing: 0.5, color: Colors.white,fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      // textSpan: TextSpan(text: '"\ncoupon\ncoupon', style: TextStyle(fontSize: 4, letterSpacing: 0.5,color: Colors.white)),
                                      //  geometry: const BadgeGeometry(width: 32, height: 32, cornerRadius: 16),
                                    ),
                                  ),
                                ),
                              ),*/
                                    Positioned(
                                      top: 10.0,
                                      right: 10.0,
                                      left: 10.0,
                                      child: CircleAvatar(
                                        radius: width * 0.10,
                                        backgroundImage: NetworkImage(
                                            company_image_base_url +
                                                offerads_model[parent_index]
                                                    .offersList![index]
                                                    .companylogo!),

                                        /*child:Visibility(
                                              visible: offerads_model[parent_index]
                                                  .offersList![index].couponstatus== "0" ? false : true,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom:1.0,left: 12,right:7),
                                                child: Container(
                                                  width: 50,
                                                  margin: EdgeInsets.only(left: 20),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),

                                                    alignment: Alignment.bottomRight,
                                                 // padding: const EdgeInsets.all(5),
                                                  child: const Text('', style: TextStyle(fontSize: 12)),
                                                  foregroundDecoration:  RotatedCornerDecoration(

                                                    color: Colors.lightGreen,
                                                    geometry: const BadgeGeometry(width: 25, height: 26, cornerRadius: 7,alignment: BadgeAlignment.bottomRight),
                                                    textSpan: TextSpan(text: 'coupon', style: TextStyle(fontSize: 5, letterSpacing: 0.5)),
                                                  //  geometry: const BadgeGeometry(width: 32, height: 32, cornerRadius: 16),
                                                  ),
                                                ),
                                              ),
                                            ),*/
                                      ),
                                    ),
                                  ],
                                ),
                                margin: const EdgeInsets.only(
                                  left: 2.0,
                                  right: 2.0,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  Constants.language == "en"
                                      ? offerads_model[parent_index]
                                          .offersList![index]
                                          .displayName!
                                      : offerads_model[parent_index]
                                              .offersList![index]
                                              .displayArbName!
                                              .isNotEmpty
                                          ? offerads_model[parent_index]
                                              .offersList![index]
                                              .displayArbName!
                                          : offerads_model[parent_index]
                                              .offersList![index]
                                              .displayName!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : offerads_model[parent_index]
                                                  .offersList![index]
                                                  .displayArbName!
                                                  .isNotEmpty
                                              ? "Roboto" //GSSFont edited by rohan
                                              : "Roboto",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 1.0),
                                child: Text(
                                  offerads_model[parent_index]
                                              .offersList![index]
                                              .couponstatus ==
                                          "1"
                                      ? "Coupons"
                                      : offerads_model[parent_index]
                                          .offersList![index]
                                          .discountdisplay!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(2.0),
                                margin: const EdgeInsets.only(
                                    left: 1.0, right: 1.0, bottom: 7, top: 2),
                                width: width * 0.20,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Column(
                                  children: [
                                    Text(
                                      Constants.language == "en"
                                          ? "Views"
                                          : "مشاهدة",
                                      style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .viewCount!,
                                      style: const TextStyle(
                                        fontSize: 8.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              /*Container(
                          margin: const EdgeInsets.only(
                              top: 1.0, left: 3.0, right: 3.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2.0),
                                width: width * 0.08,
                                margin: const EdgeInsets.only(
                                    left: 1.0, right: 1.0),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.0))),
                                child: Column(
                                  children: [
                                    Text(
                                      Constants.language == "en"
                                          ? "Days"
                                          : "يوم",
                                      style: TextStyle(
                                          fontFamily:
                                          Constants.language ==
                                              "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 8.0),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .remainingday!,
                                      style: const TextStyle(
                                        fontSize: 8.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(2.0),
                                margin: const EdgeInsets.only(
                                    left: 1.0, right: 1.0),
                                width: width * 0.09,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.0))),
                                child: Column(
                                  children: [
                                    Text(
                                      Constants.language == "en"
                                          ? "Hours"
                                          : "ساعة",
                                      style: TextStyle(
                                          fontFamily:
                                          Constants.language ==
                                              "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 8.0),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .remaininghours!,
                                      style: const TextStyle(
                                        fontSize: 8.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(2.0),
                                margin: const EdgeInsets.only(
                                    left: 1.0, right: 1.0),
                                width: width * 0.10,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.0))),
                                child: Column(
                                  children: [
                                    Text(
                                      Constants.language == "en"
                                          ? "Views"
                                          : "مشاهدة",
                                      style: TextStyle(
                                        fontFamily:
                                        Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      count.toString(),
                                      style: const TextStyle(
                                        fontSize: 8.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),*/
                              /* Container(
                          margin: const EdgeInsets.only(
                              top: 1.0, bottom: 10.0),
                          child: Text(
                            Constants.language == "en"
                                ? "Remaining Time"
                                : "الوقت المتبقي",
                            style: TextStyle(
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                                fontSize: 8.0),
                            textAlign: TextAlign.center,
                          ),
                        ),*/
                            ],
                          ),
                        ),
                      );
                    },
                  )
                else
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: offerads_model[parent_index].offersList!.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: width / 657,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          coupondata = offerads_model[parent_index]
                              .offersList![index]
                              .couponstatus
                              .toString();

                          if (widget.coupon_type == "friday") {
                            var date = DateTime.now();
                            if (date.weekday == DateTime.friday) {
                              Route route = MaterialPageRoute(
                                  builder: (context) => OfferDetailsScreen(
                                      Constants.language == "en"
                                          ? offerads_model[parent_index]
                                              .offersList![index]
                                              .companyName!
                                          : offerads_model[parent_index]
                                                  .offersList![index]
                                                  .companyArbName!
                                                  .isNotEmpty
                                              ? offerads_model[parent_index]
                                                  .offersList![index]
                                                  .companyArbName!
                                              : offerads_model[parent_index]
                                                  .offersList![index]
                                                  .companyName!,
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .companyId!,
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .discountdisplay!,
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .id!,
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .isfavorate!,
                                      "offers",
                                      "",
                                      coupondata,
                                      "",
                                      ""));
                              Navigator.push(context, route);
                            } else {
                              _alertDialog(Constants.language == "en"
                                  ? "The offer will be available on Friday"
                                  : "العرض متاح يوم الجمعة");
                            }
                          } else {
                            print("rohanss" +
                                offerads_model[parent_index]
                                    .offersList![index]
                                    .viewCount!);
                            Route route = MaterialPageRoute(
                                builder: (context) => OfferDetailsScreen(
                                    Constants.language == "en"
                                        ? offerads_model[parent_index]
                                            .offersList![index]
                                            .displayName!
                                        : offerads_model[parent_index]
                                                .offersList![index]
                                                .displayArbName!
                                                .isNotEmpty
                                            ? offerads_model[parent_index]
                                                .offersList![index]
                                                .displayArbName!
                                            : offerads_model[parent_index]
                                                .offersList![index]
                                                .displayName!,
                                    offerads_model[parent_index]
                                        .offersList![index]
                                        .companyId!,
                                    offerads_model[parent_index]
                                        .offersList![index]
                                        .discountdisplay!,
                                    offerads_model[parent_index]
                                        .offersList![index]
                                        .id!,
                                    offerads_model[parent_index]
                                        .offersList![index]
                                        .isfavorate!,
                                    "offers",
                                    "",
                                    coupondata,
                                    "",
                                    ""));
                            Navigator.push(context, route);
                            print("Company namess::::::::::" +
                                offerads_model[parent_index]
                                    .offersList![index]
                                    .companyName!);
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: const Color(0xFFE6D997),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 96,
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        offerads_model[parent_index]
                                                    .offersList![index]
                                                    .priority!
                                                    .isNotEmpty &&
                                                offerads_model[parent_index]
                                                        .offersList![index]
                                                        .priority!
                                                        .toLowerCase() !=
                                                    "priority-99"
                                            ? Image(
                                                image: AssetImage(offerads_model[
                                                                parent_index]
                                                            .offersList![index]
                                                            .priority!
                                                            .toLowerCase() ==
                                                        "priority-1"
                                                    ? "images/diamond.png"
                                                    : offerads_model[
                                                                    parent_index]
                                                                .offersList![
                                                                    index]
                                                                .priority!
                                                                .toLowerCase() ==
                                                            "priority-2"
                                                        ? "images/golden.png"
                                                        : offerads_model[
                                                                        parent_index]
                                                                    .offersList![
                                                                        index]
                                                                    .priority!
                                                                    .toLowerCase() ==
                                                                "priority-3"
                                                            ? "images/silver.png"
                                                            : "images/bronze.png"),
                                                width: width * 0.06,
                                                fit: BoxFit.fill,
                                              )
                                            : Container(),
                                        LikeButton(
                                          onTap: (bool) {
                                            return _addOrRemoveFavOffer(
                                                parent_index, index);
                                          },
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          size: width * 0.06,
                                          isLiked: offerads_model[parent_index]
                                                      .offersList![index]
                                                      .isfavorate! ==
                                                  "1"
                                              ? true
                                              : false,
                                          circleColor: const CircleColor(
                                              start: Color(0xff00ddff),
                                              end: Color(0xff0099cc)),
                                          bubblesColor: const BubblesColor(
                                            dotPrimaryColor: Color(0xff33b5e5),
                                            dotSecondaryColor:
                                                Color(0xff0099cc),
                                          ),
                                          likeBuilder: (bool isLiked) {
                                            return Icon(
                                              isLiked
                                                  ? CupertinoIcons.heart_fill
                                                  : CupertinoIcons.heart,
                                              color: isLiked
                                                  ? Colors.red
                                                  : Colors.black,
                                              size: width * 0.06,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    /*      Visibility(
                                          visible:offerads_model[parent_index]
                                              .offersList![index].couponstatus== "0" ? false : true,
                                          child: Center(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 58,right: 20,bottom:7,top: 53),
                                              height: 80,
                                              width: 80,

                                              foregroundDecoration:  RotatedCornerDecoration(

                                                color: Colors.lightGreen,
                                                geometry: const BadgeGeometry(width: 45, height: 40, cornerRadius: 7,alignment: BadgeAlignment.bottomRight),
                                                textSpan: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '"  "\n',
                                                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.redAccent),
                                                    ),
                                                    TextSpan(
                                                      text:   '" "\n',
                                                      style: TextStyle(fontSize: 4, fontStyle: FontStyle.italic, letterSpacing: 0.5, color: Colors.white),
                                                    ),
                                                    TextSpan(
                                                      text:   "    Coupon\n",
                                                      style: TextStyle(fontSize: 4, fontStyle: FontStyle.italic, letterSpacing: 0.5, color: Colors.white,fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                               // textSpan: TextSpan(text: '"\ncoupon\ncoupon', style: TextStyle(fontSize: 4, letterSpacing: 0.5,color: Colors.white)),
                                                //  geometry: const BadgeGeometry(width: 32, height: 32, cornerRadius: 16),
                                              ),
                                            ),
                                          ),
                                        ),*/
                                    Positioned(
                                      top: 10.0,
                                      right: 10.0,
                                      left: 10.0,
                                      child: CircleAvatar(
                                        radius: width * 0.10,
                                        backgroundImage: NetworkImage(
                                            company_image_base_url +
                                                offerads_model[parent_index]
                                                    .offersList![index]
                                                    .companylogo!),

                                        /*child:Visibility(
                                              visible: offerads_model[parent_index]
                                                  .offersList![index].couponstatus== "0" ? false : true,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom:1.0,left: 12,right:7),
                                                child: Container(
                                                  width: 50,
                                                  margin: EdgeInsets.only(left: 20),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),

                                                    alignment: Alignment.bottomRight,
                                                 // padding: const EdgeInsets.all(5),
                                                  child: const Text('', style: TextStyle(fontSize: 12)),
                                                  foregroundDecoration:  RotatedCornerDecoration(

                                                    color: Colors.lightGreen,
                                                    geometry: const BadgeGeometry(width: 25, height: 26, cornerRadius: 7,alignment: BadgeAlignment.bottomRight),
                                                    textSpan: TextSpan(text: 'coupon', style: TextStyle(fontSize: 5, letterSpacing: 0.5)),
                                                  //  geometry: const BadgeGeometry(width: 32, height: 32, cornerRadius: 16),
                                                  ),
                                                ),
                                              ),
                                            ),*/
                                      ),
                                    ),
                                  ],
                                ),
                                margin: const EdgeInsets.only(
                                    left: 2.0, right: 2.0, top: 2.0),
                              ),
                              Container(
                                // margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  Constants.language == "en"
                                      ? offerads_model[parent_index]
                                          .offersList![index]
                                          .displayName!
                                      : offerads_model[parent_index]
                                              .offersList![index]
                                              .displayArbName!
                                              .isNotEmpty
                                          ? offerads_model[parent_index]
                                              .offersList![index]
                                              .displayArbName!
                                          : offerads_model[parent_index]
                                              .offersList![index]
                                              .displayName!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : offerads_model[parent_index]
                                                  .offersList![index]
                                                  .displayArbName!
                                                  .isNotEmpty
                                              ? "Roboto" //GSSFont edited by rohan
                                              : "Roboto",
                                      fontWeight: FontWeight.bold,
                                      //  fontSize: 16.0
                                      fontSize: 14.0),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 1.0),
                                child: Text(
                                  offerads_model[parent_index]
                                              .offersList![index]
                                              .couponstatus ==
                                          "1"
                                      ? "Coupons"
                                      : offerads_model[parent_index]
                                          .offersList![index]
                                          .discountdisplay!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 1.0),
                                child: Text(
                                  Constants.language == "en"
                                      ? offerads_model[parent_index]
                                          .offersList![index]
                                          .discountEnDetail!
                                      : offerads_model[parent_index]
                                          .offersList![index]
                                          .discountArbDetail!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontSize: 12.0),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 1.0, left: 3.0, right: 3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      // width: width * 0.08,
                                      width: width * 0.12,
                                      margin: const EdgeInsets.only(
                                          left: 1.0, right: 1.0),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      child: Column(
                                        children: [
                                          Text(
                                            Constants.language == "en"
                                                ? "Days"
                                                : "يوم",
                                            style: TextStyle(
                                                fontFamily:
                                                    Constants.language == "en"
                                                        ? "Roboto"
                                                        : "GSSFont",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 8.0),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            offerads_model[parent_index]
                                                .offersList![index]
                                                .remainingday!,
                                            style: const TextStyle(
                                              fontSize: 8.0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    /* Container(
                                          padding: const EdgeInsets.all(2.0),
                                          margin: const EdgeInsets.only(
                                              left: 1.0, right: 1.0),
                                          width: width * 0.09,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: Column(
                                            children: [
                                              Text(
                                                Constants.language == "en"
                                                    ? "Hours"
                                                    : "ساعة",
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constants.language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 8.0),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                offerads_model[parent_index]
                                                    .offersList![index]
                                                    .remaininghours!,
                                                style: const TextStyle(
                                                  fontSize: 8.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),*/
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      margin: const EdgeInsets.only(
                                          left: 1.0, right: 1.0),
                                      //width: width * 0.10,
                                      width: width * 0.12,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      child: Column(
                                        children: [
                                          Text(
                                            Constants.language == "en"
                                                ? "Views"
                                                : "مشاهدة",
                                            style: TextStyle(
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8.0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            offerads_model[parent_index]
                                                .offersList![index]
                                                .viewCount!,
                                            style: const TextStyle(
                                              fontSize: 8.0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 1.0, bottom: 10.0),
                                child: Text(
                                  Constants.language == "en"
                                      ? "Remaining Time"
                                      : "الوقت المتبقي",
                                  style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontSize: 8.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                Visibility(
                  visible:
                      offerads_model[parent_index].iAd == "1" ? true : false,
                  child: InkWell(
                    onTap: () async {
                      if (offerads_model[parent_index]
                          .adsList
                          .url!
                          .isNotEmpty) {
                        if (offerads_model[parent_index]
                            .adsList
                            .url!
                            .contains("https://instagram.com/")) {
                          String trimmed_url = offerads_model[parent_index]
                              .adsList
                              .url!
                              .replaceAll("https://instagram.com/", "");
                          var split_url = trimmed_url.split("?");
                          String native_url =
                              "instagram://user?username=${split_url[0]}";
                          if (await canLaunch(native_url)) {
                            launch(native_url);
                          } else {
                            launch(
                              offerads_model[parent_index].adsList.url!,
                              universalLinksOnly: true,
                            );
                          }
                        } else {
                          Route route = MaterialPageRoute(
                              builder: (context) => WebViewScreen("",
                                  offerads_model[parent_index].adsList.url!));
                          Navigator.push(context, route);
                        }
                      }
                      bannercount(int.parse(offerads_model[parent_index]
                          .adsList
                          .addId
                          .toString()));
                      print("call::::::");
                      print(bannercount.toString());
                    },
                    child: Container(
                      height: 70.0,
                      width: width,
                      margin: const EdgeInsets.all(5.0),
                      child: Image(
                        width: width,
                        height: 70.0,
                        image: NetworkImage(
                          ads_image_base_url +
                              offerads_model[parent_index].adsList.addImage!,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isPaginationLoading,
                  child: const SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        Visibility(
          visible: _isLoading,
          child: const Center(
            child: SizedBox(
              width: 40.0,
              height: 40.0,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
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
} //    HERE START CART LIST SCREEN ******************************************************
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

class CartlistScreen extends StatefulWidget {
  const CartlistScreen({Key? key}) : super(key: key);

  @override
  State<CartlistScreen> createState() => _CartlistScreenState();
}

class _CartlistScreenState extends State<CartlistScreen> {
  List<CartList>? cartlist = [];
  String fastDeliveryCharges = '';
  String spclDeliveryCharges = '';
  bool isFastDelivery = false;

  var imagebase_url = "";
  var company_image = "";
  int _itemCount = 0;
  var fluttercount = "";
  var cartamount = "0";
  var cardinit = "0";
  var cartid = "0";
  var branchid = "";
  var productid = "";
  var companyid = "";
  var discount = "";
  var price1 = "";
  var price2 = "";
  var pro;
  var i = 0;
  var cartidconter = "0";
  bool _isLoading = true;
  String companycount = "";

  var companydatacount;

  var distinctIds;
  List uniqueList = [];
  //var vlistdata;
  var companyidlist = "";
  var cartiddata = "";

  Future<void> getcartlist(companyidlist) async {
    print("apidata" + companyidlist);
    String url =
        "http://cp.citycode.om/public/index.php/cartlist?userid=${Constants.user_id}&companyid=${companyidlist}";
    var network = NewVendorApiService();
    var res = await network.getresponse(url);
    var vlistdata = Cartlistmodel.fromJson(res);
    imagebase_url = vlistdata.imageBaseUrl.toString();
    company_image = vlistdata.companyImageBaseUrl.toString();

    companydatacount =
        vlistdata.cartList?.where((e) => e.companyId == e.companyId).toList();

    final jsonList = companydatacount!.map((item) => jsonEncode(item)).toList();
    final uniqueJsonList = jsonList!.toSet().toList();

    final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();

    print(result.length);

    vlistdata.cartList?.forEach((element) {
      cartlist?.removeWhere((e) => element.companyId == e.companyId);
      cartlist?.add(element);
    });

    vlistdata.cartList != cartlist;

    setState(() {
      _isLoading = false;
    });
    setState(() {
      cartlist = vlistdata.cartList!;
    });
    setState(() {
      _isLoading = false;
    });
    print("cartcomapnydataafound:::" + companyidlist);
    cartlistsummery(companyidlist);
    print("listdata" + res!.toString());
  }

  String qty = "";
  String actualprice = "";
  String afterdiscount = "";
  String deliverycharge = "";
  String totalprice = "";
  String totalpoints = "";
  String productimage = "";
  String productname = "";
  String arbproductname = "";
  String cartqtyy = "";
  String deliveryType = '';
  String vat = '';

  Future<void> cartlistsummery(companyidlist) async {
    http: //cp.citycode.om/public/index.php/cartlistsummary?userid=22064&companyid=199&branch_id=131&delivery_charge=fast
    String url =
        "http://cp.citycode.om/public/index.php/cartlistsummary?userid=${Constants.user_id}&companyid=$companyidlist&branch_id=${Constants.branchID}&delivery_charge=$deliveryType";
    print("deliveryType$deliveryType");
    var network = NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = Cartsummerymodel.fromJson(res);

    setState(() {
      _isLoading = false;
    });
    setState(() {
      qty = vlist.cartSummary!.qty.toString();
      actualprice = vlist.cartSummary!.productCostMobile.toString();

      vat = vlist.cartSummary!.vat!;
      deliverycharge = vlist.cartSummary!.deliveryCharge.toString();
      afterdiscount = vlist.cartSummary!.productDiscountMobile.toString();
      totalprice = vlist.cartSummary!.totalPrice.toString();
      totalpoints = vlist.cartSummary!.point.toString();
    });
    setState(() {
      _isLoading = false;
    });
    print("" + res!.toString());
  }

  List<CompanyCartList>? cartcomapny = [];
  Future<void> cartliscompany() async {
    String url =
        "http://cp.citycode.om/public/index.php/companycartlist?userid=" +
            Constants.user_id;
    var network = NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = CartlistcompanyModel.fromJson(res);

    setState(() {
      cartcomapny = vlist.companyCartList;
    });
    _isLoading = false;
    print("cartcomapnydataa:::" + companyidlist);
    cartlistsummery(companyidlist);
    print("companylist" + res!.toString());
  }

  Future<void> deletecart(cartiddata) async {
    Map<String, String> jsonbody = {
      "userid": Constants.user_id,
      "cart_id": cartiddata,
    };
    print("useridbhai" + Constants.user_id);
    print("cradidbhai" + cartiddata);
    var network = NewVendorApiService();
    String urls = "http://cp.citycode.om/public/index.php/cartremove";
    var res = await network.postresponse(urls, jsonbody);
    var deletemodel = DeletecartModel.fromJson(res);
    String stat = deletemodel.status.toString();

    print("dgdsgdsg" + stat);

    if (stat.contains("201")) {
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: " Item Deleted ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Somthing Went Wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      _isLoading = false;
    });
    print("Delete Cart" + res!.toString());
  }

  int cartqty = 0;
  Future<void> addqauntiy(cartqty, cartiddata) async {
    Map<String, String> jsonbody = {
      "cartid": cartiddata,
      "Quantity": cartqty,
    };
    print("useridbhai" + cartqty);
    print("cradidbhai" + cartiddata);
    var network = NewVendorApiService();
    String urls = "http://cp.citycode.om/public/index.php/editquantity";
    var res = await network.postresponse(urls, jsonbody);
    var deletemodel = QuantityModel.fromJson(res);
    String stat = deletemodel.status.toString();

    cartlistsummery(companyidlist);
    print("dgdsgdsg" + stat);

    if (stat.contains("201")) {
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: " Item added ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
    print("Added Cart" + res!.toString());
  }

  Future<void> _getCompanyDetails(String id) async {
    try {
      final response = await http.get(
        Uri.parse('http://185.188.127.11/public/index.php/ApiCompany/$id'),
      );
      if (response.statusCode == 200) {
        CompanyDetailsModel1? companyDetailsModel =
            companyDetailsModel1FromJson(response.body);
        var data = companyDetailsModel.companyBranch;
        fastDeliveryCharges = data[0].fastDeliveryCharges;
        spclDeliveryCharges = data[0].specialDeliveryCharges;
        Constants.branchID = data[0].branchId;

        if (cartcomapny != null && cartcomapny!.isNotEmpty) {
          final company = Constants.language == "en"
              ? cartcomapny![0].branchName ?? ''
              : cartcomapny![0].arbBranchName != null &&
                      cartcomapny![0].arbBranchName!.isNotEmpty
                  ? cartcomapny![0].arbBranchName!
                  : cartcomapny![0].branchName ?? '';
        }
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      print(error.toString());
    }
    setState(() {});
  }

  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.teal,
      backgroundColor: const Color(0xFFF2CC0F),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Visibility(
          visible: !_visible,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Visibility(
                visible: !_visible,
                child: ElevatedButton(
                  onPressed: () {
                    // transactionapi();
                    setState(() {
                      _visible = true;
                      // loading=true;
                    });
                  },
                  child: Text(
                    Constants.language == "en" ? "Back" : "Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
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
                        width: 1.0,
                      ),
                    ),
                    fixedSize: const Size(20, 35.0),
                  ),
                ),
              ),
              Container(
                width: 140,
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: ElevatedButton(
                  onPressed: () async {
                    deliveryType = 'special';
                    _getCompanyDetails(companyidlist);

                    await cartlistsummery(companyidlist);

                    setState(() {
                      _isLoading = true;
                      isFastDelivery = false;
                      //  transactionapi();
                    });
                    _showdialog(context, width);
                  },
                  child: Text(
                    Constants.language == "en"
                        ? "Special Delivery"
                        : "شراء مع توصيل",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                      fontSize: 15.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFF2CC0F),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 170,
                child: ElevatedButton(
                  onPressed: () async {
                    deliveryType = 'fast';

                    setState(() {
                      _isLoading = false;
                      isFastDelivery = true;
                    });
                    await cartlistsummery(companyidlist);

                    _showdialog(context, width);
                  },
                  child: Text(
                    Constants.language == "en"
                        ? "Fast Delivery"
                        : "شراء بدون توصيل",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                      fontSize: 15.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFF2CC0F),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
      body: Stack(
        children: [
          Visibility(
            visible: _visible,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              margin: const EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                  itemCount: cartcomapny!.length,
                  itemBuilder: (context, index) {
                    var c = cartcomapny![index].companyId.toString();
                    print("bongabo" + c);
                    var companytext = Constants.language == "en"
                        ? cartcomapny![index].companyName!
                        : cartcomapny![index].companyArbName!;
                    i = index;
                    print(cartlist?.where((e) => e.companyId == 103).length);
                    productimage = imagebase_url +
                        cartcomapny![index].companyImage.toString();
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });

                        setState(() {
                          print("bjkbjkbjbjb" + c);
                          companyidlist = c;
                          print("datfound" + companyidlist);
                          getcartlist(companyidlist);
                          _getCompanyDetails(companyidlist);

                          _visible = !_visible;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        margin: const EdgeInsets.only(top: 10.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE6D997),
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          children: [
                            cartcomapny![index].companyImage!.isNotEmpty
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        company_image +
                                            cartcomapny![index].companyImage!),
                                  )
                                : const Image(
                                    image: AssetImage(
                                        "images/circle_app_icon.png"),
                                    width: 60.0,
                                    height: 60.0,
                                  ),
                            Container(
                              width: 220,
                              margin:
                                  const EdgeInsets.only(left: 10.0, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    companytext,
                                    style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 500,
                                    child: Text(
                                      Constants.language == "en"
                                          ? (cartcomapny != null &&
                                                  cartcomapny!.isNotEmpty &&
                                                  cartcomapny![index]
                                                          .branchName !=
                                                      null)
                                              ? cartcomapny![index].branchName!
                                              : ''
                                          : (cartcomapny != null &&
                                                  cartcomapny!.isNotEmpty &&
                                                  cartcomapny![index]
                                                          .arbBranchName
                                                          ?.isNotEmpty ==
                                                      true)
                                              ? cartcomapny![index]
                                                  .arbBranchName!
                                              : (cartcomapny != null &&
                                                      cartcomapny!.isNotEmpty &&
                                                      cartcomapny![index]
                                                              .branchName !=
                                                          null)
                                                  ? cartcomapny![index]
                                                      .branchName!
                                                  : '',
                                      style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Directionality(
                              textDirection: Constants.language == "en"
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              child: Align(
                                child: IconButton(
                                  icon: const Icon(CupertinoIcons.arrow_right),
                                  iconSize: 18.0,
                                  color: Colors.green,
                                  onPressed: () async {
                                    var data = productname =
                                        cartlist![index].productName.toString();
                                    print("dataerro" + data.toString());
                                  },
                                ),
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Visibility(
            visible: !_visible,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              margin: const EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                  itemCount: cartlist!.length,
                  itemBuilder: (context, index) {
                    var companytext = Constants.language == "en"
                        ? cartlist![index].productName.toString()
                        : cartlist![index].arbProductName!;
                    productimage =
                        imagebase_url + cartlist![index].picture.toString();
                    productname = cartlist![index].productName.toString();
                    arbproductname = cartlist![index].arbProductName.toString();
                    cartid = cartlist![index].cartId.toString();
                    branchid = cartlist![index].branchId.toString();
                    productid = cartlist![index].productId.toString();
                    companyid = cartlist![index].companyId.toString();
                    price1 = cartlist![index].productCostMobile.toString();
                    price2 = cartlist![index].productDiscountMobile.toString();
                    cardinit = cartlist![index].cartId.toString();
                    cartqtyy = cartlist![index].qty.toString();
                    print("cartjiii::" + cartid);

                    return GestureDetector(
                      onTap: () {
                        print("initialization" + cardinit);

                        var priceone = price1;
                        var pricetwo = price2;
                        String productname = cartlist![index].productName!;
                        String arbproductname =
                            cartlist![index].arbProductName!;

                        String description = cartlist![index].description!;

                        var product_mobile =
                            cartlist![index].productCostMobile.toString();
                        var productdiscountmobile =
                            cartlist![index].productDiscountMobile.toString();

                        var companyname =
                            cartlist![index].companyName.toString();

                        var branchname = cartlist![index].branchName.toString();
                        var arbbranchname =
                            cartlist![index].arbBranchName.toString();
                        var companyimage = company_image +
                            cartlist![index].companyImage.toString();

                        Route route = MaterialPageRoute(
                            builder: (context) => booknow(
                                companyname,
                                companyimage,
                                Constants.user_id,
                                branchid,
                                productimage,
                                "product_detailsdescription2description3",
                                "user",
                                "",
                                "",
                                "0",
                                "0",
                                priceone,
                                pricetwo,
                                productname,
                                description,
                                branchname,
                                arbproductname,
                                arbbranchname,
                                totalpoints,
                                productid,
                                product_mobile,
                                productdiscountmobile,
                                branchid,
                                companyid,
                                "",
                                "",
                                "",
                                cartlist![index].qty.toString()));
                        Navigator.push(context, route);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        margin: const EdgeInsets.only(top: 10.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE6D997),
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            cartlist![index].picture.toString().isNotEmpty
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        imagebase_url +
                                            cartlist![index]
                                                .picture
                                                .toString()),
                                  )
                                : const Image(
                                    image: AssetImage(
                                        "images/circle_app_icon.png"),
                                    width: 40.0,
                                    height: 40.0,
                                  ),
                            Column(
                              children: [
                                Container(
                                  //color:Colors.grey,
                                  margin: const EdgeInsets.only(right: 200),

                                  //width:350,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: 150,
                                            // color:Colors.grey,
                                            margin: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text(
                                              companytext.length > 20
                                                  ? '${companytext.substring(0, 10)}...'
                                                  : companytext,
                                              style: TextStyle(
                                                  fontFamily:
                                                      Constants.language == "en"
                                                          ? "Roboto"
                                                          : "GSSFont",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                          Container(
                                            height: 30,
                                            //  margin: EdgeInsets.only(left: 70),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15))),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10,
                                                            left: 10),
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                        Icons.remove,
                                                        size: 30)),
                                                MaterialButton(
                                                  // color:   Color(0xFFE6D997),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 1),
                                                  minWidth: 10,
                                                  //     color: Color(0xFFB005BA),
                                                  shape:
                                                      const BeveledRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                    Radius.circular(5),
                                                  )),
                                                  onPressed: () {
                                                    var cartidd =
                                                        cartlist![index]
                                                            .cartId
                                                            .toString();
                                                    cartidconter = cartidd;
                                                    print("cartdata1" + cartid);
                                                    print("cartdost" +
                                                        cartidconter);

                                                    var _itemCount =
                                                        cartlist![index]
                                                            .qty
                                                            .toString();
                                                    print("_itemCount" +
                                                        _itemCount);
                                                    _itemCount = _itemCount;
                                                  },
                                                  child: Text(
                                                    cartid == cartidconter
                                                        ? fluttercount
                                                            .toString()
                                                        : cartqtyy,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                IconButton(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20,
                                                            bottom: 10),
                                                    onPressed: () {},
                                                    icon: const Icon(Icons.add,
                                                        size: 30)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 74,
                                      margin: const EdgeInsets.only(
                                          right: 10, left: 1),
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Text(
                                          cartlist![index]
                                              .productCostMobile
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationThickness: 2.85,
                                            decorationColor: Colors.red,
                                          )),
                                    ),
                                    Container(
                                      width: 90,
                                      margin:
                                          const EdgeInsets.only(right: 60.0),
                                      // margin: const EdgeInsets.only(right: 320.0),
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Text(
                                          cartlist![index]
                                              .productDiscountMobile
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              decorationColor: Colors.red,
                                              color: Colors.green)),
                                    ),
                                    Container(
                                      margin:
                                          const EdgeInsets.only(right: 170.0),
                                      child: IconButton(
                                        icon: const Icon(
                                            CupertinoIcons.delete_solid),
                                        iconSize: 18.0,
                                        color: Colors.red,
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text(
                                                        Constants.language ==
                                                                "en"
                                                            ? 'Are you sure you want to delete this Item ?'
                                                            : "هل أنت متأكد أنك تريد حذف هذه الرسالة ؟",
                                                        style: TextStyle(
                                                          fontFamily: Constants
                                                                      .language ==
                                                                  "en"
                                                              ? "Roboto"
                                                              : "GSSFont",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text(
                                                      'NO',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text(
                                                      'YES',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    onPressed: () async {
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      //   bool isdeleted= await deletecart();
                                                      cartiddata =
                                                          cartlist![index]
                                                              .cartId
                                                              .toString();
                                                      print("deletekya" +
                                                          cartiddata);
                                                      var cartdada = cartiddata;
                                                      print("cartdata" +
                                                          cartdada);
                                                      deletecart(cartdada);

                                                      setState(() {
                                                        cartlist!
                                                            .removeAt(index);
                                                      });

                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
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
    );
  }

  @override
  void initState() {
    // _itemCount=fluttercount as int;
    cartid;
    _getCompanyDetails(companyidlist);
    cartliscompany();
    print(uniqueList);

    print('');

    print('${companydatacount.runtimeType} : $companydatacount');
    print(distinctIds);
    cartlistsummery(companyidlist);
    getcartlist(companyid);
    super.initState();
  }

  _alertShow(BuildContext context, String type) {
    CoolAlert.show(
      backgroundColor: const Color(0xFFF2CC0F),
      context: context,
      type: type == "success" ? CoolAlertType.success : CoolAlertType.error,
      text: type == "success"
          ? Constants.language == "en"
              ? "Online Payment"
              : "تم ارسال الرسالة"
          : Constants.language == "en"
              ? "Message not sent"
              : "لم يتم إرسال الرسالة",
      confirmBtnText: Constants.language == "en" ? "Success" : "أستمرار",
      cancelBtnText: Constants.language == "en" ? "Not Success" : "أستمرار",
      barrierDismissible: true,
      confirmBtnColor: const Color(0xFFF2CC0F),
      confirmBtnTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont"),
      cancelBtnTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont"),
      onConfirmBtnTap: () {
        if (type == "success") {
          Navigator.of(context, rootNavigator: true).pop();
        } else {
          Navigator.of(context).pop();
        }
      },
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

  _showdialog(BuildContext context, double width) {
    Dialog dialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        //this right here
        child: SizedBox(
            height: 700,
            width: MediaQuery.of(context).size.width * 0.90,
            child: SingleChildScrollView(
                child: Column(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(),
                              Container(
                                margin: const EdgeInsets.only(left: 50),
                                child: Center(
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(productimage),
                                    radius: 40.0,
                                  ),
                                ),
                              ),
                              IconButton(
                                iconSize: 30.0,
                                onPressed: () {
                                  Constants.arb_companyname = "";
                                  Constants.branchid = "";
                                  Constants.image = "";
                                  Constants.redeempoint = "";
                                  Constants.discount = "";
                                  Constants.notification_id = "";
                                  Constants.arb_branchname = "";
                                  Constants.paidamount = "";
                                  Constants.companyid = "";
                                  Constants.saveamount = "";
                                  Constants.totalamount = "";
                                  Constants.companyname = "";
                                  Constants.notificationtype = "";
                                  Constants.order_id = "";
                                  Constants.branchname = "";
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                icon: const Icon(
                                    CupertinoIcons.clear_circled_solid),
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      Constants.language == "en" ? productname : arbproductname,
                      style: TextStyle(
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 250.0,
                    margin: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 10.0, bottom: 50),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2CC0F),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Text(
                            Constants.language == "en"
                                ? "Quantity"
                                : "Quantity",
                            style: TextStyle(
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            qty,
                            // widget.state2.toString(),
                            //   total.toString(),

                            style: const TextStyle(fontFamily: "Roboto"),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          height: 1.0,
                          color: Colors.black,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                Constants.language == "en"
                                    ? "Actual Price:"
                                    : "السعر الأصلي",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(actualprice,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: "Roboto",
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2.85,
                                      decorationColor: Colors.red,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          height: 1.0,
                          color: Colors.black,
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: [
                                  Text(
                                    /*Constants.language == "en"
                                    ? "Amount To Pay"
                                    : "المبلغ للدفع",*/

                                    Constants.language == "en"
                                        ? "After Discount + Delivery Charges:"
                                        : "بعد الخصم",
                                    style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      afterdiscount,
                                      style:
                                          const TextStyle(fontFamily: "Roboto"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              height: 1.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                Constants.language == "en"
                                    ? "VAT"
                                    : "سعر التوصيل",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  vat,
                                  // itemdeliver.toString(),
                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          height: 1.0,
                          color: Colors.black,
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Text(
                                Constants.language == "en"
                                    ? "Total price "
                                    : "السعر النهائي",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  totalprice,
                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                height: 1.0,
                                color: Colors.black,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                ),
                                child: Text(
                                  Constants.language == "en"
                                      ? "Points "
                                      : "عدد النقاط",
                                  style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  totalpoints,
                                  //   total.toString(),

                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                height: 1.0,
                                color: Colors.black,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 20, left: 10, right: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _alertShow(context, "success");
                                  },
                                  child: Text(
                                    Constants.language == "en"
                                        ? " Pay now"
                                        : "أدفع الان",
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    fixedSize: Size(width, 35.0),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _alertDialog("Not Available");
                                  },
                                  child: Text(
                                    Constants.language == "en"
                                        ? "Pay By Cash"
                                        : "الدفع نقدا",
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    fixedSize: Size(width, 35.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]))));

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => dialog);
  }
}

//    HERE END OF CART LIST SCREEN ??88888REIOJFHRE UGIUT 43T R4P Q4UR4 4EUI3TUI4QHURC UIQWR UIWQ4UH U3UH UF3Y4YUH

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  int tempIndex = 0;

  bool _isLoading = false;
  var company_image = "";
  var product_image = "";
  bool visible = true;
  List<MyOrder>? orderCompanylist = [];
  List<MyOrder> OrderSummery = [];
  Future<void> orderCompanyListMethod() async {
    String url = "http://cp.citycode.om/public/index.php/myorders?userid=" +
        Constants.user_id;
    var network = NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = OrderListModel.fromJson(res);
    print(vlist.status);
    print(Constants.user_id);

    //  _isLoading = true;

    setState(() {
      orderCompanylist = vlist.myOrder;
      company_image = vlist.companyImageBaseUrl.toString();
      product_image = vlist.productImageBaseUrl.toString();
    });
    _isLoading = false;

    print("companylist" + res!.toString());
  }

  @override
  void initState() {
    _isLoading = true;
    orderCompanyListMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF2CC0F),
      bottomNavigationBar: Visibility(
        visible: !visible,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5 - 20,
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  // transactionapi();
                  setState(() {
                    visible = true;
                    OrderSummery.clear();
                    // loading=true;
                  });
                  //_showdialog(context,width);

                  //   _textMethiodDialog(context, width);
                },
                child: Text(
                  Constants.language == "en" ? "Back" : "Back",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFF2CC0F),
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  fixedSize: const Size(20, 35.0),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5 - 20,
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  Constants.language == "en" ? "Invoice" : "Invoice",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFF2CC0F),
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  fixedSize: const Size(20, 35.0),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Visibility(
            visible: visible,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              // margin: const EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                  itemCount: orderCompanylist!.length,
                  itemBuilder: (context, index) {
                    var c = orderCompanylist![index].companyId.toString();
                    print("bongabo" + c);
                    var companytext = Constants.language == "en"
                        ? orderCompanylist![index].productName!
                        : orderCompanylist![index].arbProductName!;
                    //  i=index;
                    //cartlist.where((c) =>  == someProductId).length;
                    //  cartlist?.where((e) => e.companyId==103).length;

                    return GestureDetector(
                      onTap: () {
                        tempIndex = index;
                        setState(() {
                          // for (var data in orderCompanylist!) {
                          //   if (orderCompanylist![index].companyId ==
                          //       data.companyId) {
                          //     OrderSummery.add(MyOrder(
                          //         productName: data.productName,
                          //         arbProductName: data.arbProductName,
                          //         supplierVatCharges: data.supplierVatCharges,
                          //         actualPrice: data.actualPrice,
                          //         totalAmount: data.totalAmount,
                          //         picture: data.picture,
                          //         createdDate: data.createdDate,
                          //         orderId: data.orderId,
                          //         originalPrice: data.originalPrice,
                          //         qty: data.qty,
                          //         branchName: data.branchName));
                          //   }
                          // }

                          //  _isLoading = true;
                        });

                        setState(() {
                          visible = !visible;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        margin: const EdgeInsets.only(top: 10.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE6D997),
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          children: [
                            orderCompanylist![index].picture!.isNotEmpty
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        product_image +
                                            orderCompanylist![index].picture!),
                                  )
                                : const Image(
                                    image: AssetImage(
                                        "images/circle_app_icon.png"),
                                    width: 60.0,
                                    height: 60.0,
                                  ),
                            Container(
                              // color: Colors.grey,
                              width: 220,
                              margin:
                                  const EdgeInsets.only(left: 10.0, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    companytext,
                                    // companytext.length > 16 ? '${ companytext.substring(0, 10)}......' :  companytext,
                                    style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  Text(
                                    "Waiting",
                                    // companytext.length > 16 ? '${ companytext.substring(0, 10)}......' :  companytext,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        //  fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  SizedBox(
                                    //  color: Colors.grey,
                                    width: 500,
                                    /*margin:
                                                     const EdgeInsets.only(right: 10),*/
                                    child: Text(
                                      orderCompanylist![index].createdDate!,
                                      /* Constants.language == "en"
                                        ? orderCompanylist![index].branchName!
                                        : orderCompanylist![index]
                                        .arbBranchName!
                                        .isNotEmpty
                                        ? cartcomapny![index]
                                        .arbBranchName!
                                        : cartcomapny![index]
                                        .branchName!,*/
                                      style: TextStyle(
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          fontSize: 14.0),
                                    ),
                                  ),
                                  Text(
                                    "Order Id:" +
                                        orderCompanylist![index]
                                            .orderId
                                            .toString(),
                                    // companytext.length > 16 ? '${ companytext.substring(0, 10)}......' :  companytext,
                                    style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        //  fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                            Directionality(
                              textDirection: Constants.language == "en"
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              child: const Icon(
                                CupertinoIcons.arrow_right,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Visibility(
            visible: !visible,
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  var c = orderCompanylist![index].companyId.toString();
                  print("bongabo" + c);
                  var companytext = Constants.language == "en"
                      ? orderCompanylist![index].productName!
                      : orderCompanylist![index].arbProductName!;
                  //  i=index;
                  //cartlist.where((c) =>  == someProductId).length;
                  //  cartlist?.where((e) => e.companyId==103).length;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        //  _isLoading = true;
                      });

                      setState(() {
                        //   visible=!visible;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      margin:
                          const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE6D997),
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: [
                          Container(
                            /* decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),*/
                            child: Row(
                              children: [
                                orderCompanylist![tempIndex].picture!.isNotEmpty
                                    ? CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            product_image +
                                                orderCompanylist![tempIndex]
                                                    .picture!),
                                      )
                                    : const Image(
                                        image: AssetImage(
                                            "images/circle_app_icon.png"),
                                        width: 60.0,
                                        height: 60.0,
                                      ),
                                Container(
                                  // color: Colors.grey,
                                  width: 220,
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orderCompanylist![tempIndex]
                                            .productName
                                            .toString(),
                                        // companytext.length > 16 ? '${ companytext.substring(0, 10)}......' :  companytext,
                                        style: TextStyle(
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      Text(
                                        "Waiting",
                                        // companytext.length > 16 ? '${ companytext.substring(0, 10)}......' :  companytext,
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",
                                            //  fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      SizedBox(
                                        //  color: Colors.grey,
                                        width: 500,
                                        /*margin:
                                                           const EdgeInsets.only(right: 10),*/
                                        child: Text(
                                          orderCompanylist![tempIndex]
                                              .createdDate!,
                                          /* Constants.language == "en"
                                              ? orderCompanylist![index].branchName!
                                              : orderCompanylist![index]
                                              .arbBranchName!
                                              .isNotEmpty
                                              ? cartcomapny![index]
                                              .arbBranchName!
                                              : cartcomapny![index]
                                              .branchName!,*/
                                          style: TextStyle(
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont",
                                              fontSize: 14.0),
                                        ),
                                      ),
                                      Text(
                                        "Order Id:" +
                                            orderCompanylist![tempIndex]
                                                .orderId
                                                .toString(),
                                        // companytext.length > 16 ? '${ companytext.substring(0, 10)}......' :  companytext,
                                        style: TextStyle(
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",
                                            //  fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 2,
                            width: width,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Order Summery",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    miscRow(
                                        name: "Product Name",
                                        Titlename: orderCompanylist![tempIndex]
                                            .productName
                                            .toString(),
                                        onTap: () {}),
                                    miscRow(
                                        name: "Branch Name",
                                        Titlename: orderCompanylist![tempIndex]
                                            .branchName
                                            .toString(),
                                        onTap: () {}),
                                    miscRow(
                                        name: "Quantity",
                                        Titlename: orderCompanylist![tempIndex]
                                            .qty
                                            .toString(),
                                        onTap: () {}),
                                    /* miscRow(
                                      name: "Actual Price",
                                      Titlename: orderCompanylist![tempIndex].originalPrice.toString(), onTap: () {  }),*/
                                    miscRow(
                                        name: "Actual Price",
                                        Titlename: orderCompanylist![tempIndex]
                                            .actualPrice
                                            .toString(),
                                        onTap: () {}),
                                    miscRow(
                                        name: "Total price",
                                        Titlename: orderCompanylist![tempIndex]
                                            .totalAmount
                                            .toString(),
                                        onTap: () {}),
                                    miscRow(
                                        name: "Delivery Address",
                                        Titlename: Constants.adressOfusers,
                                        onTap: () {}),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
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
    );
  }

  miscRow(
      {required String Titlename,
      required String name,
      required GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                name,
                //  Titlename,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 20),
            const Text(
              ":-",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 150,
              child: Text(
                Titlename,
                // name,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}

class OnlineShopScreen extends StatefulWidget {
  const OnlineShopScreen({Key? key}) : super(key: key);

  @override
  _OnlineShopScreenState createState() => _OnlineShopScreenState();
}

class _OnlineShopScreenState extends State<OnlineShopScreen> {
  bool _isLoading = true;
  late Future<Favourite_model> favourite_offers = _getFavouriteOffers();
  List<Companylist>? offersList = [];
  List<Companylist>? offersList_ads = [];
  List<Favouratelist>? favList = [];
  List<OnlineOfferAdsModel> offerads_model = [];
  List<AdsListModel> adsList = [];
  List<String> fav = [];
  String company_image_base_url = "";
  NetworkCheck networkCheck = NetworkCheck();
  String ads_image_base_url = "";
  var scrollcontroller = ScrollController();
  int _pageSize = 0, page = 1, maxPage = 0;
  bool _isPaginationLoading = false;

  Future<OnlineShopModel> _getOnlineOffers(int page) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/onlineshop?page=$page'));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
          return OnlineShopModel.fromJson(jsonDecode(response.body));
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
        if (response.statusCode == 404) {
          if (Constants.language == "en") {
            _alertDialog("No Offers Available");
          } else {
            _alertDialog("لا توجد عروض متاحة");
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

  Future<AdvertisementModel> _getAds() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(
          Uri.parse('http://185.188.127.11/public/index.php/getdashboardadd'));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
          return AdvertisementModel.fromJson(jsonDecode(response.body));
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

  Future<Favourite_model> _getFavouriteOffers() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/ApiFavorate?customer_id=' +
              Constants.user_id));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
          return Favourite_model.fromJson(jsonDecode(response.body));
        } else {
          int count = 0;
          // _getPublicOffers().then((value) => {
          //       if (value.companylist != null && value.companylist!.length > 0)
          //         {
          //           for (int i = 0; i < value.companylist!.length; i++)
          //             {
          //               offersList!.add(value.companylist![i]),
          //               fav.add("0"),
          //             },
          //           count = offersList!.length,
          //           for (int i = 0; i < count; i++)
          //             {
          //               for (int j = i + 1; j < count; j++)
          //                 {
          //                   if (offersList![i].id == offersList![j].id)
          //                     {
          //                       offersList!.removeAt(j),
          //                       fav.removeAt(j),
          //                       count--,
          //                     }
          //                 },
          //             }
          //         },
          //       setState(() {
          //         company_image_base_url = value.imageBaseUrl!;
          //         _isLoading = false;
          //       }),
          //     });
          throw Exception('Failed to load album');
        }
      } else {
        int count = 0;
        // _getPublicOffers().then((value) => {
        //       if (value.companylist != null && value.companylist!.length > 0)
        //         {
        //           for (int i = 0; i < value.companylist!.length; i++)
        //             {
        //               offersList!.add(value.companylist![i]),
        //               fav.add("0"),
        //             },
        //           count = offersList!.length,
        //           for (int i = 0; i < count; i++)
        //             {
        //               for (int j = i + 1; j < count; j++)
        //                 {
        //                   if (offersList![i].id == offersList![j].id)
        //                     {
        //                       offersList!.removeAt(j),
        //                       fav.removeAt(j),
        //                       count--,
        //                     }
        //                 },
        //               for (int i = 0; i < favList!.length; i++)
        //                 {
        //                   for (int j = 0; j < offersList!.length; j++)
        //                     {
        //                       if (favList![i].offerId == offersList![j].id)
        //                         {
        //                           fav[j] = "1",
        //                         }
        //                     }
        //                 }
        //             }
        //         },
        //       setState(() {
        //         company_image_base_url = value.imageBaseUrl!;
        //         _isLoading = false;
        //       }),
        //     });
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

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        (page < maxPage)) {
      setState(() {
        _isPaginationLoading = true;
        page += 1;
        _getOnlineOffers(page).then((value) => {
              if (mounted)
                {
                  setState(() {
                    if (value.companylist != null &&
                        value.companylist!.isNotEmpty) {
                      offerads_model.add(OnlineOfferAdsModel(
                          value.companylist!, value.dashAdvertise!, "1"));
                    }
                    _isPaginationLoading = false;
                  }),
                }
              else
                {
                  if (value.companylist != null &&
                      value.companylist!.isNotEmpty)
                    {
                      offerads_model.add(OnlineOfferAdsModel(
                          value.companylist!, value.dashAdvertise!, "1")),
                    },
                  _isPaginationLoading = false,
                }
            });
      });
    }
  }

  @override
  void initState() {
    int count = 0, n = 0, a = 0, per_page = 0;
    _getOnlineOffers(page).then((value) => {
          if (mounted)
            {
              setState(() {
                if (value.companylist != null &&
                    value.companylist!.isNotEmpty) {
                  offerads_model.add(OnlineOfferAdsModel(
                      value.companylist!, value.dashAdvertise!, "1"));
                }
                if (page == 1) {
                  company_image_base_url = value.imageBaseUrl!;
                  ads_image_base_url = value.addImageBaseUrl!;
                  _pageSize = int.parse(value.totalRecord!);
                  per_page = value.perpageRecord!;
                  maxPage = (_pageSize / per_page).round();
                }
                _isLoading = false;
              }),
            }
          else
            {
              if (value.companylist != null && value.companylist!.isNotEmpty)
                {
                  offerads_model.add(OnlineOfferAdsModel(
                      value.companylist!, value.dashAdvertise!, "1")),
                },
              if (page == 1)
                {
                  company_image_base_url = value.imageBaseUrl!,
                  ads_image_base_url = value.addImageBaseUrl!,
                  _pageSize = int.parse(value.totalRecord!),
                  per_page = value.perpageRecord!,
                  maxPage = (_pageSize / per_page).round(),
                },
              _isLoading = false,
            }
        });
    scrollcontroller.addListener(pagination);

    // favourite_offers.then((value) => {
    //       if (value.favouratelist != null && value.favouratelist!.length > 0)
    //         {
    //           for (int i = 0; i < value.favouratelist!.length; i++)
    //             {favList!.add(value.favouratelist![i])}
    //         },
    //       _getPublicOffers().then((value) => {
    //             if (value.companylist != null && value.companylist!.length > 0)
    //               {
    //                 for (int i = 0; i < value.companylist!.length; i++)
    //                   {
    //                     offersList!.add(value.companylist![i]),
    //                     fav.add("0"),
    //                   },
    //                 count = offersList!.length,
    //                 for (int i = 0; i < count; i++)
    //                   {
    //                     for (int j = i + 1; j < count; j++)
    //                       {
    //                         if (offersList![i].id == offersList![j].id)
    //                           {
    //                             offersList!.removeAt(j),
    //                             fav.removeAt(j),
    //                             count--,
    //                           }
    //                       },
    //                     for (int i = 0; i < favList!.length; i++)
    //                       {
    //                         for (int j = 0; j < offersList!.length; j++)
    //                           {
    //                             if (favList![i].offerId == offersList![j].id)
    //                               {
    //                                 fav[j] = "1",
    //                               }
    //                           }
    //                       }
    //                   }
    //               },
    //             _getAds().then((value) => {
    //                   ads_image_base_url = value.imageBaseUrl!,
    //                   if (value.adsList != null && value.adsList!.length > 0)
    //                     {
    //                       for (int i = 0; i < value.adsList!.length; i++)
    //                         {
    //                           adsList.add(AdsListModel(
    //                               value.adsList![i].addId!,
    //                               value.adsList![i].addName!,
    //                               value.adsList![i].addImage!,
    //                               value.adsList![i].url!,
    //                               value.adsList![i].status!,
    //                               value.adsList![i].createdDate!,
    //                               value.adsList![i].updatedDate!)),
    //                         },
    //                       if (adsList != null && adsList.length > 0)
    //                         {
    //                           for (int i = 0; i < offersList!.length; i++)
    //                             {
    //                               n++,
    //                               if (n == 1)
    //                                 {
    //                                   offersList_ads = [],
    //                                 },
    //                               if (i == (offersList!.length - 1) && n < 18)
    //                                 {
    //                                   offersList_ads!.add(offersList![i]),
    //                                   if (a < adsList.length)
    //                                     {
    //                                       offerads_model.add(
    //                                           OnlineOfferAdsModel(
    //                                               offersList_ads!,
    //                                               adsList[a],
    //                                               "1")),
    //                                     }
    //                                   else
    //                                     {
    //                                       adsList.add(AdsListModel(
    //                                           "", "", "", "", "", "", "")),
    //                                       offerads_model.add(
    //                                           OnlineOfferAdsModel(
    //                                               offersList_ads!,
    //                                               adsList[a],
    //                                               "0")),
    //                                     },
    //                                   n = 0,
    //                                   a++,
    //                                 }
    //                               else if (n < 18)
    //                                 {
    //                                   offersList_ads!.add(offersList![i]),
    //                                 }
    //                               else if (n == 18)
    //                                 {
    //                                   offersList_ads!.add(offersList![i]),
    //                                   if (a < adsList.length)
    //                                     {
    //                                       offerads_model.add(
    //                                           OnlineOfferAdsModel(
    //                                               offersList_ads!,
    //                                               adsList[a],
    //                                               "1")),
    //                                     }
    //                                   else
    //                                     {
    //                                       adsList.add(AdsListModel(
    //                                           "", "", "", "", "", "", "")),
    //                                       offerads_model.add(
    //                                           OnlineOfferAdsModel(
    //                                               offersList_ads!,
    //                                               adsList[a],
    //                                               "0")),
    //                                     },
    //                                   n = 0,
    //                                   a++,
    //                                 }
    //                             },
    //                         },
    //                     }
    //                 }),
    //             company_image_base_url = value.imageBaseUrl!,
    //             _isLoading = false,
    //           }),
    //     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF2CC0F),
      body: SafeArea(
        child: Stack(
          children: [
            Visibility(
                visible: !_isLoading,
                child: ListView.builder(
                    itemCount: offerads_model.length,
                    itemBuilder: (context, parent_index) {
                      return Column(
                        children: [
                          GridView.builder(
                            itemCount:
                                offerads_model[parent_index].offersList!.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: width / 495,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  print("Company name::::::::::" +
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .companyName!);
                                  Route route = MaterialPageRoute(
                                      builder: (context) => OfferDetailsScreen(
                                          Constants.language == "en"
                                              ? offerads_model[parent_index]
                                                  .offersList![index]
                                                  .companyName!
                                              : offerads_model[parent_index]
                                                      .offersList![index]
                                                      .companyArbName!
                                                      .isNotEmpty
                                                  ? offerads_model[parent_index]
                                                      .offersList![index]
                                                      .companyArbName!
                                                  : offerads_model[parent_index]
                                                      .offersList![index]
                                                      .companyName!,
                                          offerads_model[parent_index]
                                              .offersList![index]
                                              .id!,
                                          "",
                                          offerads_model[parent_index]
                                              .offersList![index]
                                              .id!,
                                          "0",
                                          "online",
                                          "",
                                          "",
                                          "",
                                          ""));
                                  Navigator.push(context, route);
                                  print("Company name::::::::::" +
                                      offerads_model[parent_index]
                                          .offersList![index]
                                          .companyName!);
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  color: const Color(0xFFE6D997),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 79,
                                        child: CircleAvatar(
                                          radius: width * 0.10,
                                          backgroundImage: NetworkImage(
                                              company_image_base_url +
                                                  offerads_model[parent_index]
                                                      .offersList![index]
                                                      .picture!),
                                        ),
                                        margin: const EdgeInsets.only(
                                            left: 2.0, right: 2.0, top: 2.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          Constants.language == "en"
                                              ? offerads_model[parent_index]
                                                  .offersList![index]
                                                  .displayName!
                                              : offerads_model[parent_index]
                                                      .offersList![index]
                                                      .displayArbName!
                                                      .isNotEmpty
                                                  ? offerads_model[parent_index]
                                                      .offersList![index]
                                                      .displayArbName!
                                                  : offerads_model[parent_index]
                                                      .offersList![index]
                                                      .displayName!,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: Constants.language ==
                                                      "en"
                                                  ? "Roboto"
                                                  : offerads_model[parent_index]
                                                          .offersList![index]
                                                          .displayArbName!
                                                          .isNotEmpty
                                                      ? "GSSFont"
                                                      : "Roboto",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 1.0, left: 2.0, right: 2.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              width: width * 0.08,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              8.0))),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    Constants.language == "en"
                                                        ? "Days"
                                                        : "يوم",
                                                    style: TextStyle(
                                                        fontFamily: Constants
                                                                    .language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 8.0),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    offerads_model[parent_index]
                                                        .offersList![index]
                                                        .remainingday!,
                                                    style: const TextStyle(
                                                      fontSize: 8.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              margin: const EdgeInsets.only(
                                                  left: 2.0, right: 2.0),
                                              width: width * 0.08,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              8.0))),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    Constants.language == "en"
                                                        ? "Hours"
                                                        : "ساعة",
                                                    style: TextStyle(
                                                        fontFamily: Constants
                                                                    .language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 8.0),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    offerads_model[parent_index]
                                                        .offersList![index]
                                                        .remaininghours!,
                                                    style: const TextStyle(
                                                      fontSize: 8.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              margin: const EdgeInsets.only(
                                                  left: 2.0),
                                              width: width * 0.10,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              8.0))),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    Constants.language == "en"
                                                        ? "Views"
                                                        : "مشاهدة",
                                                    style: TextStyle(
                                                        fontFamily: Constants
                                                                    .language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 8.0),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    offerads_model[parent_index]
                                                        .offersList![index]
                                                        .viewCount!,
                                                    style: const TextStyle(
                                                      fontSize: 8.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 1.0, bottom: 10.0),
                                        child: Text(
                                          Constants.language == "en"
                                              ? "Remaining Time"
                                              : "الوقت المتبقي",
                                          style: TextStyle(
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont",
                                              fontSize: 8.0),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          Visibility(
                            visible: offerads_model[parent_index].isAd == "1"
                                ? true
                                : false,
                            child: InkWell(
                              onTap: () async {
                                if (offerads_model[parent_index]
                                    .adsList
                                    .url!
                                    .isNotEmpty) {
                                  if (offerads_model[parent_index]
                                      .adsList
                                      .url!
                                      .contains("https://instagram.com/")) {
                                    String trimmed_url =
                                        offerads_model[parent_index]
                                            .adsList
                                            .url!
                                            .replaceAll(
                                                "https://instagram.com/", "");
                                    var split_url = trimmed_url.split("?");
                                    String native_url =
                                        "instagram://user?username=${split_url[0]}";
                                    if (await canLaunch(native_url)) {
                                      launch(native_url);
                                    } else {
                                      launch(
                                        offerads_model[parent_index]
                                            .adsList
                                            .url!,
                                        universalLinksOnly: true,
                                      );
                                    }
                                  } else {
                                    Route route = MaterialPageRoute(
                                        builder: (context) => WebViewScreen(
                                            "",
                                            offerads_model[parent_index]
                                                .adsList
                                                .url!));
                                    Navigator.push(context, route);
                                  }
                                }
                              },
                              child: Container(
                                width: width,
                                height: 70.0,
                                margin: const EdgeInsets.all(5.0),
                                child: Image(
                                  width: width,
                                  height: 70.0,
                                  image: NetworkImage(
                                    ads_image_base_url +
                                        offerads_model[parent_index]
                                            .adsList
                                            .addImage!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _isPaginationLoading,
                            child: const Center(
                              child: SizedBox(
                                width: 40.0,
                                height: 40.0,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    })),
            Visibility(
              visible: _isLoading,
              child: const Center(
                child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
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

class VipCodeScreen extends StatefulWidget {
  const VipCodeScreen({Key? key}) : super(key: key);

  @override
  _VipCodeScreenState createState() => _VipCodeScreenState();
}

class _VipCodeScreenState extends State<VipCodeScreen> {
  TextInputType inputType = TextInputType.text;
  TextEditingController vip_code_controller = TextEditingController();
  FocusNode vipFocusNode = FocusNode();

  bool _isLoading = false;
  List<Userdetail>? userdetail = [];
  List<VipOffers>? vipOffers = [];
  late Future<Favourite_model> favourite_offers = _getFavouriteOffers();
  List<String> fav = [];
  String vipCode = "", customerName = "", company_image_base_url = "";

  Future<Favourite_model> _getFavouriteOffers() async {
    final response = await http.get(Uri.parse(
        'http://185.188.127.11/public/index.php/ApiFavorate?customer_id=' +
            Constants.user_id));
    if (response.statusCode == 201) {
      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }
      if (response_server["status"] == 201) {
        return Favourite_model.fromJson(jsonDecode(response.body));
      } else {
        getVipList().then((value) => {
              if (value.userdetail != null && value.userdetail!.isNotEmpty)
                {
                  if (value.vipOffers != null && value.vipOffers!.isNotEmpty)
                    {
                      for (int i = 0; i < value.vipOffers!.length; i++)
                        {
                          vipOffers!.add(value.vipOffers![i]),
                          fav.add("0"),
                        },
                    }
                },
              setState(() {
                company_image_base_url = value.companyBaseUrl!;
                vipCode = value.userdetail![0].vipCode!;
                customerName = Constants.language == "en"
                    ? value.userdetail![0].name!
                    : value.userdetail![0].arbName!.isNotEmpty
                        ? value.userdetail![0].arbName!
                        : value.userdetail![0].name!;
                _isLoading = false;
              }),
            });
        throw Exception('Failed to load album');
      }
    } else {
      getVipList().then((value) => {
            if (value.userdetail != null && value.userdetail!.isNotEmpty)
              {
                if (value.vipOffers != null && value.vipOffers!.isNotEmpty)
                  {
                    for (int i = 0; i < value.vipOffers!.length; i++)
                      {
                        vipOffers!.add(value.vipOffers![i]),
                        fav.add("0"),
                      },
                  }
              },
            setState(() {
              company_image_base_url = value.companyBaseUrl!;
              vipCode = value.userdetail![0].vipCode!;
              customerName = Constants.language == "en"
                  ? value.userdetail![0].name!
                  : value.userdetail![0].arbName!.isNotEmpty
                      ? value.userdetail![0].arbName!
                      : value.userdetail![0].name!;
              _isLoading = false;
            }),
          });
      throw Exception('Failed to load album');
    }
  }

  Future<VipListModel> getVipList() async {
    final response = await http.get(
      Uri.parse('http://185.188.127.11/public/index.php/showvip?vip_code=' +
          vip_code_controller.text),
    );

    var response_server = jsonDecode(response.body);

    if (kDebugMode) {
      print(response_server);
    }

    if (response.statusCode == 200) {
      if (response_server["status"] == 201) {
        return VipListModel.fromJson(json.decode(response.body));
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

  @override
  void dispose() {
    vipFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Directionality(
        textDirection:
            Constants.language == "en" ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xFFF2CC0F),
          body: Container(
            height: height,
            margin: const EdgeInsets.all(10.0),
            color: const Color(0xFFFCF4C6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Container(
                          height: 50.0,
                          padding: const EdgeInsets.only(right: 6.0),
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 10.0,
                                ),
                                width: 175.0,
                                child: TextField(
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  focusNode: vipFocusNode,
                                  controller: vip_code_controller,
                                  keyboardType: inputType,
                                  maxLines: 1,
                                  cursorColor: Colors.white,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'VIP Code',
                                    hintStyle: TextStyle(color: Colors.black45),
                                  ),
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      vipFocusNode.unfocus();
                                      setState(() {
                                        inputType = TextInputType.text;
                                        Future.delayed(
                                            const Duration(milliseconds: 75),
                                            () {
                                          vipFocusNode.requestFocus();
                                        });
                                      });
                                    } else if (value.length == 1) {
                                      vipFocusNode.unfocus();
                                      setState(() {
                                        inputType = TextInputType.number;
                                        Future.delayed(
                                            const Duration(milliseconds: 75),
                                            () {
                                          vipFocusNode.requestFocus();
                                        });
                                      });
                                    } else if (value.length == 5) {
                                      vipFocusNode.unfocus();
                                    }
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (vip_code_controller.text.isNotEmpty) {
                                    if (vip_code_controller.text.length == 5) {
                                      RegExp exp =
                                          RegExp(r"(([a-zA-Z]{1}\d{4}))");
                                      bool matches = exp
                                          .hasMatch(vip_code_controller.text);
                                      if (matches) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        _getFavouriteOffers().then((favvalue) =>
                                            {
                                              getVipList().then((value) => {
                                                    if (value.userdetail !=
                                                            null &&
                                                        value.userdetail!
                                                            .isNotEmpty)
                                                      {
                                                        if (value.vipOffers !=
                                                                null &&
                                                            value.vipOffers!
                                                                .isNotEmpty)
                                                          {
                                                            for (int i = 0;
                                                                i <
                                                                    value
                                                                        .vipOffers!
                                                                        .length;
                                                                i++)
                                                              {
                                                                vipOffers!.add(
                                                                    value.vipOffers![
                                                                        i]),
                                                                fav.add("0"),
                                                              },
                                                            if (favvalue.favouratelist !=
                                                                    null &&
                                                                favvalue
                                                                    .favouratelist!
                                                                    .isNotEmpty)
                                                              {
                                                                if (vipOffers !=
                                                                        null &&
                                                                    vipOffers!
                                                                        .isNotEmpty)
                                                                  {
                                                                    for (int i =
                                                                            0;
                                                                        i < favvalue.favouratelist!.length;
                                                                        i++)
                                                                      {
                                                                        for (int j =
                                                                                0;
                                                                            j < vipOffers!.length;
                                                                            j++)
                                                                          {
                                                                            if (favvalue.favouratelist![i].offerId ==
                                                                                vipOffers![j].id)
                                                                              {
                                                                                fav[j] = "1",
                                                                              }
                                                                          }
                                                                      }
                                                                  }
                                                              }
                                                          }
                                                      },
                                                    /* if(value.userdetail!.isEmpty){
                            setState(() {
                                _isLoading = false;
                            }),
                                  print("ghjghgsfgahsfs"),


                                  _alertDialog(Constants.language == "en"
                                      ? "Please enter valid vip code"
                                      : "الرجاء إدخال صالح Code vip"),
                                },*/

                                                    setState(() {
                                                      company_image_base_url =
                                                          value.companyBaseUrl!;

                                                      vipCode = value
                                                          .userdetail![0]
                                                          .vipCode!;

                                                      Route route = MaterialPageRoute(
                                                          builder: (context) =>
                                                              VipCodeScreen_2(
                                                                  true,
                                                                  vip_code_controller
                                                                      .text,
                                                                  "home"));
                                                      Navigator.push(
                                                          context, route);

                                                      print("vipro" + vipCode);
                                                      customerName = Constants
                                                                  .language ==
                                                              "en"
                                                          ? value.userdetail![0]
                                                              .name!
                                                          : value
                                                                  .userdetail![
                                                                      0]
                                                                  .arbName!
                                                                  .isNotEmpty
                                                              ? value
                                                                  .userdetail![
                                                                      0]
                                                                  .arbName!
                                                              : value
                                                                  .userdetail![
                                                                      0]
                                                                  .name!;
                                                      _isLoading = false;
                                                    }),
                                                  }),
                                            });
                                      } else {
                                        _alertDialog(Constants.language == "en"
                                            ? "Please enter valid vip code"
                                            : "الرجاء إدخال صالح Code vip");
                                      }
                                    } else {
                                      _alertDialog(Constants.language == "en"
                                          ? "Please enter valid vip code"
                                          : "الرجاء إدخال صالح Code vip");
                                    }
                                  } else {
                                    _alertDialog(Constants.language == "en"
                                        ? "Please enter vip code"
                                        : "الرجاء إدخال Code vip");
                                  }
                                },
                                child: const Icon(
                                  CupertinoIcons.search,
                                  color: Colors.black,
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
                            "VIP Code:",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont"),
                            textAlign: Constants.language == "en"
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                        ),
                        Container(
                          width: width,
                          margin: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: Text(
                            Constants.language == "en"
                                ? "A special and exclusive discount code only for employees of government and private agencies and students of all kinds of faculty."
                                : "كود خصم خاص وحصري فقط لموظفين الجهات الحكومية والخاصة وطلاب الهيئات التدريسية بكافة أنواعها.",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont"),
                            textAlign: Constants.language == "en"
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                        ),
                        Container(
                          width: width,
                          margin: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: Text(
                            Constants.language == "en"
                                ? "Where a special and exclusive discount code has been allocated to each entity that enables its employees or students to obtain a higher discount rate than public discounts and Friday discounts."
                                : "حيث تم تخصيص كود خصم خاص وحصري لكل جهة يُمكن موظفيها أو طلابها من الحصول على نسبة خصم اعلى من التخفيضات العامة وتخفيضات الجمعة.",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont"),
                            textAlign: Constants.language == "en"
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                        ),
                        Container(
                          width: width,
                          margin: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: Text(
                            Constants.language == "en"
                                ? "All you have to do is write the VIP Code obtained from your workplace in the search box and find out the companies covered by this code and take advantage of them."
                                : "كل ما عليك فعله هو كتابة كود الخصم الحاصل عليه من مقر عملك في خانة البحث ومعرفة الشركات التي يشملها هذا الكود والاستفادة منها .",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont"),
                            textAlign: Constants.language == "en"
                                ? TextAlign.left
                                : TextAlign.right,
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
                ////////////////here Search button error
                Container(
                  width: width,
                  margin: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      if (vip_code_controller.text.isNotEmpty) {
                        if (vip_code_controller.text.length == 5) {
                          RegExp exp = RegExp(r"(([a-zA-Z]{1}\d{4}))");
                          bool matches = exp.hasMatch(vip_code_controller.text);
                          if (matches) {
                            setState(() {
                              _isLoading = true;
                            });
                            _getFavouriteOffers().then((favvalue) => {
                                  getVipList().then((value) => {
                                        if (value.userdetail != null &&
                                            value.userdetail!.isNotEmpty)
                                          {
                                            if (value.vipOffers != null &&
                                                value.vipOffers!.isNotEmpty)
                                              {
                                                for (int i = 0;
                                                    i < value.vipOffers!.length;
                                                    i++)
                                                  {
                                                    vipOffers!.add(
                                                        value.vipOffers![i]),
                                                    fav.add("0"),
                                                  },
                                                if (favvalue.favouratelist !=
                                                        null &&
                                                    favvalue.favouratelist!
                                                        .isNotEmpty)
                                                  {
                                                    if (vipOffers != null &&
                                                        vipOffers!.isNotEmpty)
                                                      {
                                                        for (int i = 0;
                                                            i <
                                                                favvalue
                                                                    .favouratelist!
                                                                    .length;
                                                            i++)
                                                          {
                                                            for (int j = 0;
                                                                j <
                                                                    vipOffers!
                                                                        .length;
                                                                j++)
                                                              {
                                                                if (favvalue
                                                                        .favouratelist![
                                                                            i]
                                                                        .offerId ==
                                                                    vipOffers![
                                                                            j]
                                                                        .id)
                                                                  {
                                                                    fav[j] =
                                                                        "1",
                                                                  }
                                                              }
                                                          }
                                                      }
                                                  }
                                              }
                                          },
                                        /* if(value.userdetail!.isEmpty){
                            setState(() {
                                _isLoading = false;
                            }),
                                  print("ghjghgsfgahsfs"),


                                  _alertDialog(Constants.language == "en"
                                      ? "Please enter valid vip code"
                                      : "الرجاء إدخال صالح Code vip"),
                                },*/

                                        setState(() {
                                          company_image_base_url =
                                              value.companyBaseUrl!;

                                          vipCode =
                                              value.userdetail![0].vipCode!;

                                          Route route = MaterialPageRoute(
                                              builder: (context) =>
                                                  VipCodeScreen_2(
                                                      true,
                                                      vip_code_controller.text,
                                                      "home"));
                                          Navigator.push(context, route);

                                          print("vipro" + vipCode);
                                          customerName = Constants.language ==
                                                  "en"
                                              ? value.userdetail![0].name!
                                              : value.userdetail![0].arbName!
                                                      .isNotEmpty
                                                  ? value
                                                      .userdetail![0].arbName!
                                                  : value.userdetail![0].name!;
                                          _isLoading = false;
                                        }),
                                      }),
                                });
                          } else {
                            _alertDialog(Constants.language == "en"
                                ? "Please enter valid vip code"
                                : "الرجاء إدخال صالح Code vip");
                          }
                        } else {
                          _alertDialog(Constants.language == "en"
                              ? "Please enter valid vip code"
                              : "الرجاء إدخال صالح Code vip");
                        }
                      } else {
                        _alertDialog(Constants.language == "en"
                            ? "Please enter vip code"
                            : "الرجاء إدخال Code vip");
                      }
                    },
                    child: Text(
                      Constants.language == "en" ? "SEARCH" : "بحث",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontSize: 18.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFF2CC0F),
                      fixedSize: Size(width, 40),
                      elevation: 0.0,
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

class NotificationListScreen extends StatefulWidget {
  String which_page;

  NotificationListScreen(this.which_page, {Key? key}) : super(key: key);

  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  bool _isLoading = true;
  late Future<Notification_list_model> notification;
  List<Notification_list>? notificationList = [];
  List<Userlist>? userlist = [];
  List<String> status = [];
  String company_base_url = "";
  String url = "";
  //String image_url="";
  String companyname = "";
  String text = "It is possible to set up You can set ,";

  NetworkCheck networkCheck = NetworkCheck();
  late Future<Home_banner_model> home_banner;

  List<Banner_list>? bannerList = [];

  Future<Notification_list_model> _getNotificationList() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/NotificationList?userid=' +
              Constants.user_id));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }

        if (response_server["status"] == 201) {
          return Notification_list_model.fromJson(jsonDecode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });
          _alertDialog(
              Constants.language == "en" ? "no data found" : "لاتوجد بيانات");
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          _alertDialog(
              Constants.language == "en" ? "no data found" : "لاتوجد بيانات");
        } else {
          _alertDialog(Constants.language == "en"
              ? "Something went wrong"
              : "هناك خطأ ما");
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

  Future<bool> _postDeleteNotification(
      String companyId, String notificationId) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "userid": Constants.user_id,
        "companyid": companyId,
        "notificationid": notificationId
      };

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/notificationdelete'),
        body: body,
      );

      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
          return true;
        } else {
          setState(() {
            _isLoading = false;
          });
          _alertDialog(Constants.language == "en"
              ? "Notification not deleted"
              : "لم يتم حذف الإخطار");
          return false;
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          _alertDialog(Constants.language == "en"
              ? "Notification not deleted"
              : "لم يتم حذف الإخطار");
        } else {
          _alertDialog(Constants.language == "en"
              ? "Something went wrong"
              : "هناك خطأ ما");
        }
        return false;
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      return false;
    }
  }

  Future<CompanyListModel> _postCompanyList() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "userid": Constants.user_id,
      };

      final response = await http.post(
        Uri.parse(
            'http://185.188.127.11/public/index.php/ApiChatUserCompanyList'),
        body: body,
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 201) {
        if (response_server["status"] == 201) {
          return CompanyListModel.fromJson(jsonDecode(response.body));
        } else {
          if (response_server["status"] == 404) {
            _alertDialog(
                Constants.language == "en" ? "No data found" : "لاتوجد بيانات");
          } else {
            _alertDialog(Constants.language == "en"
                ? "Something went wrong"
                : "هناك خطأ ما");
          }
          setState(() {
            _isLoading = false;
          });
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          _alertDialog(
              Constants.language == "en" ? "No data found" : "لاتوجد بيانات");
        } else {
          _alertDialog(Constants.language == "en"
              ? "Something went wrong"
              : "هناك خطأ ما");
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

  @override
  void initState() {
    if (widget.which_page == "chats") {
      _postCompanyList().then((value) => {
            if (value.userlist != null && value.userlist!.isNotEmpty)
              {
                for (int i = 0; i < value.userlist!.length; i++)
                  {
                    userlist!.add(value.userlist![i]),
                  },
                if (userlist != null && userlist!.isNotEmpty)
                  {
                    for (int i = 0; i < userlist!.length; i++)
                      {
                        if (userlist![i].branchId!.isEmpty)
                          {
                            userlist!.removeAt(i),
                            i--,
                          }
                      }
                  },
                if (userlist != null && userlist!.isNotEmpty)
                  {
                    for (int i = 0; i < userlist!.length; i++)
                      {
                        for (int j = i + 1; j < userlist!.length; j++)
                          {
                            if (userlist![i].branchId! ==
                                userlist![j].branchId!)
                              {
                                userlist!.removeAt(j),
                                j--,
                              }
                          }
                      }
                  },
              },
            company_base_url = value.imageUrl!,
            _isLoading = false,
          });
    } else {
      notification = _getNotificationList();
      List<String> date;
      Date now = Date();
      String today = now.getDate();
      notification.then((value) => {
            company_base_url = value.imageBaseUrl!,
            if (value.notificationlist != null &&
                value.notificationlist!.isNotEmpty)
              {
                for (int i = 0; i < value.notificationlist!.length; i++)
                  {
                    if (widget.which_page == value.notificationlist![i].type!)
                      {
                        notificationList!.add(value.notificationlist![i]),
                        date = value.notificationlist![i].time!.split(" "),
                        if (value.notificationlist![i].acceptStatus! == "1")
                          {
                            status.add("1"),
                          }
                        else if (today == date[0])
                          {
                            status.add("2"),
                          }
                        else
                          {
                            status.add("3"),
                          }
                      }
                  }
              },
            if (notificationList != null && notificationList!.isNotEmpty)
              {
                for (int i = 0; i < notificationList!.length; i++)
                  {
                    for (int j = i + 1; j < notificationList!.length; j++)
                      {
                        if (notificationList![i].notificationId ==
                            notificationList![j].notificationId)
                          {
                            notificationList!.removeAt(j),
                            j--,
                          }
                      }
                  }
              },
            _isLoading = false,
          });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2CC0F),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              widget.which_page == "chats"
                  ? ListView.builder(
                      itemCount: userlist!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    Constants.language == "en"
                                        ? userlist![index].companyName!
                                        : userlist![index]
                                                .companyArbName!
                                                .isNotEmpty
                                            ? userlist![index].companyArbName!
                                            : userlist![index].companyName!,
                                    company_base_url +
                                        userlist![index].picture!,
                                    Constants.user_id,
                                    userlist![index].branchId!,
                                    "",
                                    "",
                                    "user",
                                    "",
                                    "0",
                                    "0"));
                            Navigator.push(context, route);
                          },
                          child: Container(
                            width: width,
                            padding: const EdgeInsets.all(6.0),
                            margin: const EdgeInsets.only(top: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Row(
                              children: [
                                userlist![index].picture!.isNotEmpty
                                    ? CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            company_base_url +
                                                userlist![index].picture!),
                                      )
                                    : const Image(
                                        image: AssetImage(
                                            "images/circle_app_icon.png"),
                                        width: 60.0,
                                        height: 60.0,
                                      ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Constants.language == "en"
                                              ? userlist![index].companyName!
                                              : userlist![index]
                                                      .companyArbName!
                                                      .isNotEmpty
                                                  ? userlist![index]
                                                      .companyArbName!
                                                  : userlist![index]
                                                      .companyName!,
                                          style: TextStyle(
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(
                                            Constants.language == "en"
                                                ? userlist![index].branchName!
                                                : userlist![index]
                                                        .arbBranchName!
                                                        .isNotEmpty
                                                    ? userlist![index]
                                                        .arbBranchName!
                                                    : userlist![index]
                                                        .branchName!,
                                            style: TextStyle(
                                                fontFamily:
                                                    Constants.language == "en"
                                                        ? "Roboto"
                                                        : "GSSFont",
                                                fontSize: 14.0),
                                          ),
                                        ),
                                        Align(
                                          child: Text(
                                            userlist![index].lastupdatetime!,
                                            textAlign: TextAlign.right,
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                  : ListView.builder(
                      itemCount: notificationList!.length,
                      itemBuilder: (context, index) {
                        String textt = widget.which_page == "city"
                            ? notificationList![index].title!
                            : Constants.language == "en"
                                ? notificationList![index].companyName!
                                : notificationList![index]
                                    .companyArbName!
                                    .toString();
                        if (widget.which_page == "purchase") {
                          return InkWell(
                            onTap: () {
                              if (status[index] != "1") {
                                _showDialog(context, index, "1", width);
                              } else {
                                _showDialog(context, index, "1", width);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              margin: const EdgeInsets.only(top: 10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      notificationList![index]
                                              .companyLogo!
                                              .isNotEmpty
                                          ? CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  company_base_url +
                                                      notificationList![index]
                                                          .companyLogo!),
                                            )
                                          : const Image(
                                              image: AssetImage(
                                                  "images/circle_app_icon.png"),
                                              width: 60.0,
                                              height: 60.0,
                                            ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Text(
                                          Constants.language == "en"
                                              ? notificationList![index]
                                                  .companyName!
                                              : notificationList![index]
                                                  .companyArbName!,
                                          style: TextStyle(
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            status[index] == "1"
                                                ? Constants.language == "en"
                                                    ? " Approved"
                                                    : "تمت الموافقه"

                                                /// commenting status==2
                                                : status[index] == "2"

                                                    // : status[index] == "1"

                                                    ? Constants.language == "en"

                                                        ///comenting below code

                                                        /*  ? "Pendings"
                                             : " في الانتظار"*/

                                                        ? " Approved"
                                                        : "تمت الموافقه"
                                                    : Constants.language == "en"
                                                        ? "Expired"
                                                        : "منتهية الصلاحية",
                                            style: TextStyle(
                                                fontFamily:
                                                    Constants.language == "en"
                                                        ? "Roboto"
                                                        : "GSSFont",
                                                color: status[index] == "1"
                                                    ? Colors.green
                                                    : status[index] == "2"

                                                        ///changing blue to green
                                                        ? Colors.green
                                                        : Colors.red),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 1.0),
                                            child: IconButton(
                                              icon: const Icon(
                                                  CupertinoIcons.delete_solid),
                                              iconSize: 18.0,
                                              color: Colors.red,
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  // user must tap button!
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content:
                                                          SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            Text(
                                                              Constants.language ==
                                                                      "en"
                                                                  ? 'Are you sure you want to delete this message ?'
                                                                  : "هل أنت متأكد أنك تريد حذف هذه الرسالة ؟",
                                                              style: TextStyle(
                                                                fontFamily: Constants
                                                                            .language ==
                                                                        "en"
                                                                    ? "Roboto"
                                                                    : "GSSFont",
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child:
                                                              const Text('NO'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child:
                                                              const Text('YES'),
                                                          onPressed: () async {
                                                            setState(() {
                                                              _isLoading = true;
                                                            });
                                                            bool isDeleted = await _postDeleteNotification(
                                                                notificationList![
                                                                        index]
                                                                    .companyId!,
                                                                notificationList![
                                                                        index]
                                                                    .notificationId!);
                                                            if (isDeleted) {
                                                              setState(() {
                                                                notificationList!
                                                                    .removeAt(
                                                                        index);
                                                              });
                                                            }
                                                            setState(() {
                                                              _isLoading =
                                                                  false;
                                                            });
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(notificationList![index].time!),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              _showDialog(context, index, "0", width);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              margin: const EdgeInsets.only(
                                  top: 10.0, right: 0.5, left: 0.5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      notificationList![index]
                                              .companyLogo!
                                              .isNotEmpty
                                          ? CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  company_base_url +
                                                      notificationList![index]
                                                          .companyLogo!),
                                            )
                                          : const Image(
                                              image: AssetImage(
                                                  "images/circle_app_icon.png"),
                                              width: 45.0,
                                              height: 45.0,
                                            ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0, right: 5.0),
                                        child: Text(
                                          /*      widget.which_page == "city"
                                              ? notificationList![index].title!
                                              : Constants.language == "en"
                                              ? notificationList![index]
                                              .companyName!
                                              : notificationList![index]
                                              .companyArbName!.length > 30 ? '${widget.which_page == "city"
                                              ? notificationList![index].title!
                                              : Constants.language == "en"
                                              ? notificationList![index]
                                              .companyName!
                                              : notificationList![index]
                                              .companyArbName!.substring(0, 30)}......' : widget.which_page == "city"
                                              ? notificationList![index].title!
                                              : Constants.language == "en"
                                              ? notificationList![index]
                                              .companyName!
                                              : notificationList![index]
                                              .companyArbName!,*/
                                          textt.length > 30
                                              ? '${textt.substring(0, 30)}......'
                                              : textt,

                                          /*      widget.which_page == "city"
                                              ? notificationList![index].title!
                                              : Constants.language == "en"
                                                  ? notificationList![index]
                                                      .companyName!
                                                  : notificationList![index]
                                                      .companyArbName!,*/
                                          style: TextStyle(
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),

                                          overflow: TextOverflow.fade,
                                          maxLines: 1, //edited by rohan
                                          softWrap: true, //
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(left: 1.0),
                                        child: IconButton(
                                          icon: const Icon(
                                              CupertinoIcons.delete_solid),
                                          iconSize: 16.0,
                                          color: Colors.red,
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(
                                                          Constants.language ==
                                                                  "en"
                                                              ? 'Are you sure you want to delete this message ?'
                                                              : "هل أنت متأكد أنك تريد حذف هذه الرسالة ؟",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                Constants.language ==
                                                                        "en"
                                                                    ? "Roboto"
                                                                    : "GSSFont",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('NO'),
                                                      onPressed: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text('YES'),
                                                      onPressed: () async {
                                                        setState(() {
                                                          _isLoading = true;
                                                        });
                                                        bool isDeleted =
                                                            await _postDeleteNotification(
                                                                notificationList![
                                                                        index]
                                                                    .companyId!,
                                                                notificationList![
                                                                        index]
                                                                    .notificationId!);
                                                        if (isDeleted) {
                                                          setState(() {
                                                            notificationList!
                                                                .removeAt(
                                                                    index);
                                                          });
                                                        }
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Text(notificationList![index].time!),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),
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

  //here is implatmention of city code dialoge popup code
  _showDialog(
      BuildContext context, int index, String isPurchase, double width) {
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      //this right here
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.90,
        width: MediaQuery.of(context).size.width * 0.90,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        notificationList![index].companyLogo!.isNotEmpty
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(company_base_url +
                                    notificationList![index].companyLogo!),
                              )
                            : const Image(
                                image: AssetImage("images/circle_app_icon.png"),
                                width: 70.0,
                                height: 55.0,
                              ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            widget.which_page == "city"
                                ? notificationList![index].title!
                                : Constants.language == "en"
                                    ? notificationList![index].companyName!
                                    : notificationList![index].companyArbName!,
                            style: TextStyle(
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () async {
                            print("company url:" + company_base_url);
                            print("image :" + Constants.user_id);
                            print("Description::::::" +
                                notificationList![index].text!);
                            //print("imageurl"+image_url);
                            //  print(notification_id);
                            /* if (e.inApp == "true") {
                            Route route = MaterialPageRoute(
                                builder: (context) =>
                                    OfferDetailsScreen(
                                        "",
                                        e.companyId!,
                                        "",
                                        "",
                                        "",
                                        "city"));
                            Navigator.push(context, route);
                          } else {
                            if (e.url!.isNotEmpty) {
                              if (e.url!.contains(
                                  "https://instagram.com/")) {
                                String trimmed_url = e.url!
                                    .replaceAll(
                                    "https://instagram.com/",
                                    "");
                                var split_url =
                                trimmed_url.split("?");
                                String native_url =
                                    "instagram://user?username=${split_url[0]}";
                                if (await canLaunch(
                                    native_url)) {
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
                                        WebViewScreen(
                                            "", e.url!));
                                Navigator.push(context, route);
                              }
                            }
                          }*/

                            /* String trimmed_url = company_base_url!
                              .replaceAll(
                              "https://instagram.com/",
                              "");
                          var split_url =
                          trimmed_url.split("?");
                          String native_url =
                              "instagram://user?username=${split_url[0]}";
                          print("native url:"+native_url);

                          if (await canLaunch(
                              native_url)) {
                            launch(native_url);
                          } else {
                            // Route route = MaterialPageRoute(
                            //     builder: (context) =>
                            //         WebViewScreen(
                            //             "", company_base_url!));
                            // Navigator.push(context, route);
                            // launch(
                            //   company_base_url,
                            //   universalLinksOnly: true,
                            // );
                          }*/

                            /*if (e.url!.isNotEmpty) {
                            if (company_base_url.contains(
                                "https://instagram.com/")) {
                              String trimmed_url = company_base_url!
                                  .replaceAll(
                                  "https://instagram.com/",
                                  "");
                              var split_url =
                              trimmed_url.split("?");
                              String native_url =
                                  "instagram://user?username=${split_url[0]}";
                              if (await canLaunch(
                                  native_url)) {
                                launch(native_url);
                              } else {
                                launch(
                                  company_base_url,
                                  universalLinksOnly: true,
                                );
                              }
                            } else {
                              Route route = MaterialPageRoute(
                                  builder: (context) =>
                                      WebViewScreen(
                                          "", company_base_url!));
                              Navigator.push(context, route);
                            }
                          }*/

                            /* if (await canLaunch(url))
                          await launch(url);
                          else
                          // can't launch url, there is some error
                          throw "Could not launch $url";*/
                            /* Route route = MaterialPageRoute(
                                  builder: (context) => OfferDetailsScreen());
                          Navigator.push(context, route);*/
                            // Navigator.push(context,MaterialPageRoute(builder: (context) async =>OfferDetailsScreen));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            child: Text(
                              notificationList![index].text!,
                              style: TextStyle(
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                              ),
                              textAlign: TextAlign.left,
                              //   overflow: TextOverflow.ellipsis,
                              // maxLines:1,
                              //  softWrap: false,
                            ),
                          ),
                        ),

                        //items:bannerList!
                        //  .map((e)
                        GestureDetector(
                          onTap: () async {
                            // String StateUrl = 'View App' ;
                            String image = notificationList![index].image_url!;
                            String inapp = notificationList![index].companyId!;
                            String type = notificationList![index].type!;
                            String name = notificationList![index].companyName!;

                            //   const image = "https://www.flutter.io";
                            print("hello");
                            // print(image_url);
                            print("imageurl:" +
                                notificationList![index].image_url!);

                            Uri _url = Uri.parse(image);
                            if (inapp == Constants.company_id ||
                                type == "city") {
                              Route route = MaterialPageRoute(
                                  builder: (context) => OfferDetailsScreen(
                                      name,
                                      inapp,
                                      "",
                                      "",
                                      "",
                                      "city",
                                      "",
                                      "",
                                      "",
                                      ""));
                              Navigator.push(context, route);
                            } else if (await canLaunch(_url.toString())) {
                              launch(_url.toString());
                            }

                            /* if (image.isNotEmpty||image!= null){
                           if (Platform.isAndroid){
                            if(await canLaunch(image)){
                              launch(image);
                            }
                                 }

                         }
                         else{
                           print("error");

                         }*/

                            /* if (image!.isNotEmpty) {
      if (image!.contains(
          "https://")) {
        String trimmed_url = image!
            .replaceAll(
            "https://",
            "");
        var split_url =
        trimmed_url.split("?");
        String native_url =
            "http://${split_url[0]}";
        print("native url"+native_url);
        if (await canLaunch(
            native_url)) {
          launch(native_url);
        } else {
          launch(
            image!,
            universalLinksOnly: true,
          );
        }
      }
    }*/

                            /*    final url = notificationList![index].image_url!;
                         if()
                         if (await canLaunch(url))
                           await launch(url);
                         else
                           // can't launch url, there is some error
                           throw "Could not launch $url";*/
                            /*if (image.isNotEmpty||image!= null){
                           if (Platform.isAndroid){
                             if(await canLaunch(image)){
                               launch(image);
                             }
                           }

                         }
                         else{
                           print("error");

                         }*/
                            /*String StateUrl = 'View App' ;
                          var image=notificationList![index].image_url!;
                              try {
                              if(await canLaunch(image)) await launch(image);
                              } catch(e){
                              setState(() {
                              StateUrl = e.toString() ;
                              });
                              throw e;}*/

                            /*if (await canLaunch(image))
                          await launch(image);
                          else
                          // can't launch url, there is some error
                          throw "Could not launch $image";*/

                            //    print(image_url);
                            //  print(userid);
                            /* if (e.inApp == "true") {
                            Route route = MaterialPageRoute(
                                builder: (context) =>
                                    OfferDetailsScreen(
                                        "",
                                        e.companyId!,
                                        "",
                                        "",
                                        "",
                                        "city"));
                            Navigator.push(context, route);
                          } else {
                            if (e.url!.isNotEmpty) {
                              if (e.url!.contains(
                                  "https://instagram.com/")) {
                                String trimmed_url = e.url!
                                    .replaceAll(
                                    "https://instagram.com/",
                                    "");
                                var split_url =
                                trimmed_url.split("?");
                                String native_url =
                                    "instagram://user?username=${split_url[0]}";
                                if (await canLaunch(
                                native_url)) {
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
                          WebViewScreen(
                          "", e.url!));
                          Navigator.push(context, route);
                          }
                        }
                        }*/
                          },
                          child: Visibility(
                            visible:
                                notificationList![index].notifyimage!.isNotEmpty
                                    ? true
                                    : false,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10.0),
                              child: Image(
                                image: NetworkImage(company_base_url +
                                    notificationList![index].notifyimage!),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 10.0, right: 10.0, bottom: 10.0, top: 30),
                    height: 35.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        Constants.language == "en" ? "CLOSE" : "أستمرار",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                          fontSize: 18.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFF2CC0F),
                        textStyle: const TextStyle(color: Color(0xFFF2CC0F)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          // side: const BorderSide(
                          //   color: Colors.black,
                          //   width: 1.0,
                          // ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /*    Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:<Widget>[
            Container(
            margin:
            const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        height: 35.0,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            Constants.language == "en" ? "CLOSE" : "أستمرار",
            style: TextStyle(
              color: Colors.black,
              fontFamily:
              Constants.language == "en" ? "Roboto" : "GSSFont",
              fontSize: 18.0,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFFF2CC0F),
            textStyle: const TextStyle(color: Color(0xFFF2CC0F)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              // side: const BorderSide(
              //   color: Colors.black,
              //   width: 1.0,
              // ),
            ),
          ),
        ),
      ),
                ]
            ),*/
            ],
          ),
        ),
      ),
    );

    String discountPrice = "0.000";
    String payPrice = "0.000";

    if (widget.which_page == "purchase") {
      double discount_price = double.parse(notificationList![index].amount!);
      discountPrice = discount_price.toStringAsFixed(3);
      double pay_price = double.parse(notificationList![index].discountAmout!);
      payPrice = pay_price.toStringAsFixed(3);
    }
    Dialog purchaseDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: SizedBox(
        height: 550,
        width: width,
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                SizedBox(
                  height: 90,
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
                Positioned(
                  left: 96,
                  top: 10.0,
                  right: 96,
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.only(top: 20.0, right: 12.0),
                          child: Container(
                            width: width * 0.25,
                            height: 45,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2CC0F),
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
                            width: 30,
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
                                size: 24.0,
                              ),
                            ),
                          ),
                          bottom: 24.0,
                          left: 77.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                Constants.language == "en"
                    ? "About to take advantage of discounts"
                    : "على وشك الاستفاده من خصومات",
                style: TextStyle(
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                Constants.language == "en"
                    ? notificationList![index].companyName!
                    : notificationList![index].companyArbName!,
                style: TextStyle(
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                Constants.language == "en"
                    ? notificationList![index].branchName!
                    : notificationList![index].branchArbName!,
                style: TextStyle(
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 220.0,
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF2CC0F),
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Text(
                          notificationList![index].coupontype == "coupon"
                              ? Constants.language == "en"
                                  ? "Coupon Amount"
                                  : "خصومات القسيمة"
                              : Constants.language == "en"
                                  ? "Discounts"
                                  : "الخصم",
                          style: TextStyle(
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            notificationList![index].coupontype == "coupon"
                                ? notificationList![index].discount!
                                : notificationList![index].discount! + "%",
                            style: const TextStyle(fontFamily: "Roboto"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    height: 1.0,
                    color: Colors.black,
                  ),
                  Visibility(
                    visible:
                        int.parse(notificationList![index].reddemPoint!) > 0
                            ? false
                            : true,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                notificationList![index].coupontype == "coupon"
                                    ? Constants.language == "en"
                                        ? "Purchasing Amount"
                                        : "مبلغ الشراء"
                                    : Constants.language == "en"
                                        ? "Amount Before Discount"
                                        : "المبلغ قبل الخصم",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  discountPrice,
                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          height: 1.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Text(
                          Constants.language == "en"
                              ? "Amount To Pay"
                              // : "المبلغ للدفع",
                              : " المبلغ الواجب دفعه ",
                          style: TextStyle(
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            payPrice,
                            style: const TextStyle(fontFamily: "Roboto"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    height: 1.0,
                    color: Colors.black,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Column(
                      children: [
                        Text(
                          Constants.language == "en"
                              ? "Use Points"
                              : "استخدم النقاط",
                          //:"النقاط القابلة للخصم",
                          style: TextStyle(
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            notificationList![index].reddemPoint!,
                            style: const TextStyle(fontFamily: "Roboto"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// adding && status=="1" below code
            Visibility(
              visible: status[index] == "2" && status == "1" ? true : false,
              child: Container(
                margin:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                height: 40.0,
                child: ElevatedButton(
                  onPressed: () async {
                    bool isSuccess = await acceptOffer(
                        notificationList![index].orderId!, index);
                    if (isSuccess) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                  child: Text(
                    Constants.language == "en" ? "Accept" : "قبول",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                      fontSize: 18.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFF2CC0F),
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
            ),
            Visibility(
              visible: status[index] == "3" ? true : false,
              child: Container(
                margin:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                child: Text(
                  Constants.language == "en"
                      ? "The offer is Expired"
                      : "العرض منتهي الصلاحية",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
              ),
            ),
            Visibility(
              visible: status[index] == "1" ? true : false,
              child: Container(
                margin:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                child: Text(
                  Constants.language == "en"
                      ? "Payment Succesfully."
                      : "نجاح الدفع.",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
              height: 40.0,
              child: ElevatedButton(
                onPressed: () async {
                  /*bool isSuccess = await acceptOffer(
                      notificationList![index].orderId!, index);
                  if (isSuccess) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }*/

                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text(
                  Constants.language == "en" ? "Done" : "قبول",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                    fontSize: 18.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFF2CC0F),
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
            /* Visibility(
              visible:status[index] == "1" ? true : false,
              child: Container(
                margin:
                const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                height: 40.0,
                child: ElevatedButton(
                  onPressed: () async {


                      Navigator.of(context, rootNavigator: true).pop();

                  },
                  child: Text(
                    Constants.language == "en" ? "Done" : "قبول",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                      Constants.language == "en" ? "Roboto" : "GSSFont",
                      fontSize: 18.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFF2CC0F),
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
            ),*/
          ],
        ),
      ),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            isPurchase == "1" ? purchaseDialog : dialog);
  }

  Future<bool> acceptOffer(String order_id, int index) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "od_id": order_id,
        "status": "true",
        "notificationtype": "company"
      };

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/accept'),
        body: body,
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 201) {
        setState(() {
          status[index] = "1";
        });
        if (response_server["status"] == 201) {
          if (Constants.language == "en") {
            _alertDialog("Offer Accepted");
          } else {
            _alertDialog("تم القبول");
          }
          return true;
        } else {
          if (Constants.language == "en") {
            _alertDialog("Failed to accept offer");
          } else {
            _alertDialog("فشل قبول العرض");
          }
          return false;
        }
      } else {
        if (response.statusCode == 404) {
          if (Constants.language == "en") {
            _alertDialog("Failed to accept offer");
          } else {
            _alertDialog("فشل قبول العرض");
          }
        } else {
          if (Constants.language == "en") {
            _alertDialog("Something went wrong");
          } else {
            _alertDialog("هناك خطأ ما");
          }
        }
        return false;
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      return false;
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
