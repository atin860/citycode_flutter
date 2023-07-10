// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, avoid_print, unused_local_variable, unnecessary_new, must_be_immutable, avoid_unnecessary_containers, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, unnecessary_null_comparison, avoid_types_as_parameter_names, deprecated_member_use
import 'dart:convert';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:city_code/Screens/book_now_sceen.dart';
import 'package:city_code/Screens/chat_screen.dart';
import 'package:city_code/Screens/couponui_screen.dart';
import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/Screens/location_screen.dart';
import 'package:city_code/Screens/utildemo.dart';
import 'package:city_code/Screens/web_view_screen.dart';
import 'package:city_code/models/Newclass.dart';
// import 'package:city_code/models/company_details_model.dart';
import 'package:city_code/models/company_details_model_1.dart';
import 'package:city_code/models/company_products_model.dart';
import 'package:city_code/models/couponlistmodel.dart';
import 'package:city_code/models/couponpurchasedmodel.dart';
import 'package:city_code/models/home_banner_model.dart';
import 'package:city_code/models/menu_list_model.dart';
import 'package:city_code/models/offers_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferDetailsScreen extends StatefulWidget {
  String company_name,
      company_id,
      discount,
      offer_id,
      isFavourite,
      type,
      coupoName,
      coupondata,
      couponid,
      couponprice;

  OfferDetailsScreen(
      this.company_name,
      this.company_id,
      this.discount,
      this.offer_id,
      this.isFavourite,
      this.type,
      this.coupoName,
      this.coupondata,
      this.couponid,
      this.couponprice,
      {Key? key})
      : super(key: key);

  @override
  _OfferDetailsScreenState createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  mainFun() async {
    final pref = await SharedPreferences.getInstance();
// pref.getString('latitude');
    double myLat = pref.getDouble('latitude') ?? 0.0;
    double myLong = pref.getDouble('longitude') ?? 0.0;

    // Sort the list based on proximity to the given location
    companyBranchList!.sort(
      (user1, user2) {
        double distance1 = calculateDistance(double.parse(user1.latitude),
            double.parse(user1.longitude), myLat, myLong);
        double distance2 = calculateDistance(double.parse(user2.latitude),
            double.parse(user2.longitude), myLat, myLong);

        return distance1.compareTo(distance2);
      },
    );

    setState(() {});
  }

// Function to generate a random latitude between -90 and 90 degrees
  double getRandomLat() {
    return Random().nextDouble() * 180 - 90;
  }

// Function to generate a random longitude between -180 and 180 degrees
  double getRandomLong() {
    return Random().nextDouble() * 360 - 180;
  }

// Function to calculate the distance between two coordinates in kilometers
  double calculateDistance(
      double lat1, double long1, double lat2, double long2) {
    const double earthRadius = 6371; // km

    double dLat = degreesToRadians(lat2 - lat1);
    double dLong = degreesToRadians(long2 - long1);

    double a = pow(sin(dLat / 2), 2) +
        cos(degreesToRadians(lat1)) *
            cos(degreesToRadians(lat2)) *
            pow(sin(dLong / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

// Function to convert degrees to radians
  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  bool _isLoading = true,
      productPrice = false,
      menu_List = false,
      company_info = false,
      coupontype = false,
      couponclick = false;
  int _currentPosition = 0;
  String imageBaseUrl = "",
      location = "",
      website = "",
      app_store = "",
      play_store = "",
      huawei_store = "",
      phone = "",
      whatsapp = "",
      email = "",
      instagram = "",
      snapchat = "",
      branch_id = "",
      company_image = "",
      companyid = "",
      fastdel = "",
      specialdel = "";
  double lat1 = 0.0, long1 = 0.0;
  double longbuynow = 0.0, latbuynow = 0.0;

  TextEditingController suggestion_controller = TextEditingController();

  late Future<CompanyDetailsModel1> company_details = _getCompanyDetails();
  late Future<Offers_model> offer_details = _getPublicOffers();
  List<CompanyBanner>? companyBannerList = [];
  List<CompanyBranch>? companyBranchList = [];
  List<Banner_list>? bannerList = [];
  List<Productlist>? productlist = [];
  List<String> selectedBranch = [];
  List<Menulist>? menulist = [];
  String description = "";
  String banner_base_url = "", product_image_base_url = "", menu_base_url = "";
  String branchname = "";
  String branchid = "";
  String arbbranchname = "";
  String selectedBranchName = '';

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  var coupondata = "";
  var companyname = "";
  var couponename = "";
  var couponamount = "";
  var couponeprice = "";
  var startdate = "";
  var enddate = "";
  int index = 0;
  var coupondetail = "";
  var couponstatus = "";

  List<CouponList> couponlistdata = [];
  Future<void> couponlist() async {
    Map<String, String> jsonbody = {
      "companyid": companyid,
      "branchid": branch_id,

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
    couponstatus = model.status.toString();

    print("couponlistbranch" + companyid);
    print("couponlistbranch" + branch_id);

    setState(() {
      //  print("datalist122"+coupondata.length.toString());
      //  print("datalist2"+couponlistdata!.length.toString());
      if (model.couponList != null) {
        couponlistdata = model.couponList!;
        companyname = couponlistdata[index].companyName.toString();
        couponename = couponlistdata[index].couponName.toString();
        couponamount = couponlistdata[index].couponAmount.toString();
        couponeprice = couponlistdata[index].couponPrice.toString();
        startdate = couponlistdata[index].startDate.toString();
        enddate = couponlistdata[index].endDate.toString();
        coupondetail = Constants.language == "en"
            ? couponlistdata[index].couponDetails.toString()
            : couponlistdata[index].arbdetail.toString();
        print("couponlength" + couponlistdata.length.toString());
        print("datae" + couponlistdata.toString());
      }
    });

    print(couponamount);
    print("dgdsgdsg" + stat);

    if (stat.contains("201")) {
      if (couponlistdata.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        setState(() {
          print("yesss");
          coupontype = true;

          //  couponclick=!couponclick;
        });
        Fluttertoast.showToast(
            msg: " Coupons Not Available. ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      setState(() {
        //  _isLoading=false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    print("couponbhailist" + res!.toString());
    setState(() {
      // _isLoading=false;
    });
  }

  Future<void> couponperchased(String userID) async {
    Map<String, String> jsonbody = {
      "couponid": userID,
      "userid": Constants.user_id,

      /*   "ad_1":_ads_1_file,
      "ad_2":_ads_2_file.toString(),
      "ad_3":_ads_3_file.toString(),
      "ad_4":_ads_4_file.toString(),
*/
    };
    var network = NewVendorApiService();
    String urls = "http://cp.citycode.om/public/index.php/couponpurchase";
    var res = await network.postresponse(urls, jsonbody);
    var model = Couponpurchasedmodel.fromJson(res);
    String stat = model.status.toString();
    couponstatus = model.status.toString();

    setState(() {});

    print(couponamount);
    print("dgdsgdsg" + stat);

    if (stat.contains("201")) {
      alertShow(context, "success");
      if (couponlistdata.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        setState(() {
          print("yesss");
          coupontype = true;

          //  couponclick=!couponclick;
        });
      }

      setState(() {
        //  _isLoading=false;
      });
    } else {
      alertShow(context, "error");
      setState(() {
        _isLoading = false;
      });
    }
    print("mainscreen" + res!.toString());
    setState(() {
      // _isLoading=false;
    });
  }

  var qtycoupon = "";
  var clicked = "0";
  // var data="";
  int tindex = 0;
  List<CouponList>? mylsit = [];
  List<CouponList>? mysecondlsit = [];
  List<CouponList>? couponlistavailble = [];
  Future<void> couponlistavailable() async {
    Map<String, String> jsonbody = {
      "companyid": widget.company_id,
      "branchid": branch_id,
    };
    String url = "http://cp.citycode.om/public/index.php/couponlist";
    var network = new NewVendorApiService();
    var response = await network.postresponse(url, jsonbody);
    var model = Couponlistmodel.fromJson(response);
    var status = model.status.toString();
    print("companyid" + companyid);
    print("branch_id" + branch_id);
    print("fisrt");

    setState(() {
      couponlistavailble = model.couponList;
    });
    /*for(var data in couponlistavailble!){
      qtycoupon=data.couponQuantity.toString();
    }*/
    print("second");
    //  qtycoupon=couponlistavailble![index].couponQuantity.toString();
    setState(() {
      _isLoading = true;
    });
    if (status.contains("201")) {
      if (couponlistavailble != null && couponlistavailble!.isNotEmpty) {
        for (int i = 0; i < couponlistavailble!.length; i++) {
          tindex = i;
        }
      }
      var id = "";
      //coupondata_availble();
      var com_id = "";
      var br_id = "";
      for (var data in couponlistavailble!) {
        print("hewloo1");
        print("my coupon" + data.id.toString());
        print("yourcoupon" + widget.couponid);
        if (data.id.toString() == widget.couponid) {
          print("hewloo");
          mylsit!.add(CouponList(
              couponQuantity: data.couponQuantity,
              id: data.id,
              companyId: data.companyId,
              branchId: data.branchId));
        }
      }
      setState(() {
        _isLoading = true;
      });
      for (var data in mylsit!) {
        qtycoupon = data.couponQuantity.toString();
        id = data.id.toString();
        com_id = data.companyId.toString();
        br_id = data.branchId.toString();
        print("iddd" + id.toString());
      }
      print(mylsit);
      //  var qtycoupon1=couponlistavailble![index].couponName.toString();
      //  qtycoupon=mylsit![tindex].couponQuantity.toString();
      if (qtycoupon.isEmpty) {
        // qtycoupon=data.couponQuantity.toString();
        print("no coupposns");
        alertShow(context, "Notavailable");
      } else {
        print("coupons");
        if (clicked == "0") {
          clicked = "1";
          var userid = widget.couponid;
          //  couponperchased(userid);
          coupondata_availble(com_id, br_id);
        } else {
          _alertDialog("Coupon is Purchased !");
        }
      }
      print("third");
      // qtycoupon=couponlistavailble![index].couponQuantity.toString();
      print("forth");
      if (qtycoupon.isEmpty) {
      } else {
        print("fift");
      }

      print("couponslist" + response.toString());
      print("arebaba" + qtycoupon);
      //   print("arebaba1"+qtycoupon1);

      setState(() {
        _isLoading = false;
      });
    } else {
      alertShow(context, "Notavailable");
    }
    print("couponlistavailable" + response.toString());
  }

  List<CouponList>? coupondataavailble = [];
  Future<void> coupondata_availble(var compid, var brid) async {
    Map<String, String> jsonbody = {
      "companyid": compid,
      "branchid": brid,

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
    couponstatus = model.status.toString();

    print("couponlistbranch" + companyid);
    print("couponlistbranch" + branch_id);

    setState(() {
      couponlistdata = model.couponList!;
    });

    print(couponamount);
    print("dgdsgdsg" + stat);
    var qty = "";

    if (stat.contains("201")) {
      for (var data in couponlistdata) {
        if (data.id.toString() == widget.couponid) {
          mysecondlsit!.add(CouponList(
            couponQuantity: data.couponQuantity,
            id: data.id,
          ));
        }
      }
      for (var data in mysecondlsit!) {
        print("qtyzz" + qty.toString());
        qty = data.couponQuantity.toString();
      }
      if (qty.isEmpty) {
        print("no coupposns");
        alertShow(context, "Notavailable");
      } else {
        var userid = widget.couponid;
        couponperchased(userid);
      }

      setState(() {
        //  _isLoading=false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    print("coupondatalistreort" + res!.toString());
    setState(() {
      // _isLoading=false;
    });
  }

  Future<CompanyDetailsModel1> _getCompanyDetails() async {
    print('http://185.188.127.11/public/index.php/ApiCompany/' +
        widget.company_id);
    final response = await http.get(
      Uri.parse('http://185.188.127.11/public/index.php/ApiCompany/' +
          widget.company_id),
    );

    var responseServer = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (responseServer["status"] == 201) {
        return CompanyDetailsModel1.fromJson(json.decode(response.body));
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
  }

  Future<Offers_model> _getPublicOffers() async {
    final response = await http.get(Uri.parse(
        'http://185.188.127.11/public/index.php/ApiOffers?coupon_type=homebusiness'));
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
  }

  Future<bool> _addOrRemoveFavOffer(bool isBool) async {
    if (widget.type == "online" || widget.type == "home") {
      if (isBool) {
        return false;
      } else {
        return true;
      }
    } else {
      final body = {
        "customer_id": Constants.user_id,
        "company_id": widget.company_id,
        "offer_id": widget.offer_id,
      };

      final http.Response response;
      if (widget.isFavourite == "0") {
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
          if (widget.isFavourite == "0") {
            if (Constants.language == "en") {
              _alertDialog("Added Successfully");
            } else {
              _alertDialog("اضيف بنجاح");
            }
            setState(() {
              widget.isFavourite = "1";
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
              widget.isFavourite = "0";
              _isLoading = false;
            });
            return false;
          }
        } else {
          if (widget.isFavourite == "0") {
            setState(() {
              widget.isFavourite = "0";
              _isLoading = false;
            });
            if (Constants.language == "en") {
              _alertDialog("Failed to favourite");
            } else {
              _alertDialog("فشل إضافة المفضلة");
            }
            return false;
          } else {
            setState(() {
              widget.isFavourite = "1";
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
        if (widget.isFavourite == "0") {
          return false;
        } else {
          return true;
        }
      }
    }
  }

  Future<Home_banner_model> getHomeBanner(String screen) async {
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
        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        if (screen == "company") {
          _currentPosition = 0;
          productPrice = false;
          company_info = true;
          _isLoading = false;
        } else {
          _getCompanyProducts().then((value) => {
                if (value.productlist != null && value.productlist!.isNotEmpty)
                  {
                    for (int i = 0; i < value.productlist!.length; i++)
                      {
                        productlist!.add(value.productlist![i]),
                      }
                  },
                setState(() {
                  product_image_base_url = value.productImageBaseUrl!;
                  productPrice = true;
                  _isLoading = false;
                }),
              });
        }
      });
      if (Constants.language == "en") {
        _alertDialog("Something went wrong");
      } else {
        _alertDialog("هناك خطأ ما");
      }
      throw Exception('Failed to load album');
    }
  }

  Future<CompanyProductsModel> _getCompanyProducts() async {
    String discount = "0";
    if (widget.discount.contains("%")) {
      discount = widget.discount.replaceAll("%", "");
    } else {
      discount = widget.discount;
    }
    final response = await http.get(
      // Uri.parse(
      //     'http://185.188.127.11/public/index.php/companyproduct?company_id=' +
      //         widget.company_id +
      //         "&show_inredeem=0"),
      Uri.parse(
          'http://185.188.127.11/public/index.php/companyproduct?company_id=${widget.company_id}&show_inredeem=0&branch_id=${branch_id}&discount_offer=${discount}'),
    );

    var responseServer = jsonDecode(response.body);

    if (kDebugMode) {
      print(responseServer);
    }
    /*if(couponlistdata!.isEmpty){
      _alertDialog(Constants.language == "en"
          ? "No Products Available ee"
          : "لا توجد منتجات متاحة");
    }*/
    if (response.statusCode == 201) {
      if (responseServer["status"] == 201) {
        return CompanyProductsModel.fromJson(json.decode(response.body));
      } else {
        if (responseServer["status"] == 404 || couponlistdata.isEmpty) {
          _alertDialog(Constants.language == "en"
              ? "No Products Available"
              : "لا توجد منتجات متاحة");
        } else {
          _alertDialog(Constants.language == "en"
              ? "Something went wrong"
              : "هناك خطأ ما");
        }
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load album');
      }
    } else {
      if (response.statusCode == 404) {
        _alertDialog(Constants.language == "en"
            ? "No Products Available"
            : "لا توجد منتجات متاحة");
      } else {
        _alertDialog(Constants.language == "en"
            ? "Something went wrong"
            : "هناك خطأ ما");
      }
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load album');
    }
  }

  Future<MenuListModel> _getMenuList() async {
    final response = await http.get(
      Uri.parse(
          'http://185.188.127.11/public/index.php/ApiMenulist?company_id=' +
              widget.company_id +
              "&branch_id=" +
              branch_id),
    );

    var responseServer = jsonDecode(response.body);

    if (kDebugMode) {
      print(responseServer);
    }

    if (response.statusCode == 201) {
      if (responseServer["status"] == 201) {
        return MenuListModel.fromJson(json.decode(response.body));
      } else {
        _alertDialog(Constants.language == "en"
            ? "Menu not available"
            : "القائمة غير متوفرة");
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load album');
      }
    } else {
      if (response.statusCode == 404) {
        _alertDialog(Constants.language == "en"
            ? "Menu not available"
            : "القائمة غير متوفرة");
      } else {
        _alertDialog(Constants.language == "en"
            ? "Something went wrong"
            : "هناك خطأ ما");
      }
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load album');
    }
  }

  Future<void> postSubmitData() async {
    final body = {
      "userid": Constants.user_id,
      "companyid": widget.company_id,
      "details": suggestion_controller.text
    };

    final response = await http.post(
      Uri.parse('http://185.188.127.11/public/index.php/ApiCompanyenquiry'),
      body: body,
    );

    if (response.statusCode == 201) {
      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response_server["status"] == 201) {
        setState(() {
          _isLoading = false;
        });
        _alertShow(context, "success");
        /*_alertDialog(Constants.language == "en"
            ? "Enquiry submitted successfully"
            : "تم إرسال الاستفسار بنجاح");*/
      } else {
        setState(() {
          _isLoading = false;
        });
        _alertDialog(Constants.language == "en"
            ? "Enquiry submission failed"
            : "فشل تقديم الاستفسار");
        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Enquiry submission failed"
          : "فشل تقديم الاستفسار");
      throw Exception('Failed to load album');
    }
    suggestion_controller.clear();
  }

  _alertShow(BuildContext context, String type) {
    CoolAlert.show(
      backgroundColor: const Color(0xFFF2CC0F),
      context: context,
      type: type == "success" ? CoolAlertType.success : CoolAlertType.error,
      text: type == "success"
          ? Constants.language == "en"
              ? "Message has been sent"
              : "تم ارسال الرسالة"
          : Constants.language == "en"
              ? "Message not sent"
              : "لم يتم إرسال الرسالة",
      confirmBtnText: Constants.language == "en" ? "Continue" : "أستمرار",
      barrierDismissible: true,
      confirmBtnColor: const Color(0xFFF2CC0F),
      confirmBtnTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont"),
      onConfirmBtnTap: () {
        if (type == "success") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen("0", "")));
          Navigator.of(context, rootNavigator: true).pop();
          //_alertShow(context,type);
          //Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen("0"));
          //  Navigator.of(context, rootNavigator: true).pop();
          //Navigator.pushAndRemoveUntil(context, newRoute, (route) => true);
          //Navigator.popAndPushNamed(context,"newRoute");
          /*  Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen("0"),
            ),
                (route) => false,
          );*/
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();
        }
      },
    );
  }

  Future<void> getAddCount() async {
    final response = await http.get(
      Uri.parse(
          'http://185.188.127.11/public/index.php/viewcount?company_id=${widget.company_id}&offer_id=${widget.offer_id}'),
    );

    var response_server = jsonDecode(response.body);

    if (kDebugMode) {
      print(response_server);
    }

    if (response.statusCode == 200) {
      if (response_server["status"] == 201) {
      } else {}
    } else {}
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

  int tempindex = 0;

  var companyiddat = "";
  Future<void> share() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    companyiddat = pref.setString('companyiddata', companyid).toString();
    pref.setString('companybranchdata', branch_id);
    print("data2" + companyiddat.toString());
  }

  double VAT = 0.000;

  double longitude = 0.00000;
  double latitude = 0.0000;
  late LocationPermission permission;
  late bool serviceEnabled = false;
  var Pos;
  Future<void> _getLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        print("start form here");
        Pos = position;
        // distanceCalculation(position);
        latitude = position.latitude;
        longitude = position.longitude;
        print("rohanlat" + latitude.toString());
        print("rohanlong" + longitude.toString());
      } else {
        await Geolocator.openLocationSettings();
      }
    } else {
      permission = await Geolocator.requestPermission();
    }
  }

  var km = 0.0;
  var kmete = 0.0;
  var kmeter = 0.0;
  distanceCalculation(Position position) {
    for (var d in companyBranchList!) {
      print("here my code");
      var latitude = double.parse(d.latitude);
      var longitude = double.parse(d.longitude);
      km = getDistanceFromLatLonInKm(
          position.latitude, position.longitude, lat1, long1);
      print("longitude" + lat1.toString());
      print("kilodata" + km.toString());
      // var m = Geolocator.distanceBetween(position.latitude,position.longitude, d.lat,d.lng);
      // d.distance = m/1000;
      // var dis=d.distance.toString();
      //d.distance = km;
      //CompanyDetailsModel!.add(d);
      print("distancebhai" + d.distance.toString());
      // print(getDistanceFromLatLonInKm(position.latitude,position.longitude, d.lat,d.lng));
    }
    setState(() {
      companyBranchList!.sort((a, b) {
        var x = Geolocator.distanceBetween(
            double.parse(a.latitude),
            double.parse(a.longitude),
            double.parse(b.latitude),
            double.parse(b.longitude));
        a.latitude.compareTo(b.latitude);
        // double(a!.latitude!).compareTo(double.parse(b.latitude)) ;
        // a.(double.parse(a.distance!)).

        return km.compareTo(kmete);
      });
    });
  }

  @override
  void initState() {
    _getLocation();

    if (widget.couponprice.isNotEmpty) {
      VAT = ((double.parse(widget.couponprice)) * (100 + 0.5) / 100);
    }

    // print("companyid" + widget.company_id);
    // print("type" + widget.type);
    // print("couponid" + widget.couponid);
    // print("companyname" + widget.company_name);
    // print("coupondata" + widget.coupondata);
    // print("couponname" + widget.coupoName);
    // print("discount" + widget.discount);
    // print("favourite" + widget.isFavourite);
    // print("offerid" + widget.offer_id);
    // print("widget.couponprice." + widget.couponprice);

    if (couponlistdata != null && couponlistdata.isNotEmpty) {
      for (int i = 0; i < couponlistdata.length; i++) {
        setState(() {
          index = i;
          couponlist();
          print("datff" + couponamount);
        });
      }
    }
    imageBaseUrl = "http://cp.citycode.om/public/company/";
    getAddCount();
    offer_details.then((value) => {
          print("here"),
          if (value.offers != null && value.offers!.isNotEmpty)
            {
              print("go"),
              for (int i = 0; i < value.offers!.length; i++)
                {
                  if (widget.company_id == value.offers![i].companyId)
                    {
                      setState(() {
                        phone = value.offers![i].hMobileNo!;
                        whatsapp = value.offers![i].hWhatsappNo!;
                        email = value.offers![i].hEmail!;
                        instagram = value.offers![i].hInstagram!;
                        description = Constants.language == "en"
                            ? value.offers![i].description!
                            : value.offers![i].arbDescription!;

                        _isLoading = false;
                      }),
                    }
                },
            },
        });

    company_details.then((value) => {
          if (widget.type != "home")
            {
              print("hello"),
              setState(() {
                imageBaseUrl = value.imageBaseUrl;
                phone = value.companydetails[0].mobile;
                whatsapp = value.companydetails[0].whatsapp;
                email = value.companydetails[0].email;
                instagram = value.companydetails[0].instagram;
                snapchat = value.companydetails[0].snapchat;
                company_image = imageBaseUrl + value.companydetails[0].picture;
              }),
            },
          if (value.companyBanner != null && value.companyBanner.isNotEmpty)
            {
              companyBannerList!.clear(),
              for (int i = 0; i < value.companyBanner.length; i++)
                {
                  setState(() {
                    companyBannerList!.add(value.companyBanner[i]);
                  }),
                }
            },
          if (value.companyBranch != null && value.companyBranch.isNotEmpty)
            {
              for (int i = 0; i < value.companyBranch.length; i++)
                {
                  if (widget.type == "online")
                    {
                      companyBranchList!.add(value.companyBranch[i]),
                    }
                  else
                    {
                      if (value.companyBranch[i].branchOffers != null &&
                          value.companyBranch[i].branchOffers.isNotEmpty)
                        {
                          for (int j = 0;
                              j < value.companyBranch[i].branchOffers.length;
                              j++)
                            {
                              if (widget.discount.isNotEmpty)
                                {
                                  if (widget.discount ==
                                      value.companyBranch[i].branchOffers[j]
                                          .discountdisplay)
                                    {
                                      companyBranchList!
                                          .add(value.companyBranch[i]),
                                    }
                                }
                              else
                                {
                                  companyBranchList!
                                      .add(value.companyBranch[i]),
                                }
                            }
                        },
                    },
                }
            },
          if (companyBranchList != null && companyBranchList!.isNotEmpty)
            {
              for (int i = 0; i < companyBranchList!.length; i++)
                {
                  for (int j = i + 1; j < companyBranchList!.length; j++)
                    {
                      if (companyBranchList![i].branchId ==
                          companyBranchList![j].branchId)
                        {
                          companyBranchList!.removeAt(j),
                          j--,
                        }
                    }
                },
              if (companyBranchList != null && companyBranchList!.isNotEmpty)
                {
                  for (int i = 0; i < companyBranchList!.length; i++)
                    {
                      if (i == 0)
                        {
                          selectedBranch.add("1"),
                        }
                      else
                        {
                          selectedBranch.add("0"),
                        }
                    }
                }
            },
          if (companyBranchList != null && companyBranchList!.isNotEmpty)
            {
              for (int i = 0; i < companyBranchList!.length; i++)
                {
                  if (companyBranchList![i].branchOffers != null &&
                      companyBranchList![i].branchOffers.isNotEmpty)
                    {
                      for (int j = 0;
                          j < companyBranchList![i].branchOffers.length;
                          j++)
                        {
                          if (widget.discount.isNotEmpty)
                            {
                              if (widget.discount !=
                                  companyBranchList![i]
                                      .branchOffers[j]
                                      .discountdisplay)
                                {
                                  companyBranchList![i]
                                      .branchOffers
                                      .removeAt(j),
                                  j--,
                                }
                            }
                        },
                      if (companyBranchList![i].branchOffers == null ||
                          companyBranchList![i].branchOffers.isEmpty)
                        {
                          companyBranchList!.removeAt(i),
                          i--,
                        }
                    }
                }
            },
          setState(() {
            _isLoading = false;
          }),
          branchname = companyBranchList![0].branchName,
          branchid = companyBranchList![0].branchId,
          arbbranchname = companyBranchList![0].arbBranchName,
          companyid = companyBranchList![0].companyId,
          print("companyid" + companyid),
          share(),
          setState(() {
            imageBaseUrl = value.imageBaseUrl;
            widget.discount = companyBranchList!.isNotEmpty
                ? companyBranchList![0].branchOffers[0].discountdisplay
                : "";
            branch_id = widget.type == "online" || widget.type == "home"
                ? ""
                : companyBranchList![0].branchId;
            description = widget.type == "online"
                ? Constants.language == "en"
                    ? value.companydetails[0].onlineDescription
                    : value.companydetails[0].onlineArbDescription
                : widget.type == "home"
                    ? ""
                    : Constants.language == "en"
                        ? companyBranchList![0].branchOffers[0].description
                        : companyBranchList![0].branchOffers[0].arbDescription;
            location = widget.type == "online" || widget.type == "home"
                ? value.companydetails[0].cLocation
                : companyBranchList![0].location;
            website = widget.type == "online"
                ? value.companydetails[0].onlineLink
                : "";
            app_store = widget.type == "online"
                ? value.companydetails[0].onlineIosLink
                : "";
            play_store = widget.type == "online"
                ? value.companydetails[0].onlinePlaystoreLink
                : "";
            huawei_store = widget.type == "online"
                ? value.companydetails[0].onlineHuaweiLink
                : "";
            fastdel = companyBranchList![0].fastDeliveryCharges.toString();
            specialdel =
                companyBranchList![0].specialDeliveryCharges.toString();
            _isLoading = false;
          })
        });
    Future.delayed(
      const Duration(seconds: 1),
      () {
        mainFun();
      },
    );

    super.initState();
  }

  alertShow(BuildContext context, String type) {
    CoolAlert.show(
      backgroundColor: const Color(0xFFF2CC0F),
      context: context,
      type: type == "success"
          ? CoolAlertType.success
          : type == "Notavailable"
              ? CoolAlertType.warning
              : CoolAlertType.warning,
      title: type == "success"
          ? Constants.language == "en"
              ? "Coupon Purchased"
              : "القسيمة هنا"
          : type == "Notavailable"
              ? Constants.language == "en"
                  ? "Alert"
                  : "يُحذًِر"
              : Constants.language == "en"
                  ? "Alert"
                  : "يُحذًِر",
      text: type == "success"
          ? Constants.language == "en"
              ? "Online Payment"
              : "تم ارسال الرسالة"
          : type == "Notavailable"
              ? Constants.language == "en"
                  ? "Coupons Not Available"
                  : "القسائم غير متوفرة"
              : Constants.language == "en"
                  ? "You have already Coupon."
                  : "لديك بالفعل قسيمة.",
      confirmBtnText: Constants.language == "en" ? "Done" : "أستمرار",
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
          //savedata();

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen("0", "")));
          Navigator.of(context, rootNavigator: true).pop();
          //_alertShow(context,type);
          //Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen("0"));
          //  Navigator.of(context, rootNavigator: true).pop();
          //Navigator.pushAndRemoveUntil(context, newRoute, (route) => true);
          //Navigator.popAndPushNamed(context,"newRoute");
          /*  Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen("0"),
            ),
                (route) => false,
          );*/
        } else if (type == "Notavailable") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen("0", "")));
          Navigator.of(context, rootNavigator: true).pop();
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen("0", "")));
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      onCancelBtnTap: () {
        if (type == "success") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen("0", "")));
          //savedata();
          //  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen("0")));
          Navigator.of(context, rootNavigator: true).pop();
          //_alertShow(context,type);
          //Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen("0"));
          //  Navigator.of(context, rootNavigator: true).pop();
          //Navigator.pushAndRemoveUntil(context, newRoute, (route) => true);
          //Navigator.popAndPushNamed(context,"newRoute");
          /*  Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen("0"),
            ),
                (route) => false,
          );*/
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen("0", "")));
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
    );
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    if (productPrice || menu_List || company_info) {
      setState(() {
        productPrice = false;
        menu_List = false;
        company_info = false;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    //   branchname=companyBranchList![index].branchName!;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFF2CC0F),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.arrow_left),
            color: Colors.black,
            onPressed: () {
              if (productPrice || menu_List || company_info || couponclick) {
                setState(() {
                  productPrice = false;
                  menu_List = false;
                  company_info = false;
                  couponclick = false;
                  // coupontype=false;
                });
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                //color: Colors.white,
                width: width / 4,
                child: Text(
                  widget.company_name,
                  style: TextStyle(
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
              ),
              Container(
                  //  margin: EdgeInsets.only(left: 10),
                  //  color: Colors.white,
                  //width: width/3,
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
                child: Text(companyname),
                // child: Text(
                //   Constants.skip == "1"
                //       ? "Select Location"
                //       : 'Delivering to ' + Constants.nameOfusers,
                //   style: TextStyle(
                //       fontFamily:
                //           Constants.language == "en" ? "Roboto" : "GSSFont",
                //       color: Colors.black,
                //       fontSize: 15),
                // ),
              )),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Route newRoute = MaterialPageRoute(
                    builder: (context) => HomeScreen("0", ""));
                Navigator.pushAndRemoveUntil(
                    context, newRoute, (route) => false);
              },
              icon: const Icon(CupertinoIcons.home),
              color: Colors.black,
            ),
          ],
        ),
        body: SafeArea(
          child: Directionality(
            textDirection: Constants.language == "en"
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: Stack(
              children: [
                CouponDetailsWidget(context, width, height),
                offerDetailsWidget(context, width, height),
                productPriceWidget(context, width, height),
                companyInfoWidget(context, width, height),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget offerDetailsWidget(BuildContext context, double width, double height) {
    return Visibility(
      visible: !_isLoading && !productPrice && !menu_List && !company_info,
      child: Column(
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
                  items: companyBannerList!
                      .map(
                        (e) => ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  // imageBaseUrl="http://cp.citycode.om/public/company/";

                                  print("imafeurl" + imageBaseUrl + e.banner);
                                  print("companyBannerListdata" +
                                      companyBannerList.toString());

                                  //   if (companyBannerList[index]..url!.isNotEmpty) {
                                  //     if (e.url!.contains("https://instagram.com/")) {
                                  //       launch(
                                  //         e.url!,
                                  //         universalLinksOnly: true,
                                  //       );
                                  //     } else {
                                  //       Route route = MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               WebViewScreen(
                                  //                   "", e.url!));
                                  //       Navigator.push(context, route);
                                  //     }
                                  // }
                                  // Route route = MaterialPageRoute(builder: (context) => WebViewScreen("", ""));
                                  // Navigator.push(context, route);
                                },
                                child: Image(
                                  image: NetworkImage(imageBaseUrl + e.banner),
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
                      companyBannerList!,
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

          Visibility(
            visible:
                widget.type == "online" || widget.type == "home" ? false : true,
            child: Container(
              color: const Color(0xFFF2CC0F),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Visibility(
                    visible: widget.type == "homebutton" && !couponclick
                        ? false
                        : true,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });
                        couponlist();
                        getHomeBanner("product").then((value) => {
                              if (value.bannerList != null &&
                                  value.bannerList!.isNotEmpty)
                                {
                                  bannerList!.clear(),
                                  for (int i = 0;
                                      i < value.bannerList!.length;
                                      i++)
                                    {
                                      setState(() {
                                        bannerList!.add(value.bannerList![i]);
                                      }),
                                    }
                                },
                              setState(() {
                                banner_base_url = value.imageBaseUrl ?? "";
                                _currentPosition = 0;
                              })
                            });

                        _getCompanyProducts().then((value) => {
                              if (value.productlist != null &&
                                  value.productlist!.isNotEmpty)
                                {
                                  for (int i = 0;
                                      i < value.productlist!.length;
                                      i++)
                                    {
                                      productlist!.add(value.productlist![i]),
                                    },
                                  if (productlist != null &&
                                      productlist!.isNotEmpty)
                                    {
                                      for (int i = 0;
                                          i < productlist!.length;
                                          i++)
                                        {
                                          for (int j = i + 1;
                                              j < productlist!.length;
                                              j++)
                                            {
                                              if (productlist![i].id ==
                                                  productlist![j].id)
                                                {
                                                  productlist!.removeAt(j),
                                                  j--,
                                                }
                                            }
                                        }
                                    }
                                },
                              setState(() {
                                product_image_base_url =
                                    value.productImageBaseUrl!;

                                print("copondata" + couponlistdata.toString());
                                if (couponlistdata.isNotEmpty) {
                                  _alertDialog(Constants.language == "en"
                                      ? "This company has coupons. So not show the products and its discounts."
                                      : "هذه الشركة لديها كوبونات. لذلك لا تظهر المنتجات وخصوماتها.");
                                } else {
                                  productPrice = true;
                                }

                                _isLoading = false;
                              }),
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Column(
                          children: [
                            Text(
                              Constants.language == "en"
                                  ? "Product / prices"
                                  : "المنتج / الأسعار",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                  fontSize: 16.0),
                            ),
                            Container(
                              width: 100.0,
                              margin: const EdgeInsets.only(top: 1.0),
                              height: 2.0,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" || couponclick
                        ? false
                        : true,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });
                        getHomeBanner("company").then((value) => {
                              if (value.bannerList != null &&
                                  value.bannerList!.isNotEmpty)
                                {
                                  bannerList!.clear(),
                                  for (int i = 0;
                                      i < value.bannerList!.length;
                                      i++)
                                    {
                                      setState(() {
                                        bannerList!.add(value.bannerList![i]);
                                      }),
                                    }
                                },
                              setState(() {
                                banner_base_url = value.imageBaseUrl ?? "";
                                _currentPosition = 0;
                                productPrice = false;
                                company_info = true;
                                _isLoading = false;
                              })
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Column(
                          children: [
                            Text(
                              Constants.language == "en"
                                  ? "Company Info"
                                  : "معلومات الشركة",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                  fontSize: 16.0),
                            ),
                            Container(
                              width: 100.0,
                              margin: const EdgeInsets.only(top: 1.0),
                              height: 2.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" || couponclick
                        ? false
                        : true,
                    child: InkWell(
                      onTap: () {
                        //couponlist();
                        setState(() {
                          _isLoading = true;
                        });
                        getHomeBanner("company").then((value) => {
                              if (value.bannerList != null &&
                                  value.bannerList!.isNotEmpty)
                                {
                                  bannerList!.clear(),
                                  for (int i = 0;
                                      i < value.bannerList!.length;
                                      i++)
                                    {
                                      setState(() {
                                        bannerList!.add(value.bannerList![i]);
                                      }),
                                    }
                                },
                              setState(() {
                                couponlist();
                                banner_base_url = value.imageBaseUrl ?? "";
                                _currentPosition = 0;
                                // productPrice = false;
                                couponlist();
                                print("qqq" + couponlistdata.toString());
                                if (couponlistdata.isNotEmpty) {
                                  coupontype = true;
                                } else {
                                  _alertDialog(Constants.language == "en"
                                      ? "No coupons Available"
                                      : "لا كوبونات متاحة");
                                }

                                _isLoading = false;
                              })
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Column(
                          children: [
                            Text(
                              Constants.language == "en"
                                  ? "Buy Coupon"
                                  : "شراء قسيمة",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                  fontSize: 15.0),
                            ),
                            Container(
                              width: 90.0,
                              margin: const EdgeInsets.only(top: 1.0),
                              height: 2.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type != "homebutton" && !couponclick
                        ? false
                        : true,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });
                        getHomeBanner("company").then((value) => {
                              if (value.bannerList != null &&
                                  value.bannerList!.isNotEmpty)
                                {
                                  bannerList!.clear(),
                                  for (int i = 0;
                                      i < value.bannerList!.length;
                                      i++)
                                    {
                                      setState(() {
                                        bannerList!.add(value.bannerList![i]);
                                      }),
                                    }
                                },
                              setState(() {
                                banner_base_url = value.imageBaseUrl ?? "";
                                _currentPosition = 0;
                                // productPrice = false;
                                coupontype = true;
                                _isLoading = false;
                              })
                            });
                      },
                      child: Container(
                        // padding: const EdgeInsets.only(left: 50.0, right: 100.0),
                        margin: Constants.language == "en"
                            ? const EdgeInsets.only(left: 110, right: 130)
                            : const EdgeInsets.only(left: 130, right: 110),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                Constants.language == "en"
                                    ? "Coupons Details"
                                    : "تفاصيل الكوبون",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontSize: 15.0),
                              ),
                            ),
                            Container(
                              width: 110.0,
                              margin: const EdgeInsets.only(top: 1.0),
                              height: 2.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Visibility(
            visible:
                widget.type == "online" || widget.type == "home" ? true : false,
            child: InkWell(
              onTap: () {
                getHomeBanner("company").then((value) => {
                      if (value.bannerList != null &&
                          value.bannerList!.isNotEmpty)
                        {
                          bannerList!.clear(),
                          for (int i = 0; i < value.bannerList!.length; i++)
                            {
                              setState(() {
                                bannerList!.add(value.bannerList![i]);
                              }),
                            }
                        },
                      setState(() {
                        banner_base_url = value.imageBaseUrl ?? "";
                        _currentPosition = 0;
                        productPrice = false;
                        company_info = true;
                        _isLoading = false;
                      })
                    });
              },
              child: Container(
                width: width,
                color: const Color(0xFFF2CC0F),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      Constants.language == "en"
                          ? "Company Info"
                          : "معلومات الشركة",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                          fontSize: 16.0),
                    ),
                    Container(
                      width: 130.0,
                      margin: const EdgeInsets.only(top: 1.0),
                      height: 2.0,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
          ),

          /// Coupon detail screen code>>>>
          Visibility(
            visible: widget.type != "homebutton" && !couponclick ? false : true,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 450,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Visibility(
                          visible: widget.type != "homebutton" && !couponclick
                              ? false
                              : true,
                          child: Container(
                            //  padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  width: 130,

                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF2CC0F),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  // width: width,
                                  /* margin: const EdgeInsets.only(
                                        left: 10.0, top: 10.0, right: 10.0),*/
                                  child: Center(
                                    child: Text(
                                      Constants.language == "en"
                                          ? "Coupon Name"
                                          : "أسم الكوبون",
                                      style: TextStyle(
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          fontWeight: FontWeight.bold),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: Constants.language == "en" ? 35 : 0,
                                      right:
                                          Constants.language == "ar" ? 40 : 0),
                                  width: 180,
                                  // width: 150,
                                  //padding: const EdgeInsets.all(10.0),
                                  /* margin: const EdgeInsets.only(
                                      top: 10.0, left: 10.0, right: 10.0,bottom:10.0),*/
                                  /* decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(10))),*/
                                  child: Text(
                                    widget.type == "homebutton"
                                        ? widget.coupoName
                                        : couponename.toString(),
                                    style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                        fontWeight: FontWeight.bold),
                                    textAlign: Constants.language == "en"
                                        ? TextAlign.left
                                        : TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        /*Visibility(
                          visible:
                          widget.type!="homebutton"&& !couponclick
                              ? false
                              : true,
                          child: Container(
                            width: width,
                            margin:
                            const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                            child: Text(
                                  Constants.language == "en"
                                  ? "Coupon Details"
                                  : "تفاصيل الخصم",
                              style: TextStyle(
                                  fontFamily:
                                  Constants.language == "en" ? "Roboto" : "GSSFont",
                                  fontWeight: FontWeight.bold),
                              textAlign: Constants.language == "en"
                                  ? TextAlign.left
                                  : TextAlign.right,
                            ),
                          ),
                        ),*/
                        Visibility(
                          visible: widget.type != "homebutton" && !couponclick
                              ? false
                              : true,
                          child: Container(
                            width: width,
                            height: 200,
                            padding: const EdgeInsets.only(bottom: 10.0),
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                Visibility(
                                  visible: widget.type != "homebutton" &&
                                          !couponclick
                                      ? false
                                      : true,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 45,
                                        width: 130,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFF2CC0F),
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                        child: Center(
                                          child: Text(
                                            Constants.language == "en"
                                                ? "Coupon Details"
                                                : "تفاصيل الكوبون",
                                            style: TextStyle(
                                                fontFamily:
                                                    Constants.language == "en"
                                                        ? "Roboto"
                                                        : "GSSFont",
                                                fontWeight: FontWeight.bold),
                                            textAlign:
                                                Constants.language == "en"
                                                    ? TextAlign.left
                                                    : TextAlign.right,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: SizedBox(
                                          width: 150,
                                          /* padding: const EdgeInsets.all(10.0),
                                          margin: const EdgeInsets.only(
                                              top: 10.0, left: 10.0, right: 10.0)*/
                                          child: Center(
                                            child: Text(
                                              widget.type == "homebutton"
                                                  ? widget.discount + " OMR"
                                                  : couponamount.toString() +
                                                      " OMR",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                                /* fontFamily: Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",*/
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: widget.type != "homebutton" &&
                                          !couponclick
                                      ? false
                                      : true,
                                  child: Container(
                                    //  margin: const EdgeInsets.only(top: 10.0),
                                    color: Colors.grey,
                                    height: 2.0,
                                    width: width,
                                  ),
                                ),
                                Visibility(
                                  visible: widget.type != "homebutton" &&
                                          !couponclick
                                      ? false
                                      : true,
                                  child: Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        width: width,
                                        margin: const EdgeInsets.only(
                                            top: 10.0, left: 5.0, right: 5.0),
                                        child: Text(
                                          widget.type == "homebutton"
                                              ? widget.offer_id
                                              : coupondetail.toString(),
                                          style: TextStyle(
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",
                                          ),
                                          textAlign: Constants.language == "en"
                                              ? TextAlign.left
                                              : TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.type != "homebutton" && !couponclick
                              ? false
                              : true,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  width: 130,

                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF2CC0F),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  // width: width,
                                  /* margin: const EdgeInsets.only(
                                      left: 10.0, top: 10.0, right: 10.0),*/
                                  child: Center(
                                    child: Text(
                                      Constants.language == "en"
                                          ? "Coupon Price"
                                          : "سعر الكوبون",
                                      style: TextStyle(
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          fontWeight: FontWeight.bold),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  /* padding: const EdgeInsets.all(10.0),
                                  margin: const EdgeInsets.only(
                                      top: 10.0, left: 10.0, right: 10.0),*/
                                  /* decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(10))),*/
                                  child: Center(
                                    child: Text(
                                      widget.type == "homebutton"
                                          ? widget.couponprice + " OMR"
                                          : couponeprice.toString() + " OMR",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.type != "homebutton" && !couponclick
                              ? false
                              : true,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  width: 130,

                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF2CC0F),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  // width: width,
                                  /* margin: const EdgeInsets.only(
                                        left: 10.0, top: 10.0, right: 10.0),*/
                                  child: Center(
                                    child: Text(
                                      Constants.language == "en"
                                          ? "VAT"
                                          : "VAT",
                                      style: TextStyle(
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "Roboto",
                                          fontWeight: FontWeight.bold),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Center(
                                    child: Text(
                                      widget.type == "homebutton"
                                          ? VAT.toStringAsFixed(3) + " OMR"
                                          : VAT.toStringAsFixed(3) + " OMR",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.type != "homebutton" && !couponclick
                              ? false
                              : true,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 10.0,
                                left: 10.0,
                                right: 10.0,
                                bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Constants.language == "en"
                                      ? "Expiration Date"
                                      : "تاريخ إنتهاء الصلاحية",
                                  style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontWeight: FontWeight.bold),
                                  textAlign: Constants.language == "en"
                                      ? TextAlign.left
                                      : TextAlign.right,
                                ),
                                Text(
                                  widget.type == "homebutton"
                                      ? widget.isFavourite
                                      : enddate.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: Constants.language == "en"
                                      ? TextAlign.left
                                      : TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.coupondata.isNotEmpty ||
                                  widget.type != "homebutton" && !couponclick
                              ? false
                              : true,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 1),
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  couponlistavailable();
                                });

                                //  _showdialog(context,width);
                                //_showDialog(context,width);
                                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen("0")));
                                // var userid=widget.couponid;
                                // couponperchased(userid);
                                // alertShow(context,"success");
                              },
                              child: Text(
                                Constants.language == "en"
                                    ? "Pay Now"
                                    : "أشتري الكوبون",
                                style: TextStyle(
                                    color: const Color(0xFF111111),
                                    fontSize: 16.0,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                                textAlign: Constants.language == "en"
                                    ? TextAlign.left
                                    : TextAlign.right,
                              ),
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(500, 40.0),
                                backgroundColor: const Color(0xFFF2CC0F),
                                shadowColor: const Color(0xFFF2CC0F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          ///here i am adding coupontype in all widget insid the visibility if......(icons,branch,chaticon,discount,discrption,date)
          Visibility(
            visible: widget.type != "homebutton" && !couponclick && !coupontype
                ? true
                : false,
            child: Container(
              margin: const EdgeInsets.only(top: 10.0),
              width: width,
              height: height * 0.05,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Row(
                      children: [
                        Visibility(
                          visible: widget.type == "homebutton" &&
                                      widget.type == "online" ||
                                  widget.type == "home" ||
                                  coupontype
                              ? false
                              : true,
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 5.0, right: 5.0, top: 5),
                            //  margin: const EdgeInsets.only(top: 5.0),
                            child: LikeButton(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              padding: EdgeInsets.zero,
                              onTap: (bool) {
                                return _addOrRemoveFavOffer(bool);
                              },
                              isLiked: widget.isFavourite == "1" ? true : false,
                              circleColor: const CircleColor(
                                start: Color(0xff00ddff),
                                end: Color(0xff0099cc),
                              ),
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: Color(0xff33b5e5),
                                dotSecondaryColor: Color(0xff0099cc),
                              ),
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  isLiked
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  color: isLiked ? Colors.red : Colors.black,
                                  size: 35,
                                );
                              },
                            ),
                          ),
                        ),
                        /* IconButton(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          constraints: const BoxConstraints(),
                          iconSize: 30.0,
                          icon:Image.asset("images/locationcity.png",color: Colors.black,),
                          // icon: const Icon(CupertinoIcons.location),
                          //icon: const Icon(CupertinoIcons.location_solid,color: Color(0xFFF2CC0F),),
                          color: Colors.black,
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));

                          },
                        ),*/
                        Visibility(
                          visible: widget.type == "homebutton" || coupontype
                              ? false
                              : true,
                          child: IconButton(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            constraints: const BoxConstraints(),
                            iconSize: 30.0,
                            icon: Image.asset(
                              "images/locationcity.png",
                              color: Colors.black,
                            ),
                            // icon: const Icon(CupertinoIcons.location),
                            //icon: const Icon(CupertinoIcons.location_solid,color: Color(0xFFF2CC0F),),
                            color: Colors.black,
                            onPressed: () async {
                              print("rohank");
                              if (location.isNotEmpty) {
                                if (widget.type == "online") {
                                  String query = Uri.encodeComponent(location);
                                  print("rohank" + query);
                                  String googleUrl =
                                      "https://www.google.com/maps/search/?api=1&query=$query";

                                  if (await canLaunch(googleUrl)) {
                                    await launch(googleUrl);
                                  }
                                } else {
                                  launch(location);
                                }
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible: widget.type == "homebutton" || coupontype
                              ? false
                              : true,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            iconSize: 30.0,
                            icon: const Icon(Icons.share),
                            color: Colors.black,
                            onPressed: () {
                              Share.share(
                                  "Download the CityCode Application from the below link :- https://heylink.me/citycode");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" || coupontype
                        ? false
                        : true,
                    child: Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                      color: Colors.black,
                      width: 1.0,
                      height: 50.0,
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" ||
                            widget.type == "online" ||
                            widget.type == "home" ||
                            coupontype
                        ? false
                        : true,
                    child: Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: companyBranchList!.length,
                        itemBuilder: (context, index) {
                          _getLocation();
                          if (companyBranchList![index].latitude.isNotEmpty) {
                            ///comenting code for published                            //  lat1=double.parse(companyBranchList![index].latitude!);
                            //  long1=double.parse(companyBranchList![index].longitude!);
                            // kmete = getDistanceFromLatLonInKm(latitude,longitude, lat1,long1);
                            //  print("kilometerhai"+km.toString());
                            kmeter = getDistanceFromLatLonInKm(
                                latitude, longitude, latbuynow, longbuynow);
                            print("kilometer bhairrrr" + kmeter.toString());
                            // companyBranchList![index].distance =km;

                            //CompanyDetailsModel!.add()
                            // var a=dis![index];

                            ///comenting code for published
                            print("rohaneee" +
                                companyBranchList![0].distance.toString());
                            companyBranchList!.sort((a, b) {
                              print("rohaneee" +
                                  companyBranchList![0].branchName.toString());
                              print("raunak1s" + km.toString());
                              print("raunak2s" + kmete.toString());

                              return kmeter.compareTo(kmeter);
                              //return 8212.783477205552.compareTo(8209.807612378003);
                            });
                          }

                          print("latitudee" + lat1.toString());
                          //

                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedBranchName =
                                    companyBranchList![index].branchName;
                                tempindex = index;
                                print("tempindex : " + tempindex.toString());
                                for (int i = 0;
                                    i < selectedBranch.length;
                                    i++) {
                                  if (selectedBranch[i] == "1") {
                                    selectedBranch[i] = "0";
                                  }
                                }

                                ///comenting code for published
                                latbuynow = double.parse(
                                    companyBranchList![index].latitude);
                                longbuynow = double.parse(
                                    companyBranchList![index].longitude);
                                print("curruntlat" + latitude.toString());
                                print("currentlong" + longitude.toString());
                                kmeter = getDistanceFromLatLonInKm(
                                    latitude, longitude, latbuynow, longbuynow);
                                print("latitude" + latbuynow.toString());
                                print("longitude" + longbuynow.toString());
                                print("datatdomn" + kmeter.toString());
                                selectedBranch[index] = "1";
                                location = companyBranchList![index].location;
                                description = Constants.language == "en"
                                    ? companyBranchList![index]
                                        .branchOffers[0]
                                        .description
                                    : companyBranchList![index]
                                        .branchOffers[0]
                                        .arbDescription;
                                branch_id = companyBranchList![index].branchId;
                                widget.discount = companyBranchList![index]
                                    .branchOffers[0]
                                    .discountdisplay;
                                companyid = companyBranchList![index].companyId;
                                print("branch l" + branch_id.toString());
                                print("branch location" + location.toString());
                                print(location);
                                fastdel = companyBranchList![index]
                                    .fastDeliveryCharges
                                    .toString();
                                specialdel = companyBranchList![index]
                                    .specialDeliveryCharges
                                    .toString();
                                print("fast" + fastdel.toString());
                                print("company" + companyid.toString());
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 2.5, right: 2.5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  //  color: Colors.teal,
                                  color: const Color(0xFFF2CC0F),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: selectedBranch[index] == "1"
                                    ? const Color(0xFFE6D997)
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  Constants.language == "en"
                                      ? companyBranchList![index].branchName
                                      : companyBranchList![index]
                                              .arbBranchName
                                              .isNotEmpty
                                          ? companyBranchList![index]
                                              .arbBranchName
                                          : companyBranchList![index]
                                              .branchName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            child: Visibility(
              visible: widget.coupondata == "1" && !couponclick, //coupontype ||
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  //controller: _tabController,
                  children: [
                    // first tab bar view widget
                    GestureDetector(
                        onTap: () {
                          //coupontype=!coupontype;
                          couponlist();
                          print("rohanbhai");
                          setState(() {
                            _isLoading = false;
                          });
                          // couponlistavailable(widget.company_id,branch_id);
                          couponclick = !couponclick;
                          print(couponlistdata.length.toString() + "fisrt");
                        },
                        child: Horizontalline(
                          companyid: widget.company_id,
                          branchid: branch_id,
                        )),

                    // second tab bar view widget
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.coupondata == "1" ||
                    widget.type == "homebutton" ||
                    widget.type == "online" ||
                    widget.type == "home" ||
                    coupontype
                ? false
                : true,
            child: Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          widget.company_name,
                          company_image,
                          Constants.user_id,
                          branch_id,
                          "",
                          "",
                          "user",
                          "",
                          "0",
                          "0"));
                  Navigator.push(context, route);
                  print("branchId:::::" + branch_id);
                },
                child: const Image(
                  image: AssetImage("images/chat_icon.png"),
                  width: 30.0,
                  height: 30.0,
                ),
              ),
            ),
          ),

          Visibility(
            visible: widget.coupondata == "1" ? false : true,
            child: Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Visibility(
                    visible: widget.type == "homebutton" ||
                            widget.type == "online" ||
                            widget.type == "home" ||
                            coupontype
                        ? false
                        : true,
                    child: Container(
                      width: width,
                      margin: const EdgeInsets.only(
                          left: 10.0, top: 10.0, right: 10.0),
                      child: Text(
                        Constants.language == "en" ? "Discounts" : "الخصم",
                        style: TextStyle(
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont",
                            fontWeight: FontWeight.bold),
                        textAlign: Constants.language == "en"
                            ? TextAlign.left
                            : TextAlign.right,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" ||
                            widget.type == "online" ||
                            widget.type == "home" ||
                            coupontype
                        ? false
                        : true,
                    child: Container(
                      width: width,
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        widget.discount,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" || coupontype
                        ? false
                        : true,
                    child: Container(
                      width: width,
                      margin: const EdgeInsets.only(
                          left: 10.0, top: 10.0, right: 10.0),
                      child: Text(
                        widget.type == "home"
                            ? Constants.language == "en"
                                ? "Business Details"
                                : "تفاصيل المشروع"
                            : Constants.language == "en"
                                ? "Discount Details"
                                : "تفاصيل الخصم",
                        style: TextStyle(
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont",
                            fontWeight: FontWeight.bold),
                        textAlign: Constants.language == "en"
                            ? TextAlign.left
                            : TextAlign.right,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" || coupontype
                        ? false
                        : true,
                    child: Container(
                      width: width,
                      height: 220,
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Visibility(
                            visible: widget.type == "homebutton" ||
                                    widget.type == "online" ||
                                    widget.type == "home" ||
                                    coupontype
                                ? false
                                : true,
                            child: Text(
                              companyBranchList!.isNotEmpty
                                  ? Constants.language == "en"
                                      ? companyBranchList![tempindex]
                                          .branchOffers[0]
                                          .discountEnDetail
                                      : companyBranchList![tempindex]
                                          .branchOffers[0]
                                          .discountArbDetail
                                  : "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.type == "homebutton" ||
                                    widget.type == "online" ||
                                    widget.type == "home" ||
                                    coupontype
                                ? false
                                : true,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              color: Colors.grey,
                              height: 2.0,
                              width: width,
                            ),
                          ),
                          Visibility(
                            visible: widget.type == "homebutton" || coupontype
                                ? false
                                : true,
                            child: Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                  width: width,
                                  margin: const EdgeInsets.only(
                                      top: 10.0, left: 5.0, right: 5.0),
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                    textAlign: Constants.language == "en"
                                        ? TextAlign.left
                                        : TextAlign.right,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" ||
                            widget.type == "home" ||
                            coupontype
                        ? false
                        : true,
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Constants.language == "en"
                                ? "Offer Expiration Date"
                                : "تاريخ انتهاء العرض",
                            style: TextStyle(
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                                fontWeight: FontWeight.bold),
                            textAlign: Constants.language == "en"
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                          Text(
                            companyBranchList!.isNotEmpty
                                ? companyBranchList![0].branchOffers[0].endDate
                                : "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: Constants.language == "en"
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "online" ? true : false,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              if (website.isNotEmpty) {
                                if (website.startsWith("http") ||
                                    website.startsWith("https")) {
                                  launch(website);
                                } else {
                                  launch("http://" + website);
                                }
                              }
                            },
                            child: const Image(
                              image: AssetImage("images/website.jpeg"),
                              width: 25.0,
                              height: 25.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (app_store.isNotEmpty) {
                                if (app_store.startsWith("http") ||
                                    app_store.startsWith("https")) {
                                  launch(app_store);
                                } else {
                                  launch("http://" + app_store);
                                }
                              }
                            },
                            child: const Image(
                              image: AssetImage("images/apple_store.jpeg"),
                              width: 25.0,
                              height: 25.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (play_store.isNotEmpty) {
                                if (play_store.startsWith("http") ||
                                    play_store.startsWith("https")) {
                                  launch(play_store);
                                } else {
                                  launch("http://" + play_store);
                                }
                              }
                            },
                            child: const Image(
                              image:
                                  AssetImage("images/google_play_store.jpeg"),
                              width: 25.0,
                              height: 25.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (huawei_store.isNotEmpty) {
                                if (huawei_store.startsWith("http") ||
                                    huawei_store.startsWith("https")) {
                                  launch(huawei_store);
                                } else {
                                  launch("http://" + huawei_store);
                                }
                              }
                            },
                            child: const Image(
                              image: AssetImage("images/huawei_store.jpeg"),
                              width: 25.0,
                              height: 25.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "online" || widget.type == "home"
                        ? true
                        : false,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: phone.isNotEmpty ? 1 : 0,
                            child: Visibility(
                              visible: phone.isNotEmpty ? true : false,
                              child: InkWell(
                                onTap: () {
                                  if (phone.isNotEmpty) {
                                    launch("tel://$phone");
                                  }
                                },
                                child: const Image(
                                  image: AssetImage("images/phone.png"),
                                  width: 25.0,
                                  height: 25.0,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: whatsapp.isNotEmpty ? 1 : 0,
                            child: Visibility(
                              visible: whatsapp.isNotEmpty ? true : false,
                              child: InkWell(
                                onTap: () {
                                  if (whatsapp.isNotEmpty) {
                                    launch("https://wa.me/$whatsapp");
                                  }
                                },
                                child: const Image(
                                  image: AssetImage("images/whatsapp.png"),
                                  width: 25.0,
                                  height: 25.0,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: email.isNotEmpty ? 1 : 0,
                            child: Visibility(
                              visible: email.isNotEmpty ? true : false,
                              child: InkWell(
                                onTap: () {
                                  if (email.isNotEmpty) {
                                    launch("mailto:" + email);
                                  }
                                },
                                child: const Image(
                                  image: AssetImage("images/mail.png"),
                                  width: 25.0,
                                  height: 25.0,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: instagram.isNotEmpty ? 1 : 0,
                            child: Visibility(
                              visible: instagram.isNotEmpty ? true : false,
                              child: InkWell(
                                onTap: () {
                                  if (instagram.isNotEmpty) {
                                    launch(instagram);
                                  }
                                },
                                child: const Image(
                                  image: AssetImage("images/insta.png"),
                                  width: 25.0,
                                  height: 25.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///here my code
  Widget CouponDetailsWidget(
      BuildContext context, double width, double height) {
    return Visibility(
      visible: _isLoading && !productPrice && !menu_List,
      child: Column(
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
                  items: companyBannerList!
                      .map(
                        (e) => ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  // imageBaseUrl="http://cp.citycode.om/public/company/";

                                  print("imafeurl" + imageBaseUrl + e.banner);
                                  print("companyBannerListsss" +
                                      companyBannerList.toString());
                                },
                                child: Image(
                                  image: NetworkImage(imageBaseUrl + e.banner),
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
                      companyBannerList!,
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

          Visibility(
            visible:
                widget.type == "online" || widget.type == "home" ? false : true,
            child: Container(
              color: const Color(0xFFF2CC0F),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Visibility(
                    visible: widget.type == "homebutton" ||
                            couponlistdata != null ||
                            couponclick
                        ? false
                        : true,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });
                        couponlist();
                        getHomeBanner("product").then((value) => {
                              if (value.bannerList != null &&
                                  value.bannerList!.isNotEmpty)
                                {
                                  bannerList!.clear(),
                                  for (int i = 0;
                                      i < value.bannerList!.length;
                                      i++)
                                    {
                                      setState(() {
                                        bannerList!.add(value.bannerList![i]);
                                      }),
                                    }
                                },
                              setState(() {
                                banner_base_url = value.imageBaseUrl ?? "";
                                _currentPosition = 0;
                              })
                            });

                        _getCompanyProducts().then((value) => {
                              if (value.productlist != null &&
                                  value.productlist!.isNotEmpty)
                                {
                                  for (int i = 0;
                                      i < value.productlist!.length;
                                      i++)
                                    {
                                      productlist!.add(value.productlist![i]),
                                    },
                                  if (productlist != null &&
                                      productlist!.isNotEmpty)
                                    {
                                      for (int i = 0;
                                          i < productlist!.length;
                                          i++)
                                        {
                                          for (int j = i + 1;
                                              j < productlist!.length;
                                              j++)
                                            {
                                              if (productlist![i].id ==
                                                  productlist![j].id)
                                                {
                                                  productlist!.removeAt(j),
                                                  j--,
                                                }
                                            }
                                        }
                                    }
                                },
                              setState(() {
                                product_image_base_url =
                                    value.productImageBaseUrl!;

                                print("copondata" + couponlistdata.toString());
                                if (couponlistdata.isNotEmpty) {
                                  _alertDialog(Constants.language == "en"
                                      ? "This company has coupons. So not show the products and its discounts."
                                      : "هذه الشركة لديها كوبونات. لذلك لا تظهر المنتجات وخصوماتها.");
                                } else {
                                  productPrice = true;
                                }

                                _isLoading = false;
                              }),
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Column(
                          children: [
                            Text(
                              Constants.language == "en"
                                  ? "Product / prices"
                                  : "المنتج / الأسعار",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                  fontSize: 16.0),
                            ),
                            Container(
                              width: 100.0,
                              margin: const EdgeInsets.only(top: 1.0),
                              height: 2.0,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    //  visible:widget.type=="homebutton"||couponclick?false:true,
                    visible: !couponclick ? false : true,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });
                        getHomeBanner("company").then((value) => {
                              if (value.bannerList != null &&
                                  value.bannerList!.isNotEmpty)
                                {
                                  bannerList!.clear(),
                                  for (int i = 0;
                                      i < value.bannerList!.length;
                                      i++)
                                    {
                                      setState(() {
                                        bannerList!.add(value.bannerList![i]);
                                      }),
                                    }
                                },
                              setState(() {
                                banner_base_url = value.imageBaseUrl ?? "";
                                _currentPosition = 0;
                                productPrice = false;
                                company_info = true;
                                _isLoading = false;
                              })
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Column(
                          children: [
                            Text(
                              Constants.language == "en"
                                  ? "Company Info"
                                  : "معلومات الشركة",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                  fontSize: 16.0),
                            ),
                            Container(
                              width: 100.0,
                              margin: const EdgeInsets.only(top: 1.0),
                              height: 2.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  ///
                  Visibility(
                    //visible: _isLoading?!_isLoading:_isLoading,
                    visible: _isLoading ? true : false,
                    child: Center(
                      child: Container(
                        height: 20,
                        width: 20,
                        color: const Color(0xFFF2CC0F),
                        // padding: const EdgeInsets.all(10.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    // visible:widget.type=="homebutton"||couponclick?false:true,
                    visible: !couponclick ? false : true,
                    child: InkWell(
                      onTap: () {
                        //couponlist();
                        setState(() {
                          _isLoading = true;
                        });
                        getHomeBanner("company").then((value) => {
                              if (value.bannerList != null &&
                                  value.bannerList!.isNotEmpty)
                                {
                                  bannerList!.clear(),
                                  for (int i = 0;
                                      i < value.bannerList!.length;
                                      i++)
                                    {
                                      setState(() {
                                        bannerList!.add(value.bannerList![i]);
                                      }),
                                    }
                                },
                              setState(() {
                                couponlist();
                                banner_base_url = value.imageBaseUrl ?? "";
                                _currentPosition = 0;
                                // productPrice = false;
                                couponlist();
                                print("qqq" + couponlistdata.toString());
                                if (couponlistdata.isEmpty) {
                                } else {
                                  coupontype = true;
                                }

                                _isLoading = false;
                              })
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Column(
                          children: [
                            Text(
                              Constants.language == "en"
                                  ? "Buy Coupon"
                                  : "شراء قسيمة",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                  fontSize: 15.0),
                            ),
                            Container(
                              width: 90.0,
                              margin: const EdgeInsets.only(top: 1.0),
                              height: 2.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !couponclick ? false : true,
                    // visible:widget.type!="homebutton" &&!couponclick?false:true,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });
                        getHomeBanner("company").then((value) => {
                              if (value.bannerList != null &&
                                  value.bannerList!.isNotEmpty)
                                {
                                  bannerList!.clear(),
                                  for (int i = 0;
                                      i < value.bannerList!.length;
                                      i++)
                                    {
                                      setState(() {
                                        bannerList!.add(value.bannerList![i]);
                                      }),
                                    }
                                },
                              setState(() {
                                banner_base_url = value.imageBaseUrl ?? "";
                                _currentPosition = 0;
                                // productPrice = false;
                                coupontype = true;
                                _isLoading = false;
                              })
                            });
                      },
                      child: Container(
                        // padding: const EdgeInsets.only(left: 50.0, right: 100.0),
                        margin: Constants.language == "en"
                            ? const EdgeInsets.only(left: 110, right: 130)
                            : const EdgeInsets.only(left: 130, right: 110),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                Constants.language == "en"
                                    ? "Coupons Details"
                                    : "تفاصيل الكوبون",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontSize: 15.0),
                              ),
                            ),
                            Container(
                              width: 110.0,
                              margin: const EdgeInsets.only(top: 1.0),
                              height: 2.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Visibility(
            visible:
                widget.type == "online" || widget.type == "home" ? true : false,
            child: InkWell(
              onTap: () {
                getHomeBanner("company").then((value) => {
                      if (value.bannerList != null &&
                          value.bannerList!.isNotEmpty)
                        {
                          bannerList!.clear(),
                          for (int i = 0; i < value.bannerList!.length; i++)
                            {
                              setState(() {
                                bannerList!.add(value.bannerList![i]);
                              }),
                            }
                        },
                      setState(() {
                        banner_base_url = value.imageBaseUrl ?? "";
                        _currentPosition = 0;
                        productPrice = false;
                        company_info = true;
                        _isLoading = false;
                      })
                    });
              },
              child: Container(
                width: width,
                color: const Color(0xFFF2CC0F),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      Constants.language == "en"
                          ? "Company Info"
                          : "معلومات الشركة",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                          fontSize: 16.0),
                    ),
                    Container(
                      width: 130.0,
                      margin: const EdgeInsets.only(top: 1.0),
                      height: 2.0,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
          ),

          /// Coupon detail screen code>>>>
          Visibility(
            visible: widget.type != "homebutton" && !couponclick ? false : true,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 450,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Visibility(
                          visible: widget.type != "homebutton" && !couponclick
                              ? false
                              : true,
                          child: Container(
                            //  padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF2CC0F),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                    child: Text(
                                      Constants.language == "en"
                                          ? "Coupon Name"
                                          : "أسم الكوبون",
                                      style: TextStyle(
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          fontWeight: FontWeight.bold),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: Constants.language == "en" ? 35 : 0,
                                      right:
                                          Constants.language == "ar" ? 40 : 0),
                                  width: 180,
                                  child: Text(
                                    widget.type == "homebutton"
                                        ? widget.coupoName
                                        : couponename.toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        // fontFamily:
                                        //   Constants.language == "en" ? "Roboto" : "GSSFont",
                                        fontWeight: FontWeight.bold),
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
                          visible: widget.type != "homebutton" && !couponclick
                              ? false
                              : true,
                          child: Container(
                            width: width,
                            height: 200,
                            padding: const EdgeInsets.only(bottom: 10.0),
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                Visibility(
                                  visible: widget.type != "homebutton" &&
                                          !couponclick
                                      ? false
                                      : true,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 45,
                                        width: 130,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFF2CC0F),
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                        child: Center(
                                          child: Text(
                                            Constants.language == "en"
                                                ? "Coupon Details"
                                                : "تفاصيل الكوبون",
                                            style: TextStyle(
                                                fontFamily:
                                                    Constants.language == "en"
                                                        ? "Roboto"
                                                        : "GSSFont",
                                                fontWeight: FontWeight.bold),
                                            textAlign:
                                                Constants.language == "en"
                                                    ? TextAlign.left
                                                    : TextAlign.right,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: SizedBox(
                                          width: 150,
                                          child: Center(
                                            child: Text(
                                              widget.type == "homebutton"
                                                  ? widget.discount + " OMR"
                                                  : couponamount.toString() +
                                                      " OMR",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: widget.type != "homebutton" &&
                                          !couponclick
                                      ? false
                                      : true,
                                  child: Container(
                                    //  margin: const EdgeInsets.only(top: 10.0),
                                    color: Colors.grey,
                                    height: 2.0,
                                    width: width,
                                  ),
                                ),
                                Visibility(
                                  visible: widget.type != "homebutton" &&
                                          !couponclick
                                      ? false
                                      : true,
                                  child: Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        width: width,
                                        margin: const EdgeInsets.only(
                                            top: 10.0, left: 5.0, right: 5.0),
                                        child: Text(
                                          widget.type == "homebutton"
                                              ? widget.offer_id
                                              : coupondetail.toString(),
                                          style: TextStyle(
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",
                                          ),
                                          textAlign: Constants.language == "en"
                                              ? TextAlign.left
                                              : TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.type != "homebutton" && !couponclick
                              ? false
                              : true,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  width: 130,

                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF2CC0F),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  // width: width,
                                  /* margin: const EdgeInsets.only(
                                      left: 10.0, top: 10.0, right: 10.0),*/
                                  child: Center(
                                    child: Text(
                                      Constants.language == "en"
                                          ? "Coupon Price"
                                          : "سعر الكوبون",
                                      style: TextStyle(
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                          fontWeight: FontWeight.bold),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Center(
                                    child: Text(
                                      widget.type == "homebutton"
                                          ? widget.couponprice + " OMR"
                                          : couponeprice.toString() + " OMR",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.type != "homebutton" && !couponclick
                              ? false
                              : true,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  width: 130,

                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF2CC0F),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  // width: width,
                                  /* margin: const EdgeInsets.only(
                                      left: 10.0, top: 10.0, right: 10.0),*/
                                  child: Center(
                                    child: Text(
                                      Constants.language == "en"
                                          ? "VAT"
                                          : "VAT",
                                      style: TextStyle(
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "Roboto",
                                          fontWeight: FontWeight.bold),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Center(
                                    child: Text(
                                      widget.type == "homebutton"
                                          ? VAT.toStringAsFixed(3) + " OMR"
                                          : VAT.toStringAsFixed(3) + " OMR",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.type != "homebutton" && !couponclick
                              ? false
                              : true,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 10.0,
                                left: 10.0,
                                right: 10.0,
                                bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Constants.language == "en"
                                      ? "Expiration Date"
                                      : "تاريخ إنتهاء الصلاحية",
                                  style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                      fontWeight: FontWeight.bold),
                                  textAlign: Constants.language == "en"
                                      ? TextAlign.left
                                      : TextAlign.right,
                                ),
                                Text(
                                  widget.type == "homebutton"
                                      ? widget.isFavourite
                                      : enddate.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: Constants.language == "en"
                                      ? TextAlign.left
                                      : TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.coupondata.isNotEmpty ||
                                  widget.type != "homebutton" && !couponclick
                              ? false
                              : true,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 1),
                            child: ElevatedButton(
                              onPressed: () async {
                                couponlistavailable();

                                //  _showdialog(context,width);
                                //_showDialog(context,width);
                                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen("0")));

                                // alertShow(context,"success");
                              },
                              child: Text(
                                Constants.language == "en"
                                    ? "Pay Now"
                                    : "أشتري الكوبون",
                                style: TextStyle(
                                    color: const Color(0xFF111111),
                                    fontSize: 16.0,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                                textAlign: Constants.language == "en"
                                    ? TextAlign.left
                                    : TextAlign.right,
                              ),
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(500, 40.0),
                                primary: const Color(0xFFF2CC0F),
                                shadowColor: const Color(0xFFF2CC0F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          ///here i am adding coupontype in all widget insid the visibility if......(icons,branch,chaticon,discount,discrption,date)
          Visibility(
            visible: widget.type != "homebutton" && !couponclick && !coupontype
                ? true
                : false,
            child: Container(
              margin: const EdgeInsets.only(top: 10.0),
              width: width,
              height: height * 0.05,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Row(
                      children: [
                        Visibility(
                          visible: widget.type == "homebutton" &&
                                      widget.type == "online" ||
                                  widget.type == "home" ||
                                  coupontype
                              ? false
                              : true,
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 5.0, right: 5.0, top: 5),
                            // margin: const EdgeInsets.only(top: 5.0),
                            child: LikeButton(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              padding: EdgeInsets.zero,
                              onTap: (bool) {
                                return _addOrRemoveFavOffer(bool);
                              },
                              isLiked: widget.isFavourite == "1" ? true : false,
                              circleColor: const CircleColor(
                                start: Color(0xff00ddff),
                                end: Color(0xff0099cc),
                              ),
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: Color(0xff33b5e5),
                                dotSecondaryColor: Color(0xff0099cc),
                              ),
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  isLiked
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  color: isLiked ? Colors.red : Colors.black,
                                  size: 35,
                                );
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.type == "homebutton" || coupontype
                              ? false
                              : true,
                          child: IconButton(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            constraints: const BoxConstraints(),
                            iconSize: 30.0,
                            icon: Image.asset(
                              "images/locationcity.png",
                              color: Colors.black,
                            ),
                            // icon: const Icon(CupertinoIcons.location_solid,color: Color(0xFFF2CC0F),),
                            color: Colors.black,
                            onPressed: () async {
                              if (location.isNotEmpty) {
                                if (widget.type == "online") {
                                  String query = Uri.encodeComponent(location);
                                  print("rohank" + query);
                                  String googleUrl =
                                      "https://www.google.com/maps/search/?api=1&query=$query";

                                  if (await canLaunch(googleUrl)) {
                                    await launch(googleUrl);
                                  }
                                } else {
                                  launch(location);
                                }
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible: widget.type == "homebutton" || coupontype
                              ? false
                              : true,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            iconSize: 30.0,
                            icon: const Icon(Icons.share),
                            color: Colors.black,
                            onPressed: () {
                              Share.share(
                                  "Download the CityCode Application from the below link :- https://heylink.me/citycode");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" || coupontype
                        ? false
                        : true,
                    child: Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                      color: Colors.black,
                      width: 1.0,
                      height: 50.0,
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" ||
                            widget.type == "online" ||
                            widget.type == "home" ||
                            coupontype
                        ? false
                        : true,
                    child: Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: companyBranchList!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                tempindex = index;
                                print("tempindex : " + tempindex.toString());
                                for (int i = 0;
                                    i < selectedBranch.length;
                                    i++) {
                                  if (selectedBranch[i] == "1") {
                                    selectedBranch[i] = "0";
                                  }
                                }
                                selectedBranch[index] = "1";
                                location = companyBranchList![index].location;
                                var fastdel = companyBranchList![index]
                                    .fastDeliveryCharges;
                                description = Constants.language == "en"
                                    ? companyBranchList![index]
                                        .branchOffers[0]
                                        .description
                                    : companyBranchList![index]
                                        .branchOffers[0]
                                        .arbDescription;
                                branch_id = companyBranchList![index].branchId;
                                widget.discount = companyBranchList![index]
                                    .branchOffers[0]
                                    .discountdisplay;
                                companyid = companyBranchList![index].companyId;
                                print("branch l" + branch_id.toString());
                                print("branch location" + location.toString());
                                print("company" + companyid.toString());
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 2.5, right: 2.5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFF2CC0F),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: selectedBranch[index] == "1"
                                    ? const Color(0xFFE6D997)
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  Constants.language == "en"
                                      ? companyBranchList![index].branchName
                                      : companyBranchList![index]
                                              .arbBranchName
                                              .isNotEmpty
                                          ? companyBranchList![index]
                                              .arbBranchName
                                          : companyBranchList![index]
                                              .branchName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            child: Visibility(
              visible: widget.coupondata == "1" && !couponclick, //coupontype ||
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  //controller: _tabController,
                  children: [
                    // first tab bar view widget
                    GestureDetector(
                        onTap: () {
                          //coupontype=!coupontype;
                          couponlist();
                          print("rohandata");
                          setState(() {
                            _isLoading = false;
                          });
                          couponclick = !couponclick;
                          print(couponlistdata.length.toString() + "second");
                        },
                        child: Horizontalline(
                          companyid: widget.company_id,
                          branchid: branch_id,
                        )),

                    // second tab bar view widget
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.coupondata == "1" ||
                    widget.type == "homebutton" ||
                    widget.type == "online" ||
                    widget.type == "home" ||
                    coupontype
                ? false
                : true,
            child: Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          widget.company_name,
                          company_image,
                          Constants.user_id,
                          branch_id,
                          "",
                          "",
                          "user",
                          "",
                          "0",
                          "0"));
                  Navigator.push(context, route);
                  print("branchId:::::" + branch_id);
                },
                child: const Image(
                  image: AssetImage("images/chat_icon.png"),
                  width: 30.0,
                  height: 30.0,
                ),
              ),
            ),
          ),

          Visibility(
            visible: widget.coupondata == "1" ? false : true,
            child: Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Visibility(
                    visible: widget.type == "homebutton" ||
                            widget.type == "online" ||
                            widget.type == "home" ||
                            coupontype
                        ? false
                        : true,
                    child: Container(
                      width: width,
                      margin: const EdgeInsets.only(
                          left: 10.0, top: 10.0, right: 10.0),
                      child: Text(
                        Constants.language == "en" ? "Discounts" : "الخصم",
                        style: TextStyle(
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont",
                            fontWeight: FontWeight.bold),
                        textAlign: Constants.language == "en"
                            ? TextAlign.left
                            : TextAlign.right,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" ||
                            widget.type == "online" ||
                            widget.type == "home" ||
                            coupontype
                        ? false
                        : true,
                    child: Container(
                      width: width,
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        widget.discount,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" || coupontype
                        ? false
                        : true,
                    child: Container(
                      width: width,
                      margin: const EdgeInsets.only(
                          left: 10.0, top: 10.0, right: 10.0),
                      child: Text(
                        widget.type == "home"
                            ? Constants.language == "en"
                                ? "Business Details"
                                : "تفاصيل المشروع"
                            : Constants.language == "en"
                                ? "Discount Details"
                                : "تفاصيل الخصم",
                        style: TextStyle(
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont",
                            fontWeight: FontWeight.bold),
                        textAlign: Constants.language == "en"
                            ? TextAlign.left
                            : TextAlign.right,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" || coupontype
                        ? false
                        : true,
                    child: Container(
                      width: width,
                      height: 220,
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Visibility(
                            visible: widget.type == "homebutton" ||
                                    widget.type == "online" ||
                                    widget.type == "home" ||
                                    coupontype
                                ? false
                                : true,
                            child: Text(
                              companyBranchList!.isNotEmpty
                                  ? Constants.language == "en"
                                      ? companyBranchList![tempindex]
                                          .branchOffers[0]
                                          .discountEnDetail
                                      : companyBranchList![tempindex]
                                          .branchOffers[0]
                                          .discountArbDetail
                                  : "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.type == "homebutton" ||
                                    widget.type == "online" ||
                                    widget.type == "home" ||
                                    coupontype
                                ? false
                                : true,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              color: Colors.grey,
                              height: 2.0,
                              width: width,
                            ),
                          ),
                          Visibility(
                            visible: widget.type == "homebutton" || coupontype
                                ? false
                                : true,
                            child: Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                  width: width,
                                  margin: const EdgeInsets.only(
                                      top: 10.0, left: 5.0, right: 5.0),
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                    textAlign: Constants.language == "en"
                                        ? TextAlign.left
                                        : TextAlign.right,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "homebutton" ||
                            widget.type == "home" ||
                            coupontype
                        ? false
                        : true,
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Constants.language == "en"
                                ? "Offr Expiration Date"
                                : "تاريخ انتهاء العرض",
                            style: TextStyle(
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                                fontWeight: FontWeight.bold),
                            textAlign: Constants.language == "en"
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                          Text(
                            companyBranchList!.isNotEmpty
                                ? companyBranchList![0].branchOffers[0].endDate
                                : "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: Constants.language == "en"
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "online" ? true : false,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              if (website.isNotEmpty) {
                                if (website.startsWith("http") ||
                                    website.startsWith("https")) {
                                  launch(website);
                                } else {
                                  launch("http://" + website);
                                }
                              }
                            },
                            child: const Image(
                              image: AssetImage("images/website.jpeg"),
                              width: 25.0,
                              height: 25.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (app_store.isNotEmpty) {
                                if (app_store.startsWith("http") ||
                                    app_store.startsWith("https")) {
                                  launch(app_store);
                                } else {
                                  launch("http://" + app_store);
                                }
                              }
                            },
                            child: const Image(
                              image: AssetImage("images/apple_store.jpeg"),
                              width: 25.0,
                              height: 25.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (play_store.isNotEmpty) {
                                if (play_store.startsWith("http") ||
                                    play_store.startsWith("https")) {
                                  launch(play_store);
                                } else {
                                  launch("http://" + play_store);
                                }
                              }
                            },
                            child: const Image(
                              image:
                                  AssetImage("images/google_play_store.jpeg"),
                              width: 25.0,
                              height: 25.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (huawei_store.isNotEmpty) {
                                if (huawei_store.startsWith("http") ||
                                    huawei_store.startsWith("https")) {
                                  launch(huawei_store);
                                } else {
                                  launch("http://" + huawei_store);
                                }
                              }
                            },
                            child: const Image(
                              image: AssetImage("images/huawei_store.jpeg"),
                              width: 25.0,
                              height: 25.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.type == "online" || widget.type == "home"
                        ? true
                        : false,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: phone.isNotEmpty ? 1 : 0,
                            child: Visibility(
                              visible: phone.isNotEmpty ? true : false,
                              child: InkWell(
                                onTap: () {
                                  if (phone.isNotEmpty) {
                                    launch("tel://$phone");
                                  }
                                },
                                child: const Image(
                                  image: AssetImage("images/phone.png"),
                                  width: 25.0,
                                  height: 25.0,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: whatsapp.isNotEmpty ? 1 : 0,
                            child: Visibility(
                              visible: whatsapp.isNotEmpty ? true : false,
                              child: InkWell(
                                onTap: () {
                                  if (whatsapp.isNotEmpty) {
                                    launch("https://wa.me/$whatsapp");
                                  }
                                },
                                child: const Image(
                                  image: AssetImage("images/whatsapp.png"),
                                  width: 25.0,
                                  height: 25.0,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: email.isNotEmpty ? 1 : 0,
                            child: Visibility(
                              visible: email.isNotEmpty ? true : false,
                              child: InkWell(
                                onTap: () {
                                  if (email.isNotEmpty) {
                                    launch("mailto:" + email);
                                  }
                                },
                                child: const Image(
                                  image: AssetImage("images/mail.png"),
                                  width: 25.0,
                                  height: 25.0,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: instagram.isNotEmpty ? 1 : 0,
                            child: Visibility(
                              visible: instagram.isNotEmpty ? true : false,
                              child: InkWell(
                                onTap: () {
                                  if (instagram.isNotEmpty) {
                                    launch(instagram);
                                  }
                                },
                                child: const Image(
                                  image: AssetImage("images/insta.png"),
                                  width: 25.0,
                                  height: 25.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget productPriceWidget(BuildContext context, double width, double height) {
    return Visibility(
      visible: (productPrice || menu_List) && !company_info,
      child: Column(
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
                                      if (e.url!
                                          .contains("https://instagram.com/")) {
                                        String trimmed_url = e.url!.replaceAll(
                                            "https://instagram.com/", "");
                                        var split_url = trimmed_url.split("?");
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
                                  // Route route = MaterialPageRoute(builder: (context) => WebViewScreen("", ""));
                                  // Navigator.push(context, route);
                                },
                                child: Image(
                                  image:
                                      NetworkImage(banner_base_url + e.banner!),
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
          Container(
            color: const Color(0xFFF2CC0F),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _getCompanyProducts().then((value) => {
                          if (value.productlist != null &&
                              value.productlist!.isNotEmpty)
                            {
                              if (productlist != null &&
                                  productlist!.isNotEmpty)
                                {
                                  setState(() {
                                    productlist!.clear();
                                  }),
                                },
                              for (int i = 0;
                                  i < value.productlist!.length;
                                  i++)
                                {
                                  productlist!.add(value.productlist![i]),
                                }
                            },
                          setState(() {
                            product_image_base_url = value.productImageBaseUrl!;
                            productPrice = true;
                            menu_List = false;
                            _isLoading = false;
                          }),
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: [
                        Text(
                          Constants.language == "en"
                              ? "Product /"
                                  " prices"
                              : "المنتج / الأسعار",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontSize: 16.0),
                        ),
                        Container(
                          width: 130.0,
                          margin: const EdgeInsets.only(top: 1.0),
                          height: 2.0,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _getMenuList().then((value) => {
                          if (value.menulist != null &&
                              value.menulist!.isNotEmpty)
                            {
                              for (int i = 0; i < value.menulist!.length; i++)
                                {
                                  menulist!.add(value.menulist![i]),
                                },
                              setState(() {
                                menu_base_url = value.imageBaseUrl!;
                                productPrice = false;
                                menu_List = true;
                                _isLoading = false;
                              }),
                            }
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: [
                        Text(
                          Constants.language == "en"
                              ? "Menu List"
                              : "قائمة الأسعار",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontSize: 16.0),
                        ),
                        Container(
                          width: 130.0,
                          margin: const EdgeInsets.only(top: 1.0),
                          height: 2.0,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            width: width,
            height: height * 0.05,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Row(
                    children: [
                      Visibility(
                        visible:
                            widget.type == "online" || widget.type == "home"
                                ? false
                                : true,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 5),
                          // margin: const EdgeInsets.only(top: 5.0),
                          child: LikeButton(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            padding: EdgeInsets.zero,
                            onTap: (bool) {
                              return _addOrRemoveFavOffer(bool);
                            },
                            isLiked: widget.isFavourite == "1" ? true : false,
                            circleColor: const CircleColor(
                              start: Color(0xff00ddff),
                              end: Color(0xff0099cc),
                            ),
                            bubblesColor: const BubblesColor(
                              dotPrimaryColor: Color(0xff33b5e5),
                              dotSecondaryColor: Color(0xff0099cc),
                            ),
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                isLiked
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color: isLiked ? Colors.red : Colors.black,
                                size: 35,
                              );
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        constraints: const BoxConstraints(),
                        iconSize: 30.0,
                        //   icon: const Icon(CupertinoIcons.location),
                        //  icon: const Icon(CupertinoIcons.location_solid,color: Color(0xFFF2CC0F),),
                        icon: Image.asset(
                          "images/locationcity.png",
                          color: Colors.black,
                        ),
                        color: Colors.black,
                        onPressed: () async {
                          if (location.isNotEmpty) {
                            if (widget.type == "online") {
                              String query = Uri.encodeComponent(location);
                              print("rohank" + query);
                              String googleUrl =
                                  "https://www.google.com/maps/search/?api=1&query=$query";

                              if (await canLaunch(googleUrl)) {
                                await launch(googleUrl);
                              }
                            } else {
                              launch(location);
                            }
                          }
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 30.0,
                        icon: const Icon(Icons.share),
                        color: Colors.black,
                        onPressed: () {
                          Share.share(
                              "Download the CityCode Application from the below link :- https://heylink.me/citycode");
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  color: Colors.black,
                  width: 1.0,
                  height: 50.0,
                ),
                Column(
                  children: [
                    Text(
                      selectedBranchName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                      ),
                    ),
                    // FittedBox(
                    //     child: Text(
                    //   " Minimum Online Charges not less than 5 Rial",
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     fontFamily:
                    //         Constants.language == "en" ? "Roboto" : "GSSFont",
                    //   ),
                    // )),
                  ],
                )
              ],
            ),
          ),
          Visibility(
            visible: productPrice && !menu_List && !company_info,
            child: Expanded(
              child: GridView.builder(
                itemCount: productlist!.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: width / 798,
                ),
                itemBuilder: (context, index) {
                  String price1 = "", price2 = "";
                  String a = "", b = "";
                  if (productlist![index].originalPrice!.isNotEmpty) {
                    if (productlist![index].originalPrice!.contains(" OMR")) {
                      a = productlist![index]
                          .originalPrice!
                          .replaceAll(" OMR", "");
                    } else {
                      a = productlist![index].originalPrice!;
                    }

                    if (productlist![index].price!.contains(" OMR")) {
                      b = productlist![index].price!.replaceAll(" OMR", "");
                    } else {
                      b = productlist![index].price!;
                    }

                    if (double.parse(a) <= 0 ||
                        double.parse(a) <= double.parse(b)) {
                      if (productlist![index].price!.contains(" OMR")) {
                        a = productlist![index].price!.replaceAll(" OMR", "");
                      } else {
                        a = productlist![index].price!;
                      }
                      String discount = "";
                      if (widget.discount.isNotEmpty) {
                        if (widget.discount.contains("%")) {
                          discount = widget.discount.replaceAll("%", "");
                        } else {
                          discount = widget.discount;
                        }
                      } else {
                        if (productlist![index].discountPer!.contains("%")) {
                          discount = productlist![index]
                              .discountPer!
                              .replaceAll("%", "");
                        } else {
                          discount = productlist![index].discountPer!;
                        }
                      }
                      double c =
                          (double.parse(a) / 100) * double.parse(discount);
                      b = (double.parse(a) - c).toString();
                      price1 = double.parse(a).toStringAsFixed(3);
                      price2 = double.parse(b).toStringAsFixed(3);
                    } else {
                      price1 = double.parse(a).toStringAsFixed(3);
                      price2 = double.parse(b).toStringAsFixed(3);
                    }
                  } else {
                    if (productlist![index].price!.contains(" OMR")) {
                      a = productlist![index].price!.replaceAll(" OMR", "");
                    } else {
                      a = productlist![index].price!;
                    }
                    String discount = "";
                    if (widget.discount.isNotEmpty) {
                      if (widget.discount.contains("%")) {
                        discount = widget.discount.replaceAll("%", "");
                      } else {
                        discount = widget.discount;
                      }
                    } else {
                      if (productlist![index].discountPer!.contains("%")) {
                        discount = productlist![index]
                            .discountPer!
                            .replaceAll("%", "");
                      } else {
                        discount = productlist![index].discountPer!;
                      }
                    }
                    double c = (double.parse(a) / 100) * double.parse(discount);
                    b = (double.parse(a) - c).toStringAsFixed(3);
                    price1 = double.parse(a).toStringAsFixed(3);
                    price2 = double.parse(b).toStringAsFixed(3);
                  }
                  return GestureDetector(
                    onTap: () {
                      String product_details = Constants.language == "en"
                          ? "Product Name: " + productlist![index].productName!
                          : productlist![index].arbProductName!.isNotEmpty
                              ? "اسم المنتج: " +
                                  productlist![index].arbProductName!
                              : "اسم المنتج: " +
                                  productlist![index].productName!;
                      String description2 = Constants.language == "en"
                          ? "\nDescription: " + productlist![index].description!
                          : productlist![index].arbDescription!.isNotEmpty
                              ? "\nالوصف: " +
                                  productlist![index].arbDescription!
                              : "\nالوصف: " + productlist![index].description!;
                      String description3 = Constants.language == "en"
                          ? "\nOriginal price: " +
                              price1.toString() +
                              "\nDiscounted price: " +
                              price2.toString()
                          : "\nالسعر الأصلي: " +
                              price1.toString() +
                              "\nالسعر بعد التخفيض: " +
                              price2.toString();
                      var priceone = price1;
                      var pricetwo = price2;
                      String productname = productlist![index].productName!;
                      String arbproductname =
                          productlist![index].arbProductName!;
                      var points = productlist![index].prRedeempoint!;
                      String description = productlist![index].description!;
                      var productid = productlist![index].id.toString();
                      var product_mobile =
                          productlist![index].productcostmobile.toString();
                      var productdiscountmobile =
                          productlist![index].productdiscountmobile.toString();
                      var branchid = productlist![index].branchId.toString();
                      var companyid = productlist![index].companyId.toString();
                      var companydiscount =
                          productlist![index].discountPer.toString();
                      if (Constants.skip == "1") {
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
                      } else {
                        Route route = MaterialPageRoute(
                            builder: (context) => booknow(
                                "  widget.cartid",
                                widget.company_name,
                                company_image,
                                Constants.user_id,
                                branch_id,
                                product_image_base_url +
                                    productlist![index].picture!,
                                product_details + description2 + description3,
                                "user",
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
                                points,
                                productid,
                                product_mobile,
                                productdiscountmobile,
                                branchid,
                                companyid,
                                companydiscount,
                                fastdel,
                                specialdel,
                                "1"));
                        Navigator.push(context, route);
                      }
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              Constants.language == "en"
                                  ? productlist![index].productName!
                                  : productlist![index]
                                          .arbProductName!
                                          .isNotEmpty
                                      ? productlist![index].arbProductName!
                                      : productlist![index].productName!,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                  fontSize: 14),
                            ),
                          ),
                          Container(
                            width: width,
                            height: 190,
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            child: Image(
                              width: width,
                              height: 190,
                              image: NetworkImage(product_image_base_url +
                                  productlist![index].picture!),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 10.0, top: 10.0, right: 10.0),
                            child: Text(
                              Constants.language == "en"
                                  ? productlist![index].description!
                                  : productlist![index]
                                          .arbDescription!
                                          .isNotEmpty
                                      ? productlist![index].arbDescription!
                                      : productlist![index].description!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 10.0, top: 10.0, right: 10.0),
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 74,
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                        // productlist![index]
                                        //             .productcostmobile
                                        //             .toString() ==
                                        //         "0.000"
                                        //     ?
                                        price1,
                                        // : productlist![index]
                                        //     .productcostmobile
                                        //     .toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationThickness: 2.85,
                                          decorationColor: Colors.red,
                                        )),
                                  ),
                                  Container(
                                    width: 74,
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      productlist![index]
                                                  .productdiscountmobile
                                                  .toString() ==
                                              "0.000"
                                          ? price2
                                          : productlist![index]
                                              .productdiscountmobile
                                              .toString(),
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                /* String product_details = Constants.language ==
                                        "en"
                                    ? "Product Name: " +
                                        productlist![index].productName!
                                    : productlist![index]
                                            .arbProductName!
                                            .isNotEmpty
                                        ? "اسم المنتج: " +
                                            productlist![index].arbProductName!
                                        : "اسم المنتج: " +
                                            productlist![index].productName!;
                                String description2 = Constants.language == "en"
                                    ? "\nDescription: " +
                                        productlist![index].description!
                                    : productlist![index]
                                            .arbDescription!
                                            .isNotEmpty
                                        ? "\nالوصف: " +
                                            productlist![index].arbDescription!
                                        : "\nالوصف: " +
                                            productlist![index].description!;
                                String description3 = Constants.language == "en"
                                    ? "\nOriginal price: " +
                                        price1.toString() +
                                        "\nDiscounted price: " +
                                        price2.toString()
                                    : "\nالسعر الأصلي: " +
                                        price1.toString() +
                                        "\nالسعر بعد التخفيض: " +
                                        price2.toString();
                                Route route = MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                        widget.company_name,
                                        company_image,
                                        Constants.user_id,
                                        branch_id,
                                        product_image_base_url +
                                            productlist![index].picture!,
                                        product_details +
                                            description2 +
                                            description3,
                                        "user",
                                        "", "0", "0"));
                                Navigator.push(context, route);*/
                                //  Navigator.push(context, MaterialPageRoute(builder: (context)=>booknow(company_name,company_image)));
                                String product_details = Constants.language ==
                                        "en"
                                    ? "Product Name: " +
                                        productlist![index].productName!
                                    : productlist![index]
                                            .arbProductName!
                                            .isNotEmpty
                                        ? "اسم المنتج: " +
                                            productlist![index].arbProductName!
                                        : "اسم المنتج: " +
                                            productlist![index].productName!;
                                String description2 = Constants.language == "en"
                                    ? "\nDescription: " +
                                        productlist![index].description!
                                    : productlist![index]
                                            .arbDescription!
                                            .isNotEmpty
                                        ? "\nالوصف: " +
                                            productlist![index].arbDescription!
                                        : "\nالوصف: " +
                                            productlist![index].description!;
                                String description3 = Constants.language == "en"
                                    ? "\nOriginal price: " +
                                        price1.toString() +
                                        "\nDiscounted price: " +
                                        price2.toString()
                                    : "\nالسعر الأصلي: " +
                                        price1.toString() +
                                        "\nالسعر بعد التخفيض: " +
                                        price2.toString();
                                var priceone = price1;
                                var pricetwo = price2;
                                String productname =
                                    productlist![index].productName!;
                                String arbproductname =
                                    productlist![index].arbProductName!;
                                String description =
                                    productlist![index].description!;
                                var points = productlist![index].prRedeempoint!;
                                var productid =
                                    productlist![index].id.toString();
                                var product_mobile = productlist![index]
                                    .productcostmobile
                                    .toString();
                                print("productmobile____" + product_mobile);
                                var productdiscountmobile = productlist![index]
                                    .productdiscountmobile
                                    .toString();
                                var branchid =
                                    productlist![index].branchId.toString();
                                var companyid =
                                    productlist![index].companyId.toString();
                                var companydiscount =
                                    productlist![index].discountPer.toString();
                                if (Constants.skip == "1") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => locationscreen(
                                                state: ""
                                                    'Oman, Al Batinah South,Barka',
                                                name: "",
                                                mobile: "",
                                                name1: "username.toString()",
                                                mobile2:
                                                    "usermobile.toString()",
                                                state2: "useradress.toString()",
                                                actuaprice: "itemamount",
                                                image: "imagedata",
                                                totalprice: "itemtotal",
                                                vat: "itemvat",
                                                discount: "itemdiscount",
                                                productname:
                                                    "companyproductdata",
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
                                } else {
                                  Route route = MaterialPageRoute(
                                      builder: (context) => booknow(
                                          "0",
                                          widget.company_name,
                                          company_image,
                                          Constants.user_id,
                                          branch_id,
                                          product_image_base_url +
                                              productlist![index].picture!,
                                          product_details +
                                              description2 +
                                              description3,
                                          "user",
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
                                          points,
                                          productid,
                                          product_mobile,
                                          productdiscountmobile,
                                          branchid,
                                          companyid,
                                          companydiscount,
                                          fastdel,
                                          specialdel,
                                          "1"));
                                  Navigator.push(context, route);
                                }
                              },
                              child: Text(
                                Constants.language == "en"
                                    ? "Buy Now"
                                    : "اشتري الآن",
                                /*?"More Details"
                                :"المزيد من التفاصيل",*/
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                  fontSize: 18.0,
                                ),
                              ),
                              /* child: Text(
                                Constants.language == "en"
                                    ? "BOOK NOW"
                                    : "احجز الآن",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                  fontSize: 18.0,
                                ),
                              ),*/
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xFFF2CC0F),
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
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible: !productPrice && menu_List && !company_info,
            child: Expanded(
              child: ListView.separated(
                itemCount: menulist!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: InteractiveViewer(
                      panEnabled: false,
                      scaleEnabled: true,
                      boundaryMargin: const EdgeInsets.all(50),
                      minScale: 0.5,
                      maxScale: 2,
                      child: Image(
                        // width: 100,
                        // height: 100,
                        image: NetworkImage(
                            menu_base_url + menulist![index].menuImage!),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    width: width,
                    height: 1.0,
                    color: Colors.black,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget companyInfoWidget(BuildContext context, double width, double height) {
    return Visibility(
      visible: company_info,
      child: Column(
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
                                      if (e.url!
                                          .contains("https://instagram.com/")) {
                                        String trimmed_url = e.url!.replaceAll(
                                            "https://instagram.com/", "");
                                        var split_url = trimmed_url.split("?");
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
                                  // Route route = MaterialPageRoute(builder: (context) => WebViewScreen("", e.url!));
                                  // Navigator.push(context, route);
                                },
                                child: Image(
                                  image:
                                      NetworkImage(banner_base_url + e.banner!),
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
          Container(
            margin: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              children: [
                Visibility(
                  visible: widget.type == "online" || widget.type == "home"
                      ? false
                      : true,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 5.0, right: 5.0, top: 5),
                    // margin: const EdgeInsets.only(top: 5.0),
                    child: LikeButton(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      padding: EdgeInsets.zero,
                      onTap: (bool) {
                        return _addOrRemoveFavOffer(bool);
                      },
                      isLiked: widget.isFavourite == "1" ? true : false,
                      circleColor: const CircleColor(
                        start: Color(0xff00ddff),
                        end: Color(0xff0099cc),
                      ),
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          isLiked
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: isLiked ? Colors.red : Colors.black,
                          size: 35,
                        );
                      },
                    ),
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  constraints: const BoxConstraints(),
                  iconSize: 30.0,
                  //  icon: const Icon(CupertinoIcons.location),
                  // icon: const Icon(CupertinoIcons.location_solid,color: Color(0xFFF2CC0F),),
                  icon: Image.asset(
                    "images/locationcity.png",
                    color: Colors.black,
                  ),
                  color: Colors.black,
                  onPressed: () async {
                    if (location.isNotEmpty) {
                      if (widget.type == "online") {
                        String query = Uri.encodeComponent(location);
                        print("rohank" + query);
                        String googleUrl =
                            "https://www.google.com/maps/search/?api=1&query=$query";

                        if (await canLaunch(googleUrl)) {
                          await launch(googleUrl);
                        }
                      } else {
                        launch(location);
                      }
                    }
                  },
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 30.0,
                  icon: const Icon(Icons.share),
                  color: Colors.black,
                  onPressed: () {
                    Share.share(
                        "Download the CityCode Application from the below link :- https://heylink.me/citycode");
                  },
                ),
              ],
            ),
          ),
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
            child: Text(
              Constants.language == "en"
                  ? "General information about the company"
                  : "معلومات عامة عن الشركة",
              style: TextStyle(
                color: Colors.black,
                fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
              ),
              textAlign:
                  Constants.language == "en" ? TextAlign.left : TextAlign.right,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    width: width,
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: phone.isNotEmpty ? 1 : 0,
                          child: Visibility(
                            visible: phone.isNotEmpty ? true : false,
                            child: InkWell(
                              onTap: () {
                                if (phone.isNotEmpty) {
                                  launch("tel://$phone");
                                }
                              },
                              child: const Image(
                                image: AssetImage("images/phone.png"),
                                width: 35.0,
                                height: 35.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: whatsapp.isNotEmpty ? 1 : 0,
                          child: Visibility(
                            visible: whatsapp.isNotEmpty ? true : false,
                            child: InkWell(
                              onTap: () {
                                if (whatsapp.isNotEmpty) {
                                  launch("https://wa.me/$whatsapp");
                                }
                              },
                              child: const Image(
                                image: AssetImage("images/whatsapp.png"),
                                width: 35.0,
                                height: 35.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: email.isNotEmpty ? 1 : 0,
                          child: Visibility(
                            visible: email.isNotEmpty ? true : false,
                            child: InkWell(
                              onTap: () {
                                if (email.isNotEmpty) {
                                  launch("mailto:" + email);
                                }
                              },
                              child: const Image(
                                image: AssetImage("images/mail.png"),
                                width: 35.0,
                                height: 35.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: instagram.isNotEmpty ? 1 : 0,
                          child: Visibility(
                            visible: instagram.isNotEmpty ? true : false,
                            child: InkWell(
                              onTap: () {
                                if (instagram.isNotEmpty) {
                                  launch(instagram);
                                }
                              },
                              child: const Image(
                                image: AssetImage("images/insta.png"),
                                width: 35.0,
                                height: 35.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: snapchat.isNotEmpty ? 1 : 0,
                          child: Visibility(
                            visible: snapchat.isNotEmpty ? true : false,
                            child: InkWell(
                              onTap: () {
                                if (snapchat.isNotEmpty) {
                                  launch(snapchat);
                                }
                              },
                              child: const Image(
                                image: AssetImage("images/snapchat.png"),
                                width: 35.0,
                                height: 35.0,
                              ),
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
                      Constants.language == "en"
                          ? "Inquiry type"
                          : "نوع الاستفسار",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                      ),
                      textAlign: Constants.language == "en"
                          ? TextAlign.left
                          : TextAlign.right,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: suggestion_controller,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.black)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.black)),
                        hintText: Constants.language == "en"
                            ? "Problem / Suggestion here"
                            : "مشكلة / اقتراح هنا",
                        hintStyle: TextStyle(
                          color: Colors.black45,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                        ),
                      ),
                      maxLines: 5,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    margin: const EdgeInsets.only(
                        left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (suggestion_controller.text.isNotEmpty) {
                          postSubmitData();
                        } else {
                          _alertDialog(Constants.language == "en"
                              ? "Please enter enquiry / suggestion"
                              : "الرجاء إدخال الاستفسار / الاقتراح");
                        }
                      },
                      child: Text(
                        Constants.language == "en" ? "Submit" : "إرسال",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                          fontSize: 18.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFF2CC0F),
                        elevation: 0.0,
                        textStyle: const TextStyle(color: Color(0xFFF2CC0F)),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Location {
  final double latitude;
  final double longitude;

  const Location(this.latitude, this.longitude);

  double distanceTo(Location other) {
    const earthRadius = 6371; // in km

    final lat1 = latitude;
    final lon1 = longitude;
    final lat2 = other.latitude;
    final lon2 = other.longitude;

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * asin(sqrt(a));

    final distance = earthRadius * c;
    return distance;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
