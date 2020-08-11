import 'package:afrimbox/screen/movie/detailsMovieScreen.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/helpers/const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class CustomCard extends StatefulWidget {
  final Map movie;

  CustomCard({Key key, this.movie}) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  //String imageUrlPrefix = ApiUrl.urlImage;

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
    return GestureDetector(
      onTap: () => Get.to(DetailsMovieScreen(movie: widget.movie)),
      child: Container(
        width: double.infinity,
        height: 250,
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              imageUrl: appImageUrl + widget.movie['dt_poster'],
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
                      alignment: Alignment.center)),
            ),
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
}
