import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/logger.dart';

mixin PillInventoryService {

  static Future<DateTime> calculateDate() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final DocumentSnapshot doc =
        await firestore.collection('user').doc(auth.currentUser!.uid).get();

    int currentSheet = 28;
    int unusedSheet = 28;
    DateTime today = DateTime.now();
    int hour = 0;
    int min = 0;

    if (doc.exists) {
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      currentSheet -= userData['pillCounter'] as int;
      unusedSheet *= userData['unusedPillSheetNum'] as int;

      List<String> timeParts = (userData['pillTime'] as String).split(':');
      hour = int.parse(timeParts[0]);
      min = int.parse(timeParts[1]);
    } else {
      logger.d('現在の薬の番号を取得できませんでした。');
      return DateTime.now(); // エラーが発生した場合の適切な返り値を選択してください。
    }

    int totalDays = (currentSheet + unusedSheet);

    DateTime targetDate = today.add(Duration(days: totalDays));

    logger.d('次にシートを買うのは${targetDate.month}月${targetDate.day}日です。');

    return DateTime(today.year, targetDate.month, targetDate.day, hour, min);
  }

  static Future<DateTime> calculateDateMain() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final DocumentSnapshot doc =
        await firestore.collection('user').doc(auth.currentUser!.uid).get();

    int pillInterval = 28;
    DateTime today = DateTime.now();
    int hour = 0;
    int min = 0;

    if (doc.exists) {
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      pillInterval *= userData['buyPillSheetNum'] as int;

      List<String> timeParts = (userData['pillTime'] as String).split(':');
      hour = int.parse(timeParts[0]);
      min = int.parse(timeParts[1]);
    } else {
      logger.d('現在の薬の番号を取得できませんでした。');
      return DateTime.now(); // エラーが発生した場合の適切な返り値を選択してください。
    }

    int totalDays = pillInterval;

    DateTime targetDate = today.add(Duration(days: totalDays));

    logger.d('次にシートを買うのは${targetDate.month}月${targetDate.day}日です。');

    return DateTime(today.year, targetDate.month, targetDate.day, hour, min);
  }

}
