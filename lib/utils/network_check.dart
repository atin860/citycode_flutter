// ignore_for_file: avoid_print

import 'dart:io';

class NetworkCheck {
  Future<bool> isNetworkConnected() async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup("www.google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
        print('connected');
      }
    } on SocketException catch (_) {
      isConnected = false;
      print('not connected');
    }
    return isConnected;
  }
}
