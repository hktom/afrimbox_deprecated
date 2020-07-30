import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:afrimbox/controller/firestoreController.dart';
import 'package:afrimbox/model/user.dart';

class GoogleLoginController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FireStoreController fireStoreController = new FireStoreController();

  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      return true;
    } catch (e) {
      print("GOOGLE SIGNOUT ERR ${e.toString()}");
      return false;
    }
  }

  Future<FirebaseUser> auth() async {
    // hold the instance of the authenticated user
    FirebaseUser user;
    // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      user = await _auth.currentUser();
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      user = (await _auth.signInWithCredential(credential)).user;
    }

    // User usermodel = new User(
    //     authMethod: 'google',
    //     name: user.displayName,
    //     email: user.email,
    //     createdAt: DateTime.now(),
    //     updateAt: DateTime.now());

    // Map<String, dynamic> datauser = usermodel.toMap();
    // var fireStoreUser = await fireStoreController.getDocument(
    //     collection: 'users', doc: user.email);

    // if (fireStoreUser.isEmpty) {
    //   bool saveprofile = await fireStoreController.insertDocument(
    //       collection: 'users', data: datauser, doc: user.email);
    //   print("PROFILE ON FIRESTORE ${saveprofile.toString()}");
    // }

    return user;
  }
}
