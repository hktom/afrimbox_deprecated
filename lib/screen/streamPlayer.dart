import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class StreamPlayer extends StatefulWidget {
  final String streamUrl;
  final bool isChannel;
  final String streamTitle;
  StreamPlayer(
      {Key key, this.streamUrl, this.isChannel: false, this.streamTitle})
      : super(key: key);
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
    // String _url = widget.isChannel
    //     ? widget.streamUrl['flux_240p']
    //     : widget.streamUrl['flux_movie'];
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.streamUrl),
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
                title: Tex(content: widget.streamTitle, color: Colors.white),
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
