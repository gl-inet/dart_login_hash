import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _getHash({
    required String password,
    required int alg,
    required String salt,
    required String nonce,
  }) {
    Crypt? pw;
    switch (alg) {
      case 1:
        pw = Crypt.md5(password, salt: salt);
        break;
      case 5:
        pw = Crypt.sha256(password, salt: salt);
        break;
      case 6:
        pw = Crypt.sha512(password, salt: salt);
        break;
      default:
    }
    if (pw != null) {
      String hash = md5.convert(utf8.encode('root:$pw:$nonce')).toString();
      print(hash);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              _getHash(
                password: "goodlife",
                alg: 1,
                salt: "IsXk3Zfh",
                nonce: "5WFK6Rf17sqztTTF4k6AJIcbIZzKetdG",
              );
            },
            child: Container(
              width: 200,
              height: 40,
              alignment: Alignment.center,
              child: Text("Get Hash"),
            ),
          ),
        ),
      ),
    );
  }
}
