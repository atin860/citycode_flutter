// ignore_for_file: must_be_immutable, camel_case_types, non_constant_identifier_names, avoid_print, unused_local_variable

import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/companyreport_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/constants.dart';

class companyreport extends StatefulWidget {
  //const companyreport({Key? key}) : super(key: key);
  String userid, companyimage, companyname, companyid, branchid;
  companyreport(
      {Key? key,
      required this.userid,
      required this.companyimage,
      required this.companyname,
      required this.companyid,
      required this.branchid})
      : super(key: key);
  @override
  State<companyreport> createState() => _companyreportState();
}

class _companyreportState extends State<companyreport> {
  // ignore: prefer_typing_uninitialized_variables
  var CustomerCode, Totalamount, SavingAmount, TotalPay, Date;
  List<CompanyTransaction>? companyreportlist = [];

  @override
  void initState() {
    companyreport();
    super.initState();
  }

  Future<void> companyreport() async {
    Map<String, String> jsonbody = {
      "companyid": widget.companyid,
      "branchid": widget.branchid,
    };
    var network = NewVendorApiService();
    String urls =
        "http://cp.citycode.om/public/index.php/gettransactioncompany";
    var res = await network.postresponse(urls, jsonbody);
    var model = CompanyreportModel.fromJson(res);
    String stat = model.status.toString();
    //var nopopupcatID = widget.cat_id;

    print("datais here" + stat.toString());

    if (stat.contains("201")) {
      setState(() {
        companyreportlist = model.companyTransaction!;
      });

      for (var data in companyreportlist!) {
        CustomerCode = data.cityCode.toString();
        Totalamount = data.odTotalamount.toString();
        SavingAmount = data.odSaveamount.toString();
        Totalamount = data.odPaidamount.toString();
      }
    } else if (stat.contains("404")) {
      /*Fluttertoast.showToast(
          msg: "No Offer Available",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);*/
    } else {
      Fluttertoast.showToast(
          msg: "Somthing Went Wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    print("rrrss" + res!.toString());
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
            Constants.language == "en" ? "Company Report" : "تقرير القسيمة",
            style: TextStyle(
              color: Colors.black,
              fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
            ),
          ),
          actions: const <Widget>[
            /*   IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => HomeScreen("0"),
                ),
                    (route) => false,
              );
            },
            icon: Icon(CupertinoIcons.home),
            color: Colors.black,
          )*/
          ],
        ),
        body: SafeArea(
            child: Directionality(
                textDirection: Constants.language == "en"
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: Stack(children: [
                  Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Column(children: [
                        Container(
                          // color:Colors.white
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: width * 0.15,
                              backgroundImage: NetworkImage(widget.companyimage
                                  /*company_image_base_url +
                                  offerads_model[parent_index]
                                      .offersList![index]
                                      .companylogo!*/
                                  ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            widget.companyname,
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
                        const SizedBox(
                          height: 15,
                        ),
                        //Image(image: AssetImage("images/app_icon.png")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Constants.language == "en"
                                  ? "Total Earning"
                                  : "إجمالي المدخرات",
                              style: TextStyle(
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              Totalamount.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: companyreportlist!.length,
                              itemBuilder: (context, index) {
                                //double pur_amount = double.parse(purchaseditemlist![index].purchaseAmount!);
                                //double sav_amount = double.parse(purchaseditemlist![index].savingAmount!);
                                // double  amount = pur_amount + sav_amount;
                                // String total_amount = amount.toStringAsFixed(3);
                                // String purchase_amount = pur_amount.toStringAsFixed(3);
                                // String saving_amount = sav_amount.toStringAsFixed(3);
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
                                        width: width * 0.85,
                                        margin: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  Constants.language == "en"
                                                      ? "Member Code"
                                                      : "كود العضو",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          Constants.language ==
                                                                  "en"
                                                              ? "Roboto"
                                                              : "GSSFont"),
                                                ),
                                                Text(
                                                  companyreportlist![index]
                                                      .cityCode
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    Constants.language == "en"
                                                        ? "Total Amount"
                                                        : "اسم القسيمة",
                                                    style: TextStyle(
                                                        fontFamily: Constants
                                                                    .language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont"),
                                                  ),
                                                  Text(
                                                    companyreportlist![index]
                                                        .odTotalamount
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    Constants.language == "en"
                                                        ? "Saving Amount"
                                                        : "المبلغ الإجمالي",
                                                    style: TextStyle(
                                                        fontFamily: Constants
                                                                    .language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont"),
                                                  ),
                                                  Text(
                                                    companyreportlist![index]
                                                        .odSaveamount
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    Constants.language == "en"
                                                        ? "Total Pay"
                                                        : "إجمالي الأجر",
                                                    style: TextStyle(
                                                        fontFamily: Constants
                                                                    .language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont"),
                                                  ),
                                                  Text(
                                                    companyreportlist![index]
                                                        .odPaidamount
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    Constants.language == "en"
                                                        ? "Order Type"
                                                        : "Order Type",
                                                    style: TextStyle(
                                                        fontFamily: Constants
                                                                    .language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont"),
                                                  ),
                                                  Text(
                                                    index % 2 == 0
                                                        ? "Mobile"
                                                        : "Barcode",
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              height: 1.0,
                                              color: Colors.black,
                                              width: width * 0.95,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    Constants.language == "en"
                                                        ? "Date"
                                                        : "تاريخ",
                                                    style: TextStyle(
                                                        fontFamily: Constants
                                                                    .language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont"),
                                                  ),
                                                  Text(
                                                    companyreportlist![index]
                                                        .createdDate!,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      /* Container(
                                            width: width * 0.34,
                                            margin: const EdgeInsets.all(5.0),
                                            child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 35,
                                                backgroundImage: AssetImage(
                                                    "images/app_icon.png"
                                                    */ /*purchaseditemlist![index].imageBaseUrl! + purchaseditemlist![index].companyImage!*/ /*
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 5.0),
                                                child: Text("companyName"!),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 5.0),
                                                child: Text("branchName"??""),
                                              ),
                                            ],
                                            ),
                                          ),*/
                                    ],
                                  ),
                                );
                              }),
                        ),
                        /* Container(
                                  //  margin: EdgeInsets.only(bottom: 1),
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEFE7C2),
                                    // color: Colors.grey[300],
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
                                        // color: Color(0xFFF2CC0F),
                                        //color: Color(0xFFEFE7C2),
                                        color: Colors.white
                                    ),
                                    labelColor: Colors.black,
                                    unselectedLabelColor: Colors.white,
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold),
                                    tabs: [
                                      // first tab [you can add an icon using the icon property]
                                      Tab(
                                        text: 'Purchased',
                                      ),

                                      // second tab [you can add an icon using the icon property]
                                      Tab(
                                        text: 'Reedem',
                                      ),
                                      Tab(
                                        text: 'Expire',
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: TabBarView(
                                        controller: _tabController,
                                        children: [
                                          // first tab bar view widget

                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: perchasedreportlist!.length,
                                              itemBuilder: (context, index) {

                                                //double pur_amount = double.parse(purchaseditemlist![index].purchaseAmount!);
                                                //double sav_amount = double.parse(purchaseditemlist![index].savingAmount!);
                                                // double  amount = pur_amount + sav_amount;
                                                // String total_amount = amount.toStringAsFixed(3);
                                                // String purchase_amount = pur_amount.toStringAsFixed(3);
                                                // String saving_amount = sav_amount.toStringAsFixed(3);
                                                return Container(
                                                  margin: const EdgeInsets
                                                      .only(top: 10.0),
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .all(
                                                      Radius.circular(20),
                                                    ),
                                                    color: Color(0xFFEFE7C2),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: width * 0.85,
                                                        margin: const EdgeInsets
                                                            .all(10.0),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  Constants
                                                                      .language ==
                                                                      "en"
                                                                      ? "Member Code"
                                                                      : "كود العضو",
                                                                  style: TextStyle(
                                                                      fontFamily: Constants
                                                                          .language ==
                                                                          "en"
                                                                          ? "Roboto"
                                                                          : "GSSFont"),
                                                                ),
                                                                Text(
                                                                  perchasedreportlist![index].cityCode!,
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    Constants
                                                                        .language ==
                                                                        "en"
                                                                        ? "Coupon Name"
                                                                        : "اسم القسيمة",
                                                                    style: TextStyle(
                                                                        fontFamily: Constants
                                                                            .language ==
                                                                            "en"
                                                                            ? "Roboto"
                                                                            : "GSSFont"),
                                                                  ),
                                                                  Text(
                                                                    Constants.language=="en"?
                                                                    perchasedreportlist![index].couponName!:
                                                                    perchasedreportlist![index].arbCouponName!,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    Constants
                                                                        .language ==
                                                                        "en"
                                                                        ? "Total Amount"
                                                                        : "المبلغ الإجمالي",
                                                                    style: TextStyle(
                                                                        fontFamily: Constants
                                                                            .language ==
                                                                            "en"
                                                                            ? "Roboto"
                                                                            : "GSSFont"),
                                                                  ),
                                                                  Text(
                                                                    perchasedreportlist![index].couponAmount!,

                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    Constants
                                                                        .language ==
                                                                        "en"
                                                                        ? "Total Pay"
                                                                        : "إجمالي الأجر",
                                                                    style: TextStyle(
                                                                        fontFamily: Constants
                                                                            .language ==
                                                                            "en"
                                                                            ? "Roboto"
                                                                            : "GSSFont"),
                                                                  ),
                                                                  Text(
                                                                    perchasedreportlist![index].couponPrice!,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              height: 1.0,
                                                              color: Colors
                                                                  .black,
                                                              width: width *
                                                                  0.95,
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    Constants
                                                                        .language ==
                                                                        "en"
                                                                        ? "Date"
                                                                        : "تاريخ",
                                                                    style: TextStyle(
                                                                        fontFamily: Constants
                                                                            .language ==
                                                                            "en"
                                                                            ? "Roboto"
                                                                            : "GSSFont"),
                                                                  ),
                                                                  Text(
                                                                    perchasedreportlist![index].startDate!,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      */ /* Container(
                                          width: width * 0.34,
                                          margin: const EdgeInsets.all(5.0),
                                          child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 35,
                                              backgroundImage: AssetImage(
                                                  "images/app_icon.png"
                                                  */ /* */ /*purchaseditemlist![index].imageBaseUrl! + purchaseditemlist![index].companyImage!*/ /* */ /*
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 5.0),
                                              child: Text("companyName"!),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 5.0),
                                              child: Text("branchName"??""),
                                            ),
                                          ],
                                          ),
                                        ),*/ /*
                                                    ],
                                                  ),
                                                );
                                              }),

                                          // second tab bar view widget

                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: reedemreportlist!.length,
                                              itemBuilder: (context, index) {
                                                //double pur_amount = double.parse(purchaseditemlist![index].purchaseAmount!);
                                                //double sav_amount = double.parse(purchaseditemlist![index].savingAmount!);
                                                // double  amount = pur_amount + sav_amount;
                                                // String total_amount = amount.toStringAsFixed(3);
                                                // String purchase_amount = pur_amount.toStringAsFixed(3);
                                                // String saving_amount = sav_amount.toStringAsFixed(3);
                                                return Container(
                                                  margin: const EdgeInsets
                                                      .only(top: 10.0),
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .all(
                                                      Radius.circular(20),
                                                    ),
                                                    color: Color(0xFFEFE7C2),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: width * 0.85,
                                                        margin: const EdgeInsets
                                                            .all(10.0),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  Constants
                                                                      .language ==
                                                                      "en"
                                                                      ? "Member Code"
                                                                      : "كود العضو",
                                                                  style: TextStyle(
                                                                      fontFamily: Constants
                                                                          .language ==
                                                                          "en"
                                                                          ? "Roboto"
                                                                          : "GSSFont"),
                                                                ),
                                                                Text(
                                                                  reedemreportlist![index].cityCode!,
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    Constants
                                                                        .language ==
                                                                        "en"
                                                                        ? "Coupon Name"
                                                                        : "اسم القسيمة",
                                                                    style: TextStyle(
                                                                        fontFamily: Constants
                                                                            .language ==
                                                                            "en"
                                                                            ? "Roboto"
                                                                            : "GSSFont"),
                                                                  ),
                                                                  Text(
                                                                    Constants.language=="en"?
                                                                    reedemreportlist![index].couponName.toString():
                                                                    reedemreportlist![index].arbCouponName.toString(),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    Constants
                                                                        .language ==
                                                                        "en"
                                                                        ? "Total Amount"
                                                                        : "المبلغ الإجمالي",
                                                                    style: TextStyle(
                                                                        fontFamily: Constants
                                                                            .language ==
                                                                            "en"
                                                                            ? "Roboto"
                                                                            : "GSSFont"),
                                                                  ),
                                                                  Text(
                                                                    reedemreportlist![index].couponAmount.toString(),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    Constants
                                                                        .language ==
                                                                        "en"
                                                                        ? "Total Pay"
                                                                        : "إجمالي الأجر",
                                                                    style: TextStyle(
                                                                        fontFamily: Constants
                                                                            .language ==
                                                                            "en"
                                                                            ? "Roboto"
                                                                            : "GSSFont"),
                                                                  ),
                                                                  Text(
                                                                    reedemreportlist![index].couponPrice.toString(),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              height: 1.0,
                                                              color: Colors
                                                                  .black,
                                                              width: width *
                                                                  0.95,
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    Constants
                                                                        .language ==
                                                                        "en"
                                                                        ? "Date"
                                                                        : "تاريخ",
                                                                    style: TextStyle(
                                                                        fontFamily: Constants
                                                                            .language ==
                                                                            "en"
                                                                            ? "Roboto"
                                                                            : "GSSFont"),
                                                                  ),
                                                                  Text(
                                                                    reedemreportlist![index].startDate.toString(),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      */ /* Container(
                                          width: width * 0.34,
                                          margin: const EdgeInsets.all(5.0),
                                          child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 35,
                                              backgroundImage: AssetImage(
                                                  "images/app_icon.png"
                                                  */ /* */ /*purchaseditemlist![index].imageBaseUrl! + purchaseditemlist![index].companyImage!*/ /* */ /*
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 5.0),
                                              child: Text("companyName"!),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 5.0),
                                              child: Text("branchName"??""),
                                            ),
                                          ],
                                          ),
                                        ),*/ /*
                                                    ],
                                                  ),
                                                );
                                              }),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: Expirereportlist!.length,
                                              itemBuilder: (context, index) {
                                                //double pur_amount = double.parse(purchaseditemlist![index].purchaseAmount!);
                                                //double sav_amount = double.parse(purchaseditemlist![index].savingAmount!);
                                                // double  amount = pur_amount + sav_amount;
                                                // String total_amount = amount.toStringAsFixed(3);
                                                // String purchase_amount = pur_amount.toStringAsFixed(3);
                                                // String saving_amount = sav_amount.toStringAsFixed(3);
                                                return Container(
                                                  margin: const EdgeInsets
                                                      .only(top: 10.0),
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .all(
                                                      Radius.circular(20),
                                                    ),
                                                    color: Color(0xFFEFE7C2),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: width * 0.85,
                                                        margin: const EdgeInsets
                                                            .all(10.0),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  Constants
                                                                      .language ==
                                                                      "en"
                                                                      ? "Member Code"
                                                                      : "كود العضو",
                                                                  style: TextStyle(
                                                                      fontFamily: Constants
                                                                          .language ==
                                                                          "en"
                                                                          ? "Roboto"
                                                                          : "GSSFont"),
                                                                ),
                                                                Text(
                                                                  Expirereportlist![index].cityCode!,
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    Constants
                                                                        .language ==
                                                                        "en"
                                                                        ? "Coupon Name"
                                                                        : "اسم القسيمة",
                                                                    style: TextStyle(
                                                                        fontFamily: Constants
                                                                            .language ==
                                                                            "en"
                                                                            ? "Roboto"
                                                                            : "GSSFont"),
                                                                  ),
                                                                  Text(
                                                                    Constants.language=="en"?
                                                                    Expirereportlist![index].couponName.toString():
                                                                    Expirereportlist![index].arbCouponName.toString(),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    Constants
                                                                        .language ==
                                                                        "en"
                                                                        ? "Total Amount"
                                                                        : "المبلغ الإجمالي",
                                                                    style: TextStyle(
                                                                        fontFamily: Constants
                                                                            .language ==
                                                                            "en"
                                                                            ? "Roboto"
                                                                            : "GSSFont"),
                                                                  ),
                                                                  Text(
                                                                    Expirereportlist![index].couponAmount.toString(),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    Constants
                                                                        .language ==
                                                                        "en"
                                                                        ? "Total Pay"
                                                                        : "إجمالي الأجر",
                                                                    style: TextStyle(
                                                                        fontFamily: Constants
                                                                            .language ==
                                                                            "en"
                                                                            ? "Roboto"
                                                                            : "GSSFont"),
                                                                  ),
                                                                  Text(
                                                                    Expirereportlist![index].couponPrice.toString(),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              height: 1.0,
                                                              color: Colors
                                                                  .black,
                                                              width: width *
                                                                  0.95,
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    Constants
                                                                        .language ==
                                                                        "en"
                                                                        ? "Date"
                                                                        : "تاريخ",
                                                                    style: TextStyle(
                                                                        fontFamily: Constants
                                                                            .language ==
                                                                            "en"
                                                                            ? "Roboto"
                                                                            : "GSSFont"),
                                                                  ),
                                                                  Text(
                                                                    Expirereportlist![index].startDate.toString(),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      */ /* Container(
                                          width: width * 0.34,
                                          margin: const EdgeInsets.all(5.0),
                                          child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 35,
                                              backgroundImage: AssetImage(
                                                  "images/app_icon.png"
                                                  */ /* */ /*purchaseditemlist![index].imageBaseUrl! + purchaseditemlist![index].companyImage!*/ /* */ /*
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 5.0),
                                              child: Text("companyName"!),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 5.0),
                                              child: Text("branchName"??""),
                                            ),
                                          ],
                                          ),
                                        ),*/ /*
                                                    ],
                                                  ),
                                                );
                                              }),

                                        ])),*/
                      ]))
                ]))));
  }
}
