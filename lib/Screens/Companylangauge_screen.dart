// ignore_for_file: file_names

import 'package:city_code/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Companylangauge extends StatefulWidget {
  const Companylangauge({Key? key}) : super(key: key);

  @override
  State<Companylangauge> createState() => _CompanylangaugeState();
}

class _CompanylangaugeState extends State<Companylangauge> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  _prefs.setString("language", "ar");
                  Constants.language = "ar";
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>))
                  Navigator.pop(context);
                },
                child: const Text(
                  "العربية",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "GSSFont",
                      fontSize: 18.0),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: InkWell(
                  onTap: () async {
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    _prefs.setString("language", "en");
                    Constants.language = "en";
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "English",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
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
