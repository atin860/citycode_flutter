// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_final_fields, unused_field, avoid_print, deprecated_member_use, unnecessary_new, avoid_unnecessary_containers, unused_local_variable, avoid_types_as_parameter_names, prefer_typing_uninitialized_variables, unused_label, unrelated_type_equality_checks, body_might_complete_normally_catch_error, dead_code, unused_element, unnecessary_brace_in_string_interps, file_names

import 'dart:async';
import 'dart:convert';
import 'package:city_code/Screens/chat_screen.dart';
import 'package:city_code/models/company_list_model.dart';
import 'package:city_code/models/home_banner_model.dart';
//import 'package:city_code/models/new_offers_model.dart';
import 'package:city_code/models/notification_list_model.dart';
// ignore: unused_import
import 'package:city_code/models/vip_list_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/date.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'offer_details_screen.dart';

class NotificationListScreen extends StatefulWidget {
  String which_page;

  NotificationListScreen(this.which_page, {Key? key}) : super(key: key);

  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  bool _isLoading = true;
  late Future<Notification_list_model> notification;
  List<Notification_list>? notificationList = [];
  List<Userlist>? userlist = [];
  List<String> status = [];
  String company_base_url = "";
  String url = "";
  //String image_url="";
  String companyname = "";
  String text = "It is possible to set up You can set ,";

  NetworkCheck networkCheck = NetworkCheck();
  late Future<Home_banner_model> home_banner;

  List<Banner_list>? bannerList = [];

  Future<Notification_list_model> _getNotificationList() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/NotificationList?userid=' +
              Constants.user_id));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }

        if (response_server["status"] == 201) {
          return Notification_list_model.fromJson(jsonDecode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });
          _alertDialog(
              Constants.language == "en" ? "no data found" : "لاتوجد بيانات");
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          _alertDialog(
              Constants.language == "en" ? "no data found" : "لاتوجد بيانات");
        } else {
          _alertDialog(Constants.language == "en"
              ? "Something went wrong"
              : "هناك خطأ ما");
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

  Future<bool> _postDeleteNotification(
      String companyId, String notificationId) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "userid": Constants.user_id,
        "companyid": companyId,
        "notificationid": notificationId
      };

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/notificationdelete'),
        body: body,
      );

      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }
        if (response_server["status"] == 201) {
          return true;
        } else {
          setState(() {
            _isLoading = false;
          });
          _alertDialog(Constants.language == "en"
              ? "Notification not deleted"
              : "لم يتم حذف الإخطار");
          return false;
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          _alertDialog(Constants.language == "en"
              ? "Notification not deleted"
              : "لم يتم حذف الإخطار");
        } else {
          _alertDialog(Constants.language == "en"
              ? "Something went wrong"
              : "هناك خطأ ما");
        }
        return false;
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      return false;
    }
  }

  Future<CompanyListModel> _postCompanyList() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "userid": Constants.user_id,
      };

      final response = await http.post(
        Uri.parse(
            'http://185.188.127.11/public/index.php/ApiChatUserCompanyList'),
        body: body,
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 201) {
        if (response_server["status"] == 201) {
          return CompanyListModel.fromJson(jsonDecode(response.body));
        } else {
          if (response_server["status"] == 404) {
            _alertDialog(
                Constants.language == "en" ? "No data found" : "لاتوجد بيانات");
          } else {
            _alertDialog(Constants.language == "en"
                ? "Something went wrong"
                : "هناك خطأ ما");
          }
          setState(() {
            _isLoading = false;
          });
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          _alertDialog(
              Constants.language == "en" ? "No data found" : "لاتوجد بيانات");
        } else {
          _alertDialog(Constants.language == "en"
              ? "Something went wrong"
              : "هناك خطأ ما");
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
    if (widget.which_page == "chats") {
      _postCompanyList().then((value) => {
            if (value.userlist != null && value.userlist!.isNotEmpty)
              {
                for (int i = 0; i < value.userlist!.length; i++)
                  {
                    userlist!.add(value.userlist![i]),
                  },
                if (userlist != null && userlist!.isNotEmpty)
                  {
                    for (int i = 0; i < userlist!.length; i++)
                      {
                        if (userlist![i].branchId!.isEmpty)
                          {
                            userlist!.removeAt(i),
                            i--,
                          }
                      }
                  },
                if (userlist != null && userlist!.isNotEmpty)
                  {
                    for (int i = 0; i < userlist!.length; i++)
                      {
                        for (int j = i + 1; j < userlist!.length; j++)
                          {
                            if (userlist![i].branchId! ==
                                userlist![j].branchId!)
                              {
                                userlist!.removeAt(j),
                                j--,
                              }
                          }
                      }
                  },
              },
            company_base_url = value.imageUrl!,
            _isLoading = false,
          });
    } else {
      notification = _getNotificationList();
      List<String> date;
      Date now = Date();
      String today = now.getDate();
      notification.then((value) => {
            company_base_url = value.imageBaseUrl!,
            if (value.notificationlist != null &&
                value.notificationlist!.isNotEmpty)
              {
                for (int i = 0; i < value.notificationlist!.length; i++)
                  {
                    if (widget.which_page == value.notificationlist![i].type!)
                      {
                        notificationList!.add(value.notificationlist![i]),
                        date = value.notificationlist![i].time!.split(" "),
                        if (value.notificationlist![i].acceptStatus! == "1")
                          {
                            status.add("1"),
                          }
                        else if (today == date[0])
                          {
                            status.add("2"),
                          }
                        else
                          {
                            status.add("3"),
                          }
                      }
                  }
              },
            if (notificationList != null && notificationList!.isNotEmpty)
              {
                for (int i = 0; i < notificationList!.length; i++)
                  {
                    for (int j = i + 1; j < notificationList!.length; j++)
                      {
                        if (notificationList![i].notificationId ==
                            notificationList![j].notificationId)
                          {
                            notificationList!.removeAt(j),
                            j--,
                          }
                      }
                  }
              },
            _isLoading = false,
          });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2CC0F),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              widget.which_page == "chats"
                  ? ListView.builder(
                      itemCount: userlist!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    Constants.language == "en"
                                        ? userlist![index].companyName!
                                        : userlist![index]
                                                .companyArbName!
                                                .isNotEmpty
                                            ? userlist![index].companyArbName!
                                            : userlist![index].companyName!,
                                    company_base_url +
                                        userlist![index].picture!,
                                    Constants.user_id,
                                    userlist![index].branchId!,
                                    "",
                                    "",
                                    "user",
                                    "",
                                    "0",
                                    "0"));
                            Navigator.push(context, route);
                          },
                          child: Container(
                            width: width,
                            padding: const EdgeInsets.all(6.0),
                            margin: const EdgeInsets.only(top: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Row(
                              children: [
                                userlist![index].picture!.isNotEmpty
                                    ? CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            company_base_url +
                                                userlist![index].picture!),
                                      )
                                    : const Image(
                                        image: AssetImage(
                                            "images/circle_app_icon.png"),
                                        width: 60.0,
                                        height: 60.0,
                                      ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Constants.language == "en"
                                              ? userlist![index].companyName!
                                              : userlist![index]
                                                      .companyArbName!
                                                      .isNotEmpty
                                                  ? userlist![index]
                                                      .companyArbName!
                                                  : userlist![index]
                                                      .companyName!,
                                          style: TextStyle(
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(
                                            Constants.language == "en"
                                                ? userlist![index].branchName!
                                                : userlist![index]
                                                        .arbBranchName!
                                                        .isNotEmpty
                                                    ? userlist![index]
                                                        .arbBranchName!
                                                    : userlist![index]
                                                        .branchName!,
                                            style: TextStyle(
                                                fontFamily:
                                                    Constants.language == "en"
                                                        ? "Roboto"
                                                        : "GSSFont",
                                                fontSize: 14.0),
                                          ),
                                        ),
                                        Align(
                                          child: Text(
                                            userlist![index].lastupdatetime!,
                                            textAlign: TextAlign.right,
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                  : ListView.builder(
                      itemCount: notificationList!.length,
                      itemBuilder: (context, index) {
                        String textt = widget.which_page == "city"
                            ? notificationList![index].title!
                            : Constants.language == "en"
                                ? notificationList![index].companyName!
                                : notificationList![index]
                                    .companyArbName!
                                    .toString();
                        if (widget.which_page == "purchase") {
                          return InkWell(
                            onTap: () {
                              if (status[index] != "1") {
                                _showDialog(context, index, "1", width);
                              } else {
                                _showDialog(context, index, "1", width);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              margin: const EdgeInsets.only(top: 10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      notificationList![index]
                                              .companyLogo!
                                              .isNotEmpty
                                          ? CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  company_base_url +
                                                      notificationList![index]
                                                          .companyLogo!),
                                            )
                                          : const Image(
                                              image: AssetImage(
                                                  "images/circle_app_icon.png"),
                                              width: 60.0,
                                              height: 60.0,
                                            ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Text(
                                          Constants.language == "en"
                                              ? notificationList![index]
                                                  .companyName!
                                              : notificationList![index]
                                                  .companyArbName!,
                                          style: TextStyle(
                                              fontFamily:
                                                  Constants.language == "en"
                                                      ? "Roboto"
                                                      : "GSSFont",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            status[index] == "1"
                                                ? Constants.language == "en"
                                                    ? " Approved"
                                                    : "تمت الموافقه"

                                                /// commenting status==2
                                                : status[index] == "2"

                                                    // : status[index] == "1"

                                                    ? Constants.language == "en"

                                                        ///comenting below code

                                                        /*  ? "Pendings"
                                             : " في الانتظار"*/

                                                        ? " Approved"
                                                        : "تمت الموافقه"
                                                    : Constants.language == "en"
                                                        ? "Expired"
                                                        : "منتهية الصلاحية",
                                            style: TextStyle(
                                                fontFamily:
                                                    Constants.language == "en"
                                                        ? "Roboto"
                                                        : "GSSFont",
                                                color: status[index] == "1"
                                                    ? Colors.green
                                                    : status[index] == "2"

                                                        ///changing blue to green
                                                        ? Colors.green
                                                        : Colors.red),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 1.0),
                                            child: IconButton(
                                              icon: const Icon(
                                                  CupertinoIcons.delete_solid),
                                              iconSize: 18.0,
                                              color: Colors.red,
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  // user must tap button!
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content:
                                                          SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            Text(
                                                              Constants.language ==
                                                                      "en"
                                                                  ? 'Are you sure you want to delete this message ?'
                                                                  : "هل أنت متأكد أنك تريد حذف هذه الرسالة ؟",
                                                              style: TextStyle(
                                                                fontFamily: Constants
                                                                            .language ==
                                                                        "en"
                                                                    ? "Roboto"
                                                                    : "GSSFont",
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child:
                                                              const Text('NO'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child:
                                                              const Text('YES'),
                                                          onPressed: () async {
                                                            setState(() {
                                                              _isLoading = true;
                                                            });
                                                            bool isDeleted = await _postDeleteNotification(
                                                                notificationList![
                                                                        index]
                                                                    .companyId!,
                                                                notificationList![
                                                                        index]
                                                                    .notificationId!);
                                                            if (isDeleted) {
                                                              setState(() {
                                                                notificationList!
                                                                    .removeAt(
                                                                        index);
                                                              });
                                                            }
                                                            setState(() {
                                                              _isLoading =
                                                                  false;
                                                            });
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(notificationList![index].time!),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              _showDialog(context, index, "0", width);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              margin: const EdgeInsets.only(
                                  top: 10.0, right: 0.5, left: 0.5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      notificationList![index]
                                              .companyLogo!
                                              .isNotEmpty
                                          ? CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  company_base_url +
                                                      notificationList![index]
                                                          .companyLogo!),
                                            )
                                          : const Image(
                                              image: AssetImage(
                                                  "images/circle_app_icon.png"),
                                              width: 45.0,
                                              height: 45.0,
                                            ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0, right: 5.0),
                                        child: Text(
                                          /*      widget.which_page == "city"
                                              ? notificationList![index].title!
                                              : Constants.language == "en"
                                              ? notificationList![index]
                                              .companyName!
                                              : notificationList![index]
                                              .companyArbName!.length > 30 ? '${widget.which_page == "city"
                                              ? notificationList![index].title!
                                              : Constants.language == "en"
                                              ? notificationList![index]
                                              .companyName!
                                              : notificationList![index]
                                              .companyArbName!.substring(0, 30)}......' : widget.which_page == "city"
                                              ? notificationList![index].title!
                                              : Constants.language == "en"
                                              ? notificationList![index]
                                              .companyName!
                                              : notificationList![index]
                                              .companyArbName!,*/
                                          textt.length > 30
                                              ? '${textt.substring(0, 30)}......'
                                              : textt,

                                          /*      widget.which_page == "city"
                                              ? notificationList![index].title!
                                              : Constants.language == "en"
                                                  ? notificationList![index]
                                                      .companyName!
                                                  : notificationList![index]
                                                      .companyArbName!,*/
                                          style: TextStyle(
                                            fontFamily:
                                                Constants.language == "en"
                                                    ? "Roboto"
                                                    : "GSSFont",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),

                                          overflow: TextOverflow.fade,
                                          maxLines: 1, //edited by rohan
                                          softWrap: true, //
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(left: 1.0),
                                        child: IconButton(
                                          icon: const Icon(
                                              CupertinoIcons.delete_solid),
                                          iconSize: 16.0,
                                          color: Colors.red,
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(
                                                          Constants.language ==
                                                                  "en"
                                                              ? 'Are you sure you want to delete this message ?'
                                                              : "هل أنت متأكد أنك تريد حذف هذه الرسالة ؟",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                Constants.language ==
                                                                        "en"
                                                                    ? "Roboto"
                                                                    : "GSSFont",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('NO'),
                                                      onPressed: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text('YES'),
                                                      onPressed: () async {
                                                        setState(() {
                                                          _isLoading = true;
                                                        });
                                                        bool isDeleted =
                                                            await _postDeleteNotification(
                                                                notificationList![
                                                                        index]
                                                                    .companyId!,
                                                                notificationList![
                                                                        index]
                                                                    .notificationId!);
                                                        if (isDeleted) {
                                                          setState(() {
                                                            notificationList!
                                                                .removeAt(
                                                                    index);
                                                          });
                                                        }
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Text(notificationList![index].time!),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),
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

  //here is implatmention of city code dialoge popup code
  _showDialog(
      BuildContext context, int index, String isPurchase, double width) {
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      //this right here
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.90,
        width: MediaQuery.of(context).size.width * 0.90,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        notificationList![index].companyLogo!.isNotEmpty
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(company_base_url +
                                    notificationList![index].companyLogo!),
                              )
                            : const Image(
                                image: AssetImage("images/circle_app_icon.png"),
                                width: 70.0,
                                height: 55.0,
                              ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            widget.which_page == "city"
                                ? notificationList![index].title!
                                : Constants.language == "en"
                                    ? notificationList![index].companyName!
                                    : notificationList![index].companyArbName!,
                            style: TextStyle(
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () async {
                            print("company url:" + company_base_url);
                            print("image :" + Constants.user_id);
                            print("Description::::::" +
                                notificationList![index].text!);
                            //print("imageurl"+image_url);
                            //  print(notification_id);
                            /* if (e.inApp == "true") {
                            Route route = MaterialPageRoute(
                                builder: (context) =>
                                    OfferDetailsScreen(
                                        "",
                                        e.companyId!,
                                        "",
                                        "",
                                        "",
                                        "city"));
                            Navigator.push(context, route);
                          } else {
                            if (e.url!.isNotEmpty) {
                              if (e.url!.contains(
                                  "https://instagram.com/")) {
                                String trimmed_url = e.url!
                                    .replaceAll(
                                    "https://instagram.com/",
                                    "");
                                var split_url =
                                trimmed_url.split("?");
                                String native_url =
                                    "instagram://user?username=${split_url[0]}";
                                if (await canLaunch(
                                    native_url)) {
                                  launch(native_url);
                                } else {
                                  launch(
                                    e.url!,
                                    universalLinksOnly: true,
                                  );
                                }
                              } else {
                                Route route = MaterialPageRoute(
                                    builder: (context) =>
                                        WebViewScreen(
                                            "", e.url!));
                                Navigator.push(context, route);
                              }
                            }
                          }*/

                            /* String trimmed_url = company_base_url!
                              .replaceAll(
                              "https://instagram.com/",
                              "");
                          var split_url =
                          trimmed_url.split("?");
                          String native_url =
                              "instagram://user?username=${split_url[0]}";
                          print("native url:"+native_url);

                          if (await canLaunch(
                              native_url)) {
                            launch(native_url);
                          } else {
                            // Route route = MaterialPageRoute(
                            //     builder: (context) =>
                            //         WebViewScreen(
                            //             "", company_base_url!));
                            // Navigator.push(context, route);
                            // launch(
                            //   company_base_url,
                            //   universalLinksOnly: true,
                            // );
                          }*/

                            /*if (e.url!.isNotEmpty) {
                            if (company_base_url.contains(
                                "https://instagram.com/")) {
                              String trimmed_url = company_base_url!
                                  .replaceAll(
                                  "https://instagram.com/",
                                  "");
                              var split_url =
                              trimmed_url.split("?");
                              String native_url =
                                  "instagram://user?username=${split_url[0]}";
                              if (await canLaunch(
                                  native_url)) {
                                launch(native_url);
                              } else {
                                launch(
                                  company_base_url,
                                  universalLinksOnly: true,
                                );
                              }
                            } else {
                              Route route = MaterialPageRoute(
                                  builder: (context) =>
                                      WebViewScreen(
                                          "", company_base_url!));
                              Navigator.push(context, route);
                            }
                          }*/

                            /* if (await canLaunch(url))
                          await launch(url);
                          else
                          // can't launch url, there is some error
                          throw "Could not launch $url";*/
                            /* Route route = MaterialPageRoute(
                                  builder: (context) => OfferDetailsScreen());
                          Navigator.push(context, route);*/
                            // Navigator.push(context,MaterialPageRoute(builder: (context) async =>OfferDetailsScreen));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            child: Text(
                              notificationList![index].text!,
                              style: TextStyle(
                                fontFamily: Constants.language == "en"
                                    ? "Roboto"
                                    : "GSSFont",
                              ),
                              textAlign: TextAlign.left,
                              //   overflow: TextOverflow.ellipsis,
                              // maxLines:1,
                              //  softWrap: false,
                            ),
                          ),
                        ),

                        //items:bannerList!
                        //  .map((e)
                        GestureDetector(
                          onTap: () async {
                            // String StateUrl = 'View App' ;
                            String image = notificationList![index].image_url!;
                            String inapp = notificationList![index].companyId!;
                            String type = notificationList![index].type!;
                            String name = notificationList![index].companyName!;

                            //   const image = "https://www.flutter.io";
                            print("hello");
                            // print(image_url);
                            print("imageurl:" +
                                notificationList![index].image_url!);

                            Uri _url = Uri.parse(image);
                            if (inapp == Constants.company_id ||
                                type == "city") {
                              Route route = MaterialPageRoute(
                                  builder: (context) => OfferDetailsScreen(
                                      name,
                                      inapp,
                                      "",
                                      "",
                                      "",
                                      "city",
                                      "",
                                      "",
                                      "",
                                      ""));
                              Navigator.push(context, route);
                            } else if (await canLaunch(_url.toString())) {
                              launch(_url.toString());
                            }

                            /* if (image.isNotEmpty||image!= null){
                           if (Platform.isAndroid){
                            if(await canLaunch(image)){
                              launch(image);
                            }
                                 }

                         }
                         else{
                           print("error");

                         }*/

                            /* if (image!.isNotEmpty) {
      if (image!.contains(
          "https://")) {
        String trimmed_url = image!
            .replaceAll(
            "https://",
            "");
        var split_url =
        trimmed_url.split("?");
        String native_url =
            "http://${split_url[0]}";
        print("native url"+native_url);
        if (await canLaunch(
            native_url)) {
          launch(native_url);
        } else {
          launch(
            image!,
            universalLinksOnly: true,
          );
        }
      }
    }*/

                            /*    final url = notificationList![index].image_url!;
                         if()
                         if (await canLaunch(url))
                           await launch(url);
                         else
                           // can't launch url, there is some error
                           throw "Could not launch $url";*/
                            /*if (image.isNotEmpty||image!= null){
                           if (Platform.isAndroid){
                             if(await canLaunch(image)){
                               launch(image);
                             }
                           }

                         }
                         else{
                           print("error");

                         }*/
                            /*String StateUrl = 'View App' ;
                          var image=notificationList![index].image_url!;
                              try {
                              if(await canLaunch(image)) await launch(image);
                              } catch(e){
                              setState(() {
                              StateUrl = e.toString() ;
                              });
                              throw e;}*/

                            /*if (await canLaunch(image))
                          await launch(image);
                          else
                          // can't launch url, there is some error
                          throw "Could not launch $image";*/

                            //    print(image_url);
                            //  print(userid);
                            /* if (e.inApp == "true") {
                            Route route = MaterialPageRoute(
                                builder: (context) =>
                                    OfferDetailsScreen(
                                        "",
                                        e.companyId!,
                                        "",
                                        "",
                                        "",
                                        "city"));
                            Navigator.push(context, route);
                          } else {
                            if (e.url!.isNotEmpty) {
                              if (e.url!.contains(
                                  "https://instagram.com/")) {
                                String trimmed_url = e.url!
                                    .replaceAll(
                                    "https://instagram.com/",
                                    "");
                                var split_url =
                                trimmed_url.split("?");
                                String native_url =
                                    "instagram://user?username=${split_url[0]}";
                                if (await canLaunch(
                                native_url)) {
                          launch(native_url);
                          } else {
                          launch(
                          e.url!,
                          universalLinksOnly: true,
                          );
                          }
                          } else {
                          Route route = MaterialPageRoute(
                          builder: (context) =>
                          WebViewScreen(
                          "", e.url!));
                          Navigator.push(context, route);
                          }
                        }
                        }*/
                          },
                          child: Visibility(
                            visible:
                                notificationList![index].notifyimage!.isNotEmpty
                                    ? true
                                    : false,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10.0),
                              child: Image(
                                image: NetworkImage(company_base_url +
                                    notificationList![index].notifyimage!),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 10.0, right: 10.0, bottom: 10.0, top: 30),
                    height: 35.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        Constants.language == "en" ? "CLOSE" : "أستمرار",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              Constants.language == "en" ? "Roboto" : "GSSFont",
                          fontSize: 18.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFF2CC0F),
                        textStyle: const TextStyle(color: Color(0xFFF2CC0F)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          // side: const BorderSide(
                          //   color: Colors.black,
                          //   width: 1.0,
                          // ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /*    Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:<Widget>[
            Container(
            margin:
            const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        height: 35.0,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            Constants.language == "en" ? "CLOSE" : "أستمرار",
            style: TextStyle(
              color: Colors.black,
              fontFamily:
              Constants.language == "en" ? "Roboto" : "GSSFont",
              fontSize: 18.0,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFFF2CC0F),
            textStyle: const TextStyle(color: Color(0xFFF2CC0F)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              // side: const BorderSide(
              //   color: Colors.black,
              //   width: 1.0,
              // ),
            ),
          ),
        ),
      ),
                ]
            ),*/
            ],
          ),
        ),
      ),
    );

    String discountPrice = "0.000";
    String payPrice = "0.000";

    if (widget.which_page == "purchase") {
      double discount_price = double.parse(notificationList![index].amount!);
      discountPrice = discount_price.toStringAsFixed(3);
      double pay_price = double.parse(notificationList![index].discountAmout!);
      payPrice = pay_price.toStringAsFixed(3);
    }
    Dialog purchaseDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: SizedBox(
        height: 550,
        width: width,
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                SizedBox(
                  height: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      IconButton(
                        iconSize: 30.0,
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        icon: const Icon(CupertinoIcons.clear_circled_solid),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 96,
                  top: 10.0,
                  right: 96,
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.only(top: 20.0, right: 12.0),
                          child: Container(
                            width: width * 0.25,
                            height: 45,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2CC0F),
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0)),
                            ),
                            child: Center(
                                child: Text(
                              Constants.city_code,
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                        Positioned(
                          child: Container(
                            width: 30,
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2CC0F),
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.star,
                                color: Colors.black,
                                size: 24.0,
                              ),
                            ),
                          ),
                          bottom: 24.0,
                          left: 77.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                Constants.language == "en"
                    ? "About to take advantage of discounts"
                    : "على وشك الاستفاده من خصومات",
                style: TextStyle(
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                Constants.language == "en"
                    ? notificationList![index].companyName!
                    : notificationList![index].companyArbName!,
                style: TextStyle(
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                Constants.language == "en"
                    ? notificationList![index].branchName!
                    : notificationList![index].branchArbName!,
                style: TextStyle(
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 220.0,
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF2CC0F),
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Text(
                          notificationList![index].coupontype == "coupon"
                              ? Constants.language == "en"
                                  ? "Coupon Amount"
                                  : "خصومات القسيمة"
                              : Constants.language == "en"
                                  ? "Discounts"
                                  : "الخصم",
                          style: TextStyle(
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            notificationList![index].coupontype == "coupon"
                                ? notificationList![index].discount!
                                : notificationList![index].discount! + "%",
                            style: const TextStyle(fontFamily: "Roboto"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    height: 1.0,
                    color: Colors.black,
                  ),
                  Visibility(
                    visible:
                        int.parse(notificationList![index].reddemPoint!) > 0
                            ? false
                            : true,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                notificationList![index].coupontype == "coupon"
                                    ? Constants.language == "en"
                                        ? "Purchasing Amount"
                                        : "مبلغ الشراء"
                                    : Constants.language == "en"
                                        ? "Amount Before Discount"
                                        : "المبلغ قبل الخصم",
                                style: TextStyle(
                                    fontFamily: Constants.language == "en"
                                        ? "Roboto"
                                        : "GSSFont",
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  discountPrice,
                                  style: const TextStyle(fontFamily: "Roboto"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          height: 1.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Text(
                          Constants.language == "en"
                              ? "Amount To Pay"
                              // : "المبلغ للدفع",
                              : " المبلغ الواجب دفعه ",
                          style: TextStyle(
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            payPrice,
                            style: const TextStyle(fontFamily: "Roboto"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    height: 1.0,
                    color: Colors.black,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Column(
                      children: [
                        Text(
                          Constants.language == "en"
                              ? "Use Points"
                              : "استخدم النقاط",
                          //:"النقاط القابلة للخصم",
                          style: TextStyle(
                              fontFamily: Constants.language == "en"
                                  ? "Roboto"
                                  : "GSSFont",
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            notificationList![index].reddemPoint!,
                            style: const TextStyle(fontFamily: "Roboto"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// adding && status=="1" below code
            Visibility(
              visible: status[index] == "2" && status == "1" ? true : false,
              child: Container(
                margin:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                height: 40.0,
                child: ElevatedButton(
                  onPressed: () async {
                    bool isSuccess = await acceptOffer(
                        notificationList![index].orderId!, index);
                    if (isSuccess) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                  child: Text(
                    Constants.language == "en" ? "Accept" : "قبول",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                          Constants.language == "en" ? "Roboto" : "GSSFont",
                      fontSize: 18.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFF2CC0F),
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
            ),
            Visibility(
              visible: status[index] == "3" ? true : false,
              child: Container(
                margin:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                child: Text(
                  Constants.language == "en"
                      ? "The offer is Expired"
                      : "العرض منتهي الصلاحية",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
              ),
            ),
            Visibility(
              visible: status[index] == "1" ? true : false,
              child: Container(
                margin:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                child: Text(
                  Constants.language == "en"
                      ? "Payment Succesfully."
                      : "نجاح الدفع.",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
              height: 40.0,
              child: ElevatedButton(
                onPressed: () async {
                  /*bool isSuccess = await acceptOffer(
                      notificationList![index].orderId!, index);
                  if (isSuccess) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }*/

                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text(
                  Constants.language == "en" ? "Done" : "قبول",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                    fontSize: 18.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFF2CC0F),
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
    );

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            isPurchase == "1" ? purchaseDialog : dialog);
  }

  Future<bool> acceptOffer(String order_id, int index) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "od_id": order_id,
        "status": "true",
        "notificationtype": "company"
      };

      final response = await http.post(
        Uri.parse('http://185.188.127.11/public/index.php/accept'),
        body: body,
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 201) {
        setState(() {
          status[index] = "1";
        });
        if (response_server["status"] == 201) {
          if (Constants.language == "en") {
            _alertDialog("Offer Accepted");
          } else {
            _alertDialog("تم القبول");
          }
          return true;
        } else {
          if (Constants.language == "en") {
            _alertDialog("Failed to accept offer");
          } else {
            _alertDialog("فشل قبول العرض");
          }
          return false;
        }
      } else {
        if (response.statusCode == 404) {
          if (Constants.language == "en") {
            _alertDialog("Failed to accept offer");
          } else {
            _alertDialog("فشل قبول العرض");
          }
        } else {
          if (Constants.language == "en") {
            _alertDialog("Something went wrong");
          } else {
            _alertDialog("هناك خطأ ما");
          }
        }
        return false;
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      return false;
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
