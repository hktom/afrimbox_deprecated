import 'package:afrimbox/controller/fbLoginController.dart';
import 'package:afrimbox/controller/googleLoginController.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:afrimbox/controller/firestoreController.dart';

class UserProvider extends ChangeNotifier {
  FireStoreController fireStoreController = new FireStoreController();
  GoogleLoginController googleLoginController = new GoogleLoginController();
  FacebookLoginController facebookLoginController =
      new FacebookLoginController();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var currentUser;
  Map authUser;

  //setupCurrentUser
  Future<void> getCurrentUser(currentUser) async {
    this.currentUser = currentUser;
    notifyListeners();
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
  Future<bool> signOut(String authMethod) async {
    bool result;
    switch (authMethod) {
      case 'google.com':
        result = await googleLoginController.signOut();

        break;

      case 'facebook.com':
        result = await facebookLoginController.signOut();
        break;

      default:
        result = true;
        break;
    }

    if (result) await _firebaseAuth.signOut();
    return result;
  }

  Future<dynamic> checkLogin() async {
    var auth = await FirebaseAuth.instance.currentUser();
    return auth;
  }
}
