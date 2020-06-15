import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCard extends StatefulWidget {
  final int id;
  final String image;
  final String title;
  final String content;
  final double height;
  final bool overlay;

  CustomCard({Key key, this.id, this.title:'', this.image, this.height:double.infinity, this.content, this.overlay:false}) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          child: Container(
        width: double.infinity,
        height: widget.height,
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              imageUrl: widget.image,
              placeholder: (context, url) => Container(color: Colors.grey[300],),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),

            widget.overlay?Container(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              width: double.infinity,
              height: double.infinity,
            ):Container(),

            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom:45, left:20),
                child: Tex(content:widget.title, size: 'h2', color: Colors.white,),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
