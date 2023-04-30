import 'package:flutter/material.dart';

class ForgetpasswordPage extends StatefulWidget {
  const ForgetpasswordPage({Key? key, required this.title}) : super(key: key);
  //const LoginPage({super.key, required this.title});
  final String title;

  @override
  _ForgetpasswordPageState createState() => new _ForgetpasswordPageState();
}

class _ForgetpasswordPageState extends State<ForgetpasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '忘記密碼介面',
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
                  fontSize: 25,
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
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(right:155,top:10),
            child: Text(
              '我的新密碼 ：',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: Colors.yellow,
                  color: Color(0xff0d3b66),
                  fontSize: 25,
                  letterSpacing:
                  0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 50, right: 50, top:20, bottom:0),
            child: TextField(
              decoration: InputDecoration(
                labelText: '輸入新密碼',
                hintText: '請輸入英數6-12位數',
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
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(right:155,top:10),
            child: Text(
              '確認新密碼 ：',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: Colors.yellow,
                  color: Color(0xff0d3b66),
                  fontSize: 25,
                  letterSpacing:
                  0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 50, right: 50, top:20, bottom:0),
            child: TextField(
              decoration: InputDecoration(
                labelText: '確認密碼',
                hintText: '確認密碼',
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

          Container(
            child: IconButton(
              //alignment: Alignment.right,
              padding: EdgeInsets.only(left: 270, right: 10, top:20),
              icon: const Icon(Icons.send),
              iconSize: 30.0,
              color: Color(0xff0d3b66),
              tooltip: "送出",
              onPressed: () {},
            ),
          ),

        ],
      ),
    );
  }
}