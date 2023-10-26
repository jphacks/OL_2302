import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_app/utils/logger.dart';

class UserStatusPage extends StatefulWidget {
  const UserStatusPage({super.key});

  @override
  UserStatusState createState() => UserStatusState();
}

class UserStatusState extends State<UserStatusPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定',
            style: TextStyle(color: CupertinoColors.activeBlue)),
        backgroundColor: CupertinoColors.secondarySystemBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: CupertinoColors.activeBlue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        toolbarHeight: 50,
      ),
      backgroundColor: CupertinoColors.secondarySystemBackground,
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 30, top: 30, bottom: 50),
            child: const Text(
              'ユーザー情報の設定',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: <Widget>[
                    _createTile(
                        context, '低用量ピル使用者', 1, '/pill_select'),
                    _createTile(
                        context, '低用量ピル使用者のパートナー', 2, '/partner'),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  Widget _createTile(
      BuildContext context, String text, int value, String routeName) {
    return InkWell(
      onTap: () async {
        await firestore.collection('user').doc(_auth.currentUser!.uid).update({
          'userStatus': value,
        });
        Get.toNamed(routeName);
        logger.d('ピルの種類は$value');
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              child:Text(text,
                style: const TextStyle(
                  fontSize: 18.0,
                )),),
          ],
        ),
      ),
    );
  }
}
