// ignore_for_file: camel_case_types, unused_field, prefer_final_fields, unnecessary_new, unused_element, unused_local_variable

import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class buypoints extends StatefulWidget {
  const buypoints({Key? key}) : super(key: key);

  @override
  State<buypoints> createState() => _buypointsState();
}

enum SingingCharacter { one, two, three, four }

class _buypointsState extends State<buypoints> {
  bool isChecked = false;

  // Buypointsmodel? invoiceData;
  /*Future<Buypointsmodel> getInvoiceData() async {
    final response = await http.get(Uri.parse(
        'http://185.188.127.11/public/index.php/showbuypoints'));
    if (response.statusCode == 201) {
      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }
      if (response_server["status"] == 201) {
        return Buypointsmodel.fromJson(jsonDecode(response.body));



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
      if (response.statusCode == 404) {
        if (Constants.language == "en") {
          _alertDialog("No Offers Available");
        } else {
          _alertDialog("لا توجد عروض متاحة");
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
  }*/
  List<String> list = ["20", "50", "100", "150", "200", "250"];
  List<int> amount = [20, 000, 3, 4, 5, 6, 7];
  int selectedindex = 1;
  int selectedamount = 0;
  bool _isLoading = true;

/*
 IconData iconlist=[Icons.star,Icons.star,Icons.code];
*/
  Widget customRadio(String txt, int index, int value) {
    return GestureDetector(
      onTap: () {
        changeindex(index);
      },
      child: Container(
        // margin: EdgeInsets.only(20),
        height: 90.0,
        width: 90.0,

        child: Center(
          child: Text(txt,
              style: new TextStyle(
                  color: selectedindex == index ? Colors.black : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0)),
        ),

        decoration: BoxDecoration(
          color: selectedindex == index ? Colors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(60),
          border: new Border.all(
              width: 3.0,
              color: selectedindex == index ? Colors.yellow : Colors.yellow),
        ),
        //  borderSide: BorderSide(color: selectedindex== index? Colors.pink:Colors.pink),
        /*  child: Text(txt,
          style: TextStyle
            (color: selectedindex==index?Colors.yellow:Colors.red),),*/
      ),
    );
  }

  void changeindex(int index) {
    setState(() {
      selectedindex = index;
      selectedamount = index;
    });
  }
  /*List<Buypointsmodel>? bupoints;
  Future<Buypointsmodel> _getCompanyDetails() async {
    print('http://185.188.127.11/public/index.php/showbuypoints');
    final response = await http.get(
      Uri.parse('http://185.188.127.11/public/index.php/showbuypoints'),
    );

    var responseServer = jsonDecode(response.body);

    if (kDebugMode) {
      print(responseServer);

    }

    if (response.statusCode == 200) {
      if (responseServer["status"] == 201) {
        return Buypointsmodel.fromJson(json.decode(response.body));
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
  }
  var response_server;
  Future<void> getpoint() async {
    final response = await http.get(
      Uri.parse('http://185.188.127.11/public/index.php/showbuypoints'),
    );

     response_server = Buypointsmodel.fromJson(json.decode(response.body));
    response_server.buypointslist![0].points.toString();


  }*/
  /* NetworkCheck networkCheck = NetworkCheck();

  Future<Buypointmodel> getbuypoints() async {
    bool isConnected = await networkCheck.isNetworkConnected();
    if (isConnected) {
      final response = await http.get(
        Uri.parse(
            'http://185.188.127.11/public/index.php/showbuypoints'),
      );

      var response_server = jsonDecode(response.body);

      if (kDebugMode) {
        print(response_server);
      }

      if (response.statusCode == 201) {
        if (response_server["status"] == 201) {
          return Buypointmodel.fromJson(json.decode(response.body));
        } else {
          setState(() {
            _isLoading = false;
          });
          if (Constants.language == "en") {
            _alertDialog("No Data Found");
          } else {
            _alertDialog("لاتوجد بيانات");
          }
          throw Exception('Failed to load album');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 404) {
          if (Constants.language == "en") {
            _alertDialog("No Data Found");
          } else {
            _alertDialog("لاتوجد بيانات");
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
  }*/

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    SingingCharacter? _character = SingingCharacter.one;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2CC0F),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 30.0),
              child: Text(
                "Buy Pointss",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFFF2CC0F),
              child: Column(children: const [
                Image(
                  image: AssetImage("images/app_icon.png"),
                ),
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width * 1,
                  //  color: const Color(0xFFF2CC0F),
                  child: const Center(
                      child: Text(
                    "Price list for Points",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ),
              ],
            ),
            Row(
              ///  crossAxisAlignment: CrossAxisAlignment,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      customRadio(list[0], 20, amount[1]),
                      Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: const Text(
                            "Points",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(
                        width: 49,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            customRadio(list[3], 150, amount[1]),
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: const Text("Points",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      customRadio(list[1], 50, amount[3]),
                      //  SizedBox(width: 10,),
                      Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: const Text("Points",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            customRadio(list[4], 200, amount[4]),
                          ],
                        ),
                      ),
                      // SizedBox(width: 10,),
                      Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: const Text("Points",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      customRadio(list[2], 100, amount[5]),
                      // SizedBox(width: 10,),
                      Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: const Text("Points",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            customRadio(list[5], 250, amount[6]),
                          ],
                        ),
                      ),
                      //SizedBox(width: 10,),
                      Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: const Text("Points",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                )
              ],
            ),

            /*   Row(
               mainAxisAlignment: MainAxisAlignment.center,

               children: <Widget>[
                Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(20),
                        height: 80.0,
                        width: 80.0,
                        child: new Center(
                          child: new Text("20",
                              style: new TextStyle(
                                  color:
                                  isChecked ? Colors.white : Colors.black,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 18.0)),
                        ),
                        decoration: new BoxDecoration(
                          color: isChecked
                              ? Colors.yellow
                              : Colors.transparent,
                          border: new Border.all(
                              width: 1.0,
                              color: isChecked
                                  ? Colors.yellow
                                  : Colors.yellow),
                            borderRadius: BorderRadius.circular(60)
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text("Points"),
                  ],
                ),

                Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(20),
                        height: 80.0,
                        width: 80.0,
                        child: new Center(
                          child: new Text("50",
                              style: new TextStyle(
                                  color:
                                  isChecked ? Colors.white : Colors.black,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 18.0)),
                        ),
                        decoration: new BoxDecoration(
                            color: isChecked
                                ? Colors.yellow
                                : Colors.transparent,
                            border: new Border.all(
                                width: 1.0,
                                color: isChecked
                                    ? Colors.yellow
                                    : Colors.yellow),
                            borderRadius: BorderRadius.circular(60)
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text("Points"),
                  ],
                ),

                Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isChecked = isChecked;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(20),
                        height: 80.0,
                        width: 80.0,
                        child: new Center(
                          child: new Text("100",
                              style: new TextStyle(
                                  color:
                                  isChecked ? Colors.white : Colors.black,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 18.0)),
                        ),
                        decoration: new BoxDecoration(
                            color: isChecked
                                ? Colors.yellow
                                : Colors.transparent,
                            border: new Border.all(
                                width: 1.0,
                                color: isChecked
                                    ? Colors.yellow
                                    : Colors.yellow),
                            borderRadius: BorderRadius.circular(60)
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text("Points")
                  ],
                ),

              ],
            ),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Column(
                 children: [
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         isChecked = isChecked;
                       });
                     },
                     child: Container(
                       margin: EdgeInsets.all(20),
                       height: 80.0,
                       width: 80.0,
                       child: new Center(
                         child: new Text("150",
                             style: new TextStyle(
                                 color:
                                 isChecked ? Colors.white : Colors.black,
                                 //fontWeight: FontWeight.bold,
                                 fontSize: 18.0)),
                       ),
                       decoration: new BoxDecoration(
                           color: isChecked
                               ? Colors.yellow
                               : Colors.transparent,
                           border: new Border.all(
                               width: 1.0,
                               color: isChecked
                                   ? Colors.yellow
                                   : Colors.yellow),
                           borderRadius: BorderRadius.circular(60)
                       ),
                     ),
                   ),
                   SizedBox(width: 10,),
                   Text("Points"),
                 ],
               ),

               Column(
                 children: [
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         isChecked = isChecked;
                       });
                     },
                     child: Container(
                       margin: EdgeInsets.all(20),
                       height: 80.0,
                       width: 80.0,
                       child: new Center(
                         child: new Text("200",
                             style: new TextStyle(
                                 color:
                                 isChecked ? Colors.white : Colors.black,
                                 //fontWeight: FontWeight.bold,
                                 fontSize: 18.0)),
                       ),
                       decoration: new BoxDecoration(
                           color: isChecked
                               ? Colors.yellow
                               : Colors.transparent,
                           border: new Border.all(
                               width: 1.0,
                               color: isChecked
                                   ? Colors.yellow
                                   : Colors.yellow),
                           borderRadius: BorderRadius.circular(60)
                       ),
                     ),
                   ),
                   SizedBox(width: 10,),
                   Text("Points"),
                 ],
               ),

               Column(
                 children: [
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         isChecked = isChecked;
                       });
                     },
                     child: Container(
                       margin: EdgeInsets.all(20),
                       height: 80.0,
                       width: 80.0,
                       child: new Center(
                         child: new Text("250",
                             style: new TextStyle(
                                 color:
                                 isChecked ? Colors.white : Colors.black,
                                 //fontWeight: FontWeight.bold,
                                 fontSize: 18.0)),
                       ),
                       decoration: new BoxDecoration(
                           color: isChecked
                               ? Colors.yellow
                               : Colors.transparent,
                           border: new Border.all(
                               width: 1.0,
                               color: isChecked
                                   ? Colors.yellow
                                   : Colors.yellow),
                           borderRadius: BorderRadius.circular(60)
                       ),
                     ),
                   ),
                   SizedBox(width: 10,),
                   Text("Points")
                 ],
               ),

             ],
           ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: const Text(
                    "Amount",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50, left: 10),
                  child: Text(
                    selectedamount.toString() + ".000 OMR",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 50.0, left: 10, right: 10),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Pay Now",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        Constants.language == "en" ? "Roboto" : "GSSFont",
                    fontSize: 18.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2CC0F),
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  fixedSize: Size(width, 50.0),
                ),
              ),
            ),
            /* Container(
              padding: EdgeInsets.all(12),
              child: Table(
                  border: TableBorder.all(), // Allows to add a border decoration around your table
                  children: [
                    TableRow(children :[
                      ListTile(
                        title: Center(child: const Text('Selcted Points')),

                      ),
                      Center(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('Points'),
                      )),
                      Center(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('Amount'),
                      )),
                    ]),
                    TableRow(children :[
                      ListTile(
                        title: const Text(''),
                        leading: Radio<SingingCharacter>(
                          value: SingingCharacter.one,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),


                      Center(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('200'),
                      )),
                      Center(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('2.000 OMR'),
                      )),
                    ]),
                    TableRow(children :[
                      ListTile(
                        title: const Text(''),
                        leading: Radio<SingingCharacter>(
                          value: SingingCharacter.two,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),

                      Center(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('500'),
                      )),
                      Center(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('10.000 OMR'),
                      )),
                    ]),
                    TableRow(children :[
                      ListTile(
                        title: const Text(''),
                        leading: Radio<SingingCharacter>(
                          value: SingingCharacter.three,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),

                      Center(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('1000'),
                      )),
                      Center(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('20.000 OMR'),
                      )),
                    ]),
                    TableRow(children :[
                      ListTile(
                        title: const Text(''),
                        leading: Radio<SingingCharacter>(
                          value: SingingCharacter.four,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),


                      Center(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('1500'),
                      )),
                      Center(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('30.000 OMR'),
                      )),
                    ]),

                  ]
              ),

            ),*/
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    //  getpoint();
    //_getCompanyDetails();
  }
}
