// ignore_for_file: non_constant_identifier_names, must_be_immutable, unused_field, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable, prefer_function_declarations_over_variables, unused_element

import 'dart:async';
import 'dart:convert';
//import 'dart:ffi';
import 'dart:io';

import 'package:city_code/Screens/CouponReport.dart';
import 'package:city_code/Screens/scanner_screen.dart';
import 'package:city_code/Screens/upload_receipt_screen.dart';
import 'package:city_code/models/Companycoupondetail_Model.dart';
import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/adressmodel.dart';
import 'package:city_code/models/couponlistmodel.dart';
import 'package:city_code/models/couponredeemmodel.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_actions/keyboard_actions.dart';
import '../models/company_offer_model.dart';
import '../models/user_transaction_code_model.dart';

class SaleDetailsScreen extends StatefulWidget {
  String vip_code,
      user_name,
      company_image,
      user_points,
      user_id,
      city_code,
      org,
      orgstatus,
      companyid,
      perchasedid;

  SaleDetailsScreen(
      this.vip_code,
      this.user_name,
      this.company_image,
      this.user_points,
      this.user_id,
      this.city_code,
      this.org,
      this.orgstatus,
      this.companyid,
      this.perchasedid,
      {Key? key})
      : super(key: key);

  @override
  _SaleDetailsScreenState createState() => _SaleDetailsScreenState();
}

class _SaleDetailsScreenState extends State<SaleDetailsScreen> {
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  final FocusNode _nodeText6 = FocusNode();
  String customerdiscount = "";
  String discription = "";
  String arbdiscription = "";

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(focusNode: _nodeText2, toolbarButtons: [
          (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
        KeyboardActionsItem(
          focusNode: _nodeText5,
          toolbarButtons: [
            //button 2
            (node) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    node.unfocus();
                    if (amountBeforeController.text.isNotEmpty &&
                        !amountBeforeController.text.contains(".")) {
                      amountBeforeController.text =
                          amountBeforeController.text + ".000 OMR";
                      amountBeforeController.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: amountBeforeController.text.length));
                    } else if (amountBeforeController.text
                            .substring(amountBeforeController.text.indexOf("."))
                            .length >
                        3) {
                      amountBeforeController.text =
                          amountBeforeController.text + "";
                      TextSelection.fromPosition(TextPosition(
                          offset: amountBeforeController.text.length));
                    } else if (amountBeforeController.text
                            .substring(amountBeforeController.text.indexOf("."))
                            .length >
                        2) {
                      amountBeforeController.text =
                          amountBeforeController.text + "0";
                      TextSelection.fromPosition(TextPosition(
                          offset: amountBeforeController.text.length));
                    } else if (amountBeforeController.text
                            .substring(amountBeforeController.text.indexOf("."))
                            .length >
                        1) {
                      amountBeforeController.text =
                          amountBeforeController.text + "00";
                      TextSelection.fromPosition(TextPosition(
                          offset: amountBeforeController.text.length));
                    } else if (amountBeforeController.text
                        .substring(amountBeforeController.text.indexOf("."))
                        .isNotEmpty) {
                      amountBeforeController.text =
                          amountBeforeController.text + "000";
                      TextSelection.fromPosition(TextPosition(
                          offset: amountBeforeController.text.length));
                    }
                    if (amountBeforeController.text.isNotEmpty &&
                        !amountBeforeController.text.contains("OMR")) {
                      amountBeforeController.text =
                          amountBeforeController.text + " OMR";
                      amountBeforeController.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: amountBeforeController.text.length));
                    }
                  },
                  child: Container(
                    width: 80,
                    color: const Color(0xFFF2CC0F),
                    //padding: EdgeInsets.all(10.0),
                    child: const Center(
                      child: Text(
                        "DONE",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _nodeText6,
          footerBuilder: (_) => const PreferredSize(
              child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('Custom Footer'),
                  )),
              preferredSize: Size.fromHeight(40)),
        ),
      ],
    );
  }

  double camount = 0.000;
  bool _isLoading = true, price_page = false, use_points = false;
  List<Offerlist>? offerlist = [];
  List<CouponData>? coupon_data = [];

  int position = 0;

  int tempposition = 0;
  String discountedTotalAmount = "0", order_id = "", status = "";

  TextEditingController points_controller = TextEditingController();
  TextEditingController amountAfterController = TextEditingController();
  TextEditingController amountBeforeController = TextEditingController();
  TextEditingController transactionCode_controller = TextEditingController();
  FocusNode numberFocusNode = FocusNode();
  int buttoncount = 0;

  late Timer timer;

  var perchased;
  var _clicked = "0";

  String response_display = "";

  @override
  void dispose() {
    numberFocusNode.dispose();
    if (timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  var coupondata = "";

  var expiredate = "";
  var companylogo = "";
  var companyimgurl = "";
  var Status = "";
  var coupontext = "";
  var companyid = "";
  var companyname = "";
  var couponename = "";
  var couponamount = "";
  var couponeprice = "";
  var companyiddata = "";
  var branchid = "";
  var startdate = "";
  var enddate = "";
  var dataone = "";
  var datatwo = "";
  var couponid = "";
  int index = 0;

  var company = "";
  Future<void> couponpreedem() async {
    Map<String, String> jsonbody = {
      "couponid": widget.companyid,
      "userid": widget.user_id,

      /*   "ad_1":_ads_1_file,
      "ad_2":_ads_2_file.toString(),
      "ad_3":_ads_3_file.toString(),
      "ad_4":_ads_4_file.toString(),
*/
    };
    var network = NewVendorApiService();
    String urls = "http://cp.citycode.om/public/index.php/redeemcoupon";
    var res = await network.postresponse(urls, jsonbody);
    var model = Couponredeemmodel.fromJson(res);
    String stat = model.status.toString();

    print("coupon" + widget.companyid);
    print("userid" + widget.user_id);

    setState(() {});

    print("coupon redeem status" + stat);

    if (stat.contains("201")) {
      setState(() {
        //  _isLoading=false;
      });
    } else {
      // alertShow(context,"error");
      setState(() {
        _isLoading = false;
      });
      /* Fluttertoast.showToast(
          msg: "You have already Coupon.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);*/
    }
    print("coupon redeem data" + res!.toString());
    setState(() {
      // _isLoading=false;
    });
  }

  List<Userdetail>? userdata = [];
  Future<void> getInfocustomer() async {
    Map<String, String> jsonbody = {
      "user_code": widget.user_id,

      /*   "ad_1":_ads_1_file,
      "ad_2":_ads_2_file.toString(),
      "ad_3":_ads_3_file.toString(),
      "ad_4":_ads_4_file.toString(),
*/
    };
    var network = NewVendorApiService();
    String urls = "http://185.188.127.11/public/index.php/getcodedetail";
    var res = await network.postresponse(urls, jsonbody);
    var model = Couponredeemmodel.fromJson(res);
    String stat = model.status.toString();

    print("coupon" + widget.companyid);
    print("userid" + widget.user_id);

    setState(() {});

    print("coupon redeem status" + stat);

    if (stat.contains("201")) {
      setState(() {
        //  _isLoading=false;
      });
    } else {
      // alertShow(context,"error");
      setState(() {
        _isLoading = false;
      });
      /* Fluttertoast.showToast(
          msg: "You have already Coupon.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);*/
    }
    print("coupon redeem data" + res!.toString());
    setState(() {
      // _isLoading=false;
    });
  }

  // var customerdiscount = "";
  // var discription = "";
  // var arbdiscription = "";

  @override
  void initState() {
    for (var data in offerlist!) {
      // customerdiscount= data.customerDiscount.toString();
    }
    print("copnbhai" + widget.companyid);

    //sendpayment();
    if (widget.companyid.isNotEmpty) {
      // sendpayment();
      couponlistingmethod();
      print("conpanyiddata" + widget.companyid.toString());
      //sendpayment();
      couponlistingmethod();
      price_page = true;
    }

    print("orgCODE" + widget.org);
/*
    if(widget.orgstatus=="0"){
      print("vipCODE1"+widget.vip_code);
      widget.vip_code=widget.org;
      widget.city_code="";
      print("ho"+widget.vip_code);
    }*/
    print("vipCODE" + widget.vip_code);
    print("cityCODE" + widget.city_code);

    print("company_id" + Constants.company_id);
    company = Constants.company_id;
    print("branch_id" + Constants.branch_id);
    print("user_code" + widget.city_code);
    print("vip_org_code" + widget.vip_code);
    print("company" + company.toString());
    couponlist();
    // sendpayment();
    bool _isButtonDisabled = false;
    _getCompanyOffers().then((value) => {
          if (value.offerlist != null && value.offerlist!.isNotEmpty)
            {
              for (int i = 0; i < value.offerlist!.length; i++)
                {
                  setState(() {
                    index = i;
                    offerlist!.add(value.offerlist![i]);
                    //  companycoupondata!.add(value.couponData![i]);
                    customerdiscount =
                        value.offerlist![i].customerDiscount.toString();
                    discription = value.offerlist![i].description.toString();
                    arbdiscription =
                        value.offerlist![i].arbDescription.toString();
                    //  couponname=value.couponData![i].couponName.toString();
                    print("datacoupon" + couponname.toString());
                  }),
                }
            },
          setState(() {
            _isLoading = false;
          }),
        });
    setState(() {
      points_controller.text = "0";
    });
    numberFocusNode.addListener(() {
      bool hasFocus = numberFocusNode.hasFocus;
      if (hasFocus) {
        // KeyboardOverlay.showOverlay(context);
      } else {
        if (amountBeforeController.text.length <= 6) {
          setState(() {
            RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
            String Function(Match) mathFunc = (Match match) => '${match[1]}.';
            amountBeforeController.text =
                amountBeforeController.text.replaceAllMapped(reg, mathFunc);
            print(amountBeforeController.text);
            amountBeforeController.selection = TextSelection.fromPosition(
                TextPosition(offset: amountBeforeController.text.length));
          });
        } else if (amountBeforeController.text.length == 7) {
          RegExp reg = RegExp(r'(\d{3})(?=(\d{3})+(?!\d))');
          String Function(Match) mathFunc = (Match match) => '${match[1]}.';
          amountBeforeController.text =
              amountBeforeController.text.replaceAllMapped(reg, mathFunc);
        } else if (amountBeforeController.text.length == 8) {
          RegExp reg = RegExp(r'(\d{3})(?=(\d{3})+(?!\d))');
          String Function(Match) mathFunc = (Match match) => '${match[1]}.';
          amountBeforeController.text =
              amountBeforeController.text.replaceAllMapped(reg, mathFunc);
        } else if (amountBeforeController.text.length == 9) {
          RegExp reg = RegExp(r'(\d{4})(?=(\d{3})+(?!\d))');
          String Function(Match) mathFunc = (Match match) => '${match[1]}.';
          amountBeforeController.text =
              amountBeforeController.text.replaceAllMapped(reg, mathFunc);
        } else if (amountBeforeController.text.length == 10) {
          RegExp reg = RegExp(r'(\d{5})(?=(\d{3})+(?!\d))');
          String Function(Match) mathFunc = (Match match) => '${match[1]}.';
          amountBeforeController.text =
              amountBeforeController.text.replaceAllMapped(reg, mathFunc);
        } else if (amountBeforeController.text.length <= 13) {
          RegExp reg = RegExp(r'(\d{5,10})(?=(\d{3})+(?!\d))');
          String Function(Match) mathFunc = (Match match) => '${match[1]}.';
          amountBeforeController.text =
              amountBeforeController.text.replaceAllMapped(reg, mathFunc);
        }
      }
      /* else {
        if(!amountBeforeController.text.toString().contains(".")){
          setState(() {
            amountBeforeController.text=amountBeforeController.text.toString()+".000";
          });

        }else if(amountBeforeController.text.toString().contains(".")){
          var tempstring = amountBeforeController.text.toString().split(".");

          //print("tempstring.length : "+tempstring[0].length.toString());
          //if(tempstring.length>1){
            if(tempstring[1].length==1){
              setState(() {
                amountBeforeController.text=amountBeforeController.text.toString()+"00";
              });
            }else if(tempstring[1].length==2){
              setState(() {
                amountBeforeController.text=amountBeforeController.text.toString()+"0";
              });
            }else if(tempstring[1].length==3){
              setState(() {
                amountBeforeController.text=amountBeforeController.text.toString()+"";
              });
            }
            else if(amountBeforeController.text.toString().contains(".")){
              setState(() {
                amountBeforeController.text=amountBeforeController.text.toString()+"000";
              });
            }
          // }else{
          //   setState(() {
          //     amountBeforeController.text=amountBeforeController.text.toString()+"000";
          //   });
          // }

        }
        KeyboardOverlay.removeOverlay();
      }*/
    });
    //  sendpayment();
    super.initState();
  }

  List<CouponList>? couponlistdata = [];
  Future<void> couponlist() async {
    Map<String, String> jsonbody = {
      "companyid": Constants.company_id,
      // "branchid":widget.branchid,

      /*   "ad_1":_ads_1_file,
      "ad_2":_ads_2_file.toString(),
      "ad_3":_ads_3_file.toString(),
      "ad_4":_ads_4_file.toString(),
*/
    };
    var network = NewVendorApiService();
    String urls = "http://cp.citycode.om/public/index.php/couponlist";
    var res = await network.postresponse(urls, jsonbody);
    var model = Couponlistmodel.fromJson(res);
    String stat = model.status.toString();
    coupondata = model.couponList.toString();
    companyimgurl = model.companyImageBaseUrl.toString();

    // print("couponlistbranch"+widget.branchid);

    setState(() {
      couponlistdata = model.couponList;
      var lengthdata = couponlistdata!.length;
      print("datadost" + lengthdata.toString());
      /*companyid=couponlistdata![index].companyId.toString();
      companyname=couponlistdata![index].companyName.toString();
      couponename=couponlistdata![index].couponName.toString();
      couponamount=couponlistdata![index].couponAmount.toString();
      couponeprice=couponlistdata![index].couponPrice.toString();
      startdate=couponlistdata![index].startDate.toString();
      enddate=couponlistdata![index].endDate.toString();
      companylogo=couponlistdata![index].picture.toString();
      coupontext=couponlistdata![index].couponDetails.toString();
      Status=couponlistdata![index].status.toString();*/
      print("detail" + coupontext.toString());
    });

    print(couponamount);
    print("dgdsgdsg" + stat);

    if (stat.contains("201")) {
      setState(() {
        //  _isLoading=false;
      });
    } else {
      setState(() {
        //_isLoading=false;
      });
      /*Fluttertoast.showToast(
          msg: "Somthing Went Wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);*/
    }
    print("dgdg" + res!.toString());
    setState(() {
      // _isLoading=false;
    });
  }

  var couponname = "";
  var couponamounts = "";
  var desciption = "";
  var arbdescription = "";
  var coupondate = "";
  List<CouponData>? companycoupondata = [];
  List<CouponData>? couponaxactlist = [];
  Future<void> sendpayment() async {
    Map<String, String> jsonbody = {
      "company_id": Constants.company_id,
      "branch_id": Constants.branch_id,
    };
    var network = NewVendorApiService();
    String urls = "http://185.188.127.11/public/index.php/cityoffer";
    var res = await network.postresponse(urls, jsonbody);
    var model = CompanyOfferModel.fromJson(res);
    String stat = model.status.toString();
    //var nopopupcatID = widget.cat_id;

    print("datais here" + stat.toString());

    if (stat.contains("201")) {
      companycoupondata = model.couponData!;
      var length = companycoupondata!.length;
      print("length" + length.toString());
      for (var data in companycoupondata!) {
        if (data.id == widget.companyid) {
          couponaxactlist!.add(CouponData(
            id: data.id,
            couponName: data.couponName,
            couponAmount: data.couponAmount,
            couponDetails: data.couponDetails,
            arbCouponDetails: data.arbCouponDetails,
            endDate: data.endDate,
          ));
        }
      }
      couponname = couponaxactlist![position].couponName.toString();
      couponamounts = couponaxactlist![position].couponAmount.toString();
      desciption = couponaxactlist![position].couponDetails.toString();
      arbdescription = couponaxactlist![position].arbCouponDetails.toString();
      coupondate = couponaxactlist![position].endDate.toString();
      camount = double.parse(couponaxactlist![position].couponAmount!);
      print("datprintsss" + camount.toString());
      /*for(var data in companycoupondata!){
        couponname= data.couponName.toString();

      }*/
      print("couponname" + couponname.toString());
      //   var d=companycoupondata![index].companyName.toString();
      //  print("data:::"+d.toString());
      // var amount=model.couponData![position].couponAmount.toString();
      // print("amount"+amount.toString());

      /*  Fluttertoast.showToast(
          msg: " Succesfully Added ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
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
    print("rrr" + res!.toString());
  }

  List<CompanyCouponList> couponlisting = [];
  Future<void> couponlistingmethod() async {
    Map<String, String> jsonbody = {
      "coupon_id": widget.companyid,
    };
    var network = NewVendorApiService();
    String urls = "http://cp.citycode.om/public/index.php/couponlistbyid";
    var res = await network.postresponse(urls, jsonbody);
    var model = CompanycoupondetailModel.fromJson(res);
    String stat = model.status.toString();
    //var nopopupcatID = widget.cat_id;

    print("datais here" + stat.toString());

    if (stat.contains("201")) {
      couponlisting = model.companyCouponList!;

      couponname = couponlisting[position].couponName.toString();
      couponamounts = couponlisting[position].couponAmount.toString();
      desciption = couponlisting[position].couponDetails.toString();
      arbdescription = couponlisting[position].arbCouponDetails.toString();
      coupondate = couponlisting[position].endDate.toString();
      camount = double.parse(couponlisting[position].couponAmount!);
      print("datprintsss" + camount.toString());
      /*for(var data in companycoupondata!){
        couponname= data.couponName.toString();

      }*/
      print("couponname" + couponname.toString());
      //   var d=companycoupondata![index].companyName.toString();
      //  print("data:::"+d.toString());
      // var amount=model.couponData![position].couponAmount.toString();
      // print("amount"+amount.toString());

      /*  Fluttertoast.showToast(
          msg: " Succesfully Added ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);*/
    } else {
      /*Fluttertoast.showToast(
          msg: "Somthings Went Wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);*/
    }
    print("rrr" + res!.toString());
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    if (price_page) {
      setState(() {
        amountAfterController.text = "";
        amountBeforeController.text = "";
        points_controller.text = "";
        price_page = false;
      });
      return false;
    } else {
      return true;
    }
  }

  final int decimalRange = 0;

  @override
  Widget build(BuildContext context) {
    bool isbuttondisabled = false;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              /* if(amountBeforeController.text.contains(".")&&amountBeforeController.text.substring(amountBeforeController.text.indexOf(".") + 1).length>decimalRange){
              print("clicked");
              amountBeforeController.text=amountBeforeController.text+"000";
              amountBeforeController.selection =
                  TextSelection.fromPosition(
                      TextPosition(
                          offset: amountBeforeController
                              .text.length));
            }*/
              /*  if(amountBeforeController.text.contains("")){
            amountBeforeController.text = amountBeforeController.text+".000 OMR";
            TextSelection.fromPosition(
                TextPosition(
                    offset: amountBeforeController
                        .text.length));
            }
            else*/
              if (amountBeforeController.text.isNotEmpty &&
                  !amountBeforeController.text.contains(".")) {
                amountBeforeController.text =
                    amountBeforeController.text + ".000 OMR";
                amountBeforeController.selection = TextSelection.fromPosition(
                    TextPosition(offset: amountBeforeController.text.length));
              } else if (amountBeforeController.text
                      .substring(amountBeforeController.text.indexOf("."))
                      .length >
                  3) {
                amountBeforeController.text = amountBeforeController.text + "";
                TextSelection.fromPosition(
                    TextPosition(offset: amountBeforeController.text.length));
              } else if (amountBeforeController.text
                      .substring(amountBeforeController.text.indexOf("."))
                      .length >
                  2) {
                amountBeforeController.text = amountBeforeController.text + "0";
                TextSelection.fromPosition(
                    TextPosition(offset: amountBeforeController.text.length));
              } else if (amountBeforeController.text
                      .substring(amountBeforeController.text.indexOf("."))
                      .length >
                  1) {
                amountBeforeController.text =
                    amountBeforeController.text + "00";
                TextSelection.fromPosition(
                    TextPosition(offset: amountBeforeController.text.length));
              } else if (amountBeforeController.text
                  .substring(amountBeforeController.text.indexOf("."))
                  .isNotEmpty) {
                amountBeforeController.text =
                    amountBeforeController.text + "000";
                TextSelection.fromPosition(
                    TextPosition(offset: amountBeforeController.text.length));
              }
              if (amountBeforeController.text.isNotEmpty &&
                  !amountBeforeController.text.contains("OMR")) {
                amountBeforeController.text =
                    amountBeforeController.text + " OMR";
                amountBeforeController.selection = TextSelection.fromPosition(
                    TextPosition(offset: amountBeforeController.text.length));
              }
              /*if(amountBeforeController.text.substring(amountBeforeController.text.indexOf(".")+1).length>decimalRange){
              print("clicked two zeros");
              amountBeforeController.text=amountBeforeController.text+"00";
              amountBeforeController.selection =
                  TextSelection.fromPosition(
                      TextPosition(
                          offset: amountBeforeController
                              .text.length));
            }
            if(amountBeforeController.text.substring(amountBeforeController.text.indexOf(".")+2).length>decimalRange){
              print("clicked one zeros");
              amountBeforeController.text=amountBeforeController.text+"0";
              amountBeforeController.selection =
                  TextSelection.fromPosition(
                      TextPosition(
                          offset: amountBeforeController
                              .text.length));
            }
            if(amountBeforeController.text.substring(amountBeforeController.text.indexOf(".")+3).length>decimalRange){
              print("clicked no zeros");
              amountBeforeController.text=amountBeforeController.text+"";
              amountBeforeController.selection =
                  TextSelection.fromPosition(
                      TextPosition(
                          offset: amountBeforeController
                              .text.length));
            }*/
              /* if(amountBeforeController!.text.length<=3){
              amountBeforeController.text=amountBeforeController.text+".000";
              amountBeforeController.selection =
                  TextSelection.fromPosition(
                      TextPosition(
                          offset: amountBeforeController
                              .text.length));
            }*/

              /*setState(() {

            });*/
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: const Color(0xFFF2CC0F),
              bottomNavigationBar: !price_page
                  ? Container(
                      width: width * 0.10,
                      height: 50.0,
                      margin: const EdgeInsets.all(9.0),
                    ) /*Container(
              width: width * 0.10,
              height: 50.0,
              margin: const EdgeInsets.all(9.0),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    Constants.language == "en" ? "Cancel" : "إلغاء",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily:
                      Constants.language == "en" ? "Roboto" : "GSSFont",
                      fontSize: 18.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFF2CC0F),
                    elevation: 0.0,
                    textStyle: const TextStyle(color: Colors.black),
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
            )*/
                  : Container(
                      color: const Color(0xFFF2CC0F),
                      child: SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /*Container(

                    //  margin: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          */ /* if (price_page) {
                                      setState(() {
                                        if (timer.isActive) {
                                          timer.cancel();
                                        }
                                        price_page = false;
                                      });
                                    }*/ /*
                          if (price_page) {
                            setState(() {
                              amountAfterController.text = "";
                              amountBeforeController.text = "";
                              points_controller.text = "";
                              price_page = false;
                              Navigator.of(context).pop();
                            });
                          } else {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          Constants.language == "en" ? "Back" : "رجوع",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont",
                            fontSize: 18.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFFF2CC0F),
                          elevation: 0.0,
                          textStyle: const TextStyle(color: Colors.black),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.45,
                              30.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),*/
                            Container(
                              width: width * 0.96,
                              margin: const EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (amountBeforeController.text.isNotEmpty) {
                                    if (discountedTotalAmount.isNotEmpty) {
                                      if (isbuttondisabled == false) {
                                        /*setState(() {
                                  _isLoading = true;
                                });*/
                                        print("my data");
                                        isbuttondisabled = true;
                                        //amountBeforeController.clear();
                                        String payamountvalue =
                                            amountBeforeController.text
                                                .toString();
                                        print(
                                            "payamountvalue" + payamountvalue);

                                        amountBeforeController.clear();

                                        //  bool isSuccess = await _postNotification(payamountvalue);
                                        //   perchased=isSuccess;

                                        if (_clicked == "0") {
                                          _clicked = "1";
                                          bool isSuccess =
                                              await _postNotification(
                                                  payamountvalue);
                                          if (widget.companyid != "null" &&
                                              widget.companyid.isNotEmpty) {
                                            print("redeem record");
                                            couponpreedem();
                                          }
                                          _alertDialog(
                                            "Payment is Successfully Done !",
                                          );
                                          amountBeforeController.text =
                                              payamountvalue;
                                          _clicked = "1";
                                          print("discountedtest" +
                                              discountedTotalAmount);

                                          ///adding redirect code to upload screen
                                          var route = MaterialPageRoute(
                                              builder: (context) =>
                                                  UploadReceiptScreen(
                                                      widget.city_code,
                                                      discountedTotalAmount,
                                                      points_controller.text,
                                                      order_id,
                                                      widget.company_image,
                                                      widget.vip_code));
                                          Navigator.push(context, route);
                                          //  check_status(context);
                                        }
                                        /*     if(perchased){
                                          _alertDialog("payment is Succesfully Done !");
                                        }
*/
                                        /*        else if(isSuccess) {
                                          //  amountBeforeController.clear();
                                        //    amountAfterController.clear();
                                            _alertDialog(Constants.language == "en"
                                                ? "Confirmation Sent Successfully !"
                                                : "تم إرسال التأكيد بنجاح!");
                                            check_status(context);

                                            isbuttondisabled=false;
                                            amountBeforeController.text=payamountvalue;

                                          }*/

                                        else {
                                          amountBeforeController.text =
                                              payamountvalue;
                                          _alertDialog(
                                            "Payment Already Done !",
                                          );
                                          /*  _alertDialog(Constants.language == "en"
                                                ? "Failed to send confirmation"
                                                : "فشل في إرسال التأكيد");*/
                                          isbuttondisabled = false;
                                        }
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
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontSize: 18.0,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF2CC0F),
                                  elevation: 0.0,
                                  textStyle:
                                      const TextStyle(color: Colors.black),
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.45,
                                      30.0),
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
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: const Color(0xFFF2CC0F),
                leading: IconButton(
                  icon: const Icon(CupertinoIcons.arrow_left),
                  color: Colors.black,
                  onPressed: () {
                    if (price_page) {
                      setState(() {
                        amountAfterController.text = "";
                        amountBeforeController.text = "";
                        points_controller.text = "";
                        price_page = false;
                        Navigator.of(context).pop();
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
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
                actions: [
                  Visibility(
                    visible: companycoupondata!.isNotEmpty ? true : false,
                    child: IconButton(
                      icon: const Icon(CupertinoIcons.doc),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => couponreport(
                                      userid: widget.user_id,
                                      companyimage: widget.company_image,
                                      companyname: Constants.company_name,
                                      companyid: Constants.company_id,
                                    )));
                      },
                    ),
                  ),
                  /* Visibility(
                  visible: price_page,
                  child: IconButton(
                    icon: Icon(CupertinoIcons.qrcode_viewfinder),
                    color: Colors.black,
                    onPressed: () {
                      _showMyDialog();
                    },
                  ),
                ),*/
                ],
              ),
              body: SafeArea(
                child: Scaffold(
                  backgroundColor: const Color(0xFFF2CC0F),
                  body: Stack(
                    children: [
                      Visibility(
                        visible: !price_page,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            height: height,
                            margin: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    Constants.language == "en"
                                        ? "Validity has been checked"
                                        : "تم التحقق من صلاحية الكود",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                      color: Colors.yellow.shade200),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, top: 5, bottom: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: CircleAvatar(
                                                backgroundImage: const AssetImage(
                                                    "images/citycode.png"), // Use AssetImage for image assets
                                                radius: width *
                                                    0.08, // Adjust the radius to reduce the image size
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10.0),
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
                                                  margin: const EdgeInsets.only(
                                                      top: 10.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    widget.user_name,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.0,
                                                      fontFamily:
                                                          Constants.language ==
                                                                  "en"
                                                              ? "Roboto"
                                                              : "GSSFont",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    widget.company_image),
                                                radius: width *
                                                    0.08, // Adjust the radius to reduce the image size
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    Constants.company_name,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.0,
                                                      fontFamily:
                                                          Constants.language ==
                                                                  "en"
                                                              ? "Roboto"
                                                              : "GSSFont",
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    Constants.branch_name,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.0,
                                                      fontFamily:
                                                          Constants.language ==
                                                                  "en"
                                                              ? "Roboto"
                                                              : "GSSFont",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10.0, bottom: 10.0),
                                  width: width,
                                  child: Text(
                                    Constants.language == "en"
                                        ? "Choose the type of discount"
                                        : "اختر نوع الخصم",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                    textAlign: Constants.language == "en"
                                        ? TextAlign.left
                                        : TextAlign.right,
                                  ),
                                ),
                                widget.companyid.isNotEmpty &&
                                        widget.companyid != "null"
                                    ? SingleChildScrollView(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: 1,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    position = index;
                                                    price_page = true;
                                                    camount = double.parse(
                                                        companycoupondata![
                                                                index]
                                                            .couponAmount!);
                                                    print("datprintsss" +
                                                        camount.toString());
                                                  });
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(5.0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        //  padding: const EdgeInsets.all(10.0),
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 10.0,
                                                            left: 10.0,
                                                            right: 10.0),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10))),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: 55,
                                                              width: 130,

                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: const Color(
                                                                          0xFFF2CC0F),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      borderRadius: const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              10))),
                                                              // width: width,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10.0),
                                                              child: Center(
                                                                child: Text(
                                                                  Constants.language ==
                                                                          "en"
                                                                      ? "Coupon Name"
                                                                      : "Coupon Price",
                                                                  style: TextStyle(
                                                                      fontFamily: Constants.language ==
                                                                              "en"
                                                                          ? "Roboto"
                                                                          : "GSSFont",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textAlign: Constants
                                                                              .language ==
                                                                          "en"
                                                                      ? TextAlign
                                                                          .left
                                                                      : TextAlign
                                                                          .right,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 150,
                                                              //padding: const EdgeInsets.all(10.0),
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10.0,
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          10.0,
                                                                      bottom:
                                                                          10.0),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      /*border: Border.all(
                                          color: Colors.black,
                                        ),*/
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10))),
                                                              child: Text(
                                                                Constants.language ==
                                                                        "en"
                                                                    ? couponlisting[
                                                                            index]
                                                                        .couponName!
                                                                    : couponlisting[
                                                                            index]
                                                                        .arbCouponName!,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16.0),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: width,
                                                        height: 200,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 10.0),
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 10.0,
                                                            left: 10.0,
                                                            right: 10.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color: Colors.black,
                                                          ),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
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

                                                                  decoration:
                                                                      BoxDecoration(
                                                                          color: const Color(
                                                                              0xFFF2CC0F),
                                                                          border: Border
                                                                              .all(
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.all(Radius.circular(5))),
                                                                  // width: width,
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10.0),
                                                                  child: Center(
                                                                    child: Text(
                                                                      Constants.language ==
                                                                              "en"
                                                                          ? "Coupon Details"
                                                                          : "Coupon Details",
                                                                      style: TextStyle(
                                                                          fontFamily: Constants.language == "en"
                                                                              ? "Roboto"
                                                                              : "GSSFont",
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign: Constants.language ==
                                                                              "en"
                                                                          ? TextAlign
                                                                              .left
                                                                          : TextAlign
                                                                              .right,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  // width: 240,
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 45),
                                                                  child: Text(
                                                                    couponlisting[index]
                                                                            .couponAmount! +
                                                                        " OMR",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16.0,
                                                                      fontFamily: Constants.language ==
                                                                              "en"
                                                                          ? "Roboto"
                                                                          : "GSSFont",
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              //  margin: const EdgeInsets.only(top: 10.0),
                                                              color:
                                                                  Colors.black,
                                                              height: 2.0,
                                                              width: width,
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                child:
                                                                    Container(
                                                                  width: width,
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 10.0,
                                                                      left: 5.0,
                                                                      right:
                                                                          5.0),
                                                                  child: Text(
                                                                    Constants.lang ==
                                                                            "en"
                                                                        ? couponlisting[index]
                                                                            .couponDetails!
                                                                        : couponlisting[index]
                                                                            .arbCouponDetails!,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily: Constants.lang ==
                                                                              "en"
                                                                          ? "Roboto"
                                                                          : "GSSFont",
                                                                    ),
                                                                    textAlign: Constants.lang ==
                                                                            "en"
                                                                        ? TextAlign
                                                                            .left
                                                                        : TextAlign
                                                                            .right,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 10.0,
                                                            left: 10.0,
                                                            right: 10.0,
                                                            bottom: 10.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              Constants.language ==
                                                                      "en"
                                                                  ? "Expiration Date"
                                                                  : "تاريخ انتهاء العرض",
                                                              style: TextStyle(
                                                                  fontFamily: Constants
                                                                              .language ==
                                                                          "en"
                                                                      ? "Roboto"
                                                                      : "GSSFont",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign: Constants
                                                                          .language ==
                                                                      "en"
                                                                  ? TextAlign
                                                                      .left
                                                                  : TextAlign
                                                                      .right,
                                                            ),
                                                            Text(
                                                              couponlisting[
                                                                      index]
                                                                  .endDate!,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign: Constants
                                                                          .language ==
                                                                      "en"
                                                                  ? TextAlign
                                                                      .left
                                                                  : TextAlign
                                                                      .right,
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
                                            }),
                                      )
                                    : Expanded(
                                        child: //offerlist!.isNotEmpty||widget.companyid==null
                                            //?
                                            ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: offerlist!.length,
                                                itemBuilder: (context, index) {
                                                  tempposition = index;
                                                  final offer =
                                                      offerlist![index];
                                                  return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          // Store the tapped offer details
                                                          customerdiscount =
                                                              '${offer.customerDiscount}%';
                                                          discription = Constants
                                                                      .lang ==
                                                                  "en"
                                                              ? offer
                                                                  .description!
                                                              : offer.arbDescription!
                                                                      .isNotEmpty
                                                                  ? offer
                                                                      .arbDescription!
                                                                  : offer
                                                                      .description!;
                                                          price_page = true;
                                                        });
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 10.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            if (index == 0 ||
                                                                (offerlist![index]
                                                                        .couponType !=
                                                                    offerlist![
                                                                            index -
                                                                                1]
                                                                        .couponType))
                                                              Column(
                                                                children: [
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          offerlist![index].couponType == "vip"
                                                                              ? "VIP Offer"
                                                                              : "Public Offer",
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                20,
                                                                          ),
                                                                          textDirection: Constants.lang == "en"
                                                                              ? TextDirection.ltr
                                                                              : TextDirection.rtl,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  // const Divider(
                                                                  //   thickness:
                                                                  //       1,
                                                                  //   color: Colors
                                                                  //       .black,
                                                                  // ),
                                                                ],
                                                              ),
                                                            // const SizedBox(
                                                            //     height: 10),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                                color: Colors
                                                                    .green
                                                                    .shade800,
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              width: width,
                                                              child: Text(
                                                                '${offerlist![index].customerDiscount}%',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      23.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: width,
                                                              height: 190,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Text(
                                                                  Constants.lang ==
                                                                          "en"
                                                                      ? offerlist![
                                                                              index]
                                                                          .description!
                                                                      : offerlist![index]
                                                                              .arbDescription!
                                                                              .isNotEmpty
                                                                          ? offerlist![index]
                                                                              .arbDescription!
                                                                          : offerlist![index]
                                                                              .description!,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily: Constants.lang ==
                                                                            "en"
                                                                        ? "Roboto"
                                                                        : "GSSFont",
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                  textAlign: Constants
                                                                              .lang ==
                                                                          "en"
                                                                      ? TextAlign
                                                                          .left
                                                                      : TextAlign
                                                                          .right,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                })
                                        //: Container(),
                                        ),
                              ],
                            ),
                          ),
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
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: Colors.yellow.shade200,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 5.0),
                                            child: CircleAvatar(
                                              backgroundImage: const AssetImage(
                                                  "images/citycode.png"), // Use AssetImage for image assets
                                              radius: width *
                                                  0.13, // Adjust the radius to reduce the image size
                                            ),
                                          ),
                                          Column(
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
                                                margin: const EdgeInsets.only(
                                                    top: 10.0),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  widget.user_name,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.0,
                                                    fontFamily:
                                                        Constants.language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
                                // companycoupondata!.isNotEmpty||
                                widget.companyid.isNotEmpty &&
                                        widget.companyid !=
                                            "null" //&& widget.companyid!=null
                                    ? GestureDetector(
                                        onTap: () {
                                          if (amountBeforeController
                                                  .text.isNotEmpty &&
                                              !amountBeforeController.text
                                                  .contains(".")) {
                                            amountBeforeController.text =
                                                amountBeforeController.text +
                                                    ".000 OMR";
                                            amountBeforeController.selection =
                                                TextSelection.fromPosition(
                                                    TextPosition(
                                                        offset:
                                                            amountBeforeController
                                                                .text.length));
                                          } else if (amountBeforeController.text
                                                  .substring(
                                                      amountBeforeController.text
                                                          .indexOf("."))
                                                  .length >
                                              3) {
                                            amountBeforeController.text =
                                                amountBeforeController.text +
                                                    "";
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        amountBeforeController
                                                            .text.length));
                                          } else if (amountBeforeController.text
                                                  .substring(
                                                      amountBeforeController.text
                                                          .indexOf("."))
                                                  .length >
                                              2) {
                                            amountBeforeController.text =
                                                amountBeforeController.text +
                                                    "0";
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        amountBeforeController
                                                            .text.length));
                                          } else if (amountBeforeController.text
                                                  .substring(
                                                      amountBeforeController
                                                          .text
                                                          .indexOf("."))
                                                  .length >
                                              1) {
                                            amountBeforeController.text =
                                                amountBeforeController.text +
                                                    "00";
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        amountBeforeController
                                                            .text.length));
                                          } else if (amountBeforeController.text
                                              .substring(amountBeforeController
                                                  .text
                                                  .indexOf("."))
                                              .isNotEmpty) {
                                            amountBeforeController.text =
                                                amountBeforeController.text +
                                                    "000";
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        amountBeforeController
                                                            .text.length));
                                          }

                                          if (amountBeforeController
                                                  .text.isNotEmpty &&
                                              !amountBeforeController.text
                                                  .contains("OMR")) {
                                            amountBeforeController.text =
                                                amountBeforeController.text +
                                                    " OMR";
                                            amountBeforeController.selection =
                                                TextSelection.fromPosition(
                                                    TextPosition(
                                                        offset:
                                                            amountBeforeController
                                                                .text.length));
                                          }
                                        },
                                        child: InkWell(
                                          onTap: () {
                                            print("datprintbhao");
                                            if (amountBeforeController
                                                    .text.isNotEmpty &&
                                                !amountBeforeController.text
                                                    .contains(".")) {
                                              amountBeforeController.text =
                                                  amountBeforeController.text +
                                                      ".000 OMR";
                                              amountBeforeController.selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset:
                                                              amountBeforeController
                                                                  .text
                                                                  .length));
                                            } else if (amountBeforeController.text
                                                    .substring(
                                                        amountBeforeController
                                                            .text
                                                            .indexOf("."))
                                                    .length >
                                                3) {
                                              amountBeforeController.text =
                                                  amountBeforeController.text +
                                                      "";
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset:
                                                          amountBeforeController
                                                              .text.length));
                                            } else if (amountBeforeController.text
                                                    .substring(
                                                        amountBeforeController
                                                            .text
                                                            .indexOf("."))
                                                    .length >
                                                2) {
                                              amountBeforeController.text =
                                                  amountBeforeController.text +
                                                      "0";
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset:
                                                          amountBeforeController
                                                              .text.length));
                                            } else if (amountBeforeController.text
                                                    .substring(
                                                        amountBeforeController
                                                            .text
                                                            .indexOf("."))
                                                    .length >
                                                1) {
                                              amountBeforeController.text =
                                                  amountBeforeController.text +
                                                      "00";
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset:
                                                          amountBeforeController
                                                              .text.length));
                                            } else if (amountBeforeController
                                                .text
                                                .substring(amountBeforeController.text.indexOf("."))
                                                .isNotEmpty) {
                                              amountBeforeController.text =
                                                  amountBeforeController.text +
                                                      "000";
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset:
                                                          amountBeforeController
                                                              .text.length));
                                            }
                                            if (amountBeforeController
                                                    .text.isNotEmpty &&
                                                !amountBeforeController.text
                                                    .contains("OMR")) {
                                              amountBeforeController.text =
                                                  amountBeforeController.text +
                                                      " OMR";
                                              amountBeforeController.selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset:
                                                              amountBeforeController
                                                                  .text
                                                                  .length));
                                            }
                                            setState(() {
                                              position = index;
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
                                                      top: 10.0,
                                                      left: 10.0,
                                                      right: 10.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 55,
                                                        width: 130,

                                                        decoration:
                                                            BoxDecoration(
                                                                color: const Color(
                                                                    0xFFF2CC0F),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10))),
                                                        // width: width,
                                                        margin: const EdgeInsets
                                                            .only(right: 10.0),
                                                        child: Center(
                                                          child: Text(
                                                            Constants.language ==
                                                                    "en"
                                                                ? "Coupon Name"
                                                                : "Coupon Price",
                                                            style: TextStyle(
                                                                fontFamily: Constants
                                                                            .language ==
                                                                        "en"
                                                                    ? "Roboto"
                                                                    : "GSSFont",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: Constants
                                                                        .language ==
                                                                    "en"
                                                                ? TextAlign.left
                                                                : TextAlign
                                                                    .right,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        //padding: const EdgeInsets.all(10.0),
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 10.0,
                                                            left: 10.0,
                                                            right: 10.0,
                                                            bottom: 10.0),
                                                        decoration:
                                                            const BoxDecoration(
                                                                /*border: Border.all(
                                          color: Colors.black,
                                        ),*/
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child: Text(
                                                          Constants.language ==
                                                                  "en"
                                                              ? couponname
                                                              : couponname,
                                                          // companycoupondata![index].couponName.toString():companycoupondata![index].arbCouponName.toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16.0),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: width,
                                                  height: 200,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10.0),
                                                  margin: const EdgeInsets.only(
                                                      top: 10.0,
                                                      left: 10.0,
                                                      right: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.black,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
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

                                                            decoration:
                                                                BoxDecoration(
                                                                    color: const Color(
                                                                        0xFFF2CC0F),
                                                                    border: Border
                                                                        .all(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            5))),
                                                            // width: width,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right:
                                                                        10.0),
                                                            child: Center(
                                                              child: Text(
                                                                Constants.language ==
                                                                        "en"
                                                                    ? "Coupon Details"
                                                                    : "Coupon Details",
                                                                style: TextStyle(
                                                                    fontFamily: Constants.language ==
                                                                            "en"
                                                                        ? "Roboto"
                                                                        : "GSSFont",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign: Constants.language ==
                                                                        "en"
                                                                    ? TextAlign
                                                                        .left
                                                                    : TextAlign
                                                                        .right,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            // width: 240,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 45),
                                                            child: Text(
                                                              couponamounts +
                                                                  " OMR",

                                                              // companycoupondata![index].couponAmount.toString()+" OMR",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.0,
                                                                fontFamily: Constants
                                                                            .language ==
                                                                        "en"
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
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          child: Container(
                                                            width: width,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0,
                                                                    left: 5.0,
                                                                    right: 5.0),
                                                            child: Text(
                                                              Constants.lang ==
                                                                      "en"
                                                                  ? desciption
                                                                      .toString()
                                                                  : arbdescription
                                                                      .toString(),
                                                              // companycoupondata![index].couponDetails.toString():companycoupondata![index].arbCouponDetails.toString(),
                                                              style: TextStyle(
                                                                fontFamily: Constants
                                                                            .lang ==
                                                                        "en"
                                                                    ? "Roboto"
                                                                    : "GSSFont",
                                                              ),
                                                              textAlign: Constants
                                                                          .lang ==
                                                                      "en"
                                                                  ? TextAlign
                                                                      .left
                                                                  : TextAlign
                                                                      .right,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10.0,
                                                      left: 10.0,
                                                      right: 10.0,
                                                      bottom: 10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        Constants.language ==
                                                                "en"
                                                            ? "Expiration Date"
                                                            : "تاريخ انتهاء العرض",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                Constants.language ==
                                                                        "en"
                                                                    ? "Roboto"
                                                                    : "GSSFont",
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign: Constants
                                                                    .language ==
                                                                "en"
                                                            ? TextAlign.left
                                                            : TextAlign.right,
                                                      ),
                                                      Text(
                                                        coupondate.toString(),
                                                        //companycoupondata![index].endDate.toString(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign: Constants
                                                                    .language ==
                                                                "en"
                                                            ? TextAlign.left
                                                            : TextAlign.right,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ))

//   here is visibl;e card

                                    : Container(
                                        margin: const EdgeInsets.only(
                                            top: 10.0, left: 10, right: 10),
                                        // margin: const EdgeInsets.only(top: 10.0),
                                        decoration: const BoxDecoration(
                                          /*border: Border.all(
                                    color: Colors.black,
                                  ),*/
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: // offerlist!.isNotEmpty&& companycoupondata!.isNotEmpty  ///
                                            // ?
                                            Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color: Colors.green.shade800),
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              width: width,
                                              child: Text(
                                                customerdiscount,
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
                                                      Radius.circular(10),
                                                ),
                                                color: Colors.white,
                                              ),
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  discription,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        Constants.lang == "en"
                                                            ? "Roboto"
                                                            : "GSSFont",
                                                    fontSize: 14.0,
                                                  ),
                                                  textAlign:
                                                      Constants.lang == "en"
                                                          ? TextAlign.left
                                                          : TextAlign.right,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                widget.companyid.isNotEmpty &&
                                        widget.companyid != "null" &&
                                        companycoupondata!.isEmpty
                                    ? Container()
                                    : Container(),

                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  margin: const EdgeInsets.only(
                                      top: 10.0, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Colors.white),
                                  child: Focus(
                                    onFocusChange: (hasFocus) {
                                      if (hasFocus == false) {
                                        if (amountBeforeController.text
                                            .contains(".")) {
                                        } else {
                                          amountBeforeController.text
                                                  .toString() +
                                              ("000");
                                        }
                                      }
                                    },
                                    child: SizedBox(
                                      height: 45,
                                      child: KeyboardActions(
                                        config: _buildConfig(context),
                                        disableScroll: true,
                                        child: TextField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,9}'))
                                            ],
                                            keyboardType: Platform.isIOS
                                                ? const TextInputType
                                                        .numberWithOptions(
                                                    decimal: true)
                                                : TextInputType.number,
                                            focusNode:
                                                _nodeText5, //Platform.isIOS ? numberFocusNode : null,
                                            //  textInputAction: TextInputAction.done,
                                            autofocus: false,
                                            controller: amountBeforeController,
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: Constants.language ==
                                                      "en"
                                                  //? "Enter Amount Before Discount"
                                                  //: "أدخل المبلغ قبل الخصم",
                                                  ? "Enter Product Amount"
                                                  : "أدخل مبلغ المنتج",
                                              hintStyle: TextStyle(
                                                  color: Colors.black45,
                                                  fontFamily:
                                                      Constants.language == "en"
                                                          ? "Roboto"
                                                          : "GSSFont"),
                                            ),
                                            textAlign:
                                                Constants.language == "en"
                                                    ? TextAlign.left
                                                    : TextAlign.right,
                                            onChanged: (value) {
                                              // print("helooooo::::");
                                              /*             if(amountBeforeController.text.length <=6){


                                            setState(() {
                                              RegExp reg = RegExp(r'(\d{3})(?=(\d{3})+(?!\d))');
                                              String Function(Match) mathFunc = (Match match) => '${match[1]}.';
                                              amountBeforeController.text=amountBeforeController.text.replaceAllMapped(reg, mathFunc);
                                            });
                                          }
                                          else if(amountBeforeController.text.length ==7){
                                            RegExp reg = RegExp(r'(\d{3})(?=(\d{3})+(?!\d))');
                                            String Function(Match) mathFunc = (Match match) => '${match[1]}.';
                                            amountBeforeController.text=amountBeforeController.text.replaceAllMapped(reg, mathFunc);
                                          }
                                          else if(amountBeforeController.text.length ==8){
                                            RegExp reg = RegExp(r'(\d{3})(?=(\d{3})+(?!\d))');
                                            String Function(Match) mathFunc = (Match match) => '${match[1]}.';
                                            amountBeforeController.text=amountBeforeController.text.replaceAllMapped(reg, mathFunc);
                                          }
                                          else if(amountBeforeController.text.length ==9){
                                            RegExp reg = RegExp(r'(\d{4})(?=(\d{3})+(?!\d))');
                                            String Function(Match) mathFunc = (Match match) => '${match[1]}.';
                                            amountBeforeController.text=amountBeforeController.text.replaceAllMapped(reg, mathFunc);
                                          }
                                          else if(amountBeforeController.text.length ==10){
                                            RegExp reg = RegExp(r'(\d{5})(?=(\d{3})+(?!\d))');
                                            String Function(Match) mathFunc = (Match match) => '${match[1]}.';
                                            amountBeforeController.text=amountBeforeController.text.replaceAllMapped(reg, mathFunc);
                                          }
                                          else if(amountBeforeController.text.length <=13){
                                            RegExp reg = RegExp(r'(\d{6})(?=(\d{3})+(?!\d))');
                                            String Function(Match) mathFunc = (Match match) => '${match[1]}.';
                                            amountBeforeController.text=amountBeforeController.text.replaceAllMapped(reg, mathFunc);
                                          }*/
                                              // String someString=amountBeforeController.text;

                                              //  amountBeforeController.text = someString;
                                              amountBeforeController.selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset:
                                                              amountBeforeController
                                                                  .text
                                                                  .length));

                                              /* if(value.isNotEmpty){
                                           double x=double.parse(value);
                                          String y=x.toStringAsFixed(3);
                                           amountBeforeController.text=y;
                                         }*/
                                              if (value.isNotEmpty) {
                                                /*if(amountBeforeController.text.length <=4){*/
                                                var lengthamount =
                                                    amountBeforeController
                                                        .text.length;

                                                ///comenting below code
                                                /*   if(amountBeforeController.text.length==4) {
                                                 RegExp reg = RegExp(
                                                     r'(\d{1,3})(?=(\d{3})+(?!\d))');

                                                 String Function(Match) mathFunc = (
                                                     Match match) => '${match[1]}.';
                                                 value = amountBeforeController.text
                                                     .replaceAllMapped(reg, mathFunc);
                                                 print(value);
                                                 amountBeforeController.text = value;
                                                 amountBeforeController.selection =
                                                     TextSelection.fromPosition(
                                                         TextPosition(
                                                             offset: amountBeforeController
                                                                 .text.length));


                                             }  if(amountBeforeController.text.length==5) {
                                               var replaced = amountBeforeController.text.replaceAll(".", "");

                                               RegExp reg = RegExp(
                                                   r'(\d{1,3})(?=(\d{3})+(?!\d))');

                                               String Function(Match) mathFunc = (
                                                   Match match) => '${match[1]}.';

                                               value = replaced
                                                   .replaceAllMapped(reg, mathFunc);
                                               print(value);
                                               amountBeforeController.text = value;
                                               amountBeforeController.selection =
                                                   TextSelection.fromPosition(
                                                       TextPosition(
                                                           offset: amountBeforeController
                                                               .text.length));


                                             }if(amountBeforeController.text.length==6) {
                                               var replaced = amountBeforeController.text.replaceAll(".", "");

                                               RegExp reg = RegExp(
                                                   r'(\d{1,3})(?=(\d{3})+(?!\d))');

                                               String Function(Match) mathFunc = (
                                                   Match match) => '${match[1]}.';

                                               value = replaced
                                                   .replaceAllMapped(reg, mathFunc);
                                               print(value);
                                               amountBeforeController.text = value;
                                               amountBeforeController.selection =
                                                   TextSelection.fromPosition(
                                                       TextPosition(
                                                           offset: amountBeforeController
                                                               .text.length));

                                             }if(amountBeforeController.text.length==7) {
                                               var replaced = amountBeforeController.text.replaceAll(".", "");

                                               RegExp reg = RegExp(
                                                   r'(\d{1,3})(?=(\d{3})+(?!\d))');

                                               String Function(Match) mathFunc = (
                                                   Match match) => '${match[1]}.';

                                               value = replaced
                                                   .replaceAllMapped(reg, mathFunc);
                                               print(value);
                                               amountBeforeController.text = value;
                                               amountBeforeController.selection =
                                                   TextSelection.fromPosition(
                                                       TextPosition(
                                                           offset: amountBeforeController
                                                               .text.length));


                                             }
                                             if(amountBeforeController.text.length==8) {
                                               var replaced = amountBeforeController.text.replaceAll(".", "");
                                               print("replaced:::"+replaced);

                                               RegExp reg = RegExp(
                                                   r'(\d{3})(?=(\d{3})+(?!\d))');

                                               String Function(Match) mathFunc = (
                                                   Match match) => '${match[1]}.';

                                               value = replaced
                                                   .replaceAllMapped(reg, mathFunc);
                                               print(value);
                                               amountBeforeController.text = value;
                                               amountBeforeController.selection =
                                                   TextSelection.fromPosition(
                                                       TextPosition(
                                                           offset: amountBeforeController
                                                               .text.length));


                                             }if(amountBeforeController.text.length==9) {
                                               var replaced = amountBeforeController.text.replaceAll(".", "");

                                               RegExp reg = RegExp(
                                                   r'(\d{3})(?=(\d{3})+(?!\d))');

                                               String Function(Match) mathFunc = (
                                                   Match match) => '${match[1]}.';

                                               value = replaced
                                                   .replaceAllMapped(reg, mathFunc);
                                               print(value);
                                               amountBeforeController.text = value;
                                               amountBeforeController.selection =
                                                   TextSelection.fromPosition(
                                                       TextPosition(
                                                           offset: amountBeforeController
                                                               .text.length));


                                             }if(amountBeforeController.text.length==10) {
                                               var replaced = amountBeforeController.text.replaceAll(".", "");

                                               RegExp reg = RegExp(
                                                   r'(\d{4})(?=(\d{3})+(?!\d))');

                                               String Function(Match) mathFunc = (
                                                   Match match) => '${match[1]}.';

                                               value = replaced
                                                   .replaceAllMapped(reg, mathFunc);
                                               print(value);
                                               amountBeforeController.text = value;
                                               amountBeforeController.selection =
                                                   TextSelection.fromPosition(
                                                       TextPosition(
                                                           offset: amountBeforeController
                                                               .text.length));


                                             }if(amountBeforeController.text.length==11) {
                                               var replaced = amountBeforeController.text.replaceAll(".", "");

                                               RegExp reg = RegExp(
                                                   r'(\d{6})(?=(\d{3})+(?!\d))');

                                               String Function(Match) mathFunc = (
                                                   Match match) => '${match[1]}.';

                                               value = replaced
                                                   .replaceAllMapped(reg, mathFunc);
                                               print(value);
                                               amountBeforeController.text = value;
                                               amountBeforeController.selection =
                                                   TextSelection.fromPosition(
                                                       TextPosition(
                                                           offset: amountBeforeController
                                                               .text.length));


                                             }*/
                                              }
                                              double amount =
                                                  double.parse(value);
                                              double finalAmount = 0.000;
                                              if (offerlist!.isNotEmpty) {
                                                double discount = double.parse(
                                                    offerlist![position]
                                                        .customerDiscount!);
                                                double discountedAmount =
                                                    (amount / 100) * discount;
                                                finalAmount =
                                                    amount - discountedAmount;
                                              }

                                              double couponamount = 0.000;
                                              print("amounts" +
                                                  amountBeforeController.text);
                                              String nums =
                                                  amountBeforeController.text;
                                              print("numss" + nums);
                                              // double camount=double.parse(companycoupondata![position].couponAmount.toString());

                                              couponamount = amount - camount;
                                              if (couponamount.isNegative) {
                                                print("enter");
                                                couponamount = 0;
                                              }

                                              //couponamount=amount-camount;

                                              print("datacoupon" +
                                                  couponamount.toString());
                                              if (points_controller
                                                      .text.isNotEmpty &&
                                                  int.parse(points_controller
                                                          .text) >
                                                      0) {
                                                double calculate_points =
                                                    finalAmount * 10;
                                                int total_points_to_use =
                                                    calculate_points.toInt();
                                                int entered_points =
                                                    int.parse(value);
                                                int available_points =
                                                    int.parse(
                                                        widget.user_points);
                                                if (entered_points <=
                                                    available_points) {
                                                  if (entered_points <=
                                                      total_points_to_use) {
                                                    double omr =
                                                        entered_points / 10;
                                                    double finalAmount1 =
                                                        finalAmount - omr;
                                                    setState(() {
                                                      discountedTotalAmount =
                                                          finalAmount1
                                                              .toStringAsFixed(
                                                                  4);
                                                      amountAfterController
                                                          .text = finalAmount1
                                                              .toStringAsFixed(
                                                                  4) +
                                                          " OMR";
                                                      points_controller
                                                              .selection =
                                                          TextSelection.fromPosition(
                                                              TextPosition(
                                                                  offset: points_controller
                                                                      .text
                                                                      .length));
                                                    });
                                                  } else {
                                                    _alertDialog(Constants
                                                                .language ==
                                                            "en"
                                                        ? "You can use only " +
                                                            total_points_to_use
                                                                .toString() +
                                                            " Points"
                                                        : " نقاط " +
                                                            total_points_to_use
                                                                .toString() +
                                                            "يمكنك استخدام فقط ");
                                                  }
                                                } else {
                                                  _alertDialog(Constants
                                                              .language ==
                                                          "en"
                                                      ? "Customer does not have enough points"
                                                      : "العميل ليس لديه نقاط كافية");
                                                }
                                              } else if (widget.companyid ==
                                                  "null") {
                                                setState(() {
                                                  discountedTotalAmount =
                                                      finalAmount
                                                          .toStringAsFixed(3);
                                                  amountAfterController
                                                      .text = finalAmount
                                                          .toStringAsFixed(3) +
                                                      " OMR";
                                                });
                                              } else if (widget
                                                  .companyid.isNotEmpty) {
                                                print("here");
                                                setState(() {
                                                  if (amount < couponamount) {
                                                    amountAfterController.text =
                                                        "0";
                                                  }

                                                  discountedTotalAmount =
                                                      couponamount
                                                          .toStringAsFixed(3);
                                                  amountAfterController
                                                      .text = couponamount
                                                          .toStringAsFixed(3) +
                                                      " OMR";
                                                });
                                              } else {
                                                print("here my city code");
                                                setState(() {
                                                  discountedTotalAmount =
                                                      finalAmount
                                                          .toStringAsFixed(3);
                                                  amountAfterController
                                                      .text = finalAmount
                                                          .toStringAsFixed(3) +
                                                      " OMR";
                                                });

                                                ///here the code of textbox
                                              }
                                            } /* else {
                                              amountAfterController.text = "";
                                              points_controller.text = "0";
                                              points_controller.selection = TextSelection.fromPosition(TextPosition(offset: points_controller.text.length));
                                          }*/
                                            // }
                                            //}

                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  margin: const EdgeInsets.only(
                                      top: 10.0,
                                      left: 10,
                                      right: 10,
                                      bottom: 50),
                                  // margin: const EdgeInsets.only(top: 10.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Colors.white),
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
                                Visibility(
                                  visible: use_points,
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    margin: const EdgeInsets.only(top: 15.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        color: Colors.white),
                                    child: TextField(
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
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont"),
                                      ),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                      onChanged: (value) {
                                        if (amountBeforeController
                                                .text.isNotEmpty &&
                                            double.parse(amountBeforeController
                                                    .text) >
                                                0) {
                                          if (value.isNotEmpty) {
                                            double amount = double.parse(
                                                amountBeforeController.text);
                                            double discount = double.parse(
                                                offerlist![position]
                                                    .customerDiscount!);
                                            double discountedAmount =
                                                (amount / 100) * discount;
                                            double finalAmount =
                                                amount - discountedAmount;
                                            double calculate_points =
                                                finalAmount * 10;
                                            int total_points_to_use =
                                                calculate_points.toInt();
                                            int entered_points =
                                                int.parse(value);
                                            int available_points =
                                                int.parse(widget.user_points);
                                            if (entered_points <=
                                                available_points) {
                                              if (entered_points <=
                                                  total_points_to_use) {
                                                double omr =
                                                    entered_points / 10;
                                                double finalAmount1 =
                                                    finalAmount - omr;
                                                setState(() {
                                                  discountedTotalAmount =
                                                      finalAmount1
                                                          .toStringAsFixed(3);
                                                  amountAfterController
                                                      .text = finalAmount1
                                                          .toStringAsFixed(3) +
                                                      " OMR";
                                                  points_controller.selection =
                                                      TextSelection.fromPosition(
                                                          TextPosition(
                                                              offset:
                                                                  points_controller
                                                                      .text
                                                                      .length));
                                                });
                                              } else {
                                                _alertDialog(Constants
                                                            .language ==
                                                        "en"
                                                    ? "You can use only " +
                                                        total_points_to_use
                                                            .toString() +
                                                        " Points"
                                                    : " نقاط " +
                                                        total_points_to_use
                                                            .toString() +
                                                        "يمكنك استخدام فقط ");
                                              }
                                            } else {
                                              _alertDialog(Constants.language ==
                                                      "en"
                                                  ? "Customer does not have enough points"
                                                  : "العميل ليس لديه نقاط كافية");
                                            }
                                          } else {
                                            double amount = double.parse(
                                                amountBeforeController.text);
                                            double discount = double.parse(
                                                offerlist![position]
                                                    .customerDiscount!);
                                            double discountedAmount =
                                                (amount / 100) * discount;
                                            double finalAmount =
                                                amount - discountedAmount;
                                            setState(() {
                                              discountedTotalAmount =
                                                  finalAmount
                                                      .toStringAsFixed(3);
                                              amountAfterController.text =
                                                  finalAmount
                                                          .toStringAsFixed(3) +
                                                      " OMR";
                                              points_controller.selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset:
                                                              points_controller
                                                                  .text
                                                                  .length));
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: false,
                                  child: Container(
                                    width: width * 0.90,
                                    height: 50.0,
                                    margin: const EdgeInsets.all(10.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (use_points) {
                                          double amount = double.parse(
                                              amountBeforeController.text);
                                          double discount = double.parse(
                                              offerlist![position]
                                                  .customerDiscount!);
                                          double discountedAmount =
                                              (amount / 100) * discount;
                                          double finalAmount =
                                              amount - discountedAmount;
                                          setState(() {
                                            discountedTotalAmount =
                                                finalAmount.toStringAsFixed(3);
                                            amountAfterController.text =
                                                finalAmount.toStringAsFixed(3) +
                                                    " OMR" +
                                                    " + 0 Points";
                                            points_controller.text = "0";
                                            use_points = false;
                                          });
                                        } else {
                                          setState(() {
                                            use_points = true;
                                          });
                                        }
                                      },
                                      child: Text(
                                        use_points
                                            ? Constants.language == "en"
                                                ? "Remove Points"
                                                : "إزالة النقاط"
                                            : Constants.language == "en"
                                                ? "Use Points"
                                                : "استخدم النقاط",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFF2CC0F),
                                        elevation: 0.0,
                                        textStyle: const TextStyle(
                                            color: Colors.black),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: const BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                          ),
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

                  ///comenting bottmnavigation of code because buttom moving upside
                  /*bottomNavigationBar: !price_page
                    ? Container(
                        width: width * 0.10,
                        height: 50.0,
                        margin: const EdgeInsets.all(9.0),
                        child: SafeArea(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              Constants.language == "en" ? "Cancel" : "إلغاء",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily:
                                    Constants.language == "en" ? "Roboto" : "GSSFont",
                                fontSize: 18.0,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFF2CC0F),
                              elevation: 0.0,
                              textStyle: const TextStyle(color: Colors.black),
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
                      )
                    : Container(
                        color: const Color(0xFFF2CC0F),
                        child: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                   */ /* if (price_page) {
                                      setState(() {
                                        if (timer.isActive) {
                                          timer.cancel();
                                        }
                                        price_page = false;
                                      });
                                    }*/ /*
                                    if (price_page) {
                                      setState(() {
                                        amountAfterController.text = "";
                                        amountBeforeController.text = "";
                                        points_controller.text = "";
                                        price_page = false;
                                      });
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text(
                                    Constants.language == "en" ? "Back" : "رجوع",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFFF2CC0F),
                                    elevation: 0.0,
                                    textStyle: const TextStyle(color: Colors.black),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width * 0.45,
                                        30.0),
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

                                    if(amountBeforeController.text.isNotEmpty) {
                                      if (discountedTotalAmount.isNotEmpty) {
                                        if(isbuttondisabled==false){
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          isbuttondisabled=true;
                                          //amountBeforeController.clear();
                                          String payamountvalue= amountBeforeController.text.toString();
                                         print ("payamountvalue"+payamountvalue);

                                          amountBeforeController.clear();

                                        //  bool isSuccess = await _postNotification(payamountvalue);
                                       //   perchased=isSuccess;



                                         if(_clicked=="0"){
                                           _clicked="1";
                                           bool isSuccess = await _postNotification(payamountvalue);

                                           _alertDialog("Payment is Successfully Done !",

                                          );
                                           amountBeforeController.text=payamountvalue;
                                           _clicked="1";
                                           ///adding redirect code to upload screen
                                          var route = MaterialPageRoute(
                                               builder: (context) => UploadReceiptScreen(widget.city_code, discountedTotalAmount, points_controller.text, order_id, widget.company_image, widget.vip_code));
                                    Navigator.push(context, route);
                                           //  check_status(context);
                                        }
                                     */ /*     if(perchased){
                                          _alertDialog("payment is Succesfully Done !");
                                        }
*/ /*
                                */ /*        else if(isSuccess) {
                                          //  amountBeforeController.clear();
                                        //    amountAfterController.clear();
                                            _alertDialog(Constants.language == "en"
                                                ? "Confirmation Sent Successfully !"
                                                : "تم إرسال التأكيد بنجاح!");
                                            check_status(context);

                                            isbuttondisabled=false;
                                            amountBeforeController.text=payamountvalue;

                                          }*/ /*



                                          else {
                                           amountBeforeController.text=payamountvalue;
                                           _alertDialog("Payment Already Done !",
                                           );
                                          */ /*  _alertDialog(Constants.language == "en"
                                                ? "Failed to send confirmation"
                                                : "فشل في إرسال التأكيد");*/ /*
                                            isbuttondisabled=false;
                                          }
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
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(

                                    primary: const Color(0xFFF2CC0F),
                                    elevation: 0.0,
                                    textStyle: const TextStyle(color: Colors.black),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width * 0.45,
                                        30.0),
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
                      ),*/
                  ///comenting ending of bottomnavigation
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  check_status(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      Route route;
      _postAcceptStatus().then((value) => {
            if (value)
              {
                timer.cancel(),
                route = MaterialPageRoute(
                    builder: (context) => UploadReceiptScreen(
                        widget.city_code,
                        discountedTotalAmount,
                        points_controller.text,
                        order_id,
                        widget.company_image,
                        widget.vip_code)),
                Navigator.push(context, route),
              }
          });
    });
  }

  Future<CompanyOfferModel> _getCompanyOffers() async {
    final body = {
      "company_id": Constants.company_id,
      "branch_id": Constants.branch_id,
      "user_code": widget
          .city_code, //widget.vip_code.isEmpty ? widget.city_code : widget.vip_code,
      "vip_org_code":
          widget.vip_code, //widget.vip_code.isEmpty?widget.org:widget.vip_code,
      "type": widget.companyid.isNotEmpty && widget.companyid != "null"
          ? "coupon"
          : "",
      // "type":"coupon",
    };

    final response = await http.post(
      Uri.parse(
          'http://185.188.127.11/public/index.php/ApiCompany/companyoffer'),
      body: body,
    );

    var responseServer = jsonDecode(response.body);
    response_display = responseServer["messages"]["success"];
    var offer = responseServer["offerlist"];

/*    if(response.statusCode == 202){
      if (responseServer["status"] == 202) {

        throw Exception('Failed to load album');
       */ /* Fluttertoast.showToast(
            msg: responseServer,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        return CompanyOfferModel.fromJson(json.decode(response.body));*/ /*

      }

    }*/

    if (kDebugMode) {
      /*for(var data in offer){
        data.
      }*/
      print("bhaii" + responseServer.toString());
      print("Constants.company_id" + Constants.company_id);
      print("Constants.branch_id" + Constants.branch_id);
      print("widget.city_code" + widget.city_code);
      print("widget.vip_code" + widget.vip_code);

      /* price_page=false;
      Fluttertoast.showToast(
          msg: responseServer["messages"]["success"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);*/
    }

    if (response.statusCode == 201) {
      if (responseServer["status"] == 201) {
        return CompanyOfferModel.fromJson(json.decode(response.body));
      } else {
        setState(() {
          _isLoading = false;
        });

        price_page = false;
        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      throw Exception('Invalid Code.');
    }
  }

  Future<bool> _postNotification(String payamountvalue) async {
    final body = {
      "userid": widget.user_id,
      "companyid": Constants.company_id,
      "branchid": Constants.branch_id,
      "discount": widget.perchasedid.isEmpty
          ? offerlist![position].customerDiscount!
          : couponamounts,
      "totalamount": payamountvalue,
      "paidamount": discountedTotalAmount,
      "redeempoint": points_controller.text,
      "offer_id": offerlist![position].id,
      "notificationtype": "user",
      "product_id": "",
      "coupon_purchase_id": widget.perchasedid,
      "coupon_id": widget.companyid,
    };

    final response = await http.post(
      Uri.parse('http://185.188.127.11/public/index.php/notification'),
      body: body,
    );

    var responseServer = jsonDecode(response.body);

    if (kDebugMode) {
      print("widget.user_id" + widget.user_id);
      print("Constants.company_id" + Constants.company_id);
      print("Constants.branch_id" + Constants.branch_id);
      print("offerlist![position].customerDiscount!" +
          offerlist![position].customerDiscount!);
      print("payamountvalue" + payamountvalue);
      print("discountedTotalAmount" + discountedTotalAmount);
      print("points_controller.text" + points_controller.text);
      print("offerlist![position].id" + offerlist![position].id.toString());
      print("perchasedid" + widget.perchasedid);
      print("coupon_id" + widget.companyid);
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
      print("widget.user_id" + widget.user_id);
      print("Constants.company_id" + Constants.company_id);
      print("Constants.branch_id" + Constants.branch_id);
      print("offerlist![position].customerDiscount!" +
          offerlist![position].customerDiscount!);
      print("payamountvalue" + payamountvalue);
      print("discountedTotalAmount" + discountedTotalAmount);
      print("points_controller.text" + points_controller.text);
      print("offerlist![position].id" + offerlist![position].id.toString());
      print("error");
      setState(() {
        _isLoading = false;
      });
      return false;
    }
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
