import 'package:flutter/material.dart';

class Style {
  //mainStyle theme
  static ThemeData mainstyle() {
    return ThemeData(
      primaryColor: Color.fromRGBO(158, 25, 25, 1),
      primaryColorLight: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      accentColor: Color.fromRGBO(158, 25, 25, 1),
      primaryColorDark: Color.fromRGBO(6, 6, 6, 1),
      iconTheme: IconThemeData(color: Colors.black),
    );
  }

  // Dark Theme
  static ThemeData darkStyle() {
    return ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        accentColor: Colors.white,
        primaryColorDark: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        cardColor: Colors.black,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ));
  }
}
