import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

class LoginsignupPage extends StatefulWidget {
  const LoginsignupPage({Key? key, required this.title}) : super(key: key);
  //const LoginPage({super.key, required this.title});
  final String title;

  @override
  _LoginsignupPageState createState() => new _LoginsignupPageState();
}

class _LoginsignupPageState extends State<LoginsignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Hi',
          textAlign: TextAlign.left,
          style: TextStyle(
              backgroundColor: Colors.yellow,
              color: Color(0xff0d3b66),
              fontSize: 32,
              letterSpacing:
              0 /*percentages not used in flutter. defaulting to zero*/,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        //Text(widget.title, style: TextStyle(color: Color(0xff0d3b66))),
        backgroundColor: Colors.white,

      ),

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(right: 80, left: 80, top: 80),
            child: Text(
              'Welcome to',
              textAlign: TextAlign.center,
              style: TextStyle(
                  backgroundColor: Colors.yellow,
                  color: Color(0xff0d3b66),
                  fontSize: 30,
                  letterSpacing:
                  0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 80, left: 80, top: 10),
            child: Text(
              '懶蟲們，一起運動吧!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  backgroundColor: Colors.yellow,
                  color: Color(0xff0d3b66),
                  fontSize: 30,
                  letterSpacing:
                  0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          SizedBox(height: 30),
          Container(
            child:
            Image.asset(
              'assets/images/lazy.png', // 相對路徑
              width: 300,
              height: 100,
            ),
          ),
          /*
                child: Image.file(
                  //File imageFile = File('path/to/image.png');
                  File('D:/flutter/assets/images/lazy.png'), // 替換為自己的圖片文件名稱
                  width: 100,
                  height: 100,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Text('Failed to load image: $exception');

                  },
                ),*/

          SizedBox(height: 30),

          Container(
            child: TextButton(
              onPressed: () {
                // 效果
                Navigator.popAndPushNamed(context, '/loginPage');
              },
              child: Container(
                height: 30.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  '登入',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),

          Container(
            child: TextButton(
              onPressed: () {
                // 效果
                Navigator.popAndPushNamed(context, '/signupPage');
              },
              child: Container(
                height: 30.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  '註冊新帳號',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
