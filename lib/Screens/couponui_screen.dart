// ignore_for_file: must_be_immutable, unused_field, avoid_print, avoid_unnecessary_containers, unused_element

import 'package:city_code/Screens/offer_details_screen.dart';
import 'package:city_code/models/Newclass.dart';

import 'package:city_code/models/couponlistmodel.dart';
import 'package:city_code/utils/constants.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Horizontalline extends StatefulWidget {
  // const Horizontalline({Key? key}) : super(key: key);
  String companyid, branchid;
  Horizontalline({Key? key, required this.companyid, required this.branchid})
      : super(key: key);

  @override
  State<Horizontalline> createState() => _HorizontallineState();
}

enum Gender { first, second, third }

class _HorizontallineState extends State<Horizontalline> {
  static const Color primaryColor = Color(0xFFF2CC0F);
  static const Color secondaryColor = Color(0xff368f8b);
  Gender? _selectedGender;
  String gender = "male";
  bool newValue = false;
  bool value = false;
  ValueChanged<bool?>? onChanged;
  var coupondata = "";
  var couponamount = "";
  var couponprice = "";
  var couponcompanyname = "";
  var expiredate = "";
  int index = 0;
  bool _isLoading = true;
  var companylogo = "";
  var companyimgurl = "";
  var coupondetail = "";
  var couponstatus = "";
  List<CouponList>? couponlistdata = [];
  Future<void> couponlist() async {
    Map<String, String> jsonbody = {
      "companyid": widget.companyid,
      "branchid": widget.branchid,

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
    //coupondata=model.couponList.toString();
    companyimgurl = model.companyImageBaseUrl.toString();
    couponstatus = model.status.toString();
    /*if(couponlistdata!.isEmpty){
      setState(() {
         _isLoading=false;
      });

    }*/
    setState(() {
      _isLoading = false;
    });
    setState(() {
      couponlistdata = model.couponList;
      couponamount = couponlistdata![index].couponAmount.toString();
      expiredate = couponlistdata![index].endDate.toString();
      couponprice = couponlistdata![index].couponPrice.toString();
      couponcompanyname = couponlistdata![index].companyName.toString();
      companylogo = couponlistdata![index].picture.toString();
      coupondetail = couponlistdata![index].couponDetails.toString();
      print("couponlengthqq" + couponlistdata!.length.toString());
    });

    print(couponamount);
    print("dgdsgdsg" + stat);

    if (stat.contains("201")) {
      if (couponlistdata!.isNotEmpty) {
        /*Fluttertoast.showToast(
            msg: "  Coupons. ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);*/
      } else {
        Fluttertoast.showToast(
            msg: " No Coupons. ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }

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
        // _isLoading=false;
      });
    } else {
      Fluttertoast.showToast(
          msg: " No Coupons. ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        //  _isLoading=false;
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
    print("couponscreen" + res!.toString());
    setState(() {
      _isLoading = false;
    });
  }
  /*List<Offers>? companyinfo;
  var companyid="";
  var branchid="";
      Future<void> companylist() async {
    var network = NewVendorApiService();
    String urls =
        'http://185.188.127.11/public/index.php/ApiOffers?coupon_type=city';
    var res = await network.getresponse(urls);
    var model = Offers_model.fromJson(res);
    String stat = model.status.toString();
    coupondata = model.offers.toString();


    setState(() {
      companyinfo = model.offers;
      companyid = companyinfo![index].companyId.toString();
      branchid=companyinfo![index].branchId.toString();

    });

    couponlist();









    print(couponamount);
    print("dgdsgdsg"+stat);
    print("co"+companyid);
    print("branch"+branchid);

    if (stat.contains("201")) {
      */ /* Navigator.push(context, MaterialPageRoute(builder: (context)=>locationscreen(state:""'Oman, Al Batinah South,Barka', name: "", mobile: "",
        name1: username.toString(), mobile2: usermobile.toString(),
        state2:  useradress.toString(), actuaprice: itemamount, image: imagedata,
        totalprice: itemtotal, vat: price, discount: itemdiscount, productname: companyproductdata,
        demo: '+968 25252525', quantity: itemquantity, totalpoints: itempoints,)));*/ /*
*/ /*      Fluttertoast.showToast(
          msg: " Succesfully Added ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);*/ /*
      */ /*print("Done"+Constants.category);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.category = widget.cat_id;
    //   await prefs.setBool('isLoggedIn', true);
    await prefs.setString("category", Constants.category);
    print("hogaya"+Constants.category);
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) =>
    VendorThankyouPage(bback:widget.cat_idd,)));*/ /*
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


  }*/

  @override
  void initState() {
    print("couponlistbranch" + widget.branchid);
    print("couponlist" + widget.companyid);
    //companylist();

    couponlist();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Directionality(
            textDirection: Constants.language == "en"
                ? TextDirection.ltr
                : TextDirection.ltr,
            child: SizedBox(
              height: 400,
              child: ListView.builder(
                  itemCount: couponlistdata?.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => OfferDetailsScreen(
                                  couponlistdata![index].companyName.toString(),
                                  couponlistdata![index].companyId.toString(),
                                  couponlistdata![index]
                                      .couponAmount
                                      .toString(),
                                  Constants.language == "en"
                                      ? couponlistdata![index]
                                          .couponDetails
                                          .toString()
                                      : couponlistdata![index]
                                          .arbdetail
                                          .toString(),
                                  couponlistdata![index].endDate.toString(),
                                  "homebutton",
                                  couponlistdata![index].couponName.toString(),
                                  "",
                                  couponlistdata![index].id.toString(),
                                  couponlistdata![index]
                                      .couponPrice
                                      .toString()));
                          Navigator.push(context, route);
                        },
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
                                      onTap: () {
                                        // _showDialog(context);
                                      },
                                      child: Container(
                                        height: 90,
                                        width: 90,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
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
                                      //margin: EdgeInsets.only(left: 12,right:10),
                                      child: const Dash(
                                          direction: Axis.vertical,
                                          length: 100,
                                          dashLength: 12,
                                          dashThickness: 2,
                                          dashColor: Colors.black),
                                    ),
                                  ],
                                ),

                                /*  Container(
                            margin:  EdgeInsets.only(left: 9,right:18),
                           height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio<Gender>(
                                  activeColor: Colors.green,
                                  value: Gender.first,
                                  toggleable: true,
                                  groupValue: _selectedGender,
                                  onChanged: (Gender? value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                  },
                                ),
                                Container(
                                    margin: EdgeInsets.only(right: 1),
                                    child: Text("BUY",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),

                              */ /*  Container(
                                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                                  color: Colors.black,
                                  width: 1.0,
                                  height: 50.0,
                                ),*/ /*
                              ],
                            ),
                          )*/
                                /*Container(
                            margin:  EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(2)
                            ),
                            child: Row(
                              children: [
                                Radio<Gender>(
                                  activeColor: Colors.green,
                                  value: Gender.first,
                                  toggleable: true,
                                  groupValue: _selectedGender,
                                  onChanged: (Gender? value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                  },
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 1),
                                    child: Text("Coupons",style: TextStyle(fontSize: 9),))
                              ],
                            ),
                          ),*/
                                /*
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    '23%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'OFF',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                          const Divider(color: Colors.white54, height: 0),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'WINTER IS\nHERE',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),*/
                              ],
                            ),
                          ),

                          secondChild: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.all(1),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      //  margin: EdgeInsets.only(top: 1,),
                                      //height:30,
                                      child: Text(
                                        //   Constants.language == "en"?
                                        "COUPON AMOUNT: " +
                                            couponlistdata![index]
                                                .couponAmount
                                                .toString() +
                                            " OMR",
                                        //     : "مبلغ القسيمة: " + couponlistdata![index].couponAmount.toString() + " OMR",
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
                                          couponlistdata![index]
                                              .couponPrice
                                              .toString() +
                                          " OMR",
                                      //  :"سعر القسيمة:" +couponlistdata![index].couponPrice.toString()+ " OMR",
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
                                      //  Constants.language == "en"?
                                      "EXPIRE DATE:  " +
                                          couponlistdata![index]
                                              .endDate
                                              .toString(),
                                      //  :"تاريخ انتهاء الصلاحية:" + couponlistdata![index].endDate.toString(),
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
                                    couponlistdata![index].picture!.isNotEmpty
                                        ? CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                                companyimgurl +
                                                    couponlistdata![index]
                                                        .picture
                                                        .toString()),
                                          )
                                        : Container(
                                            margin: const EdgeInsets.only(
                                                top: 20, left: 0.1, bottom: 6),
                                            child: const Center(
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    "images/circle_app_icon.png"),
                                                radius: 29.0,
                                              ),
                                            ),
                                          ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 2),
                                      child: Text(
                                        couponlistdata![index]
                                                    .companyName
                                                    .toString()
                                                    .length >
                                                10
                                            ? '${couponlistdata![index].companyName.toString().substring(0, 10)}...'
                                            : couponlistdata![index]
                                                .companyName
                                                .toString(),
                                        // couponlistdata![index].companyName.toString(),
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
          /* SizedBox(height: 10,),
          CouponCard(
            height: 140,
            width: 600,
            backgroundColor: primaryColor,
            curveAxis: Axis.vertical,

            firstChild: Container(
              width: double.maxFinite,
              decoration: const BoxDecoration(
                color: primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      _showDialog(context);
                    },
                    child: Container(
                      margin:  EdgeInsets.only(top: 10.0, left: 1.0, right: 10.0),
                      child: QrImage(
                        data: "data",
                        version: QrVersions.auto,
                        size: 80,
                      ),
                    ),
                  ),
                  Container(
                    margin:  EdgeInsets.only(left: 9,right:18),
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio<Gender>(
                          activeColor: Colors.green,
                          value: Gender.second,
                          toggleable: true,
                          groupValue: _selectedGender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        Container(
                            margin: EdgeInsets.only(right: 2),
                            child: Text("BUY",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),

                        */ /*  Container(
                          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                          color: Colors.black,
                          width: 1.0,
                          height: 50.0,
                        ),*/ /*
                      ],
                    ),
                  )
                  */ /*Container(
                    margin:  EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(2)
                    ),
                    child: Row(
                      children: [
                        Radio<Gender>(
                          activeColor: Colors.green,
                          value: Gender.first,
                          toggleable: true,
                          groupValue: _selectedGender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 1),
                            child: Text("Coupons",style: TextStyle(fontSize: 9),))
                      ],
                    ),
                  ),*/ /*
                  */ /*
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            '23%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  const Divider(color: Colors.white54, height: 0),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'WINTER IS\nHERE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),*/ /*

                ],
              ),
            ),

            secondChild: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Center(
                    child: Text(
                      'DISCOUNT COUPON',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: 400,
                   // color: Colors.grey,
                    margin: EdgeInsets.only(right: 4,top: 5),
                    child: Text(
                      '35.000 OMR',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                       // overflow:TextOverflow.ellipsis,

                        fontSize:38 ,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),

                  Center(
                    child: Text(
                      'EXPIRATION DATE: 30/11/2023',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  _showDialog(BuildContext context) {
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
              child: QrImage(
                data: "data",
                version: QrVersions.auto,
                size: 320,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Text(
                Constants.language == "en"
                    ? "Valid Coupon Code."
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
}
