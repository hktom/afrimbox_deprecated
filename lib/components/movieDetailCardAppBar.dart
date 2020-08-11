import 'package:afrimbox/controller/moviesController.dart';
import 'package:afrimbox/screen/movie/trailerPlayerScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:badges/badges.dart';
import 'package:afrimbox/helpers/const.dart';

class MovieDetailCardAppBar extends StatefulWidget {
  final Map movie;
  final List genres;
  MovieDetailCardAppBar({Key key, this.movie, this.genres}) : super(key: key);

  @override
  _MovieDetailCardAppBarState createState() => _MovieDetailCardAppBarState();
}

class _MovieDetailCardAppBarState extends State<MovieDetailCardAppBar> {
  //String imageUrlPrefix = ApiUrl.urlImage;
  var unescape = new HtmlUnescape();
  String image = '';
  String placeholder = 'assets/movie_placeholder.png';

  String setImage() {
    if (widget.movie['dt_poster'] != null) {
      return appImageUrl + widget.movie['dt_poster'];
    } else {
      return placeholder;
    }
  }

  @override
  void initState() {
    image = setImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Stack(
        children: <Widget>[
          _background(),
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
          onPressed: () {},
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

  Widget _background() {
    return CachedNetworkImage(
      width: double.infinity,
      height: 300,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      imageUrl: image,
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
        child: Image.asset(placeholder,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            alignment: Alignment.center),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        child: Image.asset(placeholder,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            alignment: Alignment.center),
      ),
    );
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
