import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pills_app/utils/logger.dart';

class SlideShowScreen extends StatefulWidget {
  const SlideShowScreen({super.key});

  @override
  SlideShowScreenState createState() => SlideShowScreenState();
}

class SlideShowScreenState extends State<SlideShowScreen> {
  late PageController _pageController;
  late Timer _timer;
  int _currentIndex = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': '低用量ピルの飲み方',
      'description': '初めて低用量ピルを飲む方に向けたお話。',
      'route': '/story'
    },
    {'title': '低用量ピルの種類', 'description': '自分に合ったものを探そう！', 'route': '/story2'},
    {'title': 'アフターピルとは', 'description': 'アフターピルについてのお話。', 'route': '/story'},
    {
      'title': '低用量ピルの購入方法',
      'description': '自分に合った入手方法を探そう！',
      'route': '/story'
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentIndex < _slides.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(_currentIndex,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: _slides.length,
      itemBuilder: (context, index) {
        var slide = _slides[index];
        return GestureDetector(
          onTap: () {
            logger.d('Item #$index tapped!');
            Get.toNamed(slide['route']!);
          },
          child: Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    slide['title']!,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    slide['description']!,
                    style: const TextStyle(fontSize: 15, color: CupertinoColors.systemGrey),
                  ),
                ])));
      },
    );
  }

}
