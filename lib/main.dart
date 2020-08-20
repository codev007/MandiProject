import 'package:flutter/material.dart';
import 'package:mandi/style/colors.dart' as CustomColors;
import 'package:mandi/views/FlashScreen.dart';
void main() async {
  // then render the app on screen
  runApp(MyApp());
}

final routes = {
  '/': (BuildContext context) => new FlashScreen(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(

      debugShowCheckedModeBanner: false,
      //    routes: routes,
      routes: routes,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: CustomColors.MandiColor.white,
        accentColor: CustomColors.MandiColor.primaryColor,
        primaryColorDark: CustomColors.MandiColor.primaryColor,
        primaryIconTheme: Theme.of(context)
            .primaryIconTheme
            .copyWith(color: CustomColors.MandiColor.primaryColor),
      ),
    );
  }
}