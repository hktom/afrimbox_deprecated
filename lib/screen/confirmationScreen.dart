import 'package:afrimbox/components/inputText.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/loginProvider.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';

class ConfirmationScreen extends StatefulWidget {
  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  int confirmationCode=0;
  bool phoneNumberIsinThePhone = false;
  bool pending=false;
  ProgressDialog _progressDialog = ProgressDialog();

  Future<void> login() async {
    this.setState(() => pending = true);
    await Provider.of<LoginProvider>(context, listen: false)
        .submitOTP(smsCode: confirmationCode);

    if (Provider.of<LoginProvider>(context, listen: false).status == 200) {
      _progressDialog.dismissProgressDialog(context);
      this.setState(() => pending = false);
      //Get.toNamed('/home');
      Get.offAllNamed('/home');
    }
  }

  Future<void> phoneNumberIsinThePhoneLogin() async {
    phoneNumberIsinThePhone = Provider.of<LoginProvider>(context, listen: false)
        .phoneNumberIsinThePhone;
    if (phoneNumberIsinThePhone) {
      this.setState(() {
        confirmationCode = Provider.of<LoginProvider>(context, listen: false)
            .confirmationCodeSent;
      });
      await login();
    }
  }

  void showProgressDialog(){
  _progressDialog.showProgressDialog(context,textToBeDisplayed:'En cours...');
}


  @override
  void initState() {
    phoneNumberIsinThePhoneLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(pending) showProgressDialog();
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
            enabled: !pending,
            initialValue: confirmationCode==0?"":confirmationCode.toString().trim(),
            onChanged: (value) {
              this.confirmationCode = int.parse(value);
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

          // _internationalNumber(),
          // button submit
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.50,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  if(!pending) await login();
                }
                //Get.offAllNamed('/home');
              },
              child: Tex(content:"CONFIRMER", color: Colors.white),
            ),
          ),

          //SizedBox(child:Tex.p(color: Colors.red, text: error)),
        ],
      ),
    );
  }
}
