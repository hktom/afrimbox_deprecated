import 'package:afrimbox/screen/confirmationScreen.dart';
import 'package:flutter/material.dart';
import '../screen/splashScreen.dart';
import '../screen/Homescreen.dart';
import '../screen/Playerscreen.dart';
import '../screen/Loginscreen.dart';
import '../screen/Landingscreen.dart';

class Routes {
  static Map<String, WidgetBuilder> list={
    '/': (context) => SplashScreen(),
    '/landing': (context) => LandingScreen(),
    '/home': (context) => HomeScreen(),
    '/login':(context) => LoginScreen(),
    '/player':(context) => PlayerScreen(),
    '/confirmation':(context) => ConfirmationScreen(),
  };

}