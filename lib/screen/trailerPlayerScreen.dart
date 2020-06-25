import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: ()async{
        Get.back();
        return true;
      },
          child: Scaffold(
        body: Container(
            color: Colors.black,
            child: YoutubePlayerBuilder(
              player:
                  YoutubePlayer(controller: _controller),
              builder: (context, player) {
                return Column(
                  children: <Widget>[
                    player,
                  ],
                );
              },
            )),
      ),
    );
  }
}
