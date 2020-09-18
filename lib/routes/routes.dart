import 'package:afrimbox/landingScreen.dart';
import 'package:afrimbox/routeStack.dart';
import 'package:afrimbox/screen/channel/channels.dart';
import 'package:afrimbox/screen/channel/favoriteChannel.dart';
import 'package:afrimbox/screen/movie/favoriteMovie.dart';
import 'package:afrimbox/screen/homeScreen.dart';
import 'package:afrimbox/screen/mobileAuthScreen.dart';
import 'package:afrimbox/screen/movie/movies.dart';
import 'package:afrimbox/screen/movie/searchScreen.dart';
import 'package:afrimbox/screen/setting.dart';
import 'package:afrimbox/screen/user/payment.dart';
import 'package:afrimbox/screen/user/profile.dart';
import 'package:afrimbox/screen/user/updateProfile.dart';
import 'package:afrimbox/splashScreen.dart';
import 'package:flutter/material.dart';
//import 'package:afrimbox/screen/playerScreen.dart';
// import 'package:afrimbox/screen/subscription/subscription.dart';

class Routes {
  static Map<String, WidgetBuilder> list = {
    '/routeStack': (context) => RouteStack(),
    '/splash': (context) => SplashScreen(),
    '/landing': (context) => LandingScreen(),
    '/home': (context) => HomeScreen(),
    '/login': (context) => MobileAuthScreen(),
    '/search': (context) => SearchScreen(),
    '/movies': (context) => Movies(),
    '/favoritesMovies': (context) => FavoriteMovie(),
    '/channels': (context) => Channels(),
    '/favoriteChannels': (context) => FavoriteChannel(),
    '/profile': (context) => Profile(),
    '/Payment': (context) => Payment(),
    '/updateProfile': (context) => UpdateProfile(),
    '/setting': (context) => Setting(),
  };
}
