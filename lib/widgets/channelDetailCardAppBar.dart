import 'package:afrimbox/provider/userProvider.dart';
import 'package:afrimbox/screen/StreamPlayer.dart';
import 'package:afrimbox/widgets/img.dart';
import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

class ChannelDetailCardAppBar extends StatefulWidget {
  final Map channel;
  //final List genres;
  ChannelDetailCardAppBar({Key key, this.channel}) : super(key: key);

  @override
  _ChannelDetailCardAppBarState createState() =>
      _ChannelDetailCardAppBarState();
}

class _ChannelDetailCardAppBarState extends State<ChannelDetailCardAppBar> {
  var unescape = new HtmlUnescape();
  UserProvider model;
  var currentUser;
  int bundleActive = 0;
  String image = '';
  String placeholder = 'assets/channel_placeholder.png';
  String channelTitle = '';

  _getChannelTitle() {
    try {
      channelTitle = unescape.convert(widget.channel['title']['rendered']);
    } catch (e) {
      channelTitle = unescape.convert(widget.channel['slug']);
    }
    setState(() {});
  }

  String setImage() {
    if (widget.channel['better_featured_image'] != null) {
      return widget.channel['better_featured_image']['source_url'];
    } else {
      return null;
    }
  }

  getRemainDays() {
    model = Provider.of<UserProvider>(context, listen: false);
    bundleActive = model.subscriptionRemainDays();
  }

  @override
  void initState() {
    image = setImage();
    getRemainDays();
    _getChannelTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Stack(
        children: <Widget>[
          _background(),
          _filter(),
          _appBar(),
          _title(),
          //_listGenres(),
          _floatButton(),
        ],
      ),
    );
  }

  Widget _floatButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 24, right: 10),
        child: FloatingActionButton(
          //backgroundColor: Colors.yellow,
          onPressed: () {
            if (bundleActive > 0) {
              if (widget.channel['acf'] != '') {
                Get.to(StreamPlayer(
                  streamTitle: channelTitle,
                  isChannel: true,
                  streamUrl: widget.channel['acf']['flux_tv'],
                ));
              }
            } else {
              Get.toNamed('/subscription');
            }
          },
          child: Icon(Icons.play_arrow),
        ),
      ),
    );
  }

  Widget _title() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.80,
          margin: EdgeInsets.only(bottom: 100, left: 10),
          child: Tex(
            content: unescape.convert(widget.channel['slug']),
            size: 'h2',
            bold: FontWeight.bold,
            color: Colors.white,
          )),
    );
  }

  Widget _background() {
    return Img(url: image, placeholder: placeholder, height: 300);
  }

  Widget _filter() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.2),
      width: double.infinity,
      height: 300,
    );
  }

  Widget _appBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      //color: Color.fromRGBO(0, 0, 0, 0.2),
      child: ListTile(
        dense: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.cast, color: Colors.white, size: 25),
        ),
      ),
    );
  }
}
