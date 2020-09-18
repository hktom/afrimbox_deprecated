//import 'package:afrimbox/widgets/loadingSpinner.dart';
import 'package:afrimbox/controller/moviesController.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/moviesProvider.dart';
import 'package:afrimbox/screen/channel/channels.dart';
import 'package:afrimbox/screen/movie/movies.dart';
import 'package:afrimbox/widgets/homeCard.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/provider/ChannelProvider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:afrimbox/helpers/const.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
//import 'package:afrimbox/widgets/menu.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  var connectivity;
  bool isOnline = true;
  int page = 2;
  MoviesProvider movieModel;
  ChannelProvider channelModel;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  //load more
  Future<void> _loadMore(int index) async {
    await movieModel.loadMore(index).then((value) {
      page = value;
      setState(() => _isLoading = false);
    });
  }

  Future<void> getMoviesChannels() async {
    await movieModel.get().then((value) async {
      await channelModel.get();
    });
  }

  void _refresh() async {
    await movieModel.get().then((value) async {
      await channelModel.get();
    });
    _refreshController.refreshCompleted();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    movieModel = Provider.of<MoviesProvider>(context, listen: false);
    channelModel = Provider.of<ChannelProvider>(context, listen: false);
    movieModel.resetPendingReq();
    connectivity = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() => isOnline = true);
        getMoviesChannels();
      } else {
        setState(() => isOnline = false);
      }
    });
    //getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      body: _scaffold(),
    );
  }

  Widget offLineBar() {
    return SliverToBoxAdapter(
      child: AnimatedOpacity(
        opacity: !isOnline ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Container(
          width: double.infinity,
          height: !isOnline ? 20 : 0,
          color: Colors.blue[300],
          child: Tex(
            align: TextAlign.center,
            content: "Mode hors ligne",
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _scaffold() {
    return Container(
      child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
        if (!_isLoading &&
            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent) {
          print("load more");
          setState(() => _isLoading = true);
          _loadMore(page);
        }
      }, child: Consumer<MoviesProvider>(builder: (context, model, child) {
        if (model.pending['get']) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return SmartRefresher(
          controller: _refreshController,
          onRefresh: _refresh,
          enablePullUp: false,
          enablePullDown: true,
          child: CustomScrollView(
            slivers: _returnSlivers(),
          ),
        );
      })),
    );
  }

  void updateCurrentGenre(currentCategory) {
    movieModel.setCurrentGenre(currentCategory);
    Get.to(Movies(displayAppBar: true));
  }

  List<Widget> _returnSlivers() {
    List<Widget> slivers = [];
    slivers.add(offLineBar());
    slivers.add(lastMovie());
    slivers.add(sliverTitle("Nos chaines", null));
    slivers.add(listChannels());
    //slivers.add(sliverTitle("Films populaires", category[1]['label']));
    //slivers.add(listMovies(1));

    movieModel.moviesByGenre.forEach((key, value) {
      if (key != '0') {
        Map _category = _returnCategory(key);
        slivers.add(
          SliverToBoxAdapter(
              child: HomeCard(
            updateCurrentGenre: updateCurrentGenre,
            data: value,
            category: _category,
          )),
        );
      }
    });

    if (movieModel.pending['getByGenre']) {
      slivers.add(SliverToBoxAdapter(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 162, vertical: 20),
        child: CircularProgressIndicator(),
      )));
    }
    slivers.add(SliverPadding(padding: EdgeInsets.only(top: 50)));

    return slivers;
  }

  Map _returnCategory(genreKey) {
    Map _category = {};
    category.forEach((element) {
      if (element['key'].toString() == genreKey) {
        _category = element;
      }
    });
    return _category;
  }

  Widget sliverTitle(String title, String genre) {
    return SliverPadding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        sliver: SliverToBoxAdapter(
            child: ListTile(
          leading: Tex(
            content: title,
            size: 'h5',
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
            onPressed: () {
              Get.to(Channels(displayAppBar: true));
            },
            icon: FaIcon(
              FontAwesomeIcons.th,
              color: Theme.of(context).accentColor,
            ),
          ),
        )));
  }

// display on the top
  Widget lastMovie() {
    return SliverList(
      delegate: SliverChildListDelegate(
        MoviesController.myCard(
          offset: 0,
          limit: 0,
          data: movieModel.movies,
        ),
      ),
    );
  }

  Widget listChannels() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(5),
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: MoviesController.myChannels(
              offset: 0, limit: double.infinity, data: channelModel.channels),
        ),
      ),
    );
  }

  Widget listMovies(int index) {
    var data = movieModel.moviesByGenre[index.toString()] != null
        ? movieModel.moviesByGenre[index.toString()]
        : [];
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(5),
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: MoviesController.poster(
              offset: 0, limit: double.infinity, data: data),
        ),
      ),
    );
  }
}
