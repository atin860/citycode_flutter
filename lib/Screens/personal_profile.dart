// ignore_for_file: non_constant_identifier_names, unnecessary_cast

import 'dart:convert';
import 'dart:io';

import 'package:city_code/models/user_details_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class PersonalProfileScreen extends StatefulWidget {
  const PersonalProfileScreen({Key? key}) : super(key: key);

  @override
  _PersonalProfileScreenState createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  bool _isLoading = true;
  String photoURL = "";
  late Future<User_details_model> userDetails = getUserDetails();
  File _userImage = File("");

  TextEditingController name_controller = TextEditingController();
  TextEditingController gender_controller = TextEditingController();
  TextEditingController nationality_controller = TextEditingController();
  TextEditingController governorate_controller = TextEditingController();
  TextEditingController state_controller = TextEditingController();
  TextEditingController language_controller = TextEditingController();
  TextEditingController mobile_controller = TextEditingController();

  Future<User_details_model> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("nameofuser", name_controller.text);

    SharedPreferences mob = await SharedPreferences.getInstance();

    mob.setString("numberr", mobile_controller.text);
    SharedPreferences add = await SharedPreferences.getInstance();
    add.setString("userAddress", nationality_controller.text);
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
  }

  Future<void> uploadImage(BuildContext context) async {
    String mimeType = "";
    if (_userImage.existsSync()) {
      mimeType = mime(_userImage.path.split("/").last) ?? "image/jpg";
    }
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "http://185.188.127.11/public/index.php/apiupdateprofileimage"));
    request.fields['userid'] = Constants.user_id;
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
      _alertDialog(Constants.language == "en"
          ? "Profile Updated Successfully"
          : "تم تحديث الملف الشخصي بنجاح");
    } else {
      _alertDialog(Constants.language == "en"
          ? "Failed to update profile"
          : "فشل في تحديث الملف الشخصي");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    userDetails.then((value) => {
          setState(() {
            photoURL = value.userurl! + value.userdetail![0].profile!;
            name_controller.text = value.userdetail![0].name!;
            gender_controller.text = Constants.language == "en"
                ? value.userdetail![0].gender!
                : value.userdetail![0].gender! == "Male" ||
                        value.userdetail![0].gender! == "Gender.Male"
                    ? "ذكر"
                    : "أنثى";
            nationality_controller.text = Constants.language == "en"
                ? value.userdetail![0].countryEnNationality!
                : value.userdetail![0].countryArNationality!;
            governorate_controller.text = Constants.language == "en"
                ? value.userdetail![0].stateName!
                : value.userdetail![0].arbStateName!;
            state_controller.text = Constants.language == "en"
                ? value.userdetail![0].cityName!
                : value.userdetail![0].cityArbName!;
            language_controller.text = Constants.language == "en"
                ? value.userdetail![0].language!
                : value.userdetail![0].language! == "english"
                    ? "إنجليزي"
                    : "عربى";
            mobile_controller.text = value.userdetail![0].mobile!;
            if (nationality_controller.text.isEmpty) {
              nationality_controller.text =
                  Constants.language == "en" ? "Oman" : "سلطنة عمان";
            }
            _isLoading = false;
          }),
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2CC0F),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          Constants.language == "en" ? "Personal Profile" : "الملف الشخصي",
          style: TextStyle(
            color: Colors.black,
            fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
          ),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: height * 0.76,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Center(
                            child: CircleAvatar(
                              radius: width * 0.14,
                              backgroundImage: photoURL.isNotEmpty
                                  ? NetworkImage(photoURL)
                                  : _userImage.path.isNotEmpty
                                      ? Image.file(
                                          _userImage,
                                          fit: BoxFit.cover,
                                        ).image
                                      : const AssetImage(
                                              "images/user_profile.png")
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
                                        padding: const EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Icon(
                                          CupertinoIcons.pencil,
                                          size: width * 0.02,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            name_controller.text,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                            ),
                            textAlign: Constants.language == "en"
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                        ),
                        Container(
                          width: width,
                          margin: const EdgeInsets.only(top: 10.0),
                          color: const Color(0xFFF2CC0F),
                          child: Center(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 10.0),
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, right: 12.0),
                                    child: Container(
                                      width: 85,
                                      height: 40,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15.0),
                                            bottomRight: Radius.circular(15.0)),
                                      ),
                                      child: Center(
                                          child: Text(
                                        Constants.city_code,
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                  Positioned(
                                    child: Container(
                                      width: 25,
                                      padding: const EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF2CC0F),
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          CupertinoIcons.star,
                                          color: Colors.black,
                                          size: 19.0,
                                        ),
                                      ),
                                    ),
                                    bottom: 24.0,
                                    left: 72.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Constants.language == "en"
                                        ? "Personal data"
                                        : "البيانات الشخصية",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont",
                                    ),
                                    textAlign: Constants.language == "en"
                                        ? TextAlign.left
                                        : TextAlign.right,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      name_controller.text,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black45,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                      ),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    color: Colors.black,
                                    height: 1.0,
                                    width: width,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      gender_controller.text,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black45,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                      ),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    color: Colors.black,
                                    height: 1.0,
                                    width: width,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      nationality_controller.text,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black45,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                      ),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    color: Colors.black,
                                    height: 1.0,
                                    width: width,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      governorate_controller.text,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black45,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                      ),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    color: Colors.black,
                                    height: 1.0,
                                    width: width,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      state_controller.text,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black45,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                      ),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    color: Colors.black,
                                    height: 1.0,
                                    width: width,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      language_controller.text,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black45,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                      ),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    color: Colors.black,
                                    height: 1.0,
                                    width: width,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      Constants.language == "en"
                                          ? "Contact information"
                                          : "معلومات الاتصال",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont",
                                      ),
                                      textAlign: Constants.language == "en"
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 5.0, left: 1.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "+968",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          Container(
                                            width: width * 0.77,
                                            margin: const EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            child: Text(
                                              mobile_controller.text,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Roboto",
                                                color: Colors.black45,
                                              ),
                                              textAlign:
                                                  Constants.language == "en"
                                                      ? TextAlign.left
                                                      : TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    color: Colors.black,
                                    height: 1.0,
                                    width: width,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 0, left: 5.0, right: 5.0, bottom: 0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_userImage.path.isNotEmpty) {
                          uploadImage(context);
                        } else {
                          _alertDialog(Constants.language == "en"
                              ? "Please select image"
                              : "الرجاء تحديد الصورة");
                        }
                      },
                      child: Text(
                        Constants.language == "en" ? "Save" : "حفظ",
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
                        fixedSize:
                            Size(MediaQuery.of(context).size.width, 40.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
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
      photoURL = "";
      _userImage = (image == null ? null : File(image.path))!;
    });
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      photoURL = "";
      _userImage = (image == null ? null : File(image.path))!;
    });
  }
}
