// ignore_for_file: camel_case_types, unused_local_variable

import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class coupondetalscreen extends StatefulWidget {
  // const coupondetalscreen({Key? key}) : super(key: key);
  String compnyname,
      compantimage,
      couponamount,
      couponprice,
      expiredate,
      couponname,
      coupondescription;
  coupondetalscreen({
    Key? key,
    required this.compnyname,
    required this.compantimage,
    required this.couponamount,
    required this.couponprice,
    required this.expiredate,
    required this.couponname,
    required this.coupondescription,
  }) : super(key: key);

  @override
  State<coupondetalscreen> createState() => _coupondetalscreenState();
}

class _coupondetalscreenState extends State<coupondetalscreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF2CC0F),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFF2CC0F),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.arrow_left),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Coupon Details",
            // widget.compnyname,
            style: TextStyle(
              color: Colors.black,
              fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
            ),
          ),
          actions: const <Widget>[
            /*Visibility(
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
            ),*/
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.compantimage),
                  radius: width * 0.15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Text(
                  widget.compnyname,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    // camount=double.parse(companycoupondata![index].couponAmount!);
                    // print("datprint2"+camount.toString());
                    return InkWell(
                      onTap: () {
                        setState(() {
                          // position = index;
                          // price_page = true;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        decoration: const BoxDecoration(
                          /*border: Border.all(
                                        color: Colors.black,
                                      ),*/
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              //  padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.only(
                                  top: 10.0, left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Row(
                                children: [
                                  Container(
                                    height: 55,
                                    width: 130,

                                    decoration: BoxDecoration(
                                        color: const Color(0xFFF2CC0F),
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    // width: width,
                                    margin: const EdgeInsets.only(right: 10.0),
                                    child: Center(
                                      child: Text(
                                        Constants.language == "en"
                                            ? "Coupon Name"
                                            : "Coupon Price",
                                        style: TextStyle(
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",
                                            fontWeight: FontWeight.bold),
                                        textAlign: Constants.language == "en"
                                            ? TextAlign.left
                                            : TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    //padding: const EdgeInsets.all(10.0),
                                    margin: const EdgeInsets.only(
                                        top: 10.0,
                                        left: 10.0,
                                        right: 10.0,
                                        bottom: 10.0),
                                    decoration: const BoxDecoration(
                                        /*border: Border.all(
                                    color: Colors.black,
                                  ),*/
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(
                                      Constants.language == "en"
                                          ? widget.couponname
                                          : widget.couponname,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: width,
                              height: 200,
                              padding: const EdgeInsets.only(bottom: 10.0),
                              margin: const EdgeInsets.only(
                                  top: 10.0, left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 130,

                                        decoration: BoxDecoration(
                                            color: const Color(0xFFF2CC0F),
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                        // width: width,
                                        margin:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Center(
                                          child: Text(
                                            Constants.language == "en"
                                                ? "Coupon Details"
                                                : "Coupon Details",
                                            style: TextStyle(
                                                fontFamily:
                                                    Constants.language == "en"
                                                        ? "Roboto"
                                                        : "GSSFont",
                                                fontWeight: FontWeight.bold),
                                            textAlign:
                                                Constants.language == "en"
                                                    ? TextAlign.left
                                                    : TextAlign.right,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // width: 240,
                                        margin: const EdgeInsets.only(left: 45),
                                        child: Text(
                                          widget.couponamount + " OMR",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    //  margin: const EdgeInsets.only(top: 10.0),
                                    color: Colors.black,
                                    height: 2.0,
                                    width: width,
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        width: width,
                                        margin: const EdgeInsets.only(
                                            top: 10.0, left: 5.0, right: 5.0),
                                        child: Text(
                                          widget.coupondescription,
                                          style: TextStyle(
                                            fontFamily: Constants.lang == "en"
                                                ? "Roboto"
                                                : "GSSFont",
                                          ),
                                          textAlign: Constants.lang == "en"
                                              ? TextAlign.left
                                              : TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            /*Container(

                                          margin: const EdgeInsets.only(
                                              top: 10.0, left: 10.0, right: 10.0),
                                          decoration: BoxDecoration(
                                              color:Colors.white,
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                              borderRadius:
                                              const BorderRadius.all(Radius.circular(10))),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 130,

                                                decoration: BoxDecoration(
                                                    color: const Color(0xFFF2CC0F),
                                                    border: Border.all(
                                                      color: Colors.black,
                                                    ),
                                                    borderRadius:
                                                    const BorderRadius.all(Radius.circular(10))),
                                                // width: width,
                                                 margin: const EdgeInsets.only(
                                   right: 10.0),
                                                child: Center(
                                                  child: Text(
                                                    Constants.language == "en" ? "Coupon Price" : "Coupon Price",
                                                    style: TextStyle(
                                                        fontFamily:
                                                        Constants.language == "en" ? "Roboto" : "GSSFont",
                                                        fontWeight: FontWeight.bold),
                                                    textAlign: Constants.language == "en"
                                                        ? TextAlign.left
                                                        : TextAlign.right,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 150,
                                                padding: const EdgeInsets.all(10.0),
                                                margin: const EdgeInsets.only(
                                                    top: 10.0, left: 10.0, right: 10.0),
                                                 decoration: BoxDecoration(
                                  */ /*border: Border.all(
                                    color: Colors.black,
                                  ),*/ /*
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                                                child: Text(
                                                  companycoupondata![index].couponPrice!+" OMR",
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold, fontSize: 16.0),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),*/
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10.0,
                                  left: 10.0,
                                  right: 10.0,
                                  bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Constants.language == "en"
                                        ? "Expiration Date"
                                        : "تاريخ انتهاء العرض",
                                    style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold),
                                    textAlign: Constants.language == "en"
                                        ? TextAlign.left
                                        : TextAlign.right,
                                  ),
                                  Text(
                                    widget.expiredate,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    textAlign: Constants.language == "en"
                                        ? TextAlign.left
                                        : TextAlign.right,
                                  ),
                                ],
                              ),
                            ),
                            /*  Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius:
                                          const BorderRadius.only(
                                              topLeft:
                                              Radius.circular(10),
                                              topRight:
                                              Radius.circular(
                                                  10)),
                                          color: const Color(0xFF0F996D),
                                        ),
                                        padding:
                                        const EdgeInsets.all(10.0),
                                        width: width,
                                        child: Text(
                                          companycoupondata![index].couponName!,


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
                                        height: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius:
                                          const BorderRadius.only(
                                              bottomLeft:
                                              Radius.circular(10),
                                              bottomRight:
                                              Radius.circular(
                                                  10)),
                                          color: Colors.white,
                                        ),
                                        padding:
                                        const EdgeInsets.all(10.0),
                                        child: SingleChildScrollView(
                                          child: Text(
                                            companycoupondata![index].couponName!,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily:
                                              Constants.language == "en"
                                                  ? "Roboto"
                                                  : "GSSFont",
                                              fontSize: 14.0,
                                            ),
                                            textAlign:
                                            Constants.language == "en"
                                                ? TextAlign.left
                                                : TextAlign.right,
                                          ),
                                        ),
                                      )*/
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ));
  }
}
