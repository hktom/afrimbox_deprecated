import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal:40),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            Center(
        child: Image.asset('assets/logo1.jpg', width: 200, fit: BoxFit.contain),
      ),

      SizedBox(height:20),

      Text("Bienvenu sur AfrimBox", style: TextStyle(fontSize:17, fontWeight:FontWeight.bold),),

      SizedBox(
        width: MediaQuery.of(context).physicalDepth,
        child: FlatButton(
        onPressed: (){
          Get.toNamed('/login');
        },
        child: Text("Entrez"),
        ),
      ),
          ]
        ),
      ),
    );
  }
}