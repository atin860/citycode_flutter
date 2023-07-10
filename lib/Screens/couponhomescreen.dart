// ignore_for_file: avoid_unnecessary_containers, unused_import, must_be_immutable, override_on_non_overriding_member, avoid_print, unnecessary_new, non_constant_identifier_names, unused_local_variable, unused_element

import 'dart:convert';

import 'package:city_code/Screens/couponui_screen.dart';
import 'package:city_code/Screens/offer_details_screen.dart';
import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/couponlistingmodel.dart';

import 'package:city_code/models/couponlistmodel.dart';
import 'package:city_code/utils/constants.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/offers_model.dart';

class Couponsshowscreen extends StatefulWidget {
  // const Couponsshowscreen({Key? key}) : super(key: key);
  String companyid, branchid;
  Couponsshowscreen({Key? key, required this.companyid, required this.branchid})
      : super(key: key);

  @override
  State<Couponsshowscreen> createState() => _CouponsshowscreenState();
}

class _CouponsshowscreenState extends State<Couponsshowscreen>
    with SingleTickerProviderStateMixin {
  late List<bool> isSelected;
  late TabController _tabController;
  int index = 0;
  @override
  List<Offers>? companyinfo;
  var companyname = "";
  var couponename = "";
  var couponamount = "";
  var couponeprice = "";
  var companyiddata = "";
  var branchid = "";
  var startdate = "";
  var enddate = "";
  var dataone = "";
  var datatwo = "";
  var couponid = "";
  Future<void> share() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    dataone = pref.getString("companyiddata") ?? "";
    datatwo = pref.getString("companybranchdata") ?? "";
    print("data" + dataone);
  }

  Future<void> companylist() async {
    var network = NewVendorApiService();
    String urls =
        'http://185.188.127.11/public/index.php/ApiOffers?coupon_type=city';
    var res = await network.getresponse(urls);
    var model = Offers_model.fromJson(res);
    String stat = model.status.toString();
    coupondata = model.offers.toString();
    // couponlist();

    setState(() {
      companyinfo = model.offers;
      companyiddata = companyinfo![index].companyId.toString();
      branchid = companyinfo![index].branchId.toString();
      couponid = companyinfo![index].id.toString();
      print("my friend" + companyiddata);
    });

    couponlist();

    print(couponamount);
    print("dgdsgdsg" + stat);
    print("co" + companyiddata);
    print("branch" + branchid);

    if (stat.contains("201")) {
      /* Navigator.push(context, MaterialPageRoute(builder: (context)=>locationscreen(state:""'Oman, Al Batinah South,Barka', name: "", mobile: "",
        name1: username.toString(), mobile2: usermobile.toString(),
        state2:  useradress.toString(), actuaprice: itemamount, image: imagedata,
        totalprice: itemtotal, vat: price, discount: itemdiscount, productname: companyproductdata,
        demo: '+968 25252525', quantity: itemquantity, totalpoints: itempoints,)));*/
/*      Fluttertoast.showToast(
          msg: " Succesfully Added ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);*/
      /*print("Done"+Constants.category);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.category = widget.cat_id;
    //   await prefs.setBool('isLoggedIn', true);
    await prefs.setString("category", Constants.category);
    print("hogaya"+Constants.category);
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) =>
    VendorThankyouPage(bback:widget.cat_idd,)));*/
      setState(() {
        //  _isLoading=false;
      });
    } else {
      setState(() {
        //_isLoading=false;
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
    print("dgdg" + res!.toString());
    setState(() {
      // _isLoading=false;
    });
  }

  @override
  void initState() {
    print("company ind " + widget.companyid);
    share();
    print("data" + dataone);
    print("couponlistbranch" + widget.branchid);
    couponlistmethod();
    companylist();

    isSelected = [true, false];
    _tabController = new TabController(length: 2, vsync: this);
    if (couponlistdata != null && couponlistdata!.isNotEmpty) {
      for (int i = 0; i < couponlistdata!.length; i++) {
        setState(() {
          index = i;
          print(couponamount);
        });
      }
    }
    super.initState();
  }

  var coupondata = "";

  var expiredate = "";
  var companylogo = "";
  var companyimgurl = "";
  var Status = "";
  var coupontext = "";
  var companyid = "";
  List<CouponList>? couponlistdata = [];
  Future<void> couponlist() async {
    Map<String, String> jsonbody = {
      "companyid": companyiddata,
      // "branchid":widget.branchid,

      /*   "ad_1":_ads_1_file,
      "ad_2":_ads_2_file.toString(),
      "ad_3":_ads_3_file.toString(),
      "ad_4":_ads_4_file.toString(),
*/
    };
    var network = NewVendorApiService();
    String urls = "http://cp.citycode.om/public/index.php/couponlist";
    var res = await network.postresponse(urls, jsonbody);
    var model = Couponlistmodel.fromJson(res);
    String stat = model.status.toString();
    coupondata = model.couponList.toString();
    companyimgurl = model.companyImageBaseUrl.toString();

    print("couponlistbranch" + widget.branchid);

    setState(() {
      print("databroo" + companyiddata.toString());
      couponlistdata = model.couponList;
      companyid = couponlistdata![index].companyId.toString();
      companyname = couponlistdata![index].companyName.toString();
      couponename = couponlistdata![index].couponName.toString();
      couponamount = couponlistdata![index].couponAmount.toString();
      couponeprice = couponlistdata![index].couponPrice.toString();
      startdate = couponlistdata![index].startDate.toString();
      enddate = couponlistdata![index].endDate.toString();
      companylogo = couponlistdata![index].picture.toString();
      coupontext = couponlistdata![index].couponDetails.toString();
      Status = couponlistdata![index].status.toString();
      print("detail" + coupontext.toString());
    });

    print(couponamount);
    print("dgdsgdsg" + stat);

    if (stat.contains("201")) {
      /* Navigator.push(context, MaterialPageRoute(builder: (context)=>locationscreen(state:""'Oman, Al Batinah South,Barka', name: "", mobile: "",
        name1: username.toString(), mobile2: usermobile.toString(),
        state2:  useradress.toString(), actuaprice: itemamount, image: imagedata,
        totalprice: itemtotal, vat: price, discount: itemdiscount, productname: companyproductdata,
        demo: '+968 25252525', quantity: itemquantity, totalpoints: itempoints,)));*/
/*      Fluttertoast.showToast(
          msg: " Succesfully Added ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);*/
      /*print("Done"+Constants.category);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.category = widget.cat_id;
    //   await prefs.setBool('isLoggedIn', true);
    await prefs.setString("category", Constants.category);
    print("hogaya"+Constants.category);
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) =>
    VendorThankyouPage(bback:widget.cat_idd,)));*/
      setState(() {
        //  _isLoading=false;
      });
    } else {
      setState(() {
        //_isLoading=false;
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
    print("dgdg" + res!.toString());
    setState(() {
      // _isLoading=false;
    });
  }

  var couponstatus = "";
  // expireusedlist= <Map<String, dynamic>>[];
  final list1 = <Map<String, dynamic>>[];
  List<UserCouponList> Activelist = [];
  List<UserCouponList> Expirelist = [];
  // final  expireusedlist= <Map<String, String>>[];
  List<UserCouponList>? couponlisting = [];
  Future<void> couponlistmethod() async {
    Map<String, String> jsonbody = {
      "userid": Constants.user_id,
    };
    var network = NewVendorApiService();
    String urls = "http://cp.citycode.om/public/index.php/usercouponlist";
    var res = await network.postresponse(urls, jsonbody);
    var model = Couponlistingmodel.fromJson(res);
    String stat = model.status.toString();
    couponlisting = model.userCouponList!;

    couponstatus = couponlisting![index].purchaseStatus!;
    print("datastatus" + couponstatus);
    //print("coupon"+userID);
    print("userid" + Constants.user_id);
    if (!mounted) return;
    setState(() {});

    /*   final list1 = [
      ...couponlisting!
          .cast<Map<String, dynamic>>()
          .where((map) => map['purchase_status'] == '0')
    ];*/

    print(couponamount);
    print("coupon listing" + stat);

    if (stat.contains("201")) {
      List<UserCouponList> userCoupon = model.userCouponList!;
      for (var data in userCoupon) {
        if (data.purchaseStatus == 'Active') {
          Activelist.add(UserCouponList(
              id: data.id,
              userId: data.userId,
              couponId: data.couponId,
              purchaseStatus: data.purchaseStatus,
              companyId: data.companyId,
              branchId: data.branchId,
              created: data.created,
              startDate: data.startDate,
              endDate: data.endDate,
              couponName: data.couponName,
              arbCouponName: data.arbCouponName,
              couponAmount: data.couponAmount,
              couponPrice: data.couponPrice,
              couponDetails: data.couponDetails,
              arbCouponDetails: data.arbCouponDetails,
              couponQuantity: data.couponQuantity,
              status: data.status,
              companyName: data.companyName,
              picture: data.picture,
              branchName: data.branchName,
              perchaseid: data.perchaseid));
        } else {
          Expirelist.add(UserCouponList(
              id: data.id,
              userId: data.userId,
              couponId: data.couponId,
              purchaseStatus: data.purchaseStatus,
              companyId: data.companyId,
              branchId: data.branchId,
              created: data.created,
              startDate: data.startDate,
              endDate: data.endDate,
              couponName: data.couponName,
              arbCouponName: data.arbCouponName,
              couponAmount: data.couponAmount,
              couponPrice: data.couponPrice,
              couponDetails: data.couponDetails,
              arbCouponDetails: data.arbCouponDetails,
              couponQuantity: data.couponQuantity,
              status: data.status,
              companyName: data.companyName,
              picture: data.picture,
              branchName: data.branchName));
        }
      }
      print("name" + Activelist[index].id.toString());
/*
      if(couponlistdata!.isEmpty){
        setState(() {
         // _isLoading=false;
        });
        setState((){
          print("yesss");
       //   coupontype=true;

          //  couponclick=!couponclick;
        });
        Fluttertoast.showToast(
            msg: " Coupons Not Available. ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }*/
      /* Navigator.push(context, MaterialPageRoute(builder: (context)=>locationscreen(state:""'Oman, Al Batinah South,Barka', name: "", mobile: "",
        name1: username.toString(), mobile2: usermobile.toString(),
        state2:  useradress.toString(), actuaprice: itemamount, image: imagedata,
        totalprice: itemtotal, vat: price, discount: itemdiscount, productname: companyproductdata,
        demo: '+968 25252525', quantity: itemquantity, totalpoints: itempoints,)));*/
/*      Fluttertoast.showToast(
          msg: " Succesfully Added ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);*/
      /*print("Done"+Constants.category);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.category = widget.cat_id;
    //   await prefs.setBool('isLoggedIn', true);
    await prefs.setString("category", Constants.category);
    print("hogaya"+Constants.category);
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) =>
    VendorThankyouPage(bback:widget.cat_idd,)));*/
      setState(() {
        //  _isLoading=false;
      });
    } else {
      setState(() {
        // _isLoading=false;
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
    print("perchaselisting" + res!.toString());

    setState(() {
      // _isLoading=false;
    });
  }

  Widget onCoupon() {
    Color primaryColor = const Color(0xFFF2CC0F);
    return ListView.builder(
        itemCount: Expirelist.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Route route = MaterialPageRoute(
                  builder: (context) => OfferDetailsScreen(
                      Expirelist[index].companyName.toString(),
                      Expirelist[index].companyId.toString(),
                      Expirelist[index].couponAmount.toString(),
                      Constants.language == "en"
                          ? Expirelist[index].couponDetails.toString()
                          : Expirelist[index].arbCouponDetails.toString(),
                      Expirelist[index].endDate.toString(),
                      "homebutton",
                      Expirelist[index].couponName.toString(),
                      "screen",
                      "",
                      Expirelist[index].couponPrice.toString()));
              Navigator.push(context, route);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: CouponCard(
                height: 140,
                width: 600,
                backgroundColor: primaryColor,
                curveAxis: Axis.vertical,
                curvePosition: 100,

                curveRadius: 30,

                // decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),

                firstChild: Container(
                  decoration: const BoxDecoration(
                    //   borderRadius: BorderRadius.only(topLeft: Radius.circular(1)),
                    border: Border(
                      top: BorderSide(color: Colors.white),
                    ),
                  ),
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final dataqr = {
                                "status": "expire",
                              };
                              bool result = await InternetConnectionChecker()
                                  .hasConnection;
                              if (result) {
                                _showDialog(
                                    context,
                                    jsonEncode(Constants.city_code).toString(),
                                    jsonEncode(dataqr).toString(),
                                    Expirelist[index]
                                        .purchaseStatus
                                        .toString());
                                //getQrCode(context);
                              } else {}
                              // _showDialog(context,jsonEncode(Constants.city_code).toString() , "expire", Expirelist![index].purchaseStatus.toString());
                            },
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              margin: const EdgeInsets.only(
                                left: 10.0,
                                right: 1.0,
                              ),
                              child: QrImage(
                                data: "data",
                                version: QrVersions.auto,
                                size: 130,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            child: const Dash(
                                direction: Axis.vertical,
                                length: 100,
                                dashLength: 12,
                                dashThickness: 2,
                                dashColor: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                secondChild: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*   Container(

                       // margin: EdgeInsets.only(left: 50),
                        child: Center(
                            child: CircleAvatar(
                              backgroundImage: NetworkImage("images/circle_app_icon.png"),
                              radius: 20.0,
                            ),),
                      ),*/
                          Container(
                            //  margin: EdgeInsets.only(top: 1,),
                            //height:30,
                            child: Text(
                              //     Constants.language=="en"?
                              "COUPON AMOUNT: " +
                                  Expirelist[index].couponAmount.toString() +
                                  " OMR",
                              //        :"مبلغ القسيمة: " + Expirelist![index].couponAmount.toString() + " OMR",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            // Constants.language == "en"?
                            "COUPON PRICE: " +
                                Expirelist[index].couponPrice.toString() +
                                " OMR",
                            //     :"سعر القسيمة:" +Expirelist![index].couponPrice.toString()+ " OMR",
                            //   '2.000 OMR',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Spacer(),
                          const SizedBox(height: 20),
                          Text(
                            //  'EXPIRATION DATE: 30/11/2023',
                            //Constants.language == "en"?
                            "EXPIRE DATE:  " +
                                Expirelist[index].endDate.toString(),
                            //  :"تاريخ انتهاء الصلاحية:" + Expirelist![index].endDate.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expirelist[index].picture.toString().isNotEmpty
                              ? CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(companyimgurl +
                                Expirelist[index].picture.toString()),
                          )
                              : Container(
                            margin: const EdgeInsets.only(
                                top: 20, left: 0.5, bottom: 6),
                            child: const Center(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "images/circle_app_icon.png"),
                                radius: 30.0,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 2),
                            child: Text(
                              Expirelist[index].companyName.toString().length >
                                  10
                                  ? '${Expirelist[index].companyName.toString().substring(0, 10)}...'
                                  : Expirelist[index].companyName.toString(),
                              //couponlisting![index].companyName.toString(),
                              //  overflow: TextOverflow.ellipsis,

                              //   '2.000 OMR',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFF2CC0F);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      /* bottomSheet: Container(
          margin: EdgeInsets.only(left: 100),
          height: 45,
          width: 200,
          decoration: BoxDecoration(
            color: Color(0xFFF2CC0F),
            borderRadius: BorderRadius.circular(
              25.0,
            ),
          ),
          child: Center(child: Text("1 OMR",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),)),
      bottomNavigationBar:    Container(
        margin: const EdgeInsets.only(left: 10,right: 10),
        child: ElevatedButton(
          onPressed: () async {
            //  _showdialog(context,width);
            //_showDialog(context,width);
*/ /*if(_selectedGender=="male"){


}*/ /*

          },
          child: const Text(
            "Pay now",
            style: TextStyle(
                fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
              fontSize: 18.0,
            ),
          ),
          style: ElevatedButton.styleFrom(
            fixedSize: Size(width, 40.0),
            primary: const Color(0xFFF2CC0F),
            shadowColor: const Color(0xFFF2CC0F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),*/
      /*body: Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ToggleButtons(
          borderColor: Colors.black,
          fillColor: Color(0xFFF2CC0F),
          borderWidth: 2,
          selectedBorderColor: Colors.black,
          selectedColor: Colors.white,
          borderRadius: BorderRadius.circular(0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Active',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Expire',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
          onPressed: (int indexx) {
            setState(() {
              for (int i = 0; i < isSelected.length; i++) {
                isSelected[i] = i == indexx;
              }
            });
          },
          isSelected: isSelected,
        ),
        Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(100))),
            margin: EdgeInsets.only(top: 10,left: 10,right: 10),
            child: Horizontalline()),
      ],
    ),*/
      body: Directionality(
        textDirection:
        Constants.language == "en" ? TextDirection.ltr : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // give the tab bar a height [can change hheight to preferred height]
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: const Color(0xFFF2CC0F),
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    // first tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Active',
                    ),

                    // second tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Expire',
                    ),
                  ],
                ),
              ),
              // tab bar view here
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // first tab bar view widget

                    ListView.builder(
                        itemCount: Activelist.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // _showdialog(context, width);
                              Route route = MaterialPageRoute(
                                  builder: (context) => OfferDetailsScreen(
                                      Activelist[index].companyName.toString(),
                                      Activelist[index].companyId.toString(),
                                      Activelist[index].couponAmount.toString(),
                                      Constants.language == "en"
                                          ? Activelist[index]
                                          .couponDetails
                                          .toString()
                                          : Activelist[index]
                                          .arbCouponDetails
                                          .toString(),
                                      Activelist[index].endDate.toString(),
                                      "homebutton",
                                      Activelist[index].couponName.toString(),
                                      "screen",
                                      "",
                                      Activelist[index]
                                          .couponPrice
                                          .toString()));
                              Navigator.push(context, route);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: CouponCard(
                                height: 140,
                                width: 600,
                                backgroundColor: primaryColor,
                                curveAxis: Axis.vertical,
                                curvePosition: 100,

                                curveRadius: 30,

                                // decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),

                                firstChild: Container(
                                  decoration: const BoxDecoration(
                                    //   borderRadius: BorderRadius.only(topLeft: Radius.circular(1)),
                                    border: Border(
                                      top: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  width: double.maxFinite,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              final dataqr = {
                                                "citycodeqr":
                                                Constants.city_code,
                                                "couponid":
                                                couponlisting![index]
                                                    .id
                                                    .toString(),
                                                "companyid":
                                                couponlisting![index]
                                                    .companyId
                                                    .toString(),
                                                "perchasedid":
                                                couponlisting![index]
                                                    .perchaseid
                                                    .toString(),
                                                "branchid":
                                                couponlisting![index]
                                                    .branchId
                                                    .toString()
                                              };
                                              bool result =
                                              await InternetConnectionChecker()
                                                  .hasConnection;
                                              if (result) {
                                                _showDialog(
                                                    context,
                                                    jsonEncode(
                                                        Constants.city_code)
                                                        .toString(),
                                                    jsonEncode(dataqr)
                                                        .toString(),
                                                    Activelist[index]
                                                        .purchaseStatus
                                                        .toString());
                                                //getQrCode(context);
                                              } else {}
                                            },
                                            child: Container(
                                              height: 90,
                                              width: 90,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(10))),
                                              margin: const EdgeInsets.only(
                                                left: 10.0,
                                                right: 13,
                                              ),
                                              child: QrImage(
                                                data: "data",
                                                version: QrVersions.auto,
                                                size: 130,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // margin: EdgeInsets.only(left: 12),
                                            child: const Dash(
                                                direction: Axis.vertical,
                                                length: 100,
                                                dashLength: 12,
                                                dashThickness: 2,
                                                dashColor: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                secondChild: Container(
                                  width: double.maxFinite,
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            //  margin: EdgeInsets.only(top: 1,),
                                            //height:30,
                                            child: Text(
                                              //  Constants.language=="en"?
                                              "COUPON AMOUNT: " +
                                                  Activelist[index]
                                                      .couponAmount
                                                      .toString() +
                                                  " OMR",
                                              //  :"مبلغ القسيمة: " + Activelist![index].couponAmount.toString() + " OMR",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            //  Constants.language == "en"?
                                            "COUPON PRICE: " +
                                                Activelist[index]
                                                    .couponPrice
                                                    .toString() +
                                                " OMR",
                                            //   :"سعر القسيمة:" +Activelist![index].couponPrice.toString()+ " OMR",
                                            //   '2.000 OMR',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // Spacer(),
                                          const SizedBox(height: 20),
                                          Text(
                                            //  'EXPIRATION DATE: 30/11/2023',
                                            // Constants.language == "en"?
                                            "EXPIRE DATE:  " +
                                                Activelist[index]
                                                    .endDate
                                                    .toString(),
                                            // :"تاريخ انتهاء الصلاحية:" + Activelist![index].endDate.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Activelist[index]
                                              .picture
                                              .toString()
                                              .isNotEmpty
                                              ? CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                                companyimgurl +
                                                    Activelist[index]
                                                        .picture
                                                        .toString()),
                                          )
                                              : Container(
                                            margin: const EdgeInsets.only(
                                                top: 20,
                                                left: 0.5,
                                                bottom: 6),
                                            child: const Center(
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    "images/circle_app_icon.png"),
                                                radius: 30.0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin:
                                            const EdgeInsets.only(left: 2),
                                            child: Text(
                                              Activelist[index]
                                                  .companyName
                                                  .toString()
                                                  .length >
                                                  10
                                                  ? '${Activelist[index].companyName.toString().substring(0, 10)}...'
                                                  : Activelist[index]
                                                  .companyName
                                                  .toString(),
                                              //couponlisting![index].companyName.toString(),
                                              //  overflow: TextOverflow.ellipsis,

                                              //   '2.000 OMR',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),

                    // second tab bar view widget

                    onCoupon(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context, var datacode, String data, var msg) {
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
            SizedBox(
              width: 270,
              child: Text(
                Constants.language == "en"
                    ? "Your Coupon code is :"
                    : ": رمز معاملتك هو",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            /* Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                "1234",
              //  transaction_code,
                style: const TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ),*/
            Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: GestureDetector(
                onTap: () {
                  print("dataaa" + data.toString());
                },
                child: QrImage(
                  data: data,
                  version: QrVersions.auto,
                  size: 320,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Text(
                Constants.language == "en"
                    ? msg + " Coupon Code."
                    : msg + "رمز معاملتك صالح لمدة 5 دقائق فقط ",
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

  _showdialog(BuildContext context, double width) {
    Dialog dialog = Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        //this right here
        child: SizedBox(
            height: 450,
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
                                        backgroundImage: NetworkImage(
                                            companyimgurl +
                                                couponlistdata![index]
                                                    .picture
                                                    .toString()),
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
                          Constants.language == "en" ? companyname : companyname,
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
                                    ? "Coupon Name"
                                    : "Coupon Name",
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
                                couponename.toString(),
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
                                        ? "Coupon Amount"
                                        : " Coupon Amount",
                                    style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5.0),
                                    child: Text(couponamount.toString() + " OMR",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: "Roboto",
                                          //decoration: TextDecoration.lineThrough,decorationThickness: 2.85,decorationColor: Colors.red,
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
                                        Constants.language == "en"
                                            ? "Coupon Price"
                                            : "Coupon Price",
                                        style: TextStyle(
                                            fontFamily: Constants.language == "en"
                                                ? "Roboto"
                                                : "GSSFont",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          couponeprice.toString() + " OMR",
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
                                        ? "Start Date"
                                        : "Start Date",
                                    style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      startdate.toString(),
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
                                        ? "End Date"
                                        : "End Date",
                                    style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      enddate.toString(),
                                      style: const TextStyle(fontFamily: "Roboto"),
                                    ),
                                  ),
                                  /* Container(
                                        margin: const EdgeInsets.only(top: 10.0),
                                        height: 1.0,
                                        color: Colors.black,
                                      ),*/

                                  /*Text(
                                        Constants.language == "en"
                                            ?  "Total price "
                                            : "السعر النهائي",

                                        style: TextStyle(
                                            fontFamily: Constants.language == "en"
                                                ? "Roboto"
                                                : "GSSFont",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5.0),
                                        child: Text("totalwithoutcost.toString()=="0"?
                                        itemtotal:totalwithoutcost.toString()",

                                          style: TextStyle(fontFamily: "Roboto"),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10.0),
                                        height: 1.0,
                                        color: Colors.black,
                                      ),
                                      Container(
                                        margin:
                                        const EdgeInsets.only(top: 10.0,),
                                        child: Text(
                                          Constants.language == "en"
                                              ?  "Points "
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
                                          itempoints.toString(),
                                          //   total.toString(),

                                          style: TextStyle(fontFamily: "Roboto"),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10.0),
                                        height: 1.0,
                                        color: Colors.black,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _alertShow(context,"success");

                                          },
                                          child: Text(

                                            Constants.language == "en"
                                                ?  " Pay now"
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
                                            _alertDialog(
                                                "Not Available"
                                            );
                                             Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (context)=>
                                              booknow(company_name,
                                                  company_image,
                                                  sender_id,
                                                  receiver_id,
                                                  product_image,
                                                  product_details, page,
                                                  sender_image,
                                                  isuserhome,
                                                  isCompanyHome,
                                                  priceone,
                                                  pricetwo)));
                                          },
                                          child: Text(
                                            Constants.language == "en"
                                                ?  "Pay By Cash"
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
                                      ),*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]))));

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }
}
