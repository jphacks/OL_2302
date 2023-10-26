import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_app/repository/firebase/partner_service.dart';

class SearchPartnerPage extends StatefulWidget {
  const SearchPartnerPage({super.key});

  @override
  SearchPartnerState createState() => SearchPartnerState();
}

class SearchPartnerState extends State<SearchPartnerPage> {
  TextEditingController emailController = TextEditingController(text: '');
  String emailErrorMessage = '';

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
              'パートナー検索',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(children: [
            Container(
              margin: const EdgeInsets.only(
                left: 40,
                right: 30,
                bottom: 5,
                top: 5,
              ),
              alignment: Alignment.centerLeft,
              child: const Text(
                'メールアドレス',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  errorText:
                      emailErrorMessage.isNotEmpty ? emailErrorMessage : null,
                ),
                controller: emailController,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 30, right: 30, top: 50, bottom: 50),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      PartnerService.findPartnerUidByEmail(
                              emailController.text)
                          .then((value) => Get.toNamed('/navi'));
                    },
                    child: const Text(
                      '検索',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
