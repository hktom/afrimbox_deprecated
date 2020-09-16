import 'package:afrimbox/screen/channel/channelDetailScreen.dart';
import 'package:afrimbox/screen/movie/detailsMovieScreen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:afrimbox/helpers/const.dart';

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
  //String imageUrlPrefix = ApiUrl.urlImage;
  String image = '';
  String placeholder = '';
  bool imageLoaded = false;

  String setImagePlaceholder() {
    if (widget.isChannel) {
      return 'assets/channel_placeholder.png';
    } else {
      return 'assets/movie_placeholder.png';
    }
  }

  Future<void> setImage() async {
    if (widget.isChannel && widget.movie['better_featured_image'] != null) {
      image = widget.movie['better_featured_image']['source_url'];
    } else if (widget.movie['dt_poster'] != null) {
      await moviePoster(widget.movie).then((value) => setState(() {
            image = value;
            imageLoaded = true;
          }));
    } else {
      image = placeholder;
      setState(() {
        imageLoaded = true;
      });
    }
  }

  @override
  void initState() {
    placeholder = setImagePlaceholder();
    setImage();
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
        child: imageLoaded ? _imagePoster() : _imagePlaceholder(),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(placeholder,
          width: double.infinity,
          fit: BoxFit.cover,
          alignment: Alignment.center),
    );
  }

  Widget _imagePoster() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        imageUrl: image,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: Image.asset(placeholder,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.center),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: Image.asset(placeholder,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.center),
        ),
      ),
    );
  }
}
