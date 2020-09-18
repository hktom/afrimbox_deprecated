import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/moviesProvider.dart';
import 'package:afrimbox/screen/movie/detailsMovieScreen.dart';
import 'package:afrimbox/screen/movie/movies.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sup/sup.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSearching = false;
  bool getMovie = false;
  MoviesProvider movieProvider;
  String searchValue = "";

  _getMovie(url) {
    Get.to(DetailsMovieScreen(movie: {}, movieUrl: url));
  }

  @override
  void initState() {
    movieProvider = Provider.of<MoviesProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _scaffold(),
        getMovie ? _loadingScreen() : SizedBox.shrink(),
      ],
    );
  }

  Widget _loadingScreen() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(255, 255, 255, 0.8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _scaffold() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.close),
            onPressed: () {
              Get.back();
            }),
        actions: <Widget>[
          IconButton(
              color: Colors.black,
              icon: Icon(Icons.search),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  setState(() => isSearching = true);
                  await movieProvider.search(searchValue);
                  setState(() => isSearching = false);
                  //couponPay(_usercoupon);
                }
              }),
        ],
        title: Container(
          width: double.infinity,
          child: _searchForm(),
        ),
        centerTitle: true,
      ),
      body: _searchResult(),
    );
  }

  Widget _searchResult() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Consumer<MoviesProvider>(builder: (context, model, child) {
        if (model.searchMovie.isEmpty) {
          return Center(
            child: QuickSup.empty(
              title: 'Vide',
              subtitle: "Aucun film trouvé",
            ),
          );
        } else {
          if (isSearching) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return _listSearch(model.searchMovie);
        }
      }),
    );
  }

  Widget _searchForm() {
    return Container(
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: TextFormField(
          //enabled: !pending,
          //autofocus: true,
          initialValue: '',
          onChanged: (value) {
            setState(() => searchValue = value);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            hintText: 'Recherche film... ',
            contentPadding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          ),
          style: TextStyle(color: Colors.black),
          keyboardType: TextInputType.text,
        ),
      ),
    );
  }

  Widget _listSearch(List result) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () => _getMovie(result[index]['_links']['self'][0]['href']),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Tex(
              align: TextAlign.left,
              content: result[index]['title'],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: result.length,
    );
  }
}
