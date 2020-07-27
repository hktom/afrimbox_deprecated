import 'package:afrimbox/controller/firestoreController.dart';
import 'package:afrimbox/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FacebookLoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin facebookSignIn = new FacebookLogin();
  FireStoreController fireStoreController = new FireStoreController();

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

    //var dateParse = DateTime.parse(new DateTime.now().toString());
    // var formattedDate =
    //     "${dateParse.day}-${dateParse.month}-${dateParse.year} | ${dateParse.hour}:${dateParse.minute}:${dateParse.second}";

    User usermodel = new User(
        authMethod: 'facebook',
        name: user.displayName,
        email: user.email,
        createdAt: DateTime.now(),
        updateAt: DateTime.now());

    Map datauser = usermodel.toMap();
    fireStoreController.insertDocument(collection: 'users', data: datauser);

    return user;
  }

  Future<void> signOut() async {
    await facebookSignIn.logOut();
    return true;
  }
}
