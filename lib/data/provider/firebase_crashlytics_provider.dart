import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirebaseCrashlyticsProvider{
  static void sendLog(String text){

  }
  static void sendLogWithUser(String text){
    final message = "{  phone: ${FirebaseAuth.instance.currentUser?.phoneNumber}, tenantId: ${FirebaseAuth.instance.currentUser?.tenantId}, uid: ${FirebaseAuth.instance.currentUser?.uid}, message: $text }";
    FirebaseCrashlytics.instance.log(message);
  }
}