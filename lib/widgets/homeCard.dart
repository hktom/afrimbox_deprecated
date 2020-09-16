import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:afrimbox/controller/moviesController.dart';
//import 'package:provider/provider.dart';

class HomeCard extends StatefulWidget {
  final List data;
  final Map category;
  final Function updateCurrentGenre;
  HomeCard({Key key, this.data, this.category, this.updateCurrentGenre})
      : super(key: key);
  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
            child: ListTile(
              leading: Tex(
                content: widget.category['label'],
                size: 'h5',
                color: Theme.of(context).accentColor,
              ),
              trailing: IconButton(
                onPressed: () {
                  widget.updateCurrentGenre(widget.category);
                },
                icon: FaIcon(
                  FontAwesomeIcons.th,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: MoviesController.poster(
                  offset: 0, limit: double.infinity, data: widget.data),
            ),
          ),
        ],
      ),
    );
  }
}
