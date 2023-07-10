// ignore_for_file: unnecessary_import, avoid_print, unused_local_variable, prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'dart:ui';

import 'package:city_code/models/order_model.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kYellow = Color(0xFFF2CC0F);
const kYellowFaded = Color(0xFFE6D997);

class Network {
  showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  showToast(
      {required String msg,
      required Color bgColor,
      required Color txtColor,
      required ToastGravity toastGravity}) {
    Fluttertoast.showToast(
        gravity: toastGravity,
        msg: msg,
        backgroundColor: bgColor,
        textColor: txtColor);
  }

  appVersion(String userid) async {
    final pref = await SharedPreferences.getInstance();
    final version = pref.getString("version");

    final url = Uri.parse('http://cp.citycode.om/public/index.php/appversion');
    if (version != null) {
      final response =
          await http.post(url, body: {"userid": userid, "version_no": version});
      if (response.statusCode == 200) {
        print('app version sent successfully');
      } else {
        throw Exception("Something went wrong");
      }
    }
  }

  Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var model, manufacturer, os, version;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      model = androidInfo.model;
      manufacturer = androidInfo.manufacturer;
      version = androidInfo.version;
      os = "Android_" + version.toString();
    } else {
      IosDeviceInfo iosDevice = await deviceInfo.iosInfo;
      model = iosDevice.name;
      manufacturer = iosDevice.model;
      version = iosDevice.systemVersion;
      os = "IOS_" + version;
    }
  }

  Future<void> getVersion() async {
    final pref = await SharedPreferences.getInstance();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final version = packageInfo.version;
    pref.setString("version", version.toString());
  }

  // Future<OrderModel?> orderReceived(String companyID, String branchID) async {
  //   OrderModel? orderData;
  //   final url = Uri.parse('http://185.188.127.11/public/index.php/order_list1');
  //   final response = await http.post(
  //     url,
  //     body: {"company_id": companyID, "branch_id": branchID},
  //   );

  //   if (response.statusCode == 201) {
  //     final jsonResponse = json.decode(response.body);
  //     orderData = orderModelFromJson(jsonResponse);
  //   } else {
  //     print("Response status code: ${response.statusCode}");
  //     print("Response body: ${response.body}");
  //     throw Exception("Something went wrong");
  //   }

  //   return orderData;
  // }

  Future<OrderModel?> orderReceived(String companyID, String branchID) async {
    OrderModel? orderData;
    final url = Uri.parse('http://185.188.127.11/public/index.php/order_list1');
    final response = await http.post(
      url,
      body: {"company_id": companyID, "branch_id": branchID},
    );

    if (response.statusCode == 201) {
      orderData = orderModelFromJson(response.body);
    } else {
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception("Something went wrong");
    }

    return orderData;
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    // Prepare the request body
    final body = {'order_id': orderId, 'order_status': status};

    // Make the API call
    final response = await http.post(
      Uri.parse('http://example.com/api/update-order-status'),
      body: body,
    );

    // Handle the response
    if (response.statusCode == 201) {
      // Update successful, handle the response message if needed
      final responseBody = json.decode(response.body);
      final successMessage = responseBody['message'];
      Fluttertoast.showToast(
        msg: successMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return true;
    } else {
      // Update failed, handle the error if needed
      const errorMessage = 'Failed to update order status.';
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return false;
    }
  }
// Future<OrderModel?> orderReceived(String companyID, String branchID) async {
//   OrderModel? orderData;
//   final url = Uri.parse('http://185.188.127.11/public/index.php/order_list1');
//   final response = await http.post(
//     url,
//     body: {"company_id": companyID, "branch_id": "129"},
//   );

//   if (response.statusCode == 201) {
//     orderData = orderModelFromJson(response.body);
//   } else {
//     print("Response status code: ${response.statusCode}");
//     print("Response body: ${response.body}");
//     throw Exception("Something went wrong");
//   }

//   return orderData;
// }

  static void animatedDialog(
      {required BuildContext context,
      required String title,
      required String content}) {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "",
      context: context,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1).animate(anim1),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1).animate(anim1),
            child: AlertDialog(
                clipBehavior: Clip.hardEdge,
                title: Center(child: Text(title)),
                content: Center(child: Text(content)),
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none)),
          ),
        );
      },
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  final dynamic data;

  FadeRoute({this.data, required this.page})
      : super(
            // Set the pageBuilder property to build the second page.
            pageBuilder: (context, animation, secondaryAnimation) => page,
            // Define the animation that will be used to transition between the pages.
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1).animate(animation),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            settings: data);
}
