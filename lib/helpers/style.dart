import 'package:flutter/material.dart';

class Style {
  //mainStyle theme
  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: Color.fromRGBO(158, 25, 25, 1),
      primaryColorLight: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      accentColor: Color.fromRGBO(158, 25, 25, 1),
      primaryColorDark: Color.fromRGBO(6, 6, 6, 1),
      iconTheme: IconThemeData(color: Color.fromRGBO(163, 163, 163, 1)),
    );
  }

  // Dark Theme
  static ThemeData darkTheme() {
    return ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        accentColor: Colors.white,
        primaryColorDark: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        cardColor: Colors.black,
        textTheme: TextTheme(
          headline6: TextStyle(color: Colors.white),
          subtitle1: TextStyle(color: Colors.white),
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ));
  }
}
