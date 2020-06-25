import 'package:afrimbox/components/menu.dart';
import 'package:afrimbox/controller/moviesController.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/screen/genreScreen.dart';
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
      //drawer: Menu(),
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
          sliverTitle("Nos chaines", 0),
          listChannels(),
          // actors
          //movies Action
          sliverTitle("Actions", 3295),
          listActionsMovies(),
          //movies Animation
          sliverTitle("Animations", 3302),
          listAnimationMovies()
        ],
      ),
    );
  }

  Widget sliverTitle(String title, int genre) {
    return SliverPadding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        sliver: SliverToBoxAdapter(
            child: ListTile(
          leading: Tex(
            content: title,
            size: 'h5',
          ),
          trailing: IconButton(
            onPressed: (){
              Get.to(GenreScreen(genre:genre));
            },
            icon: FaIcon(FontAwesomeIcons.th),
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

  Widget loadingContent() {
    return Center(
      child: SpinKitChasingDots(
        size: 60,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
