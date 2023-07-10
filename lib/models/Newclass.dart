// ignore_for_file: non_constant_identifier_names, unused_import, file_names, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../AppException.dart';

class NewVendorApiService {
  Future getresponse(String url) async {
    dynamic RegisterVendirCatogoryResponse;
    try {
      final response = await http.get(Uri.parse(
        url,
      ));
      RegisterVendirCatogoryResponse = jsonDecode(response.body);
      print("Api ok " + response.toString());
    } catch (e) {
      print("Api Error" + e.toString());
    }
    return RegisterVendirCatogoryResponse;
  }

  Future postresponse(String urls, Map<String, dynamic> jsonbody) async {
    dynamic RegisterVendirCatogoryResponse1;
    try {
      final response = await http.post(Uri.parse(urls), body: jsonbody);
      RegisterVendirCatogoryResponse1 = jsonDecode(response.body);
      print("Api ok " + response.toString());
    } catch (e) {
      print("Api Error" + e.toString());
    }
    return RegisterVendirCatogoryResponse1;
  }
}
