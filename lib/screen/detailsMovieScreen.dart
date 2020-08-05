import 'package:afrimbox/components/movieDetailCardAppBar.dart';
import 'package:afrimbox/screen/trailerPlayerScreen.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:afrimbox/provider/MovieProvider.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/controller/moviesController.dart';
//import 'package:afrimbox/helpers/const.dart';

class DetailsMovieScreen extends StatefulWidget {
  final Map movie;
  DetailsMovieScreen({Key key, this.movie}) : super(key: key);
  @override
  _DetailsMovieScreenState createState() => _DetailsMovieScreenState();
}

class _DetailsMovieScreenState extends State<DetailsMovieScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  var unescape = new HtmlUnescape();
  //var genres = [];
  //var actors = [];
  var favorites = [];
  MovieProvider model;
  SnackBar snackBar = SnackBar(
    content: Text("Aucun trailer n'est disponible pour le moment"),
    backgroundColor: Color.fromRGBO(158, 25, 25, 1),
  );

  // get genres
  Future<void> init() async {
    await model.getGenres(widget.movie['id'].toString());
    await model.getActors(widget.movie['id'].toString());
    await model.getByGenre(3295.toString());
    favorites = [];
    setState(() {});
  }

  @override
  void initState() {
    model = Provider.of<MovieProvider>(context, listen: false);
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: <Widget>[
        SliverToBoxAdapter(
          child: _appBar(),
        ),
        SliverToBoxAdapter(
          child: _description(),
        ),
        SliverToBoxAdapter(
          child: _listActionsButton(),
        ),
        sliverTitle("Cast"),
        listActors(),
        sliverTitle("Voir également"),
        //listFavoriteMovies()
      ]),
    );
  }

  Widget listActors() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        //height: 20,
        child: Wrap(
          direction: Axis.horizontal,
          children: MoviesController.listName(
              offset: 0, limit: double.infinity, data: model.actors),
        ),
      ),
    );
  }

  Widget sliverTitle(String title) {
    return SliverPadding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        sliver: SliverToBoxAdapter(
            child: ListTile(
          leading: Tex(
            content: title,
            size: 'h5',
          ),
        )));
  }

  Widget _listActionsButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FlatButton(
                padding: EdgeInsets.zero,
                child: _buttonIcon(icon: Icons.camera_roll, text: 'Trailer'),
                onPressed: () {
                  if (widget.movie["youtube_id"] != "") {
                    var url = widget.movie["youtube_id"]
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', '');
                    print("DEBBUG YOUTUBE URL $url");
                    Get.to(TrailerPlayerScreen(trailerUrl: url.trim()));
                  } else {
                    _scaffoldkey.currentState.showSnackBar(snackBar);
                  }
                }),
          ),
          // Expanded(
          //   flex: 1,
          //   child: FlatButton(
          //       padding: EdgeInsets.zero,
          //       child: _buttonIcon(icon: Icons.share, text: 'Partager'),
          //       onPressed: () {}),
          // ),
          Expanded(
            flex: 1,
            child: FlatButton(
                padding: EdgeInsets.zero,
                child: _buttonIcon(icon: Icons.list, text: 'Ma liste'),
                onPressed: () {}),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
                padding: EdgeInsets.zero,
                child: _buttonIcon(icon: Icons.thumb_up, text: "j'aime"),
                onPressed: () {}),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
                padding: EdgeInsets.zero,
                child:
                    _buttonIcon(icon: Icons.file_download, text: 'Télecharger'),
                onPressed: () {}),
          ),
        ],
      ),
    );
  }

  Widget _buttonIcon({IconData icon, String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(fontSize: 10),
        )
      ],
    );
  }

  Widget _description() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Tex(
                      content:
                          unescape.convert(widget.movie['title']['rendered']))),
              _caracteristics(),
              HtmlWidget(widget.movie['content']['rendered']),
              //Tex(content: .toString()), //description
            ]));
  }

  Widget _caracteristics() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 0,
              child: Tex(
                content: widget.movie['release_date'] + ' | ',
              )),
          Expanded(flex: 0, child: _time()),
          Expanded(flex: 0, child: _rating()),
        ],
      ),
    );
  }

  Widget _appBar() {
    return MovieDetailCardAppBar(
      movie: widget.movie,
      genres: model.genres,
    );
  }

  Widget _time() {
    double runtime = double.parse(widget.movie['runtime']);
    int h = runtime ~/ 60;
    double m = runtime % 60;

    return Tex(
      content: h.toString() + 'h ' + m.toString() + 'min | ',
    );
  }

  Widget _rating() {
    double currentRate = double.parse(widget.movie['vote_average']) / 2;
    return SmoothStarRating(
        allowHalfRating: true,
        onRated: (v) {
          print(v);
          print(widget.movie['vote_average']);
        },
        starCount: 5,
        rating: currentRate,
        size: 20.0,
        isReadOnly: false,
        color: Colors.yellow,
        borderColor: Colors.black,
        spacing: 0.0);
  }

  Widget listFavoriteMovies() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(5),
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: MoviesController.poster(
              offset: 0, limit: double.infinity, data: []),
        ),
      ),
    );
  }
}
