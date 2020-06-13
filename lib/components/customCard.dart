import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCard extends StatefulWidget {
  final String image;
  final String title;
  final double id;
  final double height;

  CustomCard({Key key, this.id, this.title:'', this.image, this.height:double.infinity}) : super(key: key);

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
              imageUrl: widget.image,
              placeholder: (context, url) => Container(color: Colors.grey[300],),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Tex(content:widget.title, size: 'h2',),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
