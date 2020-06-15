import 'package:afrimbox/components/menu.dart';
import 'package:afrimbox/controller/moviesController.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/provider/itemsProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    await Provider.of<ItemsProvider>(context, listen: false)
        .getItems(field: 'movies');
    await Provider.of<ItemsProvider>(context, listen: false)
        .getItems(field: 'channels');

    await Provider.of<ItemsProvider>(context, listen: false)
        .getItems(field: 'animations', filter: 'Animation');

    await Provider.of<ItemsProvider>(context, listen: false)
        .getItems(field: 'actions', filter: 'Action');

    setState(() {
      movies =
          Provider.of<ItemsProvider>(context, listen: false).items['movies'];
      loadData = true;
    });

    setState(() {
      channels =
          Provider.of<ItemsProvider>(context, listen: false).items['channels'];
      loadData = true;
    });

    setState(() {
      actions =
          Provider.of<ItemsProvider>(context, listen: false).items['actions'];
      loadData = true;
    });

    setState(() {
      animations = Provider.of<ItemsProvider>(context, listen: false)
          .items['animations'];
      loadData = true;
    });
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
        elevation: 0,
        title: Text('AFRIMBOX'),
      ),
      drawer: Menu(),
      body: Container(
        child: loadData ? content() : loadingContent(),
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
          sliverTitle("Nos chaines"),
          listChannels(),

          // actors

          //movies Action
          sliverTitle("Actions"),
          listActionsMovies(),

          //movies Animation
          sliverTitle("Animations"),
          listAnimationMovies()
        ],
      ),
    );
  }

  Widget sliverTitle(String title) {
    return SliverPadding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        sliver: SliverToBoxAdapter(
            child: Tex(
          content: title,
          size: 'h5',
        )));
  }

  Widget lastMovie() {
    return SliverList(
      delegate: SliverChildListDelegate(
        MoviesController.myCard(
            offset: 0,
            limit: 0,
            height: 300,
            width: double.infinity,
            data: movies,
            overlay: true),
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
              offset: 0, limit: double.infinity, width: 200, data: channels),
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
          children: MoviesController.myCard(
              hideTitle: true,
              offset: 0,
              limit: double.infinity,
              width: 100,
              data: actions),
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
          children: MoviesController.myCard(
              hideTitle: true,
              offset: 0,
              limit: double.infinity,
              width: 100,
              data: animations),
        ),
      ),
    );
  }

  Widget loadingContent() {
    return Center(
      child: SpinKitChasingDots(
        size: 60,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
