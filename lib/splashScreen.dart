import 'package:afrimbox/controller/firestoreController.dart';
import 'package:afrimbox/provider/moviesProvider.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:afrimbox/screen/user/createProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FireStoreController fireStoreController = new FireStoreController();
  var result;
  UserProvider model;
  MoviesProvider moviesProvider;

  Future<void> _checkSession() async {
    result = await model.checkLogin();
    if (result == null) {
      Get.offAllNamed('/landing');
    } else {
      await _checkProfile();
    }
  }

  Future<void> _checkProfile() async {
    var fireStoreUser = await fireStoreController.getDocument(
        collection: 'users', doc: result.uid);
    if (fireStoreUser[0] == null) {
      Get.offAll(CreateProfile(user: result));
    } else {
      await model.getCurrentUser(fireStoreUser);
      Get.offAllNamed('/routeStack');
    }
  }

  @override
  void initState() {
    model = Provider.of<UserProvider>(context, listen: false);
    moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    //moviesProvider.getFirebaseMovies();
    model.getCoupons();
    _checkSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/logo3.jpg',
                width: 180,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator()
          ],
        ));
  }
}
