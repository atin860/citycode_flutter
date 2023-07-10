// ignore_for_file: camel_case_types, unused_field, non_constant_identifier_names, unnecessary_new, avoid_print, avoid_unnecessary_containers

import 'dart:convert';

import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/user_details_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class demo extends StatefulWidget {
  const demo({Key? key}) : super(key: key);

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  List<Userdetail>? userdetail = [];

  bool _isLoading = true;
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

  List<Userdetail>? demolist = [];
  Future<void> getdata() async {
    String url =
        "http://185.188.127.11/public/index.php/ApiUsers/" + Constants.user_id;
    var network = new NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = User_details_model.fromJson(res);

    setState(() {
      demolist = vlist.userdetail!;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(demolist![index].name.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16.0)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(demolist![index].name.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 16.0)),
                  Text(demolist![index].name.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 16.0)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    getdata();
    //getUserDetails();
    super.initState();
  }
}
