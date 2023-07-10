// ignore_for_file: non_constant_identifier_names, file_names, unused_element, unused_local_variable, avoid_print, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:city_code/Screens/web_view_screen.dart';
import 'package:city_code/models/favourite_model.dart';
//import 'package:city_code/models/new_offers_model.dart';
import 'package:city_code/models/online_shop_model.dart';
import 'package:city_code/models/online_shop_offer_ads_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../models/ads_list_model.dart';
import '../models/advertisement_model.dart';
import 'offer_details_screen.dart';

class OnlineShopScreen extends StatefulWidget {
  const OnlineShopScreen({Key? key}) : super(key: key);

  @override
  _OnlineShopScreenState createState() => _OnlineShopScreenState();
}

class _OnlineShopScreenState extends State<OnlineShopScreen> {
  bool _isLoading = true;
  late Future<Favourite_model> favourite_offers = _getFavouriteOffers();
  List<Companylist>? offersList = [];
  List<Companylist>? offersList_ads = [];
  List<Favouratelist>? favList = [];
  List<OnlineOfferAdsModel> offerads_model = [];
  List<AdsListModel> adsList = [];
  List<String> fav = [];
  String company_image_base_url = "";
  NetworkCheck networkCheck = NetworkCheck();
  String ads_image_base_url = "";
  var scrollcontroller = ScrollController();
  int _pageSize = 0, page = 1, maxPage = 0;
  bool _isPaginationLoading = false;

  Future<OnlineShopModel> _getOnlineOffers(int page) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/onlineshop?page=$page'));
      if (response.statusCode == 201) {
        var responseServer = jsonDecode(response.body);

        if (kDebugMode) {
          print(responseServer);
        }
        if (responseServer["status"] == 201) {
          return OnlineShopModel.fromJson(jsonDecode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          if (Constants.language == "en") {
            _alertDialog("No Offers Available");
          } else {
            _alertDialog("لا توجد عروض متاحة");
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
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      throw Exception('Failed to load album');
    }
  }

  Future<AdvertisementModel> _getAds() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(
          Uri.parse('http://185.188.127.11/public/index.php/getdashboardadd'));
      if (response.statusCode == 201) {
        var responseServer = jsonDecode(response.body);

        if (kDebugMode) {
          print(responseServer);
        }
        if (responseServer["status"] == 201) {
          return AdvertisementModel.fromJson(jsonDecode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      throw Exception('Failed to load album');
    }
  }

  Future<Favourite_model> _getFavouriteOffers() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
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
          int count = 0;

          throw Exception('Failed to load album');
        }
      } else {
        int count = 0;

        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      throw Exception('Failed to load album');
    }
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        (page < maxPage)) {
      setState(() {
        _isPaginationLoading = true;
        page += 1;
        _getOnlineOffers(page).then((value) => {
              if (mounted)
                {
                  setState(() {
                    if (value.companylist != null &&
                        value.companylist!.isNotEmpty) {
                      offerads_model.add(OnlineOfferAdsModel(
                          value.companylist!, value.dashAdvertise!, "1"));
                    }
                    _isPaginationLoading = false;
                  }),
                }
              else
                {
                  if (value.companylist != null &&
                      value.companylist!.isNotEmpty)
                    {
                      offerads_model.add(OnlineOfferAdsModel(
                          value.companylist!, value.dashAdvertise!, "1")),
                    },
                  _isPaginationLoading = false,
                }
            });
      });
    }
  }

  @override
  void initState() {
    int count = 0, n = 0, a = 0, perPage = 0;
    _getOnlineOffers(page).then((value) => {
          if (mounted)
            {
              setState(() {
                if (value.companylist != null &&
                    value.companylist!.isNotEmpty) {
                  offerads_model.add(OnlineOfferAdsModel(
                      value.companylist!, value.dashAdvertise!, "1"));
                }
                if (page == 1) {
                  company_image_base_url = value.imageBaseUrl!;
                  ads_image_base_url = value.addImageBaseUrl!;
                  _pageSize = int.parse(value.totalRecord!);
                  perPage = value.perpageRecord!;
                  maxPage = (_pageSize / perPage).round();
                }
                _isLoading = false;
              }),
            }
          else
            {
              if (value.companylist != null && value.companylist!.isNotEmpty)
                {
                  offerads_model.add(OnlineOfferAdsModel(
                      value.companylist!, value.dashAdvertise!, "1")),
                },
              if (page == 1)
                {
                  company_image_base_url = value.imageBaseUrl!,
                  ads_image_base_url = value.addImageBaseUrl!,
                  _pageSize = int.parse(value.totalRecord!),
                  perPage = value.perpageRecord!,
                  maxPage = (_pageSize / perPage).round(),
                },
              _isLoading = false,
            }
        });
    scrollcontroller.addListener(pagination);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF2CC0F),
      body: SafeArea(
        child: Stack(
          children: [
            Visibility(
                visible: !_isLoading,
                child: ListView.builder(
                    itemCount: offerads_model.length,
                    itemBuilder: (context, parentIndex) {
                      return Column(
                        children: [
                          GridView.builder(
                            itemCount:
                                offerads_model[parentIndex].offersList!.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: width / 495,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  print("Company name::::::::::" +
                                      offerads_model[parentIndex]
                                          .offersList![index]
                                          .companyName!);
                                  Route route = MaterialPageRoute(
                                      builder: (context) => OfferDetailsScreen(
                                          Constants.language == "en"
                                              ? offerads_model[parentIndex]
                                                  .offersList![index]
                                                  .companyName!
                                              : offerads_model[parentIndex]
                                                      .offersList![index]
                                                      .companyArbName!
                                                      .isNotEmpty
                                                  ? offerads_model[parentIndex]
                                                      .offersList![index]
                                                      .companyArbName!
                                                  : offerads_model[parentIndex]
                                                      .offersList![index]
                                                      .companyName!,
                                          offerads_model[parentIndex]
                                              .offersList![index]
                                              .id!,
                                          "",
                                          offerads_model[parentIndex]
                                              .offersList![index]
                                              .id!,
                                          "0",
                                          "online",
                                          "",
                                          "",
                                          "",
                                          ""));
                                  Navigator.push(context, route);
                                  print("Company name::::::::::" +
                                      offerads_model[parentIndex]
                                          .offersList![index]
                                          .companyName!);
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  color: const Color(0xFFE6D997),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 79,
                                        child: CircleAvatar(
                                          radius: width * 0.10,
                                          backgroundImage: NetworkImage(
                                              company_image_base_url +
                                                  offerads_model[parentIndex]
                                                      .offersList![index]
                                                      .picture!),
                                        ),
                                        margin: const EdgeInsets.only(
                                            left: 2.0, right: 2.0, top: 2.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          Constants.language == "en"
                                              ? offerads_model[parentIndex]
                                                  .offersList![index]
                                                  .displayName!
                                              : offerads_model[parentIndex]
                                                      .offersList![index]
                                                      .displayArbName!
                                                      .isNotEmpty
                                                  ? offerads_model[parentIndex]
                                                      .offersList![index]
                                                      .displayArbName!
                                                  : offerads_model[parentIndex]
                                                      .offersList![index]
                                                      .displayName!,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: Constants.language ==
                                                      "en"
                                                  ? "Roboto"
                                                  : offerads_model[parentIndex]
                                                          .offersList![index]
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
                                        margin: const EdgeInsets.only(
                                            top: 1.0, left: 2.0, right: 2.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              width: width * 0.08,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              8.0))),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    Constants.language == "en"
                                                        ? "Days"
                                                        : "يوم",
                                                    style: TextStyle(
                                                        fontFamily: Constants
                                                                    .language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 8.0),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    offerads_model[parentIndex]
                                                        .offersList![index]
                                                        .remainingday!,
                                                    style: const TextStyle(
                                                      fontSize: 8.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              margin: const EdgeInsets.only(
                                                  left: 2.0, right: 2.0),
                                              width: width * 0.08,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              8.0))),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    Constants.language == "en"
                                                        ? "Hours"
                                                        : "ساعة",
                                                    style: TextStyle(
                                                        fontFamily: Constants
                                                                    .language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 8.0),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    offerads_model[parentIndex]
                                                        .offersList![index]
                                                        .remaininghours!,
                                                    style: const TextStyle(
                                                      fontSize: 8.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              margin: const EdgeInsets.only(
                                                  left: 2.0),
                                              width: width * 0.10,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              8.0))),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    Constants.language == "en"
                                                        ? "Views"
                                                        : "مشاهدة",
                                                    style: TextStyle(
                                                        fontFamily: Constants
                                                                    .language ==
                                                                "en"
                                                            ? "Roboto"
                                                            : "GSSFont",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 8.0),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    offerads_model[parentIndex]
                                                        .offersList![index]
                                                        .viewCount!,
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
                                        margin: const EdgeInsets.only(
                                            top: 1.0, bottom: 10.0),
                                        child: Text(
                                          Constants.language == "en"
                                              ? "Remaining Time"
                                              : "الوقت المتبقي",
                                          style: TextStyle(
                                              fontFamily:
                                                  Constants.language == "en"
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
                          Visibility(
                            visible: offerads_model[parentIndex].isAd == "1"
                                ? true
                                : false,
                            child: InkWell(
                              onTap: () async {
                                if (offerads_model[parentIndex]
                                    .adsList
                                    .url!
                                    .isNotEmpty) {
                                  if (offerads_model[parentIndex]
                                      .adsList
                                      .url!
                                      .contains("https://instagram.com/")) {
                                    String trimmedUrl =
                                        offerads_model[parentIndex]
                                            .adsList
                                            .url!
                                            .replaceAll(
                                                "https://instagram.com/", "");
                                    var splitUrl = trimmedUrl.split("?");
                                    String nativeUrl =
                                        "instagram://user?username=${splitUrl[0]}";
                                    if (await canLaunch(nativeUrl)) {
                                      launch(nativeUrl);
                                    } else {
                                      launch(
                                        offerads_model[parentIndex]
                                            .adsList
                                            .url!,
                                        universalLinksOnly: true,
                                      );
                                    }
                                  } else {
                                    Route route = MaterialPageRoute(
                                        builder: (context) => WebViewScreen(
                                            "",
                                            offerads_model[parentIndex]
                                                .adsList
                                                .url!));
                                    Navigator.push(context, route);
                                  }
                                }
                              },
                              child: Container(
                                width: width,
                                height: 70.0,
                                margin: const EdgeInsets.all(5.0),
                                child: Image(
                                  width: width,
                                  height: 70.0,
                                  image: NetworkImage(
                                    ads_image_base_url +
                                        offerads_model[parentIndex]
                                            .adsList
                                            .addImage!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _isPaginationLoading,
                            child: const Center(
                              child: SizedBox(
                                width: 40.0,
                                height: 40.0,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    })),
            Visibility(
              visible: _isLoading,
              child: const Center(
                child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
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
