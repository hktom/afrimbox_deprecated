import 'package:afrimbox/components/progressModal.dart';
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
  String errLogin = "";

  Future<void> progressModal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ProgressModal();
      },
    );
  }

  Future<void> _auth(String type) async {
    progressModal();
    if (type == "google")
      user = await googleLoginController.auth();
    else
      user = await facebookLoginController.auth();

    if (user.email != null) {
      Get.back();
      Get.offAllNamed('/home');
    } else {
      Get.back();
      setState(() {
        errLogin = "Nous avons rencontré une erreur, veuillez ressayer";
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

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
                padding: EdgeInsets.only(bottom: 5),
                child: Tex(
                  align: TextAlign.center,
                  bold: FontWeight.bold,
                  color: Colors.red,
                  content: errLogin,
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
                      _auth('google');
                    },
                  )),
              Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: SignInButton(
                    Buttons.Facebook,
                    text: "Son profile Facebook",
                    onPressed: () async {
                      _auth('facebook');
                    },
                  )),
            ]),
      ),
    );
  }
}
