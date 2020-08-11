import 'package:afrimbox/components/menu.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/ChannelProvider.dart';
import 'package:afrimbox/controller/moviesController.dart';

class Channels extends StatefulWidget {
  final bool displayAppBar;
  Channels({Key key, this.displayAppBar}) : super(key: key);
  @override
  _ChannelsState createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //var channels = [];
  double itemHeight;
  double itemWidth;
  bool loadData = false;
  String title = '';
  ChannelProvider model;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    model = Provider.of<ChannelProvider>(context, listen: false);
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
      appBar: widget.displayAppBar
          ? AppBar(
              title: Tex(
                content: "Les chaines",
                size: 'h4',
              ),
            )
          : null,
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
              offset: 0, limit: double.infinity, data: model.channels),
        ),
      ],
    );
  }
}
