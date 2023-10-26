import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_app/utils/logger.dart';

class PillSelectPage extends StatefulWidget {
  const PillSelectPage({super.key});

  @override
  PillSelectState createState() => PillSelectState();
}

class PillSelectState extends State<PillSelectPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
              'ピルの設定',
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
                _createTile(context, '第2世代', 'assets/images/second.png', 2),
                _createTile(context, '第3世代', 'assets/images/pills/day00.png', 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createTile(
      BuildContext context, String text, String imagePath, int value) {
    return InkWell(
      onTap: () async {
        await firestore.collection('user').doc(_auth.currentUser!.uid).update({
          'pillKind': value,
        });
        Get.toNamed('/number_select');
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
            Image.asset(imagePath, height: 120.0, width: 120.0),
            const SizedBox(height: 5.0),
            Text(text, style: const TextStyle(fontSize: 20.0,)),
          ],
        ),
      ),
    );
  }
}
