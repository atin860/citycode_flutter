// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// ignore: unused_import
import 'package:audioplayers/audioplayers.dart';
import 'package:city_code/Screens/CouponReport.dart';
import 'package:city_code/Screens/company_chat_list_screen.dart';
import 'package:city_code/Screens/companycoupondetailscreen.dart';
import 'package:city_code/Screens/companyreportscreen.dart';
import 'package:city_code/Screens/redeem_points_screen.dart';
import 'package:city_code/Screens/sale_details_screen.dart';
import 'package:city_code/Screens/scanner_screen.dart';
import 'package:city_code/Screens/welcome_screen.dart';
import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/company_offer_model.dart';
import 'package:city_code/models/couponredeemmodel.dart';
import 'package:city_code/models/redeep_points_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/code_details_model.dart';
import '../models/company_details_model.dart';

class MemberCodeScreen extends StatefulWidget {
  const MemberCodeScreen({Key? key}) : super(key: key);

  @override
  _MemberCodeScreenState createState() => _MemberCodeScreenState();
}

class _MemberCodeScreenState extends State<MemberCodeScreen> {
  bool isVisbleredeem = true;
  String company_name = "",
      company_image = "",
      user_points = "",
      username = "",
      vip_code = "",
      city_code = "",
      chat_notification = "0";
  String citytransacioncode = "";
  var data = "";
  var offer = "";
  var citytype = "";
  bool isVisblecoupun = false;
  var tempindex = 0;
  bool _isLoading = true, city_code_screen = false;
  List<Offerlist>? offerlist = [];
  List<CouponData>? coupon_data = [];
  List<CompanyStatus>? companyStatus = [];
  FocusNode vipFocusNode = FocusNode();
  TextInputType inputType = TextInputType.text;
  TextEditingController vip_code_controller = TextEditingController();
  NetworkCheck networkCheck = NetworkCheck();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var hel;
  var msg;
  var company_login_secondcitycode;
  var status;
  Future<void> couponpreedem(String userID, String user) async {
    Map<String, String> jsonbody = {
      "couponid": userID,
      "userid": user,
    };
    var network = NewVendorApiService();
    String urls = "http://cp.citycode.om/public/index.php/redeemcoupon";
    var res = await network.postresponse(urls, jsonbody);
    var model = Couponredeemmodel.fromJson(res);
    String stat = model.status.toString();

    print("coupon" + userID);
    print("userid" + user);

    setState(() {
      status = model.couponStatus;

      print("datastatus" + status.toString());
    });

    print("coupon redeem status" + stat);

    if (stat.contains("201")) {
      setState(() {
        //  _isLoading=false;
      });
    } else {
      // alertShow(context,"error");
      setState(() {
        _isLoading = false;
      });
    }
    print("coupon redeem data" + res!.toString());
    setState(() {
      // _isLoading=false;
    });
  }
//List<Offerlist> offerList = []; // Replace this with your actual list of Offerlist objects

  // List<Offerlist> getCombinedOfferList() {
  //   List<Offerlist> publicOffers =
  //       offerlist!.where((offer) => offer.couponType == 'public').toList();
  //   List<Offerlist> vipOffers =
  //       offerlist!.where((offer) => offer.couponType == 'vip').toList();

  //   List<Offerlist> combinedList = [];

  //   // Add public offers to the combined list
  //   combinedList.addAll(publicOffers);

  //   // Iterate over the VIP offers and add them to the combined list only if they are not already present
  //   for (Offerlist vipOffer in vipOffers) {
  //     bool offerAlreadyAdded =
  //         combinedList.any((offer) => offer.id == vipOffer.id);
  //     if (!offerAlreadyAdded) {
  //       combinedList.add(vipOffer);
  //     }
  //   }

  //   return combinedList;
  // }

  List<CouponData>? companycoupondata = [];
  List<Offerlist>? Offer = [];
  // Future<void> sendpayment() async {
  //   Map<String, String> jsonbody = {
  //     "company_id": Constants.company_id,
  //     "branch_id": Constants.branch_id,
  //     "coupon_type": "city"
  //   };
  //   var network = NewVendorApiService();
  //   String urls = "http://185.188.127.11/public/index.php/cityoffer";
  //   var res = await network.postresponse(urls, jsonbody);
  //   var model = CompanyOfferModel.fromJson(res);
  //   String stat = model.status.toString();
  //   //var nopopupcatID = widget.cat_id;
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   print("datais here" + stat.toString());

  //   if (stat.contains("201")) {
  //     setState(() {
  //       companycoupondata = model.couponData!;
  //       Offer = model.offerlist;
  //     });
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     var length = companycoupondata!.length;
  //     print("length" + length.toString());
  //   } else if (stat.contains("404")) {
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "Somthing Went Wrong",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  //   print("rrrss" + res!.toString());
  // }
  Future<void> sendpayment() async {
    Map<String, String> jsonbody = {
      "company_id": Constants.company_id,
      "branch_id": Constants.branch_id,
      // Remove the coupon_type field to fetch both VIP and public offers
    };

    var network = NewVendorApiService();
    String urls = "http://185.188.127.11/public/index.php/cityoffer";
    var res = await network.postresponse(urls, jsonbody);
    var model = CompanyOfferModel.fromJson(res);
    String stat = model.status.toString();
    // var nopopupcatID = widget.cat_id;

    setState(() {
      _isLoading = true;
    });

    print("datais here" + stat.toString());

    if (stat.contains("201")) {
      setState(() {
        companycoupondata = model.couponData!;
        Offer = model.offerlist;
      });
      setState(() {
        _isLoading = false;
      });
      var length = companycoupondata!.length;
      print("length" + length.toString());

      // Display the offers
      for (var offer in Offer!) {
        print("Offer ID: ${offer.id}");
        print("Coupon Type: ${offer.couponType}");
        print("Company Discount: ${offer.companyDiscount}");
        print("Customer Discount: ${offer.customerDiscount}");
        print("Description: ${offer.description}");
        print("Start Date: ${offer.startDate}");
        print("End Date: ${offer.endDate}");
        print("-------------------------");
      }
    } else if (stat.contains("404")) {
      // Handle the case when offer is not found
    } else {
      Fluttertoast.showToast(
        msg: "Something Went Wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    print("rrrss" + res!.toString());
  }

  Future<void> Langauge() async {
    if (Constants.language == "ar") {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString("language", "en");
      Constants.language = "en";
      _prefs.setString("lang", "ar");
      Constants.lang = "ar";
      print("langauge" + Constants.language);
      print("lang" + Constants.lang);
    }
  }

  Future<void> Lang() async {
    if (Constants.language == "en") {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString("lang", "ar");
      Constants.lang = "ar";
      print("lang" + Constants.lang);
    }
  }

  @override
  void initState() {
    // plday();
    log("khkjgg o g" + offerlist.toString());
    Langauge();
    //Lang();
    print("langauge" + Constants.language);
    sendpayment();

    _getChatCount();

    _getCompanyDetails().then((value) => {
          _getCompanyOffers().then((value) => {
                if (value.offerlist != null && value.offerlist!.isNotEmpty)
                  {
                    if (value.companyStatus != null &&
                        value.companyStatus!.isNotEmpty)
                      {
                        for (int i = 0; i < value.offerlist!.length; i++)
                          {
                            setState(() {
                              offerlist!.add(value.offerlist![i]);
                              citytype = offerlist![i].couponType!;
                              print("citytype" + citytype.toString());
                              print("datasss" + offerlist.toString());
                            }),
                          },
                        offerlist!.add(Offerlist()),
                      }
                  }
              }),
          setState(() {
            company_name = Constants.language == "en"
                ? value.companydetails![0].displayName!
                : value.companydetails![0].displayArbName!.isNotEmpty
                    ? value.companydetails![0].displayArbName!
                    : value.companydetails![0].displayName!;

            Constants.company_name = company_name;
            company_image =
                value.imageBaseUrl! + value.companydetails![0].picture!;
            _isLoading = false;
            hel = value.companydetails![0].redeem;
            print("hellooooo" + value.companydetails![0].redeem.toString());
            print("datasss" + offerlist.toString());
            print("coupondtaaa" + coupon_data.toString());
          }),
        });

    if (Platform.isIOS) {
      iOS_Permission();
    }
    _firebaseMessaging.getToken().then((value) => {
          print("token:- " + value!),
          update_token(value),
        });

    super.initState();
  }

  Future<void> _getChatCount() async {
    print("called");
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/messagecount?userid=${Constants.branch_id}&send_by=company&seenstatus=unseen'));
      if (response.statusCode == 201) {
        var responseServer = jsonDecode(response.body);

        if (kDebugMode) {
          print(responseServer);
        }

        if (responseServer["status"] == 201) {
          if (int.parse(responseServer["messagecount"]) > 0) {
            setState(() {
              chat_notification = responseServer["messagecount"];
            });
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

  void iOS_Permission() {
    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
  }

  Future<void> update_token(String token) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {"branch_id": Constants.branch_id, "android_token": token};

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/companytoken'),
        body: body,
      );

      var responseServer = jsonDecode(response.body);

      if (kDebugMode) {
        print(responseServer);
      }

      if (response.statusCode == 201) {
        if (responseServer["status"] == 201) {
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

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    vipFocusNode.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    if (city_code_screen) {
      setState(() {
        city_code_screen = false;
      });
      return false;
    } else {
      return true;
    }
  }

  var orgnumber = "";
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFF2CC0F),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFF2CC0F),
          title: Text(
            company_name,
            style: TextStyle(
              color: Colors.black,
              fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
            ),
          ),
          actions: <Widget>[
            Visibility(
              visible: !city_code_screen,
              child: IconButton(
                onPressed: () {
                  _showMyDialog();
                },
                icon: const Icon(Icons.logout),
                color: Colors.black,
              ),
            ),
            Visibility(
              visible: city_code_screen,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    city_code_screen = false;
                  });
                },
                icon: const Icon(CupertinoIcons.home),
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFF2CC0F),
            body: Stack(
              children: [
                Visibility(
                  visible: !_isLoading,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      height: height,
                      margin: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(company_image),
                              radius: width * 0.15,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              company_name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                              ),
                            ),
                          ),
                          Visibility(
                            visible: city_code_screen,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                Constants.branch_name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: city_code_screen,
                            child: Container(
                              width: width,
                              margin: const EdgeInsets.only(top: 10.0),
                              height: 1.0,
                              color: Colors.black,
                            ),
                          ),
                          Visibility(
                            visible: !city_code_screen,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      Constants.branch_name.length > 30
                                          ? '${Constants.branch_name.substring(0, 30)}...'
                                          : Constants.branch_name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                      ),
                                    ),
                                  ),
                                  companycoupondata!.isNotEmpty
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(left: 250),
                                          child: IconButton(
                                            iconSize: 30,
                                            icon:
                                                const Icon(CupertinoIcons.doc),
                                            color: Colors.black,
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          couponreport(
                                                            userid: Constants
                                                                .user_id,
                                                            companyimage:
                                                                company_image,
                                                            companyname: Constants
                                                                .company_name,
                                                            companyid: Constants
                                                                .company_id,
                                                          )));
                                            },
                                          ),
                                        )
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(left: 190),
                                          child: IconButton(
                                            iconSize: 30,
                                            icon:
                                                const Icon(CupertinoIcons.doc),
                                            color: Colors.black,
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          companyreport(
                                                            userid: Constants
                                                                .user_id,
                                                            companyimage:
                                                                company_image,
                                                            companyname: Constants
                                                                .company_name,
                                                            companyid: Constants
                                                                .company_id,
                                                            branchid: Constants
                                                                .branch_id,
                                                          )));
                                            },
                                          ),
                                        ),
                                  GestureDetector(
                                    onTap: () async {
                                      Route route = MaterialPageRoute(
                                          builder: (context) =>
                                              CompanyChatListScreen(
                                                  company_image));
                                      await Navigator.push(context, route);
                                      _getChatCount();
                                    },
                                    child: Container(
                                      //margin: EdgeInsets.only(left: 170),
                                      child: const Image(
                                        image:
                                            AssetImage("images/chat_icon.png"),
                                        width: 30.0,
                                        height: 30.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: city_code_screen,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "VIP Code: $vip_code",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    Constants.language == "en"
                                        ? "Name: $username"
                                        : "اسم: $username",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  companycoupondata!.isEmpty &&
                                          !city_code_screen
                                      ? Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          width: 180,
                                          //  height: ,
                                          margin: const EdgeInsets.only(
                                              top: 10.0, bottom: 10.0),

                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.black,
                                              backgroundColor:
                                                  const Color(0xFFF2CC0F),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10), // <-- Radius
                                              ),
                                              fixedSize: const Size(340, 45),
                                              // foreground
                                            ),

                                            icon: const Icon(
                                              CupertinoIcons.qrcode_viewfinder,
                                              size: 30,
                                            ),
                                            //  color: Colors.black,
                                            onPressed: () async {
                                              print("databruhhh" +
                                                  citytransacioncode
                                                      .toString());
                                              Route route = MaterialPageRoute(
                                                  builder: (contect) =>
                                                      const ScannerScreen());
                                              String citycodescan =
                                                  await Navigator.push(
                                                      context, route);
                                              //dataname();
                                              final scanresponse =
                                                  jsonDecode(citycodescan);
                                              citytransacioncode =
                                                  citycodescan.toString();
                                              String filteredString =
                                                  citytransacioncode.replaceAll(
                                                      '"', '');
                                              String citydata =
                                                  scanresponse["citycodeqr"]
                                                      .toString();
                                              String vipdata =
                                                  scanresponse["vipcodeqr"]
                                                      .toString();
                                              String orgdata =
                                                  scanresponse["vipcode"]
                                                      .toString();
                                              String companyid =
                                                  scanresponse["couponid"]
                                                      .toString();
                                              String compid =
                                                  scanresponse["companyid"]
                                                      .toString();

                                              if (offer == "null") {
                                                //  _alertDialog("No Offer Available");
                                              } else if (companyid == null ||
                                                  companyid.isEmpty) {
                                                companyid = "1";
                                              }
                                              print("couponiddd" + companyid);
                                              print("citydata" + citydata);
                                              print("vipdata" + vipdata);
                                              print("orgdata" + orgdata);
                                              print("companyid" + compid);
                                              print("databruhhh" +
                                                  filteredString.toString());
                                              print("usenameqr" +
                                                  usenameqr.toString());
                                              print("holding Id" +
                                                  Constants.company_id);
                                              String nameq = "";
                                              var userid = "";
                                              var vip = "";

                                              _getCodeDetails(citydata)
                                                  .then((value) async => {
                                                        nameq = value
                                                            .userdetail![0].name
                                                            .toString(),
                                                        userid = value
                                                            .userdetail![0].id
                                                            .toString(),
                                                        vip = value
                                                            .userdetail![0]
                                                            .vipCode
                                                            .toString(),
                                                        print(
                                                            "namebhai" + nameq),
                                                        if (offer == "null")
                                                          {
                                                            // _alertDialog("No Offer Available"),
                                                          }
                                                        else if (compid ==
                                                            Constants
                                                                .company_id)
                                                          {
                                                            print("one way"),
                                                            //couponpreedem(companyid,userid),
                                                            route = MaterialPageRoute(
                                                                builder: (context) => SaleDetailsScreen(
                                                                    vip,
                                                                    nameq
                                                                        .toString(),
                                                                    company_image,
                                                                    user_points,
                                                                    userid,
                                                                    citydata,
                                                                    orgdata,
                                                                    "",
                                                                    companyid
                                                                        .toString(),
                                                                    "")),
                                                            await Navigator
                                                                .push(context,
                                                                    route),
                                                          }
                                                        else if (orgdata !=
                                                            "null")
                                                          {
                                                            route = MaterialPageRoute(
                                                                builder: (context) => SaleDetailsScreen(
                                                                    orgdata,
                                                                    nameq
                                                                        .toString(),
                                                                    company_image,
                                                                    user_points,
                                                                    userid,
                                                                    citydata,
                                                                    "",
                                                                    "",
                                                                    companyid,
                                                                    "")),
                                                            await Navigator
                                                                .push(context,
                                                                    route),
                                                          }
                                                        else if (companyid ==
                                                                "null" &&
                                                            offer != "null")
                                                          {
                                                            print("citytype2" +
                                                                citytype
                                                                    .toString()),
                                                            if (citytype
                                                                    .toString() ==
                                                                "vip")
                                                              {
                                                                print(
                                                                    "user login"),
                                                                route = MaterialPageRoute(
                                                                    builder: (context) => SaleDetailsScreen(
                                                                        vip,
                                                                        nameq
                                                                            .toString(),
                                                                        company_image,
                                                                        user_points,
                                                                        userid,
                                                                        citydata,
                                                                        orgdata,
                                                                        "",
                                                                        companyid,
                                                                        "")),
                                                                await Navigator
                                                                    .push(
                                                                        context,
                                                                        route),
                                                              }
                                                            else
                                                              {
                                                                print(
                                                                    "citypage"),
                                                                route = MaterialPageRoute(
                                                                    builder: (context) => SaleDetailsScreen(
                                                                        "",
                                                                        nameq
                                                                            .toString(),
                                                                        company_image,
                                                                        user_points,
                                                                        userid,
                                                                        citydata,
                                                                        "",
                                                                        "",
                                                                        companyid
                                                                            .toString(),
                                                                        "")),
                                                                await Navigator
                                                                    .push(
                                                                        context,
                                                                        route),
                                                              }
                                                          }
                                                        else
                                                          {
                                                            print("two way"),
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Invalid Coupon.",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors.red,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0),
                                                          }
                                                      });

                                              //_showMyDialog();
                                            },
                                            label: const Text(
                                              "Scan Now",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  companycoupondata!.isNotEmpty
                                      ?
                                      //!city_code_screen?
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          width: 370,
                                          //  height: ,
                                          margin: const EdgeInsets.only(
                                              top: 10.0, bottom: 10.0),

                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.black,
                                              backgroundColor:
                                                  const Color(0xFFF2CC0F),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10), // <-- Radius
                                              ),
                                              fixedSize: const Size(340, 45),
                                              // foreground
                                            ),

                                            icon: const Icon(
                                              CupertinoIcons.qrcode_viewfinder,
                                              size: 30,
                                            ),
                                            //  color: Colors.black,
                                            onPressed: () async {
                                              print("databruhhh" +
                                                  citytransacioncode
                                                      .toString());
                                              Route route = MaterialPageRoute(
                                                  builder: (contect) =>
                                                      const ScannerScreen());
                                              String citycodescan =
                                                  await Navigator.push(
                                                      context, route);
                                              //dataname();

                                              final scanresponse =
                                                  jsonDecode(citycodescan);
                                              citytransacioncode =
                                                  citycodescan.toString();
                                              String filteredString =
                                                  citytransacioncode.replaceAll(
                                                      '"', '');
                                              String status =
                                                  scanresponse["status"]
                                                      .toString();
                                              String citydata =
                                                  scanresponse["citycodeqr"]
                                                      .toString();
                                              String vipdata =
                                                  scanresponse["vipcodeqr"]
                                                      .toString();
                                              String orgdata =
                                                  scanresponse["vipcode"]
                                                      .toString();
                                              String companyid =
                                                  scanresponse["couponid"]
                                                      .toString();
                                              String compid =
                                                  scanresponse["companyid"]
                                                      .toString();
                                              String perchasedid =
                                                  scanresponse["perchasedid"]
                                                      .toString();
                                              String branchid =
                                                  scanresponse["branchid"]
                                                      .toString();

                                              if (companyid == null ||
                                                  companyid.isEmpty) {
                                                companyid = "1";
                                              }
                                              print("status" + status);
                                              print("couponiddd" + companyid);
                                              print("citydata" + citydata);
                                              print("vipdata" + vipdata);
                                              print("orgdata" + orgdata);
                                              print("databruhhh" +
                                                  filteredString.toString());
                                              print("usenameqr" +
                                                  usenameqr.toString());
                                              print("branchid" +
                                                  branchid.toString());
                                              String nameq = "";
                                              var userid = "";
                                              var vip = "";
                                              if (status == "expire") {
                                                Fluttertoast.showToast(
                                                    msg: "Used Coupon.",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }

                                              _getCodeDetails(citydata)
                                                  .then((value) async => {
                                                        nameq = value
                                                            .userdetail![0].name
                                                            .toString(),
                                                        userid = value
                                                            .userdetail![0].id
                                                            .toString(),
                                                        vip = value
                                                            .userdetail![0]
                                                            .vipCode
                                                            .toString(),
                                                        print(
                                                            "namebhai" + nameq),
                                                        /*if(offer=="null"){
                                          _alertDialog("No Offer Available"),
                                        }*/
                                                        if (compid ==
                                                            Constants
                                                                .company_id)
                                                          {
                                                            if (branchid ==
                                                                Constants
                                                                    .branch_id)
                                                              {
                                                                print(
                                                                    "one way only coupon"),
                                                                route = MaterialPageRoute(
                                                                    builder: (context) => SaleDetailsScreen(
                                                                        vip,
                                                                        nameq
                                                                            .toString(),
                                                                        company_image,
                                                                        user_points,
                                                                        userid,
                                                                        citydata,
                                                                        orgdata,
                                                                        "",
                                                                        companyid
                                                                            .toString(),
                                                                        perchasedid)),
                                                                await Navigator
                                                                    .push(
                                                                        context,
                                                                        route)
                                                              }
                                                            else
                                                              {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "Invalid Coupon.",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    gravity: ToastGravity
                                                                        .BOTTOM,
                                                                    timeInSecForIosWeb:
                                                                        1,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    fontSize:
                                                                        16.0),
                                                              }

                                                            //  }
                                                          }
                                                        else
                                                          {
                                                            print("two way"),
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Invalid Coupon.",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors.red,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0),
                                                          }
                                                      });

                                              //_showMyDialog();
                                            },
                                            label: const Text(
                                              "Scan Now",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: city_code_screen ? 370 : 190,
                                          //width: 370,
                                          margin: const EdgeInsets.only(
                                              top: 10.0, bottom: 10.0),
                                          child: TextField(
                                            focusNode: vipFocusNode,
                                            keyboardType: inputType,
                                            textCapitalization:
                                                TextCapitalization.characters,
                                            controller: vip_code_controller,
                                            maxLines: 1,
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Colors.black)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Colors.black)),
                                              hintText: Constants.language ==
                                                      "en"
                                                  //    ? "Enter the City Code / VIP Code"
                                                  ? "Enter Code"
                                                  : "أدخل كود الخصم / VIP CODE",
                                              hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    Constants.language == "en"
                                                        ? "Roboto"
                                                        : "GSSFont",
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                            onChanged: (value) {
                                              if (value.isEmpty) {
                                                vipFocusNode.unfocus();
                                                setState(() {
                                                  inputType =
                                                      TextInputType.text;
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 75),
                                                      () {
                                                    vipFocusNode.requestFocus();
                                                  });
                                                });
                                              } else if (value.length == 1) {
                                                vipFocusNode.unfocus();
                                                setState(() {
                                                  inputType =
                                                      TextInputType.number;
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 75),
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
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: !city_code_screen &&
                                (companycoupondata == null ||
                                    companycoupondata!.isEmpty),
                            child: Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: Offer != null ? Offer!.length : 0,
                                itemBuilder: (context, index) {
                                  final offer = Offer![index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Column(
                                      children: [
                                        if (index == 0 ||
                                            (offer.couponType !=
                                                Offer![index - 1].couponType))
                                          Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(
                                                      offer.couponType == "vip"
                                                          ? "VIP Offer"
                                                          : "Public Offer",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                      ),
                                                      textDirection: Constants
                                                                  .lang ==
                                                              "en"
                                                          ? TextDirection.ltr
                                                          : TextDirection.rtl,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        //const SizedBox(height: 10),
                                        Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            color: Colors.green.shade800,
                                          ),
                                          padding: const EdgeInsets.all(10.0),
                                          width: width,
                                          child: Text(
                                            '${offer.customerDiscount!}%',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 23.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          width: width,
                                          height: 190,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                            color: Colors.white,
                                          ),
                                          padding: const EdgeInsets.all(10.0),
                                          child: SingleChildScrollView(
                                            child: Text(
                                              Constants.lang == "en"
                                                  ? offer.description!
                                                  : offer.arbDescription!
                                                          .isNotEmpty
                                                      ? offer.arbDescription!
                                                      : offer.description!,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    Constants.lang == "en"
                                                        ? "Roboto"
                                                        : "GSSFont",
                                                fontSize: 14.0,
                                              ),
                                              textAlign: Constants.lang == "en"
                                                  ? TextAlign.left
                                                  : TextAlign.right,
                                              textDirection:
                                                  Constants.lang == "en"
                                                      ? TextDirection.ltr
                                                      : TextDirection.rtl,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          companycoupondata!.isNotEmpty
                              ? SizedBox(
                                  height: 420,
                                  child: ListView.builder(
                                      itemCount: companycoupondata!.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        coupondetalscreen(
                                                          compnyname:
                                                              company_name,
                                                          compantimage:
                                                              company_image,
                                                          couponamount:
                                                              companycoupondata![
                                                                      index]
                                                                  .couponAmount
                                                                  .toString(),
                                                          couponprice:
                                                              companycoupondata![
                                                                      index]
                                                                  .couponPrice
                                                                  .toString(),
                                                          expiredate:
                                                              companycoupondata![
                                                                      index]
                                                                  .endDate
                                                                  .toString(),
                                                          couponname:
                                                              companycoupondata![
                                                                      index]
                                                                  .couponName
                                                                  .toString(),
                                                          coupondescription: Constants
                                                                      .lang ==
                                                                  "en"
                                                              ? companycoupondata![
                                                                      index]
                                                                  .couponDetails
                                                                  .toString()
                                                              : companycoupondata![
                                                                      index]
                                                                  .arbCouponDetails
                                                                  .toString(),
                                                        )));
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            child: CouponCard(
                                              height: 140,
                                              width: 600,
                                              backgroundColor:
                                                  const Color(0xFFE6D997),
                                              curveAxis: Axis.vertical,
                                              curvePosition: 100,

                                              curveRadius: 30,

                                              // decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),

                                              firstChild: Container(
                                                decoration: const BoxDecoration(
                                                    //   borderRadius: BorderRadius.only(topLeft: Radius.circular(1)),

                                                    ),
                                                width: double.maxFinite,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            // _showDialog(context,jsonEncode(Constants.city_code).toString() , "", couponlisting![index].purchaseStatus.toString());
                                                          },
                                                          child: Container(
                                                            height: 90,
                                                            width: 90,
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 10.0,
                                                              right: 1.0,
                                                            ),
                                                            child: QrImage(
                                                              data: "data",
                                                              version:
                                                                  QrVersions
                                                                      .auto,
                                                              size: 130,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 12),
                                                          child: const Dash(
                                                              direction:
                                                                  Axis.vertical,
                                                              length: 100,
                                                              dashLength: 12,
                                                              dashThickness: 2,
                                                              dashColor:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              secondChild: Container(
                                                width: double.maxFinite,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            Constants.language ==
                                                                    "en"
                                                                ? "COUPON AMOUNT: " +
                                                                    companycoupondata![
                                                                            index]
                                                                        .couponAmount
                                                                        .toString() +
                                                                    " OMR"
                                                                : "مبلغ القسيمة: " +
                                                                    companycoupondata![
                                                                            index]
                                                                        .couponAmount
                                                                        .toString() +
                                                                    " OMR",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        Text(
                                                          Constants.language ==
                                                                  "en"
                                                              ? "COUPON PRICE: " +
                                                                  companycoupondata![
                                                                          index]
                                                                      .couponPrice
                                                                      .toString() +
                                                                  " OMR"
                                                              : "سعر القسيمة:" +
                                                                  companycoupondata![
                                                                          index]
                                                                      .couponPrice
                                                                      .toString() +
                                                                  " OMR",
                                                          //   '2.000 OMR',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        // Spacer(),
                                                        const SizedBox(
                                                            height: 15),
                                                        Text(
                                                          //  'EXPIRATION DATE: 30/11/2023',
                                                          Constants.language ==
                                                                  "en"
                                                              ? "EXPIRE DATE:  " +
                                                                  companycoupondata![
                                                                          index]
                                                                      .endDate
                                                                      .toString()
                                                              : "تاريخ انتهاء الصلاحية:" +
                                                                  companycoupondata![
                                                                          index]
                                                                      .endDate
                                                                      .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        Text(
                                                          //  'EXPIRATION DATE: 30/11/2023',
                                                          Constants.language ==
                                                                  "en"
                                                              ? "COUPON QUANTITY:  " +
                                                                  companycoupondata![
                                                                          index]
                                                                      .couponQuantity
                                                                      .toString()
                                                              : "كمية القسيمة:" +
                                                                  companycoupondata![
                                                                          index]
                                                                      .couponQuantity
                                                                      .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : Container(),
                        ],
                      ),
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
            bottomNavigationBar: Visibility(
              visible: !_isLoading,
              child: Container(
                child: SafeArea(
                    child: Row(
                  children: [
                    Visibility(
                      visible: hel == "1"
                          ? isVisbleredeem = true
                          : isVisbleredeem = false,
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (vip_code_controller.text.isNotEmpty) {
                              if (vip_code_controller.text.length == 5) {
                                setState(() {
                                  _isLoading = true;
                                });

                                Route route;
                                _getCodeDetails("").then((cityvalue) => {
                                      _getRedeemPoints().then((value) async => {
                                            if (value.redeemProduct != null &&
                                                value.redeemProduct!.isNotEmpty)
                                              {
                                                // hel = true,
                                                if (cityvalue.code ==
                                                    "V.I.P Code")
                                                  {
                                                    print("citycode:::::" +
                                                        cityvalue.code
                                                            .toString()),
                                                    route = MaterialPageRoute(
                                                        builder: (context) =>
                                                            RedeemPointsScreen(
                                                                cityvalue
                                                                    .userdetail![
                                                                        0]
                                                                    .vipCode!,
                                                                cityvalue
                                                                    .userdetail![
                                                                        0]
                                                                    .cityCode!,
                                                                cityvalue
                                                                    .userdetail![
                                                                        0]
                                                                    .totalpoint!,
                                                                value
                                                                    .imageBaseUrl!,
                                                                value
                                                                    .companyImageBaseUrl!,
                                                                value
                                                                    .redeemProduct!,
                                                                company_image,
                                                                cityvalue
                                                                    .userdetail![
                                                                        0]
                                                                    .id!)),
                                                    await Navigator.push(
                                                        context, route),
                                                    _getChatCount(),
                                                  }
                                                else
                                                  {
                                                    print("citycode1:::::" +
                                                        cityvalue.code
                                                            .toString()),
                                                    route = MaterialPageRoute(
                                                        builder: (context) =>
                                                            RedeemPointsScreen(
                                                                "",
                                                                cityvalue
                                                                    .userdetail![
                                                                        0]
                                                                    .cityCode!,
                                                                cityvalue
                                                                    .userdetail![
                                                                        0]
                                                                    .totalpoint!,
                                                                value
                                                                    .imageBaseUrl!,
                                                                value
                                                                    .companyImageBaseUrl!,
                                                                value
                                                                    .redeemProduct!,
                                                                company_image,
                                                                cityvalue
                                                                    .userdetail![
                                                                        0]
                                                                    .id!)),
                                                    await Navigator.push(
                                                        context, route),
                                                    _getChatCount(),
                                                  }
                                              }
                                            else
                                              {
                                                _showDialog(),
                                              },
                                            setState(() {
                                              _isLoading = false;
                                            }),
                                          }),
                                    });
                              } else {
                                _alertDialog(Constants.language == "en"
                                    ? "Please Enter valid City/VIP Code"
                                    : "الرجاء إدخال رمز المدينة / VIP صالح");
                              }
                            } else {
                              _alertDialog(Constants.language == "en"
                                  ? "Please Enter City/VIP Code"
                                  : "الرجاء إدخال رمز العضوية / VIP");
                            }
                          },
                          child: Text(
                            Constants.language == "en"
                                ? "Redeem points"
                                : "أستبدال نقاط",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontSize: 18.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF2CC0F),
                            elevation: 0.0,
                            textStyle: const TextStyle(color: Colors.black),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.45, 30.0),
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
                    Visibility(
                      visible: companycoupondata!.isNotEmpty ? false : true,
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (vip_code_controller.text.isNotEmpty) {
                              if (vip_code_controller.text.length == 5) {
                                setState(() {
                                  _isLoading = true;
                                });
                                Route route;
                                username = "";
                                String userId = "";
                                _getCodeDetails("").then((value) async => {
                                      if (city_code_screen)
                                        {
                                          if (value.code == "V.I.P Code")
                                            {
                                              _alertDialog(Constants.language ==
                                                      "en"
                                                  ? "Please enter valid customer code"
                                                  : "الرجاء إدخال رمز عميل صالح"),
                                            }
                                          else
                                            {
                                              print("throww"),
                                              /* if (value.userdetail![0].org_status! == "1")
                                              {

                                              username = Constants.language ==
                                              "en"
                                              ? value.userdetail![0].name!
                                                  : value.userdetail![0]
                                                  .arbName!.isNotEmpty
                                              ? value.userdetail![0]
                                                  .arbName!
                                                  : value.userdetail![0]
                                                  .name!,
                                              user_points = value
                                                  .userdetail![0].totalpoint!,
                                              user_id =
                                              value.userdetail![0].id!,
                                              route = MaterialPageRoute(
                                              builder: (context) =>
                                              SaleDetailsScreen(
                                              value.userdetail![0]
                                                  .vipCode!,
                                              username,
                                              company_image,
                                              user_points,
                                              user_id,
                                              value.userdetail![0]
                                                  .cityCode!)),
                                              await Navigator.push(
                                              context, route),
                                              _getChatCount(),
                                              }*/
                                              if (value.userdetail![0]
                                                      .cityCode! ==
                                                  city_code)
                                                {
                                                  print(
                                                      "cityy code" + city_code),
                                                  username = Constants
                                                              .language ==
                                                          "en"
                                                      ? value
                                                          .userdetail![0].name!
                                                      : value
                                                              .userdetail![0]
                                                              .arbName!
                                                              .isNotEmpty
                                                          ? value.userdetail![0]
                                                              .arbName!
                                                          : value.userdetail![0]
                                                              .name!,
                                                  user_points = value
                                                      .userdetail![0]
                                                      .totalpoint!,
                                                  userId =
                                                      value.userdetail![0].id!,
                                                  print("valuee1" +
                                                      value.userdetail![0]
                                                          .vipCode!),
                                                  route = MaterialPageRoute(
                                                      builder: (context) =>
                                                          SaleDetailsScreen(
                                                              value
                                                                  .userdetail![
                                                                      0]
                                                                  .vipCode!,
                                                              username,
                                                              company_image,
                                                              user_points,
                                                              userId,
                                                              value
                                                                  .userdetail![
                                                                      0]
                                                                  .cityCode!,
                                                              "",
                                                              "",
                                                              "",
                                                              "")),
                                                  await Navigator.push(
                                                      context, route),
                                                  _getChatCount(),
                                                }
                                              else if (city_code_screen)
                                                {
                                                  company_login_secondcitycode =
                                                      vip_code_controller.text,
                                                  print("company_login_secondcitycode" +
                                                      company_login_secondcitycode),
                                                  print("textboxvalue" +
                                                      vip_code_controller.text),
                                                  username = Constants
                                                              .language ==
                                                          "en"
                                                      ? value
                                                          .userdetail![0].name!
                                                      : value
                                                              .userdetail![0]
                                                              .arbName!
                                                              .isNotEmpty
                                                          ? value.userdetail![0]
                                                              .arbName!
                                                          : value.userdetail![0]
                                                              .name!,
                                                  user_points = value
                                                      .userdetail![0]
                                                      .totalpoint!,
                                                  userId =
                                                      value.userdetail![0].id!,
                                                  print("valuee" +
                                                      value.userdetail![0]
                                                          .vipCode!),
                                                  route = MaterialPageRoute(
                                                      builder: (context) =>
                                                          SaleDetailsScreen(
                                                              // value.userdetail![0]
                                                              //     .vipCode!,
                                                              //  "",
                                                              //orgnumber,
                                                              vip_code,
                                                              username,
                                                              company_image,
                                                              user_points,
                                                              userId,
                                                              //value.userdetail![0]
                                                              //   .cityCode!,
                                                              company_login_secondcitycode,
                                                              orgnumber,
                                                              value
                                                                  .userdetail![
                                                                      0]
                                                                  .org_status!,
                                                              "",
                                                              "")),
                                                  await Navigator.push(
                                                      context, route),
                                                  _getChatCount(),
                                                }
                                            },
                                        }
                                      else if (value
                                              .userdetail![0].org_status ==
                                          "1")
                                        {
                                          print("userdetal" +
                                              value.userdetail![0].vipCode!),
                                          orgnumber =
                                              value.userdetail![0].vipCode!,
                                          setState(() {
                                            print("value of city code" +
                                                value.code.toString());
                                            username =
                                                Constants.language == "en"
                                                    ? value.userdetail![0].name!
                                                    : value.userdetail![0]
                                                            .arbName!.isNotEmpty
                                                        ? value.userdetail![0]
                                                            .arbName!
                                                        : value.userdetail![0]
                                                            .name!;
                                            user_points = value
                                                .userdetail![0].totalpoint!;
                                            userId = value.userdetail![0].id!;
                                            vip_code = vip_code_controller.text;
                                            city_code =
                                                value.userdetail![0].cityCode!;
                                            vip_code_controller.text = "";
                                            vipFocusNode.unfocus();
                                            inputType = TextInputType.text;
                                            city_code_screen = true;
                                          }),
                                        }
                                      else if (value.code == "V.I.P Code")
                                        {
                                          setState(() {
                                            print("value of city code" +
                                                value.code.toString());
                                            username =
                                                Constants.language == "en"
                                                    ? value.userdetail![0].name!
                                                    : value.userdetail![0]
                                                            .arbName!.isNotEmpty
                                                        ? value.userdetail![0]
                                                            .arbName!
                                                        : value.userdetail![0]
                                                            .name!;
                                            user_points = value
                                                .userdetail![0].totalpoint!;
                                            userId = value.userdetail![0].id!;
                                            vip_code = vip_code_controller.text;
                                            city_code =
                                                value.userdetail![0].cityCode!;
                                            vip_code_controller.text = "";
                                            vipFocusNode.unfocus();
                                            inputType = TextInputType.text;
                                            city_code_screen = true;
                                          }),
                                        }
                                      else if (offer == "null")
                                        {
                                          //_alertDialog("No Offer Available"),
                                        }
                                      else
                                        {
                                          print("go"),
                                          username = Constants.language == "en"
                                              ? value.userdetail![0].name!
                                              : value.userdetail![0].arbName!
                                                      .isNotEmpty
                                                  ? value
                                                      .userdetail![0].arbName!
                                                  : value.userdetail![0].name!,
                                          user_points =
                                              value.userdetail![0].totalpoint!,
                                          userId = value.userdetail![0].id!,
                                          route = MaterialPageRoute(
                                              builder: (context) =>
                                                  SaleDetailsScreen(
                                                      "",
                                                      username,
                                                      company_image,
                                                      user_points,
                                                      userId,
                                                      vip_code_controller.text,
                                                      "",
                                                      "",
                                                      "",
                                                      "")),
                                          await Navigator.push(context, route),
                                          _getChatCount(),
                                        },
                                      setState(() {
                                        _isLoading = false;
                                      }),
                                    });
                              } else {
                                _alertDialog(Constants.language == "en"
                                    ? "Please Enter valid City/VIP Code"
                                    : "الرجاء إدخال رمز المدينة / VIP صالح");
                              }
                            } else {
                              _alertDialog(Constants.language == "en"
                                  ? "Please Enter City/VIP Code"
                                  : "الرجاء إدخال رمز العضوية / VIP");
                            }
                          },
                          child: Text(
                            Constants.language == "en" ? "Sale" : "عملية شراء",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontSize: 18.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF2CC0F),
                            elevation: 0.0,
                            textStyle: const TextStyle(color: Colors.black),
                            fixedSize: hel == "1"
                                ? Size(MediaQuery.of(context).size.width * 0.45,
                                    30.0)
                                : Size(MediaQuery.of(context).size.width * 0.96,
                                    30.0),
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
                  ],
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<CompanyDetailsModel> _getCompanyDetails() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(
        Uri.parse('http://185.188.127.11/public/index.php/ApiCompany/' +
            Constants.company_id),
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

  Future<CompanyOfferModel> _getCompanyOffers() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "company_id": Constants.company_id,
        "branch_id": Constants.branch_id,
        "coupon_type": "vip"
      };

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/cityoffer'),
        body: body,
      );

      var responseServer = jsonDecode(response.body);
      data = responseServer["coupon_data"].toString();
      offer = responseServer["offerlist"].toString();

      // citytype=responseServer["offerlist"]["coupon_type"];
      print("databross" + data);
      print("myoffers" + offer);
      if (kDebugMode) {
        print(responseServer);
      }
      if (offer == "null") {
        print("eror");
        setState(() {
          _isLoading = false;
        });
        _alertDialog(Constants.language == "en"
            ? "No Offer Available"
            : "لا يوجد عرض متاح");
      }
      if (response.statusCode == 201) {
        if (responseServer["status"] == 201) {
          return CompanyOfferModel.fromJson(json.decode(response.body));
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

  Future<CodeDetailsModel> _getCodeDetails(var city) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "user_code":
            vip_code_controller.text.isEmpty ? city : vip_code_controller.text,
        "companyid": Constants.company_id
      };

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/getcodedetail'),
        body: body,
      );

      var responseServer = jsonDecode(response.body);

      if (kDebugMode) {
        print(responseServer);
      }

      if (response.statusCode == 200) {
        if (responseServer["status"] == 201) {
          return CodeDetailsModel.fromJson(json.decode(response.body));
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

  var usenameqr = "";
/*  void dataname(){
    _getCodeDetails("").then((value) async =>
    {
      usenameqr=value.userdetail![0].name.toString(),
      print("datascrore"+usenameqr.toString()),
    });
  }*/

  Future<RedeepPointsModel> _getRedeemPoints() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "company_id": Constants.company_id,
      };

      final response = await http.post(
        Uri.parse(
            'http://185.188.127.11/public/index.php/ApiProducts/redeem_product'),
        body: body,
      );

      var responseServer = jsonDecode(response.body);

      if (kDebugMode) {
        print(responseServer);
      }

      if (response.statusCode == 201) {
        if (responseServer["status"] == 201) {
          return RedeepPointsModel.fromJson(json.decode(response.body));
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  Constants.language == "en"
                      ? "Are you sure you want to logout?"
                      : "هل أنت متأكد أنك تريد تسجيل الخروج ؟",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.clear();
                Constants.mobile_no = "";
                Constants.company_id = "";
                Constants.branch_name = "";
                Constants.branch_id = "";
                Constants.name = "";
                Constants.company_name = "";
                _prefs.setString("language", Constants.language);
                Route newRoute = MaterialPageRoute(
                    builder: (context) => const WelcomeScreen());
                Navigator.pushAndRemoveUntil(
                    context, newRoute, (route) => false);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
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

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  Constants.language == "en"
                      ? "Redeem points not available"
                      : "استبدال النقاط غير متوفرة",
                  style: TextStyle(
                    color: const Color(0xFFF2CC0F),
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                Constants.language == "en" ? "OK" : "موافق",
                style: TextStyle(
                    color: const Color(0xFFF2CC0F),
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont"),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
