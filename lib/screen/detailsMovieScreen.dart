import 'package:afrimbox/components/movieDetailCardAppBar.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:afrimbox/provider/itemsProvider.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/controller/moviesController.dart';

class DetailsMovieScreen extends StatefulWidget {
  final Map movie;
  DetailsMovieScreen({Key key, this.movie}) : super(key: key);
  @override
  _DetailsMovieScreenState createState() => _DetailsMovieScreenState();
}

class _DetailsMovieScreenState extends State<DetailsMovieScreen> {
  var unescape = new HtmlUnescape();
  var genres = [];
  var actors = [];
  var favorite = [];

  // get genres
  Future<void> getGenres() async {
    genres = await Provider.of<ItemsProvider>(context, listen: false)
        .req(field: 'genres', id: widget.movie['id']);
    setState(() {});
  }

  //get actors
  Future<void> getActors() async {
    actors = await Provider.of<ItemsProvider>(context, listen: false)
        .req(field: 'actors', id: widget.movie['id']);
    setState(() {});
  }

  //get favorite
  Future<void> getFavorite() {}

  @override
  void initState() {
    getGenres();
    getActors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        sliverTitle("Pour toi"),
      ]),
    );
  }

  Widget listActors() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(5),
        height: 120,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: MoviesController.avatar(
              offset: 0, limit: double.infinity, data: actors),
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
            child: IconButton(icon: Icon(Icons.camera_roll), onPressed: () {}),
          ),
          Expanded(
            flex: 1,
            child: IconButton(icon: Icon(Icons.share), onPressed: () {}),
          ),
          Expanded(
            flex: 1,
            child: IconButton(icon: Icon(Icons.check), onPressed: () {}),
          ),
          Expanded(
            flex: 1,
            child: IconButton(icon: Icon(Icons.thumb_up), onPressed: () {}),
          ),
          Expanded(
            flex: 1,
            child:
                IconButton(icon: Icon(Icons.file_download), onPressed: () {}),
          ),
        ],
      ),
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
      genres: this.genres,
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
    return SmoothStarRating(
        allowHalfRating: true,
        onRated: (v) {},
        starCount: 5,
        rating: double.parse(widget.movie['vote_average']),
        size: 20.0,
        isReadOnly: true,
        color: Colors.yellow,
        borderColor: Colors.yellow,
        spacing: 0.0);
  }
}
