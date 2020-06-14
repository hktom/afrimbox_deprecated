import 'package:flutter/material.dart';

class Tex extends StatefulWidget {
  final String content;
  final Color color;
  final String size;
  final FontWeight bold;
  final TextAlign align;

  Tex({Key key, this.color, this.size: 'p', this.content, this.bold:FontWeight.normal, this.align:TextAlign.left}) : super(key: key);

  @override
  _TexState createState() => _TexState();
}

class _TexState extends State<Tex> {
  Map<String, double> size = {
    'h1': 25,
    'h2': 24,
    'h3': 22,
    'h4': 20,
    'h5': 18,
    'h6': 16,
    'p': 14,
  };
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.content,
      style: TextStyle(fontSize: size[widget.size], color: widget.color, fontWeight: widget.bold),
      textAlign: widget.align,
    );
  }
}
