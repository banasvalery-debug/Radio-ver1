import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:voicetruth/utils/logger.dart';

class FirebaseAuthProvider{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? actualCode;
  User? firebaseUser;

  Future<void> getCodeWithPhoneNumber(String phoneNumber, {
    required Function(FirebaseAuthException) verificationFailed,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
    int? forceResendingToken
  }) async{
    _auth.verifyPhoneNumber(timeout: Duration(seconds: 60),
        forceResendingToken: forceResendingToken,
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: (s, n){
            actualCode = s;
            codeSent(s,n);
        },
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<User?> validateOtpAndLogin(String smsCode)async{
    try {
      final AuthCredential _authCredential = PhoneAuthProvider.credential(
          verificationId: actualCode!, smsCode: smsCode);
      final a = await _auth.signInWithCredential(_authCredential).catchError((
          error) {
        FirebaseCrashlytics.instance.log(
            "Wrong code ! Please enter the last code received.");
      });
      firebaseUser = a.user;
      return firebaseUser;
    }catch(err){}
  }

  Future<bool> isAlreadyAuthenticated() async {
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      logger.i(await firebaseUser!.getIdToken());
      return true;
    } else {
      return false;
    }
  }
  Future<void> logout() async {
    await _auth.signOut();
    firebaseUser = null;
  }
}

final FirebaseAuthProvider instanceFirebaseAuthProvider = FirebaseAuthProvider();