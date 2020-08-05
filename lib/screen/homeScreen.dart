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

class _HomeScreenState extends State<HomeScreen> {
  bool loadData = false;
  var connectivity;
  bool isOnline = true;
  int counter = 1;
  MovieProvider movieModel;
  ChannelProvider channelModel;
  Map<String, dynamic> display = {};

  //load more
  Future<void> loadMore(int increment) async {
    if (increment < category.length) {
      var genre = category[increment];
      await movieModel.getByGenre(genre['key'].toString());
      counter = increment + 1;
    }
  }

  Future<void> getMoviesChannels() async {
    await movieModel.get();
    await channelModel.get();
    setState(() {});
  }

  @override
  initState() {
    movieModel = Provider.of<MovieProvider>(context, listen: false);
    channelModel = Provider.of<ChannelProvider>(context, listen: false);
    //getMoviesChannels();
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
    return Scaffold(
      appBar: AppBar(
        //elevation: 0,
        title: Text('AFRIMBOX'),
        actions: <Widget>[
          // IconButton(
          //   padding: EdgeInsets.zero,
          //   onPressed: () {},
          //   icon: Icon(Icons.cast, color: Colors.white, size: 25),
          // ),
          // IconButton(
          //   padding: EdgeInsets.zero,
          //   onPressed: () {},
          //   icon: Icon(Icons.search, color: Colors.white, size: 25),
          // ),
        ],
      ),
      drawer: Menu(),
      body: Container(
        child: content(),
      ),
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

  Widget content() {
    return Container(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            //loadMore(counter);
            print("reach bottom");
          }
        },
        child: CustomScrollView(
          slivers: <Widget>[
            //if user is offline display bar
            offLineBar(),
            // large card
            lastMovie(),
            // channel
            sliverTitle("Nos chaines", null),
            listChannels(),
            //movies lists
            sliverTitle("Films populaires", "Tous"),
            listMovies(0),
            //movies Action
            // sliverTitle("Actions", "Action"),
            // listMovies(display['Action']),

            // for (var i = 0; i < movieModel.moviesByGenre.length; i++)
            //   if (movieModel.moviesByGenre[i] != null)
            //     sliverTitle("Animations", "Animation"),
            // listMovies(display['Animation']),
          ],
        ),
      ),
    );
  }

  Widget sliverTitle(String title, String genre) {
    return SliverPadding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        sliver: SliverToBoxAdapter(
            child: ListTile(
          leading: Tex(
              content: title,
              size: 'h5',
              color: Theme.of(context).primaryColor),
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
              color: Theme.of(context).primaryColor,
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
    var data = index == 0 ? movieModel.movies : movieModel.moviesByGenre[index];
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(5),
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: MoviesController.poster(
              offset: index == 0 ? 1 : 0, limit: double.infinity, data: data),
        ),
      ),
    );
  }
}
