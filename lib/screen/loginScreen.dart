import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../helpers/tex.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/loginProvider.dart';

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

  void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
       phoneNumber = number;
       phoneIsoCode = isoCode;
    });
}

Future<void> verifyPhoneNumber(phone)async{
  //print("MY PHONE NUMBER $phone");
  await Provider.of<LoginProvider>(context, listen: false).verifyPhoneNumber(phone: phone);
  if(Provider.of<LoginProvider>(context, listen: false).status==200){
    Get.toNamed('/confirmation');
  }
}

  @override
  Widget build(BuildContext context) {
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
              onInputChanged: (PhoneNumber number) {
                phoneNumber=number.phoneNumber;
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
                  verifyPhoneNumber(phoneNumber);
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