import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mandi/server/SharedDatabase.dart';
import 'package:mandi/style/animation.dart';
import 'package:mandi/style/design.dart';
import 'package:mandi/style/icons.dart';
import 'package:mandi/style/colors.dart' as CustomColor;
import 'package:mandi/views/OtoVerification.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Timer timer;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _mobile = new TextEditingController();
  String _verificationId = "STATUS_OK";
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isVerifing = false;
  @override
  void initState() {
    _auth.signOut();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      this.isLogin();
    });
    super.initState();
  }

  isLogin() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      if (user.uid != null) {
        setState(() {
          isVerifing = false;
          SharedDatabase().setMobile(_mobile.text);
        });
        /*
        Navigator.of(context)
            .pushReplacement(FadeRouteBuilder(page: SignUp(_verificationId)));
            */
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: null,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            padding: EdgeInsets.all(15.0),
            color: CustomColor.MandiColor.primaryColor,
            onPressed: () {
              if (_mobile.text.length > 9 && !isVerifing) {
                setState(() {
                  isVerifing = true;
                });
                _verifyPhoneNumber();
              } else {
                MandiDesign()
                    .showInSnackBar("Invalid mobile number !", _scaffoldKey);
              }
            },
            child: Text(
              "NEXT",
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
                      "Mobile Number".toUpperCase(),
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "अपना मोबाइल नंबर दर्ज करें".toUpperCase(),
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: TextField(
                              enabled: !isVerifing,
                              scrollPhysics: NeverScrollableScrollPhysics(),
                              keyboardType: TextInputType.phone,
                              textAlign: TextAlign.left,
                              controller: _mobile,
                              onChanged: (value) {
                                if (value.length == 10) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: "Enter mobile number",
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide: BorderSide(
                                          color: Colors.black12, width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide: BorderSide(
                                          color: Colors.black12, width: 2.0))),
                            ),
                          ),
                        ),
                        isVerifing
                            ? Container(
                                margin: EdgeInsets.only(left: 10.0),
                                width: 30.0,
                                height: 30.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                ))
                            : Container()
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "By signing in, you agree with our Terms of Use and Privacy Policy",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 15.0,
                          color: CustomColor.MandiColor.primaryColor),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 50.0),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "साइन इन करके, आप हमारी उपयोग की शर्तों और गोपनीयता नीति से सहमत हैं",
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

  //  code of  verify phone number
  void _verifyPhoneNumber() async {
    setState(() {});
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        isVerifing = false;
        _popupDialog(context);
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) {
      setState(() {
        isVerifing = false;
        SharedDatabase().setMobile(_mobile.text);
      });
      Navigator.of(context)
          .pushReplacement(FadeRouteBuilder(page: SignUp(verificationId)));
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: '+91' + _mobile.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _popupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Validation Error'),
            content:
                Text('Sorry your mobile number is invalid ! Please try again'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _mobile.clear();
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
