import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginProvider extends ChangeNotifier {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;
  AuthCredential _phoneAuthCredential;
  String _verificationId;
  //String phone;
  int confirmationCodeSent;
  String err;
  double status;

  Future<void> getFirebaseUser() async {
    this._firebaseUser = await FirebaseAuth.instance.currentUser();
    this.status = (_firebaseUser == null) ? 403 : 200;
  }

  Future<void> verifyPhoneNumber({String phone}) async {
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: this.verificationCompleted,
        verificationFailed: this.verificationFailed,
        codeSent: this.codeSent,
        codeAutoRetrievalTimeout: this.codeAutoRetrievalTimeout);
  }

  void codeSent(String verificationId, [int code]) {
    this.confirmationCodeSent = code;
    print('DEBBUG CONFIRMATION SENT ${this.confirmationCodeSent}');
    //this._verificationId = verificationId;
  }

  void codeAutoRetrievalTimeout(String verificationId) {}

  void verificationFailed(AuthException error) {
    this.err = error.toString();
    this.status = 500;
  }

  void verificationCompleted(AuthCredential phoneAuthCredential) {
    this._phoneAuthCredential = phoneAuthCredential;
    this.status = 200;
    print('DEBBUG VERIFICATION COMPLETED ${this._phoneAuthCredential}');
  }

// when the user use a number that is not in the current device
  void submitOTP() {
    this._phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: this._verificationId,
        smsCode: this.confirmationCodeSent.toString());

    login();
  }

// this method is used to log the user
  Future<void> login() async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential)
          .then((AuthResult authRes) {
        _firebaseUser = authRes.user;
        this.status = 200;
        //print(_firebaseUser.toString());
      });
    } catch (e) {
      this.err = e.toString();
      print(e.toString());
    }
  }
}
