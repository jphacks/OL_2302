import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pills_app/repository/getx/auth_controller.dart';
import 'package:pills_app/route.dart';
import 'package:pills_app/utils/logger.dart';
import 'package:pills_app/view/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

late final NotificationService notificationService;

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notificationService = NotificationService();
    notificationService.initializeNotification();
    if (_auth.currentUser != null) {
      logger.d('current user: ${_auth.currentUser}');
    } else {
      logger.d('current user: null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: _auth.currentUser != null ? '/navi' : '/sign_in',
      getPages: AppPages.routes,
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return;
    }
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadger.removeBadge();
    } else {
      logger.d(state);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
