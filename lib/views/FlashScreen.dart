import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mandi/server/SharedDatabase.dart';
import 'package:mandi/style/animation.dart';
import 'package:mandi/style/design.dart';
import 'package:mandi/style/icons.dart';
import 'package:mandi/views/Home.dart';
import 'package:mandi/views/Login.dart';

class FlashScreen extends StatefulWidget {
  @override
  _FlashScreenState createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  String userName;

  _data() async {
    String name = await SharedDatabase().getName();
    setState(() {
      userName = name;
    });
    if (userName != null) {
      Timer(
          Duration(seconds: 2),
          () => Navigator.of(context)
              .pushReplacement(FadeRouteBuilder(page: Home())));
    } else {
      Timer(
          Duration(seconds: 2),
          () => Navigator.of(context)
              .pushReplacement(FadeRouteBuilder(page: Login())));
    }
  }

  @override
  void initState() {
    this._data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: MandiDesign().bacgroundDesign(),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                height: 100.0,
                child: Image.asset(
                  MandiIcons().logo,
                ),
              ),
              Container(
                child: Text(
                  "Mandi Bhaw",
                  style: MandiDesign().boldTextDesign(),
                ),
              ), //
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Know the price of mandi now",
                  style: TextStyle(fontSize: 15.0),
                ),
              ), //मंडी के भाव अभी जान लें
              Container(
                child: Text(
                  "मंडी के भाव अभी जान लें",
                  style: TextStyle(fontSize: 15.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
