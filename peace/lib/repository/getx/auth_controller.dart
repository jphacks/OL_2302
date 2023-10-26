import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // Firebaseのユーザーを管理するRxUser
  final Rx<User?> _firebaseUser = Rx<User?>(null);

  // 外部から_userを参照するためのgetter
  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
  }
}
