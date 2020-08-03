import 'package:afrimbox/components/menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/itemsProvider.dart';
import 'package:afrimbox/controller/moviesController.dart';

class ChannelArchive extends StatefulWidget {
  @override
  _ChannelArchiveState createState() => _ChannelArchiveState();
}

class _ChannelArchiveState extends State<ChannelArchive> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var channels = [];
  double itemHeight;
  double itemWidth;
  bool loadData = false;
  String title = '';

  @override
  void initState() {
    var model = Provider.of<ItemsProvider>(context, listen: false);
    channels = model.items['channels'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    itemHeight = (size.height - kToolbarHeight - 24) / 2;
    itemWidth = size.width / 2;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Get.back()),
        elevation: 0,
        title: Text("Nos chaines"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () => _scaffoldKey.currentState.openDrawer())
        ],
      ),
      drawer: Menu(),
      body: ListView(
        children: MoviesController.channelPosterGrid(
            offset: 0, limit: double.infinity, data: channels),
      ),
    );
  }

  Stack buildStack() {
    return Stack(
      children: <Widget>[
        GridView.count(
          crossAxisCount: 1,
          childAspectRatio: (itemWidth / itemHeight),
          children: MoviesController.channelPosterGrid(
              offset: 0, limit: double.infinity, data: channels),
        ),
      ],
    );
  }
}
