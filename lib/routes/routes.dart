import 'package:afrimbox/screen/archive/channelArchive.dart';
import 'package:afrimbox/screen/archive/movieArchive.dart';
import 'package:afrimbox/screen/subscription/subscription.dart';
import 'package:afrimbox/screen/user/payment.dart';
import 'package:afrimbox/screen/user/profile.dart';
import 'package:afrimbox/screen/user/updateProfile.dart';
import 'package:flutter/material.dart';
import '../screen/splashScreen.dart';
import '../screen/Homescreen.dart';
import '../screen/Playerscreen.dart';
import '../screen/MobileAuthScreen.dart';
import '../screen/Landingscreen.dart';

class Routes {
  static Map<String, WidgetBuilder> list = {
    '/splash': (context) => SplashScreen(),
    '/landing': (context) => LandingScreen(),
    '/home': (context) => HomeScreen(),
    '/login': (context) => MobileAuthScreen(),
    '/player': (context) => PlayerScreen(),
    '/genre': (context) => MovieArchive(),
    '/channelArchive': (context) => ChannelArchive(),
    '/profile': (context) => Profile(),
    '/Payment': (context) => Payment(),
    '/updateProfile': (context) => UpdateProfile(),
    '/subscription': (context) => Subscription(),
  };
}
