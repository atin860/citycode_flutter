// ignore_for_file: unused_import, must_be_immutable, non_constant_identifier_names, unused_local_variable, unnecessary_null_comparison, unnecessary_this

import 'dart:convert';

import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/models/city_model.dart';
import 'package:city_code/models/nationality_model.dart';
import 'package:city_code/models/state_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ChangeLocation extends StatefulWidget {
  bool isChange;

  ChangeLocation(this.isChange, {Key? key}) : super(key: key);

  @override
  _ChangeLocationState createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  bool _isLoading = true;
  String state_id = "", city_id = "";
  String governorateValue =
      Constants.language == "en" ? "Select Governorate" : "اختر محافظة";
  String cityValue = Constants.language == "en" ? "Select State" : "اختر ولايه";
  late List<String> governorateList = [
    Constants.language == "en" ? "Select Governorate" : "اختر محافظة"
  ];
  List<State_list>? governorateModelList = [];
  List<City_list>? cityModelList = [];
  late List<String> cityList = [
    Constants.language == "en" ? "Select State" : "اختر ولايه"
  ];
  late Future<State_model> stateList = _getState();
  late Future<City_model> city_List;
  late List<SelectedLocationModel> selectedLocation = [];
  NetworkCheck networkCheck = NetworkCheck();

  Future<State_model> _getState() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/ApiFilters?language='));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
          return State_model.fromJson(jsonDecode(response.body));
        } else {
          throw Exception('Failed to load album');
        }
      } else {
        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please Connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      throw Exception('Failed to load album');
    }
  }

  Future<City_model> _getCity(String state_id) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/getcities?state_id=' +
              state_id));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
          return City_model.fromJson(jsonDecode(response.body));
        } else {
          throw Exception('Failed to load album');
        }
      } else {
        throw Exception('Failed to load album');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      throw Exception('Failed to load album');
    }
  }

  Future<void> postChangeLocation() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "userid": Constants.user_id,
        "governorate": state_id,
        "state": city_id,
        "language": Constants.language
      };

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/apiupdateprofile'),
        body: body,
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 201) {
        if (response_server["status"] == 201) {
          setState(() {
            _isLoading = false;
          });
          if (Constants.language == "en") {
            _alertDialog("Location changed successfully");
          } else {
            _alertDialog("تم تغيير الموقع بنجاح");
          }
          Route newRoute =
              MaterialPageRoute(builder: (context) => HomeScreen("0", ""));
          Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
        } else {
          setState(() {
            _isLoading = false;
          });
          if (Constants.language == "en") {
            _alertDialog("Failed to change location");
          } else {
            _alertDialog("فشل تغيير الموقع");
          }
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          if (Constants.language == "en") {
            _alertDialog("Failed to change location");
          } else {
            _alertDialog("فشل تغيير الموقع");
          }
        } else {
          if (Constants.language == "en") {
            _alertDialog("Something went wrong");
          } else {
            _alertDialog("هناك خطأ ما");
          }
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
    }
  }

  @override
  void initState() {
    stateList.then((value) => {
          if (value.stateList!.isNotEmpty)
            {
              for (int i = 0; i < value.stateList!.length; i++)
                {
                  if (Constants.language == "en")
                    {
                      setState(() {
                        governorateList.add(value.stateList![i].stateName!);
                        governorateModelList?.add(value.stateList![i]);
                      })
                    }
                  else
                    {
                      setState(() {
                        governorateList.add(value.stateList![i].arbStateName!);
                        governorateModelList?.add(value.stateList![i]);
                      })
                    }
                }
            },
          for (int i = 0; i < governorateModelList!.length; i++)
            {
              if (governorateValue == governorateModelList![i].stateName ||
                  governorateValue == governorateModelList![i].arbStateName)
                {
                  state_id = governorateModelList![i].stateId!,
                }
            },
          city_List = _getCity(state_id),
          city_List.then((value) => {
                if (value.cityList!.isNotEmpty)
                  {
                    for (int i = 0; i < value.cityList!.length; i++)
                      {
                        if (Constants.language == "en")
                          {
                            setState(() {
                              cityList.add(value.cityList![i].cityName!);
                            })
                          }
                        else
                          {
                            setState(() {
                              cityList.add(value.cityList![i].cityArbName!);
                            })
                          }
                      }
                  }
              }),
          setState(() {
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
      backgroundColor: Colors.white,
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
          Constants.language == "en" ? "Change Location" : "تحديد الموقع",
          style: TextStyle(
            color: Colors.black,
            fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
          ),
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
        child: Directionality(
          textDirection: Constants.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            hint: Text(Constants.language == "en"
                                ? "Governorate"
                                : "المحافظة"),
                            value: governorateValue,
                            icon: const Icon(
                              CupertinoIcons.chevron_down,
                              color: Colors.black,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 18),
                            onChanged: (String? data) {
                              setState(() {
                                governorateValue = data!;
                              });
                              if (governorateValue != "Select Governorate" ||
                                  governorateValue != "اختر محافظة") {
                                for (int i = 0;
                                    i < governorateModelList!.length;
                                    i++) {
                                  if (governorateValue ==
                                          governorateModelList![i].stateName ||
                                      governorateValue ==
                                          governorateModelList![i]
                                              .arbStateName) {
                                    state_id =
                                        governorateModelList![i].stateId!;
                                    if (selectedLocation != null &&
                                        selectedLocation.isNotEmpty) {
                                      selectedLocation.clear();
                                      selectedLocation.add(
                                          SelectedLocationModel(
                                              state_id,
                                              Constants.language == "en"
                                                  ? governorateModelList![i]
                                                      .stateName!
                                                  : governorateModelList![i]
                                                      .arbStateName!));
                                    } else {
                                      selectedLocation.add(
                                          SelectedLocationModel(
                                              state_id,
                                              Constants.language == "en"
                                                  ? governorateModelList![i]
                                                      .stateName!
                                                  : governorateModelList![i]
                                                      .arbStateName!));
                                    }
                                    break;
                                  }
                                }
                                city_List = _getCity(state_id);
                                city_List.then((value) => {
                                      setState(() {
                                        if (cityList != null &&
                                            cityList.isNotEmpty) {
                                          for (int i = 1;
                                              i < cityList.length;
                                              i++) {
                                            cityList.removeAt(i);
                                          }
                                          cityValue = Constants.language == "en"
                                              ? "Select State"
                                              : "اختر ولايه";
                                        }
                                      }),
                                      if (value.cityList!.isNotEmpty)
                                        {
                                          for (int i = 0;
                                              i < value.cityList!.length;
                                              i++)
                                            {
                                              if (Constants.language == "en")
                                                {
                                                  setState(() {
                                                    cityList.add(value
                                                        .cityList![i]
                                                        .cityName!);
                                                  })
                                                }
                                              else
                                                {
                                                  setState(() {
                                                    cityList.add(value
                                                        .cityList![i]
                                                        .cityArbName!);
                                                  })
                                                },
                                              cityModelList
                                                  ?.add(value.cityList![i])
                                            }
                                        }
                                    });
                              } else {
                                state_id = "";
                              }
                            },
                            items: governorateList
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      fontFamily: Constants.language == "en"
                                          ? "Roboto"
                                          : "GSSFont"),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              if (governorateValue == "Select Governorate" ||
                                  governorateValue == "اختر محافظة") {
                                _alertDialog(Constants.language == "en"
                                    ? "Select Governorate First"
                                    : "يرجى تحديد المحافظة أولا");
                              }
                            },
                            child: cityList != null || cityList.isNotEmpty
                                ? DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    hint: Text(Constants.language == "en"
                                        ? "State"
                                        : "الولاية"),
                                    value: cityValue,
                                    icon: const Icon(
                                      CupertinoIcons.chevron_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 18,
                                        fontFamily: Constants.language == "en"
                                            ? "Roboto"
                                            : "GSSFont"),
                                    onChanged: governorateValue ==
                                            "Select Governorate"
                                        ? null
                                        : (String? data) {
                                            setState(() {
                                              cityValue = data!;
                                              if (cityValue != "Select State") {
                                                for (int i = 0;
                                                    i < cityModelList!.length;
                                                    i++) {
                                                  if (cityValue ==
                                                          cityModelList![i]
                                                              .cityName ||
                                                      cityValue ==
                                                          cityModelList![i]
                                                              .cityArbName) {
                                                    city_id = cityModelList![i]
                                                        .cityId!;
                                                    if (selectedLocation !=
                                                            null &&
                                                        selectedLocation
                                                            .isNotEmpty) {
                                                      if (selectedLocation
                                                              .length ==
                                                          1) {
                                                        selectedLocation.add(SelectedLocationModel(
                                                            city_id,
                                                            Constants.language ==
                                                                    "en"
                                                                ? cityModelList![
                                                                        i]
                                                                    .cityName!
                                                                : cityModelList![
                                                                        i]
                                                                    .cityArbName!));
                                                      } else {
                                                        selectedLocation
                                                            .removeAt(1);
                                                        selectedLocation.add(SelectedLocationModel(
                                                            city_id,
                                                            Constants.language ==
                                                                    "en"
                                                                ? cityModelList![
                                                                        i]
                                                                    .cityName!
                                                                : cityModelList![
                                                                        i]
                                                                    .cityArbName!));
                                                      }
                                                    }
                                                    break;
                                                  }
                                                }
                                              } else {
                                                state_id = "";
                                              }
                                            });
                                          },
                                    items: cityList
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont"),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40.0,
                      margin: const EdgeInsets.only(
                          left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.isChange) {
                            postChangeLocation();
                          } else {
                            String data = jsonEncode(selectedLocation
                                .map((e) => e.toJson())
                                .toList());
                            Navigator.pop(context, data);
                          }
                        },
                        child: Text(
                          Constants.language == "en" ? "Done" : "حفظ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont",
                            fontSize: 18.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF2CC0F),
                          elevation: 0.0,
                          textStyle: const TextStyle(color: Color(0xFFF2CC0F)),
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
}

class SelectedLocationModel {
  String id, name;

  SelectedLocationModel(this.id, this.name);

  Map<String, dynamic> toJson() {
    return {"id": this.id, "name": this.name};
  }
}
