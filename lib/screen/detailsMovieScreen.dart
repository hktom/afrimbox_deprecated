import 'package:afrimbox/components/movieDetailCardAppBar.dart';
import 'package:afrimbox/screen/trailerPlayerScreen.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:get/get.dart';
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
  var favorites = [];

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
  Future<void> getFavorites() async {
    await Provider.of<ItemsProvider>(context, listen: false)
        .getItems(field: 'actions', filter: 'Action');
    setState(() {
      favorites =
          Provider.of<ItemsProvider>(context, listen: false).items['actions'];
    });
  }

  @override
  void initState() {
    getGenres();
    getActors();
    getFavorites();
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
        listFavoriteMovies()
      ]),
    );
  }

  Widget listActors() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(5),
        height: 180,
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
                  }
                  else
                  {
                    Get.snackbar('Erreur', 'Trailer non trouvé', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.black, colorText: Colors.white, duration: Duration(seconds:1));
                    
                  }
                }),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
                padding: EdgeInsets.zero,
                child: _buttonIcon(icon: Icons.share, text: 'Partager'),
                onPressed: () {}),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
                padding: EdgeInsets.zero,
                child: _buttonIcon(icon: Icons.check, text: 'Ma liste'),
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
        Icon(icon),
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

  Widget listFavoriteMovies() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(5),
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: MoviesController.poster(
              offset: 0, limit: double.infinity, data: favorites),
        ),
      ),
    );
  }
}
