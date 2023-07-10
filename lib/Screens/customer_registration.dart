// ignore_for_file: prefer_final_fields, non_constant_identifier_names, constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, unused_field, unused_local_variable, unnecessary_null_comparison, unnecessary_cast, avoid_unnecessary_containers, must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:city_code/Screens/TermsCondition.dart';
import 'package:city_code/Screens/confirmation_screen.dart';
import 'package:city_code/Screens/customer_login_screen.dart';
import 'package:city_code/models/city_model.dart';
import 'package:city_code/models/nationality_model.dart';
import 'package:city_code/models/registration_model.dart';
import 'package:city_code/models/state_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerRegistration extends StatefulWidget {
  String mobileNo;

  CustomerRegistration({Key? key, required this.mobileNo}) : super(key: key);

  @override
  _CustomerRegistrationState createState() => _CustomerRegistrationState();
}

enum Gender { Male, Female }

class _CustomerRegistrationState extends State<CustomerRegistration> {
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();

  bool accept = true;
  String photoURL = "";
  File _userImage = File("");
  String state_id = "";
  String nationality_id = "";
  String city_id = "";
  bool _isRegistering = false;
  bool isTextFieldTapped = false;

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

  late String longitude = '00.00000';
  late String latitude = '00.00000';
  late LocationPermission permission;
  late bool serviceEnabled = false;
  NetworkCheck networkCheck = NetworkCheck();

  Future<Nationality_model> _getNationality() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/ApiFilters?language='));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
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

  Future<State_model> _getState() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/ApiFilters?language='));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
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

  Future<City_model> _getCity(String state_id) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/getcities?state_id=' +
              state_id));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
          return City_model.fromJson(jsonDecode(response.body));
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

  Future<void> _getLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      } else {
        await Geolocator.openLocationSettings();
      }
    } else {
      permission = await Geolocator.requestPermission();
    }
  }

  Future<Registration_model> _registration(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      var model, manufacturer, os, version;
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        model = androidInfo.model;
        manufacturer = androidInfo.manufacturer;
        version = androidInfo.version;
        os = "Android_" + version.toString();
        pref.setString("version", version.toString());
      } else {
        IosDeviceInfo iosDevice = await deviceInfo.iosInfo;
        model = iosDevice.name;
        manufacturer = iosDevice.model;
        version = iosDevice.systemVersion;
        os = "IOS_" + version;
        pref.setString("version", version.toString());
      }

      final body = {
        "name": _fullNameController.text,
        "familyname": _fullNameController.text,
        "email": "",
        "mobile": mobileNoController.text,
        "date_of_birth": "",
        "gender": _selectedGender != null
            ? _selectedGender == Gender.Male
                ? "Male"
                : "Female"
            : "Male",
        "language": Constants.language,
        "nationality": nationality_id,
        "governorate": state_id,
        "cityid": city_id,
        "device": manufacturer,
        "operating_system": os,
        "phone_model": model,
        "latitude": latitude,
        "longitude": longitude,
        "location": ""
      };
      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/ApiUsers'),
        body: body,
      );

      if (response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("name", _fullNameController.text);

        SharedPreferences mob = await SharedPreferences.getInstance();
        mob.setString("number", mobileNoController.text);
        SharedPreferences add = await SharedPreferences.getInstance();
        add.setString("userAddress", nationalityValue);

        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
          if (_userImage.path.isNotEmpty) {
            String user_id = response_server["userdetail"]["id"].toString();
            uploadImage(user_id, context);
          } else {
            setState(() {
              _isLoading = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConfirmationScreen(
                  mobileNoController.text,
                  "customerLogin",
                  "",
                  false,
                ),
              ),
            );
          }
          return Registration_model.fromJson(jsonDecode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });
          _alertDialog(
            Constants.language == "en"
                ? "Registration Failed"
                : "فشل في التسجيل",
          );
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          _alertDialog(
            Constants.language == "en"
                ? "Number has registered already"
                : "رقم الهاتف مسجل من قبل",
          );
        } else {
          _alertDialog(
            Constants.language == "en"
                ? "Registration Failed"
                : "فشل في التسجيل",
          );
        }
        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(
        Constants.language == "en"
            ? "Please connect to the internet"
            : "الرجاء الاتصال بالإنترنت",
      );
      throw Exception('Failed to load album');
    }
  }

  Future<void> uploadImage(String id, BuildContext context) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      String mimeType = "";
      if (_userImage.existsSync()) {
        mimeType = mime(_userImage.path.split("/").last) ?? "image/jpg";
      }
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              "http://185.188.127.11/public/index.php/apiupdateprofileimage"));
      request.fields['userid'] = id;
      request.files.add(http.MultipartFile(
        'profileimage',
        _userImage.readAsBytes().asStream(),
        _userImage.lengthSync(),
        filename: _userImage.path.split("/").last,
        contentType: MediaType("image", mimeType.split("/").last),
      ));
      var res = await request.send();

      if (kDebugMode) {
        print(res.stream.transform(utf8.decoder));
      }
      if (res.statusCode == 201) {
        print("successfull");
      }
      setState(() {
        _isLoading = false;
      });
      bool next = await _alertShow(context);
      if (next) {
        Route newRoute =
            MaterialPageRoute(builder: (context) => const CustomerLogin());
        Navigator.pushReplacement(context, newRoute);
      }
    } else {
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
    }
  }

  final googleSignIn = GoogleSignIn();
  // final authResult =  TwitterLogin();
  GoogleSignInAccount? _user;

  Future googleLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    final googleUser = await googleSignIn.signIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      user = userCredential.user!;
      String name = userCredential.user!.displayName.toString();
      String email = userCredential.user!.email.toString();
      String uid = userCredential.user!.uid.toString();
      String phone = userCredential.user!.phoneNumber.toString();

      print("user:::::::" + user.toString());
      print("displayemail:::: " + email);
      print("displayname:::: " + name);
      print("uid:::: " + uid);
      // print("token:::"+token!);
      print("phone::" + phone);

      if (user != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CustomerLogin()));
        /* setState(() {
          isLoading = true;
        });
        FirebaseMessaging.instance.getToken().then((value) {
          setState(() {
            token = value;
            callsocial(token!,name,email,uid);
          });
        });*/
      }
    } catch (e) {
      print(e);
    }
    /*   GoogleAuthProvider googleProvider = GoogleAuthProvider();
     return await FirebaseAuth.instance.signInWithPopup(googleProvider).then((value) {
       print("value:::"+value.user.toString());
     });*/

    await FirebaseAuth.instance.signInWithCredential(credential);
/*    notifyListeners();*/
  }

  Future twitterLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    final googleUser = await googleSignIn.signIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      user = userCredential.user!;
      String name = userCredential.user!.displayName.toString();
      String email = userCredential.user!.email.toString();
      String uid = userCredential.user!.uid.toString();
      String phone = userCredential.user!.phoneNumber.toString();

      print("user:::::::" + user.toString());
      print("displayemail:::: " + email);
      print("displayname:::: " + name);
      print("uid:::: " + uid);
      // print("token:::"+token!);
      print("phone::" + phone);

      if (user != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CustomerLogin()));
        /* setState(() {
          isLoading = true;
        });
        FirebaseMessaging.instance.getToken().then((value) {
          setState(() {
            token = value;
            callsocial(token!,name,email,uid);
          });
        });*/
      }
    } catch (e) {
      print(e);
    }
    /*   GoogleAuthProvider googleProvider = GoogleAuthProvider();
     return await FirebaseAuth.instance.signInWithPopup(googleProvider).then((value) {
       print("value:::"+value.user.toString());
     });*/

    await FirebaseAuth.instance.signInWithCredential(credential);
/*    notifyListeners();*/
  }

  @override
  void initState() {
    widget.mobileNo;
    _selectedGender = Gender.Male;

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

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    _getLocation();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF2CC0F),
        title: Text(
          Constants.language == "en" ? "New Registration" : "تسجيل جديد",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
          ),
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
          child: Stack(
            children: [
              Container(
                width: width,
                margin: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: photoURL.isNotEmpty
                              ? NetworkImage(photoURL)
                              : _userImage.path.isNotEmpty
                                  ? Image.file(
                                      _userImage,
                                      fit: BoxFit.cover,
                                    ).image
                                  : const AssetImage("images/user_profile.png")
                                      as ImageProvider,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () {
                                    _showPicker(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.pencil,
                                      size: 18.0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: width,
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          Constants.language == "en"
                              ? "Personal Data"
                              : "البيانات الشخصية",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont",
                            fontSize: 16.0,
                          ),
                          textAlign: Constants.language == "en"
                              ? TextAlign.left
                              : TextAlign.right,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Directionality(
                            textDirection: Constants.language == "en"
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            child: TextField(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                              ),
                              controller: _fullNameController,
                              textDirection: Constants.language == "en"
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.visiblePassword,
                              onTap: () {
                                setState(() {
                                  isTextFieldTapped = true;
                                });
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 3.0,
                                  ),
                                ),
                                hintText: isTextFieldTapped
                                    ? ''
                                    : (Constants.language == "en"
                                        ? "Full Name"
                                        : " الاسم الكامل "),
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                ),
                                isDense: true,
                              ),
                              textAlign: Constants.language == "en"
                                  ? TextAlign.left
                                  : TextAlign.right,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width,
                        height: 1.0,
                        // color: Colors.black,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 7.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          // color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedGender == Gender.Male
                                    ? const Color(0xFFF2CC0F)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color: _selectedGender == Gender.Male
                                        ? Colors.yellow.shade500
                                        : Colors.yellow,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedGender = Gender.Male;
                                });
                              },
                              child: Text(
                                Constants.language == "en" ? "Male" : "ذكر",
                                style: TextStyle(
                                  color: _selectedGender == Gender.Male
                                      ? Colors.black
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _selectedGender == Gender.Female
                                        ? const Color(0xFFF2CC0F)
                                        : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color: _selectedGender == Gender.Female
                                        ? Colors.yellow.shade500
                                        : Colors.yellow,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedGender = Gender.Female;
                                });
                              },
                              child: Text(
                                Constants.language == "en" ? "Female" : "أنثى",
                                style: TextStyle(
                                  color: _selectedGender == Gender.Female
                                      ? Colors.black
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width,
                        height: 1.0,
                        // color: Colors.black,
                      ),
                      SizedBox(
                        width: width,
                        height: 60,
                        child: Container(
                          margin: const EdgeInsets.only(top: 7.0),
                          child: Directionality(
                            textDirection: Constants.language == "en"
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 3.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 12,
                                    right:
                                        12), // Adjust vertical padding as needed
                              ),
                              isDense: true,
                              isExpanded: true,
                              hint: Text(
                                Constants.language == "en"
                                    ? "Governorate"
                                    : "أختر المحافظة",
                                style: const TextStyle(fontSize: 14.0),
                              ),
                              value: governorateValue,
                              icon: const Icon(
                                CupertinoIcons.chevron_down,
                                color: Colors.black,
                              ),
                              iconSize: 20,
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                              onChanged: (String? data) {
                                setState(() {
                                  governorateValue = data!;
                                });
                                if (governorateValue != "Select Governorate" &&
                                    governorateValue != " أختر المحافظة") {
                                  for (int i = 0;
                                      i < governorateModelList!.length;
                                      i++) {
                                    if (governorateValue ==
                                            governorateModelList![i]
                                                .stateName ||
                                        governorateValue ==
                                            governorateModelList![i]
                                                .arbStateName) {
                                      state_id =
                                          governorateModelList![i].stateId!;
                                      break;
                                    }
                                  }
                                  city_List = _getCity(state_id);
                                  city_List.then((value) => {
                                        if (value.cityList!.isNotEmpty)
                                          {
                                            for (int i = 0;
                                                i < value.cityList!.length;
                                                i++)
                                              {
                                                if (Constants.language == "en")
                                                  {
                                                    setState(() {
                                                      cityList.add(value
                                                          .cityList![i]
                                                          .cityName!);
                                                    })
                                                  }
                                                else
                                                  {
                                                    setState(() {
                                                      cityList.add(value
                                                          .cityList![i]
                                                          .cityArbName!);
                                                    })
                                                  },
                                                cityModelList
                                                    ?.add(value.cityList![i])
                                              }
                                          }
                                      });
                                } else {
                                  state_id = "";
                                }
                              },
                              items: governorateList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      SizedBox(
                        height: 60,
                        width: width,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Directionality(
                            textDirection: Constants.language == "en"
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            child: GestureDetector(
                              onTap: () {
                                if (governorateValue == "Select Governorate" ||
                                    governorateValue == " أختر المحافظة") {
                                  _alertDialog(Constants.language == "en"
                                      ? "Select Governorate First"
                                      : "يرجى تحديد المحافظة أولا");
                                }
                              },
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 3.0,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 12,
                                      right:
                                          12), // Adjust vertical padding as needed
                                ),
                                isExpanded: true,
                                hint: Text(
                                  Constants.language == "en"
                                      ? "State"
                                      : "أختر الولاية",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black.withOpacity(
                                        0.6), // Adjust the opacity or change the color as desired
                                  ),
                                ),
                                value: cityValue,
                                icon: const Icon(
                                  CupertinoIcons.chevron_down,
                                  color: Colors.black,
                                ),
                                iconSize: 20,
                                elevation: 16,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: Constants.language == "en"
                                      ? "Roboto"
                                      : "GSSFont",
                                ),
                                onChanged: governorateValue ==
                                            "Select Governorate" ||
                                        governorateValue == "اختر محافظة"
                                    ? null
                                    : (String? data) {
                                        setState(() {
                                          cityValue = data!;
                                          if (cityValue != "Select State" ||
                                              cityValue == "اختر ولايه") {
                                            for (int i = 0;
                                                i < cityModelList!.length;
                                                i++) {
                                              if (cityValue ==
                                                      cityModelList![i]
                                                          .cityName ||
                                                  cityValue ==
                                                      cityModelList![i]
                                                          .cityArbName) {
                                                city_id =
                                                    cityModelList![i].cityId!;
                                                break;
                                              }
                                            }
                                          } else {
                                            state_id = "";
                                          }
                                        });
                                      },
                                items: cityList
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: width,
                        // height: 60,
                        child: Container(
                          width: width,
                          margin: const EdgeInsets.only(top: 10.0, bottom: 10),
                          child: Text(
                            Constants.language == "en"
                                ? "Contact Information"
                                : " معلومات الأتصال",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
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
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: SizedBox(
                          height: 60,
                          width: width,
                          child: Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.3),
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "+968",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(
                                        text: widget.mobileNo.isNotEmpty
                                            ? widget.mobileNo
                                            : null,
                                      ),
                                      keyboardType: TextInputType.phone,
                                      maxLines: 1,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: Constants.language == "en"
                                            ? 'Mobile Number'
                                            : "رقم الهاتف المحمول",
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          if (widget.mobileNo.isEmpty) {
                                            widget.mobileNo = ' ';
                                          }
                                        });
                                      },
                                      onChanged: (value) {
                                        if (value.length == 8) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        }
                                      },
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Container(
                      //   height: 1.0,
                      //   width: width,
                      //   color: Colors.black,
                      // ),

                      /*  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1.0,
                            width: 170,
                            color: Colors.black,
                          ),
                          Container(
                            child: Text("OR"),
                          ),
                          Container(
                            height: 1.0,
                            width: 170,
                            color: Colors.black,
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          GestureDetector(
                            onTap: (){
                              AuthService().signout();

                            },
                            child: Container(
                              child: Image(
                                width: 50,
                                image: AssetImage("images/Facebook.png"),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              googleLogin();
                              //AuthService().signINwihgoogle();

                            },
                            child: Container(
                              child: Image(
                                width: 50,
                                image: AssetImage("images/Googleimage.png"),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              AuthService().handleAuthState();

                            },
                            child: Container(
                              child: Image(
                                width: 50,
                                image: AssetImage("images/Twitter.png"),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              AuthService().handleAuthState();

                            },
                            child: Container(
                              child: Image(
                                width: 50,
                                image: AssetImage("images/instaphoto.png"),
                              ),
                            ),
                          ),
                        ],
                      ),*/
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Directionality(
                          textDirection: Constants.language == "en"
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          child: Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: const Color(0xFFF2CC0F),
                                value: accept,
                                onChanged: (value) {
                                  setState(() {
                                    accept = value ?? true;
                                  });
                                },
                              ),
                              Container(
                                width: 280.0,
                                margin: Constants.language == "en"
                                    ? const EdgeInsets.only(left: 10.0)
                                    : const EdgeInsets.only(right: 10.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: Constants.language == "en"
                                        ? "I agree to the "
                                        : "أوافق على",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                    children: [
                                      TextSpan(
                                        text: Constants.language == "en"
                                            ? "Terms, Conditions,and Policy "
                                            : " (شروط وأحكام وسياسة)",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            if (accept) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TermsAndConditionsScreen(),
                                                ),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: Constants.language == "en"
                                            ? "  of the Citycode"
                                            : " التطبيق",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_fullNameController.text.isNotEmpty) {
                              if (nationalityValue.isNotEmpty) {
                                if (governorateValue != "Select Governorate" &&
                                    governorateValue != "اختر محافظة") {
                                  if (cityValue != "Select State") {
                                    if (mobileNoController.text.isNotEmpty) {
                                      if (mobileNoController.text.length == 8) {
                                        if (accept) {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          _registration(context);
                                        } else {
                                          _alertDialog(Constants.language ==
                                                  "en"
                                              ? "Please accept the terms and conditions"
                                              : "الرجاء قبول الشروط والأحكام");
                                        }
                                      } else {
                                        _alertDialog(Constants.language == "en"
                                            ? "Please valid mobile number"
                                            : "الرجاء إدخال رقم هاتف محمول صحيح");
                                      }
                                    } else {
                                      _alertDialog(Constants.language == "en"
                                          ? "Please enter mobile number"
                                          : "الرجاء إدخال رقم الهاتف المحمول");
                                    }
                                  } else {
                                    _alertDialog(Constants.language == "en"
                                        ? "Please select State"
                                        : "الرجاء تحديد الولاية");
                                  }
                                } else {
                                  _alertDialog(Constants.language == "en"
                                      ? "Please select Governorate"
                                      : "الرجاء تحديد المحافظة");
                                }
                              } else {
                                _alertDialog(Constants.language == "en"
                                    ? "Please select Nationality"
                                    : "الرجاء تحديد الجنسية");
                              }
                            } else {
                              _alertDialog(Constants.language == "en"
                                  ? "Please enter full name"
                                  : "الرجاء إدخال الاسم الكامل");
                            }
                          },
                          child: Text(
                            Constants.language == "en"
                                ? "Register Now"
                                : "سجل الان",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontSize: 18.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF2CC0F),
                            elevation: 0.0,
                            textStyle: const TextStyle(color: Colors.black),
                            fixedSize:
                                Size(MediaQuery.of(context).size.width, 30.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _isLoading,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFF2CC0F),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _userImage = (image == null ? null : File(image.path))!;
    });
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _userImage = (image == null ? null : File(image.path))!;
    });
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

  Future<bool> _alertShow(BuildContext context) async {
    await CoolAlert.show(
      backgroundColor: const Color(0xFFF2CC0F),
      context: context,
      type: CoolAlertType.success,
      text: Constants.language == "en"
          ? "Registration Successful!"
          : "تم تسجيلك بنجاح",
      confirmBtnText: Constants.language == "en" ? "Continue" : "أستمرار",
      barrierDismissible: true,
      confirmBtnColor: const Color(0xFFF2CC0F),
      confirmBtnTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont"),
      onConfirmBtnTap: () {
        Navigator.pop(context); // Dismiss the current screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(
              mobileNoController.text,
              "customerLogin",
              "",
              false,
            ),
          ),
        );
      },
    );
    return true;
  }
}
