import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoryTwoPage extends StatefulWidget {
  const StoryTwoPage({super.key});

  @override
  StoryTwoState createState() => StoryTwoState();
}

class StoryTwoState extends State<StoryTwoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('戻る',
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
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 30, top: 30),
                child: const Text(
                  '低用量ピルの種類',
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 16.0),
                      const Text(
                        '低用量ピルには、いくつかの異なる種類があります。主な違いは、含まれているホルモンの種類と量です。ここでは一般的な低用量ピルの種類について説明します。',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: const Column(children: [
                          Text(
                            '1. コンビネーションピル',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'エストロゲンとプロゲステロンの両方のホルモンを含むピルです。一般的に最も効果的で、副作用が少ないとされています。',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: const Column(children: [
                          Text(
                            '2. ミニピル',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'プロゲステロンのみを含むピルです。エストロゲンが含まれていないため、エストロゲンに対する反応が強い人に適しています。',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: const Column(children: [
                          Text(
                            '3. 延長サイクルピル',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            '通常のサイクルよりも長いサイクルで服用するピルです。月経を2〜3ヶ月に1回にすることができます。',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: const Column(children: [
                          Text(
                            '4. 緊急避妊ピル',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            '不慮の事態で避妊が失敗した場合に、後から服用することで避妊効果を得ることができるピルです。',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ]),
                      ),
                    ]),
              )
            ])));
  }
}
