import 'package:afrimbox/components/menu.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/provider/itemsProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('AFRIMBOX'),
      ),
      drawer: Menu(),
      body: Container(
        child: loadingContent(),
      ),
    );
  }

  Widget content(){
    return Container(
      
    );
  }

  Widget loadingContent(){
    return Center(
      child: SpinKitChasingDots(
        size: 60,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}