// ignore_for_file: file_names, unused_field, unused_local_variable, avoid_print, unused_element, avoid_unnecessary_containers

import 'dart:convert';
import 'package:city_code/Screens/address_screen.dart';
import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/models/company_products_model.dart';
import 'package:city_code/models/getadressmodel.dart';
import 'package:city_code/utils/constants.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Newclass.dart';
import '../models/user_details_model.dart';
import 'package:http/http.dart' as http;

class LocationDashbordScreen extends StatefulWidget {
  const LocationDashbordScreen({Key? key}) : super(key: key);

  @override
  State<LocationDashbordScreen> createState() => _LocationDashbordScreenState();
}

class _LocationDashbordScreenState extends State<LocationDashbordScreen> {
  List<Productlist>? productlist = [];

  Gender? _selectedGender;
  String? selectedUserIndex;
  List<Userdetail>? userdetail = [];
  late String _currentAddress = "";
  Position? _currentPosition;
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  static CameraPosition startLocation = const CameraPosition(
    target: LatLng(19.281530, 72.879600),
    zoom: 14,
  );
  Set<Marker> markers = {};
  bool isLoading = false;
  late String errorLoading;
  bool _isLoading = true;
  var demoadress = "";
  var userid = 0;
  var iddd = "";

  Future<User_details_model> getUserDetails() async {
    final response = await http.get(
      Uri.parse('http://185.188.127.11/public/index.php/ApiUsers/' +
          Constants.user_id),
    );

    var responseServer = jsonDecode(response.body);

    if (kDebugMode) {
      print(responseServer);
      // print(userdetail![0].name);
    }

    if (response.statusCode == 200) {
      if (responseServer["status"] == 201) {
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

  List<Userdetail> demolist = [];
  Future<void> getdata() async {
    String url =
        "http://185.188.127.11/public/index.php/ApiUsers/" + Constants.user_id;
    var network = NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = User_details_model.fromJson(res);

    setState(() {
      demolist = vlist.userdetail!;
    });
    List<String> myListOfStrings =
        demolist.map((e) => e.mobile.toString()).toList();
    //demolist.map((i)=>i.toString()).toList();
    for (var data in demolist) {
      var dataDost = data.state.toString();
      var datacity = data.cityName.toString();
      List<String> myListOfStrings = [dataDost, datacity];
      SharedPreferences pref = await SharedPreferences.getInstance();

      pref.setStringList("mylocation", myListOfStrings);
      print("rrrrr" + myListOfStrings.toString());
    }
    print("" + res!.toString());
  }

  List<ListAddress>? demolists = [];
  Future<void> getadressdata() async {
    String url = "http://185.188.127.11/public/index.php/getaddress?userid=" +
        Constants.user_id;
    var network = NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = GetAddressModel.fromJson(res);
    if (vlist.listAddress != null) {
      demolists = vlist.listAddress!;
    }
    setState(() {});

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
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }

  String? username = "";
  String? useradress;
  String? usermobile;
  Future<void> sharedata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString("nameofuser");
    print("username" + username.toString());
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    useradress = pref1.getString("Address");
    SharedPreferences pref2 = await SharedPreferences.getInstance();
    usermobile = pref2.getString("mobile");
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    placemarkFromCoordinates(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    ).then((List<Placemark> placemarks) {
      if (placemarks.isNotEmpty) {
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
    }).catchError((e) {
      setState(() {
        _currentAddress = 'Error: $e';
      });
    });
  }

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

  @override
  @override
  void initState() {
    if (selectedUserIndex == null) {
      print("myvalue" + selectedUserIndex.toString());
      print("myvalue1" + Constants.selectedOfusers);
      selectedUserIndex = Constants.selectedOfusers;
    }
    setState(() {});
    getadressdata();
    demoadress = _currentAddress.toString();
    getUserDetails();
    sharedata();
    getdata();
    _getCurrentPosition(); // Retrieve current location
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
      child: InkWell(
        onTap: () {},
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFF2CC0F),
            title: const Text(
              // "Enter Location",
              "Select Location to Deliver",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {},
            ),
            actions: [
              TextButton(
                //ISSKIPPIS CHANGED 3 TO 4
                onPressed: () {
                  Constants.skip = "1";
                  Route newRoute = MaterialPageRoute(
                      builder: (context) => HomeScreen("0", ""));
                  Navigator.pushAndRemoveUntil(
                      context, newRoute, (route) => false);
                },
                child: Text(
                  Constants.language == "en" ? "SKIP" : "",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
              )
            ],
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
                      height: MediaQuery.of(context).size.height * 0.28,
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: _currentPosition != null
                                ? CameraPosition(
                                    target: LatLng(_currentPosition!.latitude,
                                        _currentPosition!.longitude),
                                    zoom: 17,
                                  )
                                : startLocation,
                            myLocationEnabled: true,
                            markers: markers,
                            zoomControlsEnabled: true,
                            mapType: MapType.normal,
                            onMapCreated:
                                (GoogleMapController controller) async {
                              mapController = controller;
                              if (_currentPosition != null) {
                                mapController!.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: LatLng(_currentPosition!.latitude,
                                          _currentPosition!.longitude),
                                      zoom: 17,
                                    ),
                                  ),
                                );
                              }
                            },
                            onCameraMove: (CameraPosition cameraPosition) {
                              this.cameraPosition = cameraPosition;
                            },
                            onCameraIdle: () async {
                              if (_currentPosition != null) {
                                List<Placemark> placemarks =
                                    await placemarkFromCoordinates(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude,
                                );
                                setState(() {
                                  // Update address based on new position
                                  if (placemarks.isNotEmpty) {
                                    Placemark place = placemarks.first;
                                    _currentAddress =
                                        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
                                  } else {
                                    _currentAddress = 'No address found';
                                  }
                                });
                              }
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
                                            vat: "",
                                            discount: "",
                                            productname: "",
                                            image: "",
                                            actuaprice: "",
                                            totalprice: "",
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
                        /*  Row(
                          children: [
                            ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                shrinkWrap: true,
                                itemCount:1,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: (){
                                      //  Navigator.push(context, MaterialPageRoute(builder: (context)=>locationscreen()));
                                    },
                                    child: Card(
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      //    color: Colors.blueGrey.shade200,
                                      elevation: 5.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                           */ /* Image(
                                              height: 50,
                                              width: 80,
                                              image: AssetImage(paymentmod[index].icon),
                                            ),*/ /*
                                            SizedBox(
                                              width: 130,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Container(
                                                    //   width: width,
                                                    child: RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      text: TextSpan(
                                                          text: '',
                                                          style: TextStyle(
                                                              color: Colors.blueGrey.shade800,
                                                              fontSize: 16.0),
                                                          children: [
                                                            TextSpan(
                                                                text:"hii",
                                                               // '${paymentmod[index].name}\n',
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight.bold)),
                                                          ]),
                                                    ),
                                                  ),


                                                ],
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(left: 10,top: 20),
                                                child: Radio(
                                                    value: "radio value",
                                                    groupValue: "group value",
                                                    onChanged: (value){
                                                      print(value); //selected value
                                                    }
                                                )

                                            ),

                                          ],
                                        ),
                                      ),
                                    ),

                                  );
                                }),
                          ],
                        ),*/
                      ],
                    ),
                    if (demolist.isNotEmpty)
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
                                onTap: () {
                                  setState(() {
                                    Constants.nameOfusers =
                                        demolists![index].name.toString();
                                    Constants.numberOfusers =
                                        demolists![index].phone.toString();
                                    Constants.housenoOfusers =
                                        demolists![index].houseNo.toString();
                                    Constants.adressOfusers =
                                        demolists![index].state.toString();
                                    Constants.selectedOfusers =
                                        selectedUserIndex.toString();
                                    print("selectedIndex" +
                                        selectedUserIndex.toString());
                                    print("helooe" +
                                        selectedUserIndex.toString());
                                  });

                                  String iddd = demolists![index].id.toString();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomeScreen("0", iddd)),
                                    (route) => false,
                                  );
                                },

                                // onTap: () {
                                //   setState(() {
                                //     Constants.nameOfusers =
                                //         demolists![index].name.toString();
                                //     Constants.numberOfusers =
                                //         demolists![index].phone.toString();
                                //     Constants.housenoOfusers =
                                //         demolists![index].houseNo.toString();
                                //     Constants.adressOfusers =
                                //         demolists![index].state.toString();
                                //     List<String> myListOfString = [
                                //       demolists![index].governate.toString() +
                                //           "," +
                                //           demolists![index].state.toString() +
                                //           "," +
                                //           demolists![index].houseNo.toString()
                                //     ];
                                //     Constants.nameOfusers =
                                //         demolists![index].name.toString();
                                //     //selectedUserIndex = value as String;
                                //     Constants.selectedOfusers =
                                //         selectedUserIndex.toString();
                                //     print("selectedIndex" +
                                //         selectedUserIndex.toString());
                                //     print("helooe" +
                                //         selectedUserIndex.toString());
                                //   });

                                //   iddd = demolists![index].id.toString();

                                //   Route newRoute = MaterialPageRoute(
                                //       builder: (context) =>
                                //           HomeScreen("0", ""));
                                //   Navigator.pushAndRemoveUntil(
                                //       context, newRoute, (route) => false);
                                //   // print(demolist![index].cityName);
                                //   print("rohanId" + iddd.toString());
                                // },
                                child: ListTile(
                                  title: Text(demolists![index].name.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18.0)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          demolists![index].houseNo.toString() +
                                              ', ' +
                                              demolists![index]
                                                  .governate
                                                  .toString() +
                                              "," +
                                              demolists![index]
                                                  .state
                                                  .toString(),
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
}
