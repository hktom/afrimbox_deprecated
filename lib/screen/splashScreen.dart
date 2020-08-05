import 'package:afrimbox/controller/firestoreController.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:afrimbox/screen/user/createProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/loginProvider.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FireStoreController fireStoreController = new FireStoreController();
  var result;
  // check if user is logged
  Future<void> _checkSession() async {
    result =
        await Provider.of<UserProvider>(context, listen: false).checkLogin();
    // user is not logged
    if (result == null) {
      Get.offAllNamed('/landing');
    } else {
      //user is logged
      var fireStoreUser = await fireStoreController.getDocument(
          collection: 'users', doc: result.uid);

      // check if user profile exist
      if (fireStoreUser[0] == null) {
        Get.offAll(CreateProfile(
          user: result,
        ));
      } else {
        await Provider.of<UserProvider>(context, listen: false)
            .getCurrentUser(fireStoreUser);
        Get.offAllNamed('/home');
      }
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
