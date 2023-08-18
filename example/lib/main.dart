import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gl_crypt/gl_crypt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GL.iNet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'RPC Example'),
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
  final String url = 'http://192.168.10.1/rpc';
  final String username = 'root';
  final String password = 'goodlife12';

  Map? status;

  void _loginAndGetStatus() {
    // Step1: Get encryption parameters by challenge method
    Dio().post(
      url,
      data: {
        'jsonrpc': '2.0',
        'method': 'challenge',
        'params': {
          'username': username,
        }
      },
    ).then(
      (value) {
        Map result = jsonDecode(value.data)['result'];
        int alg = result['alg'];
        String salt = result['salt'];
        String nonce = result['nonce'];

        // Step2: Generate cipher text using Crypt
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
        // Step3: Generate hash values for login
        String hash =
            md5.convert(utf8.encode('$username:$pw:$nonce')).toString();

        // Step4: Get sid by login
        Dio().post(
          url,
          data: {
            'jsonrpc': '2.0',
            'method': 'login',
            'params': {
              'username': username,
              'hash': hash,
            }
          },
        ).then(
          (value) {
            Map result = jsonDecode(value.data)['result'];
            String sid = result['sid'];

            // Step5: Calling other APIs with sid
            Dio().post(
              url,
              data: {
                'jsonrpc': '2.0',
                'method': 'call',
                'params': [
                  sid,
                  'system',
                  'get_status',
                ]
              },
            ).then(
              (value) {
                Map result = jsonDecode(value.data)['result'];
                setState(() {
                  status = result;
                });
                print(result);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'URL:$url',
            ),
            SizedBox(height: 10),
            Text(
              'Username:$username',
            ),
            SizedBox(height: 10),
            Text(
              'Password:$password',
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loginAndGetStatus,
              child: Text('Login and get status'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Visibility(
                visible: status != null,
                child: SingleChildScrollView(
                  child: Text(status.toString()),
                ),
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
