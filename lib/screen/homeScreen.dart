import 'package:afrimbox/components/loadingSpinner.dart';
import 'package:afrimbox/components/menu.dart';
import 'package:afrimbox/controller/moviesController.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/screen/archive/movieArchive.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/provider/itemsProvider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var movies = [];
  var actions = [];
  var animations = [];
  var channels = [];
  bool loadData = false;

  Future<void> getMovies() async {
    var model = Provider.of<ItemsProvider>(context, listen: false);
    await model.getAllMovies();
    await model.getAllChannels();
    await model.getMovieByGenre(genre: 'Animation');
    await model.getMovieByGenre(genre: 'Action');

    movies = model.items['movies'];
    channels = model.items['channels'];
    actions = model.items['Action'];
    animations = model.items['Animation'];

    setState(() {});
  }

  @override
  void initState() {
    getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //elevation: 0,
        title: Text('AFRIMBOX'),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Icon(Icons.cast, color: Colors.white, size: 25),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.white, size: 25),
          ),
        ],
      ),
      drawer: Menu(),
      body: Container(
        child: content(),
      ),
    );
  }

  Widget content() {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          // large card
          lastMovie(),
          // channel
          sliverTitle("Nos chaines", "Null"),
          listChannels(),
          // actors
          //movies Action
          sliverTitle("Actions", "Action"),
          listActionsMovies(),
          //movies Animation
          sliverTitle("Animations", "Animation"),
          listAnimationMovies()
        ],
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
              if (genre != "Null") {
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
          data: movies,
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
              offset: 0, limit: double.infinity, data: channels),
        ),
      ),
    );
  }

  Widget listActionsMovies() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(5),
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: MoviesController.poster(
              offset: 0, limit: double.infinity, data: actions),
        ),
      ),
    );
  }

  Widget listAnimationMovies() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(5),
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: MoviesController.poster(
              offset: 0, limit: double.infinity, data: animations),
        ),
      ),
    );
  }
}
