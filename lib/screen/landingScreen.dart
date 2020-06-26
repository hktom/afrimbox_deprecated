import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/tex.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 0,
                child: SizedBox(
                  width:MediaQuery.of(context).physicalDepth,
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
                padding: EdgeInsets.only(bottom:20),
                child: SizedBox(
                   width:MediaQuery.of(context).physicalDepth,
                    child: RaisedButton(
                    color:Theme.of(context).primaryColor,
                    onPressed: () {
                      Get.toNamed('/login');
                    },
                    child: Tex(content: "ENTRE", color: Colors.white,),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
