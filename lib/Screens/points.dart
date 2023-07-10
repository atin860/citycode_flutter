// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:city_code/models/Newclass.dart';
import 'package:city_code/models/buypointsmodel.dart';
import 'package:city_code/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuyPoints extends StatefulWidget {
  const BuyPoints({Key? key}) : super(key: key);

  @override
  State<BuyPoints> createState() => _BuyPointsState();
}

class _BuyPointsState extends State<BuyPoints> {
  List<Buypointslist> VendorCatList = [];

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                "Buy Points",
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                /* ListView.builder(
                shrinkWrap: true,
                itemCount: VendorCatList.length,
                itemBuilder: (context, index) {
                  return customRadio(VendorCatList[index].points==null?"":VendorCatList[index].points!.toString(),1,VendorCatList[index].points==null?"":VendorCatList[index].points!.toString());

                }
            ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width * 1,
                      //  color: const Color(0xFFF2CC0F),
                      child: Center(
                          child: Text(
                        Constants.language == "en"
                            ? "Price list for Points"
                            : "قائمة أسعار النقاط",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                          customRadio(
                              VendorCatList[0].points == null
                                  ? ""
                                  : VendorCatList[0].points!.toString(),
                              50,
                              VendorCatList[0].points == null
                                  ? ""
                                  : VendorCatList[0].points!.toString()),
                          Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                Constants.language == "en" ? "Points " : "نقاط",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )),
                          const SizedBox(
                            width: 49,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Column(
                              children: [
                                customRadio(
                                    VendorCatList[3].points == null
                                        ? ""
                                        : VendorCatList[3].points!.toString(),
                                    8,
                                    ""),
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                  Constants.language == "en"
                                      ? "Points "
                                      : "نقاط",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: <Widget>[
                          customRadio(
                              VendorCatList[1].points == null
                                  ? ""
                                  : VendorCatList[1].points!.toString(),
                              60,
                              ""),
                          //  SizedBox(width: 10,),
                          Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                  Constants.language == "en"
                                      ? "Points "
                                      : "نقاط",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Column(
                              children: [
                                customRadio(
                                    VendorCatList[0].points == null
                                        ? ""
                                        : VendorCatList[0].points!.toString(),
                                    2,
                                    ""),

                                // customRadio(VendorCatList[4].points==null?"":VendorCatList[4].points!.toString(), 150,""),
                              ],
                            ),
                          ),
                          // SizedBox(width: 10,),
                          Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                  Constants.language == "en"
                                      ? "Points "
                                      : "نقاط",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          customRadio(
                              VendorCatList[2].points == null
                                  ? ""
                                  : VendorCatList[2].points!.toString(),
                              600,
                              ""),
                          // SizedBox(width: 10,),
                          Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                  Constants.language == "en"
                                      ? "Points "
                                      : "نقاط",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Column(
                              children: [
                                customRadio(
                                    VendorCatList[0].points == null
                                        ? ""
                                        : VendorCatList[0].points!.toString(),
                                    200,
                                    ""),

                                //   customRadio(VendorCatList[5].points==null?"":VendorCatList[5].points!.toString(), 200,""),
                              ],
                            ),
                          ),
                          //SizedBox(width: 10,),
                          Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                  Constants.language == "en"
                                      ? "Points "
                                      : "نقاط",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
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
                      child: Text(
                        Constants.language == "en" ? "Amount " : "مقدار",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                      Constants.language == "en" ? " Pay now" : "أدفع الان",
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
          )
        ],
      ),
      /* Container(
        margin: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {

                */ /* if (VendorCatList[index].categoryName.toString() ==
                          "AC/ Appliance Repair") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubCatagoriesScreen(
                                    VendorCatList[index]
                                        .categoryName
                                        .toString())));
                      }
                      else if (VendorCatList[index]
                              .categoryName
                              .toString() ==
                          "General Store") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubSubCategoriesScreen(
                                    VendorCatList[index]
                                        .categoryName
                                        .toString())));

                      }


                      else {
                        _alertDialog();
                      }*/ /*
              },
              child: Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border:
                    Border.all(color: Color(0xFFFFAE00), width: 2),
                    color: const Color(0xFF3A3A3A)),
                // color: const Color(0xFF3A3A3A),
                */ /*    shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),

                        ),*/ /*
                child: Container(
                  */ /*  margin: const EdgeInsets.only(
                            left: 10.0, top: 10.0, bottom: 10.0),*/ /*
                  child: Column(
                    children: [
                      Container(
                        margin:EdgeInsets.only(top: 17),
                        // margin: const EdgeInsets.only(
                        //     left: 0.0, top: 10.0, bottom: 10.0),
                      ),
                      Container(
                        margin:  EdgeInsets.all(
                            10.0),
                       */ /* child: Text(
*/ /**/ /*
                                VendorCatList[index]
                                    .categoryName
                                    .toString(),*/ /**/ /*
                          VendorCatList[index].points==null?"":VendorCatList![index].points!.toString(),



                          style: const TextStyle(
                            color: Color(0xFFFFAE00),
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),*/ /*
                       child: customRadio(VendorCatList[index].points==null?"":VendorCatList![index].points!.toString(),0,0),
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: VendorCatList == null ? 0 : VendorCatList.length,
          //      itemCount:  VendorCatList == null ? 0 : (VendorCatList.length > 33 ? 33 : VendorCatList.length),

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
        ),
      ),*/
    );
  }

  // ignore: must_call_super
  @override
  void initState() {
    super.initState();

    getdata();
  }

  Future<void> getdata() async {
    String url = "http://185.188.127.11/public/index.php/showbuypoints";
    var network = NewVendorApiService();
    var res = await network.getresponse(url);
    var vlist = Pointbuys.fromJson(res);
    setState(() {
      _isLoading = false;
    });
    setState(() {
      VendorCatList = vlist.buypointslist!;
    });
    setState(() {
      _isLoading = false;
    });
    print("" + res!.toString());
  }

  int selectedindex = 1;
  int selectedamount = 0;
  Widget customRadio(String txt, int index, String value) {
    return GestureDetector(
      onTap: () {
        changeindex(index);
      },
      child: Container(
        // margin: EdgeInsets.only(20),
        height: 80.0,
        width: 120.0,
        child: Center(
          child: Text(txt,
              style: TextStyle(
                  color: selectedindex == index ? Colors.black : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0)),
        ),
        decoration: BoxDecoration(
          color: selectedindex == index ? Colors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
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
}
