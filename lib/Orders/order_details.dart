// ignore_for_file: unnecessary_null_comparison, unused_import

import 'package:audioplayers/audioplayers.dart';
import 'package:city_code/Location/where_is_my_order.dart';
import 'package:city_code/Network/network.dart';

import 'package:city_code/models/order_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderDetails extends StatefulWidget {
  //final AudioPlayer player;
  final Orderslist order;
  final List orderList;
  const OrderDetails({
    Key? key,
    //required this.player,
    required this.order,
    required this.orderList,
  }) : super(key: key);

  @override
  State<OrderDetails> createState() => OrderDetailsState();
}

class OrderDetailsState extends State<OrderDetails> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kAppBgColor,
      bottomSheet: MaterialButton(
        elevation: 0,
        shape: const RoundedRectangleBorder(),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: isAccepted
            ? null
            : () async {
                // Check the order status before updating
                String currentStatus = widget.order.orderStatus;

                // Update the order status only if it's not already accepted
                if (currentStatus != "Accepted") {
                  await updateOrderStatus(widget.order.orderId, "Processing");
                  setState(() {
                    isAccepted = true;
                  });
                  //  widget.player.pause();
                }
              },
        height: 50,
        color: isAccepted ? Colors.grey : const Color(0xFFEFE7C2),
        child: Text(
          isAccepted ? "Accepted" : "Accept",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
          ),
        ),
      ),
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
          Constants.language == "en" ? "Order Details" : "Order Details",
          style: TextStyle(
            color: Colors.black,
            fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => const WhereIsMyOrder(),
              // ));
            },
            icon: Image.asset(
              "images/locationcity.png",
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: miscRow(
                          type: "Customer Name   :",
                          value: ' ${widget.order.customerName}',
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: miscRow(
                          type: "MemberCode        :",
                          value: ' ${widget.order.memberCode}',
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: miscRow(
                          type: "Order ID                  :",
                          value: ' ${widget.order.orderId}',
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: miscRow(
                          type: "Mobile No              :",
                          value: ' ${widget.order.memberMobileNo}',
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: kAppBgColor,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.height * 0.39,
                child: Column(
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.order != null)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.11,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6D997),
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: width * 0.80,
                                  margin: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Image.network(
                                          widget.order.productImage,
                                          width: 70,
                                          height: 70,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stacktrace) {
                                            return Image.asset(
                                              "images/citycode.png",
                                              width: 70,
                                              height: 70,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Constants.language == "en"
                                                    ? "Product Name: -  "
                                                    : "Product Name",
                                                style: TextStyle(
                                                  fontFamily:
                                                      Constants.language == "en"
                                                          ? "Roboto"
                                                          : "GSSFont",
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                Constants.language == "en"
                                                    ? widget.order.productName
                                                    : widget.order.productName,
                                                style: TextStyle(
                                                  fontFamily:
                                                      Constants.language == "en"
                                                          ? "Roboto"
                                                          : "GSSFont",
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Constants.language == "en"
                                                    ? "Quantity: -             "
                                                    : "Quantity",
                                                style: TextStyle(
                                                  fontFamily:
                                                      Constants.language == "en"
                                                          ? "Roboto"
                                                          : "GSSFont",
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                widget.order.quantity
                                                    .toString(),
                                                style: TextStyle(
                                                  fontFamily:
                                                      Constants.language == "en"
                                                          ? "Roboto"
                                                          : "GSSFont",
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Center(
                          child: Text(
                            "No records",
                            style: TextStyle(
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
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 6,
              ),
              Column(children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: miscRow(
                            type: "Paid Amount        :",
                            value: ' ${widget.order.paidAmount}',
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: miscRow(
                            type: "Payment Status   :",
                            value: ' ${widget.order.paymentStatus}',
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: miscRow(
                            type: "Order Status         :",
                            value: ' ${widget.order.orderStatus}',
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: miscRow(
                            type: "Payment Mode    :",
                            value: ' ${widget.order.paymentMode}',
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: miscRow(
                            type: "Transaction id      :",
                            value: ' ${widget.order.transactionNo}',
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: miscRow(
                            type: "Delivery Address  :       ",
                            value: ' ${widget.order.address}',
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: miscRow(
                            type: "Date & Time          :",
                            value: widget.order.dateTime != null
                                ? formatDateTime(widget.order.dateTime!)
                                : '',
                          ),
                        ),
                      ],
                    );
                  },
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle textStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
    );
  }

  Padding miscRow({required String type, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: textStyle(),
          ),
          Flexible(
            child: Text(
              value,
              style: textStyle(),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  bool isLoading = true;
  Future<void> updateOrderStatus(String orderId, String orderStatus) async {
    setState(() {
      isLoading = true;
    });
    bool success = await Network().updateOrderStatus(orderId, orderStatus);
    if (success) {
      Fluttertoast.showToast(
        msg: "Order accepted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Failed to update order status",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }

    setState(() {
      isLoading = false;
    });
  }
}
//   updateOrderStatus(String orderId) async {
//   // Show a loading indicator
//   setState(() {
//     isAccepted = true;
//   });

//   // Make the API call to update the order status
//   bool success = await Network().updateOrderStatus(orderId);

//   if (success) {
//     Fluttertoast.showToast(
//       msg: "Order accepted",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//     );
//   } else {
//     Fluttertoast.showToast(
//       msg: "Failed to update order status",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//     );
//   }

// }

