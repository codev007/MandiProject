import 'package:mandi/style/colors.dart' as CustomColor;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mandi/style/fonts.dart';

class MandiDesign {
  hollowButtonDesign() {
    return BoxDecoration(
        color: CustomColor.MandiColor.primaryColor,
        border:
            Border.all(width: 1, color: CustomColor.MandiColor.primaryColor),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ));
  }

  dropdownDesign() {
    return BoxDecoration(
        color: Colors.black12,
        //     border: Border.all(width: 1, color: CustomColor.BybriskColor.primaryColor),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ));
  }

  hollowsubmitDesign() {
    return BoxDecoration(
        //     color: CustomColor.BybriskColor.white,
        border:
            Border.all(width: 0.50, color: CustomColor.MandiColor.textPrimary),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ));
  }

  spacer() {
    return Container(
      height: 1.0,
      color: CustomColor.MandiColor.textSecondary,
    );
  }

  bigSpacer() {
    return Container(
      height: 6.0,
      color: Colors.black12,
    );
  }

  void showInSnackBar(String value, GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(value),
        duration: Duration(milliseconds: 1000),
      ),
    );
  }

  bacgroundDesign() {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
          Colors.orange,
          Colors.orangeAccent,
          Colors.white,
          Colors.white,
          Colors.white
        ]));
  }

  boldTextDesign() {
    return TextStyle(fontFamily: Mandifont().medium, fontSize: 20.0);
  }
}
