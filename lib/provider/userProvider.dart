import 'package:afrimbox/controller/auth/facebookAuthController.dart';
import 'package:afrimbox/controller/auth/googleAuthController.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:afrimbox/controller/firestoreController.dart';

class UserProvider extends ChangeNotifier {
  FireStoreController fireStoreController = new FireStoreController();
  GoogleAuthController googleAuthController = new GoogleAuthController();
  FacebookAuthController facebookAuthController = new FacebookAuthController();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String userDefaultPhoto =
      "https://firebasestorage.googleapis.com/v0/b/skyship-bd599.appspot.com/o/userPhoto%2FPortrait_Placeholder.png?alt=media&token=50ce51eb-7154-4d74-b96b-cad1090bfcd0";
  var currentUser;
  var currentUserId;
  //Map authUser;
  var payload;

  setPayload(payload) {
    this.payload = payload;
  }

  //setupCurrentUser
  getCurrentUser(currentUser) {
    this.currentUser = currentUser;
    this.currentUserId = currentUser[0]['id'];
    notifyListeners();
  }

  List<dynamic> favoriteMovies() {
    if (this.currentUser[0]['favoriteMovies'] != null) {
      return this.currentUser[0]['favoriteMovies'];
    } else {
      return [];
    }
  }

  List<dynamic> favoriteChannels() {
    if (this.currentUser[0]['favoriteChannels'] != null) {
      return this.currentUser[0]['favoriteChannels'];
    } else {
      return [];
    }
  }

  int subscriptionRemainDays() {
    int day = 0;
    int duration = 0;
    if (this.currentUser[0]['subscription'] != null) {
      duration = this.currentUser[0]['subscription']['duration'];
      //var debuteDate = this.currentUser[0]['subscription']['debuteDate'];
      var timestamp = this.currentUser[0]['subscription']['endDate'];
      var endDate = timestamp.toDate();
      var dateNow = DateTime.now();
      int days = int.parse(endDate.difference(dateNow).inDays.toString());

      if (days <= duration && days != 0) {
        day = days;
      }
    }

    return day;
  }

  // Channel
  bool isChannelInFavories(dynamic channel) {
    bool result = false;
    if (currentUser[0]['favoriteChannels'] != null) {
      currentUser[0]['favoriteChannels'].forEach((element) {
        if (element['id'] == channel['id']) {
          result = true;
        }
      });
    }
    return result;
  }

  Future<void> addChannelToFavorite(dynamic movie) async {
    bool movieExist = isChannelInFavories(movie);
    if (!movieExist) {
      if (currentUser[0]['favoriteChannels'] == null) {
        currentUser[0]['favoriteChannels'] = [];
      }
      currentUser[0]['favoriteChannels'].add(movie);
      await fireStoreController.updateDocument(
          collection: 'users', doc: currentUserId.trim(), data: currentUser[0]);
      notifyListeners();
    }
  }

  Future<void> removeChannelToFavorite(dynamic movie) async {
    bool movieExist = isChannelInFavories(movie);
    if (movieExist) {
      currentUser[0]['favoriteChannels']
          .removeWhere((item) => item['id'] == movie['id']);

      //update
      await fireStoreController.updateDocument(
          collection: 'users', doc: currentUserId, data: currentUser[0]);
      notifyListeners();
    }
  }

// Movies
  bool isMovieInFavories(dynamic movie) {
    bool result = false;
    if (currentUser[0]['favoriteMovies'] != null) {
      currentUser[0]['favoriteMovies'].forEach((element) {
        if (element['id'] == movie['id']) {
          result = true;
        }
      });
    }
    return result;
  }

  Future<void> addMovieToFavorite(dynamic movie) async {
    bool movieExist = isMovieInFavories(movie);
    if (!movieExist) {
      if (currentUser[0]['favoriteMovies'] == null) {
        currentUser[0]['favoriteMovies'] = [];
      }
      currentUser[0]['favoriteMovies'].add(movie);
      await fireStoreController.updateDocument(
          collection: 'users', doc: currentUserId.trim(), data: currentUser[0]);
      notifyListeners();
    }
  }

  Future<void> removeMovieToFavorite(dynamic movie) async {
    bool movieExist = isMovieInFavories(movie);
    if (movieExist) {
      currentUser[0]['favoriteMovies']
          .removeWhere((item) => item['id'] == movie['id']);

      //update
      await fireStoreController.updateDocument(
          collection: 'users', doc: currentUserId, data: currentUser[0]);
      notifyListeners();
    }
  }

  Future<bool> getProfile(userId) async {
    try {
      var user = await fireStoreController.getDocument(
          collection: 'users', doc: userId);
      this.currentUser = user;
      this.currentUserId = userId;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  //createProfile
  Future<bool> creatProfile(Map<String, dynamic> data) async {
    bool result = await fireStoreController.insertDocument(
        collection: 'users', doc: data['phone'], data: data);
    notifyListeners();
    return result;
  }

  // update user profile
  Future<bool> updateProfile(Map data) async {
    bool result = await fireStoreController.updateDocument(
        collection: 'users', doc: data['email'], data: data);
    notifyListeners();
    return result;
  }

  // remove permantly profile
  Future<void> deleteProfile(String email) async {
    bool result = await fireStoreController.removeDocument(
        collection: 'users', doc: email);
    return result;
  }

  // subscription payment
  Future<void> payment() async {
    notifyListeners();
  }

  // userSession kkiakapy
  Future<void> userSession() async {
    notifyListeners();
  }

  // log out user
  Future<bool> signOut() async {
    try {
      await googleAuthController.signOut();
    } catch (e) {
      print("ERROR GOOGLE SIGNOUT ${e.toString()}");
    }

    try {
      await facebookAuthController.signOut();
    } catch (e) {
      print("ERROR FACEBOOK SIGNOUT ${e.toString()}");
    }

    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print("ERROR NORMAL SIGNOUT ${e.toString()}");
    }

    return true;
  }

  Future<FirebaseUser> checkLogin() async {
    var auth = await FirebaseAuth.instance.currentUser();
    return auth;
  }
}
