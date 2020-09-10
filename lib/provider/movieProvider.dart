import 'package:afrimbox/helpers/const.dart';
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
  Dio dio = new Dio();
// get All movies
  Future<void> get() async {
    pending['get'] = true;
    var response =
        await dio.get(moviesUrl).whenComplete(() => pending['get'] = false);
    if (response.statusCode == 200) {
      movies = response.data;
      currentGenre = '0';
      moviesByGenre['0'] = movies;
      moviesByGenre['1'] = _setPopularMovies(response.data);
      print("MOVIE API REQUEST STATUS 200");
    } else {
      print("MOVIE API REQUEST STATUS 404");
    }
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

// Get movies by genres
  Future<void> getByGenre(String genre) async {
    if (int.parse(genre) <= 1) {
      await this.get();
    } else {
      await this._callBackGetByGenre(genre);
    }
    notifyListeners();
  }

  Future<void> _callBackGetByGenre(String genre) async {
    pending['getByGenre'] = true;
    notifyListeners();
    var response = await dio
        .get(moviesByGenreUrl + genre)
        .whenComplete(() => pending['getByGenre'] = false);
    if (response.statusCode == 200) {
      moviesByGenre[genre] = response.data;
      currentGenre = genre;
      print("MOVIE By Genre $genre API REQUEST STATUS 200");
    } else {
      print("MOVIE By Genre $genre REQUEST STATUS 404");
    }
    pending['getByGenre'] = false;
    notifyListeners();
  }

  //inifinite Scroll load More Movies
  Future<int> loadMore({int counter}) async {
    if (counter >= category.length) {
      return counter;
    }

    var genre = category[counter]['key'].toString();

    if (!pendingReq.contains(genre)) {
      pendingReq.add(genre);
      await this.getByGenre(genre);
      return counter + 1;
    }

    return counter;
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
