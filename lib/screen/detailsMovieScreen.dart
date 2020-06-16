import 'package:afrimbox/components/movieDetailCardAppBar.dart';
import 'package:flutter/material.dart';

class DetailsMovieScreen extends StatefulWidget {
  final Map movie;
  DetailsMovieScreen({Key key, this.movie}):super(key:key);
  @override
  _DetailsMovieScreenState createState() => _DetailsMovieScreenState();
}

class _DetailsMovieScreenState extends State<DetailsMovieScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
         slivers: <Widget>[
           SliverToBoxAdapter(child: _appBar(),)

         ]
      ),
    );
  }


  Widget _appBar(){
    return MovieDetailCardAppBar(
      movie: widget.movie,
    );
  }
}