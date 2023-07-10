// ignore_for_file: camel_case_types, unused_field, non_constant_identifier_names, unused_local_variable, avoid_print, unused_element, avoid_unnecessary_containers, must_be_immutable, void_checks, unnecessary_null_comparison

import 'dart:convert';

import 'package:city_code/Network/network.dart';
import 'package:city_code/Screens/address_screen.dart';
import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/company_products_model.dart';
import 'package:city_code/models/getadressmodel.dart';
import 'package:city_code/models/savedatamodel.dart';
import 'package:city_code/utils/constants.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_details_model.dart';

const kGoogleApiKey = "YOUR_API_KEY";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class locationscreen extends StatefulWidget {
  // const locationscreen({Key? key}) : super(key: key);
  String name,
      state,
      mobile,
      name1,
      state2,
      mobile2,
      actuaprice,
      discount,
      vat,
      totalprice,
      image,
      productname,
      demo,
      quantity,
      totalpoints,
      dilivery,
      itemdiscount,
      productid,
      mobilecost,
      mobilediscouunt,
      mobtotal,
      del,
      type;

  locationscreen(
      {Key? key,
      required this.name,
      required this.state,
      required this.mobile,
      required this.name1,
      required this.state2,
      required this.mobile2,
      required this.actuaprice,
      required this.discount,
      required this.totalprice,
      required this.vat,
      required this.image,
      required this.productname,
      required this.demo,
      required this.quantity,
      required this.totalpoints,
      required this.dilivery,
      required this.itemdiscount,
      required this.productid,
      required this.mobilecost,
      required this.mobilediscouunt,
      required this.mobtotal,
      required this.del,
      required this.type})
      : super(key: key);

  @override
  State<locationscreen> createState() => _locationscreenState();
}

enum Gender { first, second, third }

class _locationscreenState extends State<locationscreen> {
  bool isAddressBlank = true;
  String blankAddress = '';
  bool isEditClicked = false;
  List addressDataList = [];

  List<Productlist>? productlist = [];
  Gender? _selectedGender;
  String? selectedUserIndex;
  List<Userdetail>? userdetail = [];
  late String _currentAddress = "";
  Position? _currentPosition;
  late GoogleMapController googleMapController;
  static CameraPosition inialcameraposition =
      const CameraPosition(target: LatLng(19.2785471, 72.8796206), zoom: 14);
  Set<Marker> markers = {};
  bool isLoading = false;
  late String errorLoading;
  bool _isLoading = true;
  var demoadress = "";
  var userid = 0;
  var iddd = "";
  late PlacesDetailsResponse place;

  Future<User_details_model> getUserDetails() async {
    final response = await http.get(
      Uri.parse('http://185.188.127.11/public/index.php/ApiUsers/' +
          Constants.user_id),
    );

    var response_server = jsonDecode(response.body);

    if (kDebugMode) {
      print(response_server);
      // print(userdetail![0].name);
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
  }

  // List<Userdetail> demolist = [];
  String addressType = "";
  // Future<void> getdata() async {
  //   String url =
  //       "http://185.188.127.11/public/index.php/ApiUsers/" + Constants.user_id;
  //   var network = NewVendorApiService();
  //   var res = await network.getresponse(url);
  //   var vlist = User_details_model.fromJson(res);

  //   setState(() {
  //     demolist = vlist.userdetail!;
  //   });
  //   List<String> myListOfStrings =
  //       demolist.map((e) => e.mobile.toString()).toList();
  //   //demolist.map((i)=>i.toString()).toList();
  //   for (var data in demolist) {
  //     var dataDost = data.state.toString();
  //     var datacity = data.cityName.toString();
  //     List<String> myListOfStrings = [dataDost, datacity];
  //     SharedPreferences pref = await SharedPreferences.getInstance();

  //     pref.setStringList("mylocation", myListOfStrings);
  //     print("rrrrr" + myListOfStrings.toString());
  //   }
  //   print("" + res!.toString());
  // }

  List<ListAddress>? demolists = [];
  Future<void> getadressdata() async {
    String url = "http://185.188.127.11/public/index.php/getaddress?userid=" +
        Constants.user_id;
    var network = NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = GetAddressModel.fromJson(res);

    setState(() {
      demolists = vlist.listAddress!;
    });

    print("" + res!.toString());
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

  Future<void> savedata() async {
    Map<String, String> jsonbody = {
      "userid": Constants.user_id,
      "qty": widget.quantity,
      "product_id": widget.productid,
      "branch_id": Constants.branch_id,
      "company_id": Constants.company_id,
      "actual_price": widget.actuaprice,
      "afterdiscount_price": widget.discount,
      "discount": widget.itemdiscount,
      "total_amount": widget.totalprice
      /*   "ad_1":_ads_1_file,
      "ad_2":_ads_2_file.toString(),
      "ad_3":_ads_3_file.toString(),
      "ad_4":_ads_4_file.toString(),
*/
    };
    var network = NewVendorApiService();
    String urls = "http://cp.citycode.om/public/index.php/ordersave";
    var res = await network.postresponse(urls, jsonbody);
    var model = Savedatamodel.fromJson(res);
    String stat = model.status.toString();
    //var nopopupcatID = widget.cat_id;

    print("savedata" + stat);

    if (stat.contains("201")) {
      Fluttertoast.showToast(
          msg: " Succesfully Added ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      /*print("Done"+Constants.category);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.category = widget.cat_id;
    //   await prefs.setBool('isLoggedIn', true);
    await prefs.setString("category", Constants.category);
    print("hogaya"+Constants.category);
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) =>
    VendorThankyouPage(bback:widget.cat_idd,)));*/
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

  String? username = "";
  String? useradress;
  String? usermobile;
  Future<void> shareData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString("nameofuser");
    print("username: " + username.toString());
  }

  Future<bool> handleLocationPermission() async {
    // Handle location permission logic here
    // ...

    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      await getAddressFromLatLng(_currentPosition!);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        });
      } else {
        setState(() {
          _currentAddress = 'No address found';
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _currentAddress = 'Error retrieving address';
      });
    }
  }
  // Future<void> sharedata() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   username = pref.getString("nameofuser");
  //   print("username" + username.toString());
  //   SharedPreferences pref1 = await SharedPreferences.getInstance();
  //   useradress = pref1.getString("Address");
  //   SharedPreferences pref2 = await SharedPreferences.getInstance();
  //   usermobile = pref2.getString("mobile");
  // }

  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location services are disabled. Please enable the services')));
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Location permissions are denied')));
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location permissions are permanently denied, we cannot request permissions.')));
  //     return false;
  //   }
  //   return true;
  // }

  // Future<void> getCurrentPosition() async {
  //   final hasPermission = await _handleLocationPermission();

  //   if (!hasPermission) return;
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //     setState(() => _currentPosition = position);
  //     _getAddressFromLatLng(_currentPosition!);
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  // Future<void> _getAddressFromLatLng(Position position) async {
  //   await placemarkFromCoordinates(
  //           _currentPosition!.latitude, _currentPosition!.longitude)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];
  //     setState(() {
  //       _currentAddress =
  //           '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
  //       addressDataList
  //         ..add(place.street)
  //         ..add(place.subLocality)
  //         ..add(place.subAdministrativeArea)
  //         ..add(place.postalCode);
  //     });
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  Future<Position> _determineposition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error("Location Service are disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location Service are disabled");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location Service are disabled");
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  void _updatePosition(CameraPosition _position) {
    Position newMarkerPosition = Position(
        latitude: _position.target.latitude,
        longitude: _position.target.longitude,
        accuracy: 10,
        altitude: 1.0,
        heading: 0.0,
        speed: 10,
        speedAccuracy: 1,
        timestamp: null);

    Marker marker = const Marker(markerId: MarkerId("marker_1"));

    setState(() {
      marker = marker.copyWith(
          positionParam:
              LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude));
    });
  }

  void handleRadioValueChanged(String value, int index) async {
    Constants.skip = '';

    List<String> myListOfString = [
      demolists![index].governate.toString() +
          "," +
          demolists![index].state.toString() +
          "," +
          demolists![index].houseNo.toString()
    ];
    Constants.nameOfusers = demolists![index].name.toString();
    selectedUserIndex = value;
    Constants.selectedOfusers = selectedUserIndex.toString();
    print("selectedIndex: " + selectedUserIndex.toString());
    print("hello: " + selectedUserIndex.toString());

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("nameOfusers", Constants.nameOfusers);
    pref.setStringList("myAddress", myListOfString);

    setState(() {
      // Update the state here if necessary
    });
  }

  late CameraPosition cameraPosition;

  @override
  void initState() {
    shareData(); // Perform asynchronous task separately

    getCurrentPosition();
    super.initState();
    cameraPosition = const CameraPosition(
      target: LatLng(0, 0), // Provide a default latitude and longitude
      zoom: 0, // Provide a default zoom level
    );
    // Constants.skip = "";
    if (selectedUserIndex == null) {
      print("myvalue" + selectedUserIndex.toString());
      print("myvalue1" + Constants.selectedOfusers);
      selectedUserIndex = Constants.selectedOfusers;
    }
    print("mytype" + widget.type);
    //getda();
    // savedata();
    setState(() {});
    //getadressdata();
    demoadress = _currentAddress.toString();
    getUserDetails();

    getadressdata();
    super.initState();
  }

  @override
  setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //GetAddressFromLatLong();
    return Material(
      child: InkWell(
        onTap: () {},
        child: Scaffold(
          bottomNavigationBar: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: ElevatedButton(
              onPressed: () async {
                if (selectedUserIndex == null) {
                  _alertDialog("Please Select Your Address");
                } else if (widget.type == "2") {
                  Navigator.pop(context);
                } else if (widget.type == "1") {
                  print("datadost" + _selectedGender.toString());
                  Route newRoute = MaterialPageRoute(
                      builder: (context) => HomeScreen("0", ""));
                  Navigator.of(context).pushReplacement(newRoute);
                }
                /* else{

                 // _showDialog(context,width);
                }*/
                //  _showdialog(context,width);

/*if(_selectedGender=="male"){


}*/
              },
              child: const Text(
                "Submit",
                style: TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 16.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width, 40.0),
                backgroundColor: const Color(0xFFF2CC0F),
                shadowColor: const Color(0xFFF2CC0F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFF2CC0F),
            title: const Text(
              // "Enter Location",
              "Select Location To Deliver",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                if (widget.type == "2") {
                  Navigator.pop(context);
                } else {
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
                                Constants.language == "en"
                                    ? 'Are you sure you want to Exit ?'
                                    : "هل أنت متأكد أنك تريد حذف هذه الرسالة ؟",
                                style: TextStyle(
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('NO'),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('YES'),
                            onPressed: () async {
                              SystemNavigator.pop();
                              /* Navigator.of(context,
                                  rootNavigator:
                                  true)
                                  .pop();*/
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context)
                          .size
                          .width, // or use fixed size like 200
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: inialcameraposition,
                            myLocationEnabled: true,
                            // onCameraMove: ((_position) => _updatePosition(_position)),
                            markers: markers,
                            zoomControlsEnabled: true,
                            mapType: MapType.normal,
                            /*markers: Set<Marker>.of(
                                <Marker> [
                                  Marker(
                                    markerId: MarkerId("home"),
                                    position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                                    icon: BitmapDescriptor.defaultMarker,
                                    infoWindow: InfoWindow(
                                        title: ""
                                    ),
                                    draggable: true,
                                  ),
                                ]
                            ),*/
                            onMapCreated:
                                (GoogleMapController controller) async {
                              googleMapController = controller;
                              Position position = await _determineposition();
                              googleMapController.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: LatLng(position.latitude,
                                          position.longitude),
                                      zoom: 14)));
                              getCurrentPosition();
                              markers.clear();

                              /* markers.add(Marker(
                        markerId: MarkerId("home"),

                        position: LatLng(position.latitude, position.longitude),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),

                        infoWindow: InfoWindow(

                            title: _currentAddress
                        ),
                        draggable: true,
                         ),);*/
                            },
                            onCameraMove: (CameraPosition cameraPositiona) {
                              cameraPosition =
                                  cameraPositiona; //when map is dragging
                            },
                            onCameraIdle: () async {
                              // when map drag stops
                              List<Placemark> placemarks =
                                  await placemarkFromCoordinates(
                                cameraPosition.target.latitude,
                                cameraPosition.target.longitude,
                              );
                              setState(() {
                                // get place name from lat and lang
                                var location = placemarks.first.street
                                        .toString() +
                                    "," +
                                    placemarks.first.subLocality.toString() +
                                    "," +
                                    placemarks.first.administrativeArea
                                        .toString() +
                                    "," +
                                    placemarks.first.postalCode.toString();
                                var lac = placemarks.first.name.toString();
                                _currentAddress = location;
                                //  _house.text = lac.toString();
                              });
                            },
                          ),
                          Center(
                            //picker image on google map
                            child: Image.asset(
                              "images/tool.png",
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    /* InkWell(
                      onTap: () {
                        getCurrentPosition;
                 */ /*       setState(() {

                          if (useCurrent) {
                            useCurrent = false;
                          } else {
                            useCurrent = true;
                          }
                        });*/ /*
                      },
                      child: Card(
                        color: const Color(0xFFF2CC0F),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          side: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.my_location,
                                color: Colors.black,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10.0),
                                child: const Text(
                                  "Use My Current Location",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),*/
                    GestureDetector(
                      onTap: () async {
                        Position position = await _determineposition();

                        googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(
                                    position.latitude, position.longitude),
                                zoom: 14)));
                        getCurrentPosition();
                        //markers.clear();

                        /* markers.add(Marker(
                        markerId: MarkerId("home"),

                        position: LatLng(position.latitude, position.longitude),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),

                        infoWindow: InfoWindow(

                            title: _currentAddress
                        ),
                        draggable: true,
                      ),);*/
                        setState(() {
                          //  _getAddressFromLatLng(position);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Card(
                          color: const Color(0xFFF2CC0F),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            side: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.my_location,
                                  color: Colors.black,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Adreess_screen(
                                                  demoadress:
                                                      demoadress.toString(),
                                                  vat: widget.vat,
                                                  discount: widget.discount,
                                                  productname:
                                                      widget.productname,
                                                  image: widget.image,
                                                  actuaprice: widget.actuaprice,
                                                  totalprice: widget.totalprice,
                                                  tempindex: '',
                                                  isEditClicked: false,
                                                  residenceType: '',
                                                  aptmntData: const [],
                                                  houseData: const [],
                                                  officeData: const [],
                                                )));
                                    getCurrentPosition();
                                    // print("location" +
                                    //     _currentPosition.toString());
                                    // demoadress = _currentAddress.toString();
                                    // demoadress = demoadress.toString();
                                    // setState(() {
                                    //   demoadress = _currentAddress.toString();
                                    //   print("bjbjj" + demoadress);
                                    // });
                                    // isAddressBlank = false;
                                    // //print("currentname"+place.result.name.toString());
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    //   onPressed: getCurrentPosition,
                                    child:
                                        const Text("Use My Current Location"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    isAddressBlank
                        ? Container()
                        : InkWell(
                            onTap: () {
                              Constants.nameOfusers = addressDataList[1];
                              Constants.housenoOfusers = addressDataList[0];
                              Constants.adressOfusers = addressDataList[2];

                              // if (selectedUserIndex == null) {
                              //   _alertDialog("Please Select Your Address");
                              // } else if (widget.type == "2") {
                              //   Navigator.pop(context);
                              // } else if (widget.type == "1") {
                              //   print("datadost" + _selectedGender.toString());
                              //   Route newRoute = MaterialPageRoute(
                              //       builder: (context) => HomeScreen("0", ""));
                              //   Navigator.of(context).pushReplacement(newRoute);
                              // }
                              Route newRoute = MaterialPageRoute(
                                  builder: (context) => Adreess_screen(
                                        actuaprice: '',
                                        demoadress: '',
                                        discount: '',
                                        image: '',
                                        isEditClicked: true,
                                        productname: '',
                                        tempindex: '',
                                        totalprice: '',
                                        vat: '',
                                        residenceType: '',
                                        aptmntData: const [],
                                        houseData: const [],
                                        officeData: const [],
                                      ));
                              Navigator.of(context).push(newRoute);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: kYellowFaded,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              margin:
                                  const EdgeInsets.only(top: 10.0, bottom: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  // demoadress.toString(),
                                  isAddressBlank
                                      ? blankAddress
                                      : _currentAddress,

                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                    isAddressBlank
                        ? Container()
                        : Row(children: <Widget>[
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 20.0),
                                  child: const Divider(
                                    thickness: 1.5,
                                    color: Colors.black,
                                    height: 20,
                                  )),
                            ),
                            const Text(
                              "OR",
                              style: TextStyle(fontSize: 18),
                            ),
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 10.0),
                                  child: const Divider(
                                    thickness: 1.5,
                                    color: Colors.black,
                                    height: 20,
                                  )),
                            ),
                          ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          // margin: EdgeInsets.only(top: 5.0),
                          child: TextButton.icon(
                            // <-- TextButton
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Adreess_screen(
                                            demoadress: demoadress.toString(),
                                            vat: widget.vat,
                                            discount: widget.discount,
                                            productname: widget.productname,
                                            image: widget.image,
                                            actuaprice: widget.actuaprice,
                                            totalprice: widget.totalprice,
                                            tempindex: '',
                                            isEditClicked: false,
                                            residenceType: '',
                                            aptmntData: const [],
                                            houseData: const [],
                                            officeData: const [],
                                          )));
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 24.0,
                            ),
                            label: const Text(
                              'ADD NEW ADDRESS',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        //  height: 1,
                        ),
                    const SizedBox(
                        // height: 10,
                        ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 30),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: demolists!.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: const Color(0xFFE6D997),
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: InkWell(
                              onTap: () async {
                                isEditClicked = true;
                                setState(() {
                                  // if (isEditClicked == true) {
                                  Constants.nameOfusers =
                                      demolists![index].name.toString();
                                });
                                var data = demolists![index];

                                iddd = demolists![index].id.toString();
                                addressType =
                                    demolists![index].addressType ?? "";

                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Adreess_screen(
                                              demoadress: demoadress.toString(),
                                              vat: widget.vat,
                                              discount: widget.discount,
                                              productname: widget.productname,
                                              image: widget.image,
                                              actuaprice: widget.actuaprice,
                                              totalprice: widget.totalprice,
                                              tempindex: iddd.toString(),
                                              isEditClicked: isEditClicked,
                                              residenceType: addressType,
                                              houseData: [
                                                data.block.toString(),
                                                data.street.toString(),
                                                data.way.toString(),
                                                data.houseNo.toString(),
                                                data.additionalDirections
                                                    .toString()
                                              ],
                                              aptmntData: [
                                                data.block.toString(),
                                                data.street.toString(),
                                                data.way.toString(),
                                                data.building.toString(),
                                                data.floor.toString(),
                                                data.apartmentNo.toString(),
                                                // data.additionalDirections
                                                //     .toString()
                                              ],
                                              officeData: [
                                                data.block.toString(),
                                                data.street.toString(),
                                                data.way.toString(),
                                                data.building.toString(),
                                                data.floor.toString(),
                                                data.office.toString(),
                                                data.additionalDirections
                                                    .toString()
                                              ],
                                            )));
                                getadressdata();
                                setState(() {});
                              },
                              child: ListTile(
                                title: Text(demolists![index].name.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18.0)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        demolists![index].houseNo.toString() +
                                            demolists![index]
                                                .apartmentNo
                                                .toString() +
                                            demolists![index]
                                                .office
                                                .toString() +
                                            demolists![index].block.toString() +
                                            demolists![index]
                                                .street
                                                .toString() +
                                            demolists![index].way.toString() +
                                            demolists![index]
                                                .building
                                                .toString() +
                                            demolists![index].floor.toString() +
                                            demolists![index]
                                                .additionalDirections
                                                .toString(),

                                        // demolists![index]
                                        //     .demolists![index]
                                        //     .state
                                        //     .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            fontSize: 18.0)),
                                    Text(demolists![index].phone.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            fontSize: 18.0)),
                                  ],
                                ),
                                trailing: Radio<void>(
                                  value: demolists![index].id,
                                  groupValue: selectedUserIndex,
                                  activeColor: Colors.black,
                                  onChanged: (value) async {
                                    handleRadioValueChanged(
                                        value as String, index);
                                    if (value != null) {
                                      Constants.skip = '';

                                      List<String> myListOfString = [
                                        demolists![index].governate.toString() +
                                            "," +
                                            demolists![index].state.toString() +
                                            "," +
                                            demolists![index].houseNo.toString()
                                      ];
                                      Constants.nameOfusers =
                                          demolists![index].name.toString();
                                      selectedUserIndex = value;
                                      Constants.selectedOfusers =
                                          selectedUserIndex.toString();
                                      print("selectedIndex: " +
                                          selectedUserIndex.toString());
                                      print("hello: " +
                                          selectedUserIndex.toString());

                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      await pref.setString(
                                          "nameOfusers", Constants.nameOfusers);
                                      await pref.setStringList(
                                          "myAddress", myListOfString);

                                      setState(() {
                                        // Update the state here if necessary
                                      });
                                    }
                                  },
                                ),
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
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context, double width) {
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
                                    backgroundImage: NetworkImage(widget.image),
                                    radius: 40.0,
                                  ),
                                ),
                              ),
                              IconButton(
                                iconSize: 30.0,
                                onPressed: () {
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
                          : widget.productname,
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
                          margin: const EdgeInsets.only(top: 10.0),
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
                                  widget.quantity,
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
                                child: Text(
                                  Constants.language == "en"
                                      ? "Actual Price:"
                                      : "السعر الأصلي",
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
                                    widget.mobilecost == "0"
                                        ? widget.actuaprice
                                        : widget.mobilecost,
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
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                /*Constants.language == "en"
                                ? "Amount To Pay"
                                : "المبلغ للدفع",*/

                                Constants.language == "en"
                                    ? "After Discount:"
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
                                  widget.mobilediscouunt == "0"
                                      ? widget.discount
                                      : widget.mobilediscouunt,
                                  style: const TextStyle(fontFamily: "Roboto"),
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
                        Container(
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
                                child: Text(
                                  widget.del == "1"
                                      ? "1.2 OMR"
                                      : widget.dilivery,
                                  style: const TextStyle(fontFamily: "Roboto"),
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
                        Container(
                          margin:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Column(
                            children: [
                              /*  Text(
                                        */ /*   Constants.language == "en"
                                    ? "Use Points"
                                    : "استخدم النقاط",*/ /*
                                        " Suplier VAT",
                                        style: TextStyle(
                                            fontFamily: Constants.language == "en"
                                                ? "Roboto"
                                                : "GSSFont",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5.0),
                                        child: Text(widget.vat,
                                          style: TextStyle(fontFamily: "Roboto"),
                                        ),
                                      ),*/
                              /*Container(
                                        margin: const EdgeInsets.only(top: 10.0),
                                        height: 1.0,
                                        color: Colors.black,
                                      ),
*/

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
                                  widget.mobtotal == "0"
                                      ? widget.totalprice
                                      : widget.mobtotal,
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
                                  widget.totalpoints,
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
                                margin: const EdgeInsets.only(
                                    top: 20, left: 10, right: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _alertShow(context, "success");
                                    //_alertDialog("Online Payment");
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
