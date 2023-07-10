// ignore_for_file: non_constant_identifier_names, unnecessary_new, avoid_print, deprecated_member_use, avoid_types_as_parameter_names

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:city_code/Screens/web_view_screen.dart';
import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/couponlistmodel.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/favourite_model.dart';
import '../models/home_banner_model.dart';
import 'offer_details_screen.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late Future<Home_banner_model> home_banner = getHomeBanner();
  late Future<Favourite_model> favourite_offers = _getFavouriteOffers();
  List<Favouratelist>? favouratelist = [];
  List<Banner_list>? bannerList = [];
  List<String> fav = [];
  int _currentPosition = 0;
  String banner_base_url = "";
  bool _isLoading = true;
  String company_image_base_url = "";
  NetworkCheck networkCheck = NetworkCheck();

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Future<Home_banner_model> getHomeBanner() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "user_id": Constants.user_id,
        "language": Constants.language == "en" ? "english" : "arb"
      };

      final response = await http.post(
        Uri.parse(
            'http://185.188.127.11/public/index.php/ApiAdvertise/newBanner'),
        body: body,
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 201) {
        if (response_server["status"] == 201) {
          return Home_banner_model.fromJson(json.decode(response.body));
        } else {
          if (Constants.language == "en") {
            _alertDialog("No banners available");
          } else {
            _alertDialog("لا توجد لافتات متاحة");
          }
          setState(() {
            _isLoading = false;
          });
          throw Exception('Failed to load album');
        }
      } else {
        if (Constants.language == "en") {
          _alertDialog("Something went wrong");
        } else {
          _alertDialog("هناك خطأ ما");
        }
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
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
          return Favourite_model.fromJson(jsonDecode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });
          _alertDialog(
              Constants.language == "en" ? "no data found" : "لاتوجد بيانات");
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          _alertDialog(
              Constants.language == "en" ? "no data found" : "لاتوجد بيانات");
        } else {
          _alertDialog(Constants.language == "en"
              ? "Something went wrong"
              : "هناك خطأ ما");
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

  Future<bool> _addOrRemoveFavOffer(int index) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "customer_id": Constants.user_id,
        "company_id": favouratelist![index].companyId,
        "offer_id": favouratelist![index].offerId,
      };

      final http.Response response;
      if (fav[index] == "0") {
        response = await http.post(
          Uri.parse('http://185.188.127.11/public/index.php/ApiFavorate'),
          body: body,
        );
      } else {
        response = await http.post(
          Uri.parse('http://185.188.127.11/public/index.php/removefavourate'),
          body: body,
        );
      }

      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }

        if (response_server["status"] == 201) {
          if (fav[index] == "0") {
            if (Constants.language == "en") {
              _alertDialog("Added Successfully");
            } else {
              _alertDialog("اضيف بنجاح");
            }
            setState(() {
              fav[index] = "1";
              _isLoading = false;
            });
            return true;
          } else {
            if (Constants.language == "en") {
              _alertDialog("Removed Successfully");
            } else {
              _alertDialog("تمت إزالته بنجاح");
            }
            setState(() {
              fav[index] = "0";
              _isLoading = false;
            });
            return false;
          }
        } else {
          if (fav[index] == "0") {
            setState(() {
              fav[index] = "0";
              _isLoading = false;
            });
            if (Constants.language == "en") {
              _alertDialog("Failed to add favourite");
            } else {
              _alertDialog("فشل إضافة المفضلة");
            }
            return false;
          } else {
            setState(() {
              fav[index] = "1";
              _isLoading = false;
            });
            if (Constants.language == "en") {
              _alertDialog("Failed to remove favourite");
            } else {
              _alertDialog("فشل إزالة المفضلة");
            }
            return true;
          }
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (Constants.language == "en") {
          _alertDialog("Something went wrong");
        } else {
          _alertDialog("هناك خطأ ما");
        }
        if (fav[index] == "0") {
          return false;
        } else {
          return true;
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      if (fav[index] == "0") {
        return false;
      } else {
        return true;
      }
    }
  }

  @override
  void initState() {
    _getFavouriteOffers().then((value) => {
          company_image_base_url = value.imageBaseUrl!,
          if (value.favouratelist != null && value.favouratelist!.isNotEmpty)
            {
              for (int i = 0; i < value.favouratelist!.length; i++)
                {
                  favouratelist!.add(value.favouratelist![i]),
                  fav.add("1"),
                }
            },
          home_banner.then((value) => {
                if (value.bannerList != null && value.bannerList!.isNotEmpty)
                  {
                    bannerList!.clear(),
                    for (int i = 0; i < value.bannerList!.length; i++)
                      {bannerList!.add(value.bannerList![i])}
                  },
                setState(() {
                  banner_base_url = value.imageBaseUrl ?? "";
                  _isLoading = false;
                })
              }),
        });
    super.initState();
  }

  List<CouponList> couponlist = [];
  Future<void> couponlistavailable(var companyid, int index) async {
    Map<String, String> jsonbody = {
      "companyid": companyid,
    };
    String url = "http://cp.citycode.om/public/index.php/couponlist";
    var network = new NewVendorApiService();
    var response = await network.postresponse(url, jsonbody);
    var model = Couponlistmodel.fromJson(response);
    var status = model.status.toString();
    if (status.contains("404")) {
      _alertDialog(Constants.language == "en"
          ? "Coupons Not Available"
          : "القسائم غير متوفرة");
    }
    setState(() {
      _isLoading = false;
    });

    if (status.contains("201")) {
      setState(() {
        couponlist = model.couponList!;
      });
      print("couponslist" + response.toString());
      setState(() {
        _isLoading = false;
      });
      if (couponlist.isNotEmpty) {
        print("heretwo");

        //print("rohan"+count.toString());
        Route route = MaterialPageRoute(
            builder: (context) => OfferDetailsScreen(
                Constants.language == "en"
                    ? favouratelist![index].displayName!
                    : favouratelist![index].displayArbName!.isNotEmpty
                        ? favouratelist![index].displayArbName!
                        : favouratelist![index].displayName!,
                favouratelist![index].companyId!,
                favouratelist![index].discountdisplay!,
                favouratelist![index].id!,
                fav[index],
                "offers",
                "",
                "1",
                "",
                ""));
        Navigator.push(context, route);
      } else {
        _alertDialog(Constants.language == "en"
            ? "Coupons Not Available"
            : "القسائم غير متوفرة");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF2CC0F),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF2CC0F),
        title: Text(
          Constants.language == "en" ? "My Favourite" : "المفضل لدي",
          style: TextStyle(
              color: Colors.black,
              fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont"),
        ),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: Constants.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: height * 0.25,
                        viewportFraction: 1.0,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: const Duration(seconds: 1),
                        autoPlay: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentPosition = index;
                          });
                        },
                      ),
                      items: bannerList!
                          .map(
                            (e) => ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () async {
                                      if (e.inApp == "true") {
                                        Route route = MaterialPageRoute(
                                            builder: (context) =>
                                                OfferDetailsScreen(
                                                    "",
                                                    e.companyId!,
                                                    "",
                                                    "",
                                                    "",
                                                    "city",
                                                    "",
                                                    "",
                                                    "",
                                                    ""));
                                        Navigator.push(context, route);
                                      } else {
                                        if (e.url!.isNotEmpty) {
                                          if (e.url!.contains(
                                              "https://instagram.com/")) {
                                            String trimmed_url = e.url!
                                                .replaceAll(
                                                    "https://instagram.com/",
                                                    "");
                                            var split_url =
                                                trimmed_url.split("?");
                                            String native_url =
                                                "instagram://user?username=${split_url[0]}";
                                            if (await canLaunch(native_url)) {
                                              launch(native_url);
                                            } else {
                                              launch(
                                                e.url!,
                                                universalLinksOnly: true,
                                              );
                                            }
                                          } else {
                                            Route route = MaterialPageRoute(
                                                builder: (context) =>
                                                    WebViewScreen("", e.url!));
                                            Navigator.push(context, route);
                                          }
                                        }
                                      }
                                    },
                                    child: Image(
                                      image: NetworkImage(
                                          banner_base_url + e.banner!),
                                      width: width,
                                      height: height,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    Positioned(
                      bottom: 1.0,
                      left: width * 0.40,
                      right: width * 0.40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: map<Widget>(
                          bannerList!,
                          (index, url) {
                            return Container(
                              width: 5.0,
                              height: 5.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPosition == index
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Visibility(
                      visible: !_isLoading,
                      child: FutureBuilder(
                        future: favourite_offers,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return GridView.builder(
                              itemCount: favouratelist!.length,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: width / 630,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    if (favouratelist![index].discountdisplay ==
                                        "Coupons") {
                                      var companyid = favouratelist![index]
                                          .companyId
                                          .toString();

                                      couponlistavailable(companyid, index);
                                    } else {
                                      Route route = MaterialPageRoute(
                                          builder: (context) =>
                                              OfferDetailsScreen(
                                                  Constants.language == "en"
                                                      ? favouratelist![index]
                                                          .companyName!
                                                      : favouratelist![index]
                                                              .companyArbName!
                                                              .isNotEmpty
                                                          ? favouratelist![
                                                                  index]
                                                              .companyArbName!
                                                          : favouratelist![
                                                                  index]
                                                              .companyName!,
                                                  favouratelist![index]
                                                      .companyId!,
                                                  favouratelist![index]
                                                      .discountdisplay!,
                                                  favouratelist![index].id!,
                                                  fav[index],
                                                  "city",
                                                  "",
                                                  "",
                                                  "",
                                                  ""));
                                      Navigator.push(context, route);
                                    }
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
                                          height: 93,
                                          child: Stack(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(),
                                                  LikeButton(
                                                    onTap: (bool) {
                                                      return _addOrRemoveFavOffer(
                                                          index);
                                                    },
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    size: width * 0.06,
                                                    isLiked: fav[index] == "1"
                                                        ? true
                                                        : false,
                                                    circleColor:
                                                        const CircleColor(
                                                            start: Color(
                                                                0xff00ddff),
                                                            end: Color(
                                                                0xff0099cc)),
                                                    bubblesColor:
                                                        const BubblesColor(
                                                      dotPrimaryColor:
                                                          Color(0xff33b5e5),
                                                      dotSecondaryColor:
                                                          Color(0xff0099cc),
                                                    ),
                                                    likeBuilder:
                                                        (bool isLiked) {
                                                      return Icon(
                                                        isLiked
                                                            ? CupertinoIcons
                                                                .heart_fill
                                                            : CupertinoIcons
                                                                .heart,
                                                        color: isLiked
                                                            ? Colors.red
                                                            : Colors.black,
                                                        size: width * 0.06,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Positioned(
                                                top: 10.0,
                                                right: 10.0,
                                                left: 10.0,
                                                child: CircleAvatar(
                                                  radius: width * 0.10,
                                                  backgroundImage: NetworkImage(
                                                      company_image_base_url +
                                                          favouratelist![index]
                                                              .companylogo!),
                                                ),
                                              ),
                                            ],
                                          ),
                                          margin: const EdgeInsets.only(
                                              left: 2.0, right: 2.0, top: 2.0),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            Constants.language == "en"
                                                ? favouratelist![index]
                                                    .displayName!
                                                : favouratelist![index]
                                                        .displayArbName!
                                                        .isNotEmpty
                                                    ? favouratelist![index]
                                                        .displayArbName!
                                                    : favouratelist![index]
                                                        .displayName!,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    Constants.language == "en"
                                                        ? "Roboto"
                                                        : favouratelist![index]
                                                                .displayArbName!
                                                                .isNotEmpty
                                                            ? ""
                                                            : "Roboto",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 1.0),
                                          child: Text(
                                            favouratelist![index]
                                                .discountdisplay!,
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
                                          margin:
                                              const EdgeInsets.only(top: 1.0),
                                          child: Text(
                                            Constants.language == "en"
                                                ? favouratelist![index]
                                                    .discountEnDetail!
                                                : favouratelist![index]
                                                    .discountArbDetail!,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    Constants.language == "en"
                                                        ? "Roboto"
                                                        : "GSSFont",
                                                fontSize: 12.0),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 1.0, left: 0.5, right: 0.5),
                                          child: SingleChildScrollView(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(0.2),
                                                  //  width: 34,
                                                  width: width * 0.12,
                                                  margin:
                                                      const EdgeInsets.all(0.5),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8.0))),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        Constants.language ==
                                                                "en"
                                                            ? "Days"
                                                            : "يوم",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                Constants.language ==
                                                                        "en"
                                                                    ? "Roboto"
                                                                    : "GSSFont",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 8.0),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        favouratelist![index]
                                                            .remainingday!,
                                                        style: const TextStyle(
                                                          fontSize: 8.0,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                /*Container(
                                                  padding:
                                                  const EdgeInsets.all(0.5),
                                                  margin: const EdgeInsets.all(0.5),

                                                  width: 35,
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
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 8.0),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      Text(
                                                        favouratelist![index]
                                                            .remaininghours!,
                                                        style: const TextStyle(
                                                            fontSize: 8.0,),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),*/
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(0.2),
                                                  margin: const EdgeInsets.only(
                                                      left: 1.0, right: 1.0),
                                                  // margin: const EdgeInsets.all(0.5),
                                                  width: width * 0.12,
                                                  // width: 40 ,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8.0))),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        Constants.language ==
                                                                "en"
                                                            ? "Views"
                                                            : "مشاهدة",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                Constants.language ==
                                                                        "en"
                                                                    ? "Roboto"
                                                                    : "GSSFont",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 8.0),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        favouratelist![index]
                                                            .viewCount!,
                                                        style: const TextStyle(
                                                          fontSize: 8.0,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 1.0, bottom: 1.0),
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
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
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
            ],
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
