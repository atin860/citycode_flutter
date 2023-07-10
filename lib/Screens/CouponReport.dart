// ignore_for_file: must_be_immutable, camel_case_types, file_names, non_constant_identifier_names, unnecessary_new, avoid_print, unused_local_variable

import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/couponreportsmodel.dart';

import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class couponreport extends StatefulWidget {
  //const couponreport({Key? key}) : super(key: key);
  String userid, companyimage, companyname, companyid;
  couponreport(
      {Key? key,
      required this.userid,
      required this.companyimage,
      required this.companyname,
      required this.companyid})
      : super(key: key);

  @override
  State<couponreport> createState() => _couponreportState();
}

class _couponreportState extends State<couponreport>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int index = 0;
  var totalamount = "";
  var companyname = "";
  var created = "";
  String date = "";
  List<UserCouponReport>? couponreportlist = [];
  List<UserCouponReport>? reedemreportlist = [];
  List<UserCouponReport>? Expirereportlist = [];
  List<UserCouponReport>? perchasedreportlist = [];
  List<double> datar = [];
  var cal = 0.000;
  Future<void> getreport() async {
    String url =
        "http://cp.citycode.om/public/index.php/usercoupon?companyid=" +
            widget.companyid;
    var network = new NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = Couponreportsmodel.fromJson(res);
    var stat = vlist.status.toString();
    if (stat.contains("201")) {
      // totalamount=couponreportlist![index].couponAmount!;

      print("okkkk");
      couponreportlist = vlist.userCouponReport;
      for (var dataa in couponreportlist!) {
        totalamount = dataa.couponAmount.toString();
        companyname = dataa.companyName.toString();

        created = dataa.created.toString();
      }
      date = DateTime.parse(created).toString();

      for (var data in couponreportlist!) {
        if (data.paidamount != null) {}

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

          print(cal);
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

    setState(() {
      //  couponreportlist = vlist.userCouponList!;
    });
    print(reedemreportlist!.length);
    print(Expirereportlist!.length);
    print(perchasedreportlist!.length);
    print("couponreport" + res!.toString());
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
            Constants.language == "en" ? "Coupon Report" : "تقرير القسيمة",
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
                                  ? "Total Amount"
                                  : "إجمالي المدخرات",
                              style: TextStyle(
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              cal.toStringAsFixed(3),
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
                        Container(
                          //  margin: EdgeInsets.only(bottom: 1),
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFE7C2),
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
                                color: Colors.white),
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.white,
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            tabs: const [
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
                                    // String coupondate= perchasedreportlist![index].created.toStr;
                                    //  final couponreatedby=DateTime.parse(perchasedreportlist![index].created.);
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
                                                          ? " Customer Code"
                                                          : "كود العضو",
                                                      style: TextStyle(
                                                          fontFamily: Constants
                                                                      .language ==
                                                                  "en"
                                                              ? "Roboto"
                                                              : "GSSFont"),
                                                    ),
                                                    Text(
                                                      perchasedreportlist![
                                                              index]
                                                          .cityCode!,
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
                                                        Constants.language ==
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
                                                        Constants.language ==
                                                                "en"
                                                            ? perchasedreportlist![
                                                                    index]
                                                                .couponName!
                                                            : perchasedreportlist![
                                                                    index]
                                                                .arbCouponName!,
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
                                                        Constants.language ==
                                                                "en"
                                                            ? "Coupon Amount "
                                                            : "المبلغ الإجمالي",
                                                        style: TextStyle(
                                                            fontFamily: Constants
                                                                        .language ==
                                                                    "en"
                                                                ? "Roboto"
                                                                : "GSSFont"),
                                                      ),
                                                      Text(
                                                        perchasedreportlist![
                                                                index]
                                                            .couponAmount!,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                /* Container(
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
                                                                        ? "Coupon Price"
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
                                                            ),*/
                                                /*    Container(
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
                                                                        ? "Coupon Create Date"
                                                                        : "إجمالي الأجر",
                                                                    style: TextStyle(
                                                                        fontFamily: Constants
                                                                            .language ==
                                                                            "en"
                                                                            ? "Roboto"
                                                                            : "GSSFont"),
                                                                  ),
                                                                  Text(
                                                                    date,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),*/
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
                                                        Constants.language ==
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
                                                        //couponreatedby.toString(),
                                                        couponreportlist![index]
                                                            .created!,
                                                        //perchasedreportlist![index].startDate!,
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
                                                          ? "Customer Code"
                                                          : "كود العضو",
                                                      style: TextStyle(
                                                          fontFamily: Constants
                                                                      .language ==
                                                                  "en"
                                                              ? "Roboto"
                                                              : "GSSFont"),
                                                    ),
                                                    Text(
                                                      reedemreportlist![index]
                                                          .cityCode!,
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
                                                        Constants.language ==
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
                                                        Constants.language ==
                                                                "en"
                                                            ? reedemreportlist![
                                                                    index]
                                                                .couponName
                                                                .toString()
                                                            : reedemreportlist![
                                                                    index]
                                                                .arbCouponName
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
                                                        Constants.language ==
                                                                "en"
                                                            ? "Coupon Amount"
                                                            : "المبلغ الإجمالي",
                                                        style: TextStyle(
                                                            fontFamily: Constants
                                                                        .language ==
                                                                    "en"
                                                                ? "Roboto"
                                                                : "GSSFont"),
                                                      ),
                                                      Text(
                                                        reedemreportlist![index]
                                                            .couponAmount
                                                            .toString(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                /*Container(
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
                                                                        ? "Purchase amount"
                                                                        : "المبلغ الإجمالي",
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
                                                            ),*/
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        Constants.language ==
                                                                "en"
                                                            ? "Customer Paid"
                                                            : "إجمالي الأجر",
                                                        style: TextStyle(
                                                            fontFamily: Constants
                                                                        .language ==
                                                                    "en"
                                                                ? "Roboto"
                                                                : "GSSFont"),
                                                      ),
                                                      Text(
                                                        reedemreportlist![index]
                                                            .paidamount
                                                            .toString(),
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
                                                        Constants.language ==
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
                                                        couponreportlist![index]
                                                            .created!,
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
                                                          fontFamily: Constants
                                                                      .language ==
                                                                  "en"
                                                              ? "Roboto"
                                                              : "GSSFont"),
                                                    ),
                                                    Text(
                                                      Expirereportlist![index]
                                                          .cityCode!,
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
                                                        Constants.language ==
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
                                                        Constants.language ==
                                                                "en"
                                                            ? Expirereportlist![
                                                                    index]
                                                                .couponName
                                                                .toString()
                                                            : Expirereportlist![
                                                                    index]
                                                                .arbCouponName
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
                                                        Constants.language ==
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
                                                        Expirereportlist![index]
                                                            .couponAmount
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
                                                        Constants.language ==
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
                                                        Expirereportlist![index]
                                                            .couponPrice
                                                            .toString(),
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
                                                        Constants.language ==
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
                                                        couponreportlist![index]
                                                            .created!,
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
                            ])),
                      ]))
                ]))));
  }

  @override
  void initState() {
    print("datac" + widget.companyid);
    if (couponreportlist != null && couponreportlist!.isNotEmpty) {
      for (int i = 0;
          i < couponreportlist!.length;
          couponreportlist!.length++) {
        index = i;
      }
    }
    getreport();
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }
}
