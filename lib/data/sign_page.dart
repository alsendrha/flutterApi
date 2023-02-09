import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_projext/data/user.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  final String _databaseURL =
      'https://minprojectapi-default-rtdb.firebaseio.com/';

  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;
  TextEditingController? _pwCheckTextController;
  String userId = '';
  String userPw = '';
  String userCheckPw = '';

  @override
  void initState() {
    super.initState();
    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();
    _pwCheckTextController = TextEditingController();

    _database = FirebaseDatabase(
      databaseURL: _databaseURL,
    );
    reference = _database?.ref().child('user');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('화원가입'),
          centerTitle: true,
        ),
        body: SizedBox(
          child: Center(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _idTextController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: '4자 이상 입력해주세요',
                        labelText: '아이디',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              30,
                            ),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _pwTextController,
                      obscureText: true,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: '6자 이상 입력해주세요',
                        labelText: '비밀번호',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              30,
                            ),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _pwCheckTextController,
                      obscureText: true,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: '비밀번호확인',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              30,
                            ),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_idTextController!.value.text.length >= 4 &&
                          _pwTextController!.value.text.length >= 6) {
                        if (_pwTextController!.value.text ==
                            _pwCheckTextController!.value.text) {
                          var bytes =
                              utf8.encode(_pwTextController!.value.text);
                          var digest = sha1.convert(bytes);
                          reference!
                              .child(_idTextController!.value.text)
                              .push()
                              .set(User(
                                      _idTextController!.value.text,
                                      digest.toString(),
                                      DateTime.now().toIso8601String())
                                  .toJson())
                              .then(
                            (_) {
                              Navigator.of(context).pop();
                            },
                          );
                        } else {
                          makeDialog('비밀번호가 틀립니다.');
                        }
                      } else {
                        makeDialog('길이가 짧습니다.');
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.blueAccent,
                      ),
                    ),
                    child: const Text(
                      '회원가입',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void makeDialog(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(text),
        );
      },
    );
  }
}
