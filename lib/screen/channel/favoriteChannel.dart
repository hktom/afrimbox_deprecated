import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/controller/moviesController.dart';
//import 'package:afrimbox/components/menu.dart';
//import 'package:get/get.dart';
//import 'package:afrimbox/provider/ChannelProvider.dart';

class FavoriteChannel extends StatefulWidget {
  //final bool displayAppBar;
  //FavoriteChannel({Key key, this.displayAppBar}) : super(key: key);
  @override
  _FavoriteChannelState createState() => _FavoriteChannelState();
}

class _FavoriteChannelState extends State<FavoriteChannel>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //var channels = [];
  double itemHeight;
  double itemWidth;
  bool loadData = false;
  String title = '';
  UserProvider model;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    model = Provider.of<UserProvider>(context, listen: false);
    //channels = model.items['channels'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    itemHeight = (size.height - kToolbarHeight - 24) / 2;
    itemWidth = size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Tex(content: "Mes chaines", size: 'h4'),
      ),
      body: _buildStack(),
    );
  }

  Stack _buildStack() {
    return Stack(
      children: <Widget>[
        GridView.count(
          crossAxisCount: 3,
          childAspectRatio: (itemWidth / itemHeight),
          children: MoviesController.channelPosterGrid(
              offset: 0,
              limit: double.infinity,
              data: model.favoriteChannels()),
        ),
      ],
    );
  }
}
