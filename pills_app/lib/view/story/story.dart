import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  StoryState createState() => StoryState();
}

class StoryState extends State<StoryPage> {
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
          child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 30, top: 30),
              child: const Text(
                '低用量ピルの飲み方',
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
              children:[
              const SizedBox(height: 16.0),
              const Text(
                '低用量ピルは、一日一錠を同じ時間に服用することが重要です。最初の錠剤を飲む日を決め、それを続けることが肝心です。',
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
                child: const Column(children:[
                  Text(
                    '1. ピルを始める日を選択',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'ピルを開始する日は、最初の月経周期の最初の日にするのが一般的です。しかし、医師の指示に従って異なる日に開始することもあります。',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ])),
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
                child: const Column(children:[
                  Text(
                    '2. 毎日同じ時間に服用',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '一日一回、毎日同じ時間に服用することが重要です。ピルを飲む時間を忘れないように、アラームをセットするなどしてリマインダーを作成しましょう。',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
              ])),
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
                child: const Column(children:[
                  Text(
                    '3. ピルの飲み忘れがあった場合',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'ピルを飲み忘れた場合、すぐに飲んでください。しかし、2錠以上飲み忘れた場合は、医師に相談してください。',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
              ])),
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
                child: const Column(children:[
                  Text(
                    '4. ピルの服用を続ける',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'ピルの服用を続けることが重要です。次のパックを開始する前に7日間の休薬期間がある場合も、新しいパックを開始することを忘れないようにしましょう。',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ])),
            ]),)
          ])));
  }
}
