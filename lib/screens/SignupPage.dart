import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key, required this.title}) : super(key: key);
  //const LoginPage({super.key, required this.title});
  final String title;

  @override
  _SignupPageState createState() => new _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '註冊介面',
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
            padding: EdgeInsets.only(right:155,top:80),
            child: Text(
              '我的帳號 ：',
              textAlign: TextAlign.left,
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
            padding: EdgeInsets.only(left: 50, right: 50, top:20, bottom:10),
            child: TextField(
              decoration: InputDecoration(
                labelText: '輸入帳號',
                hintText: '請輸入帳號',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              keyboardType: TextInputType.text,
              obscureText: false,
              //controller: _controller,
              onChanged: (value) {
                print(value);
              },
              onSubmitted: (value) {
                print('Submitted: $value');
              },
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.only(right:155,top:10),
            child: Text(
              '我的密碼 ：',
              textAlign: TextAlign.left,
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
            padding: EdgeInsets.only(left: 50, right: 50, top:20, bottom:10),
            child: TextField(
              decoration: InputDecoration(
                labelText: '輸入密碼',
                hintText: '請輸入密碼',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              keyboardType: TextInputType.text,
              obscureText: false,
              //controller: _controller,
              onChanged: (value) {
                //print(value);
              },
              onSubmitted: (value) {
                //print('Submitted: $value');
              },
            ),
          ),
          SizedBox(height: 30),
          Container(
            child: IconButton(
              //alignment: Alignment.right,
              padding: EdgeInsets.only(left: 300, right: 10),
              icon: const Icon(Icons.send),
              iconSize: 40,
              color: Color(0xff0d3b66),
              tooltip: "送出",
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}