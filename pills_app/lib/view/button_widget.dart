import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/logger.dart';

class ButtonGrid extends StatefulWidget {
  final int pillNum;
  final DateTime drunkedTime;
  final bool isDrunked;

  const ButtonGrid(
      {Key? key,
      required this.pillNum,
      required this.drunkedTime,
      required this.isDrunked})
      : super(key: key);

  @override
  ButtonGridState createState() => ButtonGridState();
}

class ButtonGridState extends State<ButtonGrid> {
  bool _showOverlay = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    setState(() {
      _showOverlay = widget.isDrunked;
      logger.d('initState: $_showOverlay');
    });
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
      if (_showOverlay == false) {
        firestore.collection('user').doc(_auth.currentUser!.uid).update({
          'drunkedTime': widget.drunkedTime,
          'isDrunked': false,
        });
        logger.d('pillCounterを戻す');
      } else {
        firestore.collection('user').doc(_auth.currentUser!.uid).update({
          'drunkedTime': now,
          'isDrunked': true,
        });
        logger.d('pillCounterを$nowに変更');
      }
    });
    logger.d('isDrunkedを$_showOverlayに変更');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: CupertinoColors.secondarySystemBackground,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/muji2.png'),
            ),
          ),
          height: 250,
          margin: const EdgeInsets.only(
            left: 30,
            right: 30,
          ),
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 30,
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
            ),
            itemCount: 28,
            itemBuilder: (context, index) {
              return CircularButton(
                  index: index,
                  pillNum: widget.pillNum,
                  showOverlay: _showOverlay,
                  onButtonPressed: _toggleOverlay);
            },
          ),
        ),
      ),
      // if (_showOverlay)
      //   Center(
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Container(
      //           width: double.infinity,
      //           margin: const EdgeInsets.only(
      //             top: 150,
      //             left: 100,
      //             right: 100,
      //           ),
      //           child: TextButton(
      //             style: TextButton.styleFrom(
      //               shape: const StadiumBorder(),
      //             ),
      //             onPressed: () async {
      //               setState(() {
      //                 _showOverlay = !_showOverlay;
      //                 if (_showOverlay == false) {
      //                   firestore
      //                       .collection('user')
      //                       .doc(_auth.currentUser!.uid)
      //                       .update({
      //                     'drunkedTime': widget.drunkedTime,
      //                     'isDrunked': false,
      //                   });
      //                   logger.d('pillCounterを戻す');
      //                 } else {
      //                   firestore
      //                       .collection('user')
      //                       .doc(_auth.currentUser!.uid)
      //                       .update({
      //                     'drunkedTime': now,
      //                     'isDrunked': true,
      //                   });
      //                   logger.d('pillCounterを$nowに変更');
      //                 }
      //               });
      //             },
      //             child: const Text(
      //               '戻る',
      //               style: TextStyle(fontWeight: FontWeight.bold),
      //             ),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
    ]);
  }
}

class CircularButton extends StatelessWidget {
  final int index;
  final int pillNum;
  final bool showOverlay;
  final VoidCallback onButtonPressed;

  const CircularButton({
    Key? key,
    required this.index,
    required this.pillNum,
    required this.showOverlay,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = CupertinoColors.secondarySystemBackground;

    if (showOverlay) {
      if (index == pillNum) {
        backgroundColor = Colors.grey[600]!;
      }
    } else {
      if (index == pillNum) {
        backgroundColor = Colors.amberAccent[400]!;
      }
    }
    if (index < pillNum) {
      backgroundColor = Colors.grey[600]!;
    } else if (index >= 21) {
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
        if (index == pillNum) {
          onButtonPressed();
          logger.d('showoverlayの値：$showOverlay');
        }
        // logger.d('Button $index pressed');
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
