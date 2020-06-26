import 'package:flutter/material.dart';

class Style {
  
  //mainStyle theme
  static ThemeData mainstyle(){
    return ThemeData(
      //primaryColor: Color.fromRGBO(247, 247, 247, 1),
      primaryColor: Color.fromRGBO(158, 25, 25, 1),
      scaffoldBackgroundColor: Color.fromRGBO(247, 247, 247, 1),
      accentColor: Color.fromRGBO(155, 16, 18, 1),
      primaryColorDark: Color.fromRGBO(6, 6, 6, 1)
      
    );
  }

  // Dark Theme
  static ThemeData darkStyle(){
    return ThemeData(
      primaryColor: Color.fromRGBO(0, 0, 0, 1),
      scaffoldBackgroundColor: Color.fromRGBO(0, 0, 0, 1),
      accentColor: Color.fromRGBO(247, 247, 247, 1),
      primaryColorDark: Color.fromRGBO(155, 16, 18, 1),
    );
  }
}