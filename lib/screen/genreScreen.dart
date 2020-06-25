import 'package:flutter/material.dart';

class GenreScreen extends StatefulWidget {
  final int genre;
  GenreScreen({Key key, this.genre}):super(key:key);
  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(),
    );
  }
}