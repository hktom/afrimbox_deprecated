import 'package:afrimbox/controller/moviesController.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:afrimbox/screen/streamPlayer.dart';
import 'package:afrimbox/widgets/img.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

class MovieDetailCardAppBar extends StatefulWidget {
  final Map movie;
  final List genres;
  MovieDetailCardAppBar({Key key, this.movie, this.genres}) : super(key: key);

  @override
  _MovieDetailCardAppBarState createState() => _MovieDetailCardAppBarState();
}

class _MovieDetailCardAppBarState extends State<MovieDetailCardAppBar> {
  var unescape = new HtmlUnescape();
  String placeholder = 'assets/movie_placeholder.png';
  int bundleActive = 0;
  UserProvider model;

  getRemainDays() {
    model = Provider.of<UserProvider>(context, listen: false);
    bundleActive = model.subscriptionRemainDays();
  }

  @override
  void initState() {
    super.initState();
    getRemainDays();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Stack(
        children: <Widget>[
          _background(widget.movie),
          _filter(),
          _appBar(),
          _columnTitleGenres(),
          _floatButton(),
        ],
      ),
    );
  }

  Widget _floatButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 24, right: 10),
        child: FloatingActionButton(
          onPressed: () {
            if (bundleActive > 0) {
              if (widget.movie['acf']['flux_movie'] != null) {
                Get.to(StreamPlayer(
                    movie: widget.movie,
                    streamTitle:
                        unescape.convert(widget.movie['title']['rendered']),
                    streamUrl: widget.movie['acf']['flux_movie'],
                    isChannel: false));
              }
            } else {
              Get.toNamed('/subscription');
            }
          },
          child: Icon(Icons.play_arrow),
        ),
      ),
    );
  }

  Widget _columnTitleGenres() {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[_title(), _listGenres()],
      ),
    );
  }

  Widget _listGenres() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        //height: 40,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 0),
        child: Wrap(
          direction: Axis.horizontal,
          children: MoviesController.genres(
              offset: 0, limit: double.infinity, data: widget.genres),
        ),
      ),
    );
  }

  Widget _title() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.80,
          margin: EdgeInsets.only(bottom: 0, left: 10),
          child: Tex(
            content: unescape.convert(widget.movie['title']['rendered']),
            size: 'h2',
            bold: FontWeight.bold,
            color: Colors.white,
          )),
    );
  }

  Widget _background(movie) {
    var _image = placeholder;
    if (widget.movie["_embedded"]["wp:featuredmedia"] != null) {
      _image = widget.movie["_embedded"]["wp:featuredmedia"][0]["media_details"]
          ["sizes"]["medium"]["source_url"];
    } else {
      _image = null;
    }
    return Img(url: _image, placeholder: placeholder, height: 300);
  }

  Widget _filter() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.2),
      width: double.infinity,
      height: 300,
    );
  }

  Widget _appBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      //color: Color.fromRGBO(0, 0, 0, 0.2),
      child: ListTile(
        dense: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.cast, color: Colors.white, size: 25),
        ),
      ),
    );
  }
}
