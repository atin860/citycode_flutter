// ignore_for_file: must_be_immutable

import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatefulWidget {
  String title, url;

  WebViewScreen(this.title, this.url, {Key? key}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF2CC0F),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.black,
              fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont"),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Route newRoute =
                  MaterialPageRoute(builder: (context) => HomeScreen("0", ""));
              Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
            },
            icon: const Icon(CupertinoIcons.home),
            color: Colors.black,
          ),
        ],
      ),
      body: SafeArea(
        child: InAppWebView(
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;

            if (![
              "http",
              "https",
              "file",
              "chrome",
              "data",
              "javascript",
              "about"
            ].contains(uri.scheme)) {}

            return NavigationActionPolicy.ALLOW;
          },
          initialUrlRequest: URLRequest(
            url: Uri.parse(widget.url.isNotEmpty
                ? widget.url
                : "https://instagram.com/citycode?utm_medium=copy_link"),
          ),
          initialOptions: InAppWebViewGroupOptions(
            android: AndroidInAppWebViewOptions(
              safeBrowsingEnabled: false,
              useWideViewPort: false,
            ),
            ios: IOSInAppWebViewOptions(
              enableViewportScale: true,
            ),
          ),
        ),
      ),
    );
  }
}
