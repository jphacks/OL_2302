import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pills_app/utils/logger.dart';

mixin PartnerService {
  static Future<Map<String, dynamic>?> getPartnerData(String partnerUid) async {
    try {
      DocumentSnapshot partnerData = await FirebaseFirestore.instance
          .collection('users')
          .doc(partnerUid)
          .get();
      if (partnerData.exists) {
        return partnerData.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      logger.d("Error getting partner data: $e");
      return null;
    }
  }

  static Future<void> updateUserDataWithPartnerData(String partnerUid) async {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;
    Map<String, dynamic>? partnerData = await getPartnerData(partnerUid);
    if (partnerData != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(partnerData);
    }
  }

  static Future<void> findPartnerUidByEmail(String email) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // return null;
        logger.d('No such user!');
      }

      final doc = querySnapshot.docs.first;
      updateUserDataWithPartnerData(doc.id);

      // return doc.id; // UIDを取得
    } catch (e) {
      logger.d(e);
      // return null;
    }
  }
}
