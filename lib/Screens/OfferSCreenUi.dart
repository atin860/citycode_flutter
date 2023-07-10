// ignore_for_file: must_be_immutable, avoid_unnecessary_containers, avoid_types_as_parameter_names, non_constant_identifier_names, duplicate_ignore, unused_local_variable, avoid_print, dead_code, prefer_final_fields, file_names, unused_element, prefer_typing_uninitialized_variables, unnecessary_new, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:city_code/Screens/web_view_screen.dart';
import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/company_details_model.dart';
import 'package:city_code/models/couponlistmodel.dart';
import 'package:city_code/models/favourite_model.dart';
//import 'package:city_code/models/new_offers_model.dart';
import 'package:city_code/models/offers_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/ads_list_model.dart';
import '../models/advertisement_model.dart';
import '../models/new_offers_model.dart';
import '../models/offer_with_ads_model.dart';
import '../models/offers_list.dart';
import 'offer_details_screen.dart';

class OffersScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String coupon_type;

  OffersScreen(this.coupon_type, {Key? key}) : super(key: key);

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  bool _isLoading = true, _isPaginationLoading = false;
  late Future<Offers_model> public_offers = _getPublicOffers();
  late Future<Favourite_model> favourite_offers = _getFavouriteOffers();
  List<OffersListModel>? offersList = [];
  List<OffersListModel>? offersList_ads = [];
  List<Favouratelist>? favList = [];
  List<OfferAdsModel> offerads_model = [];
  List<AdsListModel> adsList = [];
  String company_image_base_url = "";
  String ads_image_base_url = "";
  NetworkCheck networkCheck = NetworkCheck();
  int _pageSize = 0, page = 1, maxPage = 0;
  var scrollcontroller = ScrollController();

  var coupondata = "";
  Future bannercount(int bannerId) async {
    final body = {
      "bannerId": bannerId,
    };

    final response = await http.get(
      Uri.parse(
          'http://185.188.127.11/public/index.php/countviewbanner?add_id=' +
              bannerId.toString()),
    );
    print("respose:::::");
    print(response);
  }

  Future<Offers_model> _getPublicOffers() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      if (widget.coupon_type == "friday") {
        var date = DateTime.now();
        if (date.weekday == DateTime.thursday ||
            date.weekday == DateTime.friday) {
          final response = await http.get(Uri.parse(
              'http://185.188.127.11/public/index.php/ApiOffers?coupon_type=' +
                  widget.coupon_type));
          print("respense::::;;");
          if (response.statusCode == 201) {
            var responseServer = jsonDecode(response.body);

            if (kDebugMode) {
              print(responseServer);
            }
            if (responseServer["status"] == 201) {
              return Offers_model.fromJson(jsonDecode(response.body));
            } else {
              setState(() {
                _isLoading = false;
              });
              throw Exception('Failed to load album');
              print("respense::::;;");
            }
          } else {
            setState(() {
              _isLoading = false;
            });
            throw Exception('Failed to load album');
            print("respense::::;;");
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          throw Exception('Failed to load album');
        }
      } else {
        final response = await http.get(Uri.parse(
            'http://185.188.127.11/public/index.php/ApiOffers?coupon_type=' +
                widget.coupon_type));
        if (response.statusCode == 201) {
          var responseServer = jsonDecode(response.body);

          if (kDebugMode) {
            print(responseServer);
          }

          if (responseServer["status"] == 201) {
            return Offers_model.fromJson(jsonDecode(response.body));
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
          print("respense::::;;");
        }
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

  Future<NewOffersModel> _getNewOffers(int pageKey) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      if (widget.coupon_type == "friday") {
        var date = DateTime.now();
        if (date.weekday == DateTime.thursday ||
            date.weekday == DateTime.friday) {
          //  final response = await http.get(Uri.parse(
          //  'http://185.188.127.11/public/index.php/ApiOffers?coupon_type=' +
          //    widget.coupon_type));
          // print(widget.coupon_type);
          //  print(pageKey);
          final response = await http.get(Uri.parse(
              "http://185.188.127.11/public/index.php/apigetoffers?coupon_type=${widget.coupon_type}&page=$pageKey"));

          /*final response = await http.get(Uri.parse(
              "http://185.188.127.11/public/index.php/apigetoffers?coupon_type=${widget.coupon_type}&page=$pageKey"));*/
          print(response);
          if (response.statusCode == 201) {
            var responseServer = jsonDecode(response.body);

            if (kDebugMode) {
              print(responseServer);
            }
            if (responseServer["status"] == 201) {
              print("executed");
              return NewOffersModel.fromJson(jsonDecode(response.body));
              // return Offers_model.fromJson(jsonDecode(response.body));
              print("page");
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
          throw Exception('Failed to load album');
        }
      } else {
        final response = await http.get(Uri.parse(
            "http://185.188.127.11/public/index.php/apigetoffers?coupon_type=${widget.coupon_type}&page=$pageKey&userid=${Constants.user_id}"));
        if (response.statusCode == 201) {
          var responseServer = jsonDecode(response.body);

          if (kDebugMode) {
            print(responseServer);
          }

          if (responseServer["status"] == 201) {
            print("page" + pageKey.toString());
            return NewOffersModel.fromJson(jsonDecode(response.body));
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
              print("copounsss" + widget.coupon_type);
              _alertDialog("No Offers Available..");
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
          int n = 0, a = 0;

          throw Exception('Failed to load album');
        }
      } else {
        int count = 0;
        int n = 0, a = 0;

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

  Future<bool> _addOrRemoveFavOffer(int parentIndex, int index) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final Map<String, String?> body;
      if (offerads_model.isNotEmpty) {
        body = {
          "customer_id": Constants.user_id,
          "company_id":
              offerads_model[parentIndex].offersList![index].companyId,
          "offer_id": offerads_model[parentIndex].offersList![index].id,
        };
      } else {
        body = {
          "customer_id": Constants.user_id,
          "company_id": offersList![index].companyId,
          "offer_id": offersList![index].id,
        };
      }

      final http.Response response;
      if (offerads_model.isNotEmpty) {
        if (offerads_model[parentIndex].offersList![index].isfavorate == "0") {
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
      } else {
        if (offersList![index].isFav == "0") {
          response = await http.post(
            Uri.parse('http://185.188.127.11/public/index.php/ApiFavorate'),
            body: body,
          );
          print("hellp");
        } else {
          response = await http.post(
            Uri.parse('http://185.188.127.11/public/index.php/removefavourate'),
            body: body,
          );
        }
      }

      if (response.statusCode == 201) {
        var responseServer = jsonDecode(response.body);

        if (kDebugMode) {
          print(responseServer);
        }

        if (responseServer["status"] == 201) {
          if (offerads_model.isNotEmpty) {
            if (offerads_model[parentIndex].offersList![index].isfavorate ==
                "0") {
              if (Constants.language == "en") {
                _alertDialog("Added Successfully");
              } else {
                _alertDialog("اضيف بنجاح");
              }
              setState(() {
                offerads_model[parentIndex].offersList![index].isfavorate = "1";
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
                offerads_model[parentIndex].offersList![index].isfavorate = "0";
                _isLoading = false;
              });
              return false;
            }
          } else {
            if (offersList![index].isFav == "0") {
              if (Constants.language == "en") {
                _alertDialog("Added Successfully");
              } else {
                _alertDialog("اضيف بنجاح");
              }
              setState(() {
                offersList![index].isFav = "1";
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
                offersList![index].isFav = "0";
                _isLoading = false;
              });
              return false;
            }
          }
        } else {
          if (offerads_model.isNotEmpty) {
            if (offerads_model[parentIndex].offersList![index].isfavorate ==
                "0") {
              setState(() {
                offerads_model[parentIndex].offersList![index].isfavorate = "0";
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
                offerads_model[parentIndex].offersList![index].isfavorate = "1";
                _isLoading = false;
              });
              if (Constants.language == "en") {
                _alertDialog("Failed to remove favourite");
              } else {
                _alertDialog("فشل إزالة المفضلة");
              }
              return true;
            }
          } else {
            if (offersList![index].isFav == "0") {
              setState(() {
                offersList![index].isFav = "0";
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
                offersList![index].isFav = "1";
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
        if (offerads_model.isNotEmpty) {
          if (offerads_model[parentIndex].offersList![index].isfavorate ==
              "0") {
            return false;
          } else {
            return true;
          }
        } else {
          if (offersList![index].isFav == "0") {
            return false;
          } else {
            return true;
          }
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      if (offersList![index].isFav == "0") {
        return false;
      } else {
        return true;
      }
    }
  }

  @override
  void initState() {
    int count;
    int n = 0, a = 0, perPage = 0;
    var contains;
    _getNewOffers(page).then((value) => {
          if (mounted)
            {
              setState(() {
                if (value.offers != null && value.offers!.isNotEmpty) {
                  offerads_model.add(
                      OfferAdsModel(value.dashAdvertise!, value.offers!, "1"));
                }
                if (page == 1) {
                  company_image_base_url = value.imageBaseUrl!;
                  ads_image_base_url = value.addImageBaseUrl!;
                  _pageSize = int.parse(value.totalRecord!);
                  perPage = value.perpageRecord!;
                  // Edited by rohan 22/07/22 for pagination 18 records ...
                  maxPage = (_pageSize).round();
                  int maxdouble = (maxPage / 18).ceil();
                  maxdouble = (maxdouble.round());
                  print("max" + maxPage.toString());
                  print("pagesize" + _pageSize.toString());
                  print("maxpagee" + maxdouble.toString());
                  maxPage = maxdouble;
                }
                _isLoading = false;
              }),
            }
          else
            {
              if (value.offers != null && value.offers!.isNotEmpty)
                {
                  offerads_model.add(
                      OfferAdsModel(value.dashAdvertise!, value.offers!, "1")),
                },
              if (page == 1)
                {
                  company_image_base_url = value.imageBaseUrl!,
                  ads_image_base_url = value.addImageBaseUrl!,
                  _pageSize = int.parse(value.totalRecord!),
                  perPage = value.perpageRecord!,
                  maxPage = (_pageSize / perPage).round(),
                  print("alert::::::")
                },
              _isLoading = false,
            }
        });

    scrollcontroller.addListener(pagination);
    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        (page < maxPage)) {
      setState(() {
        page += 1;
      });
    }
  }

  var count = "";
  List<Companydetails>? companydetail = [];

  Future<void> getCompany(var companyid) async {
    String url =
        "http://185.188.127.11/public/index.php/ApiCompany/" + companyid;
    var network = new NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = CompanyDetailsModel.fromJson(res);
    var stat = vlist.status.toString();
    if (stat.contains("201")) {
      // totalamount=couponreportlist![index].couponAmount!;

      print("okkkk");

      for (var data in companydetail!) {
        count = data.viewCount.toString();
        print("viewhere" + count);
      }
    }

    setState(() {
      //  couponreportlist = vlist.userCouponList!;
    });

    print("companydetailsrr" + res!.toString());
  }

  List<CouponList> couponlist = [];

  Future<void> couponlistavailable(
      var companyid, var branchid, int parentIndex, int index) async {
    Map<String, String> jsonbody = {
      "companyid": companyid,
      "branchid": branchid,
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

        print("rohan" + count.toString());
        Route route = MaterialPageRoute(
            builder: (context) => OfferDetailsScreen(
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
                offerads_model[parentIndex].offersList![index].companyId!,
                offerads_model[parentIndex].offersList![index].discountdisplay!,
                offerads_model[parentIndex].offersList![index].id!,
                offerads_model[parentIndex].offersList![index].isfavorate!,
                "offers",
                "",
                coupondata,
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
  void dispose() {
    scrollcontroller.dispose();
    super.dispose();
  }

  var companyid = "";
  var branchid = "";
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        ListView.builder(
          shrinkWrap: true,
          controller: scrollcontroller,
          itemCount: offerads_model.length,
          itemBuilder: (BuildContext context, int parentIndex) {
            return Column(
              children: [
                if (widget.coupon_type == "homebusiness")
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: offerads_model[parentIndex].offersList!.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: width / 500,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      companyid = offerads_model[parentIndex]
                          .offersList![index]
                          .companyId!;
                      branchid = offerads_model[parentIndex]
                          .offersList![index]
                          .branchId!;
                      return InkWell(
                        onTap: () {
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
                                      .companyId!,
                                  offerads_model[parentIndex]
                                      .offersList![index]
                                      .discountdisplay!,
                                  offerads_model[parentIndex]
                                      .offersList![index]
                                      .id!,
                                  offerads_model[parentIndex]
                                      .offersList![index]
                                      .isfavorate!,
                                  "home",
                                  "",
                                  coupondata,
                                  "",
                                  ""));
                          Navigator.push(context, route);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          // color: Colors.green,
                          color: const Color(0xFFE6D997),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: height * 0.103,
                                child: CircleAvatar(
                                  radius: width * 0.10,
                                  backgroundImage: NetworkImage(
                                      company_image_base_url +
                                          offerads_model[parentIndex]
                                              .offersList![index]
                                              .companylogo!),
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
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : offerads_model[parentIndex]
                                                  .offersList![index]
                                                  .displayArbName!
                                                  .isNotEmpty
                                              ? "GSSFont"
                                              : "Roboto",
                                      fontWeight: FontWeight.bold,
                                      //fontSize: 16.0
                                      fontSize: 14.0),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(2.0),
                                margin: const EdgeInsets.only(
                                    left: 1.0, right: 1.0, bottom: 7),
                                width: width * 0.20,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Column(
                                  children: [
                                    Text(
                                      Constants.language == "en"
                                          ? "Views"
                                          : "مشاهدة",
                                      style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8.0,
                                      ),
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
                      );
                    },
                  )
                else if (widget.coupon_type == "coupon")
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: offerads_model[parentIndex].offersList!.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: width / 657,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          var qty = offerads_model[parentIndex]
                              .offersList![index]
                              .couponquantity
                              .toString();
                          print("qty" + qty.toString());
                          /* couponsavailbler( companyid, branchid)?.then((value) => {
                      if(value.couponList!=null&&value.couponList!.isNotEmpty){

                      }
                    });*/
                          var companyid = offerads_model[parentIndex]
                              .offersList![index]
                              .companyId!;
                          var branchid = offerads_model[parentIndex]
                              .offersList![index]
                              .branchId!;
                          couponlistavailable(
                              companyid, branchid, parentIndex, index);
                          setState(() {
                            _isLoading = true;
                          });
                          getCompany(offerads_model[parentIndex]
                              .offersList![index]
                              .companyId!);
                          print("hereone");
                          coupondata = offerads_model[parentIndex]
                              .offersList![index]
                              .couponstatus
                              .toString();

                          if (widget.coupon_type == "friday") {
                            var date = DateTime.now();
                            if (date.weekday == DateTime.friday) {
                              print("herefriday");
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
                                          .companyId!,
                                      offerads_model[parentIndex]
                                          .offersList![index]
                                          .discountdisplay!,
                                      offerads_model[parentIndex]
                                          .offersList![index]
                                          .id!,
                                      offerads_model[parentIndex]
                                          .offersList![index]
                                          .isfavorate!,
                                      "offers",
                                      "",
                                      coupondata,
                                      "",
                                      ""));
                              Navigator.push(context, route);
                            } else {
                              _alertDialog(Constants.language == "en"
                                  ? "The offer will be available on Friday"
                                  : "العرض متاح يوم الجمعة");
                            }
                          } else {
                            print("Company name::::::::::" +
                                offerads_model[parentIndex]
                                    .offersList![index]
                                    .companyName!);
                            /* if(couponlist.isNotEmpty){}

                      else{
                        _alertDialog(Constants.language == "en"
                            ? "Coupons Not Available"
                            : "القسائم غير متوفرة");
                      }*/
                          }
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
                                height: 100,
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        offerads_model[parentIndex]
                                                    .offersList![index]
                                                    .couponstatus ==
                                                "1"
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    color: Colors.lightGreen,
                                                    child: const Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Coupon",
                                                          style: TextStyle(
                                                              fontSize: 5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ))),
                                              )
                                            : Container(),
                                        LikeButton(
                                          onTap: (bool) {
                                            return _addOrRemoveFavOffer(
                                                parentIndex, index);
                                          },
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          size: width * 0.06,
                                          isLiked: offerads_model[parentIndex]
                                                      .offersList![index]
                                                      .isfavorate! ==
                                                  "1"
                                              ? true
                                              : false,
                                          circleColor: const CircleColor(
                                              start: Color(0xff00ddff),
                                              end: Color(0xff0099cc)),
                                          bubblesColor: const BubblesColor(
                                            dotPrimaryColor: Color(0xff33b5e5),
                                            dotSecondaryColor:
                                                Color(0xff0099cc),
                                          ),
                                          likeBuilder: (bool isLiked) {
                                            return Icon(
                                              isLiked
                                                  ? CupertinoIcons.heart_fill
                                                  : CupertinoIcons.heart,
                                              color: isLiked
                                                  ? Colors.red
                                                  : Colors.black,
                                              size: width * 0.06,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    /* Visibility(
                                visible:offerads_model[parent_index]
                                    .offersList![index].couponstatus== "0" ? false : true,
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 58,right: 20,bottom:7,top: 53),
                                    height: 80,
                                    width: 80,

                                    foregroundDecoration:  RotatedCornerDecoration(

                                      color: Colors.lightGreen,
                                      geometry: const BadgeGeometry(width: 45, height: 40, cornerRadius: 7,alignment: BadgeAlignment.bottomRight),
                                      textSpan: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '"  "\n',
                                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.redAccent),
                                          ),
                                          TextSpan(
                                            text:   '" "\n',
                                            style: TextStyle(fontSize: 4, fontStyle: FontStyle.italic, letterSpacing: 0.5, color: Colors.white),
                                          ),
                                          TextSpan(
                                            text:   "    Coupon\n",
                                            style: TextStyle(fontSize: 4, fontStyle: FontStyle.italic, letterSpacing: 0.5, color: Colors.white,fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      // textSpan: TextSpan(text: '"\ncoupon\ncoupon', style: TextStyle(fontSize: 4, letterSpacing: 0.5,color: Colors.white)),
                                      //  geometry: const BadgeGeometry(width: 32, height: 32, cornerRadius: 16),
                                    ),
                                  ),
                                ),
                              ),*/
                                    Positioned(
                                      top: 10.0,
                                      right: 10.0,
                                      left: 10.0,
                                      child: CircleAvatar(
                                        radius: width * 0.10,
                                        backgroundImage: NetworkImage(
                                            company_image_base_url +
                                                offerads_model[parentIndex]
                                                    .offersList![index]
                                                    .companylogo!),

                                        /*child:Visibility(
                                              visible: offerads_model[parent_index]
                                                  .offersList![index].couponstatus== "0" ? false : true,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom:1.0,left: 12,right:7),
                                                child: Container(
                                                  width: 50,
                                                  margin: EdgeInsets.only(left: 20),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),

                                                    alignment: Alignment.bottomRight,
                                                 // padding: const EdgeInsets.all(5),
                                                  child: const Text('', style: TextStyle(fontSize: 12)),
                                                  foregroundDecoration:  RotatedCornerDecoration(

                                                    color: Colors.lightGreen,
                                                    geometry: const BadgeGeometry(width: 25, height: 26, cornerRadius: 7,alignment: BadgeAlignment.bottomRight),
                                                    textSpan: TextSpan(text: 'coupon', style: TextStyle(fontSize: 5, letterSpacing: 0.5)),
                                                  //  geometry: const BadgeGeometry(width: 32, height: 32, cornerRadius: 16),
                                                  ),
                                                ),
                                              ),
                                            ),*/
                                      ),
                                    ),
                                  ],
                                ),
                                margin: const EdgeInsets.only(
                                  left: 2.0,
                                  right: 2.0,
                                ),
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
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : offerads_model[parentIndex]
                                                  .offersList![index]
                                                  .displayArbName!
                                                  .isNotEmpty
                                              ? "Roboto" //GSSFont edited by rohan
                                              : "Roboto",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 1.0),
                                child: Text(
                                  offerads_model[parentIndex]
                                              .offersList![index]
                                              .couponstatus ==
                                          "1"
                                      ? "Coupons"
                                      : offerads_model[parentIndex]
                                          .offersList![index]
                                          .discountdisplay!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(2.0),
                                margin: const EdgeInsets.only(
                                    left: 1.0, right: 1.0, bottom: 7, top: 2),
                                width: width * 0.20,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Column(
                                  children: [
                                    Text(
                                      Constants.language == "en"
                                          ? "Views"
                                          : "مشاهدة",
                                      style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8.0,
                                      ),
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
                              /*Container(
                          margin: const EdgeInsets.only(
                              top: 1.0, left: 3.0, right: 3.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2.0),
                                width: width * 0.08,
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
                                          Constants.language ==
                                              "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 8.0),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      offerads_model[parent_index]
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
                                padding: const EdgeInsets.all(2.0),
                                margin: const EdgeInsets.only(
                                    left: 1.0, right: 1.0),
                                width: width * 0.09,
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
                                          Constants.language ==
                                              "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 8.0),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      offerads_model[parent_index]
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
                                padding: const EdgeInsets.all(2.0),
                                margin: const EdgeInsets.only(
                                    left: 1.0, right: 1.0),
                                width: width * 0.10,
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
                                        fontSize: 8.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      count.toString(),
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
                        ),*/
                              /* Container(
                          margin: const EdgeInsets.only(
                              top: 1.0, bottom: 10.0),
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
                        ),*/
                            ],
                          ),
                        ),
                      );
                    },
                  )
                else
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: offerads_model[parentIndex].offersList!.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: width / 657,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          coupondata = offerads_model[parentIndex]
                              .offersList![index]
                              .couponstatus
                              .toString();

                          if (widget.coupon_type == "friday") {
                            var date = DateTime.now();
                            if (date.weekday == DateTime.friday) {
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
                                          .companyId!,
                                      offerads_model[parentIndex]
                                          .offersList![index]
                                          .discountdisplay!,
                                      offerads_model[parentIndex]
                                          .offersList![index]
                                          .id!,
                                      offerads_model[parentIndex]
                                          .offersList![index]
                                          .isfavorate!,
                                      "offers",
                                      "",
                                      coupondata,
                                      "",
                                      ""));
                              Navigator.push(context, route);
                            } else {
                              _alertDialog(Constants.language == "en"
                                  ? "The offer will be available on Friday"
                                  : "العرض متاح يوم الجمعة");
                            }
                          } else {
                            print("rohanss" +
                                offerads_model[parentIndex]
                                    .offersList![index]
                                    .viewCount!);
                            Route route = MaterialPageRoute(
                                builder: (context) => OfferDetailsScreen(
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
                                    offerads_model[parentIndex]
                                        .offersList![index]
                                        .companyId!,
                                    offerads_model[parentIndex]
                                        .offersList![index]
                                        .discountdisplay!,
                                    offerads_model[parentIndex]
                                        .offersList![index]
                                        .id!,
                                    offerads_model[parentIndex]
                                        .offersList![index]
                                        .isfavorate!,
                                    "offers",
                                    "",
                                    coupondata,
                                    "",
                                    ""));
                            Navigator.push(context, route);
                            print("Company namess::::::::::" +
                                offerads_model[parentIndex]
                                    .offersList![index]
                                    .companyName!);
                          }
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
                                height: 96,
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        offerads_model[parentIndex]
                                                    .offersList![index]
                                                    .priority!
                                                    .isNotEmpty &&
                                                offerads_model[parentIndex]
                                                        .offersList![index]
                                                        .priority!
                                                        .toLowerCase() !=
                                                    "priority-99"
                                            ? Image(
                                                image: AssetImage(offerads_model[
                                                                parentIndex]
                                                            .offersList![index]
                                                            .priority!
                                                            .toLowerCase() ==
                                                        "priority-1"
                                                    ? "images/diamond.png"
                                                    : offerads_model[
                                                                    parentIndex]
                                                                .offersList![
                                                                    index]
                                                                .priority!
                                                                .toLowerCase() ==
                                                            "priority-2"
                                                        ? "images/golden.png"
                                                        : offerads_model[
                                                                        parentIndex]
                                                                    .offersList![
                                                                        index]
                                                                    .priority!
                                                                    .toLowerCase() ==
                                                                "priority-3"
                                                            ? "images/silver.png"
                                                            : "images/bronze.png"),
                                                width: width * 0.06,
                                                fit: BoxFit.fill,
                                              )
                                            : Container(),
                                        LikeButton(
                                          onTap: (bool) {
                                            return _addOrRemoveFavOffer(
                                                parentIndex, index);
                                          },
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          size: width * 0.06,
                                          isLiked: offerads_model[parentIndex]
                                                      .offersList![index]
                                                      .isfavorate! ==
                                                  "1"
                                              ? true
                                              : false,
                                          circleColor: const CircleColor(
                                              start: Color(0xff00ddff),
                                              end: Color(0xff0099cc)),
                                          bubblesColor: const BubblesColor(
                                            dotPrimaryColor: Color(0xff33b5e5),
                                            dotSecondaryColor:
                                                Color(0xff0099cc),
                                          ),
                                          likeBuilder: (bool isLiked) {
                                            return Icon(
                                              isLiked
                                                  ? CupertinoIcons.heart_fill
                                                  : CupertinoIcons.heart,
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
                                                offerads_model[parentIndex]
                                                    .offersList![index]
                                                    .companylogo!),
                                      ),
                                    ),
                                  ],
                                ),
                                margin: const EdgeInsets.only(
                                    left: 2.0, right: 2.0, top: 2.0),
                              ),
                              Container(
                                // margin: const EdgeInsets.only(top: 5.0),
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
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : offerads_model[parentIndex]
                                                  .offersList![index]
                                                  .displayArbName!
                                                  .isNotEmpty
                                              ? "Roboto" //GSSFont edited by rohan
                                              : "Roboto",
                                      fontWeight: FontWeight.bold,
                                      //  fontSize: 16.0
                                      fontSize: 14.0),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 1.0),
                                child: Text(
                                  offerads_model[parentIndex]
                                              .offersList![index]
                                              .couponstatus ==
                                          "1"
                                      ? "Coupons"
                                      : offerads_model[parentIndex]
                                          .offersList![index]
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
                                margin: const EdgeInsets.only(top: 1.0),
                                child: Text(
                                  Constants.language == "en"
                                      ? offerads_model[parentIndex]
                                          .offersList![index]
                                          .discountEnDetail!
                                      : offerads_model[parentIndex]
                                          .offersList![index]
                                          .discountArbDetail!,
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
                                      padding: const EdgeInsets.all(2.0),
                                      margin: const EdgeInsets.only(
                                          left: 1.0, right: 1.0),
                                      //width: width * 0.10,
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
                                              fontSize: 8.0,
                                            ),
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
                Visibility(
                  visible:
                      offerads_model[parentIndex].iAd == "1" ? true : false,
                  child: InkWell(
                    onTap: () async {
                      if (offerads_model[parentIndex].adsList.url!.isNotEmpty) {
                        if (offerads_model[parentIndex]
                            .adsList
                            .url!
                            .contains("https://instagram.com/")) {
                          String trimmedUrl = offerads_model[parentIndex]
                              .adsList
                              .url!
                              .replaceAll("https://instagram.com/", "");
                          var splitUrl = trimmedUrl.split("?");
                          String nativeUrl =
                              "instagram://user?username=${splitUrl[0]}";
                          if (await canLaunch(nativeUrl)) {
                            launch(nativeUrl);
                          } else {
                            launch(
                              offerads_model[parentIndex].adsList.url!,
                              universalLinksOnly: true,
                            );
                          }
                        } else {
                          Route route = MaterialPageRoute(
                              builder: (context) => WebViewScreen("",
                                  offerads_model[parentIndex].adsList.url!));
                          Navigator.push(context, route);
                        }
                      }
                      bannercount(int.parse(offerads_model[parentIndex]
                          .adsList
                          .addId
                          .toString()));
                      print("call::::::");
                      print(bannercount.toString());
                    },
                    child: Container(
                      height: 70.0,
                      width: width,
                      margin: const EdgeInsets.all(5.0),
                      child: Image(
                        width: width,
                        height: 70.0,
                        image: NetworkImage(
                          ads_image_base_url +
                              offerads_model[parentIndex].adsList.addImage!,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isPaginationLoading,
                  child: const SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
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
