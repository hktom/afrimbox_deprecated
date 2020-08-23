// import 'package:afrimbox/helpers/tex.dart';
// import 'package:afrimbox/helpers/const.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:chewie/chewie.dart';

// class StreamPlayer extends StatefulWidget {
//   final Map streamUrl;
//   StreamPlayer({Key key, this.streamUrl}) : super(key: key);
//   @override
//   _StreamPlayerState createState() => _StreamPlayerState();
// }

// class _StreamPlayerState extends State<StreamPlayer> {
//   VideoPlayerController player;
//   Future<void> _initializeVideoPlayerFuture;
//   String screenOrientation = "portrait";
//   String quality = '240p';
//   String url = '';
//   bool showSwitcher = false;
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   ChewieController chewieController;
//   //FlickManager flickManager;
//   //VLC
//   VlcPlayerController controller;
//   String urlToStreamVideo = defaultChannel;

//   double playerWidth = 640;
//   double playerHeight = 360;

//   //flick
//   FlickManager flickManager;

// String _setUrl(urls) {
//   return urls['flux_240p'] != null ? urls['flux_240p'] : urls['flux_480p'];
// }

// void _urlSwitcher(urls) {
//   //url = quality == '240p' ? urls['flux_240p'] : urls['flux_480p'];
//   switch (quality) {
//     case '240p':
//       url = urls['flux_240p'];
//       break;
//     case '480p':
//       url = urls['flux_480p'];
//       break;
//     default:
//       url = defaultChannel;
//   }
//   _initEngine(url);
//   this.setState(() {});
// }

// _initEngine(url) async {
//   //await Cdnbye.init("7r0wbwVMg", config: P2pConfig.byDefault());
//   //var cdnUrl = await Cdnbye.parseStreamURL(url);
//   player = VideoPlayerController.network(defaultChannel);
//   _initializeVideoPlayerFuture = player.initialize();
//   chewieController = ChewieController(
//     videoPlayerController: player,
//     aspectRatio: 3 / 2,
//     autoPlay: true,
//     looping: true,
//   );
// }

// void _playerOnTap() {
//   setState(() {
//     if (player.value.isPlaying) {
//       player.pause();
//     } else {
//       player.play();
//     }
//   });
// }

// @override
// void dispose() {
//   //player.dispose();
//   //chewieController.dispose();
//   //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   flickManager.dispose();
//   super.dispose();
// }

// @override
// void initState() {
//url = _setUrl(widget.streamUrl);
//_initEngine(url);
//SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
// controller = new VlcPlayerController(
//     // Start playing as soon as the video is loaded.
//     onInit: () {
//   controller.play();
// });
//   flickManager = FlickManager(
//     videoPlayerController: VideoPlayerController.network(defaultChannel),
//   );
//   super.initState();
// }

// @override
// Widget build(BuildContext context) {
//   return Chewie(
//     controller: chewieController,
//   );
// }
// @override
// Widget build(BuildContext context) {
//   return Container(
//     child: FlickVideoPlayer(flickManager: flickManager),
//   );
// }

// @override
// Widget build(BuildContext context) {
//   return WillPopScope(onWillPop: () async {
//     Get.back();
//     return true;
//   }, child: OrientationBuilder(builder: (context, orientation) {
//     if (orientation == Orientation.portrait) {
//       return _portrait();
//     } else {
//       return _landscape();
//     }
//   }));
// }

// Scaffold _portrait() {
//   return Scaffold(
//     backgroundColor: Colors.black,
//     appBar: AppBar(
//       backgroundColor: Colors.black,
//       actions: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(top: 15, right: 10),
//           child: Tex(content: "Qualité de la vidéo", color: Colors.white),
//         ),
//         DropdownButton<String>(
//           dropdownColor: Colors.black,
//           value: quality,
//           icon: FaIcon(FontAwesomeIcons.chevronDown,
//               color: Colors.white, size: 15),
//           iconSize: 24,
//           elevation: 16,
//           style: TextStyle(color: Colors.white),
//           underline: Container(
//             height: 2,
//             color: Colors.black,
//           ),
//           onChanged: (String newValue) {
//             setState(() {
//               quality = newValue;
//             });
//             _urlSwitcher(widget.streamUrl);
//           },
//           items: <String>['240p', '480p', 'défault']
//               .map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//         ),
//       ],
//     ),
//     body: Center(
//       child: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return AspectRatio(
//               aspectRatio: player.value.aspectRatio,
//               child: _showPlayer(),
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     ),
//   );
// }

// Scaffold _landscape() {
//   return Scaffold(
//     key: _scaffoldKey,
//     backgroundColor: Colors.black,
//     drawer: Drawer(
//       child: Container(),
//     ),
//     body: Center(
//       child: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return AspectRatio(
//               aspectRatio: player.value.aspectRatio,
//               child: _showPlayer(),
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     ),
//   );
// }

// Widget _showPlayer() {
//   return Stack(
//     children: <Widget>[
//       VideoPlayer(player),
//       Align(
//         alignment: Alignment.center,
//         child: _playerController(),
//       ),
//       _swictherQuality(),
//     ],
//   );
// }

// Widget _swictherQuality() {
//   return Align(
//     alignment: Alignment.bottomLeft,
//     child: AnimatedOpacity(
//       opacity: showSwitcher ? 1.0 : 0.0,
//       duration: Duration(milliseconds: 500),
//       child: Container(
//         width: 80,
//         padding: EdgeInsets.zero,
//         margin: EdgeInsets.only(top: 210),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           //mainAxisAlignment: MainAxisAlignment.end,
//           //crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FlatButton(
//                 color: Color.fromRGBO(158, 25, 25, 1),
//                 padding: EdgeInsets.zero,
//                 onPressed: () {
//                   setState(() {
//                     quality = '240p';
//                   });
//                   _urlSwitcher(widget.streamUrl);
//                 },
//                 child: Tex(
//                   content: "240p",
//                   color: Colors.white,
//                 )),
//             FlatButton(
//                 color: Color.fromRGBO(158, 25, 25, 1),
//                 padding: EdgeInsets.zero,
//                 onPressed: () {
//                   setState(() {
//                     quality = '480p';
//                   });
//                   _urlSwitcher(widget.streamUrl);
//                 },
//                 child: Tex(
//                   content: "480p",
//                   color: Colors.white,
//                 )),
//             FlatButton(
//                 color: Color.fromRGBO(158, 25, 25, 1),
//                 padding: EdgeInsets.zero,
//                 onPressed: () {
//                   setState(() {
//                     quality = 'default';
//                   });
//                   _urlSwitcher(widget.streamUrl);
//                 },
//                 child: Tex(
//                   content: "Défaut",
//                   color: Colors.white,
//                 )),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget _playerController() {
//   return AnimatedOpacity(
//     opacity: player.value.isPlaying ? 0.0 : 1.0,
//     duration: Duration(milliseconds: 500),
//     child: Row(children: <Widget>[
//       Expanded(
//         flex: 1,
//         child: GestureDetector(
//             onTap: () {
//               setState(() => showSwitcher = !showSwitcher);
//             },
//             child: Icon(Icons.settings, color: Colors.white, size: 50)),
//       ),
//       Expanded(
//         flex: 2,
//         child: GestureDetector(
//           onTap: () => _playerOnTap(),
//           child: Icon(
//             player.value.isPlaying ? Icons.pause : Icons.play_arrow,
//             color: Colors.white,
//             size: 50,
//             //size: 100,
//           ),
//         ),
//       ),
//       Expanded(
//         flex: 1,
//         child: GestureDetector(
//           onTap: () {
//             Get.back();
//           },
//           child: Icon(Icons.exit_to_app, color: Colors.white, size: 50),
//         ),
//       ),
//     ]),
//   );
// }
//}
