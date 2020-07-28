import 'package:afrimbox/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/loginProvider.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _checkSession() async {
    await Provider.of<LoginProvider>(context, listen: false).getFirebaseUser();
    if (Provider.of<LoginProvider>(context, listen: false).status == 200) {
      var user =
          Provider.of<LoginProvider>(context, listen: false).firebaseUser;
      var provider = user.providerData;

      // Check if auth method is google or facebook or mobile
      bool getProfile = false;
      for (var userInfo in provider) {
        if (userInfo.providerId == "google.com" ||
            userInfo.providerId == "facebook.com") getProfile = true;
      }

      // if auth method is google or facebook get by email or try by mobile
      if (getProfile)
        await Provider.of<UserProvider>(context, listen: false)
            .getCurrentUserProfile(
                userId: user.email, auth: user, mobileProvider: false);
      else
        await Provider.of<UserProvider>(context, listen: false)
            .getCurrentUserProfile(
                userId: user.phoneNumber, auth: user, mobileProvider: true);

      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/landing');
    }
  }

  @override
  void initState() {
    _checkSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
