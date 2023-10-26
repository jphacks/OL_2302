import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../utils/logger.dart';

class NotificationService {
  NotificationService();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late DateTime notificationTime;
  int hours = 0;
  int minutes = 0;

  Future<void> initializeNotification() async {
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await requestPermissions();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));
  }

  Time stringToTime(String timeString) {
    final List<String> timeParts = timeString.split(':');
    return Time(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      logger.d('通知を全てキャンセルしました');
    } catch (e) {
      logger.d('通知のキャンセルに失敗しました');
    }
  }

  Future<void> sendInstantNotification() async {
    try {
      logger.d('通知開始');
      await flutterLocalNotificationsPlugin.show(
        10,
        'pills',
        '薬を忘れずに飲みましょう！',
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            badgeNumber: 1,
          ),
        ),
      );
      logger.d('通知終了');
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> scheduleNotification(int hour, int min) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'pills',
        '本日の服薬をしましょう',
        _nextInstanceOfEveryNotification(hour, min),
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            badgeNumber: 1,
          ),
          macOS: DarwinNotificationDetails(
            badgeNumber: 1,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      logger.d('通知のエラー$e');
    }
    logger.d('毎日$hour:$minに通知を設定しました');
  }

  tz.TZDateTime _nextInstance(int hour, int min) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    logger.d('_nextInstance: $scheduledDate');
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfEveryNotification(int hour, int min) {
    tz.TZDateTime scheduledDate = _nextInstance(hour, min);
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduleDateNotification(DateTime scheduleTime) async {
    int month = scheduleTime.month;
    int day = scheduleTime.day;
    int hour = scheduleTime.hour;
    int min = scheduleTime.day;
    int dayUnderSeven = 30 - (7 - day);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      'pills',
      '今日で薬が切れます。',
      _nextDateInstance(month, day, hour, min),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          badgeNumber: 1,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    logger.d('$month月$day日$hour:$minに通知を設定しました');

    if (day > 7) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        3,
        'pills',
        'あと１週間で薬がなくなります。買い足しましょう。',
        _nextDateInstance(month, day - 7, hour, min),
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            badgeNumber: 1,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      logger.d('$month月$day-7,日$hour:$minに通知を設定しました');
    } else {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        4,
        'pills',
        'あと１週間で薬がなくなります。買い足しましょう。',
        _nextDateInstance(month, dayUnderSeven, hour, min),
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            badgeNumber: 1,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      logger.d('$month月$dayUnderSeven日$hour:$minに通知を設定しました');
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      5,
      'pills',
      'あと1か月で薬が切れます。買い足しましょう。',
      _nextDateInstance(month - 1, day, hour, min),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          badgeNumber: 1,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    logger.d('$month-1月$day日$hour:$minに通知を設定しました');
  }

  tz.TZDateTime _nextDateInstance(int month, int day, int hour, int min) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, month, day, hour, min);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
