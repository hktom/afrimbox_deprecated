import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/itemsProvider.dart';
import 'package:afrimbox/controller/moviesController.dart';

class GenreScreen extends StatefulWidget {
  final String genre;
  GenreScreen({Key key, this.genre}) : super(key: key);
  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  var movies = [];

  Future<void> getMovies() async {
    await Provider.of<ItemsProvider>(context, listen: false).getItems(
        field: widget.genre.toLowerCase() + 's', filter: widget.genre);

    setState(() {
      movies = Provider.of<ItemsProvider>(context, listen: false)
          .items[widget.genre.toLowerCase() + 's'];
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
      ),
      body: Stack(
        children: <Widget>[
          _listMovie(),
        ],
      ),
    );
  }

  Widget _listMovie() {
    return GridView.count(
      crossAxisCount: 2,
      children: MoviesController.posterGrid(offset: 0, limit: double.infinity, data: movies),
    );
  }
}
