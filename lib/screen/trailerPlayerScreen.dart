import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerPlayerScreen extends StatefulWidget {
  final String trailerUrl;
  TrailerPlayerScreen({Key key, this.trailerUrl}) : super(key: key);
  @override
  _TrailerPlayerScreenState createState() => _TrailerPlayerScreenState();
}

class _TrailerPlayerScreenState extends State<TrailerPlayerScreen> {
  YoutubePlayerController _controller;

  @override
  void dispose() {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.trailerUrl),
      // flags: YoutubePlayerFlags(
      //   mute: false,
      // ),
    );
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return portrait();
        } else {
          return landscape();
        }
      }),
    );
  }

  Widget portrait() {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: double.infinity,
          height: 300,
          color: Colors.black,
          child: YoutubePlayer(
            controller: _controller,
            //liveUIColor: Colors.amber,
          ),
        ),
      ),
    );
  }

  Widget landscape() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: YoutubePlayer(
          controller: _controller,
          //liveUIColor: Colors.amber,
        ),
      ),
    );
  }
}
