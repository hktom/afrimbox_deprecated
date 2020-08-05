import 'package:afrimbox/helpers/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MovieProvider extends ChangeNotifier {
  var movies = [];
  var actors = [];
  var genres = [];
  var moviesByGenre = {};
  var moviesArchive = [];
  var currentGenre;

// get All movies
  Future<void> get() async {
    var response = await http.get(moviesUrl);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      movies = jsonResponse;
      moviesByGenre['0'] = movies;
      currentGenre = '0';
      print("MOVIE API REQUEST STATUS 200");
    } else {
      print("MOVIE API REQUEST STATUS 404");
    }
    notifyListeners();
  }

// Get movies by genres
  Future<void> getByGenre(String genre) async {
    var response = await http.get(moviesByGenreUrl + genre);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      moviesByGenre[genre] = jsonResponse;
      currentGenre = genre;
      print("MOVIE By Genre API REQUEST STATUS 200");
    } else {
      print("MOVIE By Genre REQUEST STATUS 404");
    }
    notifyListeners();
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
}
