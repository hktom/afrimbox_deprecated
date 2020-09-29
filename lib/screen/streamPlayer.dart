import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/moviesProvider.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class StreamPlayer extends StatefulWidget {
  final Map movie;
  final String streamUrl;
  final bool isChannel;
  final String streamTitle;
  StreamPlayer(
      {Key key,
      this.streamUrl,
      this.isChannel: false,
      this.streamTitle,
      this.movie})
      : super(key: key);
  @override
  _StreamPlayerState createState() => _StreamPlayerState();
}

class _StreamPlayerState extends State<StreamPlayer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MoviesProvider moviesProvider;
  UserProvider userProvider;
  //flick
  FlickManager flickManager;

  Future<void> addView() async {
    Map<String, dynamic> movie = moviesProvider.movieReducer(widget.movie);
    bool check = moviesProvider.hasUserAlreadyViewTheMovie(
        userId: userProvider.currentUser[0]['id'],
        movieId: widget.movie['id'].toString());
    bool hasViews =
        moviesProvider.hasMovieGotViews(movieId: widget.movie['id'].toString());

    if (!check && !hasViews) {
      moviesProvider.addView(
          movie: movie, userId: userProvider.currentUser[0]['id']);
    } else if (!check && hasViews) {
      moviesProvider.updateView(
          movieId: widget.movie['id'].toString(),
          userId: userProvider.currentUser[0]['id']);
    } else {}
  }

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
    moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getFirebaseMovies();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.streamUrl),
    );
    if (!widget.isChannel) addView();
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
