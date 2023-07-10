// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_final_fields, unused_field, avoid_print, deprecated_member_use, unnecessary_new, avoid_unnecessary_containers, unused_local_variable, avoid_types_as_parameter_names, prefer_typing_uninitialized_variables, unused_label, unrelated_type_equality_checks, body_might_complete_normally_catch_error, dead_code, unused_element, unnecessary_brace_in_string_interps, file_names

import 'dart:async';
import 'dart:convert';
import 'package:city_code/Screens/vip_code_screen.dart';
import 'package:city_code/models/favourite_model.dart';
//import 'package:city_code/models/new_offers_model.dart';
import 'package:city_code/models/vip_list_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class VipCodeScreen extends StatefulWidget {
  const VipCodeScreen({Key? key}) : super(key: key);

  @override
  _VipCodeScreenState createState() => _VipCodeScreenState();
}

class _VipCodeScreenState extends State<VipCodeScreen> {
  TextInputType inputType = TextInputType.text;
  TextEditingController vip_code_controller = TextEditingController();
  FocusNode vipFocusNode = FocusNode();

  bool _isLoading = false;
  List<Userdetail>? userdetail = [];
  List<VipOffers>? vipOffers = [];
  late Future<Favourite_model> favourite_offers = _getFavouriteOffers();
  List<String> fav = [];
  String vipCode = "", customerName = "", company_image_base_url = "";

  Future<Favourite_model> _getFavouriteOffers() async {
    final response = await http.get(Uri.parse(
        'http://185.188.127.11/public/index.php/ApiFavorate?customer_id=' +
            Constants.user_id));
    if (response.statusCode == 201) {
      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }
      if (response_server["status"] == 201) {
        return Favourite_model.fromJson(jsonDecode(response.body));
      } else {
        getVipList().then((value) => {
              if (value.userdetail != null && value.userdetail!.isNotEmpty)
                {
                  if (value.vipOffers != null && value.vipOffers!.isNotEmpty)
                    {
                      for (int i = 0; i < value.vipOffers!.length; i++)
                        {
                          vipOffers!.add(value.vipOffers![i]),
                          fav.add("0"),
                        },
                    }
                },
              setState(() {
                company_image_base_url = value.companyBaseUrl!;
                vipCode = value.userdetail![0].vipCode!;
                customerName = Constants.language == "en"
                    ? value.userdetail![0].name!
                    : value.userdetail![0].arbName!.isNotEmpty
                        ? value.userdetail![0].arbName!
                        : value.userdetail![0].name!;
                _isLoading = false;
              }),
            });
        throw Exception('Failed to load album');
      }
    } else {
      getVipList().then((value) => {
            if (value.userdetail != null && value.userdetail!.isNotEmpty)
              {
                if (value.vipOffers != null && value.vipOffers!.isNotEmpty)
                  {
                    for (int i = 0; i < value.vipOffers!.length; i++)
                      {
                        vipOffers!.add(value.vipOffers![i]),
                        fav.add("0"),
                      },
                  }
              },
            setState(() {
              company_image_base_url = value.companyBaseUrl!;
              vipCode = value.userdetail![0].vipCode!;
              customerName = Constants.language == "en"
                  ? value.userdetail![0].name!
                  : value.userdetail![0].arbName!.isNotEmpty
                      ? value.userdetail![0].arbName!
                      : value.userdetail![0].name!;
              _isLoading = false;
            }),
          });
      throw Exception('Failed to load album');
    }
  }

  Future<VipListModel> getVipList() async {
    final response = await http.get(
      Uri.parse('http://185.188.127.11/public/index.php/showvip?vip_code=' +
          vip_code_controller.text),
    );

    var response_server = jsonDecode(response.body);

    if (kDebugMode) {
      print(response_server);
    }

    if (response.statusCode == 200) {
      if (response_server["status"] == 201) {
        return VipListModel.fromJson(json.decode(response.body));
      } else {
        setState(() {
          _isLoading = false;
        });
        if (Constants.language == "en") {
          _alertDialog("No Data Found");
        } else {
          _alertDialog("لاتوجد بيانات");
        }
        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == 404) {
        if (Constants.language == "en") {
          _alertDialog("No Data Found");
        } else {
          _alertDialog("لاتوجد بيانات");
        }
      } else {
        if (Constants.language == "en") {
          _alertDialog("Something went wrong");
        } else {
          _alertDialog("هناك خطأ ما");
        }
      }
      throw Exception('Failed to load album');
    }
  }

  @override
  void dispose() {
    vipFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Directionality(
        textDirection:
            Constants.language == "en" ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xFFF2CC0F),
          body: Container(
            height: height,
            margin: const EdgeInsets.all(10.0),
            color: const Color(0xFFFCF4C6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Container(
                          height: 50.0,
                          padding: const EdgeInsets.only(right: 6.0),
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 10.0,
                                ),
                                width: 175.0,
                                child: TextField(
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  focusNode: vipFocusNode,
                                  controller: vip_code_controller,
                                  keyboardType: inputType,
                                  maxLines: 1,
                                  cursorColor: Colors.white,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'VIP Code',
                                    hintStyle: TextStyle(color: Colors.black45),
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
                              GestureDetector(
                                onTap: () {
                                  if (vip_code_controller.text.isNotEmpty) {
                                    if (vip_code_controller.text.length == 5) {
                                      RegExp exp =
                                          RegExp(r"(([a-zA-Z]{1}\d{4}))");
                                      bool matches = exp
                                          .hasMatch(vip_code_controller.text);
                                      if (matches) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        _getFavouriteOffers().then((favvalue) =>
                                            {
                                              getVipList().then((value) => {
                                                    if (value.userdetail !=
                                                            null &&
                                                        value.userdetail!
                                                            .isNotEmpty)
                                                      {
                                                        if (value.vipOffers !=
                                                                null &&
                                                            value.vipOffers!
                                                                .isNotEmpty)
                                                          {
                                                            for (int i = 0;
                                                                i <
                                                                    value
                                                                        .vipOffers!
                                                                        .length;
                                                                i++)
                                                              {
                                                                vipOffers!.add(
                                                                    value.vipOffers![
                                                                        i]),
                                                                fav.add("0"),
                                                              },
                                                            if (favvalue.favouratelist !=
                                                                    null &&
                                                                favvalue
                                                                    .favouratelist!
                                                                    .isNotEmpty)
                                                              {
                                                                if (vipOffers !=
                                                                        null &&
                                                                    vipOffers!
                                                                        .isNotEmpty)
                                                                  {
                                                                    for (int i =
                                                                            0;
                                                                        i < favvalue.favouratelist!.length;
                                                                        i++)
                                                                      {
                                                                        for (int j =
                                                                                0;
                                                                            j < vipOffers!.length;
                                                                            j++)
                                                                          {
                                                                            if (favvalue.favouratelist![i].offerId ==
                                                                                vipOffers![j].id)
                                                                              {
                                                                                fav[j] = "1",
                                                                              }
                                                                          }
                                                                      }
                                                                  }
                                                              }
                                                          }
                                                      },
                                                    /* if(value.userdetail!.isEmpty){
                            setState(() {
                                _isLoading = false;
                            }),
                                  print("ghjghgsfgahsfs"),


                                  _alertDialog(Constants.language == "en"
                                      ? "Please enter valid vip code"
                                      : "الرجاء إدخال صالح Code vip"),
                                },*/

                                                    setState(() {
                                                      company_image_base_url =
                                                          value.companyBaseUrl!;

                                                      vipCode = value
                                                          .userdetail![0]
                                                          .vipCode!;

                                                      Route route = MaterialPageRoute(
                                                          builder: (context) =>
                                                              VipCodeScreen_2(
                                                                  true,
                                                                  vip_code_controller
                                                                      .text,
                                                                  "home"));
                                                      Navigator.push(
                                                          context, route);

                                                      print("vipro" + vipCode);
                                                      customerName = Constants
                                                                  .language ==
                                                              "en"
                                                          ? value.userdetail![0]
                                                              .name!
                                                          : value
                                                                  .userdetail![
                                                                      0]
                                                                  .arbName!
                                                                  .isNotEmpty
                                                              ? value
                                                                  .userdetail![
                                                                      0]
                                                                  .arbName!
                                                              : value
                                                                  .userdetail![
                                                                      0]
                                                                  .name!;
                                                      _isLoading = false;
                                                    }),
                                                  }),
                                            });
                                      } else {
                                        _alertDialog(Constants.language == "en"
                                            ? "Please enter valid vip code"
                                            : "الرجاء إدخال صالح Code vip");
                                      }
                                    } else {
                                      _alertDialog(Constants.language == "en"
                                          ? "Please enter valid vip code"
                                          : "الرجاء إدخال صالح Code vip");
                                    }
                                  } else {
                                    _alertDialog(Constants.language == "en"
                                        ? "Please enter vip code"
                                        : "الرجاء إدخال Code vip");
                                  }
                                },
                                child: const Icon(
                                  CupertinoIcons.search,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: width,
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 10.0, right: 10.0),
                          child: Text(
                            "VIP Code:",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont"),
                            textAlign: Constants.language == "en"
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                        ),
                        Container(
                          width: width,
                          margin: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: Text(
                            Constants.language == "en"
                                ? "A special and exclusive discount code only for employees of government and private agencies and students of all kinds of faculty."
                                : "كود خصم خاص وحصري فقط لموظفين الجهات الحكومية والخاصة وطلاب الهيئات التدريسية بكافة أنواعها.",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont"),
                            textAlign: Constants.language == "en"
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                        ),
                        Container(
                          width: width,
                          margin: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: Text(
                            Constants.language == "en"
                                ? "Where a special and exclusive discount code has been allocated to each entity that enables its employees or students to obtain a higher discount rate than public discounts and Friday discounts."
                                : "حيث تم تخصيص كود خصم خاص وحصري لكل جهة يُمكن موظفيها أو طلابها من الحصول على نسبة خصم اعلى من التخفيضات العامة وتخفيضات الجمعة.",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont"),
                            textAlign: Constants.language == "en"
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                        ),
                        Container(
                          width: width,
                          margin: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: Text(
                            Constants.language == "en"
                                ? "All you have to do is write the VIP Code obtained from your workplace in the search box and find out the companies covered by this code and take advantage of them."
                                : "كل ما عليك فعله هو كتابة كود الخصم الحاصل عليه من مقر عملك في خانة البحث ومعرفة الشركات التي يشملها هذا الكود والاستفادة منها .",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont"),
                            textAlign: Constants.language == "en"
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                        ),
                      ],
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
                ////////////////here Search button error
                Container(
                  width: width,
                  margin: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      if (vip_code_controller.text.isNotEmpty) {
                        if (vip_code_controller.text.length == 5) {
                          RegExp exp = RegExp(r"(([a-zA-Z]{1}\d{4}))");
                          bool matches = exp.hasMatch(vip_code_controller.text);
                          if (matches) {
                            setState(() {
                              _isLoading = true;
                            });
                            _getFavouriteOffers().then((favvalue) => {
                                  getVipList().then((value) => {
                                        if (value.userdetail != null &&
                                            value.userdetail!.isNotEmpty)
                                          {
                                            if (value.vipOffers != null &&
                                                value.vipOffers!.isNotEmpty)
                                              {
                                                for (int i = 0;
                                                    i < value.vipOffers!.length;
                                                    i++)
                                                  {
                                                    vipOffers!.add(
                                                        value.vipOffers![i]),
                                                    fav.add("0"),
                                                  },
                                                if (favvalue.favouratelist !=
                                                        null &&
                                                    favvalue.favouratelist!
                                                        .isNotEmpty)
                                                  {
                                                    if (vipOffers != null &&
                                                        vipOffers!.isNotEmpty)
                                                      {
                                                        for (int i = 0;
                                                            i <
                                                                favvalue
                                                                    .favouratelist!
                                                                    .length;
                                                            i++)
                                                          {
                                                            for (int j = 0;
                                                                j <
                                                                    vipOffers!
                                                                        .length;
                                                                j++)
                                                              {
                                                                if (favvalue
                                                                        .favouratelist![
                                                                            i]
                                                                        .offerId ==
                                                                    vipOffers![
                                                                            j]
                                                                        .id)
                                                                  {
                                                                    fav[j] =
                                                                        "1",
                                                                  }
                                                              }
                                                          }
                                                      }
                                                  }
                                              }
                                          },
                                        /* if(value.userdetail!.isEmpty){
                            setState(() {
                                _isLoading = false;
                            }),
                                  print("ghjghgsfgahsfs"),


                                  _alertDialog(Constants.language == "en"
                                      ? "Please enter valid vip code"
                                      : "الرجاء إدخال صالح Code vip"),
                                },*/

                                        setState(() {
                                          company_image_base_url =
                                              value.companyBaseUrl!;

                                          vipCode =
                                              value.userdetail![0].vipCode!;

                                          Route route = MaterialPageRoute(
                                              builder: (context) =>
                                                  VipCodeScreen_2(
                                                      true,
                                                      vip_code_controller.text,
                                                      "home"));
                                          Navigator.push(context, route);

                                          print("vipro" + vipCode);
                                          customerName = Constants.language ==
                                                  "en"
                                              ? value.userdetail![0].name!
                                              : value.userdetail![0].arbName!
                                                      .isNotEmpty
                                                  ? value
                                                      .userdetail![0].arbName!
                                                  : value.userdetail![0].name!;
                                          _isLoading = false;
                                        }),
                                      }),
                                });
                          } else {
                            _alertDialog(Constants.language == "en"
                                ? "Please enter valid vip code"
                                : "الرجاء إدخال صالح Code vip");
                          }
                        } else {
                          _alertDialog(Constants.language == "en"
                              ? "Please enter valid vip code"
                              : "الرجاء إدخال صالح Code vip");
                        }
                      } else {
                        _alertDialog(Constants.language == "en"
                            ? "Please enter vip code"
                            : "الرجاء إدخال Code vip");
                      }
                    },
                    child: Text(
                      Constants.language == "en" ? "SEARCH" : "بحث",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontSize: 18.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFF2CC0F),
                      fixedSize: Size(width, 40),
                      elevation: 0.0,
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
