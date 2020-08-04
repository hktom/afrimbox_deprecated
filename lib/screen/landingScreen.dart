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
import '../helpers/tex.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> progressModal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ProgressModal(
          title: "Authentifaction en cours",
        );
      },
    );
  }

  Future<void> _authGoogleFacebook(String type) async {
    progressModal();
    if (type == "google.com")
      user = await googleAuthController.auth();
    else
      user = await facebookAuthController.auth();

    //check if auth succed
    if (user.uid != null) {
      Get.back();
      bool checkIfProfileExist = await fireStoreController.checkIfDocumentExist(
          userId: user.uid.trim(), collection: 'users');
      // check if profile exist , true redirect to homem false redirect to create profile
      if (!checkIfProfileExist) {
        return Get.offAll(CreateProfile(user: user));
      } else {
        //get current profile
        bool result = await Provider.of<UserProvider>(context, listen: false)
            .getProfile(user.uid);
        if (result)
          Get.offAllNamed('/home');
        else
          setState(() {
            errLogin = "Nous avons rencontré une erreur, veuillez ressayer";
          });
      }
    } else {
      Get.back();
      setState(() {
        errLogin = "Nous avons rencontré une erreur, veuillez ressayer";
      });
    }
  }

  Future<void> _redirectToProfileEdit(user, authMethod) async {
    return Get.offAll(CreateProfile(
      //authMethod: authMethod,
      user: user,
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      _authGoogleFacebook('google.com');
                    },
                  )),
              Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: SignInButton(
                    Buttons.Facebook,
                    text: "Son profile Facebook",
                    onPressed: () async {
                      _authGoogleFacebook('facebook.com');
                    },
                  )),
            ]),
      ),
    );
  }
}
