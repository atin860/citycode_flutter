// ignore_for_file: must_be_immutable, non_constant_identifier_names, unrelated_type_equality_checks

import 'dart:convert';

import 'package:badges/badges.dart' as badge;

import 'package:city_code/Screens/chat_screen.dart';
import 'package:city_code/models/chat_list_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CompanyChatListScreen extends StatefulWidget {
  String company_image;

  CompanyChatListScreen(this.company_image, {Key? key}) : super(key: key);

  @override
  _CompanyChatListScreenState createState() => _CompanyChatListScreenState();
}

class _CompanyChatListScreenState extends State<CompanyChatListScreen> {
  bool _isLoading = true;
  NetworkCheck networkCheck = NetworkCheck();
  List<Userlist>? userlist = [];
  String baseUrl = "";

  @override
  void initState() {
    postChatList().then((value) => {
          if (value.userlist != null && value.userlist!.isNotEmpty)
            {
              for (int i = 0; i < value.userlist!.length; i++)
                {
                  userlist!.add(value.userlist![i]),
                }
            },
          setState(() {
            baseUrl = value.imageUrl!;
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
          icon: const Icon(
            CupertinoIcons.arrow_left,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          Constants.company_name,
          style: TextStyle(
            color: Colors.black,
            fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
          ),
        ),
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: Constants.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Stack(
            children: [
              SizedBox(
                height: height,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                        Constants.language == "en"
                                            ? userlist![index].name!
                                            : userlist![index].arbName!.isEmpty
                                                ? userlist![index].name!
                                                : userlist![index].arbName!,
                                        baseUrl + userlist![index].profile!,
                                        Constants.branch_id,
                                        userlist![index].id!,
                                        "",
                                        "",
                                        "company",
                                        widget.company_image,
                                        "0",
                                        "0"));
                                Navigator.push(context, route);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          baseUrl + userlist![index].profile!),
                                      radius: 30.0,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Text(
                                        Constants.language == "en"
                                            ? userlist![index].name!
                                            : userlist![index].arbName!.isEmpty
                                                ? userlist![index].name!
                                                : userlist![index].arbName!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontFamily: Constants.language == "en"
                                              ? "Roboto"
                                              : "GSSFont",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 100),
                                      child: badge.Badge(
                                        padding: const EdgeInsets.all(10),
                                        shape: badge.BadgeShape.circle,
                                        showBadge:
                                            userlist![index].unread_status ==
                                                    "0"
                                                ? false
                                                : true,
                                        badgeContent: Text(
                                          userlist![index]
                                              .unread_status
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    badge.Badge(
                                      badgeColor: Colors.red,
                                      shape: badge.BadgeShape.square,
                                      showBadge:
                                          userlist![index].unread_status != null
                                              ? false
                                              : true,
                                      position: badge.BadgePosition.topEnd(
                                          top: -15, end: -19),
                                      badgeContent: Text(
                                        userlist![index]
                                            .unread_status
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              height: 1.0,
                              width: width,
                              color: Colors.black,
                            );
                          },
                          itemCount: userlist!.length),
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

  Future<ChatListModel> postChatList() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {"branch_id": Constants.branch_id};

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/ApiChatUserList'),
        body: body,
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 201) {
        if (response_server["status"] == 201) {
          return ChatListModel.fromJson(json.decode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });
          if (Constants.language == "en") {
            _alertDialog("No chats available");
          } else {
            _alertDialog("لا توجد محادثة متاحة");
          }
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          if (Constants.language == "en") {
            _alertDialog("No chats available");
          } else {
            _alertDialog("لا توجد محادثة متاحة");
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
