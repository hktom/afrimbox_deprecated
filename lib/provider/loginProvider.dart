import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginProvider extends ChangeNotifier {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  AuthCredential _phoneAuthCredential;
  String _verificationId;
  //String phone;
  int confirmationCodeSent;
  String err;
  double status;
  bool phoneNumberIsinThePhone = false;

  Future<void> getFirebaseUser() async {
    this.firebaseUser = await FirebaseAuth.instance.currentUser();
    this.status = (firebaseUser == null) ? 403 : 200;
  }

// verify my number
  Future<void> verifyPhoneNumber({String phone}) async {
    print("DEBBUG SEND SMS TO ${phone.toString().trim()}");

    // send code
    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this._verificationId = verificationId;
      this.confirmationCodeSent = forceResendingToken;
      print('DEBBUG CONFIRMATION SENT ${this.confirmationCodeSent}');
    };

    // timeout
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this._verificationId = verificationId;
    };

    // verification failed
    final PhoneVerificationFailed verificationFailed = (AuthException error) {
      this.err = error.toString();
      this.status = 500;
      this.phoneNumberIsinThePhone = false;
      print(
          "DEBBUG THE PHONE NUMBER IS THIS CURRENT PHONE ${this.phoneNumberIsinThePhone}");
    };

    // verification completed
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
      //this.login();
      this.phoneNumberIsinThePhone = true;
      print(
          "DEBBUG THE PHONE NUMBER IS THIS CURRENT PHONE ${this.phoneNumberIsinThePhone}");
    };

    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone.toString().trim(),
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  // void codeSent(String verificationId, [int code]) {
  //   this._verificationId = verificationId;
  //   this.confirmationCodeSent = code;
  //   print('DEBBUG CONFIRMATION SENT ${this.confirmationCodeSent}');
  // }

  // void codeAutoRetrievalTimeout(String verificationId) {}

  // void verificationFailed(AuthException error) {
  //   this.err = error.toString();
  //   this.status = 500;
  // }

  // void verificationCompleted(AuthCredential phoneAuthCredential) {
  //   this._phoneAuthCredential = phoneAuthCredential;
  //   login();
  //   this.status = 200;
  //   print('DEBBUG VERIFICATION COMPLETED ${this._phoneAuthCredential}');
  // }

// when the user use a number that is not in the current device
  Future<void> submitOTP({int smsCode}) async {
    this._phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: this._verificationId, smsCode: smsCode.toString());

    await login();
  }

// this method is used to log the user
  Future<void> login() async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential)
          .then((AuthResult authRes) {
        firebaseUser = authRes.user;
        this.status = 200;
        print("LOG ME AUTOMATICALLY");
        //print(firebaseUser.toString());
      });
    } catch (e) {
      this.err = e.toString();
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      this.err = e.toString();
      print(e.toString());
    }
  }
}
