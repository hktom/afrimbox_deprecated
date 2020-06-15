import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../helpers/tex.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/loginProvider.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState>  _formKey = GlobalKey<FormState>();
  String phoneNumber;
  String phoneIsoCode;
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  final TextEditingController controller = TextEditingController();
  bool pending=false;
  ProgressDialog _progressDialog = ProgressDialog();

  void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
       phoneNumber = number;
       phoneIsoCode = isoCode;
    });
}

Future<void> verifyPhoneNumber(phone)async{
  //print("MY PHONE NUMBER $phone");
  this.setState(()=>pending=true);
  await Provider.of<LoginProvider>(context, listen: false).verifyPhoneNumber(phone: phone);
  _progressDialog.dismissProgressDialog(context);
  this.setState(()=>pending=false);
  Get.toNamed('/confirmation');
}

void showProgressDialog(){
  _progressDialog.showProgressDialog(context,textToBeDisplayed:'En cours...');
}

  @override
  Widget build(BuildContext context) {
    if(pending) showProgressDialog();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Tex(content: "Verifiez votre numero de télephone", size: 'p', bold: FontWeight.bold,),
        centerTitle: true,
      ),
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
        
          SliverPadding(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
            sliver: SliverToBoxAdapter(
              child: _renderLoginForm() 
              ),
          )
          ],
        )
      ),
    );
  }

  Widget _internationalNumber(){
    return  InternationalPhoneNumberInput(
              countries:["CD", "BJ"] ,
              isEnabled: !pending,
              onInputChanged: (PhoneNumber number) {
                setState(() {
                phoneNumber=number.phoneNumber.toString().trim();
                });
              },
              onInputValidated: (bool value) {
              },
              //autoFocus: true,
              errorMessage: 'Numero de télephone incorrect',
              ignoreBlank: false,
              autoValidate: false,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: controller,
              inputBorder: UnderlineInputBorder(),
              inputDecoration:InputDecoration(
                hintText:'Numero de télephone',
                border: UnderlineInputBorder()
              )
            );
  }

    Widget _renderLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _internationalNumber(),
          // button submit
          SizedBox(height: 10,),
          Tex(content: "Un code de confirmation vous sera envoyé sur ce numéro de télephone", align: TextAlign.center,),
          SizedBox(height: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.30,
            child: RaisedButton(
              color: Color.fromRGBO(255, 174, 54, 1),
              textColor: Colors.white,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                 if(!pending) verifyPhoneNumber(phoneNumber);
                }
              },
              child: Tex(content: "SUIVANT", size: 'p',),
            ),
          ),

          //SizedBox(child:Tex.p(color: Colors.red, text: error)),
          
        ],
      ),
    );
  }


}