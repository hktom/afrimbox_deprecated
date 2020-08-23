import 'package:afrimbox/widgets/menu.dart';
import 'package:afrimbox/controller/moviesController.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FavoriteMovie extends StatefulWidget {
  @override
  _FavoriteMovieState createState() => _FavoriteMovieState();
}

class _FavoriteMovieState extends State<FavoriteMovie> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserProvider model;
  double itemHeight;
  double itemWidth;

  @override
  void initState() {
    model = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    itemHeight = (size.height - kToolbarHeight - 24) / 2;
    itemWidth = size.width / 2;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Get.back()),
        elevation: 0,
        title: Tex(content: "Mes Films", size: 'h4'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () => _scaffoldKey.currentState.openDrawer())
        ],
      ),
      drawer: Menu(),
      body: Container(
        child: _listMovie(),
      ),
    );
  }

  Widget _listMovie() {
    return Consumer<UserProvider>(
      builder: (context, model, child) => GridView.count(
          crossAxisCount: 3,
          childAspectRatio: (itemWidth / itemHeight),
          children: MoviesController.posterGrid(
              offset: 0, limit: double.infinity, data: model.favoriteMovies())),
    );
  }
}
