import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  NoteState createState() => NoteState();
}

class Item {
  final String title;
  final String description;
  final String route;

  Item(this.title, this.description, this.route);
}

final List<Map<String, String>> itemData = [
  {
    'title': '低用量ピルの飲み方',
    'description': '初めて低用量ピルを飲む方に向けたお話。',
    'route': '/story'
  },
  {'title': '低用量ピルの種類', 'description': '自分に合ったものを探そう！', 'route': '/story2'},
  {'title': 'アフターピルとは', 'description': 'アフターピルについてのお話。', 'route': '/story'},
  {'title': '低用量ピルの購入方法', 'description': '自分に合った入手方法を探そう！', 'route': '/story'},
];

class NoteState extends State<NotePage> {
  final List<Item> items = itemData.map((data) {
    return Item(data['title']!, data['description']!, data['route']!);
  }).toList();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ListView Example',
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CupertinoColors.secondarySystemBackground,
          elevation: 0,
          title: Container(
            margin: const EdgeInsets.only(left: 10,
              top: 10,
            ),
            child: const Text(
            'ピル情報',
            style: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.black,
            ),
          ),
          ),
          centerTitle: false,
          toolbarHeight: 120,
        ),
        backgroundColor: CupertinoColors.secondarySystemBackground,
        body: Column(children: <Widget>[
          // Container(
          //   alignment: Alignment.centerLeft,
          //   margin: const EdgeInsets.only(left: 30, bottom: 10, top: 20),
          //   child: const Text(
          //     'ピル情報',
          //     style: TextStyle(
          //       fontSize: 20.0,
          //       // fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(item.title,
                            style: const TextStyle(fontSize: 20.0)),
                        subtitle: Text(item.description),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => Get.toNamed(item.route),
                      )),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
