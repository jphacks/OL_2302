import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/logger.dart';

class NumberSelectPage extends StatefulWidget {
  const NumberSelectPage({super.key});

  @override
  NumberSelectState createState() => NumberSelectState();
}

class NumberSelectState extends State<NumberSelectPage> {
  var selectDate = DateTime.now();
  int _currentIntValue = 1;
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    currentNum();
  }

  Future<int> currentNum() async {
    final doc =
        await firestore.collection('user').doc(_auth.currentUser!.uid).get();
    if (doc.exists) {
      setState(() => _currentIntValue = doc.data()?['pillCounter'] as int);
    } else {
      setState(() => _currentIntValue = 1);
    }
    logger.d('現在の薬の番号は$_currentIntValue');
    return _currentIntValue;
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
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 30, top: 30, bottom: 50),
              child: const Text(
                'ピル番号の設定',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                right: 20,
                left: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/muji2.png'),
                      ),
                    ),
                    height: 250,
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 30,
                    ),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1.0,
                        mainAxisSpacing: 15.0,
                        crossAxisSpacing: 15.0,
                      ),
                      itemCount: 28,
                      itemBuilder: (context, index) {
                        return InitCircularButton(
                          index: index,
                          pillNum: _currentIntValue - 1,
                          currentIntValue: _currentIntValue,
                          onButtonPressed: () {
                            setState(() {
                              _currentIntValue = index + 1;
                            });
                            firestore
                              .collection('user')
                              .doc(_auth.currentUser!.uid)
                              .update({
                              'pillCounter': _currentIntValue,
                            });
                            logger.d('pillCounterを$_currentIntValueに変更');
                            Get.toNamed('/date_select');
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                top: 30,
                left: 30,
              ),
              child: const Text('今日飲むピルの番号を選択してください。',
                  style: TextStyle(
                    fontSize: 15,
                    color: CupertinoColors.secondaryLabel,
                  ),
                  textAlign: TextAlign.left),
            ),
          ]),
    );
  }
}

class InitCircularButton extends StatelessWidget {
  final int index;
  final int pillNum;
  final int currentIntValue;
  final VoidCallback onButtonPressed;

  const InitCircularButton({
    Key? key,
    required this.index,
    required this.pillNum,
    required this.currentIntValue,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    if (index >= 21) {
      backgroundColor = Colors.lightGreen[300]!;
    } 

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const CircleBorder(),
        elevation: 2.5,
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        onButtonPressed();
        logger.d('Button $index pressed');
      },
      child: Text(
        '${index + 1}',
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black,
        ),
      ),
    );
  }
}
