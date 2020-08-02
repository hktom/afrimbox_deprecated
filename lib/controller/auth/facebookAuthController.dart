import 'package:afrimbox/controller/firestoreController.dart';
import 'package:afrimbox/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FacebookAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin facebookSignIn = new FacebookLogin();
  FireStoreController fireStoreController = new FireStoreController();

  Future<bool> signOut() async {
    try {
      await facebookSignIn.logOut();
      return true;
    } catch (e) {
      print("FACEBOOK SIGNOUT ERR ${e.toString()}");
      return false;
    }
  }

  Future<FirebaseUser> auth() async {
    FirebaseUser user;
    bool isSignedIn = await facebookSignIn.isLoggedIn;
    if (isSignedIn) {
      user = await _auth.currentUser();
    } else {
      FacebookLoginResult result = await facebookSignIn.logIn(['email']);
      FacebookAccessToken accessToken = result.accessToken;
      var credential =
          FacebookAuthProvider.getCredential(accessToken: accessToken.token);
      await _auth.signInWithCredential(credential);
      user = await _auth.currentUser();
    }
    return user;
  }
}
