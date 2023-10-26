import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_app/repository/firebase/auth_service.dart';
import 'package:pills_app/view/sign_up.dart';

import '../utils/logger.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  String errorMessage = '';
  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateEmail);
    passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _validateEmail() {
    if (!EmailValidator.validate(emailController.text)) {
      setState(() {
        emailErrorMessage = '正しいメールアドレスを入力してください';
        isButtonEnabled = false;
        errorMessage = '';
      });
    } else {
      setState(() {
        emailErrorMessage = '';
        isButtonEnabled = true;
        errorMessage = '';
      });
    }
  }

  _validatePassword() {
    if (passwordController.text.length < 8) {
      setState(() {
        passwordErrorMessage = 'パスワードは8文字以上で入力してください';
        isButtonEnabled = false;
        errorMessage = '';
      });
    } else {
      setState(() {
        passwordErrorMessage = '';
        isButtonEnabled = true;
        errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: 5,
                top: 5,
              ),
              alignment: Alignment.centerLeft,
              child: const Text(
                'ログイン',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
                    fillColor: Colors.grey.shade200,
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
            ]),
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
                  'パスワード',
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      errorText: passwordErrorMessage.isNotEmpty
                          ? passwordErrorMessage
                          : null,
                    ),
                    controller: passwordController,
                  )),
            ]),
            Column(children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 30, right: 30, top: 20, bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          isButtonEnabled ? Colors.black : Colors.grey[300],
                      shape: const StadiumBorder(),
                    ),
                    onPressed: isButtonEnabled
                        ? () async {
                            try {
                              var result =
                                  await AuthService.signInWithEmailAndPassword(
                                      emailController.text,
                                      passwordController.text);
                              if (result == SignInResult.success) {
                                Get.toNamed('/navi');
                              } else if (result == SignInResult.wrongPassword) {
                                passwordController.clear();
                                setState(() {
                                  passwordErrorMessage = 'パスワードが間違っています';
                                  isButtonEnabled = false;
                                });
                              } else if (result == SignInResult.userNotFound) {
                                emailController.clear();
                                setState(() {
                                  emailErrorMessage = 'メールアドレスが間違っています';
                                  isButtonEnabled = false;
                                });
                              } else {
                                setState(() {
                                  errorMessage = 'アカウントが見つかりません';
                                  isButtonEnabled = false;
                                });
                              }
                            } catch (e) {
                              logger.d('Unexpected error: $e');
                            }
                          }
                        : null,
                    child: const Text(
                      'ログイン',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // この行で文字を太くしています
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: Text(errorMessage,
                    style: const TextStyle(color: Colors.red)),
              ),
            ]),
            Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Get.to(const SignUp());
                    },
                    child: const Text('新規登録はこちら'))),
            const SizedBox(height: 50),
          ]),
    );
  }
}
