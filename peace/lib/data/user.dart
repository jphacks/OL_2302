import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  User({
    this.name,
    required this.uid,
    this.imagePath,
    this.email,
    this.pillKind,
    this.pillCounter,
    this.pillTime,
    this.unusedPillSheetNum,
    this.buyPillSheetNum,
    this.drunkedTime,
    this.nextBuyTime,
    this.isDrunked,
    this.userStatus
  });
  String? name;
  String uid;
  String? imagePath;
  String? email;
  int? pillKind;
  int? pillCounter;
  TimeOfDay? pillTime;
  int? unusedPillSheetNum;
  int? buyPillSheetNum;
  DateTime? drunkedTime;
  Timestamp? nextBuyTime;
  bool? isDrunked;
  int? userStatus;
}
