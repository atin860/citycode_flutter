// ignore_for_file: unused_local_variable

import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'home_screen.dart';

class WhoWeAreScreen extends StatefulWidget {
  const WhoWeAreScreen({Key? key}) : super(key: key);

  @override
  _WhoWeAreScreenState createState() => _WhoWeAreScreenState();
}

class _WhoWeAreScreenState extends State<WhoWeAreScreen> {
  bool isApplication = false, terms = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2CC0F),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          color: Colors.black,
          onPressed: () {
            if (isApplication || terms) {
              setState(() {
                isApplication = false;
                terms = false;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          terms
              ? Constants.language == "en"
                  ? "Terms and conditions of the"
                  : "شروط وأحكام التطبيق"
              : isApplication
                  ? Constants.language == "en"
                      ? "Application Policy"
                      : "سياسة التطبيق"
                  : Constants.language == "en"
                      ? "Who are we"
                      : "من نحن",
          style: TextStyle(
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
          )
        ],
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: Constants.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: SizedBox(
            height: height,
            child: Column(
              children: [
                const Image(
                  image: AssetImage("images/app_icon.png"),
                ),
                Visibility(
                  visible: !isApplication && !terms,
                  child: Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0),
                      child: InAppWebView(
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
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
                          /*  url: Uri.parse(
                              isApplication ? Constants.language == "en"
                                  ? "http://165.22.219.135/codeapp/termdoc/privacypolicy-english.html"
                                  : "http://165.22.219.135/codeapp/termdoc/privacypolicy-arebic.html" :
                              Constants.language == "en"
                                  ? "http://165.22.219.135/codeapp/termdoc/whoarewe-english.html"
                                  : "http://165.22.219.135/codeapp/termdoc/whoarewe-arebic.html"),*/
                          url: Uri.parse(isApplication
                              ? Constants.language == "en"
                                  ? "http://cp.citycode.om/public/termdoc/privacypolicy-english.html"
                                  : "http://cp.citycode.om/public/termdoc/privacypolicy-arebic.html"
                              : Constants.language == "en"
                                  ? "http://cp.citycode.om//public/termdoc/whoarewe-english.html"
                                  : "http://cp.citycode.om//public/termdoc/whoarewe-arebic.html"),
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
                  ),
                ),
                Visibility(
                  visible: isApplication,
                  child: Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0),
                      child: InAppWebView(
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
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
                          url: Uri.parse(Constants.language == "en"
                              ? "http://cp.citycode.om/public/termdoc/privacypolicy-english.html"
                              : "http://cp.citycode.om/public/termdoc/privacypolicy-arebic.html"),
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
                  ),
                ),
                Visibility(
                  visible: terms,
                  child: Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0),
                      child: InAppWebView(
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
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
                          url: Uri.parse(Constants.language == "en"
                              ? "http://cp.citycode.om/public/termdoc/termandconditions-english.html"
                              : "http://cp.citycode.om/public/termdoc/tremandconditions-arebic.html"),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !isApplication && !terms,
        child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isApplication = true;
                    });
                  },
                  child: Text(
                    Constants.language == "en"
                        ? "Application policy"
                        : "سياسة التطبيق",
                    style: TextStyle(
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont"),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2CC0F),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      terms = true;
                    });
                  },
                  child: Text(
                    Constants.language == "en"
                        ? "Terms and Conditions"
                        : "الأحكام والشروط",
                    style: TextStyle(
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont"),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2CC0F),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
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
}
