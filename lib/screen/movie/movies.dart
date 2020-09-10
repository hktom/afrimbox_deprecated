import 'package:afrimbox/widgets/filterByGenre.dart';
import 'package:afrimbox/widgets/menu.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/MovieProvider.dart';
import 'package:afrimbox/controller/moviesController.dart';

class Movies extends StatefulWidget {
  final String genre;
  final bool displayAppBar;
  Movies({Key key, this.genre, this.displayAppBar}) : super(key: key);
  @override
  _MoviesState createState() => _MoviesState();
}

class _MoviesState extends State<Movies> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var movies = [];
  double itemHeight;
  double itemWidth;
  bool loadData = false;
  String title = '';
  MovieProvider model;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    model = Provider.of<MovieProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    itemHeight = (size.height - kToolbarHeight - 24) / 2;
    itemWidth = size.width / 2;

    return Scaffold(
      key: _scaffoldKey,
      appBar: widget.displayAppBar
          ? AppBar(
              title: Tex(
                content: widget.genre,
                size: 'h4',
              ),
            )
          : null,
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
            child: FilterByGenre(genre: widget.genre),
          ),
        ),
      ],
    );
  }

  Widget _listMovie() {
    return Consumer<MovieProvider>(
      builder: (context, model, child) {
        print("PENDING ${model.pending['getByGenre']}");
        if (model.pending['getByGenre']) {
          return Center(child: CircularProgressIndicator());
        } else {
          return GridView.count(
            crossAxisCount: 3,
            childAspectRatio: (itemWidth / itemHeight),
            children: MoviesController.posterGrid(
                offset: 0,
                limit: double.infinity,
                data: model.moviesByGenre[model.currentGenre]),
          );
        }
      },
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
