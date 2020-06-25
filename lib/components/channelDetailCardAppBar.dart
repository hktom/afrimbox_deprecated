import 'package:afrimbox/controller/moviesController.dart';
import 'package:afrimbox/screen/trailerPlayerScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:badges/badges.dart';

class ChannelDetailCardAppBar extends StatefulWidget {
  final Map channel;
  final List genres;
  ChannelDetailCardAppBar({Key key, this.channel, this.genres}) : super(key: key);

  @override
  _ChannelDetailCardAppBarState createState() => _ChannelDetailCardAppBarState();
}

class _ChannelDetailCardAppBarState extends State<ChannelDetailCardAppBar> {
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
          //_listGenres(),
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
          //backgroundColor: Colors.yellow,
          onPressed: () {},
          child: Icon(Icons.play_arrow),
        ),
      ),
    );
  }

  // Widget _listGenres() {
  //   return Align(
  //     alignment: Alignment.bottomLeft,
  //     child: Container(
  //       height: 40,
  //       padding: EdgeInsets.zero,
  //       margin: EdgeInsets.only(left: 10, right: 10, bottom: 60),
  //       child: ListView(
  //         padding: EdgeInsets.zero,
  //         //shrinkWrap: true,
  //         scrollDirection: Axis.horizontal,
  //         children: channelsController.genres(
  //             offset: 0, limit: double.infinity, data: widget.genres),
  //       ),
  //     ),
  //   );
  // }

  Widget _title() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.80,
          margin: EdgeInsets.only(bottom: 100, left: 10),
          child: Tex(
            content: unescape.convert(widget.channel['title']['rendered']),
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
      imageUrl: widget.channel['better_featured_image']['source_url'],
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