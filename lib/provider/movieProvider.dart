import 'package:afrimbox/helpers/const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class MovieProvider extends ChangeNotifier {
  var movies = [];
  var actors = [];
  var genres = [];
  var moviesByGenre = {};
  var moviesArchive = [];
  var currentGenre;
  var pendingReq = [];
  Map<String, bool> pending = {'get': false, 'getByGenre': false};
  //Dio dio = new Dio();
// get All movies

  void setCurrentGenre(category) {
    this.currentGenre = category;
    notifyListeners();
  }

  Future<void> get() async {
    pending['get'] = true;
    await Dio().get(moviesUrl).catchError((err) {
      print("MOVIE GET ERR ${err.toString()}");
      pending['get'] = false;
    }).then((res) {
      if (res.statusCode == 200) {
        movies = res.data;
        currentGenre = '0';
        moviesByGenre['0'] = movies;
        moviesByGenre['1'] = _setPopularMovies(res.data);
      }
      pending['get'] = false;
    });

    notifyListeners();
  }

  //set popular movies
  dynamic _setPopularMovies(List data) {
    var popular = [];
    data.forEach((element) {
      if (double.parse(element['vote_average']) >= 5.5) {
        popular.add(element);
      }
    });
    return popular;
  }

  void resetPendingReq() {
    pendingReq = [];
  }

  void setPendingByGenre(){
    pending['getByGenre'] = true;
    notifyListeners();
  }

// Get movies by genres
  Future<void> getByGenre(category) async {
    pending['getByGenre'] = true;
    if (category['key'] == 1 || category['key'] == 0) {
      currentGenre = category;
      pending['getByGenre'] = false;
    } else {
      await this._getByGenre(category);
    }
    notifyListeners();
  }

  Future<void> _getByGenre(category) async {
    Dio _dio = new Dio();
    _dio.options.connectTimeout = 5000; //5s
    _dio.options.receiveTimeout = 3000;
    await _dio.get(moviesByGenreUrl + category['key']).then((res) {
      if (res.statusCode == 200) {
        var key = category['key'];
        moviesByGenre[key] = res.data;
        currentGenre = category;
        notifyListeners();
      }
      pending['getByGenre'] = false;
    }).catchError((err) {
      print("REQUEST Error ${err.toString()}");
      pending['getByGenre'] = false;
    });
  }

  //inifinite Scroll load More Movies
  Future<int> loadMore(int index) async {
    if (index >= category.length) {
      return index;
    }

    if (!pendingReq.contains(category[index]['key'])) {
      pendingReq.add(category[index]['key']);
      await this.getByGenre(category[index]);
      return index + 1;
    }

    return index;
  }

  //get genres
  Future<void> getGenres(String movieId) async {
    var response = await http.get(genresUrl + movieId);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      genres = jsonResponse;
      print("MOVIE By Genre API REQUEST STATUS 200");
    } else {
      print("MOVIE By Genre REQUEST STATUS 404");
    }
    notifyListeners();
  }

  //Get movies Archive
  Future<void> filterArchive(String genre) async {
    var response = await http.get(moviesByGenreUrl + genre);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      moviesArchive = jsonResponse;
      print("MOVIE By Genre API REQUEST STATUS 200");
    } else {
      print("MOVIE By Genre REQUEST STATUS 404");
    }
    notifyListeners();
  }

  // Get movies actors
  Future<void> getActors(String movieId) async {
    var response = await http.get(actorsUrl + movieId);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      actors = jsonResponse;
      print("MOVIE Actors API REQUEST STATUS 200");
    } else {
      print("MOVIE By Genre REQUEST STATUS 404");
    }
    notifyListeners();
  }

  void setActors() {
    this.actors = [];
  }
}
