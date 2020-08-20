import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mandi/pojos/CropInfo.dart';
import 'package:mandi/server/SharedDatabase.dart';
import 'package:mandi/style/animation.dart';
import 'package:mandi/style/colors.dart' as CustomColor;
import 'package:mandi/style/design.dart';
import 'package:mandi/views/FlashScreen.dart';
import 'package:mandi/views/profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var cropList = List<CropInfo>();
  DateTime selectedDate = DateTime.now();
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var dayFormat = DateFormat('dd MMMM yyyy');
  String mandiName, userName, mobileNumber;
  var mandiList = ["Shajapur", "Shujalpur", "Indore", "Bhopal"];
  var crop =
      '[{"id": "1", "crop_name": "Rice", "min": "10,000", "max": "15,000"},{"id": "2", "crop_name": "Wheat", "min": "10,000", "max": "15,000"},{"id": "3", "crop_name": "Oat", "min": "10,000", "max": "15,000"},{"id": "4", "crop_name": "Bajra", "min": "10,000", "max": "15,000"},{"id": "5", "crop_name": "Mustard", "min": "10,000", "max": "15,000"},{"id": "6", "crop_name": "Rapeesed", "min": "10,000", "max": "15,000"}]';
  getData() async {
    String na = await SharedDatabase().getName();
    String mob = await SharedDatabase().getMobile();
    String mand = await SharedDatabase().getMandi();
    setState(() {
      userName = na;
      mobileNumber = mob;
      mandiName = mand;
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        cropList = (json.decode(crop) as List)
            .map((data) => new CropInfo.fromJson(data))
            .toList();
        isLoading = false;
      });
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1980, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    this.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
        return true;
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration:
                    BoxDecoration(color: CustomColor.MandiColor.primaryColor),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40.0,
                        backgroundColor: CustomColor.MandiColor.white,
                        child: Text(
                          userName[0],
                          style: TextStyle(fontSize: 30.0),
                        ),
                      ),
                      Container(
                        height: 5.0,
                      ),
                      Text(
                        userName,
                        style: TextStyle(
                            color: CustomColor.MandiColor.white,
                            fontSize: 18.0),
                      ),
                      Container(
                        height: 5.0,
                      ),
                      Text(
                        mobileNumber,
                        style: TextStyle(
                            color: CustomColor.MandiColor.white,
                            fontSize: 18.0),
                      )
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text(
                  'Profile',
                ),
                onTap: () {
                  Navigator.of(context).push(FadeRouteBuilder(page: Profile()));
                },
              ),
              ListTile(
                leading: Icon(Icons.graphic_eq),
                title: Text(
                  'Feedback',
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.chat_bubble_outline),
                title: Text(
                  'FAQ',
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text(
                  'Terms and Conditions',
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text(
                  'Privacy Policy',
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.arrow_back),
                title: Text(
                  'Logout',
                ),
                onTap: () {
                  _auth.signOut();
                  SharedDatabase().mLogout();
                  Navigator.of(context)
                      .pushReplacement(FadeRouteBuilder(page: FlashScreen()));
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: CustomColor.MandiColor.primaryColor,
          title: Text(
            "Welcome",
            style: TextStyle(color: CustomColor.MandiColor.white),
          ),
        ),
        body: isLoading
            ? Center(
                child: SpinKitRipple(
                  color: CustomColor.MandiColor.primaryColor,
                ),
              )
            : Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.black,
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.update,
                              color: Colors.orange,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Text(
                                "See new updates direct from the mandi , now\nमंडी से सीधे नए अपडेट देखें, अभी",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: RefreshIndicator(
                            onRefresh: _refresh,
                            child: SingleChildScrollView(child: _cropList())))
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _refresh() {
    setState(() {
      cropList.clear();
      isLoading = true;
    });
    this.getData();
  }

  _cropList() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomLeft,
          margin: EdgeInsets.only(top: 10.0, left: 10.0),
          child: Text(
            "Select mandi from here\nयहां से मंडी का चयन करें",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 15.0, color: CustomColor.MandiColor.primaryColor),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 15.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: DropdownButton(
                        hint: Text(
                          "Select Mandi",
                        ),
                        items: mandiList.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(
                              item.toString().toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400),
                            ),
                            value: item.toString(),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            mandiName = newVal;
                          });
                        },
                        value: mandiName,
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              dayFormat.format(selectedDate).toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: CustomColor.MandiColor.primaryColor,
                                  fontSize: 15.0),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _selectDate(context),
                            icon: Icon(Icons.date_range),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        MandiDesign().spacer(),
        Container(
          color: Colors.black12,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Row(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 10.0),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.spa,
                        size: 20.0,
                      )),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Name",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                    ),
                  ),
                ],
              )),
              Expanded(
                  child: Row(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 10.0),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_downward,
                        size: 20.0,
                      )),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Lowest",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                    ),
                  ),
                ],
              )),
              Expanded(
                  child: Row(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 10.0),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_upward,
                        size: 20.0,
                      )),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Highest",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
        MandiDesign().spacer(),
        Container(
          margin: EdgeInsets.only(top: 8.0, bottom: 20.0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cropList.length,
              itemBuilder: (BuildContext contex, int index) {
                return _cropRow(cropList[index], index);
              }),
        ),
        MandiDesign().bigSpacer(),
        Container(
          height: 100.0,
        )
      ],
    );
  }

  _cropRow(CropInfo cropInfo, int index) {
    return Container(
      //   color: index % 2 == 0 ? Colors.blue[50] : Colors.blue[100],
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                cropInfo.cropName,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8.0),
              child: Text(
                cropInfo.min,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(8.0),
              child: Text(
                cropInfo.max,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
