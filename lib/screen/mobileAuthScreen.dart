import 'dart:async';

import 'package:afrimbox/components/progressModal.dart';
import 'package:afrimbox/controller/auth/mobileAuthController.dart';
import 'package:afrimbox/controller/firestoreController.dart';
import 'package:afrimbox/screen/user/createProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../helpers/tex.dart';
import 'package:get/get.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:provider/provider.dart';

class MobileAuthScreen extends StatefulWidget {
  @override
  _MobileAuthScreenState createState() => _MobileAuthScreenState();
}

class _MobileAuthScreenState extends State<MobileAuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  MobileAuthController mobileAuthController = new MobileAuthController();

  String phoneNumber;
  String phoneIsoCode;
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  TextEditingController controller = TextEditingController();
  FireStoreController fireStoreController = new FireStoreController();
  bool pending = false;
  String err = '';
  int screen = 1;
  int confirmationCode;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  Future<void> sendConfirmationCode(phone) async {
    showProgressModal("Envoi du code de confirmation...");
    setState(() => err = '');
    try {
      await mobileAuthController.sendConfirmationCode(phone.toString());
      if (mobileAuthController.status != 500) {
        setState(() => screen = 2);
      } else
        setState(() => err = "Une erreur est survenue, veuillez ressayer");
      Get.back();
    } catch (e) {
      setState(() => err = "Une erreur est survenue, veuillez ressayer");
      Get.back();
    }
  }

  Future<AuthCredential> generateCredentials() async {
    var payload = {
      'verificationId': mobileAuthController.verificationId,
      'confirmationCode': this.confirmationCode.toString(),
    };
    return await mobileAuthController.confirmCodeFromAnotherDevice(payload);
  }

  Future<void> authCallBack(FirebaseUser user) async {
    if (user.phoneNumber == null) {
      Get.back();
      this.setState(
          () => err = "Une erreur est arrivée pendant l'authentification");
    }

    bool checkIfProfileExist = await fireStoreController.checkIfDocumentExist(
        userId: user.email, collection: user.phoneNumber);

    if (checkIfProfileExist) {
      //get current profile
      bool result = await Provider.of<UserProvider>(context, listen: false)
          .getProfile(user.phoneNumber);
      Get.back();
      if (result) {
        Get.offAllNamed('/home');
      } else {
        this.setState(
            () => err = "Une erreur est arrivée pendant l'authentification");
      }
    } else {
      Get.offAll(CreateProfile(
        //authMethod: 'mobile',
        user: user,
      ));
    }
  }

  Future<void> auth() async {
    showProgressModal("Authentification en cours ...");
    setState(() => err = '');

    try {
      var creditials = await generateCredentials();
      var user = await mobileAuthController.auth(creditials);
      await authCallBack(user);
    } catch (e) {
      setState(() => err = "Une erreur est arrivée pendant l'authentification");
    }
  }

  Future<void> showProgressModal(title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ProgressModal(
          title: title,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return screen == 1 ? screenOne() : screenTwo();
  }

  Widget screenOne() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Tex(
          content: "Verifiez votre numero de télephone",
          size: 'p',
          bold: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Container(
          child: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
            sliver: SliverToBoxAdapter(child: _renderLoginForm()),
          )
        ],
      )),
    );
  }

  Widget _internationalNumber() {
    return InternationalPhoneNumberInput(
        countries: ["CD", "BJ"],
        isEnabled: !pending,
        onInputChanged: (PhoneNumber number) {
          setState(() {
            phoneNumber = number.phoneNumber.toString().trim();
          });
        },
        onInputValidated: (bool value) {},
        //autoFocus: true,
        errorMessage: 'Numero de télephone incorrect',
        ignoreBlank: false,
        autoValidate: false,
        selectorTextStyle: TextStyle(color: Colors.black),
        initialValue: number,
        textFieldController: controller,
        inputBorder: UnderlineInputBorder(),
        inputDecoration: InputDecoration(
            hintText: 'Numero de télephone', border: UnderlineInputBorder()));
  }

  Widget _renderLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _internationalNumber(),
          // button submit
          SizedBox(
            height: 10,
          ),
          Tex(
            content:
                "Un code de confirmation vous sera envoyé sur ce numéro de télephone",
            align: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.30,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  sendConfirmationCode(phoneNumber);
                }
              },
              child: Tex(
                content: "SUIVANT",
                size: 'p',
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(
            height: 10,
          ),
          Tex(
            content: err,
            color: Colors.red,
            align: TextAlign.center,
          ),

          //SizedBox(child:Tex.p(color: Colors.red, text: error)),
        ],
      ),
    );
  }

  Widget screenTwo() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() => screen = 1);
            }),
        elevation: 0,
        title: Tex(
          content: "Entrez le code de confirmation",
          size: 'p',
          bold: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Container(
          child: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            sliver: SliverToBoxAdapter(child: _buildConfirmationForm()),
          )
        ],
      )),
    );
  }

  Widget _buildConfirmationForm() {
    return Form(
      key: _formKey2,
      child: Column(
        children: <Widget>[
          TextFormField(
            //enabled: !pending,
            initialValue: '',
            onChanged: (value) {
              setState(() => this.confirmationCode = int.parse(value));
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.phone_android,
                color: Theme.of(context).hintColor,
              ),
              filled: true,
              fillColor: Color.fromRGBO(255, 255, 255, 0.3),
              border: UnderlineInputBorder(),
              hintText: 'ex: 123456',
              contentPadding:
                  EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
            ),
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return "Ne peut pas rester vide";
              }
            },
          ),
          SizedBox(
            height: 0.5,
          ),
          Tex(
            content: err,
            color: Colors.red,
            align: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Tex(
            content:
                "Un code de confirmation a été envoyé sur votre numéro. Veuillez l'inserer",
            align: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),

          // _internationalNumber(),
          // button submit
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.50,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () async {
                if (_formKey2.currentState.validate()) {
                  await auth();
                }
                //Get.offAllNamed('/home');
              },
              child: Tex(content: "CONFIRMER", color: Colors.white),
            ),
          ),

          //SizedBox(child:Tex.p(color: Colors.red, text: error)),
        ],
      ),
    );
  }
}
