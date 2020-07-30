import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';

class ProgressModal extends StatelessWidget {
  final String title;
  ProgressModal({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //title: Text('AlertDialog Title'),
      content: ListTile(
        leading: CircularProgressIndicator(),
        title: Tex(
          content: this.title,
          size: 'h6',
          bold: FontWeight.bold,
        ),
      ),
    );
  }
}
