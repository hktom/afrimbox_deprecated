import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FacebookLoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin facebookSignIn = new FacebookLogin();

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

  Future<void> signOut() async {
    await facebookSignIn.logOut();
    return true;
  }
}
