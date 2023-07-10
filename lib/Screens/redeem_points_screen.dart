// ignore_for_file: must_be_immutable, non_constant_identifier_names, unused_local_variable, avoid_unnecessary_containers

import 'dart:async';
import 'dart:convert';

import 'package:city_code/Screens/member_code_screen.dart';
import 'package:city_code/Screens/scanner_screen.dart';
import 'package:city_code/Screens/upload_receipt_screen.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/redeep_points_model.dart';
import '../models/user_transaction_code_model.dart';
import 'package:http/http.dart' as http;

class RedeemPointsScreen extends StatefulWidget {
  String vip_code,
      city_code,
      user_points,
      product_base_url,
      company_base_url,
      company_image,
      user_id;
  List<RedeemProduct>? redeemProductList = [];

  RedeemPointsScreen(
      this.vip_code,
      this.city_code,
      this.user_points,
      this.product_base_url,
      this.company_base_url,
      this.redeemProductList,
      this.company_image,
      this.user_id,
      {Key? key})
      : super(key: key);

  @override
  _RedeemPointsScreenState createState() => _RedeemPointsScreenState();
}

class _RedeemPointsScreenState extends State<RedeemPointsScreen> {
  bool _isLoading = false, price_page = false, use_points = false;
  int position = 0;
  String discountedTotalAmount = "0", order_id = "", status = "";

  TextEditingController points_controller = TextEditingController();
  TextEditingController amountAfterController = TextEditingController();
  TextEditingController amountBeforeController = TextEditingController();
  TextEditingController transactionCode_controller = TextEditingController();

  late Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    if (price_page) {
      setState(() {
        price_page = false;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: price_page ? const Color(0xFFF2CC0F) : Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFF2CC0F),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.arrow_left),
            color: Colors.black,
            onPressed: () {
              if (price_page) {
                setState(() {
                  price_page = false;
                });
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            Constants.company_name,
            style: TextStyle(
              color: Colors.black,
              fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
            ),
          ),
          actions: <Widget>[
            Visibility(
              visible: !price_page,
              child: IconButton(
                onPressed: () {
                  Route newRoute = MaterialPageRoute(
                      builder: (context) => const MemberCodeScreen());
                  Navigator.pushAndRemoveUntil(
                      context, newRoute, (route) => false);
                },
                icon: const Icon(CupertinoIcons.home),
                color: Colors.black,
              ),
            ),
            Visibility(
              visible: price_page,
              child: IconButton(
                icon: const Icon(CupertinoIcons.qrcode_viewfinder),
                color: Colors.black,
                onPressed: () {
                  _showMyDialog();
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Visibility(
                visible: !price_page,
                child: Column(
                  children: [
                    Container(
                      color: const Color(0xFFF2CC0F),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            alignment: Alignment.center,
                            child: Text(
                              Constants.language == "en"
                                  ? "Validity has been checked"
                                  : "تم التحقق من الصلاحية",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            alignment: Alignment.center,
                            child: Text(
                              widget.vip_code.isNotEmpty
                                  ? widget.vip_code
                                  : widget.city_code,
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            alignment: Constants.language == "en"
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Constants.language == "en" ? "Point" : "نقطة",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    widget.user_points,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Constants.language == "en"
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      margin: const EdgeInsets.all(10.0),
                      child: Text(
                        Constants.language == "en"
                            ? "Redeeming Points"
                            : "استبدال النقاط",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        shrinkWrap: true,
                        itemCount: widget.redeemProductList!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                amountAfterController.text = double.parse(
                                        widget.redeemProductList![index].price!)
                                    .toStringAsFixed(3);
                                points_controller.text = widget
                                    .redeemProductList![index].prRedeempoint!;
                                int points1 = int.parse(points_controller.text);
                                double amount1 =
                                    double.parse(amountAfterController.text);
                                double omr = points1 / 10;
                                double finalAmount1 = amount1 + omr;
                                if (widget.redeemProductList![index]
                                        .originalPrice!.isNotEmpty &&
                                    double.parse(widget
                                            .redeemProductList![index]
                                            .originalPrice!) >
                                        0) {
                                  amountBeforeController.text = widget
                                      .redeemProductList![index].originalPrice!;
                                } else {
                                  amountBeforeController.text =
                                      finalAmount1.toStringAsFixed(3);
                                }
                                position = index;
                                price_page = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: width / 4,
                                    height: 124,
                                    margin: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          Constants.language == "en"
                                              ? "Price"
                                              : "السعر",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(widget
                                              .redeemProductList![index]
                                              .price!),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 5.0),
                                          child: const Text("+"),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(widget
                                                  .redeemProductList![index]
                                                  .prRedeempoint! +
                                              " point"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 1.0,
                                    height: 144,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    width: width / 4,
                                    height: 124,
                                    margin: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Constants.language == "en"
                                              ? widget.redeemProductList![index]
                                                  .productName!
                                              : widget.redeemProductList![index]
                                                  .arbProductName!,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",
                                          ),
                                        ),
                                        Image(
                                          width: 100,
                                          height: 100,
                                          image: NetworkImage(
                                              widget.product_base_url +
                                                  widget
                                                      .redeemProductList![index]
                                                      .picture!),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 1.0,
                                    height: 144,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    width: width / 4,
                                    height: 124,
                                    margin: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          Constants.language == "en"
                                              ? widget.redeemProductList![index]
                                                  .companyName!
                                              : widget.redeemProductList![index]
                                                  .companyArbName!,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              widget.company_base_url +
                                                  widget
                                                      .redeemProductList![index]
                                                      .companyPicture!),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: price_page,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.vip_code.isEmpty
                                ? widget.city_code
                                : widget.vip_code,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.company_image),
                            radius: 70.0,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          alignment: Alignment.center,
                          child: Text(
                            Constants.company_name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          alignment: Alignment.center,
                          child: Text(
                            Constants.branch_name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          margin: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: width / 4,
                                height: 124,
                                margin: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      Constants.language == "en"
                                          ? "Price"
                                          : "السعر",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 5.0),
                                      child: Text(widget
                                          .redeemProductList![position].price!),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 5.0),
                                      child: const Text("+"),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 5.0),
                                      child: Text(widget
                                              .redeemProductList![position]
                                              .prRedeempoint! +
                                          " point"),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1.0,
                                height: 144,
                                color: Colors.black,
                              ),
                              Container(
                                width: width / 4,
                                height: 124,
                                margin: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Constants.language == "en"
                                          ? widget.redeemProductList![position]
                                              .productName!
                                          : widget.redeemProductList![position]
                                              .arbProductName!,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                      ),
                                    ),
                                    Image(
                                      width: 100,
                                      height: 100,
                                      image: NetworkImage(
                                          widget.product_base_url +
                                              widget
                                                  .redeemProductList![position]
                                                  .picture!),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1.0,
                                height: 144,
                                color: Colors.black,
                              ),
                              Container(
                                width: width / 5,
                                height: 124,
                                margin: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      Constants.language == "en"
                                          ? widget.redeemProductList![position]
                                              .companyName!
                                          : widget.redeemProductList![position]
                                              .companyArbName!,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          widget.company_base_url +
                                              widget
                                                  .redeemProductList![position]
                                                  .companyPicture!),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.only(top: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width * 0.60,
                                  child: TextField(
                                    readOnly: true,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: false),
                                    controller: amountBeforeController,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: Constants.language == "en"
                                          ? "Enter Amount Before Discount"
                                          : "أدخل المبلغ قبل الخصم",
                                      hintStyle: TextStyle(
                                          color: Colors.black45,
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont"),
                                    ),
                                    textAlign: Constants.language == "en"
                                        ? TextAlign.left
                                        : TextAlign.right,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Text(
                                    Constants.language == "en"
                                        ? "Total Amount"
                                        : "المبلغ الإجمالي",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          margin: const EdgeInsets.only(top: 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * 0.536,
                                child: TextField(
                                  controller: amountAfterController,
                                  readOnly: true,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: Constants.language == "en"
                                        ? "Enter Amount After Discount"
                                        : "المبلغ بعد الخصم",
                                    hintStyle: TextStyle(
                                        color: Colors.black45,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont"),
                                  ),
                                  textAlign: Constants.language == "en"
                                      ? TextAlign.left
                                      : TextAlign.right,
                                ),
                              ),
                              Container(
                                // margin: EdgeInsets.all(10),
                                /*margin: const EdgeInsets.only(
                              right: 30.0),  */ ////comment by rohan
                                child: Text(
                                  Constants.language == "en"
                                      ? "Amount to be paid"
                                      : "المبلغ الواجب دفعه   ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          margin: const EdgeInsets.only(top: 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white),
                          child: Row(
                            children: [
                              SizedBox(
                                width: width * 0.55,
                                child: TextField(
                                  readOnly: true,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: false),
                                  controller: points_controller,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: Constants.language == "en"
                                        ? "Enter Points"
                                        : "أدخل النقاط",
                                    hintStyle: TextStyle(
                                        color: Colors.black45,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont"),
                                  ),
                                  textAlign: Constants.language == "en"
                                      ? TextAlign.left
                                      : TextAlign.right,
                                ),
                              ),
                              Container(
                                //  margin: EdgeInsets.all(15),
                                /*    margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),*/ ////comment by rohan
                                child: Center(
                                  child: Text(
                                    Constants.language == "en"
                                        ? "         Deductible points"
                                        : "النقاط القابلة للخصم",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
            ],
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: price_page,
          child: Container(
            color: const Color(0xFFF2CC0F),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (price_page) {
                        setState(() {
                          price_page = false;
                        });
                      }
                    },
                    child: Text(
                      Constants.language == "en" ? "Back" : "رجوع",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontSize: 18.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2CC0F),
                      elevation: 0.0,
                      textStyle: const TextStyle(color: Colors.black),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.45, 30.0),
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
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (amountBeforeController.text.isNotEmpty) {
                        if (discountedTotalAmount.isNotEmpty) {
                          if (int.parse(points_controller.text.trim()) <=
                              int.parse(widget.user_points)) {
                            setState(() {
                              _isLoading = true;
                            });
                            bool isSuccess = await _postNotification();
                            if (isSuccess) {
                              _alertDialog(Constants.language == "en"
                                  ? "Confirmation Sent Successfully !"
                                  : "تم إرسال التأكيد بنجاح!");
                              check_status(context);
                            } else {
                              _alertDialog(Constants.language == "en"
                                  ? "Failed to send confirmation"
                                  : "فشل في إرسال التأكيد");
                            }
                          } else {
                            _alertDialog(Constants.language == "en"
                                ? "User does not have enough points"
                                : "ليس لدى المستخدم نقاط كافية");
                          }
                        }
                      } else {
                        _alertDialog(Constants.language == "en"
                            ? "Please enter total amount"
                            : "الرجاء إدخال المبلغ الإجمالي");
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: Text(
                      Constants.language == "en" ? "Done" : "تأكيد",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontSize: 18.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2CC0F),
                      elevation: 0.0,
                      textStyle: const TextStyle(color: Colors.black),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.45, 30.0),
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      Route route = MaterialPageRoute(
                          builder: (contect) => const ScannerScreen());
                      String codeSanner = await Navigator.push(context, route);
                      final scanResponsede = jsonDecode(codeSanner);
                      String od_id = scanResponsede["order_id"].toString();
                      String userid = scanResponsede["userid"].toString();
                      String usertransactioncode =
                          scanResponsede["usertransactioncode"].toString();
                      if (userid == widget.user_id) {
                        if (usertransactioncode.isNotEmpty) {
                          setState(() {
                            transactionCode_controller.text =
                                usertransactioncode;
                            status = scanResponsede["usertransactionstatus"]
                                .toString();
                          });
                        } else {
                          setState(() {
                            _isLoading = true;
                          });
                          getQrCode(context).then((value) => {
                                if (value.data != null)
                                  {
                                    setState(() {
                                      order_id = value.data!.orderId!;
                                      transactionCode_controller.text =
                                          value.data!.usertransactioncode!;
                                      _isLoading = false;
                                    }),
                                  }
                              });
                        }
                      } else {
                        _alertDialog(Constants.language == "en"
                            ? "Wrong QR code"
                            : "كود qr خاطئ");
                      }
                    },
                    child: Wrap(
                      children: [
                        const Icon(
                          CupertinoIcons.qrcode_viewfinder,
                          color: Color(0xFFF2CC0F),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            Constants.language == "en"
                                ? "Scan QR Code"
                                : "مسح كود qr",
                            style: TextStyle(
                              color: const Color(0xFFF2CC0F),
                              fontWeight: FontWeight.bold,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0.0,
                      textStyle: const TextStyle(color: Colors.black),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.45, 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Color(0xFFF2CC0F),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  Constants.language == "en" ? "OR" : "أو",
                  style: TextStyle(
                    color: const Color(0xFFF2CC0F),
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: transactionCode_controller,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: Constants.language == "en"
                          ? "Enter Transaction Code"
                          : "أدخل رمز المعاملة",
                      hintStyle: TextStyle(
                          color: Colors.black45,
                          fontFamily: Constants.language == "en"
                              ? "Roboto"
                              : "GSSFont"),
                    ),
                    textAlign: Constants.language == "en"
                        ? TextAlign.left
                        : TextAlign.right,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (transactionCode_controller.text.isNotEmpty) {
                        bool isAccepted = await _checkTransactionCode(status);
                        if (isAccepted) {
                          timer.cancel();
                          Route route = MaterialPageRoute(
                              builder: (context) => UploadReceiptScreen(
                                  widget.city_code,
                                  discountedTotalAmount,
                                  points_controller.text,
                                  order_id,
                                  widget.company_image,
                                  widget.vip_code));
                          Navigator.push(context, route);
                        }
                      } else {
                        _alertDialog(Constants.language == "en"
                            ? "Please enter transaction code"
                            : "الرجاء إدخال رمز المعاملة");
                      }
                    },
                    child: Text(
                      Constants.language == "en" ? "Submit" : "إرسال",
                      style: TextStyle(
                        color: const Color(0xFFF2CC0F),
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontSize: 18.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0.0,
                      textStyle: const TextStyle(color: Colors.black),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.45, 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Color(0xFFF2CC0F),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<UserTransactionCodeModel> getQrCode(BuildContext context) async {
    final response = await http.get(
      Uri.parse(
          'http://185.188.127.11/public/index.php/TransactionCode?userid=' +
              widget.user_id),
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
        return UserTransactionCodeModel.fromJson(json.decode(response.body));
      } else {
        setState(() {
          _isLoading = false;
        });
        _alertDialog(Constants.language == "en"
            ? "Unable to get transaction code"
            : "غير قادر على الحصول على رمز المعاملة");
        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Unable to get transaction code"
          : "غير قادر على الحصول على رمز المعاملة");
      throw Exception('Failed to load album');
    }
  }

  Future<bool> _checkTransactionCode(String status) async {
    final body = {
      "userid": widget.user_id,
      "companyid": Constants.company_id,
      "usertransactioncode": transactionCode_controller.text,
      "usertransactionstatus": status
    };

    final response = await http.post(
      Uri.parse('http://185.188.127.11/public/index.php/CheckTransactionCode'),
      body: body,
    );

    var responseServer = jsonDecode(response.body);

    if (kDebugMode) {
      print(responseServer);
    }

    if (response.statusCode == 201) {
      if (responseServer["status"] == 201) {
        return true;
      } else {
        setState(() {
          _isLoading = false;
        });
        _alertDialog(Constants.language == "en"
            ? "Invalid transaction code"
            : "رمز المعاملة غير صالح");
        return false;
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Invalid transaction code"
          : "رمز المعاملة غير صالح");
      return false;
    }
  }

  Future<bool> _postNotification() async {
    final body = {
      "userid": widget.user_id,
      "companyid": Constants.company_id,
      "branchid": Constants.branch_id,
      "discount": widget.redeemProductList![position].discountPer,
      "totalamount": amountBeforeController.text,
      "paidamount": amountAfterController.text,
      "redeempoint": points_controller.text,
      "offer_id": "",
      "notificationtype": "user",
      "product_id": widget.redeemProductList![position].id,
    };

    final response = await http.post(
      Uri.parse('http://185.188.127.11/public/index.php/notification'),
      body: body,
    );

    var responseServer = jsonDecode(response.body);

    if (kDebugMode) {
      print(responseServer);
    }

    if (response.statusCode == 200) {
      if (responseServer["status"] == 201) {
        order_id = responseServer["data"]["details"]["order_id"];
        return true;
      } else {
        setState(() {
          _isLoading = false;
        });
        return false;
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      return false;
    }
  }

  check_status(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      Route route;
      _postAcceptStatus().then((value) => {
            if (value)
              {
                timer.cancel(),
                route = MaterialPageRoute(
                    builder: (context) => UploadReceiptScreen(
                        widget.city_code,
                        amountAfterController.text,
                        points_controller.text,
                        order_id,
                        widget.company_image,
                        widget.vip_code)),
                Navigator.push(context, route),
              }
          });
    });
  }

  Future<bool> _postAcceptStatus() async {
    final body = {
      "order_id": order_id,
    };

    final response = await http.post(
      Uri.parse(
          'http://185.188.127.11/public/index.php/ApiUsers/ApiAcceptStatus'),
      body: body,
    );

    var responseServer = jsonDecode(response.body);

    if (kDebugMode) {
      print(responseServer);
    }

    if (response.statusCode == 201) {
      if (responseServer["status"] == 201) {
        return true;
      } else {
        setState(() {
          _isLoading = false;
        });
        return false;
      }
    } else {
      setState(() {
        _isLoading = false;
      });
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
