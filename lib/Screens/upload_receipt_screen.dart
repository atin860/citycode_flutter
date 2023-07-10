// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_final_fields, unused_field, unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:city_code/Screens/member_code_screen.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';

class UploadReceiptScreen extends StatefulWidget {
  String city_code, paid_amount, paid_points, order_id, company_image, vip_code;

  UploadReceiptScreen(this.city_code, this.paid_amount, this.paid_points,
      this.order_id, this.company_image, this.vip_code,
      {Key? key})
      : super(key: key);

  @override
  _UploadReceiptScreenState createState() => _UploadReceiptScreenState();
}

class _UploadReceiptScreenState extends State<UploadReceiptScreen> {
  TextEditingController invoice_Controller = TextEditingController();
  File _userImage = File("");
  NetworkCheck networkCheck = NetworkCheck();
  bool _isLoading = false, confirm_screen = false;

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    Route newRoute =
        MaterialPageRoute(builder: (contect) => const MemberCodeScreen());
    Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF2CC0F),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFF2CC0F),
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.arrow_left,
            ),
            color: Colors.black,
            onPressed: () {
              Route newRoute = MaterialPageRoute(
                  builder: (contect) => const MemberCodeScreen());
              Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
            },
          ),
          title: Text(
            Constants.company_name,
            style: TextStyle(
              fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Directionality(
              textDirection: Constants.language == "en"
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: Container(
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !confirm_screen,
                      child: Column(
                        children: [
                          const Image(
                            image: AssetImage("images/done.png"),
                            width: 90.0,
                            height: 90.0,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              Constants.language == "en"
                                  ? "Confirmation was successful \nBy the owner of the code"
                                  : "تم التأكيد بنجاح \n بواسطة صاحب الكود",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              widget.vip_code.isEmpty
                                  ? widget.city_code
                                  : widget.vip_code,
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.white),
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.paid_amount,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                  ),
                                  textAlign: Constants.language == "en"
                                      ? TextAlign.left
                                      : TextAlign.right,
                                ),
                                Text(
                                  Constants.language == "en"
                                      ? "Amount to be paid"
                                      : "المبلغ المستحق للدفع",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              Constants.language == "en"
                                  ? "Purchase invoice number"
                                  : "رقم فاتورة الشراء",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.only(top: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.white),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              controller: invoice_Controller,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: Constants.language == "en"
                                    ? "Enter Invoice Number"
                                    : "أكتب ملاحظة أو رقم الفاتورة",
                                hintStyle: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont"),
                              ),
                              textAlign: Constants.language == "en"
                                  ? TextAlign.left
                                  : TextAlign.right,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Constants.language == "en"
                                      ? "Upload Receipt"
                                      : "تحميل الإيصال",
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                _userImage.path.isNotEmpty
                                    ? Image.file(
                                        _userImage,
                                        fit: BoxFit.cover,
                                        width: 80.0,
                                        height: 80.0,
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          _showPicker(context);
                                        },
                                        icon: const Icon(
                                            CupertinoIcons.cloud_upload_fill),
                                        color: Colors.white,
                                        iconSize: 50.0,
                                      )
                              ],
                            ),
                          ),
                          Container(
                            width: width * 1.20,
                            height: 50.0,
                            margin: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (invoice_Controller.text.isNotEmpty) {
                                  if (_userImage.path.isNotEmpty) {
                                    bool isUpload = await uploadImage();
                                    if (isUpload) {
                                      setState(() {
                                        Route newRoute = MaterialPageRoute(
                                            builder: (context) =>
                                                const MemberCodeScreen());
                                        Navigator.pushAndRemoveUntil(context,
                                            newRoute, (route) => false);

                                        ///comenting below code and adding above code
                                        // confirm_screen = true;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      Route newRoute = MaterialPageRoute(
                                          builder: (context) =>
                                              const MemberCodeScreen());
                                      Navigator.pushAndRemoveUntil(
                                          context, newRoute, (route) => false);

                                      ///comenting below code and adding above code
                                      //confirm_screen = true;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    Route newRoute = MaterialPageRoute(
                                        builder: (context) =>
                                            const MemberCodeScreen());
                                    Navigator.pushAndRemoveUntil(
                                        context, newRoute, (route) => false);

                                    ///comenting below code and adding above code
                                    //confirm_screen = true;
                                  });
                                }
                              },
                              child: Text(
                                Constants.language == "en" ? "Done" : "حفظ",
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: confirm_screen,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              widget.vip_code.isEmpty
                                  ? widget.city_code
                                  : widget.vip_code,
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            alignment: Alignment.center,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              Constants.language == "en"
                                  ? "In the process of taking advantage of"
                                  : "في عملية الاستفادة من ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: CircleAvatar(
                              radius: 70.0,
                              backgroundImage:
                                  NetworkImage(widget.company_image),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              Constants.company_name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              Constants.branch_name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: const Image(
                              image: AssetImage("images/done.png"),
                              width: 70.0,
                              height: 70.0,
                            ),
                          ),
                          // Container(
                          //   margin: const EdgeInsets.only(top: 10.0),
                          //   child: Text(
                          //     Constants.language == "en" ? "Has been confirmed" : "في عمليه الاستفاده",
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 20.0,
                          //       fontWeight: FontWeight.bold,
                          //       fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                          //     ),
                          //     textAlign: TextAlign.center,
                          //   ),
                          // ),
                          Container(
                            width: width * 0.30,
                            height: 40.0,
                            margin: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                /* Route newRoute = MaterialPageRoute(builder: (context) => const MemberCodeScreen());
                                  Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);*/
                              },
                              child: Text(
                                Constants.language == "en" ? "Continue" : "حفظ",
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
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

  Future<bool> uploadImage() async {
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
      request.fields['order_id'] = widget.order_id;
      request.fields['receipt_no'] = invoice_Controller.text;
      request.files.add(http.MultipartFile(
        'receiptImage',
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
        _alertDialog(Constants.language == "en"
            ? "Receipt uploaded successfully"
            : "تم تحميل الإيصال بنجاح");
        return true;
      } else {
        _alertDialog(Constants.language == "en"
            ? "Unable to upload receipt"
            : "غير قادر على تحميل الإيصال");
        return false;
      }
    } else {
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      return false;
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
}
