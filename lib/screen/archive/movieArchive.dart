import 'package:afrimbox/components/filterByGenre.dart';
import 'package:afrimbox/components/loadingSpinner.dart';
import 'package:afrimbox/components/menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/itemsProvider.dart';
import 'package:afrimbox/controller/moviesController.dart';

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

  Future<void> getMovies(genre) async {
    setState(() {
      loadData = false;
      title = genre;
    });

    if (genre == "Tout genres") {
      await Provider.of<ItemsProvider>(context, listen: false).getAllMovies();
      setState(() {
        movies =
            Provider.of<ItemsProvider>(context, listen: false).items["movies"];
        loadData = true;
      });
    } else {
      await Provider.of<ItemsProvider>(context, listen: false)
          .getMovieByGenre(genre: genre, MovieArchive: true);

      setState(() {
        movies = Provider.of<ItemsProvider>(context, listen: false)
            .items["genreMovie"];
        loadData = true;
      });
    }
  }

  @override
  void initState() {
    getMovies(widget.genre);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    itemHeight = (size.height - kToolbarHeight - 24) / 2;
    itemWidth = size.width / 2;

    print("REFRESH DATA");

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
        title: Text(this.title == "Tout genres" ? "Films" : this.title),
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
            padding: EdgeInsets.all(10),
            child: FilterByGenre(
              getMovies: this.getMovies,
            ),
          ),
        ),
      ],
    );
  }

  Widget _listMovie() {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: (itemWidth / itemHeight),
      children: MoviesController.posterGrid(
          offset: 0, limit: double.infinity, data: movies),
    );
  }
}
