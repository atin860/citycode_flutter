// ignore_for_file: unused_import

import 'package:audioplayers/audioplayers.dart';
import 'package:city_code/Network/network.dart';
import 'package:city_code/Orders/order_details.dart';
import 'package:city_code/models/order_model.dart';

import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  final String image, branch;
  // final AudioPlayer player;

  const OrderScreen({
    Key? key,
    required this.image,
    required this.branch,
    // required this.player,
  }) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderModel? orderList;
  bool isLoading = true;
  bool isAccepted = false;

  @override
  void initState() {
    orderData();
    // log(orderList.toString() as num);
    super.initState();
  }

  @override
  void dispose() {
    // widget.player.pause(); // Pause the audio player when the screen is disposed
    super.dispose();
  }

  Future<void> orderData() async {
    setState(() {
      isLoading = true;
    });

    orderList = await Network()
        .orderReceived(Constants.company_id, Constants.branch_id);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
          Constants.language == "en" ? "Active Orders" : "Active Orders",
          style: TextStyle(
            color: Colors.black,
            fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
          ),
        ),
        actions: const [],
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: Constants.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: width * 0.15,
                          backgroundImage: NetworkImage(
                            widget.image,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        widget.branch,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : orderList != null &&
                                  orderList!.orderslist.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: orderList!.orderslist.length,
                                  itemBuilder: (context, index) {
                                    final Orderslist order =
                                        orderList!.orderslist[index];
                                    // final formattedDateTime = formatDateTime(
                                    //     order.dateTime?.toString() ?? "");

                                    return InkWell(
                                      onTap: () {
                                        //   updateOrderStatus(order.orderId,order.orderStatus);
                                        Navigator.of(context).push(
                                          FadeRoute(
                                            page: OrderDetails(
                                              // player: widget.player,
                                              order: order,
                                              orderList: orderList!.orderslist,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(top: 10.0),
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
                                              margin:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        Constants.language ==
                                                                "en"
                                                            ? "Member Code"
                                                            : "كود العضو",
                                                        style: TextStyle(
                                                          fontFamily: Constants
                                                                      .language ==
                                                                  "en"
                                                              ? "Roboto"
                                                              : "GSSFont",
                                                        ),
                                                      ),
                                                      Text(order.memberCode),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          Constants.language ==
                                                                  "en"
                                                              ? "Order ID"
                                                              : "Order ID",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                Constants.language ==
                                                                        "en"
                                                                    ? "Roboto"
                                                                    : "GSSFont",
                                                          ),
                                                        ),
                                                        Text(order.orderId),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          Constants.language ==
                                                                  "en"
                                                              ? "Paid Amount"
                                                              : "Paid Amount",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                Constants.language ==
                                                                        "en"
                                                                    ? "Roboto"
                                                                    : "GSSFont",
                                                          ),
                                                        ),
                                                        Text(order.paidAmount),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          Constants.language ==
                                                                  "en"
                                                              ? "Payment Status"
                                                              : "Address",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                Constants.language ==
                                                                        "en"
                                                                    ? "Roboto"
                                                                    : "GSSFont",
                                                          ),
                                                        ),
                                                        Text(
                                                          order.paymentStatus,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          Constants.language ==
                                                                  "en"
                                                              ? "Date & Time"
                                                              : "تاريخ",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                Constants.language ==
                                                                        "en"
                                                                    ? "Roboto"
                                                                    : "GSSFont",
                                                          ),
                                                        ),
                                                        Text(
                                                          order.dateTime != null
                                                              ? formatDateTime(
                                                                  order
                                                                      .dateTime!)
                                                              : '', // Handle null case by providing an empty string or alternative text
                                                          // Add the desired text style for the date and time
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: const Text(
                                      "No records found",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
