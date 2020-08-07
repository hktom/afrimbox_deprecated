//import 'package:afrimbox/components/loadingSpinner.dart';
import 'package:afrimbox/components/menu.dart';
import 'package:afrimbox/controller/moviesController.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/screen/archive/movieArchive.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/provider/MovieProvider.dart';
import 'package:afrimbox/provider/ChannelProvider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:afrimbox/helpers/const.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loadData = false;
  var connectivity;
  bool isOnline = true;
  int counter = 2;
  MovieProvider movieModel;
  ChannelProvider channelModel;

  //load more
  Future<void> loadMore(int index) async {
    counter = await movieModel.loadMore(counter: index);
    setState(() {});
    //}
  }

  Future<void> getMoviesChannels() async {
    await movieModel.get();
    await channelModel.get();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    movieModel = Provider.of<MovieProvider>(context, listen: false);
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
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 400) {
            loadMore(counter);
          }
        },
        child: CustomScrollView(
          slivers: _returnSlivers(),
        ),
      ),
    );
  }

  List<Widget> _returnSlivers() {
    List<Widget> slivers = [];
    slivers.add(offLineBar());
    slivers.add(lastMovie());
    slivers.add(sliverTitle("Nos chaines", null));
    slivers.add(listChannels());
    slivers.add(sliverTitle("Films populaires", "Popular"));
    slivers.add(listMovies(1));

    for (var i = 2; i < movieModel.moviesByGenre.length; i++) {
      var genre = category[i]['key'];
      if (movieModel.moviesByGenre[genre.toString()] != null) {
        slivers.add(sliverTitle(category[i]['label'], category[i]['label']));
        slivers.add(listMovies(genre));
      }
    }

    slivers.add(SliverPadding(padding: EdgeInsets.only(top: 50)));

    return slivers;
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
              if (genre != null) {
                Get.to(MovieArchive(genre: genre));
              } else {
                Get.toNamed('/channelArchive');
              }
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
