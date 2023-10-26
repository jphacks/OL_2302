import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../utils/logger.dart';

class DateSelectPage extends StatefulWidget {
  const DateSelectPage({super.key});

  @override
  DateSelectState createState() => DateSelectState();
}

class DateSelectState extends State<DateSelectPage> {
  Time _time = Time(hour: 10, minute: 0);
  String initialTime = '';
  bool iosStyle = true;
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int hours = 12;
  int minutes = 0;
  ValueKey<DateTime> _pickerKey = ValueKey(DateTime.now());

  @override
  void initState() {
    super.initState();
    notificationService.cancelAllNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await currentNum();
    });
  }

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
      logger.d('Inside onTimeChanged: $_time');
    });
  }

  Time stringToTime(String timeString) {
    final List<String> timeParts = timeString.split(':');
    return Time(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
  }

  String timeToString(Time time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<Time> currentNum() async {
    final doc =
        await firestore.collection('user').doc(_auth.currentUser!.uid).get();
    if (doc.exists) {
      initialTime = doc.data()!['pillTime'];
    } else {
      initialTime = '12:00';
    }
    logger.d('initialTime: $initialTime');
    setState(() {
      _time = stringToTime(initialTime);
      _pickerKey = ValueKey(DateTime.now());
    });
    logger.d('現在の時間は$_time');
    return _time;
  }

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 30, top: 30),
                child: const Text(
                  '通知時間の設定',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(children: [
                SizedBox(
                  key: _pickerKey,
                  child: showPicker(
                    isOnChangeValueMode: true,
                    isInlinePicker: true,
                    elevation: 0,
                    value: _time,
                    onChange: onTimeChanged,
                    minuteInterval: TimePickerInterval.TEN,
                    iosStylePicker: iosStyle,
                    minHour: 0,
                    maxHour: 23,
                    is24HrFormat: true,
                    displayHeader: false,
                    height: 280,
                    hideButtons: true,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  alignment: Alignment.center,
                  child: Text('${_time.format(context)}にピルを飲みます。',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ))),
              ]),
              Container(
                margin: const EdgeInsets.only(bottom: 150, left: 30, right: 30),
                child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          firestore
                              .collection('user')
                              .doc(_auth.currentUser!.uid)
                              .update({
                            'pillTime': timeToString(_time),
                          }).then((value) {
                            hours = _time.hour;
                            minutes = _time.minute;
                            // notificationService.scheduleNotification(hours, minutes);
                            notificationService.sendInstantNotification();
                          });
                          logger
                              .d('pillTimeを$_timeに変更し、通知を$hours : $minutesに設定');
                          Get.toNamed('/bought');
                        },
                        child: const Text('次へ',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
              ),
            ]));
  }
}
