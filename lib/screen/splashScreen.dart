import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/loginProvider.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> _checkSession()async{
     await Provider.of<LoginProvider>(context, listen: false).getFirebaseUser();
     if(Provider.of<LoginProvider>(context, listen: false).status==200){
       Get.offAllNamed('/home');
     }
     else
     {
       Get.offAllNamed('/landing');
     }
  }

  @override
  void initState() {
    _checkSession();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}
