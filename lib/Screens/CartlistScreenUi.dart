// ignore_for_file: unnecessary_null_comparison, avoid_print, unrelated_type_equality_checks, non_constant_identifier_names, unused_local_variable, prefer_typing_uninitialized_variables, unused_field, prefer_final_fields, file_names

import 'package:city_code/Screens/book_now_sceen.dart';
import 'package:city_code/models/Newclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/deletecart_model.dart';
import '../models/gETcARTLISmODEL.dart';
import '../utils/constants.dart';

class CartListScreenui extends StatefulWidget {
  const CartListScreenui({Key? key}) : super(key: key);

  @override
  _CartListScreenuiState createState() => _CartListScreenuiState();
}

class _CartListScreenuiState extends State<CartListScreenui> {
  List<CartListItem> cartList = [];
  List<CartProductItem> productList = [];
  bool _visible = true;
  bool _isLoading = true;
  String deliveryType = '';
  String fastDeliveryCharges = '';
  String spclDeliveryCharges = '';
  bool isFastDelivery = false;

  var imagebase_url = "";
  var company_image = "";
  var cartidconter = 0;
  int _itemCount = 0;
  var fluttercount = "";
  var cartamount = "0";
  var cardinit = "0";
  var cartid = "0";
  var branchid = "";
  var productid = "";
  var companyid = "";
  var discount = "";
  var price1 = "";
  var price2 = "";
  var pro;
  var cartiddata = "";
  String qty = "";
  String actualprice = "";
  String afterdiscount = "";
  String deliverycharge = "";
  String totalprice = "";
  String totalpoints = "";
  String productimage = "";
  String productname = "";
  String arbproductname = "";
  String cartqtyy = "";

  String vat = '';
  var i = 0;

  var c = 0;

  @override
  void initState() {
    super.initState();
    fetchcartList();
  }

  Future<void> deletecart(cartiddata) async {
    Map<String, String> jsonbody = {
      "userid": Constants.user_id,
      "cart_id": cartiddata,
    };
    print("useridbhai" + Constants.user_id);
    print("cradidbhai" + cartiddata);
    var network = NewVendorApiService();
    String urls = "http://185.188.127.11/public/index.php/cartremove";
    var res = await network.postresponse(urls, jsonbody);
    var deletemodel = DeletecartModel.fromJson(res);
    String stat = deletemodel.status.toString();

    print("dgdsgdsg" + stat);

    if (stat.contains("201")) {
      Fluttertoast.showToast(
        msg: "Item Deleted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      setState(() {
        _isLoading = true; // Set _isLoading to true to indicate loading state
      });

      // Refresh the cart list
      await fetchcartList();

      setState(() {
        _isLoading =
            false; // Set _isLoading back to false after refreshing the list
      });

      if (cartList.isEmpty) {
        // If the list is empty, navigate back to the previous screen
        Navigator.pop(context);
      }
    } else {
      Fluttertoast.showToast(
        msg: "Something Went Wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    print("Delete Cart" + res!.toString());
  }

  Future<void> fetchcartList() async {
    final url =
        'http://185.188.127.11/public/index.php/getcart?userid=${Constants.user_id}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse != null) {
          final cartListResponse = CartListResponse.fromJson(jsonResponse);
          setState(() {
            cartList = cartListResponse.cartList;
          });
        } else {
          throw Exception('Response body is null');
        }
      } else {
        throw Exception('Failed to fetch cart list');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2CC0F),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Visibility(
          visible: !_visible,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Visibility(
                visible: !_visible,
                child: ElevatedButton(
                  onPressed: () {
                    // transactionapi();
                    setState(() {
                      _visible = true;
                      // loading=true;
                    });
                  },
                  child: Text(
                    Constants.language == "en" ? "Back" : "Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                      fontSize: 12.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2CC0F),
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
                width: 140,
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: ElevatedButton(
                  onPressed: () async {
                    deliveryType = 'special';
                    // _getCompanyDetails(companyidlist);

                    //  await cartListsummery(companyidlist);

                    setState(() {
                      _isLoading = true;
                      isFastDelivery = false;
                      //  transactionapi();
                    });
                    // _showdialog(context, width);
                  },
                  child: Text(
                    Constants.language == "en"
                        ? "Special Delivery"
                        : "شراء مع توصيل",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                      fontSize: 15.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2CC0F),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 170,
                child: ElevatedButton(
                  onPressed: () async {
                    deliveryType = 'fast';

                    setState(() {
                      _isLoading = false;
                      isFastDelivery = true;
                    });
                    //  await cartListsummery(companyidlist);

                    //  _showdialog(context, width);
                  },
                  child: Text(
                    Constants.language == "en"
                        ? "Fast Delivery"
                        : "شراء بدون توصيل",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                      fontSize: 15.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2CC0F),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Colors.black,
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
      body: Stack(
        children: [
          Visibility(
            visible: _visible,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              margin: const EdgeInsets.only(top: 10.0),
              child: cartList.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "List is empty",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        var companytext = Constants.language == "en"
                            ? cartList[index].companyName
                            : cartList[index].companyArbName;
                        i = index;
                        print(cartList.where((e) => e.companyId == 103).length);
                        //   picture = imagebase_url +
                        String? companyImage = cartList[index].companyImage;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLoading = true;
                            });

                            setState(() {
                              productList = [];
                              productList = cartList[index]
                                  .cartProduct; // print("bjkbjkbjbjb" + c);
                              // cartList = c as List<cartListItem>;
                              //  print("datfound" + companyidlist);
                              // fetchcartList();
                              //  _getCompanyDetails(companyidlist);

                              _visible = !_visible;
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
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              children: [
                                companyImage != null && companyImage.isNotEmpty
                                    ? CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            NetworkImage(companyImage),
                                      )
                                    : const Image(
                                        image: AssetImage(
                                          "images/circle_app_icon.png",
                                        ),
                                        width: 60.0,
                                        height: 60.0,
                                      ),
                                Container(
                                  width: 220,
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        companytext,
                                        style: TextStyle(
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 500,
                                        child: Text(
                                          Constants.language == "en"
                                              ? (cartList != null &&
                                                      cartList.isNotEmpty &&
                                                      cartList[index]
                                                              .branchName !=
                                                          null)
                                                  ? cartList[index].branchName
                                                  : ''
                                              : (cartList != null &&
                                                      cartList.isNotEmpty &&
                                                      cartList[index]
                                                              .arbBranchName
                                                              .isNotEmpty ==
                                                          true)
                                                  ? cartList[index]
                                                      .arbBranchName
                                                  : (cartList != null &&
                                                          cartList.isNotEmpty &&
                                                          cartList[index]
                                                                  .branchName !=
                                                              null)
                                                      ? cartList[index]
                                                          .branchName
                                                      : '',
                                          style: TextStyle(
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Directionality(
                                  textDirection: Constants.language == "en"
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  child: Align(
                                    child: IconButton(
                                      icon: const Icon(
                                          CupertinoIcons.arrow_right),
                                      iconSize: 18.0,
                                      color: Colors.black,
                                      onPressed: () async {
                                        var data = productname = cartList[index]
                                            .productName
                                            .toString();
                                        print("dataerro" + data.toString());
                                      },
                                    ),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          Visibility(
            visible: !_visible,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              margin: const EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    var companytext = Constants.language == "en"
                        ? productList[index].productName.toString()
                        : productList[index].arbProductName;
                    productimage =
                        imagebase_url + productList[index].picture.toString();
                    productname = productList[index].productName.toString();
                    arbproductname =
                        productList[index].arbProductName.toString();
                    cartid = productList[index].cartId.toString();
                    branchid = productList[index].branchId.toString();
                    productid = productList[index].productId.toString();
                    companyid = productList[index].companyId.toString();
                    price1 =
                        productList[index].productDiscountMobile.toString();
                    price2 = productList[index].productCostMobile.toString();
                    cardinit = productList[index].cartId.toString();
                    cartqtyy = productList[index].qty.toString();
                    // print("cartjiii::" + cartid);

                    return GestureDetector(
                      onTap: () {
                        //  print("initialization" + cardinit);

                        var priceone = price1;
                        var pricetwo = price2;
                        String productname = productList[index].productName;
                        String arbproductname =
                            productList[index].arbProductName;

                        String description = productList[index].description;

                        var product_mobile =
                            productList[index].productCostMobile.toString();
                        var productdiscountmobile =
                            productList[index].productDiscountMobile.toString();

                        var companyname =
                            productList[index].companyName.toString();

                        var branchname =
                            productList[index].branchName.toString();
                        var arbbranchname =
                            productList[index].arbBranchName.toString();
                        var companyimage = company_image +
                            productList[index].companyImage.toString();

                        Route route = MaterialPageRoute(
                          builder: (context) => booknow(
                              companyname,
                              companyimage,
                              Constants.user_id,
                              branchid,
                              productimage,
                              "product_detailsdescription2description3",
                              "user",
                              "",
                              "",
                              "0",
                              "0",
                              priceone,
                              pricetwo,
                              productname,
                              description,
                              branchname,
                              arbproductname,
                              arbbranchname,
                              totalpoints,
                              productid,
                              product_mobile,
                              productdiscountmobile,
                              branchid,
                              companyid,
                              "",
                              "",
                              "",
                              productList[index].qty.toString()),
                        );
                        Navigator.push(context, route);
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            productList[index].picture.toString().isNotEmpty
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        imagebase_url +
                                            productList[index]
                                                .picture
                                                .toString()),
                                  )
                                : const Image(
                                    image: AssetImage(
                                        "images/circle_app_icon.png"),
                                    width: 40.0,
                                    height: 40.0,
                                  ),
                            Column(
                              children: [
                                Container(
                                  //color:Colors.grey,
                                  margin: const EdgeInsets.only(right: 200),

                                  //width:350,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: 150,
                                            // color:Colors.grey,
                                            margin: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text(
                                              companytext.length > 20
                                                  ? '${companytext.substring(0, 10)}...'
                                                  : companytext,
                                              style: TextStyle(
                                                  fontFamily:
                                                      Constants.language == "en"
                                                          ? "Roboto"
                                                          : "GSSFont",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                          Container(
                                            height: 30,
                                            //  margin: EdgeInsets.only(left: 70),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15))),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10,
                                                            left: 10),
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                        Icons.remove,
                                                        size: 30)),
                                                MaterialButton(
                                                  // color:   Color(0xFFE6D997),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 1),
                                                  minWidth: 10,
                                                  //     color: Color(0xFFB005BA),
                                                  shape:
                                                      const BeveledRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                    Radius.circular(5),
                                                  )),
                                                  onPressed: () {
                                                    var cartidd =
                                                        productList[index]
                                                            .cartId
                                                            .toString();
                                                    cartidconter =
                                                        cartidd as int;
                                                    print("cartdata1" + cartid);
                                                    //   print("cartdost" +
                                                    //    cartidconter);

                                                    var _itemCount =
                                                        productList[index]
                                                            .qty
                                                            .toString();
                                                    print("_itemCount" +
                                                        _itemCount);
                                                    _itemCount = _itemCount;
                                                  },
                                                  child: Text(
                                                    cartid == cartidconter
                                                        ? fluttercount
                                                            .toString()
                                                        : cartqtyy,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                IconButton(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20,
                                                            bottom: 10),
                                                    onPressed: () {},
                                                    icon: const Icon(Icons.add,
                                                        size: 30)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 74,
                                      margin: const EdgeInsets.only(
                                          right: 10, left: 1),
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Text(
                                          cartList[index]
                                              .productDiscountMobile
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationThickness: 2.85,
                                            decorationColor: Colors.red,
                                          )),
                                    ),
                                    Container(
                                      width: 90,
                                      margin:
                                          const EdgeInsets.only(right: 60.0),
                                      // margin: const EdgeInsets.only(right: 320.0),
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Text(
                                          cartList[index]
                                              .productCostMobile
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              decorationColor: Colors.red,
                                              color: Colors.green)),
                                    ),
                                    Container(
                                      margin:
                                          const EdgeInsets.only(right: 170.0),
                                      child: IconButton(
                                        icon: const Icon(
                                            CupertinoIcons.delete_solid),
                                        iconSize: 18.0,
                                        color: Colors.red,
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text(
                                                        Constants.language ==
                                                                "en"
                                                            ? 'Are you sure you want to delete this Item ?'
                                                            : "هل أنت متأكد أنك تريد حذف هذه الرسالة ؟",
                                                        style: TextStyle(
                                                          fontFamily: Constants
                                                                      .language ==
                                                                  "en"
                                                              ? "Roboto"
                                                              : "GSSFont",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text(
                                                      'NO',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text(
                                                      'YES',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    onPressed: () async {
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      //   bool isdeleted= await deletecart();
                                                      cartiddata =
                                                          productList[index]
                                                              .cartId
                                                              .toString();
                                                      print("deletekya" +
                                                          cartiddata);
                                                      var cartdada = cartiddata;
                                                      print("cartdata" +
                                                          cartdada);
                                                      deletecart(cartdada);

                                                      setState(() {
                                                        cartList
                                                            .removeAt(index);
                                                      });

                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

// ListView.builder(
//         itemCount: cartList.length,
//         itemBuilder: (context, index) {
//           final cartListItem = cartList[index];
//           return ListTile(
//             title: Text(cartListItem.productName),
//             subtitle: Text(cartListItem.companyName),
//             trailing: Text(cartListItem.originalPrice),
//             // Add more widgets to display other information as needed
//           );
//         },
//       ),

