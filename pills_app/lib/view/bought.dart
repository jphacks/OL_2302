import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pills_app/main.dart';
import 'package:pills_app/services/pill_inventory_service.dart';

import '../utils/logger.dart';

class BoughtPage extends StatefulWidget {
  const BoughtPage({super.key});

  @override
  BoughtState createState() => BoughtState();
}

class BoughtState extends State<BoughtPage> {
  late Future<void> future;
  var selectDate = DateTime.now();
  int _unusedValue = 1;
  int _buyPillValue = 1;
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();
  int month = 1;
  int day = 1;
  String time = '';
  int hour = 0;
  int min = 0;

  @override
  void initState() {
    super.initState();
    future = currentNum();
  }

  Future<void> currentNum() async {
    final doc =
        await firestore.collection('user').doc(_auth.currentUser!.uid).get();
    if (doc.exists) {
      _unusedValue = doc.data()?['unusedPillSheetNum'] as int;
      _buyPillValue = doc.data()?['buyPillSheetNum'] as int;
      time = doc.data()?['pillTime'] as String;
      List<String> timeParts = time.split(':');
      hour = int.parse(timeParts[0]);
      min = int.parse(timeParts[1]);
    } else {
      _unusedValue = 1;
      _buyPillValue = 1;
    }
    logger.d('現在の薬の番号は$_unusedValue');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: future, // initStateで保存したFutureを使用します
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(color: Colors.black),
              ),
            ); 
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // エラーを表示
          } else {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 30, top: 30),
                      child: const Text(
                        'ピルの情報',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 25,
                            right: 30,
                            left: 30,
                          ),
                          alignment: Alignment.center,
                          child: Text('現在持っている未使用のピルは$_unusedValue枚です。',
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.black)),
                        ),
                        Container(
                          width: 330,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(
                            right: 30,
                            left: 30,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                NumberPicker(
                                    itemHeight: 100,
                                    itemWidth: 80,
                                    haptics: true,
                                    axis: Axis.horizontal,
                                    value: _unusedValue,
                                    minValue: 0,
                                    maxValue: 30,
                                    onChanged: (value) {
                                      setState(() => _unusedValue = value);
                                    },
                                    selectedTextStyle: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                    )),
                              ]),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 25,
                            right: 30,
                            left: 30,
                          ),
                          alignment: Alignment.center,
                          child: Text('1度に購入するピルの枚数は$_buyPillValue枚です。',
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.black)),
                        ),
                        Container(
                          width: 330,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(
                            right: 30,
                            left: 30,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                NumberPicker(
                                    itemHeight: 100,
                                    itemWidth: 80,
                                    haptics: true,
                                    axis: Axis.horizontal,
                                    value: _buyPillValue,
                                    minValue: 0,
                                    maxValue: 30,
                                    onChanged: (value) {
                                      setState(() => _buyPillValue = value);
                                    },
                                    selectedTextStyle: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                    )),
                              ]),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 150, left: 30, right: 30),
                      child: SizedBox(
                          width: double.infinity,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () async {
                                firestore
                                    .collection('user')
                                    .doc(_auth.currentUser!.uid)
                                    .update({
                                  'unusedPillSheetNum': _unusedValue,
                                  'buyPillSheetNum': _buyPillValue,
                                });
                                DateTime calculateDate =
                                    await PillInventoryService.calculateDate();
                                firestore
                                    .collection('user')
                                    .doc(_auth.currentUser!.uid)
                                    .update({
                                  'nextBuyTime':
                                      Timestamp.fromDate(calculateDate),
                                });
                                notificationService.scheduleDateNotification(calculateDate);
                                logger.d('$_unusedValueと$_buyPillValueに変更');
                                Get.offAllNamed('/navi');
                              },
                              child: const Text('完了',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                    ),
                  ]),
            );
          }
        });
  }
}
