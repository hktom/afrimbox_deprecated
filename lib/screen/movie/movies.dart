import 'package:afrimbox/widgets/filterByGenre.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/MovieProvider.dart';
import 'package:afrimbox/controller/moviesController.dart';
import 'package:sup/sup.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Movies extends StatefulWidget {
  // final Map category;
  final bool displayAppBar;
  Movies({Key key, this.displayAppBar}) : super(key: key);
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
  DefaultCacheManager manager = new DefaultCacheManager();
  //MovieProvider model;

  @override
  bool get wantKeepAlive => true;

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
              title: Consumer<MovieProvider>(builder: (context, model, child) {
                return Tex(
                  content: model.currentGenre['label'],
                  size: 'h4',
                );
              }),
            )
          : null,
      body: Container(
        child: Consumer<MovieProvider>(builder: (context, model, child) {
          if (model.pending['getByGenre']) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return buildStack(model);
          }
        }),
      ),
    );
  }

  Stack buildStack(model) {
    return Stack(
      children: <Widget>[
        _listMovie(model),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: FilterByGenre(),
          ),
        ),
      ],
    );
  }

  Widget _listMovie(model) {
    var _key = model.currentGenre['key'];
    var _movie = model.moviesByGenre[_key];

    if (model.moviesByGenre[_key].isEmpty) {
      return Center(
        child: QuickSup.empty(
          subtitle: "Cette categorie est vide",
        ),
      );
    } else {
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (itemWidth / itemHeight),
        children: MoviesController.posterGrid(
            offset: 0, limit: double.infinity, data: _movie),
      );
    }
  }
}
