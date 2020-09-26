import 'package:afrimbox/screen/channel/channelDetailScreen.dart';
import 'package:afrimbox/screen/movie/detailsMovieScreen.dart';
import 'package:afrimbox/widgets/img.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardRounded extends StatefulWidget {
  final Map movie;
  final bool isChannel;
  final double height;
  final double width;
  final EdgeInsetsGeometry margin;

  CardRounded(
      {Key key,
      this.movie,
      this.isChannel: false,
      this.height,
      this.margin: EdgeInsets.zero,
      this.width})
      : super(key: key);

  @override
  _CardRoundedState createState() => _CardRoundedState();
}

class _CardRoundedState extends State<CardRounded> {
  String placeholder = '';

  String setImagePlaceholder() {
    if (widget.isChannel) {
      return 'assets/channel_placeholder.png';
    } else {
      return 'assets/movie_placeholder.png';
    }
  }

  @override
  void initState() {
    placeholder = setImagePlaceholder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isChannel) {
          Get.to(ChannelDetailScreen(channel: widget.movie));
        } else {
          Get.to(DetailsMovieScreen(movie: widget.movie));
        }
      },
      child: Container(
        margin: widget.margin,
        height: widget.height,
        width: widget.width,
        child: _poster(widget.isChannel),
      ),
    );
  }

  Widget _poster(isChannel) {
    var _image = placeholder;
    if (isChannel) {
      if (widget.movie['better_featured_image'] != null) {
        _image = widget.movie['better_featured_image']["source_url"];
      } else {
        _image = null;
      }
    } else {
      if (widget.movie["_embedded"]["wp:featuredmedia"] != null) {
        _image = widget.movie["_embedded"]["wp:featuredmedia"][0]
            ["media_details"]["sizes"]["medium"]["source_url"];
      } else {
        _image = null;
      }
    }

    return Img(url: _image, placeholder: placeholder, height: 300);
  }
}
