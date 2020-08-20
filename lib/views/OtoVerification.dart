import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mandi/server/SharedDatabase.dart';
import 'package:mandi/style/animation.dart';
import 'package:mandi/style/design.dart';
import 'package:mandi/style/colors.dart' as CustomColor;
import 'package:mandi/style/icons.dart';
import 'package:mandi/views/Home.dart';
import 'package:uuid/uuid.dart';

class SignUp extends StatefulWidget {
  final String _verifiedID;
  SignUp(this._verifiedID, {Key key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Timer timer;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String mandiName;
  String mobileNumber = "";
  String _name = '', _otp = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;
  bool isVerifing = false;
  var uuid = new Uuid();
  FirebaseUser user;
  var mandiList = ["Shajpur", "Shujalpur", "Indore", "Bhopal"];
  getData() async {
    String mob = await SharedDatabase().getMobile();
    setState(() {
      _verificationId = widget._verifiedID;
      mobileNumber = mob;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  isLogin() async {
    FirebaseUser usr = await _auth.currentUser();
    if (usr != null) {
      if (usr.uid != null) {
        setState(() {
          user = usr;
        });
      }
    }
  }

  @override
  void initState() {
    getData();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      this.isLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: null,
      bottomNavigationBar: isVerifing
          ? Container(
              alignment: Alignment.center,
              width: 30.0,
              height: 30.0,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
              ))
          : Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  padding: EdgeInsets.all(15.0),
                  color: CustomColor.MandiColor.primaryColor,
                  onPressed: () {
                    if (_name.length > 0 && mandiName != null) {
                      setState(() {
                        isVerifing = true;
                      });
                      if (user != null) {
                        SharedDatabase().setProfileData(uuid.v1().toString(),
                            _name, mobileNumber, "MANDI_USER", mandiName);
                        Navigator.of(context)
                            .push(FadeRouteBuilder(page: Home()));
                      } else {
                        _signInWithPhoneNumber();
                      }
                    } else {
                      MandiDesign()
                          .showInSnackBar("Feilds are missing !", _scaffoldKey);
                    }
                  },
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            decoration: MandiDesign().bacgroundDesign(),
            child: Padding(
              padding: EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
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
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(top: 50.0),
                    child: Text(
                      "Your name",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: TextField(
                      scrollPhysics: NeverScrollableScrollPhysics(),
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.left,
                      onChanged: (value) {
                        setState(() {
                          this._name = value;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your name",
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(
                                  color: Colors.black12, width: 2.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(
                                  color: Colors.black12, width: 2.0))),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 7.0),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Select Your Mandi",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(
                        top: 5.0, bottom: 10.0, left: 10.0, right: 10.0),
                    child: DropdownButton(
                      isExpanded: true,
                      hint: Text(
                        "Select Mandi",
                        style: TextStyle(color: Colors.black),
                      ),
                      items: mandiList.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item.toString()),
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
                  user != null && user.uid != null
                      ? Container()
                      : Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "OTP",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                  user != null && user.uid != null
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: TextField(
                            scrollPhysics: NeverScrollableScrollPhysics(),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              setState(() {
                                this._otp = value;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Enter your otp",
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                        color: Colors.black12, width: 2.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                        color: Colors.black12, width: 2.0))),
                          ),
                        ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(top: 10.0, bottom: 50.0),
                    child: Text(
                      "Auto verifying the OTP sent on " + mobileNumber,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 15.0,
                          color: CustomColor.MandiColor.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: _otp,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      if (user.uid == currentUser.uid) {
        assert(user.uid == currentUser.uid);
        setState(() {
          if (user != null) {
            if (_name.length > 0 && mandiName != null) {
              SharedDatabase().setProfileData(uuid.v1().toString(), _name,
                  mobileNumber, "MANDI_USER", mandiName);
              Navigator.of(context).push(FadeRouteBuilder(page: Home()));
            } else {
              MandiDesign().showInSnackBar("Something missing !", _scaffoldKey);
            }
          } else {
            setState(() {
              isVerifing = false;
            });
            _popupDialog(context);
          }
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _popupDialog(context);
        isVerifing = false;
      });
    }
  }

  void _popupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Validation Error'),
            content: Text('Sorry your OTP is invalid ! Please try again'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _otp = '';
                      isVerifing = false;
                    });
                  },
                  child: Text('OK')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('CANCEL')),
            ],
          );
        });
  }
}
