// ignore_for_file: file_names, unnecessary_import, unused_import

import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'home_screen.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool terms = false;

  @override
  void initState() {
    super.initState();
    terms = true; // Set initial visibility to true
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2CC0F),
        centerTitle: true,
        title: Text(
          Constants.language == "en"
              ? "Terms and conditions of the"
              : "شروط وأحكام التطبيق",
          style: TextStyle(
            fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
          ),
        ),
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
                Expanded(
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !terms,
        child: Container(
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
                fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
              ),
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
      ),
    );
  }
}
