import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Img extends StatefulWidget {
  final String url;
  final String placeholder;
  final double height;

  Img({Key key, this.height, this.placeholder, this.url}) : super(key: key);
  @override
  _ImgState createState() => _ImgState();
}

class _ImgState extends State<Img> {
  @override
  Widget build(BuildContext context) {
    if (widget.url == null) {
      return _assetImage();
    } else {
      return _loadImg();
    }
  }

  Widget _loadImg() {
    return CachedNetworkImage(
      width: double.infinity,
      height: widget.height,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      imageUrl: widget.url,
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
        child: Image.asset(widget.placeholder,
            width: double.infinity,
            height: widget.height,
            fit: BoxFit.cover,
            alignment: Alignment.center),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        child: Image.asset(widget.placeholder,
            width: double.infinity,
            height: widget.height,
            fit: BoxFit.cover,
            alignment: Alignment.center),
      ),
    );
  }

  Widget _assetImage() {
    return Image.asset(widget.placeholder,
        width: double.infinity,
        height: widget.height,
        fit: BoxFit.cover,
        alignment: Alignment.center);
  }
}
