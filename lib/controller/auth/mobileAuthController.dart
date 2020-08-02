import 'package:firebase_auth/firebase_auth.dart';

class MobileAuthController {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int confirmationCodeSent;
  String verificationId;
  String err;
  double status;
  bool phoneNumberIsinThePhone = false;

  // send confirmation code
  Future<void> sendConfirmationCode(String phone) async {
    // send code
    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      this.confirmationCodeSent = forceResendingToken;
    };

    // timeout
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
    };

    // verification failed
    PhoneVerificationFailed verificationFailed = (AuthException error) {
      this.err = error.toString();
      this.status = 500;
      this.phoneNumberIsinThePhone = false;
    };

    // verification completed
    PhoneVerificationCompleted verificationCompleted = (AuthCredential auth) {
      this.phoneNumberIsinThePhone = true;
      //await _firebaseAuth.signInWithCredential(auth);
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone.trim(),
        timeout: Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  // when the user use a number that is not in the current device
  Future<AuthCredential> confirmCodeFromAnotherDevice(payload) async {
    return PhoneAuthProvider.getCredential(
        verificationId: payload['verificationId'].toString(),
        smsCode: payload['confirmationCode'].toString());
  }

  // this method is used to log the user
  Future<FirebaseUser> auth(AuthCredential phoneAuthCredential) async {
    AuthResult result =
        await _firebaseAuth.signInWithCredential(phoneAuthCredential);
    return result.user;
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
