import 'package:afrimbox/components/channelDetailCardAppBar.dart';
import 'package:afrimbox/screen/trailerPlayerScreen.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:afrimbox/provider/itemsProvider.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/controller/moviesController.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelDetailScreen extends StatefulWidget {
  final Map channel;
  ChannelDetailScreen({Key key, this.channel}) : super(key: key);
  @override
  _ChannelDetailScreenState createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  var unescape = new HtmlUnescape();
  var favorites = [];

  //get favorite
  Future<void> getFavorites() async {
    // await Provider.of<ItemsProvider>(context, listen: false)
    //     .getItems(field: 'actions', filter: 'Action');
    await Provider.of<ItemsProvider>(context, listen: false).getAllChannels();
    setState(() {
      favorites =
          Provider.of<ItemsProvider>(context, listen: false).items['channels'];
    });
  }

  @override
  void initState() {
    getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverToBoxAdapter(
          child: _appBar(),
        ),
        SliverToBoxAdapter(
          child: _description(),
        ),
        SliverToBoxAdapter(
          child: _listActionsButton(),
        ),
        sliverTitle("Pour toi"),
        listFavoritechannels()
      ]),
    );
  }

  Widget sliverTitle(String title) {
    return SliverPadding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        sliver: SliverToBoxAdapter(
            child: ListTile(
          leading: Tex(
            content: title,
            size: 'h5',
          ),
        )));
  }

  Widget _listActionsButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FlatButton(
                padding: EdgeInsets.zero,
                child: _buttonIcon(icon: Icons.language, text: 'Website'),
                onPressed: () {
                  _launchURL(widget.channel['link']);
                }),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
                padding: EdgeInsets.zero,
                child: _buttonIcon(icon: Icons.share, text: 'Partager'),
                onPressed: () {}),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
                padding: EdgeInsets.zero,
                child: _buttonIcon(icon: Icons.list, text: 'Ma liste'),
                onPressed: () {}),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
                padding: EdgeInsets.zero,
                child: _buttonIcon(icon: Icons.thumb_up, text: "j'aime"),
                onPressed: () {}),
          ),
        ],
      ),
    );
  }

  Widget _buttonIcon({IconData icon, String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(fontSize: 10),
        )
      ],
    );
  }

  Widget _description() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Tex(
                      content: unescape
                          .convert(widget.channel['title']['rendered']))),
              //_caracteristics(),
              //HtmlWidget(widget.channel['content']['rendered']),
              //Tex(content: .toString()), //description
            ]));
  }

  // Widget _caracteristics() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 10),
  //     child: Row(
  //       children: <Widget>[
  //         Expanded(
  //             flex: 0,
  //             child: Tex(
  //               content: widget.channel['release_date'] + ' | ',
  //             )),
  //         Expanded(flex: 0, child: _time()),
  //         Expanded(flex: 0, child: _rating()),
  //       ],
  //     ),
  //   );
  // }

  Widget _appBar() {
    return ChannelDetailCardAppBar(
      channel: widget.channel,
    );
  }

  Widget _time() {
    double runtime = double.parse(widget.channel['runtime']);
    int h = runtime ~/ 60;
    double m = runtime % 60;

    return Tex(
      content: h.toString() + 'h ' + m.toString() + 'min | ',
    );
  }

  // Widget _rating() {
  //   return SmoothStarRating(
  //       allowHalfRating: true,
  //       onRated: (v) {},
  //       starCount: 5,
  //       rating: double.parse(widget.channel['vote_average']),
  //       size: 20.0,
  //       isReadOnly: true,
  //       color: Colors.yellow,
  //       borderColor: Colors.yellow,
  //       spacing: 0.0);
  // }

  Widget listFavoritechannels() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(5),
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: MoviesController.myChannels(
              offset: 0, limit: double.infinity, data: favorites),
        ),
      ),
    );
  }

  Future<void> _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
