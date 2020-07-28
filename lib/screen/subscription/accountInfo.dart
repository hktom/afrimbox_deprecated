import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Tex(
          content: "Abonnement réussi",
          color: Colors.white,
          size: 'h4',
          bold: FontWeight.bold,
        ),
      ),
      body: Container(
        child: Center(),
      ),
    );
  }
}
