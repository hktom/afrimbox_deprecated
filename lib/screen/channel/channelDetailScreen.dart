import 'package:afrimbox/widgets/buttonIconText.dart';
import 'package:afrimbox/widgets/channelDetailCardAppBar.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:afrimbox/provider/ChannelProvider.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/controller/moviesController.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';
import 'package:share/share.dart';

class ChannelDetailScreen extends StatefulWidget {
  final Map channel;
  ChannelDetailScreen({Key key, this.channel}) : super(key: key);
  @override
  _ChannelDetailScreenState createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  var unescape = new HtmlUnescape();
  ChannelProvider model;
  UserProvider userModel;
  bool isFavorite = true;

  @override
  void initState() {
    model = Provider.of<ChannelProvider>(context, listen: false);
    userModel = Provider.of<UserProvider>(context, listen: false);
    isFavorite = userModel.isChannelInFavories(widget.channel);
    //getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverToBoxAdapter(
          child: ChannelDetailCardAppBar(
            channel: widget.channel,
          ),
        ),
        // SliverToBoxAdapter(
        //   child: _description(),
        // ),
        SliverToBoxAdapter(
          child: _listActionsButton(),
        ),
        //sliverTitle("Pour toi"),
        //listFavoritechannels()
      ]),
    );
  }

  // Widget _sliverTitle(String title) {
  //   return SliverPadding(
  //       padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
  //       sliver: SliverToBoxAdapter(
  //           child: ListTile(
  //         leading: Tex(
  //           content: title,
  //           size: 'h5',
  //         ),
  //       )));
  // }

  Widget _listActionsButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          // Expanded(
          //   flex: 1,
          //   child: FlatButton(
          //       padding: EdgeInsets.zero,
          //       child: ButtonIconText(icon: Icons.language, text: 'url'),
          //       onPressed: () {
          //         _launchURL(widget.channel['link']);
          //       }),
          // ),
          Expanded(
            flex: 1,
            child: FlatButton(
                padding: EdgeInsets.zero,
                child: ButtonIconText(icon: Icons.share, text: 'Partager'),
                onPressed: () {
                  Share.share(widget.channel['link'],
                      subject: widget.channel['title']['rendered']);
                }),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
                padding: EdgeInsets.zero,
                child: ButtonIconText(icon: Icons.list, text: 'Ma liste'),
                onPressed: () {
                  if (userModel.currentUser[0]['favoriteChannels'] != null) {
                    Get.toNamed('/favoriteChannels');
                  } else {
                    Toast.show(
                        "Aucune chaine a été ajouté aux favoris", context);
                  }
                }),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              padding: EdgeInsets.zero,
              child: ButtonIconText(
                icon: Icons.thumb_up,
                text: "j'aime",
                color: isFavorite ? Theme.of(context).accentColor : Colors.grey,
              ),
              onPressed: () async {
                setState(() => isFavorite = !isFavorite);
                if (isFavorite) {
                  Toast.show("Cette chaine a été retiré de favoris", context);
                  await userModel.removeChannelToFavorite(widget.channel);
                } else {
                  //setState(() => isFavorite = !isFavorite);
                  Toast.show("Cette chaine a été ajouté aux favoris", context);
                  await userModel.addChannelToFavorite(widget.channel);
                }
              },
            ),
          ),
        ],
      ),
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

  Widget listFavoritechannels() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(5),
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: MoviesController.myChannels(
              offset: 0, limit: double.infinity, data: []),
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
