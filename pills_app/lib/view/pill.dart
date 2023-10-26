import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pills_app/view/slide_show.dart';
import '../services/pill_inventory_service.dart';
import '../utils/logger.dart';
import 'button_widget.dart';

class PillPage extends StatefulWidget {
  const PillPage({super.key});

  @override
  PillState createState() => PillState();
}

class PillState extends State<PillPage> {
  late Future<void> future;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  Timestamp nextBuyTime = Timestamp.now();
  Timestamp today = Timestamp.now();
  String email = '';
  String status = '飲んだ';
  String initialTime = '';
  String message = 'お疲れ様でした。';
  int hours = 10;
  int minutes = 0;
  int pillNum = 0;
  final now = DateTime.now();
  DateTime drunkedTime = DateTime.now();
  DateTime _lastCheckedDate = DateTime.now();
  Timer? _timer;
  bool isDrunked = false;

  @override
  void initState() {
    super.initState();
    future = checkNextPillTime();
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      final now = DateTime.now();
      if (now.day != _lastCheckedDate.day) {
        _updateFirestore();
      }
      _lastCheckedDate = now;
    });
  }

  Future<void> checkNextPillTime() async {
    final doc =
        await firestore.collection('user').doc(_auth.currentUser!.uid).get();
    if (doc.exists) {
      nextBuyTime = doc.data()!['nextBuyTime'];
      pillNum = doc.data()?['pillCounter'] - 1;
      isDrunked = doc.data()?['isDrunked'];
    }
    logger.d('isDrunkedの値は$isDrunked');

    DateTime now = today.toDate();
    DateTime nextTime = nextBuyTime.toDate();
    Duration difference = nextTime.difference(now).abs();

    if (difference.inDays <= 7) {
      logger.d('todayとnextTimeの差は1週間以内です。');
      setState(() {
        message = 'そろそろピルが切れます。';
      });
    } else if (difference.inDays <= 30) {
      logger.d('1か月以内にピルが切れます。');
      setState(() {
        message = 'あと1か月でピルが切れます。';
      });
    } else if (isDrunked == true) {
      logger.d('今日もお疲れ様でした！');
      setState(() {
        message = '今日もお疲れ様でした！';
      });
    } else {
      logger.d('ピルが切れるまでまだまだ期間があります。');
      setState(() {
        message = 'ピルが切れるまでまだまだ期間があります。';
      });
    }

    if (difference.inDays == 0) {
      DateTime calculateDate = await PillInventoryService.calculateDateMain();
      firestore.collection('user').doc(_auth.currentUser!.uid).update({
        'nextBuyTime': Timestamp.fromDate(calculateDate),
      });
      // notificationService.scheduleDateNotification(calculateDate);
    }
  }

  Time stringToTime(String timeString) {
    final List<String> timeParts = timeString.split(':');
    return Time(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
  }

  _updateFirestore() async {
    final doc =
        await firestore.collection('user').doc(_auth.currentUser!.uid).get();
    if (doc.exists) {
      pillNum = doc.data()?['pillCounter'];
      doc.data()?['isDrunked'] = false;
      logger.d('現在の薬の番号は$pillNum');
    }
    firestore.collection('user').doc(_auth.currentUser!.uid).update({
      'pillCounter': pillNum + 1,
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
            // データが読み込まれたら、ウィジェットを表示
            return Stack(
              children: [
                Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: CupertinoColors.secondarySystemBackground,
                    elevation: 0,
                    title: Image.asset(
                      'assets/images/pills_t.png',
                      height: 120,
                    ),
                    centerTitle: false,
                    toolbarHeight: 120,
                  ),
                  backgroundColor: CupertinoColors.secondarySystemBackground,
                  body: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(
                            // height: 50,
                          ),
                          Expanded(
                            child: SizedBox(
                                height: 300,
                                child: ButtonGrid(
                                  pillNum: pillNum,
                                  drunkedTime: drunkedTime,
                                  isDrunked: isDrunked,
                                )),
                          ),
                          Column(children: [
                            // Container(
                            //   width: double.infinity,
                            //   // decoration: BoxDecoration(
                            //   //   color: Colors.white,
                            //   //   borderRadius: BorderRadius.circular(10),
                            //   // ),
                            //   margin: const EdgeInsets.only(
                            //     left: 30,
                            //     right: 30,
                            //   ),
                            //   padding: const EdgeInsets.all(20),
                            //   child: Text(
                            //     message,
                            //     style: const TextStyle(
                            //       color: Colors.black,
                            //       fontSize: 20,
                            //     ),
                            //   ),
                            // ),
                            // TextButton(
                            //     child: const Text('通知を送る'),
                            //     onPressed: () {
                            //       notificationService.cancelAllNotifications();
                            //       notificationService.sendInstantNotification();
                            //     }),
                            Column(children:[
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                  // bottom: 20,
                                ),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'ピルに関する情報もチェック！',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 40,
                                ),
                                child: const SizedBox(
                                  height: 130,
                                  child: SlideShowScreen(),
                                ),
                              ),
                            ])
                          ]),
                        ]),
                  ),
                ),
              ],
            );
          }
        });
  }
}
