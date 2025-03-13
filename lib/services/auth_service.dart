import 'package:firebase_auth/firebase_auth.dart';

class AuthserviceHelper {
  static Future<String> createAccountWithEmail(
      String email, String password) async {
    try {
      //for firebseauthenthication
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      return "Account Created"; //this String is used to check user is created
    } on FirebaseAuthException catch (e) {
      //to catch execption in firebase authenthication
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

//login
  static Future<String> loginWithEmail(String email, String password) async {
    try {
      //for firebseauthenthication
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return "Login succesfull"; //this String is used to check user is created
    } on FirebaseAuthException catch (e) {
      //to catch execption in firebase authenthication
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  //logout
  static Future logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //check user Alreadylogin or loggout
  static Future<bool> isUserLoggedIn() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null ? true : false;
  }
}
