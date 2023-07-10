// ignore_for_file: must_be_immutable, camel_case_types, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:city_code/Screens/offer_details_screen.dart';
import 'package:city_code/models/favourite_model.dart';
import 'package:city_code/models/vip_list_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'home_screen.dart';

class VipCodeScreen_2 extends StatefulWidget {
  bool vipOffers;
  String vip_code, which_page;

  VipCodeScreen_2(this.vipOffers, this.vip_code, this.which_page, {Key? key})
      : super(key: key);

  @override
  _VipCodeScreen_2State createState() => _VipCodeScreen_2State();
}

class _VipCodeScreen_2State extends State<VipCodeScreen_2> {
  TextEditingController vip_code_controller = TextEditingController();
  TextInputType inputType = TextInputType.text;

  bool _isLoading = false;
  List<Userdetail>? userdetail = [];
  List<VipOffers>? vipOffers = [];
  late Future<Favourite_model> favourite_offers = _getFavouriteOffers();
  List<String> fav = [];
  String vipCode = "", customerName = "", company_image_base_url = "";
  late FocusNode vipFocusNode = FocusNode();

  Future<Favourite_model> _getFavouriteOffers() async {
    final response = await http.get(Uri.parse(
        'http://185.188.127.11/public/index.php/ApiFavorate?customer_id=' +
            Constants.user_id));
    if (response.statusCode == 201) {
      var responseServer = jsonDecode(response.body);

      if (kDebugMode) {
        print(responseServer);
      }
      if (responseServer["status"] == 201) {
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
                widget.vipOffers = true;
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
              widget.vipOffers = true;
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

    var responseServer = jsonDecode(response.body);

    if (kDebugMode) {
      print(responseServer);
    }

    if (response.statusCode == 200) {
      if (responseServer["status"] == 201) {
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
    // Clean up the focus node when the Form is disposed.
    vipFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.vipOffers) {
      setState(() {
        _isLoading = true;
        vip_code_controller.text = widget.vip_code;
      });
      _getFavouriteOffers().then((favvalue) => {
            getVipList().then((value) => {
                  if (value.userdetail != null && value.userdetail!.isNotEmpty)
                    {
                      if (value.vipOffers != null &&
                          value.vipOffers!.isNotEmpty)
                        {
                          for (int i = 0; i < value.vipOffers!.length; i++)
                            {
                              vipOffers!.add(value.vipOffers![i]),
                              fav.add("0"),
                            },
                          if (favvalue.favouratelist != null &&
                              favvalue.favouratelist!.isNotEmpty)
                            {
                              if (vipOffers != null && vipOffers!.isNotEmpty)
                                {
                                  for (int i = 0;
                                      i < favvalue.favouratelist!.length;
                                      i++)
                                    {
                                      for (int j = 0;
                                          j < vipOffers!.length;
                                          j++)
                                        {
                                          if (favvalue
                                                  .favouratelist![i].offerId ==
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
                  setState(() {
                    company_image_base_url = value.companyBaseUrl!;

                    vipCode = value.userdetail![0].vipCode!;
                    widget.vipOffers = true;
                    customerName = Constants.language == "en"
                        ? value.userdetail![0].name!
                        : value.userdetail![0].arbName!.isNotEmpty
                            ? value.userdetail![0].arbName!
                            : value.userdetail![0].name!;
                    _isLoading = false;
                  }),
                }),
          });
    }
    super.initState();
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    if (widget.which_page == "home") {
      return true;
    } else if (widget.vipOffers) {
      setState(() {
        widget.vipOffers = false;
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
      child: Stack(
        children: [
          widget.vipOffers
              ? vipOffersWidget(width, height)
              : vipCodeWidget(width, height),
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

  _ShowDialog(BuildContext context, String data, String vipcodedata) {
    Dialog purchaseDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: SizedBox(
        height: 450,
        child: Column(
          children: <Widget>[
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(),
                  IconButton(
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    icon: const Icon(CupertinoIcons.clear_circled_solid),
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            /*SizedBox(
              width: 270,
              child: Text(
                Constants.language == "en"
                    ? "Your transaction code is :"
                    : ": رمز معاملتك هو",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily:
                  Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),*/
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: const Text(
                "",
                // vipcodedata.toString(),
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: GestureDetector(
                onTap: () {
                  print("databhai:" + data.toString());
                },
                child: QrImage(
                  data: data.toString(),
                  version: QrVersions.auto,
                  size: 320,
                ),
              ),
            ),
            /*Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Text(
                Constants.language == "en"
                    ? "Your QR code"
                    : "رمز معاملتك صالح لمدة 5 دقائق فقط",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                ),
                textAlign: TextAlign.center,
              ),
            ),*/
          ],
        ),
      ),
    );

    showDialog(
        context: context, builder: (BuildContext context) => purchaseDialog);
  }

  Widget vipOffersWidget(double width, double height) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2CC0F),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF2CC0F),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          color: Colors.black,
          onPressed: () {
            if (widget.which_page == "home") {
              Navigator.of(context).pop();
            } else {
              setState(() {
                widget.vipOffers = false;
              });
            }
          },
        ),
        title: Text(
          "VIP Code",
          style: TextStyle(
            color: Colors.black,
            fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final qrdata = {
                "vipcode": vipCode,
                "vipcodeqr": vipCode,
                "citycodeqr": Constants.city_code
              };
              bool result = await InternetConnectionChecker().hasConnection;
              if (result) {
                _ShowDialog(context, jsonEncode(qrdata).toString(), "");
                //getQrCode(context);
              } else {}
            },
            icon: const Icon(
              CupertinoIcons.qrcode,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: Constants.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Text(
                  vipCode,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Text(
                  customerName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
              ),
              Container(
                width: width,
                margin: const EdgeInsets.only(
                    top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                child: Text(
                  Constants.language == "en"
                      ? "List of companies to which the VIP Code applies"
                      : "قائمة الشركات التي ينطبق عليها VIP Code ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                  textAlign: Constants.language == "en"
                      ? TextAlign.left
                      : TextAlign.right,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: vipOffers!.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: width / 635,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => OfferDetailsScreen(
                                Constants.language == "en"
                                    ? vipOffers![index].companyName!
                                    : vipOffers![index]
                                            .companyArbName!
                                            .isNotEmpty
                                        ? vipOffers![index].companyArbName!
                                        : vipOffers![index].companyName!,
                                vipOffers![index].companyId!,
                                vipOffers![index].discountdisplay!,
                                vipOffers![index].id!,
                                fav[index],
                                "city",
                                "",
                                "",
                                "",
                                ""));
                        Navigator.push(context, route);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: const Color(0xFFE6D997),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 76,
                              child: CircleAvatar(
                                radius: width * 0.10,
                                backgroundImage: NetworkImage(
                                    company_image_base_url +
                                        vipOffers![index].companylogo!),
                              ),
                              margin: const EdgeInsets.only(
                                  left: 2.0, right: 2.0, top: 2.0),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                Constants.language == "en"
                                    ? vipOffers![index].displayName!
                                    : vipOffers![index]
                                            .displayArbName!
                                            .isNotEmpty
                                        ? vipOffers![index].displayArbName!
                                        : vipOffers![index].displayName!,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : vipOffers![index]
                                                .displayArbName!
                                                .isNotEmpty
                                            ? "GSSFont"
                                            : "Roboto",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 1.0),
                              child: Text(
                                vipOffers![index].discountdisplay!,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 1.0),
                              child: Text(
                                Constants.language == "en"
                                    ? vipOffers![index].discountEnDetail!
                                    : vipOffers![index].discountArbDetail!,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontSize: 12.0),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 1.0, left: 3.0, right: 3.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2.0),
                                    // width: width * 0.08,
                                    width: width * 0.12,
                                    margin: const EdgeInsets.only(
                                        left: 1.0, right: 1.0),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: Column(
                                      children: [
                                        Text(
                                          Constants.language == "en"
                                              ? "Days"
                                              : "يوم",
                                          style: TextStyle(
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8.0),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          vipOffers![index].remainingday!,
                                          style: const TextStyle(
                                            fontSize: 8.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  /*Container(
                                    padding: const EdgeInsets.all(2.0),
                                    margin: const EdgeInsets.only(
                                        left: 1.0, right: 1.0),
                                    width: width * 0.08,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: Column(
                                      children: [
                                        Text(
                                          Constants.language == "en"
                                              ? "Hours"
                                              : "ساعة",
                                          style: TextStyle(
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8.0),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          vipOffers![index].remaininghours!,
                                          style: const TextStyle(
                                            fontSize: 8.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),*/
                                  Container(
                                    padding: const EdgeInsets.all(2.0),
                                    margin: const EdgeInsets.only(
                                        left: 1.0, right: 1.0),
                                    // width: width * 0.10,
                                    width: width * 0.12,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: Column(
                                      children: [
                                        Text(
                                          Constants.language == "en"
                                              ? "Views"
                                              : "مشاهدة",
                                          style: TextStyle(
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8.0),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          vipOffers![index].viewCount!,
                                          style: const TextStyle(
                                            fontSize: 8.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 1.0, bottom: 10.0),
                              child: Text(
                                Constants.language == "en"
                                    ? "Remaining Time"
                                    : "الوقت المتبقي",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontSize: 8.0),
                                textAlign: TextAlign.center,
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
      ),
    );
  }

  Widget vipCodeWidget(double width, double height) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF4C6),
      resizeToAvoidBottomInset: true,
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "VIP Code",
              style: TextStyle(
                color: Colors.black,
                fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: const Icon(
                CupertinoIcons.star_fill,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => HomeScreen("0", ""),
                ),
                (route) => false,
              );
            },
            icon: const Icon(CupertinoIcons.home),
            color: Colors.black,
          )
        ],
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: Constants.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: height * 0.72,
                  child: Column(
                    children: [
                      const Image(image: AssetImage("images/app_icon.png")),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 10.0),
                                      width: 278.0,
                                      child: TextField(
                                        focusNode: vipFocusNode,
                                        keyboardType: inputType,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        controller: vip_code_controller,
                                        maxLines: 1,
                                        cursorColor: Colors.black,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'VIP Code',
                                          hintStyle:
                                              TextStyle(color: Colors.black45),
                                        ),
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            vipFocusNode.unfocus();
                                            setState(() {
                                              inputType = TextInputType.text;
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 75), () {
                                                vipFocusNode.requestFocus();
                                              });
                                            });
                                          } else if (value.length == 1) {
                                            vipFocusNode.unfocus();
                                            setState(() {
                                              inputType = TextInputType.number;
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 75), () {
                                                vipFocusNode.requestFocus();
                                              });
                                            });
                                          } else if (value.length == 5) {
                                            vipFocusNode.unfocus();
                                          }
                                        },
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (vip_code_controller
                                              .text.isNotEmpty) {
                                            if (vip_code_controller
                                                    .text.length ==
                                                5) {
                                              RegExp exp = RegExp(
                                                  r"(([a-zA-Z]{1}\d{4}))");
                                              bool matches = exp.hasMatch(
                                                  vip_code_controller.text);
                                              if (matches) {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                _getFavouriteOffers()
                                                    .then((favvalue) => {
                                                          getVipList()
                                                              .then((value) => {
                                                                    if (value.userdetail !=
                                                                            null &&
                                                                        value
                                                                            .userdetail!
                                                                            .isNotEmpty)
                                                                      {
                                                                        if (value.vipOffers !=
                                                                                null &&
                                                                            value.vipOffers!.isNotEmpty)
                                                                          {
                                                                            for (int i = 0;
                                                                                i < value.vipOffers!.length;
                                                                                i++)
                                                                              {
                                                                                vipOffers!.add(value.vipOffers![i]),
                                                                                fav.add("0"),
                                                                              },
                                                                            if (favvalue.favouratelist != null &&
                                                                                favvalue.favouratelist!.isNotEmpty)
                                                                              {
                                                                                if (vipOffers != null && vipOffers!.isNotEmpty)
                                                                                  {
                                                                                    for (int i = 0; i < favvalue.favouratelist!.length; i++)
                                                                                      {
                                                                                        for (int j = 0; j < vipOffers!.length; j++)
                                                                                          {
                                                                                            if (favvalue.favouratelist![i].offerId == vipOffers![j].id)
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

                                                                    setState(
                                                                        () {
                                                                      company_image_base_url =
                                                                          value
                                                                              .companyBaseUrl!;

                                                                      vipCode = value
                                                                          .userdetail![
                                                                              0]
                                                                          .vipCode!;

                                                                      Route route = MaterialPageRoute(
                                                                          builder: (context) => VipCodeScreen_2(
                                                                              true,
                                                                              vip_code_controller.text,
                                                                              "home"));
                                                                      Navigator.push(
                                                                          context,
                                                                          route);

                                                                      print("vipro" +
                                                                          vipCode);
                                                                      customerName = Constants.language ==
                                                                              "en"
                                                                          ? value
                                                                              .userdetail![0]
                                                                              .name!
                                                                          : value.userdetail![0].arbName!.isNotEmpty
                                                                              ? value.userdetail![0].arbName!
                                                                              : value.userdetail![0].name!;
                                                                      _isLoading =
                                                                          false;
                                                                    }),
                                                                  }),
                                                        });
                                              } else {
                                                _alertDialog(Constants
                                                            .language ==
                                                        "en"
                                                    ? "Please enter valid vip code"
                                                    : "الرجاء إدخال صالح Code vip");
                                              }
                                            } else {
                                              _alertDialog(Constants.language ==
                                                      "en"
                                                  ? "Please enter valid vip code"
                                                  : "الرجاء إدخال صالح Code vip");
                                            }
                                          } else {
                                            _alertDialog(
                                                Constants.language == "en"
                                                    ? "Please enter vip code"
                                                    : "الرجاء إدخال Code vip");
                                          }
                                        },
                                        child: const Icon(
                                          CupertinoIcons.search,
                                          color: Colors.black,
                                        ),
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
                    ],
                  ),
                ),
                Container(
                  width: width,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                                        /*if(value.userdetail!.isEmpty){
                                      print("ghjghgsfgahsfs"),
                                      setState(() {
                                           _isLoading = false;
                                      }),

                            _alertDialog(Constants.language == "en"
                            ? "Please enter valid vip code"
                                : "الرجاء إدخال صالح Code vip"),
                                    },*/

                                        setState(() {
                                          company_image_base_url =
                                              value.companyBaseUrl!;

                                          vipCode =
                                              value.userdetail![0].vipCode!;

                                          widget.vipOffers = true;

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
                      backgroundColor: const Color(0xFFF2CC0F),
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
