import 'package:afrimbox/components/filterByGenre.dart';
//import 'package:afrimbox/components/loadingSpinner.dart';
import 'package:afrimbox/components/menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/MovieProvider.dart';
import 'package:afrimbox/controller/moviesController.dart';
import 'package:afrimbox/helpers/const.dart';

class MovieArchive extends StatefulWidget {
  final String genre;
  MovieArchive({Key key, this.genre}) : super(key: key);
  @override
  _MovieArchiveState createState() => _MovieArchiveState();
}

class _MovieArchiveState extends State<MovieArchive> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var movies = [];
  double itemHeight;
  double itemWidth;
  bool loadData = false;
  String title = '';
  MovieProvider model;

  @override
  void initState() {
    model = Provider.of<MovieProvider>(context, listen: false);
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
        title: Text(widget.genre == "Tous" ? "Films" : widget.genre),
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
      body: buildStack(),
    );
  }

  Stack buildStack() {
    return Stack(
      children: <Widget>[
        _listMovie(),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: FilterByGenre(genre: "Tous"),
          ),
        ),
      ],
    );
  }

  Widget _listMovie() {
    return Consumer<MovieProvider>(
      builder: (context, model, child) => GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (itemWidth / itemHeight),
        children: MoviesController.posterGrid(
            offset: 0,
            limit: double.infinity,
            data: model.moviesByGenre[model.currentGenre]),
      ),
    );
  }

  // String mapGenreToKey(String label) {
  //   var key;
  //   category.forEach((element) {
  //     if (element['label'] == label) {
  //       key = element['label'].toString();
  //     }
  //   });
  //   return key;
  // }
}
