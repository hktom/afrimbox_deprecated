import 'package:afrimbox/screen/channelDetailScreen.dart';
import 'package:afrimbox/screen/detailsMovieScreen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  String imageUrlPrefix =
      "https://afrimbox.groukam.com/App/wp-content/uploads/2020/06/";
  String image;

  @override
  void initState() {
    image = widget.isChannel
        ? widget.movie['better_featured_image']['source_url']
        : imageUrlPrefix + widget.movie['dt_poster'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          if(widget.isChannel){
            Get.to(ChannelDetailScreen(channel: widget.movie));
          }
          else
          {
            Get.to(DetailsMovieScreen(movie: widget.movie));
          }
        },
        child: Container(
        margin: widget.margin,
        height: widget.height,
        width: widget.width,
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(10),
        // ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            imageUrl: this.image,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }
}