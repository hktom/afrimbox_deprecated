import 'package:afrimbox/components/progressModal.dart';
import 'package:afrimbox/controller/auth/facebookAuthController.dart';
import 'package:afrimbox/controller/auth/googleAuthController.dart';
import 'package:afrimbox/controller/firestoreController.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:afrimbox/screen/user/createProfile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'helpers/tex.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:bot_toast/bot_toast.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  GoogleAuthController googleAuthController = new GoogleAuthController();
  FireStoreController fireStoreController = new FireStoreController();
  FacebookAuthController facebookAuthController = new FacebookAuthController();
  FirebaseUser user;
  String errLogin = "";
  UserProvider model;
  SharedPreferences prefs;

  Future<void> progressModal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ProgressModal(
          title: "Chargement...",
        );
      },
    );
  }

  Future<void> _authGoogleFacebook(String type) async {
    progressModal();
    await model.signOut();
    try {
      user = type == "google.com"
          ? await googleAuthController.auth()
          : await facebookAuthController.auth();
    } catch (e) {
      Get.back();
      return Toast.show(
          "Nous avons rencontré une erreur, veuillez ressayer", context);
      // return this.setState(() {
      //   errLogin = "Nous avons rencontré une erreur, veuillez ressayer";
      // });
    }

    //check if auth succed
    if (user.uid != null) {
      print("Auth Success");
      await _checkProfileExist();
    } else {
      print("Not Auth Success");
      Get.back();
      return Toast.show(
          "Nous avons rencontré une erreur, veuillez ressayer", context);
    }
  }

  Future<void> _checkProfileExist() async {
    bool checkIfProfileExist = await fireStoreController.checkIfDocumentExist(
        userId: user.uid.trim(), collection: 'users');
    if (!checkIfProfileExist) {
      Get.back();
      return Get.offAll(CreateProfile(user: user));
    } else {
      await _getCurrentProfile();
    }
  }

  Future<void> _getCurrentProfile() async {
    bool result = await model.getProfile(user.uid);
    if (result) {
      Get.back();
      return Get.offAllNamed('/routeStack');
    } else {
      Get.back();
      return Toast.show(
          "Nous avons rencontré une erreur, veuillez ressayer", context);
    }
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('themeIsLight', true);
  }

  @override
  void initState() {
    init();
    model = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Color.fromRGBO(158, 25, 25, 1),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child:
                    Image.asset('assets/afrimbox-png.png', fit: BoxFit.contain),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5, top: 30),
                child: Tex(
                  color: Colors.white,
                  align: TextAlign.center,
                  //bold: FontWeight.bold,
                  content: "Connection",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 1),
                child: SignInButtonBuilder(
                  text: 'Télephone',
                  icon: FontAwesomeIcons.mobile,
                  onPressed: () => Get.toNamed('/login'),
                  backgroundColor: Colors.blueGrey[700],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 1),
                  child: SignInButton(
                    Buttons.Google,
                    text: "Google",
                    onPressed: () async {
                      _authGoogleFacebook('google.com');
                    },
                  )),
              Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: SignInButton(
                    Buttons.Facebook,
                    text: "Facebook",
                    onPressed: () async {
                      _authGoogleFacebook('facebook.com');
                    },
                  )),
            ]),
      ),
    );
  }
}
