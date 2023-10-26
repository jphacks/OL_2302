import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pills_app/view/note.dart';
import 'package:pills_app/view/pill.dart';
import 'package:pills_app/view/setting.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  var _currentPageIndex = 0;
  final _pageViewController = PageController();

  final _pages = <Widget>[
    const PillPage(),
    const NotePage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageViewController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        height: 55,
        currentIndex: _currentPageIndex,
        onTap: (int index) {
          setState(() {
            _pageViewController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          });
        },
        activeColor: CupertinoColors.black,
        backgroundColor: Colors.transparent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'pills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: '情報',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
