import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';

class MovieDetailCardAppBar extends StatefulWidget {
  final Map movie;
  final List genres;
  MovieDetailCardAppBar({Key key, this.movie, this.genres}) : super(key: key);

  @override
  _MovieDetailCardAppBarState createState() => _MovieDetailCardAppBarState();
}

class _MovieDetailCardAppBarState extends State<MovieDetailCardAppBar> {
  String imageUrlPrefix =
      "https://afrimbox.groukam.com/App/wp-content/uploads/2020/06/";
      var unescape = new HtmlUnescape();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Stack(
        children: <Widget>[
          _background(),
          _filter(),
          _appBar(),
          _title(),
          _listTags(),
          _floatButton()
        ],
      ),
    );
  }

  Widget _floatButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin:  EdgeInsets.only(bottom:24, right: 10),
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.play_arrow),
        ),
      ),
    );
  }

  Widget _listTags() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: <Widget>[],
        ),
      ),
    );
  }

  Widget _title() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.80,
          margin: EdgeInsets.only(bottom:100, left:10),
          child: Tex(
            content: unescape.convert(widget.movie['title']['rendered']),
            size: 'h2',
            bold:FontWeight.bold,
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
      imageUrl: imageUrlPrefix + widget.movie['dt_poster'],
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
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
      padding: EdgeInsets.symmetric(vertical:15),
      //color: Color.fromRGBO(0, 0, 0, 0.2),
      child: ListTile(
        dense: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white, size:30),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.cast, color: Colors.white, size:25),
        ),
      ),
    );
  }

}
