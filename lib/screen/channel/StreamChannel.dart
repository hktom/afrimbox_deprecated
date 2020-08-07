import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:cdnbye/cdnbye.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  String screenOrientation = "portrait";
  String quality = '360p';
  //FlickManager flickManager;

  _initEngine(url) async {
    //await Cdnbye.init("7r0wbwVMg", config: P2pConfig.byDefault());
    //var cdnUrl = await Cdnbye.parseStreamURL(url);
    player = VideoPlayerController.network(url);
    _initializeVideoPlayerFuture = player.initialize();
  }

  void _playerOnTap() {
    setState(() {
      if (player.value.isPlaying) {
        player.pause();
      } else {
        player.play();
      }
    });
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
    return WillPopScope(onWillPop: () async {
      Get.back();
      return true;
    }, child: OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return _portrait();
      } else {
        return _landscape();
      }
    }));
  }

  Scaffold _portrait() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 10),
            child: Tex(content: "Qualité de la vidéo", color: Colors.white),
          ),
          DropdownButton<String>(
            dropdownColor: Colors.black,
            value: quality,
            icon: FaIcon(FontAwesomeIcons.chevronDown,
                color: Colors.white, size: 15),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.white),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (String newValue) {
              setState(() {
                quality = newValue;
              });
            },
            items: <String>['144p', '360p', '480p', '720p']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
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
    );
  }

  Scaffold _landscape() {
    return Scaffold(
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
    );
  }

  Widget showPlayer() {
    return Stack(
      children: <Widget>[
        VideoPlayer(player),
        Align(
          alignment: Alignment.center,
          child: _buttonPlayStop(),
        ),
      ],
    );
  }

  Widget _buttonPlayStop() {
    return AnimatedOpacity(
      opacity: player.value.isPlaying ? 0.0 : 1.0,
      duration: Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: () => _playerOnTap(),
        child: Icon(
          player.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 150,
          //size: 100,
        ),
      ),
    );
  }
}
