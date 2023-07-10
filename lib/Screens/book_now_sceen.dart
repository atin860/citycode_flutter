// ignore_for_file: non_constant_identifier_names, must_be_immutable, camel_case_types, unused_field, prefer_final_fields, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable, unnecessary_null_comparison, prefer_if_null_operators, dead_code, unused_import, unused_element

import 'dart:developer';

import 'package:badges/badges.dart' as badge;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:city_code/Network/network.dart';
import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/Screens/location_screen.dart';
import 'package:city_code/main.dart';
import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/Transactionapimodel.dart';
import 'package:city_code/models/company_details_model_1.dart';
import 'package:city_code/models/company_products_model.dart';
import 'package:city_code/models/qaunttymodel.dart';
import 'package:city_code/models/savecartmodel.dart';
import 'package:city_code/models/savedatamodel.dart';
import 'package:city_code/utils/constants.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/company_list_model.dart';
import 'package:http/http.dart' as http;

class booknow extends StatefulWidget {
  // const booknow({Key? key}) : super(key: key);
  String company_name,
      cartid,
      company_image,
      sender_id,
      receiver_id,
      product_image,
      product_details,
      page,
      sender_image,
      isuserhome,
      isCompanyHome,
      priceone,
      pricetwo,
      productname,
      description,
      branchname,
      arbproductname,
      arbbranchname,
      points,
      pruducrid,
      prodictmobcost,
      productmobdiscont,
      branchid,
      companyid,
      discountpr,
      qty,
      fastDeliveryCharges,
      specialDeliveryCharges;
  booknow(
      this.cartid,
      this.company_name,
      this.company_image,
      this.sender_id,
      this.receiver_id,
      this.product_image,
      this.product_details,
      this.page,
      this.sender_image,
      this.isuserhome,
      this.isCompanyHome,
      this.priceone,
      this.pricetwo,
      this.productname,
      this.description,
      this.branchname,
      this.arbproductname,
      this.arbbranchname,
      this.points,
      this.pruducrid,
      this.prodictmobcost,
      this.productmobdiscont,
      this.branchid,
      this.companyid,
      this.discountpr,
      this.fastDeliveryCharges,
      this.specialDeliveryCharges,
      this.qty,
      {Key? key})
      : super(key: key);
  @override
  State<booknow> createState() => _booknowState();
}

class _booknowState extends State<booknow> {
  String fastDeliveryCharges = '';
  String spclDeliveryCharges = '';
  int quantity = 1;
  bool _purchased = false;
  int addedProductsCount = 0;

  int _currentPosition = 0;

  List<CompanyBanner>? companyBannerList = [];
  String imageBaseUrl = "";
  bool _visible = false;
  bool _delvery = false;
  late String vatamount;
  var vat = 1.05;
  //List<Productlist>? productlist = [];
  List<Userlist>? userlist = [];
  var cartitem = "0";
  var c;
  var price;
  var total;
  var vat1;
  var delvery = 2.000;
  var totalbycash;
  var actualdata,
      afterdata,
      totalpoints,
      imagedata,
      companyproductdata,
      vatdata;
  String product_image_base_url = "";
  final GlobalKey _scaffoldKey = GlobalKey();
  late Route newRoute1, newRoute2;
  int _itemCount = 1;
  late FocusNode vipFocusNode = FocusNode();
  TextInputType inputType = TextInputType.text;
  TextEditingController vip_code_controller = TextEditingController();
  var itemamount;
  var itemdiscount;
  var itemtotal;
  var itemquantity;
  var itempoints;
  var itemdeliver;
  var itemvat;
  var itemid;
  var discount;
  var mobcost;
  var mobdiscount;
  var totalcost;
  var totalwithoutcost;
  var aferdiswithdilcharge;
  var avat;
  var cartid;

  int cartno = 0;
  bool loading = false;
  bool _isLoading = true;

  final List<String> one = [
    '1',
    '2',
  ];
  var _oneValue = '';

  Future<CompanyDetailsModel1?> _getCompanyDetails(String id) async {
    CompanyDetailsModel1? companyDetailsModel;
    final response = await http.get(
      Uri.parse('http://185.188.127.11/public/index.php/ApiCompany/$id'),
    );
    if (response.statusCode == 200) {
      companyDetailsModel = companyDetailsModel1FromJson(response.body);
      var data = companyDetailsModel.companyBranch;
      // if (data != null) {
      widget.fastDeliveryCharges = data[0].fastDeliveryCharges;
      widget.specialDeliveryCharges = data[0].specialDeliveryCharges;
      // }
    } else {
      throw Exception(response.statusCode.toString());
    }
    setState(() {});
    return companyDetailsModel;
  }

  String deliveryCharge = '';
  Future<void> savedata() async {
    Map<String, String> jsonbody = {
      "userid": Constants.user_id,
      "qty": itemquantity,
      "product_id": widget.pruducrid,
      "branch_id": widget.branchid,
      "company_id": widget.companyid,
      "actual_price": itemamount,
      "afterdiscount_price": itemdiscount,
      "discount": discount,
      "total_amount": itemtotal,
    };

    var network = NewVendorApiService();
    String urls = "http://cp.citycode.om/public/index.php/ordersave";
    var res = await network.postresponse(urls, jsonbody);
    var model = Savedatamodel.fromJson(res);
    String stat = model.status.toString();
    //var nopopupcatID = widget.cat_id;

    print("savedata" + stat);

    if (stat.contains("201")) {
      setState(() {
        addedProductsCount++;
      });

      Fluttertoast.showToast(
          msg: " Succesfully Added ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
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
    print("" + res!.toString());
  }

  List<Productlist>? imagelist = [];
  var imageone = "";
  var imagetwo = "";
  var imagethree = "";
  int index = 0;
  var imageurl = "";
  List<String> carouselList = [];
  Future<void> getproductdata() async {
    String url =
        "http://185.188.127.11/public/index.php/companyproduct?company_id=${widget.companyid}&show_inredeem=0&branch_id=${widget.branchid}&discount_offer=${widget.discountpr}";
    var network = NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = CompanyProductsModel.fromJson(res);

    setState(() {
      carouselList.add(widget.product_image);
      imagelist = vlist.productlist;
      imageurl = vlist.productImageBaseUrl!;
      imageone = imagelist![index].imageone!;
      imagetwo = imagelist![index].imagetwo!;
      imagethree = imagelist![index].imagethree!;
      print("imagebhai" + imagethree.toString());
      if (imageone.isNotEmpty) {
        carouselList.add(imageurl + imageone);
      }
      if (imagetwo.isNotEmpty) {
        carouselList.add(imageurl + imagetwo);
      }
      if (imagethree.isNotEmpty) {
        carouselList.add(imageurl + imagethree);
      }
    });

    print("productdata" + res!.toString());
  }

  Future<bool> saveCart() async {
    Map<String, String> jsonBody = {
      "userid": Constants.user_id,
      "company_id": widget.companyid,
      "branch_id": widget.branchid,
      "product_id": widget.pruducrid,
      "qty": _itemCount.toString(),
      "opration": "add",
    };

    var network = NewVendorApiService();
    String url = "http://185.188.127.11/public/index.php/addcart";
    var response = await network.postresponse(url, jsonBody);
    var model = response;
    String status = model['status'].toString();

    if (status.contains("201")) {
      // setState(() {
      //   addedProductsCount++;
      // });

      Fluttertoast.showToast(
        msg: "Item Added To Cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Call the incrementAddedProductsCount method here

      return true;
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

    setState(() {
      loading = false;
    });

    return false;
  }

  void incrementAddedProductsCount() {
    setState(() {
      addedProductsCount++;
    });
  }

  // Future<void> editQuantity(String cartId, String quantity) async {
  //   Map<String, String> jsonBody = {
  //     "cartid": cartId,
  //     "Quantity": quantity,
  //   };

  //   var network = NewVendorApiService();
  //   String url = "http://cp.citycode.om/public/index.php/editquantity";
  //   var response = await network.postresponse(url, jsonBody);
  //   var model = QuantityModel.fromJson(response);
  //   int? status = model.status;

  //   if (status == 201) {
  //     log("hi i am here ");
  //     setState(() {
  //       _isLoading = false;
  //     });

  //     Fluttertoast.showToast(
  //       msg: "Item updated",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );

  //     // Access the updated quantity data
  //     var qtyData = model.qtyData;
  //     String? updatedCost = qtyData?.productCostMobile;
  //     String? updatedDiscount = qtyData?.productDiscountMobile;
  //     String? updatedQuantity = qtyData?.qty;

  //     // ignore: todo
  // ignore: todo
  //     // TODO: Update the UI with the updated quantity data
  //   } else {
  //     setState(() {
  //       _isLoading = false;
  //     });

  //     Fluttertoast.showToast(
  //       msg: "Failed to update item",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //   }
  // }

  _alertShow(BuildContext context, String type) {
    CoolAlert.show(
      backgroundColor: const Color(0xFFF2CC0F),
      context: context,
      type: type == "success" ? CoolAlertType.success : CoolAlertType.error,
      text: type == "success"
          ? Constants.language == "en"
              ? "Online Payment"
              : "تم ارسال الرسالة"
          : Constants.language == "en"
              ? "Message not sent"
              : "لم يتم إرسال الرسالة",
      confirmBtnText: Constants.language == "en" ? "Success" : "أستمرار",
      cancelBtnText: Constants.language == "en" ? "Not Success" : "أستمرار",
      barrierDismissible: true,
      confirmBtnColor: const Color(0xFFF2CC0F),
      confirmBtnTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont"),
      cancelBtnTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont"),
      onConfirmBtnTap: () {
        if (type == "success") {
          savedata();
          //  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen("0")));
          Navigator.of(context, rootNavigator: true).pop();
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Future<void> transactionapi(String deliverycharge) async {
    Map<String, String> jsonbody = {
      "userid": Constants.user_id,
      "qty": _itemCount.toString(),
      "product_id": widget.pruducrid,
      "branch_id": widget.branchid,
      "company_id": widget.companyid,
      "delivery_charge": deliverycharge,

//       userid:780
// product_id:1002
// branch_id:131,133
// qty:3
// delivery_charge:
    };
    print("deliverycharge $deliverycharge");

    var network = NewVendorApiService();
    String urls = "http://cp.citycode.om/public/index.php/getprice";
    var res = await network.postresponse(urls, jsonbody);
    var model = Transactionapimodel.fromJson(res);
    String stat = model.status.toString();
    //var nopopupcatID = widget.cat_id;
    itemamount = model.listData.actualPrice.toString();
    itemdiscount = model.listData.afterdiscountPlusDeliveryCharge.toString();
    var ordcharge = "1.2";
    // itemdiscount=itemdiscount+ordcharge;
    itemtotal = model.listData.total.toString();
    itemquantity = model.listData.quantity.toString();
    itempoints = model.listData.point.toString();
    // itemdeliver = model.listData.deliveryChargeFast.toString();
    itemvat = model.listData.supliervatCharges.toString();
    itemid = model.listData.productId.toString();
    discount = model.listData.discount.toString();
    mobcost = model.listData.productCostMobile.toString();
    mobdiscount = model.listData.productDiscountMobile.toString();
    totalcost = model.listData.total.toString();
    totalwithoutcost = model.listData.discount.toString();
    // aferdiswithdilcharge =
    //     model.listData.afterdiscount_plus_delivery_charge.toString();
    avat = model.listData.afterdiscountPlusDeliveryChargeVat.toString();
    print("rrr" + totalwithoutcost);
    print("userid" + Constants.user_id);
    print("qaty" + _itemCount.toString());
    print("priduct" + widget.pruducrid);
    print("branchid" + widget.branchid);
    print("company id" + widget.companyid);

    itemdiscount = itemdiscount.toString() == null
        ? widget.pricetwo.toString()
        : itemdiscount.toString();

    print("dgdsgdsg" + stat);

    if (stat.contains("201")) {
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
    print("dgdg" + res!.toString());
    setState(() {
      loading = false;
    });
  }

  // Future<bool> saveCartt() async {
  //   Map<String, String> jsonBody = {
  //     "userid": Constants.user_id,
  //     "quantity": _itemCount.toString(),
  //     "productid": widget.pruducrid,
  //     "branchid": widget.branchid,
  //     "companyid": widget.companyid,
  //   };

  //   var network = NewVendorApiService();
  //   String url = "http://cp.citycode.om/public/index.php/cartsave";
  //   var response = await network.postresponse(url, jsonBody);
  //   var model = response;
  //   String status = model['status'].toString();

  //   if (status.contains("201")) {
  //     setState(() {
  //       // addedProductsCount++;
  //     });

  //     Fluttertoast.showToast(
  //       msg: "Item Added To Cart",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );

  //     return true;
  //   } else {
  //     Fluttertoast.showToast(
  //       msg: "Something Went Wrong",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //   }

  //   setState(() {
  //     loading = false;
  //   });

  //   return false;
  // }

  Future<bool> _onBackPressed() async {
    if (widget.isuserhome == "1") {
      Navigator.of(context).pushAndRemoveUntil(newRoute1, (route) => false);
    } else if (widget.isCompanyHome == "1") {
      Navigator.of(context).pushAndRemoveUntil(newRoute2, (route) => false);
    }
    return true;
  }

  // get index => 0;
  @override
  Widget build(BuildContext context) {
    actualdata = widget.priceone.toString();
    afterdata = widget.pricetwo.toString();
    totalpoints = widget.points.toString();
    imagedata = widget.product_image.toString();
    companyproductdata = widget.productname.toString();

    c = (double.parse(widget.pricetwo) * double.parse(vat.toString()));
    vat1 = (double.parse(widget.pricetwo) * double.parse(vat.toString()));
    price = (c - double.parse(widget.pricetwo)).toStringAsFixed(3);
    //price=double.parse(price).toStringAsFixed(3);
    total = (double.parse(c.toString()) + double.parse(delvery.toString()))
        .toStringAsFixed(3);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool _buyNowClicked = false;
    return WillPopScope(
      onWillPop: () async {
        if (_buyNowClicked) {
          setState(() {
            _visible = true;
            _delvery = true;
            _buyNowClicked = false;
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: const Color(0xFFF2CC0F),
            leading: IconButton(
              icon: const Icon(CupertinoIcons.arrow_left),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.company_image),
                  radius: 20.0,
                ),
                // Container(
                //   margin: const EdgeInsets.only(left: 10.0),
                //   child: Text(
                //     widget.company_name,
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontWeight: FontWeight.bold,
                //       fontFamily:
                //           Constants.language == "en" ? "Roboto" : "GSSFont",
                //     ),
                //   ),
                // ),
                Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => locationscreen(
                                      state: "" 'Oman, Al Batinah South,Barka',
                                      name: "",
                                      mobile: "",
                                      name1: "username.toString()",
                                      mobile2: "usermobile.toString()",
                                      state2: "useradress.toString()",
                                      actuaprice: "itemamount",
                                      image: "imagedata",
                                      totalprice: "itemtotal",
                                      vat: "itemvat",
                                      discount: "itemdiscount",
                                      productname: "companyproductdata",
                                      demo: '',
                                      quantity: "itemquantity",
                                      totalpoints: "itempoints",
                                      dilivery: "itemdeliver",
                                      itemdiscount: "discount",
                                      productid: "itemid",
                                      mobilecost: "mobcost",
                                      mobilediscouunt: "mobdiscount",
                                      mobtotal: "totalcost",
                                      del: '',
                                      type: '2',
                                    )));
                      },
                      child: Row(children: [
                        Text(
                          widget.company_name,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont",
                          ),
                        )
                      ]),
                      // child: Text(
                      //   'Delivering to ' + Constants.nameOfusers,
                      //   style: TextStyle(
                      //       //overflow:TextOverflow.ellipsis,
                      //       fontFamily: Constants.language == "en"
                      //           ? "Roboto"
                      //           : "GSSFont",
                      //       color: Colors.black,
                      //       fontSize: 15),
                      // ),
                    )),
              ],
              /*  actions:[
          IconButton(onPressed: (){}, icon: Icon(Icons.card_travel)
       ]*/
            ),
            actions: const [
              // Container(
              //   margin: const EdgeInsets.only(
              //     right: 12.0,
              //     top: 8.0,
              //     bottom: 5.0,
              //     left: 12.0,
              //   ),
              //   child: badge.Badge(
              //     shape: badge.BadgeShape.square,
              //     showBadge: addedProductsCount > 0 && !_purchased,
              //     badgeContent: Text(
              //       addedProductsCount.toString(),
              //       style: const TextStyle(color: Colors.white),
              //     ),
              //     child: InkWell(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => HomeScreen(
              //               "0",
              //               "cartbook",
              //             ),
              //           ),
              //         );
              //       },
              //       child: const Image(
              //         image: AssetImage("images/Cart.png"),
              //         width: 30.0,
              //         height: 30.0,
              //       ),
              //     ),
              //   ),
              // ),
            ]),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  CarouselSlider(
                    items: carouselList
                        .map(
                          (e) => Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                color: Colors.white,
                                width: width,
                                height: 300,
                                margin: const EdgeInsets.only(
                                    top: 10.0, left: 10.0, right: 10.0),
                                child: InteractiveViewer(
                                  panEnabled: false, // Set it to false
                                  boundaryMargin: const EdgeInsets.all(100),
                                  minScale: 0.5,
                                  maxScale: 2,
                                  child: PhotoView(
                                    backgroundDecoration: const BoxDecoration(
                                        color: Colors.white),
                                    imageProvider:
                                        NetworkImage(widget.product_image),
                                    minScale: 0.3,
                                    basePosition: Alignment.center,
                                    // initialScale: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                      height: 300.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  ),
                  Positioned(
                      top: 40,
                      right: 58,
                      child: Image.asset(
                        "images/fullscreen.png",
                        width: 20,
                        height: 20,
                      )),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 10.0, top: 5),
                child: Text(
                  Constants.language == "en"
                      ? widget.productname
                      : widget.arbproductname,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  //color: Colors.red,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Directionality(
                    textDirection: Constants.language == "en"
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.4),
                        1: FlexColumnWidth(0.5),
                        2: FlexColumnWidth(2),
                      },
                      children: <TableRow>[
                        TableRow(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Text(
                                    Constants.language == "en"
                                        ? "Branch "
                                        : "فرع",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: const Center(child: Text(':')),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              //  color: Colors.white,
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Constants.language == "en"
                                        ? widget.branchname
                                        : widget.arbbranchname,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    Constants.language == "en"
                                        ? "Description"
                                        : " الوصف",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(top: 22),
                                    child: const Center(child: Text(':'))),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    widget.description,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    Constants.language == "en"
                                        ? "Actual Price"
                                        : "السعر الأصلي",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 22),
                                  child: const Center(child: Text(':')),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text(
                                      (double.parse(widget.priceone) *
                                              _itemCount)
                                          .toStringAsFixed(3),
                                      // : widget.priceone,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 2.85,
                                        decorationColor: Colors.red,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    Constants.language == "en"
                                        ? "After Discount"
                                        : "بعد الخصم",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 22),
                                  child: const Center(child: Text(':')),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    /*widget.productmobdiscont=="0.000"?
                                widget.pricetwo:widget.productmobdiscont,*/

                                    (double.parse(widget.pricetwo) * _itemCount)
                                        .toStringAsFixed(3),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.green,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  child: Text(
                                    Constants.language == "en"
                                        ? "VIP Code"
                                        : "بعد الخصم",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  child: const Center(child: Text(':')),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  // margin: const EdgeInsets.only(left: 10.0),
                                  height: 40.0,
                                  width: 190,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: TextField(
                                    textAlign: TextAlign.start,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    focusNode: vipFocusNode,
                                    controller: vip_code_controller,
                                    keyboardType: inputType,
                                    maxLines: 1,
                                    cursorColor: Colors.white,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '  VIP Code',
                                      hintStyle:
                                          TextStyle(color: Colors.black45),
                                    ),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        vipFocusNode.unfocus();
                                        setState(() {
                                          inputType = TextInputType.text;
                                          Future.delayed(
                                              const Duration(milliseconds: 75),
                                              () {
                                            vipFocusNode.requestFocus();
                                          });
                                        });
                                      } else if (value.length == 1) {
                                        vipFocusNode.unfocus();
                                        setState(() {
                                          inputType = TextInputType.number;
                                          Future.delayed(
                                              const Duration(milliseconds: 75),
                                              () {
                                            vipFocusNode.requestFocus();
                                          });
                                        });
                                      } else if (value.length == 5) {
                                        vipFocusNode.unfocus();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  child: Text(
                                    Constants.language == "en"
                                        ? "Quantity"
                                        : "بعد الخصم",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  child: const Center(child: Text(':')),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 20,
                                right: 30,
                              ),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xFFF2CC0F),
                              ),
                              height: 35,
                              width: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                      padding: const EdgeInsets.only(
                                          bottom: 10, left: 5),
                                      onPressed: () {
                                        setState(() {
                                          if (_itemCount >= 2) {
                                            // transactionapi();
                                            _itemCount--;
                                            // transactionapi();
                                          }
                                          setState(() {
                                            loading = true;
                                          });
                                        });
                                      },
                                      icon: const Icon(Icons.remove, size: 30)),
                                  MaterialButton(
                                    padding: const EdgeInsets.only(left: 1),
                                    minWidth: 10,
                                    //     color: Color(0xFFB005BA),
                                    shape: const BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    )),
                                    // foregroundColor: Colors.white,
                                    // backgroundColor: Colors.white,
                                    onPressed: () {},
                                    child: Text(
                                      _itemCount.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      onPressed: () {
                                        print("pricetwo" +
                                            widget.pricetwo.toString());
                                        // transactionapi();
                                        setState(() {});
                                        setState(() {
                                          _itemCount++;
                                        });
                                      },
                                      icon: const Icon(Icons.add, size: 30)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Visibility(
              //   visible: !_visible,
              //   child: Column(
              //     children: [
              //       Container(
              //         margin: const EdgeInsets.only(
              //           top: 70,
              //           left: 10,
              //           right: 10,
              //         ),
              //         child: ElevatedButton(
              //           onPressed: () {
              //             if (widget.fastDeliveryCharges != '' &&
              //                 widget.specialDeliveryCharges != '') {
              //               print("myfastDeliveryCharges here" +
              //                   widget.fastDeliveryCharges.toString());
              //               print("mycurrentlattitude" + _latitude.toString());
              //               // transactionapi();
              //               setState(() {
              //                 _visible = !_visible;
              //                 _delvery = !_delvery;
              //                 _buyNowClicked = true;
              //                 _purchased = true; // Set the purchase flag
              //               });
              //             } else {
              //               Network().showToast(
              //                 msg: "No delivery available",
              //                 bgColor: kYellow,
              //                 txtColor: Colors.black,
              //                 toastGravity: ToastGravity.CENTER,
              //               );
              //             }
              //           },
              //           child: Text(
              //             Constants.language == "en"
              //                 ? "Buy Now"
              //                 : "شراء بدون توصيل",
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontFamily: Constants.language == "en"
              //                   ? "Roboto"
              //                   : "GSSFont",
              //               fontSize: 18.0,
              //             ),
              //           ),
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: const Color(0xFFF2CC0F),
              //             elevation: 0.0,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10),
              //               side: const BorderSide(
              //                 color: Colors.black,
              //                 width: 1.0,
              //               ),
              //             ),
              //             fixedSize: Size(width, 35.0),
              //           ),
              //         ),
              //       ),
              //       Visibility(
              //         visible: !_buyNowClicked,
              //         child: Container(
              //           margin: const EdgeInsets.only(
              //             bottom: 5,
              //             left: 10,
              //             right: 10,
              //           ),
              //           child: ElevatedButton(
              //             onPressed: () async {
              //               bool success = await saveCart();
              //               if (success) {
              //                 incrementAddedProductsCount();
              //                 if (widget.cartid != null) {
              //                   //  String cartId = widget.cartid;
              //                   // String qty = widget.qty.toString();
              //                   //   await editQuantity(cartId, qty);

              //                   setState(() {
              //                     cartitem = itemquantity;
              //                   });
              //                 } else {
              //                   // Handle the case when cartlist is null or index is out of range
              //                   // Example: Show an error message or handle the case accordingly
              //                 }
              //               }
              //             },
              //             child: Text(
              //               Constants.language == "en"
              //                   ? "Add To Cart"
              //                   : "شراء بدون توصيل",
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontFamily: Constants.language == "en"
              //                     ? "Roboto"
              //                     : "GSSFont",
              //                 fontSize: 18.0,
              //               ),
              //             ),
              //             style: ElevatedButton.styleFrom(
              //               backgroundColor: const Color(0xFFF2CC0F),
              //               elevation: 0.0,
              //               shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(10),
              //                 side: const BorderSide(
              //                   color: Colors.black,
              //                   width: 1.0,
              //                 ),
              //               ),
              //               fixedSize: Size(width, 35.0),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              widget.fastDeliveryCharges.isNotEmpty
                  ? Visibility(
                      visible: _delvery,
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 70.0, left: 10, right: 10),
                        child: ElevatedButton(
                          onPressed: () async {
                            total =
                                (double.parse(widget.pricetwo) * _itemCount);

                            if (total <= 5.000) {
                              // transactionapi();
                              setState(() {
                                loading = true;
                              });
                              _alertDialog(
                                  "Pricing Amount is less than 5.000 OMR Please buy above 5.000 OMR");
                              // _showdialog(context,width);
                            } else {
                              deliveryCharge = 1.toString();

                              await transactionapi(deliveryCharge);

                              setState(() {});
                              _showDialog(context, width);
                            }
                          },
                          child: Text(
                            Constants.language == "en"
                                ? "Fast Deliver"
                                : "شراء مع توصيل",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontSize: 18.0,
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
                            fixedSize: Size(width, 35.0),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      /*margin: const EdgeInsets.only(top: 70.0,left: 10,right: 10),*/),
              widget.specialDeliveryCharges.isNotEmpty
                  ? Visibility(
                      visible: _delvery,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: ElevatedButton(
                          onPressed: () async {
                            deliveryCharge = 2.toString();
                            await transactionapi(deliveryCharge);

                            setState(() {});
                            _showdialog(context, width);
                          },
                          child: Text(
                            Constants.language == "en"
                                ? "Special  Deliver"
                                : "شراء مع توصيل",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontSize: 18.0,
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
                            fixedSize: Size(width, 35.0),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  String? username;
  String? useradress;
  String? usermobile;
  Future<void> sharedataagain() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString("name");
    useradress = pref.getString("adress");
    usermobile = pref.getString("mobile");
  }

  String _latitude = '00.00000';
  String _longitude = '00.00000';
//  double _latitude=0.0,_longitude=0.0,
  double kmete = 0.0;

  Future<void> _getLocation() async {
    print("start...");
    print("start...1");
    print("rohanlong" + longitude);
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _latitude = position.latitude.toString();
    _longitude = position.longitude.toString();
    //  kmete = getDistanceFromLatLonInKm(position.latitude,position.longitude, widget.fastDeliveryCharges,widget.specialDeliveryCharges);
    // LocationNotification(position.latitude,position.longitude);
    print("rohanlatrr" + _latitude.toString());

    print("rohanID" + Constants.user_id);
  }

  List<String>? myaddress = [];
  Future<void> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    myaddress = pref.getStringList("myAddress");
  }

  @override
  void initState() {
    _getCompanyDetails(widget.companyid);
    _itemCount = int.parse(widget.qty);
    /*if(Constants.qty!=null){
    _itemCount=int.parse(Constants.qty);
    Constants.qty="";
  }*/

    getData();

    _getLocation();
//kmete = getDistanceFromLatLonInKm(latitude,longitude, widget.lat,widget.specialDeliveryCharges);
    if (imagelist != null && imagelist!.isNotEmpty) {
      for (int i = 0; i < imagelist!.length; i++) {
        setState(() {
          index = i;

          print("couponamount");
        });
      }
    }
    getproductdata();
    print("productmobile_cost" + widget.prodictmobcost);
    //  transactionapi();
    sharedataagain();
    print("mylatitude" + widget.fastDeliveryCharges.toString());
    print("mycurrentlattitude" + _latitude.toString());
    print("rrfastDeliveryCharges" + kmete.toString());
    super.initState();
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

  _showDialog(BuildContext context, double width) {
    Dialog dialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        //this right here
        child: SizedBox(
            height: 900,
            width: MediaQuery.of(context).size.width * 0.90,
            child: SingleChildScrollView(
                child: Column(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(),
                              Container(
                                margin: const EdgeInsets.only(left: 50),
                                child: Center(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(widget.product_image),
                                    radius: 40.0,
                                  ),
                                ),
                              ),
                              IconButton(
                                iconSize: 30.0,
                                onPressed: () {
                                  Constants.arb_companyname = "";
                                  Constants.branchid = "";
                                  Constants.image = "";
                                  Constants.redeempoint = "";
                                  Constants.discount = "";
                                  Constants.notification_id = "";
                                  Constants.arb_branchname = "";
                                  Constants.paidamount = "";
                                  Constants.companyid = "";
                                  Constants.saveamount = "";
                                  Constants.totalamount = "";
                                  Constants.companyname = "";
                                  Constants.notificationtype = "";
                                  Constants.order_id = "";
                                  Constants.branchname = "";
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                icon: const Icon(
                                    CupertinoIcons.clear_circled_solid),
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      Constants.language == "en"
                          ? widget.productname
                          : widget.arbproductname,
                      style: TextStyle(
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 250.0,
                    margin: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 10.0, bottom: 50),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2CC0F),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Text(
                            Constants.language == "en"
                                ? "Quantity"
                                : "Quantity",
                            style: TextStyle(
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            itemquantity,
                            // widget.state2.toString(),
                            //   total.toString(),

                            style: const TextStyle(fontFamily: "Roboto"),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          height: 1.0,
                          color: Colors.black,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                Constants.language == "en"
                                    ? "Actual Price:"
                                    : "السعر الأصلي",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(itemamount.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: "Roboto",
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2.85,
                                      decorationColor: Colors.red,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          height: 1.0,
                          color: Colors.black,
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: [
                                  // Fast is fastDeliveryCharges
                                  Text(
                                    /*Constants.language == "en"
                                    ? "Amount To Pay"
                                    : "المبلغ للدفع",*/

                                    Constants.language == "en"
                                        ? "After Discount + Delivery Charges:"
                                        : "بعد الخصم",
                                    style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      // (double.parse("12")).toString(),
                                      itemdiscount.toString(),
                                      style:
                                          const TextStyle(fontFamily: "Roboto"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              height: 1.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Text(
                                /*   Constants.language == "en"
                                    ? "Use Points"
                                    : "استخدم النقاط",*/
                                "VAT",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  avat,
                                  //  price.toString(),

                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                height: 1.0,
                                color: Colors.black,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                ),
                                child: Text(
                                  Constants.language == "en"
                                      ? "Total price "
                                      : "السعر النهائي",
                                  style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  itemtotal,
                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                height: 1.0,
                                color: Colors.black,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                ),
                                child: Text(
                                  Constants.language == "en"
                                      ? "Total Points "
                                      : "عدد النقاط",
                                  style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  itempoints,
                                  //   total.toString(),

                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                              // Container(
                              //   margin: const EdgeInsets.only(top: 10.0),
                              //   height: 1.0,
                              //   color: Colors.black,
                              // ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                height: 1.0,
                                color: Colors.black,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                ),
                                child: Text(
                                  Constants.language == "en"
                                      ? "Delivery Address"
                                      : "عدد النقاط",
                                  style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  // myaddress.toString(),
                                  Constants.nameOfusers,
                                  //   total.toString(),

                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                height: 1.0,
                                color: Colors.black,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 20, left: 10, right: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // transactionapi();
                                    _alertShow(context, "success");
                                  },
                                  child: Text(
                                    Constants.language == "en"
                                        ? " Pay now"
                                        : "أدفع الان",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontSize: 18.0,
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
                                    fixedSize: Size(width, 35.0),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _alertDialog("Not Available");
                                    /* Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (context)=>
                                              booknow(company_name,
                                                  company_image,
                                                  sender_id,
                                                  receiver_id,
                                                  product_image,
                                                  product_details, page,
                                                  sender_image,
                                                  isuserhome,
                                                  isCompanyHome,
                                                  priceone,
                                                  pricetwo)));*/
                                  },
                                  child: Text(
                                    Constants.language == "en"
                                        ? "Pay By Cash"
                                        : "الدفع نقدا",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontSize: 18.0,
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
                                    fixedSize: Size(width, 35.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]))));

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  _showdialog(BuildContext context, double width) {
    Dialog dialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        //this right here
        child: SizedBox(
            height: 700,
            width: MediaQuery.of(context).size.width * 0.90,
            child: SingleChildScrollView(
                child: Column(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(),
                              Container(
                                margin: const EdgeInsets.only(left: 50),
                                child: Center(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(widget.product_image),
                                    radius: 40.0,
                                  ),
                                ),
                              ),
                              IconButton(
                                iconSize: 30.0,
                                onPressed: () {
                                  Constants.arb_companyname = "";
                                  Constants.branchid = "";
                                  Constants.image = "";
                                  Constants.redeempoint = "";
                                  Constants.discount = "";
                                  Constants.notification_id = "";
                                  Constants.arb_branchname = "";
                                  Constants.paidamount = "";
                                  Constants.companyid = "";
                                  Constants.saveamount = "";
                                  Constants.totalamount = "";
                                  Constants.companyname = "";
                                  Constants.notificationtype = "";
                                  Constants.order_id = "";
                                  Constants.branchname = "";
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                icon: const Icon(
                                    CupertinoIcons.clear_circled_solid),
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      Constants.language == "en"
                          ? widget.productname
                          : widget.arbproductname,
                      style: TextStyle(
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 250.0,
                    margin: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 10.0, bottom: 50),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2CC0F),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Text(
                            Constants.language == "en"
                                ? "Quantity"
                                : "Quantity",
                            style: TextStyle(
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            itemquantity.toString(),
                            // widget.state2.toString(),
                            //   total.toString(),

                            style: const TextStyle(fontFamily: "Roboto"),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          height: 1.0,
                          color: Colors.black,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                Constants.language == "en"
                                    ? "Actual Price:"
                                    : "السعر الأصلي",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                    mobcost.toString() == "0"
                                        ? itemamount.toString()
                                        : mobcost.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: "Roboto",
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2.85,
                                      decorationColor: Colors.red,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          height: 1.0,
                          color: Colors.black,
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: [
                                  Text(
                                    /*Constants.language == "en"
                                    ? "Amount To Pay"
                                    : "المبلغ للدفع",*/

                                    Constants.language == "en"
                                        ? "After Discount + Delivery Charges:"
                                        : "بعد الخصم",
                                    style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      itemdiscount,
                                      //mobdiscount.toString()=="0"?
                                      //  itemdiscount.toString():mobdiscount.toString(),
                                      style:
                                          const TextStyle(fontFamily: "Roboto"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              height: 1.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        /* Container(
                                  margin: const EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        Constants.language == "en"
                                            ? "Delivery Charges"
                                            : "سعر التوصيل",
                                        style: TextStyle(
                                            fontFamily: Constants.language == "en"
                                                ? "Roboto"
                                                : "GSSFont",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5.0),
                                        child: Text("0.000",
                                         // itemdeliver.toString(),
                                          style: TextStyle(fontFamily: "Roboto"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.only(top: 10.0),
                                  height: 1.0,
                                  color: Colors.black,
                                ),*/
                        Container(
                          margin:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Column(
                            children: [
                              /* Text(
                                        */ /*   Constants.language == "en"
                                    ? "Use Points"
                                    : "استخدم النقاط",*/ /*
                                        "Suplier VAT",
                                        style: TextStyle(
                                            fontFamily: Constants.language == "en"
                                                ? "Roboto"
                                                : "GSSFont",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          itemvat.toString(),

                                          style: TextStyle(fontFamily: "Roboto"),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10.0),
                                        height: 1.0,
                                        color: Colors.black,
                                      ),*/
                              Text(
                                /*   Constants.language == "en"
                                    ? "Use Points"
                                    : "استخدم النقاط",*/
                                "VAT",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  avat,
                                  //  price.toString(),

                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                height: 1.0,
                                color: Colors.black,
                              ),
                              Text(
                                Constants.language == "en"
                                    ? "Total price "
                                    : "السعر النهائي",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  // totalwithoutcost.toString() == "0"
                                  //     ?
                                  itemtotal,
                                  // : totalwithoutcost.toString(),
                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                height: 1.0,
                                color: Colors.black,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                ),
                                child: Text(
                                  Constants.language == "en"
                                      ? "Points "
                                      : "عدد النقاط",
                                  style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  itempoints.toString(),
                                  //   total.toString(),

                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                height: 1.0,
                                color: Colors.black,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                ),
                                child: Text(
                                  Constants.language == "en"
                                      ? "Delivery Address"
                                      : "عدد النقاط",
                                  style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  // myaddress.toString(),
                                  //   total.toString(),
                                  Constants.nameOfusers,
                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                height: 1.0,
                                color: Colors.black,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 20, left: 10, right: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _alertShow(context, "success");
                                  },
                                  child: Text(
                                    Constants.language == "en"
                                        ? " Pay now"
                                        : "أدفع الان",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontSize: 18.0,
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
                                    fixedSize: Size(width, 35.0),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _alertDialog("Not Available");
                                    /* Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (context)=>
                                              booknow(company_name,
                                                  company_image,
                                                  sender_id,
                                                  receiver_id,
                                                  product_image,
                                                  product_details, page,
                                                  sender_image,
                                                  isuserhome,
                                                  isCompanyHome,
                                                  priceone,
                                                  pricetwo)));*/
                                  },
                                  child: Text(
                                    Constants.language == "en"
                                        ? "Pay By Cash"
                                        : "الدفع نقدا",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontSize: 18.0,
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
                                    fixedSize: Size(width, 35.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]))));

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }
}
