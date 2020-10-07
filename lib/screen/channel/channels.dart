import 'package:afrimbox/widgets/menu.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/ChannelProvider.dart';
import 'package:afrimbox/controller/moviesController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isAdulteMode = false;
  bool onAdulteMode = false;
  bool _isLoading = false;
  int page = 9;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _refresh() async {
    model.getChannels();
    _refreshController.refreshCompleted();
  }

  @override
  bool get wantKeepAlive => true;

  _checkAdulteMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isAdulteMode = prefs.getBool('adulteMode') == null
        ? false
        : prefs.getBool('adulteMode');
    setState(() {});
  }

  @override
  void initState() {
    model = Provider.of<ChannelProvider>(context, listen: false);
    _checkAdulteMode();
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
              leading: onAdulteMode
                  ? IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() => onAdulteMode = false);
                      })
                  : IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Get.back();
                      }),
              title: Tex(
                content: "Les chaines",
                size: 'h4',
              ),
              actions: [
                isAdulteMode
                    ? IconButton(
                        icon: Icon(Icons.child_care),
                        onPressed: () {
                          setState(() => onAdulteMode = true);
                        })
                    : SizedBox.shrink(),
              ],
            )
          : null,
      body: Consumer<ChannelProvider>(builder: (context, model, child) {
        return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // if (!_isLoading &&
              //     scrollInfo.metrics.pixels >=
              //         scrollInfo.metrics.maxScrollExtent) {
              //   setState(() => _isLoading = true);
              //   _loadMore();
              // }
              return true;
            },
            child: SmartRefresher(
              enablePullUp: true,
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: _refresh,
              child: _buildStack(
                  onAdulteMode ? model.adultChannels : model.channels),
            ));
      }),
    );
  }

  Future<void> _loadMore() async {
    int newpage = await model.pagination(page: page);
    setState(() => page = newpage);
    setState(() => _isLoading = false);
  }

  Widget _buildStack(channels) {
    return Container(
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (itemWidth / itemHeight),
        children: MoviesController.channelPosterGrid(
            offset: 0, limit: double.infinity, data: channels),
      ),
    );
  }
}
