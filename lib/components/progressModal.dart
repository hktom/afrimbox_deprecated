import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';

class ProgressModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //title: Text('AlertDialog Title'),
      content: ListTile(
        leading: CircularProgressIndicator(),
        title: Tex(
          content: "Authentifaction en cours",
          size: 'h6',
          bold: FontWeight.bold,
        ),
      ),
    );
  }
}
