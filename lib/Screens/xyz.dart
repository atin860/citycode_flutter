// ignore_for_file: must_be_immutable, camel_case_types, unused_field, prefer_final_fields, non_constant_identifier_names, avoid_print, duplicate_ignore, unused_element, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:city_code/Screens/location_screen.dart';
import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/getadressmodel.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:city_code/models/adressmodel.dart';
import 'package:city_code/models/city_model.dart';
import 'package:city_code/models/nationality_model.dart';
import 'package:city_code/models/state_model.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Adreess_screen extends StatefulWidget {
  // const Adreess_screen({Key? key}) : super(key: key);
  String demoadress,
      vat,
      discount,
      actuaprice,
      image,
      totalprice,
      productname,
      tempindex;
  bool isEditClicked;
  String residenceType;
  List<String> houseData;
  List<String> aptmntData;
  List<String> officeData;

  Adreess_screen(
      {Key? key,
      required this.demoadress,
      required this.vat,
      required this.image,
      required this.productname,
      required this.totalprice,
      required this.actuaprice,
      required this.discount,
      required this.tempindex,
      required this.isEditClicked,
      required this.residenceType,
      required this.houseData,
      required this.aptmntData,
      required this.officeData})
      : super(key: key);

  @override
  State<Adreess_screen> createState() => _Adreess_screenState();
}

enum Gender { first, second, third }

class _Adreess_screenState extends State<Adreess_screen> {
  late GoogleMapController googleMapController;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  String addressType = '';

  String? _dropDownValue;
  late String _currentAddress = "";
  Position? _currentPosition;
  static CameraPosition inialcameraposition =
      const CameraPosition(target: LatLng(19.2785471, 72.8796206), zoom: 14);
  Set<Marker> markers = {};
  final TextEditingController _name = TextEditingController();
  final TextEditingController _governate = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _house = TextEditingController();

  TextEditingController _mobile = TextEditingController();
  final TextEditingController _Address = TextEditingController();

  String state_id = "";
  String nationality_id = "";
  String city_id = "";

  Gender? _selectedGender;
  String nationalityValue = 'Oman';
  String governorateValue =
      Constants.language == "en" ? "Select Governorate" : "اختر محافظة";
  String cityValue = Constants.language == "en" ? "Select State" : "اختر ولايه";
  late List<String> nationalityList = [];
  late List<String> governorateList = [
    Constants.language == "en" ? "Select Governorate" : "اختر محافظة"
  ];
  List<State_list>? governorateModelList = [];
  List<Country_list>? nationalityModelList = [];
  List<City_list>? cityModelList = [];
  late List<String> cityList = [
    Constants.language == "en" ? "Select State" : "اختر ولايه"
  ];
  late Future<Nationality_model> nationalList;
  late Future<State_model> stateList;
  late Future<City_model> city_List;
  NetworkCheck networkCheck = NetworkCheck();
  bool _isLoading = true;
  final bool _validate = false;

  final _addressFromGoogle = TextEditingController();

  final blockController = TextEditingController();
  final streetController = TextEditingController();
  final wayController = TextEditingController();
  final addInfoController = TextEditingController();
  final flooorController = TextEditingController();
  final officeController = TextEditingController();
  late final apartmentController = TextEditingController();
  final bldgController = TextEditingController();

  bool isHouseSelected = false;

  bool isAptmntSelected = false;

  bool isOfficeSelected = false;

  List<String> residentialList = ['House', 'Apartment', 'Office'];

  Future<City_model> _getCity(String stateId) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (!isConnected) {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to the internet"
          : "الرجاء الاتصال بالإنترنت");
      throw Exception('Failed to load album');
    }

    final response = await http.get(Uri.parse(
        'http://185.188.127.11/citycode_dev/public/index.php/getcities?state_id=' +
            stateId));

    if (response.statusCode == 201) {
      var responseServer = jsonDecode(response.body);
      if (kDebugMode) {
        print(responseServer);
      }

      if (responseServer["status"] == 201) {
        return City_model.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load album');
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<State_model> _getState() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/citycode_dev/public/index.php/ApiFilters?language='));
      if (response.statusCode == 201) {
        var responseServer = jsonDecode(response.body);

        if (kDebugMode) {
          print(responseServer);
        }
        if (responseServer["status"] == 201) {
          return State_model.fromJson(jsonDecode(response.body));
        } else {
          throw Exception('Failed to load album');
        }
      } else {
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

  Future<Nationality_model> _getNationality() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/citycode_dev/public/index.php/ApiFilters?language='));
      if (response.statusCode == 201) {
        var responseServer = jsonDecode(response.body);

        if (kDebugMode) {
          print("dattata");
          print(responseServer);
        }
        if (responseServer["status"] == 201) {
          setState(() {
            _isLoading = false;
          });
          return Nationality_model.fromJson(jsonDecode(response.body));
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

  getMblno() async {
    final pref = await SharedPreferences.getInstance();
    var mobileNo = pref.getString('mblno');
    if (mobileNo != null) {
      _mobile.text = mobileNo;
    }
    if (widget.residenceType == 'House') {
      var data = widget.houseData;
      isHouseSelected = true;
      blockController.text = data[0];
      streetController.text = data[1];
      wayController.text = data[2];
      _house.text = data[3];
      addInfoController.text = data[4];
      _dropDownValue = widget.residenceType;
    } else if (widget.residenceType == 'Apartment') {
      var data = widget.aptmntData;
      isHouseSelected = true;

      blockController.text = data[0];
      streetController.text = data[1];
      wayController.text = data[2];
      bldgController.text = data[3];
      flooorController.text = data[4];
      apartmentController.text = data[5];
      _dropDownValue = widget.residenceType;

      _dropDownValue = widget.residenceType;

      isAptmntSelected = true;
    } else if (widget.residenceType == 'Office') {
      var data = widget.officeData;

      _dropDownValue = widget.residenceType;
      isOfficeSelected = true;

      blockController.text = data[0];
      streetController.text = data[1];
      wayController.text = data[2];
      bldgController.text = data[3];
      flooorController.text = data[4];
      officeController.text = data[5];
      addInfoController.text = data[6];
    }
  }

  Future<void> sendpayment() async {
    Map<String, String> jsonbody = {
      "userid": Constants.user_id,
      "name": _name.text + ' ',
      "phone": _mobile.text + " ",
      "governorate": governorateValue + " ",
      "state": _Address.text + _addressFromGoogle.text,
      "house_no": _house.text + ' ',
      "address_type": addressType,
      "block": blockController.text.isEmpty ? "" : blockController.text + " ",
      "street":
          streetController.text.isEmpty ? "" : streetController.text + " ",
      "way": wayController.text.isEmpty ? "" : wayController.text + " ",
      "building": bldgController.text.isEmpty ? "" : bldgController.text + " ",
      "floor": flooorController.text.isEmpty ? "" : flooorController.text + " ",
      "apartment_no": apartmentController.text.isEmpty
          ? ""
          : apartmentController.text + " ",
      "office":
          officeController.text.isEmpty ? "" : officeController.text + " ",
      "additional_directions":
          addInfoController.text.isEmpty ? "" : addInfoController.text + " ",
    };
    var network = NewVendorApiService();
    String urls =
        "http://185.188.127.11/citycode_dev/public/index.php/saveaddress";
    var res = await network.postresponse(urls, jsonbody);
    var model = Adressmodel.fromJson(res);
    String stat = model.status.toString();
    //var nopopupcatID = widget.cat_id;

    // ignore: avoid_print
    print(stat);

    if (stat.contains("201")) {
      Fluttertoast.showToast(
          msg: " Succesfully Added ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
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

  List<ListAddress>? demolists = [];
  Future<void> getadressdata() async {
    String url =
        "http://185.188.127.11/citycode_dev/public/index.php/getaddress?userid=" +
            Constants.user_id;
    var network = NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = GetAddressModel.fromJson(res);

    setState(() {
      demolists = vlist.listAddress;
    });

    print("" + res!.toString());
  }

  Future<void> DeleteApi(var id) async {
    Map<String, String> jsonbody = {
      "userid": Constants.user_id,
      "add_id": id,
    };
    var network = NewVendorApiService();
    String urls =
        "http://185.188.127.11/citycode_dev/public/index.php/deleteaddress";
    var res = await network.postresponse(urls, jsonbody);
    //var model = Adressmodel.fromJson(res);
    // String stat = model.status.toString();
    //var nopopupcatID = widget.cat_id;
    getadressdata();
    Fluttertoast.showToast(
        msg: " Succesfully Deleted ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

    print("" + res!.toString());
  }

  Future<void> UpadateApi(var id) async {
    Map<String, String> jsonbody = {
      "userid": Constants.user_id,
      "add_id": id,
      "name": _name.text,
      // "governate": governorateValue,
      "state": _Address.text,
      "phone": _mobile.text,
      "house_no": _house.text,
      "address_type": addressType,
      "block": blockController.text,
      "street": streetController.text,
      "way": wayController.text,
      "building": bldgController.text,
      "floor": flooorController.text,
      "apartment_no": apartmentController.text,
      "office": officeController.text,
      "additional_directions": addInfoController.text,
    };
    var network = NewVendorApiService();
    String urls =
        "http://185.188.127.11/citycode_dev/public/index.php/updateaddress";
    var res = await network.postresponse(urls, jsonbody);
    //var model = Adressmodel.fromJson(res);
    // String stat = model.status.toString();
    //var nopopupcatID = widget.cat_id;
    getadressdata();
    Fluttertoast.showToast(
        msg: " Succesfully Updated ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

    print("" + res!.toString());
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

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
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

  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;
        return LatLng(latitude, longitude);
      }
    } catch (e) {
      print('Error retrieving coordinates: $e');
    }
    return null;
  }

  Future<void> _getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
    });

    // Get the address from the current position
    _getAddressFromLatLng(_currentPosition!);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';

        // Geocode the current address and update the map
        getCoordinatesFromAddress(_currentAddress).then((LatLng coordinates) {
          if (coordinates != null) {
            mapController!.moveCamera(CameraUpdate.newLatLng(coordinates));
          } else {
            // Handle case when the address is not valid
            print('Invalid address');
          }
        } as FutureOr Function(LatLng? value));
      });
    }
  }

  List<Placemark> placemarks = [];
  Future<void> current_Location() async {
    final pref = await SharedPreferences.getInstance();
    if (cameraPosition != null) {
      placemarks = await placemarkFromCoordinates(
          cameraPosition!.target.latitude, cameraPosition!.target.longitude);
    }

    _getCurrentPosition();
    Position position = await _determineposition();

    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 14)));
    markers.clear();

    markers.add(
      Marker(
        markerId: const MarkerId("home"),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        infoWindow: InfoWindow(title: _currentAddress),
        draggable: true,
      ),
    );
    pref.setDouble('latitude', position.latitude);
    pref.setDouble('longitude', position.longitude);
  }

  @override
  void initState() {
    getMblno();
    current_Location();
    // sendpayment();
    nationalList = _getNationality();
    nationalList.then((value) => {
          if (value.countryList!.isNotEmpty)
            {
              for (int i = 0; i < value.countryList!.length; i++)
                {
                  nationalityList.add(value.countryList![i].countryEnName!),
                  if (value.countryList![i].countryEnName! == "Oman")
                    {nationality_id = value.countryList![i].countryId!},
                  nationalityModelList?.add(value.countryList![i])
                }
            },
          stateList = _getState(),
          stateList.then((value) => {
                if (value.stateList!.isNotEmpty)
                  {
                    for (int i = 0; i < value.stateList!.length; i++)
                      {
                        if (Constants.language == "en")
                          {
                            setState(() {
                              governorateList
                                  .add(value.stateList![i].stateName!);
                              governorateModelList?.add(value.stateList![i]);
                            })
                          }
                        else
                          {
                            setState(() {
                              governorateList
                                  .add(value.stateList![i].arbStateName!);
                              governorateModelList?.add(value.stateList![i]);
                            })
                          }
                      }
                  },
                for (int i = 0; i < governorateModelList!.length; i++)
                  {
                    if (governorateValue ==
                            governorateModelList![i].stateName ||
                        governorateValue ==
                            governorateModelList![i].arbStateName)
                      {
                        state_id = governorateModelList![i].stateId!,
                      }
                  },
                city_List = _getCity(state_id),
                city_List.then((value) => {
                      if (value.cityList!.isNotEmpty)
                        {
                          for (int i = 0; i < value.cityList!.length; i++)
                            {
                              if (Constants.language == "en")
                                {
                                  setState(() {
                                    cityList.add(value.cityList![i].cityName!);
                                  })
                                }
                              else
                                {
                                  setState(() {
                                    cityList
                                        .add(value.cityList![i].cityArbName!);
                                  })
                                }
                            }
                        }
                    }),
              }),
        });

    super.initState();
  }

  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  // LatLng startLocation = LatLng(27.6602292, 85.308027);
  static CameraPosition startLocation =
      const CameraPosition(target: LatLng(19.2785471, 72.8796206), zoom: 14);

  String location = "Location Name:";
  @override
  setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  dispose() {
    blockController.dispose();
    streetController.dispose();
    mapController!.dispose();
    wayController.dispose();
    addInfoController.dispose();
    flooorController.dispose();
    officeController.dispose();
    _house.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: ElevatedButton(
            onPressed: () async {
              if (_name.text.isNotEmpty) {
                if (_dropDownValue != null) {
                  if (_dropDownValue == 'House' &&
                      _formKey.currentState!.validate()) {
                    widget.isEditClicked ? null : sendpayment();
                    widget.isEditClicked ? UpadateApi(widget.tempindex) : null;

                    locationScreen(context);
                  } else if (_dropDownValue == 'Apartment' &&
                      _formKey1.currentState!.validate()) {
                    widget.isEditClicked ? null : sendpayment();
                    widget.isEditClicked ? UpadateApi(widget.tempindex) : null;

                    locationScreen(context);
                  } else if (_dropDownValue == 'Office' &&
                      _formKey2.currentState!.validate()) {
                    widget.isEditClicked ? null : sendpayment();
                    widget.isEditClicked ? UpadateApi(widget.tempindex) : null;

                    locationScreen(context);
                  }
                } else {
                  _alertDialog("Select Location First");
                }
              } else {
                _alertDialog("Location name can't be empty");
              }
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
          backgroundColor: const Color(0xFFF2CC0F),
          title: const Text(
            "Select Address",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.delete_solid),
              iconSize: 20,
              color: Colors.black,
              onPressed: () {
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
                                  ? 'Are you sure you want to delete this Address ?'
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
                            if (widget.tempindex == "default") {
                              _alertDialog("This is  Default Address");
                            } else {
                              DeleteApi(widget.tempindex);
                              setState(() {
                                getadressdata();
                              });
                            }

                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
                width: MediaQuery.of(context)
                    .size
                    .width, // or use fixed size like 200
                height: MediaQuery.of(context).size.height * 0.292,
                child: Stack(children: [
                  GoogleMap(
                    //Map widget from google_maps_flutter package
                    zoomGesturesEnabled: true, //enable Zoom in, out on map
                    initialCameraPosition: startLocation,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true, //map type
                    onMapCreated: (controller) async {
                      //method called when map is created
                      //  List<Placemark> placemarks = await placemarkFromCoordinates(cameraPosition!.target.latitude, cameraPosition!.target.longitude);
                      googleMapController = controller;
                      Position position = await _determineposition();

                      googleMapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target:
                                  LatLng(position.latitude, position.longitude),
                              zoom: 14)));
                      _getCurrentPosition();
                      // setState(() {
                      //   mapController = controller;
                      //   // _mobile.text = Constants.numberOfusers;
                      //   widget.isEditClicked
                      //       ? _name.text = Constants.nameOfusers
                      //       : _name.text = '';
                      //   // widget.isEditClicked
                      //   //     ? _house.text = Constants.housenoOfusers
                      //   //     : _house.text = '';
                      //   widget.isEditClicked
                      //       ? _Address.text = Constants.adressOfusers
                      //       : _Address.text = '';
                      //   location =
                      //       placemarks.first.administrativeArea.toString() +
                      //           ", " +
                      //           placemarks.first.street.toString() +
                      //           "," +
                      //           placemarks.first.locality.toString() +
                      //           "," +
                      //           placemarks.first.subLocality.toString() +
                      //           "," +
                      //           placemarks.first.name.toString() +
                      //           "," +
                      //           placemarks.first.postalCode.toString();
                      //   // var lac = placemarks.first.name.toString();

                      //   // widget.isEditClicked
                      //   //     ? _Address.text = location.toString()
                      //   //     : _Address.text = '';
                      // });
                      setState(() {
                        mapController = controller;
                        widget.isEditClicked
                            ? _name.text = Constants.nameOfusers
                            : _name.text = '';
                        widget.isEditClicked
                            ? _Address.text = Constants.adressOfusers
                            : _Address.text = '';

                        if (placemarks.isNotEmpty) {
                          location =
                              '${placemarks.first.administrativeArea}, ${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.subLocality}, ${placemarks.first.name}, ${placemarks.first.postalCode}';
                        } else {
                          // Handle case when placemarks list is empty
                          location = 'Unknown Location';
                        }

                        // Rest of your code...

                        // widget.isEditClicked
                        //     ? _Address.text = location.toString()
                        //     : _Address.text = '';
                      });
                    },
                    onCameraMove: (CameraPosition cameraPositiona) {
                      cameraPosition = cameraPositiona; //when map is dragging
                    },
                    onCameraIdle: () async {
                      final pref = await SharedPreferences.getInstance();
                      //when map drag stops
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              cameraPosition!.target.latitude,
                              cameraPosition!.target.longitude);
                      setState(() {
                        //get place name from lat and lang
                        var location = placemarks.first.name.toString() +
                            ", " +
                            placemarks.first.locality.toString() +
                            ", " +
                            placemarks.first.administrativeArea.toString();
                        pref.setDouble(
                            'latitude', cameraPosition?.target.latitude ?? 0.0);
                        pref.setDouble('longitude',
                            cameraPosition?.target.longitude ?? 0.0);

                        _addressFromGoogle.text = location.toString();
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
                ])),
            Expanded(
              // height: MediaQuery.of(context).size.height * 0.52,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      width: width,
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 10, right: 10, bottom: 20),
                      child: const Text(
                        "Enter Address",
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                      child: TextFormField(
                        key: _formKey3,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Location Nick Name';
                          }

                          return null;
                        },
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        controller: _name,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          // hintText: 'Email / Mobile No.',
                          labelText: 'Location Nick Name',
                          isDense: true,
                        ),
                        onChanged: (text) {},
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 2.0),
                          // labelText: widget.text,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child: DropdownButton(
                          // key: _formKey,

                          hint: _dropDownValue == null
                              ? const Text(
                                  "Select Location",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  _dropDownValue.toString(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                          isExpanded: true,
                          iconSize: 30.0,
                          style: const TextStyle(color: Colors.black),
                          items: residentialList.map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            addressType = _dropDownValue = val as String;

                            if (val == residentialList[0]) {
                              isHouseSelected = true;
                              isOfficeSelected = false;
                              isAptmntSelected = false;
                              // _formKey.currentState!.reset();
                            } else if (val == residentialList[1]) {
                              isAptmntSelected = true;
                              isHouseSelected = false;
                              isOfficeSelected = false;
                              // _formKey.currentState!.reset();
                            } else {
                              // _formKey.currentState!.reset();

                              isOfficeSelected = true;
                              isHouseSelected = false;
                              isAptmntSelected = false;
                            }

                            setState(() {});
                          },
                        ),
                      ),
                    ),

                    //! When House is Selected
                    Visibility(
                      visible: isHouseSelected,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            textFieldMisc(
                                controller: blockController,
                                labelText: 'Block'),
                            textFieldMisc(
                                controller: streetController,
                                labelText: 'Street'),
                            textFieldMisc1(
                                controller: wayController,
                                labelText: 'Way (optional)'),
                            textFieldMisc(
                                controller: _house, labelText: 'House'),
                            textFieldMisc1(
                                controller: addInfoController,
                                labelText: 'Additional Directions (optional)'),
                          ],
                        ),
                      ),
                    ),

                    //! When Apartment is selected
                    Visibility(
                      visible: isAptmntSelected,
                      child: Form(
                        key: _formKey1,
                        child: Column(
                          children: [
                            textFieldMisc1(
                              controller: blockController,
                              labelText: 'Block (optional)',
                            ),
                            textFieldMisc(
                              controller: streetController,
                              labelText: 'Street',
                            ),
                            textFieldMisc1(
                              controller: wayController,
                              labelText: 'Way (optional)',
                            ),
                            textFieldMisc(
                              controller: bldgController,
                              labelText: 'Building',
                            ),
                            textFieldMisc(
                              controller: flooorController,
                              labelText: 'Floor',
                            ),
                            textFieldMisc(
                              controller: apartmentController,
                              labelText: 'Apartment No.',
                            ),
                          ],
                        ),
                      ),
                    ),

                    //! When office is selected
                    Visibility(
                      visible: isOfficeSelected,
                      child: Form(
                        key: _formKey2,
                        child: Column(
                          children: [
                            textFieldMisc1(
                                controller: _house,
                                labelText: 'Block (optional)'),
                            textFieldMisc(
                                controller: streetController,
                                labelText: 'Street'),
                            textFieldMisc1(
                                controller: wayController,
                                labelText: 'Way (optional)'),
                            textFieldMisc(
                                controller: bldgController,
                                labelText: 'Building'),
                            textFieldMisc(
                                controller: flooorController,
                                labelText: 'Floor'),
                            textFieldMisc(
                                controller: officeController,
                                labelText: 'Office'),
                            textFieldMisc1(
                                controller: addInfoController,
                                labelText: 'Additional Directions (optional)'),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      margin:
                          const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                      child: TextField(
                        readOnly: true,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.streetAddress,
                        controller: _addressFromGoogle,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelStyle: const TextStyle(color: Colors.black),
                          // hintText: 'Email / Mobile No.',
                          labelText: "Address (Select From Map)",
                          isDense: true,
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                      child: TextField(
                        // readOnly: true,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.phone,
                        controller: _mobile,
                        maxLines: 1,
                        maxLength: 8,
                        onChanged: (value) {
                          if (value.length == 8) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelStyle: const TextStyle(color: Colors.black),
                          // hintText: 'Email / Mobile No.',
                          labelText: 'Mobile No',
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<dynamic> locationScreen(BuildContext context) {
    return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => locationscreen(
                  name: _name.text,
                  state: _Address.text + "," + _house.text,
                  mobile: _mobile.text,
                  name1: '',
                  mobile2: '',
                  state2: "",
                  vat: widget.vat,
                  discount: widget.discount,
                  actuaprice: widget.actuaprice,
                  image: widget.image,
                  totalprice: widget.totalprice,
                  productname: widget.productname,
                  demo: widget.demoadress,
                  quantity: '',
                  totalpoints: '',
                  dilivery: '',
                  itemdiscount: '',
                  productid: '',
                  mobilecost: '',
                  mobilediscouunt: '',
                  mobtotal: '',
                  del: '',
                  type: '1',
                )));
  }

  Container textFieldMisc(
      {required String labelText, required TextEditingController controller}) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Enter Your $labelText';
          }

          return null;
        },
        cursorColor: Colors.black,
        keyboardType: TextInputType.streetAddress,
        controller: controller,
        maxLines: 1,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelStyle: const TextStyle(color: Colors.black),
          // hintText: 'Email / Mobile No.',
          labelText: labelText,
          isDense: true,
        ),
      ),
    );
  }

  Container textFieldMisc1(
      {required String labelText, required TextEditingController controller}) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        cursorColor: Colors.black,
        keyboardType: TextInputType.streetAddress,
        controller: controller,
        maxLines: 1,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelStyle: const TextStyle(color: Colors.black),
          // hintText: 'Email / Mobile No.',
          labelText: labelText,
          isDense: true,
        ),
      ),
    );
  }
}
