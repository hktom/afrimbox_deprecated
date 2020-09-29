import 'package:afrimbox/controller/firestoreController.dart';
import 'package:afrimbox/helpers/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MoviesProvider extends ChangeNotifier {
  FireStoreController fireStoreController = new FireStoreController();
  //property
  List movies = [];
  List actors = [];
  List genres = [];
  List moviesArchive = [];
  List pendingReq = [];
  List searchMovie = [];
  Map moviesByGenre = {};
  var currentGenre;
  var firebaseMovies = [];

  Map<String, bool> pending = {'get': false, 'getByGenre': false};

  //get http => null;

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
  Future<void> getMovies() async {
    //movies = [];
    pending['get'] = true;
    await Dio().get(moviesUrl + '&per_page=9').catchError((err) {
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

  //get genres
  getGenres(Map movie) {
    genres = [];
    movie["_embedded"]["wp:term"][0].forEach((element) {
      if (element["taxonomy"] == "genres") {
        genres.add(element);
      }
    });
  }

  _getGenres(Map movie) {
    List _genres = [];
    movie["_embedded"]["wp:term"][0].forEach((element) {
      if (element["taxonomy"] == "genres") {
        genres.add(element);
      }
    });
    return _genres;
  }

  // Get movies actors
  getActors(Map movie) {
    actors = [];
    movie["_embedded"]["wp:term"].forEach((array) {
      array.forEach((element) {
        if (element["taxonomy"] == "dtcast" ||
            element["taxonomy"] == "dtdirector") {
          actors.add(element);
        }
      });
    });
  }

  // get all movies from firebase
  Future<bool> getFirebaseMovies() async {
    try {
      firebaseMovies = await fireStoreController.getDocuments('movies');
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // check if user has already view the movie
  bool hasUserAlreadyViewTheMovie({String userId, String movieId}) {
    bool _return = false;
    try {
      firebaseMovies.forEach((_movie) {
        _movie['viewers'].forEach((viewer) {
          if (viewer['id'] == userId && _movie['id'] == movieId) {
            _return = true;
          }
        });
      });
    } catch (e) {
      return false;
    }

    return _return;
  }

  bool hasMovieGotViews({String movieId}) {
    bool _res = false;
    firebaseMovies.forEach((element) {
      if (element['id'] == movieId && element['total_view'] != null) {
        _res = true;
      }
    });
    return _res;
  }

  //add new view
  Future<void> addView({String userId, Map movie}) async {
    movie.remove('_embedded');
    movie['viewers'] = [
      {'id': userId, 'created_at': DateTime.now()}
    ];
    movie['total_view'] = 1;
    return await fireStoreController.insertDocument(
        collection: 'movies', data: movie, doc: movie['id'].toString());
  }

  //update movie view
  Future<void> updateView({String userId, int count, String movieId}) async {
    Map _movie;
    firebaseMovies.forEach((element) {
      if (element['id'] == movieId) {
        _movie = element.data;
      }
    });

    _movie['viewers'].add({'id': userId, 'created_at': DateTime.now()});
    _movie['total_view'] += 1;
    return fireStoreController.updateDocument(
        collection: 'movies', doc: _movie['id'], data: _movie);
  }

  //get total count
  Future<int> getMovieTotalView({Map movie}) async {
    List _movie = await fireStoreController.getDocument(
        collection: 'movies', doc: movie['id']);
    return _movie[0]['total_view'];
  }

  // reduce movie to save in firebase
  Map<String, dynamic> movieReducer(Map movie) {
    Map<String, dynamic> _movie = {};
    _movie['id'] = movie['id'].toString();
    _movie['title'] = movie['title'];
    _movie['content'] = movie['content'];
    _movie['acf'] = movie['acf'];
    if (movie["_embedded"]["wp:featuredmedia"] != null) {
      _movie['featuremedia'] = movie["_embedded"]["wp:featuredmedia"][0]
          ["media_details"]["sizes"]["medium"]["source_url"];
    }
    _movie['genres'] = _getGenres(movie);
    return _movie;
  }
}
