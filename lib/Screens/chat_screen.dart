// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_final_fields, unused_element, unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'package:city_code/Screens/home_screen.dart';
import 'package:city_code/Screens/member_code_screen.dart';
import 'package:city_code/models/chat_model.dart';
import 'package:city_code/utils/constants.dart';
import 'package:city_code/utils/network_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../models/user_details_model.dart';

class ChatScreen extends StatefulWidget {
  String company_name,
      company_image,
      sender_id,
      receiver_id,
      product_image,
      product_details,
      page,
      sender_image,
      isuserhome,
      isCompanyHome;

  ChatScreen(
      this.company_name,
      this.company_image,
      this.sender_id,
      this.receiver_id,
      this.product_image,
      this.product_details,
      this.page,
      this.sender_image,
      this.isuserhome,
      this.isCompanyHome,
      {Key? key})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  String user_image = "";
  String user_name = "", mobileNo = "", unseen_id = "";

  bool _isLoading = true;
  List<Users>? usersChatList = [];
  List<String> isImageAvailable = [];
  late Timer timer;
  ScrollController controller = ScrollController();
  TextEditingController _message_controller = TextEditingController();
  NetworkCheck networkCheck = NetworkCheck();
  final ScrollController _scrollController = ScrollController();
  late Route newRoute1, newRoute2;

  Future<ChatModel> _receiveChat() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "sender_id": widget.sender_id,
        "receiver_id": widget.receiver_id
      };

      final response = await http.post(
        Uri.parse(
            "http://185.188.127.11/public/index.php/ApiUsers/ChatDetalis"),
        body: body,
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print("response:- " + response_server.toString());
      }

      if (response.statusCode == 201) {
        if (response_server["response"] == "success") {
          return ChatModel.fromJson(json.decode(response.body));
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
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load album');
    }
  }

  Future<void> _sendChat(String isProduct) async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final body = {
        "sender_id": widget.sender_id,
        "receiver_id": widget.receiver_id,
        "send_by":
            widget.sender_id == Constants.user_id ? "customer" : "company",
        "msg": isProduct == "1"
            ? widget.product_details
            : isProduct == "2"
                ? "My Name is: $user_name\nMobile No.: $mobileNo"
                : _message_controller.text,
        "image": isProduct == "1" ? widget.product_image : ""
      };
      _message_controller.text = "";
      isConnected = false;

      final response = await http.post(
        Uri.parse("http://185.188.127.11/public/index.php/ApiUsers/Chat"),
        body: body,
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print("response:- " + response.statusCode.toString());
      }

      if (response.statusCode == 201) {
        if (response_server["response"] == "success") {
          setState(() {
            _message_controller.text = "";
          });
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
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load album');
    }
  }

  Future<User_details_model> getUserDetails() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(
        Uri.parse('http://185.188.127.11/public/index.php/ApiUsers/' +
            Constants.user_id),
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 200) {
        if (response_server["status"] == 201) {
          return User_details_model.fromJson(json.decode(response.body));
        } else {
          // setState(() {
          //   _isLoading = false;
          // });
          // if (Constants.language == "en") {
          //   _alertDialog("No Data Found");
          // } else {
          //   _alertDialog("لاتوجد بيانات");
          // }
          throw Exception('Failed to load album');
        }
      } else {
        // setState(() {
        //   _isLoading = false;
        // });
        if (response.statusCode == 404) {
          // if (Constants.language == "en") {
          //   _alertDialog("No Data Found");
          // } else {
          //   _alertDialog("لاتوجد بيانات");
          // }
        } else {
          // if (Constants.language == "en") {
          //   _alertDialog("Something went wrong");
          // } else {
          //   _alertDialog("هناك خطأ ما");
          // }
        }
        throw Exception('Failed to load album');
      }
    } else {
      _alertDialog(Constants.language == "en"
          ? "Please connect to internet"
          : "الرجاء الاتصال بالإنترنت");
      setState(() {
        _isLoading = false;
      });
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

  Future<void> _changeStatus() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/messagestatus?chatid=$unseen_id'));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }

        if (response_server["status"] == 201) {
          setState(() {
            unseen_id = "";
          });
        } else {
          throw Exception('Failed to load album');
        }
      } else {
        throw Exception('Failed to load album');
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> _sendOnChat() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/insertchatstatus?senderid=${widget.sender_id}&receiverid=${widget.receiver_id}'));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }

        if (response_server["status"] == 201) {
        } else {
          throw Exception('Failed to load album');
        }
      } else {
        throw Exception('Failed to load album');
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> _deleteOnChat() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(Uri.parse(
          'http://185.188.127.11/public/index.php/delchatstatus?senderid=${widget.sender_id}&receiverid=${widget.receiver_id}'));
      if (response.statusCode == 201) {
        var response_server = jsonDecode(response.body);

        if (kDebugMode) {
          print(response_server);
        }

        if (response_server["status"] == 201) {
        } else {
          throw Exception('Failed to load album');
        }
      } else {
        throw Exception('Failed to load album');
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  _hitReceiveApi() async {
    bool isScroll = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _receiveChat().then((value) async => {
            if (value.users != null && value.users!.isNotEmpty)
              {
                if (usersChatList!.isEmpty ||
                    usersChatList!.length < value.users!.length)
                  {
                    for (int i = usersChatList!.length;
                        i < value.users!.length;
                        i++)
                      {
                        setState(() {
                          if (value.users![i].receiverId == widget.sender_id &&
                              value.users![i].seenStatus == "unseen") {
                            if (unseen_id.isNotEmpty) {
                              unseen_id = "$unseen_id,${value.users![i].id!}";
                            } else {
                              unseen_id = value.users![i].id!;
                            }
                          }
                          if (value.users![i].image != null &&
                              value.users![i].image!.isNotEmpty &&
                              value.users![i].image != "null") {
                            isImageAvailable.add("1");
                          } else {
                            isImageAvailable.add("0");
                          }
                          usersChatList!.add(value.users![i]);
                        }),
                      },
                    if (unseen_id.isNotEmpty)
                      {
                        _changeStatus(),
                      },
                    setState(() {
                      isScroll = true;
                    }),
                  }
                else
                  {
                    setState(() {
                      isScroll = false;
                    }),
                  }
              },
            setState(() {
              _isLoading = false;
            }),
            if (isScroll)
              {
                await Future.delayed(const Duration(milliseconds: 300)),
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn);
                }),
              },
          });
    });
    if (widget.product_image.isNotEmpty) {
      _sendChat("1");
    }
  }

  void _goToElement() {
    if (controller.hasClients) {
      controller.animateTo(controller.position.maxScrollExtent,
          duration: const Duration(microseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _sendOnChat();
    } else {
      _deleteOnChat();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _sendOnChat();
    Constants.chat_data = "";
    _hitReceiveApi();
    if (widget.page == "user") {
      getUserDetails().then((value) => {
            if (value.userdetail != null && value.userdetail!.isNotEmpty)
              {
                setState(() {
                  user_image = value.userurl! + value.userdetail![0].profile!;
                  user_name = Constants.language == "en"
                      ? value.userdetail![0].name!
                      : value.userdetail![0].arbName!.isNotEmpty
                          ? value.userdetail![0].arbName!
                          : value.userdetail![0].name!;
                  mobileNo = value.userdetail![0].mobile!;
                }),
              },
            // _sendChat("2"),
          });
    } else {
      setState(() {
        user_image = widget.sender_image;
      });
    }
    super.initState();
  }

  Future<bool> _onBackPressed() async {
    if (widget.isuserhome == "1") {
      _deleteOnChat();
      Navigator.of(context).pushAndRemoveUntil(newRoute1, (route) => false);
    } else if (widget.isCompanyHome == "1") {
      _deleteOnChat();
      Navigator.of(context).pushAndRemoveUntil(newRoute2, (route) => false);
    }
    _deleteOnChat();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    newRoute1 = MaterialPageRoute(builder: (context) => HomeScreen("0", ""));
    newRoute2 =
        MaterialPageRoute(builder: (context) => const MemberCodeScreen());
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFFF2CC0F),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.arrow_left),
            color: Colors.black,
            onPressed: () {
              if (widget.isuserhome == "1") {
                _deleteOnChat();
                Route newRoute = MaterialPageRoute(
                    builder: (context) => HomeScreen("0", ""));
                Navigator.of(context)
                    .pushAndRemoveUntil(newRoute, (route) => false);
              } else if (widget.isCompanyHome == "1") {
                _deleteOnChat();
                Route newRoute = MaterialPageRoute(
                    builder: (context) => const MemberCodeScreen());
                Navigator.of(context)
                    .pushAndRemoveUntil(newRoute, (route) => false);
              } else {
                _deleteOnChat();
                Navigator.of(context).pop();
              }
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.company_image),
                radius: 20.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.company_name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Scaffold(
            bottomNavigationBar: SizedBox(
              height: height * 0.10,
              width: width,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 0.5),
                child: Row(
                  children: [
                    SizedBox(
                      width: width * 0.80,
                      child: TextField(
                        controller: _message_controller,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: Constants.language == "en"
                              ? "Enter Message"
                              : "أدخل رسالة",
                          hintStyle: TextStyle(
                            color: Colors.black45,
                            fontFamily: Constants.language == "en"
                                ? "Roboto"
                                : "GSSFont",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 4.0),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        color: const Color(0xFFF2CC0F),
                        onPressed: () async {
                          if (_message_controller.text.isNotEmpty) {
                            await _sendChat("0");
                            _message_controller.clear();

                            setState(() {
                              _message_controller.text = "";
                              _message_controller.clear();
                            });
                          }
                          _message_controller.text = "";
                          _message_controller.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                SizedBox(
                  height: height,
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: usersChatList!.length,
                      itemBuilder: (context, index) {
                        var previous_datetime = index == 0
                            ? []
                            : usersChatList![index - 1].createdDate!.split(" ");
                        var date_time =
                            usersChatList![index].createdDate!.split(" ");
                        String date = date_time[0];
                        String previous_date =
                            index == 0 ? "" : previous_datetime[0];
                        String time = date_time[1];
                        if (usersChatList![index].senderId! ==
                            widget.sender_id) {
                          return Container(
                            margin: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                  index == 0
                                      ? usersChatList![index].createdDate!
                                      : date != previous_date
                                          ? date
                                          : "",
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        child: Text(
                                          time,
                                          style: const TextStyle(
                                              color: Colors.black45),
                                        ),
                                        margin:
                                            const EdgeInsets.only(right: 5.0),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 15,
                                            ),
                                            width: 150,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                bottomRight:
                                                    Radius.circular(30),
                                              ),
                                              color: Color(0xFFC0C0C0),
                                            ),
                                            child: Column(
                                              children: [
                                                Visibility(
                                                  visible:
                                                      isImageAvailable[index] ==
                                                              "1"
                                                          ? true
                                                          : false,
                                                  child: Image(
                                                    image: NetworkImage(
                                                        usersChatList![index]
                                                                    .image !=
                                                                null
                                                            ? usersChatList![
                                                                    index]
                                                                .image!
                                                            : ""),
                                                    width: 100.0,
                                                    height: 100.0,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    usersChatList![index].msg!,
                                                    maxLines: 10,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      top: isImageAvailable ==
                                                              "1"
                                                          ? 10.0
                                                          : 0.0),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(10.0),
                                          ),
                                          CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(user_image),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            width: width,
                            margin: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                  index == 0
                                      ? date
                                      : date != previous_date
                                          ? date
                                          : "",
                                  style: const TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(widget.company_image),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 15),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                          color: Color(0xFFC0C0C0),
                                        ),
                                        child: Column(
                                          children: [
                                            Visibility(
                                              visible:
                                                  isImageAvailable[index] == "1"
                                                      ? true
                                                      : false,
                                              child: Image(
                                                image: NetworkImage(
                                                    usersChatList![index]
                                                                .image !=
                                                            null
                                                        ? usersChatList![index]
                                                            .image!
                                                        : ""),
                                                width: 100.0,
                                                height: 100.0,
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                usersChatList![index].msg!,
                                                maxLines: 10,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              margin: EdgeInsets.only(
                                                  top: isImageAvailable == "1"
                                                      ? 10.0
                                                      : 0.0),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(10.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }),
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
      ),
    );
  }
}
