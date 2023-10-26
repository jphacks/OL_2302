import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pills_app/data/user.dart';

import '../../utils/logger.dart';

const storage = FlutterSecureStorage();

mixin UserFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _userCollection = _firebaseFirestoreInstance.collection('user');

  static Future<void> insertNewAccount(String uid) async {
    try {
      const TimeOfDay initialTime = TimeOfDay(hour: 12, minute: 0);
      final String initialTimeString =
          '${initialTime.hour}:${initialTime.minute}';

      await _userCollection.doc(uid).set({
        'pillCounter': 1,
        'unusedPillSheetNum': 0,
        'buyPillSheetNum': 0,
        'pillTime': initialTimeString,
        'drunkedTime': DateTime.now(),
        'nextBuyTime': DateTime.now(),
        'isDrunked': false,
      });
      logger.d('アカウント作成に成功しました。 === $uid');
    } on Exception catch (e) {
      logger.e('アカウント作成に失敗しました。==== $e');
    }
  }

  static Future<void> createUser(String uid) async {
    await insertNewAccount(uid);
    await storage.write(key: 'user_uid', value: uid);
  }

  static Future<List<QueryDocumentSnapshot>?> fetchUsers() async {
    try {
      final snapshot = await _userCollection.get();
      return snapshot.docs;
    } on Exception catch (e) {
      logger.e('ユーザー情報の取得失敗 ===== $e');
    }
    return null;
  }

  static Future<User?> fetchProfile(String uid) async {
    try {
      final snapshot = await _userCollection.doc(uid).get();

      if (!snapshot.exists) {
        logger.e('ユーザー情報が存在しないため、新しいユーザーを作成します。');
        await createUser(uid);
        // 新しく作成したユーザーの情報を取得します。
        final newSnapshot = await _userCollection.doc(uid).get();
        final user = User(
          uid: uid,
          name: newSnapshot.data()!['name'] as String?,
        );
        return user;
      } else {
        logger.d('ユーザー情報が存在するため、その情報を取得します。');
        final user = User(
          uid: uid,
          name: snapshot.data()!['name'] as String?, 
        );
        return user;
      }
    } on Exception catch (e) {
      logger.e('自分のユーザー情報の取得失敗 ===== $e');
      return null;
    }
  }

  static Future<void> updateUser(User newProfile) async {
    try {
      final dataToUpdate = <String, dynamic>{};
      if (dataToUpdate.isNotEmpty) {
        await _userCollection.doc(newProfile.uid).update(dataToUpdate);
      }
    } on Exception catch (e) {
      logger.e('ユーザー情報の更新失敗 ===== $e');
    }
  }
}
