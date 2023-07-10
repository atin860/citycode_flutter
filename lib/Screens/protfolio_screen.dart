// ignore_for_file: non_constant_identifier_names, unnecessary_new, avoid_print, prefer_spread_collections, unused_local_variable

import 'dart:convert';

import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/couponreportsmodel.dart';
import 'package:city_code/models/portfolio_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'home_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  bool _isLoading = true;
  late Future<Portfolio_model> portfolio = _getPortfolio();
  List<Purchased_item_list>? purchaseditemlist = [];
  var total_savings = 0.000;
  List<UserCouponReport>? couponreportlist = [];
  List<UserCouponReport>? reedemreportlist = [];
  List<UserCouponReport>? Expirereportlist = [];
  List<UserCouponReport>? perchasedreportlist = [];
  List<dynamic> usedportfolio = [];
  var totalamount = "";
  var companyname = "";
  var created = "";
  String date = "";
  List<double> datar = [];
  var cal = 0.000;
  int tempindex = 0;
  var coupon_amount = "";
  var coupon_price = "";
  int tindex = 0;
  List<UserCouponReport> listofportfolio = [];
  Future<void> getreport(int index) async {
    String url = "http://cp.citycode.om/public/index.php/usercoupon?userid=" +
        Constants.user_id;
    var network = new NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = Couponreportsmodel.fromJson(res);
    var stat = vlist.status.toString();
    if (stat.contains("201")) {
      // totalamount=couponreportlist![index].couponAmount!;

      print("okkkk");
      setState(() {
        couponreportlist = vlist.userCouponReport;
      });

      for (var dataa in couponreportlist!) {
        totalamount = dataa.couponAmount.toString();
        companyname = dataa.companyName.toString();

        created = dataa.created.toString();
      }

      date = DateTime.parse(created).toString();

      for (var data in couponreportlist!) {
        /*double value=sumTwo()
        var od_amount=double.parse(data.paidamount.toString()).;
        for(int i=0;i<od_amount;i++){
          i=i+;
          print("datadost"+i.toString());
        }*/
        if (data.purchaseStatus == "Used") {
          if (data.paidamount != null) {
            datar.add(double.parse(data.paidamount.toString()));
            cal = datar.reduce((value, element) => value + element);
          }

          print("datadost" + cal.toString());
          reedemreportlist!.add(UserCouponReport(
              id: data.id,
              userId: data.userId,
              companyId: data.companyId,
              couponId: data.couponId,
              purchaseStatus: data.purchaseStatus,
              branchId: data.branchId,
              couponName: data.couponName,
              couponAmount: data.couponAmount,
              couponPrice: data.couponPrice,
              startDate: data.startDate,
              endDate: data.endDate,
              arbCouponName: data.arbCouponName,
              couponDetails: data.couponDetails,
              arbCouponDetails: data.arbCouponDetails,
              companyName: data.companyName,
              name: data.name,
              cityCode: data.cityCode,
              created: data.created,
              paidamount: data.paidamount));
          /*if(reedemreportlist!.isNotEmpty&&reedemreportlist!=null){
            for(int i=0;i<reedemreportlist!.length;i++){
              //   tempindex=i;
              coupon_amount= reedemreportlist![i].couponAmount.toString();
              coupon_price=reedemreportlist![i].couponPrice.toString();
            }
          }*/
          if (reedemreportlist != null && reedemreportlist!.isNotEmpty) {
            for (int i = 0; i < reedemreportlist!.length; i++) {
              tindex = i;
            }
          }
          coupon_amount = reedemreportlist![tindex].couponAmount.toString();
          coupon_price = reedemreportlist![tindex].couponPrice.toString();
          print("heremyvalue" + coupon_amount);
        } else if (data.purchaseStatus == "Expire") {
          Expirereportlist!.add(UserCouponReport(
            id: data.id,
            userId: data.userId,
            companyId: data.companyId,
            couponId: data.couponId,
            purchaseStatus: data.purchaseStatus,
            branchId: data.branchId,
            couponName: data.couponName,
            couponAmount: data.couponAmount,
            couponPrice: data.couponPrice,
            startDate: data.startDate,
            endDate: data.endDate,
            arbCouponName: data.arbCouponName,
            couponDetails: data.couponDetails,
            arbCouponDetails: data.arbCouponDetails,
            companyName: data.companyName,
            name: data.name,
            cityCode: data.cityCode,
          ));
        } else {
          perchasedreportlist!.add(UserCouponReport(
            id: data.id,
            userId: data.userId,
            companyId: data.companyId,
            couponId: data.couponId,
            purchaseStatus: data.purchaseStatus,
            branchId: data.branchId,
            couponName: data.couponName,
            couponAmount: data.couponAmount,
            couponPrice: data.couponPrice,
            startDate: data.startDate,
            endDate: data.endDate,
            arbCouponName: data.arbCouponName,
            couponDetails: data.couponDetails,
            arbCouponDetails: data.arbCouponDetails,
            companyName: data.companyName,
            name: data.name,
            cityCode: data.cityCode,
          ));
        }
      }
    }

    usedportfolio = []
      ..addAll(couponreportlist!)
      ..addAll(purchaseditemlist!);
    // listofportfolio= new List.from(couponreportlist!)..addAll(purchaseditemlist!);
    print("here my data1" + usedportfolio.toString());
    print(usedportfolio);

    setState(() {
      //  couponreportlist = vlist.userCouponList!;
    });
    print(reedemreportlist!.length);
    print(Expirereportlist!.length);
    print(perchasedreportlist!.length);
    print("couponreport" + res!.toString());
  }

  Future<void> datalist() async {
    var list = []
      ..addAll(couponreportlist!)
      ..addAll(purchaseditemlist!);
    // listofportfolio= new List.from(couponreportlist!)..addAll(purchaseditemlist!);
    print("here my data" + list.toString());
    // listofportfolio.addAll(Portfolio_model + UserCouponReport){

    //   }
  }

  Future<Portfolio_model> _getPortfolio() async {
    final response = await http.get(
      Uri.parse(
          'http://cp.citycode.om/public/index.php/portfolioApi?user_id= ' +
              Constants.user_id),
    );

    var response_server = jsonDecode(response.body);

    if (kDebugMode) {
      print(response_server);
    }

    if (response.statusCode == 201) {
      if (response_server["status"] == 201) {
        return Portfolio_model.fromJson(json.decode(response.body));
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
    double a = 0.0;
    portfolio.then((value) => {
          if (value.purchaseditemlist != null &&
              value.purchaseditemlist!.isNotEmpty)
            {
              setState(() {
                print("hieee");
                for (int i = 0; i < value.purchaseditemlist!.length; i++) {
                  getreport(i);
                  print(value);
                  print(purchaseditemlist!.length);
                  a = a +
                      double.parse(value.purchaseditemlist![i].savingAmount!);
                  purchaseditemlist!.add(value.purchaseditemlist![i]);
                }
                _isLoading = false;
                total_savings =
                    double.parse(cal.toString()) + double.parse(a.toString());
                //total_savings=total_savings.toStringAsFixed(3);
                print("cal" + cal.toString());
                print("total" + a.toString());
                print("totalsaving" + total_savings.toStringAsFixed(3));
              }),
            }
        });
    datalist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF2CC0F),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF2CC0F),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          Constants.language == "en" ? "My Portfolio" : "أعمالي",
          style: TextStyle(
            color: Colors.black,
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
            color: Colors.black,
          )
        ],
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: Constants.language == "en"
              ? TextDirection.ltr
              : TextDirection.ltr,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Image(image: AssetImage("images/app_icon.png")),
                    Directionality(
                      textDirection: Constants.language == "en"
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Constants.language == "en"
                                  ? "Total Savings"
                                  : "إجمالي المدخرات",
                              style: TextStyle(
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              total_savings.toStringAsFixed(3),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: purchaseditemlist!.length,
                          itemBuilder: (context, index) {
                            tempindex = index;

                            // double camount=double.parse(couponreportlist![index].couponAmount.toString());
                            double pur_amount = double.parse(
                                purchaseditemlist![index].purchaseAmount!);
                            double sav_amount = double.parse(
                                purchaseditemlist![index].savingAmount!);
                            double amount = pur_amount + sav_amount;
                            String total_amount = amount.toStringAsFixed(3);
                            String purchase_amount =
                                pur_amount.toStringAsFixed(3);
                            String saving_amount =
                                sav_amount.toStringAsFixed(3);
                            String purchased = purchase_amount + saving_amount;
                            return Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: Color(0xFFEFE7C2),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: width * 0.52,
                                    margin: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              purchaseditemlist![index]
                                                      .coupontype!
                                                      .isNotEmpty
                                                  ?
                                                  //     Constants.language == "en"
                                                  //      ?
                                                  "Coupon Amount"
                                                  //     : "مبلغ القسيمة":
                                                  //    Constants.language == "en"
                                                  //       ?
                                                  : "Total Amount",
                                              //        : "أجمالي المبلغ",
                                              style: TextStyle(
                                                  fontFamily:
                                                      Constants.language == "en"
                                                          ? "Roboto"
                                                          : "GSSFont"),
                                            ),
                                            Text(
                                              purchaseditemlist![index]
                                                      .coupontype!
                                                      .isNotEmpty
                                                  ? purchaseditemlist![index]
                                                      .couponamount
                                                      .toString()
                                                  //reedemreportlist![index].couponAmount.toString()
                                                  : total_amount,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                purchaseditemlist![index]
                                                        .coupontype!
                                                        .isNotEmpty
                                                    ?
                                                    // Constants.language == "en" ?
                                                    "Coupon price"
                                                    //   : "سعر القسيمة":
                                                    // Constants.language == "en" ?
                                                    : "Total Pay",
                                                //: "المبلغ المدفوع",
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constants.language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont"),
                                              ),
                                              Text(
                                                purchaseditemlist![index]
                                                        .coupontype!
                                                        .isNotEmpty
                                                    ? purchaseditemlist![index]
                                                        .couponprice
                                                        .toString()
                                                    :
                                                    // reedemreportlist![index].couponPrice.toString():
                                                    purchase_amount,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: purchaseditemlist![index]
                                              .coupontype!
                                              .isNotEmpty,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  //  Constants.language == "en" ?
                                                  "Purchase Amount",
                                                  //  : "إجمالي الأجر",

                                                  style: TextStyle(
                                                      fontFamily:
                                                          Constants.language ==
                                                                  "en"
                                                              ? "Roboto"
                                                              : "GSSFont"),
                                                ),
                                                Text(
                                                    //couponreportlist![index].paidamount.toString():
                                                    total_amount),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                purchaseditemlist![index]
                                                        .coupontype!
                                                        .isNotEmpty
                                                    ?
                                                    //Constants.language == "en" ?
                                                    "Total Pay"
                                                    //    : "إجمالي الأجر":
                                                    //  Constants.language == "en"?
                                                    : "Saving Amount",
                                                //     : "مبلغ الادخار",
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constants.language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont"),
                                              ),
                                              Text(
                                                purchaseditemlist![index]
                                                        .coupontype!
                                                        .isNotEmpty
                                                    ?
                                                    //couponreportlist![index].paidamount.toString():
                                                    purchase_amount
                                                    : saving_amount,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                // Constants.language == "en" ?
                                                "Points",
                                                //   : "نقاط",
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constants.language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont"),
                                              ),
                                              Text(
                                                purchaseditemlist![index]
                                                        .coupontype!
                                                        .isNotEmpty
                                                    ? "0"
                                                    : purchaseditemlist![index]
                                                        .points!,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 5.0),
                                          height: 1.0,
                                          color: Colors.black,
                                          width: width * 0.55,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                // Constants.language == "en" ?
                                                "Date",
                                                //     : "تاريخ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constants.language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont"),
                                              ),
                                              Text(
                                                purchaseditemlist![index]
                                                    .purchaseDate!,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.34,
                                    margin: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundImage: NetworkImage(
                                              purchaseditemlist![index]
                                                      .imageBaseUrl! +
                                                  purchaseditemlist![index]
                                                      .companyImage
                                                      .toString()),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(purchaseditemlist![index]
                                              .companyName
                                              .toString()),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(purchaseditemlist![index]
                                                  .branchName ??
                                              ""),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
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
