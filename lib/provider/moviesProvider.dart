import 'package:afrimbox/helpers/const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

class MoviesProvider extends ChangeNotifier {
  //property
  var movies = [];
  var actors = [];
  var genres = [];
  var moviesByGenre = {};
  var moviesArchive = [];
  var currentGenre;
  var pendingReq = [];
  var searchMovie = [];
  Map<String, bool> pending = {'get': false, 'getByGenre': false};

  get http => null;

  void setCurrentGenre(category) {
    this.currentGenre = category;
    notifyListeners();
  }

  void resetPendingReq() => pendingReq = [];
  void setActors() => this.actors = [];

  void setPendingByGenre() {
    pending['getByGenre'] = true;
    notifyListeners();
  }

  // get all movies
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

  Future<Map> getOne(url) async {
    Map movie = {};
    await Dio().get(url).catchError((err) {
      print("MOVIE GET ERR ${err.toString()}");
    }).then((res) {
      if (res.statusCode == 200) {
        movie = res.data;
      }
    });
    return movie;
  }

  //set popular movie
  dynamic _setPopularMovies(List data) {
    var popular = [];
    data.forEach((element) {
      if (double.parse(element['vote_average']) >= 5.5) {
        popular.add(element);
      }
    });
    return popular;
  }

  // Get movies by genres
  Future<void> getByGenre(category) async {
    pending['getByGenre'] = true;
    if (category['key'] == '1' || category['key'] == '0') {
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

  // pagination
  Future<int> pagination({int page, category: category}) async {
    Dio _dio = new Dio();
    int pages = page;
    String _url = "";
    String perpage = "&per_page=${page.toString()}";
    if (category['key'] == '0' || category['key'] == '1') {
      _url = moviesUrl + perpage;
    } else {
      _url = moviesByGenreUrl + category['key'] + perpage;
    }
    _dio.options.connectTimeout = 5000; //5s
    _dio.options.receiveTimeout = 3000;
    await _dio.get(_url).then((res) {
      if (res.statusCode == 200) {
        var key = category['key'];
        moviesByGenre[key] = res.data;
        currentGenre = category;
        pages = pages + 9;
        notifyListeners();
      }
      pending['getByGenre'] = false;
    }).catchError((err) {
      print("REQUEST Error ${err.toString()}");
      pending['getByGenre'] = false;
    });

    return pages;
  }

  // search
  Future<void> search(value) async {
    if (value != null) {
      pending['search'] = true;
      await Dio().get(searchUrl).then((res) {
        if (res.statusCode == 200) {
          searchMovie = res.data;
          notifyListeners();
        }
        pending['search'] = false;
      }).catchError((err) {
        print("REQUEST Error ${err.toString()}");
        pending['search'] = false;
      });
    }
  }

  //get genres
  Future<void> getGenres(String movieId) async {
    await Dio().get(genresUrl + movieId).then((res) {
      if (res.statusCode == 200) {
        genres = res.data;
      }
    }).catchError((err) {
      print("MOVIE By Genre API Err ${err.toString()}");
    });
    notifyListeners();
  }

  //Get movies Archive
  Future<void> filterArchive(String genre) async {
    await Dio().get(moviesByGenreUrl + genre).then((res) {
      if (res.statusCode == 200) {
        moviesArchive = res.data;
      }
    }).catchError((err) {
      print("MOVIE FILTER ARCHIVE API Err ${err.toString()}");
    });
    notifyListeners();
  }

  // Get movies actors
  Future<void> getActors(String movieId) async {
    await Dio().get(actorsUrl + movieId).then((res) {
      if (res.statusCode == 200) {
        actors = res.data;
      }
    }).catchError((err) {
      print("MOVIE ACTOR API Err ${err.toString()}");
    });
    notifyListeners();
  }
}
