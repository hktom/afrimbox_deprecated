import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ChannelPlayer extends StatefulWidget {
  final String channelUrl;
  ChannelPlayer({Key key, this.channelUrl}) : super(key: key);
  @override
  _ChannelPlayerState createState() => _ChannelPlayerState();
}

class _ChannelPlayerState extends State<ChannelPlayer> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.channelUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio, child: _player());
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _player() {
    return Stack(
      children: <Widget>[
        VideoPlayer(_controller),
        Align(
          alignment: Alignment.center,
          child: Opacity(
            opacity: _controller.value.isPlaying ? 0.0 : 1,
            child: FloatingActionButton(
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  //size: 100,
                ),
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                }),
          ),
        ),
      ],
    );
  }
}
