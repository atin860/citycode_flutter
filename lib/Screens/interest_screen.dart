// ignore_for_file: unnecessary_import, must_be_immutable, non_constant_identifier_names, unnecessary_null_comparison, unnecessary_this

import 'dart:convert';

import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/models/add_interest_model.dart';
import 'package:city_code/models/interest_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'chat_screen.dart';

class InterestScreen extends StatefulWidget {
  String page, catagory_id;

  InterestScreen(this.page, this.catagory_id, {Key? key}) : super(key: key);

  @override
  _InterestScreenState createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  late Future<Interest_model> future_interest;
  late List<Category_list>? category_list = [];
  late List<String> selected_category = [];
  String? base_url = "";
  String selected_id = "";
  bool _isLoading = false;
  late List<SelectedInterestModel> selectedList = [];
  NetworkCheck networkCheck = NetworkCheck();

  Future<Interest_model> _getInterest() async {
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
          return Interest_model.fromJson(jsonDecode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
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

  Future<Add_interest_model> addInterest(BuildContext context) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {"userid": Constants.user_id, "interest": selected_id};

      final response = await http.post(
        Uri.parse(
            'http://185.188.127.11/public/index.php/ApiUsers/AddUserIntrest'),
        body: body,
      );

      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }

        if (response_server["status"] == 201) {
          setState(() {
            _isLoading = false;
          });
          _alertDialog(Constants.language == "en"
              ? "Interest added successfully"
              : "تمت إضافة الاهتمام بنجاح");
          if (Constants.chat_data.isNotEmpty) {
            var data = jsonDecode(Constants.chat_data);
            Route route = MaterialPageRoute(
                builder: (context) => ChatScreen(
                    data["company_name"],
                    data["company_image_base_url"] + data["company_logo"],
                    data["receiver_id"],
                    data["sender_id"],
                    "",
                    "",
                    "user",
                    "",
                    "1",
                    "0"));
            Navigator.pushReplacement(context, route);
          } else if (Constants.notification_id.isNotEmpty) {
            Route route =
                MaterialPageRoute(builder: (context) => HomeScreen("1", ""));
            Navigator.pushReplacement(context, route);
          } else {
            Route route =
                MaterialPageRoute(builder: (context) => HomeScreen("0", ""));
            Navigator.pushReplacement(context, route);
          }
          return Add_interest_model.fromJson(json.decode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });
          if (Constants.language == "en") {
            _alertDialog("Failed to add interest");
          } else {
            _alertDialog("فشل في إضافة الفائدة");
          }
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (Constants.language == "en") {
          _alertDialog("Something went wrong");
        } else {
          _alertDialog("هناك خطأ ما");
        }
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

  @override
  void initState() {
    future_interest = _getInterest();
    var cat_id = [];
    future_interest.then((value) => {
          setState(() {
            base_url = value.categoryBaseUrl ?? "";
          }),
          if (value.categoryList!.isNotEmpty)
            {
              for (int i = 0; i < value.categoryList!.length; i++)
                {
                  setState(() {
                    category_list?.add(value.categoryList![i]);
                    selected_category.add("0");
                  })
                },
              if (widget.catagory_id.isNotEmpty)
                {
                  cat_id = widget.catagory_id.split(","),
                  if (category_list != null && category_list!.isNotEmpty)
                    {
                      for (int i = 0; i < category_list!.length; i++)
                        {
                          for (int j = 0; j < cat_id.length; j++)
                            {
                              if (category_list![i].catId == cat_id[j])
                                {
                                  setState(() {
                                    selected_category[i] = "1";
                                    selected_id = "";
                                    if (selected_id.isNotEmpty) {
                                      selected_id = selected_id +
                                          "," +
                                          category_list![i].catId!;
                                    } else {
                                      selected_id = category_list![i].catId!;
                                    }
                                    if (widget.page == "arrangement") {
                                      selectedList.add(SelectedInterestModel(
                                          category_list![i].catId!,
                                          Constants.language == "en"
                                              ? category_list![i].catName!
                                              : category_list![i].catArbname!));
                                    }
                                  }),
                                }
                            }
                        }
                    }
                }
            }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.page == "arrangement" || widget.page == "settings"
          ? AppBar(
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
                Constants.language == "en"
                    ? "Define your interests"
                    : "أختر نوع التصنيف",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont"),
              ),
            )
          : AppBar(
              centerTitle: true,
              backgroundColor: const Color(0xFFF2CC0F),
              title: Text(
                Constants.language == "en"
                    ? "Define your interests"
                    : "أختر نوع التصنيف",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont"),
              ),
            ),
      body: SafeArea(
        child: Directionality(
          textDirection: Constants.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Stack(
            children: [
              FutureBuilder(
                future: future_interest,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GridView.builder(
                      itemCount: category_list!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisExtent: height * 0.16),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selected_category[index] == "1") {
                                selected_category[index] = "0";
                                if (selected_id
                                    .contains(category_list![index].catId!)) {
                                  List selected_id_list =
                                      selected_id.split(",");
                                  for (int i = 0;
                                      i < selected_id_list.length;
                                      i++) {
                                    if (selected_id_list[i] ==
                                        category_list![index].catId!) {
                                      selected_id_list.remove(i);
                                    }
                                  }
                                  selected_id = "";
                                  if (selected_id_list.isNotEmpty) {
                                    selected_id = selected_id_list.join(",");
                                  }
                                }
                                if (widget.page == "arrangement") {
                                  if (selectedList != null &&
                                      selectedList.isNotEmpty) {
                                    for (int i = 0;
                                        i < selectedList.length;
                                        i++) {
                                      if (selectedList[i].id ==
                                          category_list![index].catId!) {
                                        selectedList.removeAt(i);
                                      }
                                    }
                                  }
                                }
                              } else {
                                selected_category[index] = "1";
                                if (selected_id.isNotEmpty) {
                                  selected_id = selected_id +
                                      "," +
                                      category_list![index].catId!;
                                } else {
                                  selected_id = category_list![index].catId!;
                                }
                                if (widget.page == "arrangement") {
                                  selectedList.add(SelectedInterestModel(
                                      category_list![index].catId!,
                                      Constants.language == "en"
                                          ? category_list![index].catName!
                                          : category_list![index].catArbname!));
                                }
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: selected_category[index] == "1"
                                      ? const Color(0xFFF2CC0F)
                                      : Colors.white,
                                  width: 4.0,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(13))),
                            margin: const EdgeInsets.only(
                                left: 1.5, right: 1.5, top: 2.5),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(10), // Image border
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(48), // Image radius
                                child: Image(
                                  image: NetworkImage(Constants.language == "en"
                                      ? base_url! +
                                          category_list![index].catImage!
                                      : base_url! +
                                          category_list![index].catArbImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                        // Card(
                        //   elevation: 5,
                        //   shape: RoundedRectangleBorder(
                        // side: BorderSide(color: Colors.white70, width: 1),
                        // borderRadius: BorderRadius.circular(10),
                        // ),
                        //   child: Image(image: NetworkImage(Constants.language == "en" ? base_url! + category_list![index].catImage! : base_url! + category_list![index].catArbImage!),
                        //     fit: BoxFit.cover,),
                        // );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
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
      bottomNavigationBar: Directionality(
        textDirection:
            Constants.language == "en" ? TextDirection.ltr : TextDirection.rtl,
        child: Container(
          height: height * 0.10,
          color: const Color(0xFFF2CC0F),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  bool all_selected = true;
                  for (int i = 0; i < selected_category.length; i++) {
                    if (selected_category[i] == "0") {
                      all_selected = false;
                    }
                  }
                  if (!all_selected) {
                    setState(() {
                      if (category_list!.isNotEmpty) {
                        selected_id = "";
                        for (int i = 0; i < category_list!.length; i++) {
                          if (selected_category[i] == "0") {
                            if (selected_id.isNotEmpty) {
                              selected_id =
                                  selected_id + "," + category_list![i].catId!;
                            } else {
                              selected_id = category_list![i].catId!;
                            }
                            selected_category[i] = "1";
                            selectedList.add(SelectedInterestModel(
                                category_list![i].catId!,
                                Constants.language == "en"
                                    ? category_list![i].catName!
                                    : category_list![i].catArbname!));
                          }
                        }
                      }
                    });
                  } else {
                    setState(() {
                      selected_id = "";
                      selectedList.clear();
                      for (int i = 0; i < selected_category.length; i++) {
                        if (selected_category[i] == "1") {
                          selected_category[i] = "0";
                        }
                      }
                    });
                  }
                },
                child: Container(
                  width: width * 0.40,
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.only(
                      left: 10.0, top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    Constants.language == "en" ? "All" : "الكل",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (widget.page == "arrangement") {
                    if (selectedList.isNotEmpty) {
                      String data = jsonEncode(
                          selectedList.map((e) => e.toJson()).toList());
                      Navigator.pop(context, data);
                    }
                  } else if (selected_id.isNotEmpty) {
                    setState(() {
                      _isLoading = true;
                    });
                    addInterest(context);
                  } else {
                    if (Constants.chat_data.isNotEmpty) {
                      var data = jsonDecode(Constants.chat_data);
                      Route route = MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              data["company_name"],
                              data["company_image_base_url"] +
                                  data["company_logo"],
                              data["receiver_id"],
                              data["sender_id"],
                              "",
                              "",
                              "user",
                              "",
                              "1",
                              "0"));
                      Navigator.pushReplacement(context, route);
                    } else if (Constants.notification_id.isNotEmpty) {
                      Route route = MaterialPageRoute(
                          builder: (context) => HomeScreen("1", ""));
                      Navigator.pushReplacement(context, route);
                    } else {
                      Route route = MaterialPageRoute(
                          builder: (context) => HomeScreen("0", ""));
                      Navigator.pushReplacement(context, route);
                    }
                  }
                },
                child: Container(
                  width: width * 0.40,
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.only(
                      left: 10.0, top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    Constants.language == "en" ? "Next" : "التالي",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily:
                            Constants.language == "en" ? "Roboto" : "GSSFont",
                        fontSize: 16.0),
                    textAlign: TextAlign.center,
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

class SelectedInterestModel {
  String id, name;

  SelectedInterestModel(this.id, this.name);

  Map<String, dynamic> toJson() {
    return {"id": this.id, "name": this.name};
  }
}
