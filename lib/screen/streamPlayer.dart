import 'package:afrimbox/helpers/const.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class StreamPlayer extends StatefulWidget {
  final Map streamUrl;
  StreamPlayer({Key key, this.streamUrl}) : super(key: key);
  @override
  _StreamPlayerState createState() => _StreamPlayerState();
}

class _StreamPlayerState extends State<StreamPlayer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //flick
  FlickManager flickManager;

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.network(widget.streamUrl['flux_movie']),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      bool _appBar = true;
      if (orientation == Orientation.portrait) {
        _appBar = true;
      } else {
        _appBar = false;
      }
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        appBar: _appBar
            ? AppBar(
                backgroundColor: Colors.black,
              )
            : null,
        body: Center(
          child: Container(
            height: 200,
            child: FlickVideoPlayer(flickManager: flickManager),
          ),
        ),
      );
    });
  }
}
