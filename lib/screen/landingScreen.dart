import 'package:afrimbox/controller/fbLoginController.dart';
import 'package:afrimbox/controller/googleLoginController.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../helpers/tex.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  GoogleLoginController googleLoginController = new GoogleLoginController();
  FacebookLoginController facebookLoginController =
      new FacebookLoginController();
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: Container(
        //padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).physicalDepth,
                  child: Tex(
                    size: 'h6',
                    align: TextAlign.center,
                    content: "Bienvenu sur AfrimBox",
                    bold: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.asset('assets/logo1.jpg',
                    width: 200, fit: BoxFit.contain),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Tex(
                  align: TextAlign.center,
                  bold: FontWeight.bold,
                  content: "Se Connecter avec",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 1),
                child: SignInButtonBuilder(
                  text: 'Son numero de télephone',
                  icon: FontAwesomeIcons.mobile,
                  onPressed: () => Get.toNamed('/login'),
                  backgroundColor: Colors.blueGrey[700],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 1),
                  child: SignInButton(
                    Buttons.Google,
                    text: "Son compte Google",
                    onPressed: () async {
                      user = await googleLoginController.auth();
                      print("DEBBUG USER GOOGLE ${user.toString()}");
                    },
                  )),
              Padding(
                  padding: EdgeInsets.only(bottom: 1),
                  child: SignInButton(
                    Buttons.Facebook,
                    text: "Se profile Facebook",
                    onPressed: () async {
                      user = await facebookLoginController.auth();
                      print("DEBBUG USER GOOGLE ${user.toString()}");
                    },
                  )),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: SignInButton(
                  Buttons.Email,
                  text: "Son adresse Email",
                  onPressed: () {},
                ),
              ),
            ]),
      ),
    );
  }
}
