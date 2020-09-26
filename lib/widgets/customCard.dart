import 'package:afrimbox/screen/movie/detailsMovieScreen.dart';
import 'package:afrimbox/widgets/img.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:get/get.dart';

class CustomCard extends StatefulWidget {
  final Map movie;

  CustomCard({Key key, this.movie}) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  String placeholder = 'assets/movie_placeholder.png';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(DetailsMovieScreen(movie: widget.movie)),
      child: Container(
        width: double.infinity,
        height: 250,
        child: Stack(
          children: <Widget>[
            _moviePoster(widget.movie),
            Container(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              width: double.infinity,
              height: double.infinity,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 45, left: 20),
                child: Tex(
                  content: widget.movie['title']['rendered'],
                  size: 'h2',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _moviePoster(movie) {
    var _image = placeholder;
    if (widget.movie["_embedded"]["wp:featuredmedia"] != null) {
      _image = widget.movie["_embedded"]["wp:featuredmedia"][0]["media_details"]
          ["sizes"]["medium"]["source_url"];
    } else {
      _image = null;
    }

    return Img(url: _image, placeholder: placeholder, height: 300);
  }
}
