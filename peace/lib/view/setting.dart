import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_app/repository/firebase/auth_service.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<SettingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  String email = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CupertinoColors.secondarySystemBackground,
          elevation: 0,
          title: Container(
            margin: const EdgeInsets.only(left: 10, top: 10,),
            child: const Text(
            '設定',
            style: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.black,
            ),
          ),),
          centerTitle: false,
          toolbarHeight: 120,
        ),
        backgroundColor: Colors.white,
        body: SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              // title: Container(
              //   margin: const EdgeInsets.only(
              //     bottom: 15,
              //   ),
              //   child: const Text(
              //   '設定',
              //   style: TextStyle(
              //       fontSize: 20,
              //       color: Colors.black,
              //       // fontWeight: FontWeight.bold,
              //   ),
              // ),),
              tiles: <SettingsTile>[
                SettingsTile(
                  title: const Text('ピルの設定'),
                  trailing: const Icon(Icons.more_vert), // ← 追加
                  onPressed: (context) => _goToPillSetting(),
                ),
                SettingsTile(
                  title: const Text('パスワード変更'),
                  trailing: const Icon(Icons.more_vert), // ← 追加
                  onPressed: (context) => _changePassword(),
                ),
                SettingsTile(
                  title: const Text('ログアウト'),
                  trailing: const Icon(Icons.more_vert), // ← 追加
                  onPressed: (context) => _signOut(),
                ),
              ],
            ),
          ],
        ));
  }

    Future<void> _goToPillSetting() async {
    Get.toNamed('/pill_select');
  }

  Future<void> _changePassword() async {
    if (_auth.currentUser!.email != null) {
      email = _auth.currentUser!.email!;
      await AuthService.sendPasswordResetEmail(email)
          .then((value) => Get.toNamed('/sign_in'));
    }
  }

  Future<void> _signOut() async {
    await AuthService.signOut();
    Get.toNamed('/sign_in');
  }
}
