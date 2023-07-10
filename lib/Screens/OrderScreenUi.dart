// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_final_fields, unused_field, avoid_print, deprecated_member_use, unnecessary_new, avoid_unnecessary_containers, unused_local_variable, avoid_types_as_parameter_names, prefer_typing_uninitialized_variables, unused_label, unrelated_type_equality_checks, body_might_complete_normally_catch_error, dead_code, unused_element, unnecessary_brace_in_string_interps, file_names

import 'dart:async';
import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/order_list_model.dart';
//import 'package:city_code/models/new_offers_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              ":",
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
