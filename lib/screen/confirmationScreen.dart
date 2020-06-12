import 'package:afrimbox/components/inputText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationScreen extends StatefulWidget {
  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  String phoneNumber;
  String phoneIsoCode;

  void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
       phoneNumber = number;
       phoneIsoCode = isoCode;
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            
            SliverPadding(
            padding: EdgeInsets.fromLTRB(100, 80, 100, 0),
            sliver: SliverToBoxAdapter(
              child: Image.asset('assets/logo1.jpg', width: 30, fit: BoxFit.contain) 
              ),
          ),

          SliverPadding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            sliver: SliverToBoxAdapter(
              child: _renderLoginForm() 
              ),
          )
          ],
        )
      ),
    );
  }

    Widget _renderLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          //Tex.p(text: "Se connecter", color: Colors.white),
          InputText(
            field: 'mobile', 
            fieldIcon: Icons.phone, 
            fieldHint: 'Taper le code de confirmation'
            ),

          // _internationalNumber(),
          // button submit
          SizedBox(
            width: MediaQuery.of(context).physicalDepth,
            child: RaisedButton(
              color: Color.fromRGBO(255, 174, 54, 1),
              textColor: Colors.white,
              onPressed: () async {
                // if (_formKey.currentState.validate()) {
                //   //await _login();
                // }
                Get.offAllNamed('/home');
              },
              child: Text("CONFIRMER"),
            ),
          ),

          //SizedBox(child:Tex.p(color: Colors.red, text: error)),
          
        ],
      ),
    );
  }


}