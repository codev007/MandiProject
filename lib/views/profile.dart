import 'dart:async';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mandi/server/SharedDatabase.dart';
import 'package:mandi/style/design.dart';
import 'package:mandi/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:mandi/style/colors.dart' as CustomColor;
import 'package:flutter/rendering.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  String businessName;
  String businessAddress;
  String businessMobile;
  String businessEmail;
  var mandiList = ["Shajapur", "Shujalpur", "Indore", "Bhopal"];
  bool isMandiEdit = false;
  _getProfileData() async {
    String tempName = await SharedDatabase().getName();
    String tempMobile = await SharedDatabase().getMobile();
    String tempEmail = await SharedDatabase().getType();
    String tempAddress = await SharedDatabase().getMandi();
    setState(() {
      businessName = tempName;
      businessEmail = tempEmail;
      businessAddress = tempAddress;
      businessMobile = tempMobile;
    });
  }

  @override
  void initState() {
    _getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: CustomColor.MandiColor.white),
        backgroundColor: CustomColor.MandiColor.primaryColor,
        elevation: 0.0,
        title: Text(
          "Profile",
          style: TextStyle(
              fontFamily: Mandifont().large,
              color: CustomColor.MandiColor.white,
              fontSize: 20.0),
        ),
      ),
      body: isLoading
          ? Center(
              child: SpinKitRipple(
                color: CustomColor.MandiColor.primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 30.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      "Name",
                      style: TextStyle(color: Colors.black45),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                    child: Text(
                      businessName,
                      style: TextStyle(
                          fontFamily: Mandifont().large,
                          color: CustomColor.MandiColor.textPrimary,
                          fontSize: 20.0),
                    ),
                  ),
                  MandiDesign().bigSpacer(),
                  Container(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    child: Text(
                      "Default Mandi",
                      style: TextStyle(color: Colors.black45),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: !isMandiEdit
                              ? Container(
                                  padding: EdgeInsets.only(
                                      left: 10.0, right: 10.0, bottom: 10.0),
                                  child: Text(
                                    businessAddress,
                                    style: TextStyle(
                                        fontFamily: Mandifont().large,
                                        color:
                                            CustomColor.MandiColor.textPrimary,
                                        fontSize: 20.0),
                                  ),
                                )
                              : Container(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
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
                                        isLoading = true;
                                      });
                                      Timer(Duration(seconds: 2), () {
                                        setState(() {
                                          businessAddress = newVal;
                                          isLoading = false;
                                        });
                                        if (newVal == businessAddress) {
                                          SharedDatabase()
                                              .setMandi(businessAddress);
                                        }
                                      });
                                    },
                                    value: businessAddress,
                                  ),
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (isMandiEdit) {
                                isMandiEdit = false;
                              } else {
                                isMandiEdit = true;
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Text(
                              isMandiEdit ? "Cancle" : "Edit Mandi",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  MandiDesign().bigSpacer(),
                  Container(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    child: Text(
                      "Mobile Number",
                      style: TextStyle(color: Colors.black45),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                    child: Text(
                      businessMobile,
                      style: TextStyle(
                          fontFamily: Mandifont().large,
                          color: CustomColor.MandiColor.textPrimary,
                          fontSize: 20.0),
                    ),
                  ),
                  Container(
                    height: 50.0,
                  )
                ],
              ),
            ),
    );
  }
}
