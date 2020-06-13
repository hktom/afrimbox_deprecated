import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CircularAvatar extends StatefulWidget {
  final String image;
  final String title;
  final double id;
  final double height;

  CircularAvatar({Key key, this.id, this.title:'', this.image, this.height:double.infinity}) : super(key: key);

  @override
  _CircularAvatarState createState() => _CircularAvatarState();
}

class _CircularAvatarState extends State<CircularAvatar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          child: Container(
        width: double.infinity,
        height: widget.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(widget.image),
            ),
            Tex(content: widget.title,)
          ]
        )
      ),
    );
  }
}
