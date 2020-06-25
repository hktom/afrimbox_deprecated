import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';

class CardGenre extends StatefulWidget {
  final Map data;
  CardGenre({Key key, this.data}) : super(key: key);

  @override
  _CardGenreState createState() => _CardGenreState();
}

class _CardGenreState extends State<CardGenre> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(3),
        color: Color.fromRGBO(0, 0, 0, 1),
        child: Tex(
          content: widget.data['name'],
          color: Colors.white,
        ),
      ),
    );
  }
}
