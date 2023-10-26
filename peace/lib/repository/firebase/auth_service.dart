import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/logger.dart';

enum SignInResult { success, userNotFound, wrongPassword, unknownError }

enum SignUpResult { success, emailAlreadyInUse, weakPassword, unknownError }

mixin AuthService {
  static Future<SignInResult> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return SignInResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logger.d('No user found for that email.');
        return SignInResult.userNotFound;
      } else if (e.code == 'wrong-password') {
        logger.d('Wrong password provided for that user.');
        return SignInResult.wrongPassword;
      }
      logger.d(e);
    } catch (e) {
      logger.d(e);
      return SignInResult.unknownError;
    }
    return SignInResult.unknownError;
  }

  static Future<SignUpResult> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return SignUpResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logger.d('The password provided is too weak.');
        return SignUpResult.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        logger.d('The account already exists for that email.');
        return SignUpResult.emailAlreadyInUse;
      }
      logger.d(e);
    } catch (e) {
      logger.d(e);
      return SignUpResult.unknownError;
    }
    return SignUpResult.unknownError;
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      logger.d('Password reset email sent.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        logger.d('The email address is badly formatted.');
      } else if (e.code == 'user-not-found') {
        logger.d('No user found for that email.');
      }
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
