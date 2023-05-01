import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

class LoginsignupPage extends StatefulWidget {
  const LoginsignupPage({Key? key, required this.title, required this.isLoginPage}) : super(key: key);
  //const LoginPage({super.key, required this.title});
  final String title;
  final bool isLoginPage;

  @override
  _LoginsignupPage createState() => _LoginsignupPage(this.title,this.isLoginPage);
}

class _LoginsignupPage extends State<LoginsignupPage> {
  late bool isLoginPage;
  //late _LoginsignupPage loginPage; // 定義變量
  //late _LoginsignupPage signupPage;
  late String title;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  _LoginsignupPage(String title, bool isLoginPage) {
    this.title = title;
    this.isLoginPage = isLoginPage;
  } // 定義變量
  @override
  //_LoginsignupPageState({required this.title, required this.isLoginPage})
  void initState() {
    super.initState();
    isLoginPage = widget.isLoginPage; //初始化
    // 初始化變量
    //loginPage = _LoginsignupPageState('Login', true);
    //signupPage = _LoginsignupPageState('Signup', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          isLoginPage ? 'Login' : 'Sighup',
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

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            isLoginPage ? _buildLoginForm(context) : _buildRegisterForm(
                context),
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
              padding: EdgeInsets.only(right: 80, left: 80, top: 150),
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
              padding: EdgeInsets.only(right: 80, left: 80, top: 100),
              child:
              Image.asset(
                'assets/images/lazy.png', // 相對路徑
                width: 700,
                height: 400,
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
              padding: EdgeInsets.only(right: 80, left: 80, top: 500),
              child: TextButton(
                onPressed: () {
                  // 效果
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _buildLoginForm(context),
                    ),
                  );
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
              padding: EdgeInsets.only(right: 80, left: 80, top: 350),
              child: TextButton(
                onPressed: () {
                  // 效果
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //builder: (context) => LoginsignupPage(title: 'Signup', isLoginPage: false),
                      builder: (context) =>
                          _buildRegisterForm(context),
                    ),
                  );
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
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    //登錄
    //var _accountController;
    List<String> userData = [];
    return Scaffold(
        backgroundColor: Colors.yellow,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '登入介面',
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
          //child: isLoginPage ? _buildLoginForm() : _buildRegisterForm(),
            children: [
              Container(
                padding: EdgeInsets.only(right: 155, top: 80),
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
                padding: EdgeInsets.only(
                    left: 50, right: 50, top: 20, bottom: 10),
                child: TextField(
                  controller: _accountController,
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
                padding: EdgeInsets.only(right: 155, top: 10),
                child: Text(
                  '我的密碼 ：',
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
                padding: EdgeInsets.only(
                    left: 50, right: 50, top: 20, bottom: 0),
                child: TextField(
                  controller: _passwordController,
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
                  obscureText: true,
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
                height: 50.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          // 效果
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  _buildForgetPasswordForm(context),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            '忘记密码',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: IconButton(
                        //alignment: Alignment.right,
                        //padding: EdgeInsets.only(left: 300, right: 10),
                        icon: const Icon(Icons.send),
                        iconSize: 30.0,
                        color: Color(0xff0d3b66),
                        tooltip: "送出",
                        onPressed: () {
                          // 存储用戶輸入的帳號和密碼
                          userData.add(_accountController.text);
                          userData.add(_passwordController.text);
                          print(userData);
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ]
        )
    );
  }


  Widget _buildRegisterForm(BuildContext context) {
    //註冊
    List<String> userData = [];
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
                padding: EdgeInsets.only(right: 155, top: 80),
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
                padding: EdgeInsets.only(
                    left: 50, right: 50, top: 20, bottom: 10),
                child: TextField(
                  controller: _accountController,
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
                padding: EdgeInsets.only(right: 155, top: 10),
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
                padding: EdgeInsets.only(
                    left: 50, right: 50, top: 20, bottom: 10),
                child: TextField(
                  controller: _passwordController,
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
                  obscureText: true,
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
                height: 50.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          // 效果
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  _buildLoginForm(context),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            '我要登入',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: IconButton(
                        //alignment: Alignment.right,
                        //padding: EdgeInsets.only(left: 300, right: 10),
                        icon: const Icon(Icons.send),
                        iconSize: 30.0,
                        color: Color(0xff0d3b66),
                        tooltip: "送出",
                        onPressed: () {
                          // 存储用戶輸入的帳號和密碼
                          userData.add(_accountController.text);
                          userData.add(_passwordController.text);
                          print(userData);
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ]
        )
    );
  }

  Widget _buildForgetPasswordForm(BuildContext context) {
    List<String> userData = [];
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
              controller: _accountController,
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
              controller: _passwordController,
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
              obscureText: true,
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
              controller: _passwordConfirmController,
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
              obscureText: true,
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
              onPressed: () {
                // 存储用戶輸入的帳號和密碼
                userData.add(_accountController.text);
                userData.add(_passwordController.text);
                userData.add(_passwordConfirmController.text);
                print(userData);
              },
            ),
          ),

        ],
      ),
    );
  }
}