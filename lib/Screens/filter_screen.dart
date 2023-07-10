// ignore_for_file: non_constant_identifier_names, avoid_print, avoid_types_as_parameter_names, unnecessary_null_comparison, prefer_is_empty, unnecessary_this

import 'dart:convert';

import 'package:city_code/Screens/change_location.dart';
import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/Screens/interest_screen.dart';
import 'package:city_code/Screens/location_screen.dart';
import 'package:city_code/models/discount_type_model.dart';
import 'package:city_code/models/favourite_model.dart';
import 'package:city_code/models/mall_list_model.dart';
import 'package:city_code/models/offers_model.dart';
import 'package:city_code/models/user_details_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';

import 'offer_details_screen.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<SelectedInterestModel> classList = [];
  List<SelectedInterestModel> classLocationList = [];
  String interestName = "",
      locationName = "",
      discountName = "",
      sortName = "",
      mallName = "",
      state_id = "",
      cityid = "",
      sortid = "",
      discount_id = "",
      category_id = "",
      mall_id = "";

  List<ArrangementModel> arrangementList = [
    ArrangementModel(
        "1",
        Constants.language == "en"
            ? "Type of classification"
            : " أختر نوع التصنيف"),
    ArrangementModel(
        "2",
        Constants.language == "en"
            ? "According to the location"
            : "حسب الموقع"),
    ArrangementModel(
        "3", Constants.language == "en" ? "Near me" : "بالقرب مني"),
    ArrangementModel(
        "4", Constants.language == "en" ? "Discount type" : "نوع الخصم"),
    ArrangementModel("5", Constants.language == "en" ? "Sort By" : "صنف حسب"),
    ArrangementModel("6", Constants.language == "en" ? "By Mall" : "حسب المول"),
    // ArrangementModel(
    //   "7",
    //   Constants.language == "en" ? "Select Location " : "حسب المول",
    // )
    //: "بالمول"),
  ];

  List<bool> discountCheckBoxList = [];
  List<bool> sortCheckBoxList = [];
  List<bool> mallCheckBoxList = [];
  NetworkCheck networkCheck = NetworkCheck();

  late Future<User_details_model> userDetails;
  late Future<DiscountTypeModel> discountType = getDiscountType();
  late Future<MallListModel> mall_details = getMallList();
  late List<OfferdataData>? discountList = [];
  late List<MallData>? mallList = [];
  late Future<Offers_model> offers;
  List<Offers>? offersList = [];
  List<Favouratelist>? favList = [];
  List<String> fav = [];
  String company_image_base_url = "";

  List<String> sortBy = [
    Constants.language == "en" ? "Recently arrived" : "وصل مؤخرا",
    Constants.language == "en"
        ? "Discount (top to bottom)"
        : "الخصم (من الاعلى الى الاقل)",
    Constants.language == "en"
        ? "Discount (from bottom to top)"
        : "الخصم ( من الاقل الى الاعلى)"
  ];

  bool isChecked = false, _isLoading = false, filterShow = false;

  Future<User_details_model> getUserDetails() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(
        Uri.parse('http://185.188.127.11/public/index.php/ApiUsers/' +
            Constants.user_id),
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 200) {
        if (response_server["status"] == 201) {
          return User_details_model.fromJson(json.decode(response.body));
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

  Future<DiscountTypeModel> getDiscountType() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(
        Uri.parse("http://185.188.127.11/public/index.php/GetOfferList"),
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 201) {
        if (response_server["status"] == 201) {
          return DiscountTypeModel.fromJson(json.decode(response.body));
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

  Future<MallListModel> getMallList() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(
        Uri.parse("http://185.188.127.11/public/index.php/GetMallList"),
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 201) {
        if (response_server["status"] == 201) {
          return MallListModel.fromJson(json.decode(response.body));
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
          int count = 0;
          _getOffers().then((value) => {
                if (value.offers != null && value.offers!.length > 0)
                  {
                    if (offersList != null && offersList!.isNotEmpty)
                      {
                        offersList!.clear(),
                      },
                    for (int i = 0; i < value.offers!.length; i++)
                      {
                        if (value.offers![i].companyId! != "173")
                          {
                            offersList!.add(value.offers![i]),
                            fav.add("0"),
                          },
                      },
                    count = offersList!.length,
                    for (int i = 0; i < count; i++)
                      {
                        for (int j = i + 1; j < count; j++)
                          {
                            if (offersList![i].id == offersList![j].id)
                              {
                                offersList!.removeAt(j),
                                fav.removeAt(j),
                                count--,
                              }
                          },
                        for (int i = 0; i < favList!.length; i++)
                          {
                            for (int j = 0; j < offersList!.length; j++)
                              {
                                if (favList![i].offerId == offersList![j].id)
                                  {
                                    fav[j] = "1",
                                  }
                              }
                          }
                      }
                  },
                setState(() {
                  company_image_base_url = value.imageBaseUrl!;
                  _isLoading = false;
                })
              });
          throw Exception('Failed to load album');
        }
      } else {
        int count = 0;
        _getOffers().then((value) => {
              if (value.offers != null && value.offers!.isNotEmpty)
                {
                  if (offersList != null && offersList!.isNotEmpty)
                    {
                      offersList!.clear(),
                    },
                  for (int i = 0; i < value.offers!.length; i++)
                    {
                      if (value.offers![i].companyId! != "173")
                        {
                          offersList!.add(value.offers![i]),
                          fav.add("0"),
                        },
                    },
                  count = offersList!.length,
                  for (int i = 0; i < count; i++)
                    {
                      for (int j = i + 1; j < count; j++)
                        {
                          if (offersList![i].id == offersList![j].id)
                            {
                              offersList!.removeAt(j),
                              fav.removeAt(j),
                              count--,
                            }
                        },
                      for (int i = 0; i < favList!.length; i++)
                        {
                          for (int j = 0; j < offersList!.length; j++)
                            {
                              if (favList![i].offerId == offersList![j].id)
                                {
                                  fav[j] = "1",
                                }
                            }
                        }
                    }
                },
              setState(() {
                company_image_base_url = value.imageBaseUrl!;
                _isLoading = false;
              })
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

  Future<Offers_model> _getOffers() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      category_id = category_id.replaceAll(",", "A");
      print(
          'http://185.188.127.11/public/index.php/ApiOffers?coupon_type=city&stateid=$state_id&cityid=$cityid&sortby=$sortid&discounttype=$discount_id&category=$category_id&mallby=$mall_id');
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/ApiOffers?coupon_type=city&stateid=$state_id&cityid=$cityid&sortby=$sortid&discounttype=$discount_id&category=$category_id&mallby=$mall_id'));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
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
        "company_id": offersList![index].companyId,
        "offer_id": offersList![index].id,
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

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    if (filterShow) {
      setState(() {
        offersList!.clear();
        filterShow = false;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    discountType.then((value) => {
          if (value.offerdataData != null && value.offerdataData!.isNotEmpty)
            {
              for (int i = 0; i < value.offerdataData!.length; i++)
                {
                  discountList!.add(value.offerdataData![i]),
                  discountCheckBoxList.add(false),
                }
            }
        });
    mall_details.then((value) => {
          if (value.mallData != null && value.mallData!.isNotEmpty)
            {
              for (int i = 0; i < value.mallData!.length; i++)
                {
                  mallList!.add(value.mallData![i]),
                  mallCheckBoxList.add(false),
                }
            }
        });
    for (int i = 0; i < sortBy.length; i++) {
      sortCheckBoxList.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2CC0F),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFF2CC0F),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.arrow_left),
            color: Colors.black,
            onPressed: () {
              if (filterShow) {
                setState(() {
                  offersList!.clear();
                  filterShow = false;
                });
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            filterShow
                ? Constants.language == "en"
                    ? "Filter List"
                    : "نتائج البحث"
                : Constants.language == "en"
                    ? "Arrangement"
                    : "ترتيب",
            style: TextStyle(
              color: Colors.black,
              fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
            ),
          ),
          actions: <Widget>[
            filterShow
                ? IconButton(
                    onPressed: () {
                      Route newRoute = MaterialPageRoute(
                          builder: (context) => HomeScreen("0", ""));
                      Navigator.pushAndRemoveUntil(
                          context, newRoute, (route) => false);
                    },
                    icon: const Icon(CupertinoIcons.home),
                    color: Colors.black,
                  )
                : Container(),
          ],
        ),
        body: SafeArea(
          child: Directionality(
            textDirection: Constants.language == "en"
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: Stack(
              children: [
                Container(
                  height: height,
                  margin: const EdgeInsets.all(3.0),
                  child: filterShow
                      ? filterLayout(width, height)
                      : arrangementLayout(width, height),
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
        ),
      ),
    );
  }

  Widget filterLayout(double width, double height) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFE6D997),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: width,
                margin:
                    const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                child: Text(
                  Constants.language == "en"
                      ? "Searching Data Results :-"
                      : "نتائج البحث عن البيانات :-",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
              ),
              Container(
                width: width,
                margin:
                    const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Constants.language == "en"
                                ? "Interest"
                                : "الإهتمامات",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                            ),
                          ),
                          Text(
                            ":",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        interestName.isNotEmpty ? interestName : "All",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                margin:
                    const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Constants.language == "en" ? "Location" : "الموقع",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                            ),
                          ),
                          Text(
                            ":",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        locationName.isNotEmpty ? locationName : "All",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                margin:
                    const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Constants.language == "en" ? "Discount" : "تخفيض",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                            ),
                          ),
                          Text(
                            ":",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        discountName.isNotEmpty ? discountName : "All",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                margin:
                    const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Constants.language == "en"
                                ? "Sort By"
                                : "ترتيب حسب",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                            ),
                          ),
                          Text(
                            ":",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        sortName.isNotEmpty ? sortName : "All",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                margin: const EdgeInsets.only(
                    left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Constants.language == "en" ? "By Mall" : "حدد مول",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                            ),
                          ),
                          Text(
                            ":",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        mallName.isNotEmpty ? mallName : "All",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: GridView.builder(
            itemCount: offersList!.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: width / 657,
            ),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => OfferDetailsScreen(
                          Constants.language == "en"
                              ? offersList![index].companyName!
                              : offersList![index].companyArbName!.isNotEmpty
                                  ? offersList![index].companyArbName!
                                  : offersList![index].companyName!,
                          offersList![index].companyId!,
                          offersList![index].discountdisplay!,
                          offersList![index].id!,
                          fav[index],
                          "offers",
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
                        height: 96,
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                offersList![index].priority!.isNotEmpty &&
                                        offersList![index]
                                                .priority!
                                                .toLowerCase() !=
                                            "priority-99"
                                    ? Image(
                                        image: AssetImage(offersList![index]
                                                    .priority!
                                                    .toLowerCase() ==
                                                "priority-1"
                                            ? "images/diamond.png"
                                            : offersList![index]
                                                        .priority!
                                                        .toLowerCase() ==
                                                    "priority-2"
                                                ? "images/golden.png"
                                                : offersList![index]
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
                                    return _addOrRemoveFavOffer(index);
                                  },
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  size: width * 0.06,
                                  isLiked: fav[index] == "1" ? true : false,
                                  circleColor: const CircleColor(
                                      start: Color(0xff00ddff),
                                      end: Color(0xff0099cc)),
                                  bubblesColor: const BubblesColor(
                                    dotPrimaryColor: Color(0xff33b5e5),
                                    dotSecondaryColor: Color(0xff0099cc),
                                  ),
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      isLiked
                                          ? CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      color:
                                          isLiked ? Colors.red : Colors.black,
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
                                        offersList![index].companylogo!),
                              ),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.only(
                            left: 2.0, right: 2.0, top: 2.0),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          Constants.language == "en"
                              ? offersList![index].displayName!
                              : offersList![index].displayArbName!.isNotEmpty
                                  ? offersList![index].displayArbName!
                                  : offersList![index].displayName!,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : offersList![index]
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
                          offersList![index].discountdisplay!,
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
                              ? offersList![index].discountEnDetail!
                              : offersList![index].discountArbDetail!,
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
                            top: 1.0, left: 2.0, right: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2.0),
                              margin:
                                  const EdgeInsets.only(left: 1.0, right: 1.0),
                              width: width * 0.12,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    Constants.language == "en" ? "Days" : "يوم",
                                    style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8.0),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    offersList![index].remainingday!,
                                    style: const TextStyle(
                                      fontSize: 8.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            // Container(
                            //   padding: const EdgeInsets.all(2.0),
                            //   margin:
                            //       const EdgeInsets.only(left: 1.0, right: 1.0),
                            //   width: width * 0.09,
                            //   decoration: const BoxDecoration(
                            //       color: Colors.white,
                            //       borderRadius:
                            //           BorderRadius.all(Radius.circular(8.0))),
                            //   child: Column(
                            //     children: [
                            //       Text(
                            //         Constants.language == "en"
                            //             ? "Hours"
                            //             : "ساعة",
                            //         style: TextStyle(
                            //             fontFamily: Constants.language == "en"
                            //                 ? "Roboto"
                            //                 : "GSSFont",
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 8.0),
                            //         textAlign: TextAlign.center,
                            //       ),
                            //       Text(
                            //         offersList![index].remaininghours!,
                            //         style: const TextStyle(
                            //           fontSize: 8.0,
                            //         ),
                            //         textAlign: TextAlign.center,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Container(
                              padding: const EdgeInsets.all(2.0),
                              margin:
                                  const EdgeInsets.only(left: 1.0, right: 1.0),
                              width: width * 0.12,
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
                                        fontSize: 8.0),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    offersList![index].viewCount!,
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
                        margin: const EdgeInsets.only(top: 1.0, bottom: 10.0),
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
    );
  }

  Widget arrangementLayout(double width, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        if (arrangementList[index].id == "1") {
                          Route route = MaterialPageRoute(
                              builder: (context) =>
                                  InterestScreen("arrangement", category_id));
                          String data = await Navigator.push(context, route);
                          if (data != null) {
                            List<dynamic> dataList = jsonDecode(data);
                            classList.clear();
                            interestName = "";
                            category_id = "";
                            for (int i = 0; i < dataList.length; i++) {
                              classList.add(SelectedInterestModel(
                                  dataList[i]["id"], dataList[i]["name"]));
                              if (interestName.isNotEmpty) {
                                interestName =
                                    interestName + "," + dataList[i]["name"];
                                category_id =
                                    category_id + "," + dataList[i]["id"];
                              } else {
                                interestName = dataList[i]["name"];
                                category_id = dataList[i]["id"];
                              }
                            }
                          }
                          setState(() {
                            if (interestName.isNotEmpty) {
                              arrangementList[index].name = interestName;
                            } else {
                              arrangementList[index].name =
                                  Constants.language == "en"
                                      ? "Type of classification"
                                      : " أختر نوع التصنيف";
                            }
                          });
                        } else if (arrangementList[index].id == "2") {
                          Route route = MaterialPageRoute(
                              builder: (context) => ChangeLocation(false));
                          String data = await Navigator.push(context, route);
                          if (data != null) {
                            List<dynamic> dataList = jsonDecode(data);
                            classLocationList.clear();
                            locationName = "";
                            state_id = "";
                            cityid = "";
                            if (dataList.length == 2) {
                              state_id = dataList[0]["id"];
                              cityid = dataList[1]["id"];
                            } else {
                              state_id = dataList[0]["id"];
                              cityid = "";
                            }
                            for (int i = 0; i < dataList.length; i++) {
                              classLocationList.add(SelectedInterestModel(
                                  dataList[i]["id"], dataList[i]["name"]));
                              if (locationName.isNotEmpty) {
                                locationName =
                                    locationName + "," + dataList[i]["name"];
                              } else {
                                locationName = dataList[i]["name"];
                              }
                            }
                          }
                          setState(() {
                            if (locationName.isNotEmpty) {
                              arrangementList[index].name = locationName;
                            } else {
                              arrangementList[index].name =
                                  Constants.language == "en"
                                      ? "According to the location"
                                      : "حسب الموقع";
                            }
                          });
                        } else if (arrangementList[index].id == "4") {
                          _showDialog(context, width, "discount", index);
                        } else if (arrangementList[index].id == "5") {
                          _showDialog(context, width, "sort", index);
                        } else if (arrangementList[index].id == "6") {
                          _showDialog(context, width, "mall", index);
                        } else if (arrangementList[index].id == "7") {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => locationscreen(
                                        state:
                                            "" 'Oman, Al Batinah South,Barka',
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
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: arrangementList[index].id == "3"
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    arrangementList[index].name,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont"),
                                  ),
                                  SizedBox(
                                    width: 25.0,
                                    height: 25.0,
                                    child: Checkbox(
                                      checkColor: const Color(0xFFF2CC0F),
                                      activeColor: Colors.white,
                                      value: isChecked,
                                      onChanged: (bool? checkData) {
                                        if (checkData! == true) {
                                          userDetails = getUserDetails();
                                          String governorate = "";
                                          String city = "";
                                          userDetails.then((value) => {
                                                governorate =
                                                    Constants.language == "en"
                                                        ? value.userdetail![0]
                                                            .stateName!
                                                        : value.userdetail![0]
                                                            .arbStateName!,
                                                city =
                                                    Constants.language == "en"
                                                        ? value.userdetail![0]
                                                            .cityName!
                                                        : value.userdetail![0]
                                                            .cityArbName!,
                                                setState(() {
                                                  if (governorate.isNotEmpty &&
                                                      city.isNotEmpty) {
                                                    arrangementList[index - 1]
                                                            .name =
                                                        governorate +
                                                            "," +
                                                            city;
                                                    if (classLocationList !=
                                                            null &&
                                                        classLocationList
                                                            .isNotEmpty) {
                                                      classLocationList.clear();
                                                      classLocationList.add(
                                                          SelectedInterestModel(
                                                              value
                                                                  .userdetail![
                                                                      0]
                                                                  .stateid!,
                                                              governorate));
                                                      classLocationList.add(
                                                          SelectedInterestModel(
                                                              value
                                                                  .userdetail![
                                                                      0]
                                                                  .cityid!,
                                                              city));
                                                    } else {
                                                      classLocationList.add(
                                                          SelectedInterestModel(
                                                              value
                                                                  .userdetail![
                                                                      0]
                                                                  .stateid!,
                                                              governorate));
                                                      classLocationList.add(
                                                          SelectedInterestModel(
                                                              value
                                                                  .userdetail![
                                                                      0]
                                                                  .cityid!,
                                                              city));
                                                    }
                                                  } else {
                                                    arrangementList[index - 1]
                                                        .name = Constants
                                                                .language ==
                                                            "en"
                                                        ? "According to the location"
                                                        : "حسب الموقع";
                                                    classLocationList.clear();
                                                  }
                                                  isChecked = checkData;
                                                }),
                                              });
                                        } else {
                                          setState(() {
                                            arrangementList[index - 1]
                                                .name = Constants.language ==
                                                    "en"
                                                ? "According to the location"
                                                : "حسب الموقع";
                                            isChecked = checkData;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    arrangementList[index].name,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont"),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: Constants.language == "en"
                                        ? TextAlign.left
                                        : TextAlign.right,
                                  ),
                                  const SizedBox(
                                    width: 25.0,
                                    height: 25.0,
                                    child: Icon(
                                      CupertinoIcons.chevron_down,
                                      color: Colors.black,
                                      size: 25.0,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    Visibility(
                      child: Container(
                        height: 1.0,
                        width: width,
                        color: Colors.black,
                      ),
                      visible:
                          index + 1 == arrangementList.length ? true : false,
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  height: 1.0,
                  width: width,
                  color: Colors.black,
                );
              },
              itemCount: arrangementList.length),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          width: width,
          height: 40.0,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                filterShow = true;
                _isLoading = true;
              });
              int count = 0;
              _getFavouriteOffers().then((value) => {
                    if (value.favouratelist != null &&
                        value.favouratelist!.length > 0)
                      {
                        for (int i = 0; i < value.favouratelist!.length; i++)
                          {favList!.add(value.favouratelist![i])}
                      },
                    _getOffers().then((value) => {
                          if (value.offers != null && value.offers!.length > 0)
                            {
                              if (offersList != null && offersList!.isNotEmpty)
                                {
                                  offersList!.clear(),
                                },
                              for (int i = 0; i < value.offers!.length; i++)
                                {
                                  if (value.offers![i].companyId! != "173")
                                    {
                                      offersList!.add(value.offers![i]),
                                      fav.add("0"),
                                    },
                                },
                              count = offersList!.length,
                              for (int i = 0; i < count; i++)
                                {
                                  for (int j = i + 1; j < count; j++)
                                    {
                                      if (offersList![i].id ==
                                          offersList![j].id)
                                        {
                                          offersList!.removeAt(j),
                                          fav.removeAt(j),
                                          count--,
                                        }
                                    },
                                  for (int i = 0; i < favList!.length; i++)
                                    {
                                      for (int j = 0;
                                          j < offersList!.length;
                                          j++)
                                        {
                                          if (favList![i].offerId ==
                                              offersList![j].id)
                                            {
                                              fav[j] = "1",
                                            }
                                        }
                                    }
                                }
                            },
                          setState(() {
                            company_image_base_url = value.imageBaseUrl!;
                            _isLoading = false;
                          })
                        }),
                  });
            },
            child: Text(
              Constants.language == "en" ? "SEARCH" : "بحث",
              style: TextStyle(
                color: Colors.black,
                fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                fontSize: 18.0,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF2CC0F),
              elevation: 0.0,
              textStyle: const TextStyle(color: Colors.black),
              fixedSize: Size(MediaQuery.of(context).size.width, 30.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
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

  _showDialog(BuildContext context, double width, String which_click,
      int position) async {
    Dialog discountTypeDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      //this right here
      child: StatefulBuilder(builder: (context, setState) {
        return Directionality(
          textDirection: Constants.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: SizedBox(
            child: Column(
              children: [
                Container(
                  width: width,
                  margin: const EdgeInsets.all(10.0),
                  child: Text(
                    Constants.language == "en"
                        ? "Select Discount Type"
                        : "حدد نوع الخصم",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                    ),
                    textAlign: Constants.language == "en"
                        ? TextAlign.left
                        : TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Constants.language == "en"
                                    ? discountList![index].stName!
                                    : discountList![index].stArbName!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                ),
                                textAlign: Constants.language == "en"
                                    ? TextAlign.left
                                    : TextAlign.right,
                              ),
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: const Color(0xFFF2CC0F),
                                value: discountCheckBoxList[index],
                                onChanged: (bool? checkData) {
                                  setState(() {
                                    for (int i = 0;
                                        i < discountCheckBoxList.length;
                                        i++) {
                                      if (discountCheckBoxList[i] == true) {
                                        discountCheckBoxList[i] = false;
                                        break;
                                      }
                                    }
                                    discountCheckBoxList[index] =
                                        checkData ?? false;
                                    if (discountCheckBoxList[index] == true) {
                                      Navigator.pop(
                                          context,
                                          Constants.language == "en"
                                              ? discountList![index].stName!
                                              : discountList![index]
                                                  .stArbName!);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 1.0,
                          width: width,
                          color: Colors.black,
                        );
                      },
                      itemCount: discountList!.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );

    Dialog sortByDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: StatefulBuilder(builder: (context, setState) {
        return Directionality(
          textDirection: Constants.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: SizedBox(
            height: 250,
            child: Column(
              children: [
                Container(
                  width: width,
                  margin: const EdgeInsets.all(10.0),
                  child: Text(
                    Constants.language == "en" ? "Sort By" : "صنف حسب",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                    ),
                    textAlign: Constants.language == "en"
                        ? TextAlign.left
                        : TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * 0.50,
                                child: Text(
                                  sortBy[index],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                  ),
                                  textAlign: Constants.language == "en"
                                      ? TextAlign.left
                                      : TextAlign.right,
                                ),
                              ),
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: const Color(0xFFF2CC0F),
                                value: sortCheckBoxList[index],
                                onChanged: (bool? checkData) {
                                  setState(() {
                                    for (int i = 0;
                                        i < sortCheckBoxList.length;
                                        i++) {
                                      if (sortCheckBoxList[i] == true) {
                                        sortCheckBoxList[i] = false;
                                        break;
                                      }
                                    }
                                    sortCheckBoxList[index] =
                                        checkData ?? false;
                                    if (sortCheckBoxList[index] == true) {
                                      Navigator.pop(context, sortBy[index]);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 1.0,
                          width: width,
                          color: Colors.black,
                        );
                      },
                      itemCount: sortBy.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );

    Dialog mallDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: StatefulBuilder(builder: (context, setState) {
        return Directionality(
          textDirection: Constants.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: SizedBox(
            height: 450,
            child: Column(
              children: [
                Container(
                  width: width,
                  margin: const EdgeInsets.all(10.0),
                  child: Text(
                    Constants.language == "en" ? "Select Mall" : "حدد مول",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                    ),
                    textAlign: Constants.language == "en"
                        ? TextAlign.left
                        : TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * 0.50,
                                child: Text(
                                  Constants.language == "en"
                                      ? mallList![index].mallName!
                                      : mallList![index].arabicMallName!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                  ),
                                  textAlign: Constants.language == "en"
                                      ? TextAlign.left
                                      : TextAlign.right,
                                ),
                              ),
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: const Color(0xFFF2CC0F),
                                value: mallCheckBoxList[index],
                                onChanged: (bool? checkData) {
                                  setState(() {
                                    for (int i = 0;
                                        i < mallCheckBoxList.length;
                                        i++) {
                                      if (mallCheckBoxList[i] == true) {
                                        mallCheckBoxList[i] = false;
                                        break;
                                      }
                                    }
                                    mallCheckBoxList[index] =
                                        checkData ?? false;
                                    if (mallCheckBoxList[index] == true) {
                                      Navigator.pop(
                                          context,
                                          Constants.language == "en"
                                              ? mallList![index].mallName!
                                              : mallList![index]
                                                  .arabicMallName!);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 1.0,
                          width: width,
                          color: Colors.black,
                        );
                      },
                      itemCount: mallList!.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );

    var data = await showDialog(
        context: context,
        builder: (BuildContext context) => which_click == "discount"
            ? discountTypeDialog
            : which_click == "sort"
                ? sortByDialog
                : mallDialog);

    setState(() {
      if (data == null || data == "") {
        if (which_click == "discount") {
          arrangementList[position].name =
              Constants.language == "en" ? "Discount type" : "نوع الخصم";
        } else if (which_click == "sort") {
          arrangementList[position].name =
              Constants.language == "en" ? "Sort By" : "صنف حسب";
        } else {
          arrangementList[position].name =
              Constants.language == "en" ? "By Mall" : "حسب المول";
        }
      } else {
        if (which_click == "discount") {
          discountName = data;
          for (int i = 0; i < discountList!.length; i++) {
            if (discountName == discountList![i].stName ||
                discountName == discountList![i].stArbName) {
              discount_id = discountList![i].stId!;
              break;
            }
          }
        } else if (which_click == "sort") {
          sortName = data;
          if (sortName == "Recently arrived" || sortName == "وصل مؤخرا") {
            sortid = "1";
          } else if (sortName == "Discount (top to bottom)" ||
              sortName == "الخصم (من الاعلى الى الاقل)") {
            sortid = "2";
          } else {
            sortid = "3";
          }
        } else {
          mallName = data;
          for (int i = 0; i < mallList!.length; i++) {
            if (mallName == mallList![i].mallName ||
                mallName == mallList![i].arabicMallName) {
              mall_id = mallList![i].id!;
              break;
            }
          }
        }
        arrangementList[position].name = data;
      }
    });
  }
}

class SelectedInterestModel {
  String id, name;

  SelectedInterestModel(this.id, this.name);

  Map<String, dynamic> toJson() {
    return {"id": this.id, "name": this.name};
  }
}

class ArrangementModel {
  String id, name;

  ArrangementModel(this.id, this.name);
}
