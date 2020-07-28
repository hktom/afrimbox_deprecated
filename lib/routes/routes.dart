import 'package:afrimbox/screen/confirmationScreen.dart';
import 'package:afrimbox/screen/genreScreen.dart';
import 'package:afrimbox/screen/subscription/subscription.dart';
import 'package:afrimbox/screen/user/payment.dart';
import 'package:afrimbox/screen/user/profile.dart';
import 'package:afrimbox/screen/user/updateProfile.dart';
import 'package:flutter/material.dart';
import '../screen/splashScreen.dart';
import '../screen/Homescreen.dart';
import '../screen/Playerscreen.dart';
import '../screen/Loginscreen.dart';
import '../screen/Landingscreen.dart';

class Routes {
  static Map<String, WidgetBuilder> list = {
    '/splash': (context) => SplashScreen(),
    '/landing': (context) => LandingScreen(),
    '/home': (context) => HomeScreen(),
    '/login': (context) => LoginScreen(),
    '/player': (context) => PlayerScreen(),
    '/confirmation': (context) => ConfirmationScreen(),
    '/genre': (context) => GenreScreen(),
    '/profile': (context) => Profile(),
    '/Payment': (context) => Payment(),
    '/updateProfile': (context) => UpdateProfile(),
    '/subscription': (context) => Subscription(),
  };
}
