//import 'package:afrimbox/components/inputText.dart';
import 'package:afrimbox/components/progressModal.dart';
import 'package:afrimbox/controller/auth/mobileAuthController.dart';
import 'package:afrimbox/controller/firestoreController.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:afrimbox/screen/user/createProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/loginProvider.dart';
//import 'package:custom_progress_dialog/custom_progress_dialog.dart';

class MobileAuthConfirmationScreen extends StatefulWidget {
  final String verificationId;

  MobileAuthConfirmationScreen({Key key, this.verificationId})
      : super(key: key);

  @override
  _MobileAuthConfirmationScreenState createState() =>
      _MobileAuthConfirmationScreenState();
}

class _MobileAuthConfirmationScreenState
    extends State<MobileAuthConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  MobileAuthController mobileAuthController = new MobileAuthController();
  int confirmationCode = 0;
  bool phoneNumberIsinThePhone = false;
  bool pending = false;
  String err = '';
  //ProgressDialog _progressDialog = ProgressDialog();
  FireStoreController fireStoreController = new FireStoreController();

  Future<void> login() async {
    showProgressModal();
    setState(() => err = '');
    //var payload = Provider.of<UserProvider>(context, listen: false).payload;

    var payload = {
      'verificationId': widget.verificationId,
      'confirmationCode': confirmationCode.toString(),
    };

    var creditials =
        await mobileAuthController.confirmCodeFromAnotherDevice(payload);
    var user = await mobileAuthController.auth(creditials);

    if (user.phoneNumber == null) {
      return this.setState(
          () => err = "Une erreur est arrivée pendant l'authentification");
    }

    bool checkIfProfileExist = await fireStoreController.checkIfDocumentExist(
        userId: user.email, collection: user.phoneNumber);

    if (checkIfProfileExist)
      Get.offAllNamed('/home');
    else
      return Get.offAll(CreateProfile(
        authMethod: 'mobile',
        user: user,
      ));
  }

  // Future<void> phoneNumberIsinThePhoneLogin() async {
  //   phoneNumberIsinThePhone = Provider.of<LoginProvider>(context, listen: false)
  //       .phoneNumberIsinThePhone;
  //   if (phoneNumberIsinThePhone) {
  //     this.setState(() {
  //       confirmationCode = Provider.of<LoginProvider>(context, listen: false)
  //           .confirmationCodeSent;
  //     });
  //     await login();
  //   }
  // }

  Future<void> showProgressModal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ProgressModal(
          title: "Authentification en cours ...",
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            sliver: SliverToBoxAdapter(child: _renderLoginForm()),
          )
        ],
      )),
    );
  }

  Widget _renderLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            //enabled: !pending,
            initialValue:
                confirmationCode == 0 ? "" : confirmationCode.toString().trim(),
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
                if (_formKey.currentState.validate()) {
                  if (!pending) await login();
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
