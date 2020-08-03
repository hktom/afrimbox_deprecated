import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:cdnbye/cdnbye.dart';
import 'package:video_player/video_player.dart';
// import 'package:flick_video_player/flick_video_player.dart';
//hls stream

class StreamChannel extends StatefulWidget {
  final String channelUrl;
  StreamChannel({Key key, this.channelUrl}) : super(key: key);
  @override
  _StreamChannelState createState() => _StreamChannelState();
}

class _StreamChannelState extends State<StreamChannel> {
  VideoPlayerController player;
  Future<void> _initializeVideoPlayerFuture;
  //FlickManager flickManager;

  _initEngine(url) async {
    //await Cdnbye.init("7r0wbwVMg", config: P2pConfig.byDefault());
    //var cdnUrl = await Cdnbye.parseStreamURL(url);
    player = VideoPlayerController.network(url);
    _initializeVideoPlayerFuture = player.initialize();
  }

  @override
  void dispose() {
    player.dispose();
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  void initState() {
    _initEngine(widget.channelUrl);
    print("URL CHANNEL ${widget.channelUrl}");
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
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: player.value.aspectRatio,
                  child: showPlayer(),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget showPlayer() {
    return Stack(
      children: <Widget>[
        VideoPlayer(player),
        Align(
          alignment: Alignment.center,
          child: Opacity(
            opacity: player.value.isPlaying ? 0.0 : 1,
            child: FloatingActionButton(
                child: Icon(
                  player.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  //size: 100,
                ),
                onPressed: () {
                  setState(() {
                    if (player.value.isPlaying) {
                      player.pause();
                    } else {
                      player.play();
                    }
                  });
                }),
          ),
        ),
      ],
    );
  }
}
