import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:g12/screens/Homepage.dart';
import 'package:g12/services/Authentication.dart';
import 'package:g12/services/PlanAlgo.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.isLoginPage})
      : super(key: key);

  //const LoginPage({super.key, required this.title});
  final bool isLoginPage;

  @override
  _RegisterPage createState() => _RegisterPage(this.isLoginPage);
}

// TODO: 將各頁面改為 class 並加入路徑(參考小戴做的頁面)
class _RegisterPage extends State<RegisterPage> {
  late bool isLoginPage;

  //late _RegisterPage loginPage; // 定義變量
  //late _RegisterPage signupPage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  _RegisterPage(this.isLoginPage); // 定義變量

  @override
  //_RegisterPageState({required this.title, required this.isLoginPage})
  void initState() {
    super.initState();
    isLoginPage = widget.isLoginPage; //初始化
    // 初始化變量
    //loginPage = _RegisterPageState('Login', true);
    //signupPage = _RegisterPageState('Signup', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfffaf0ca),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              // Logo
              'assets/images/Logo.jpg', // 相對路徑
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text(
                    "登入",
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFA493),
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _buildLoginForm(context),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  child: Text(
                    "註冊新帳號",
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFA493),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //builder: (context) => RegisterPage(title: 'Signup', isLoginPage: false),
                        builder: (context) => _buildRegisterForm(context),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildLoginForm(BuildContext context) {
    //登錄
    //var _accountController;
    return Scaffold(
      backgroundColor: const Color(0xfffaf0ca),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          '登入',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color(0xff0d3b66),
              fontSize: 35,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        actions: [],
        //Text(widget.title, style: TextStyle(color: Color(0xff0d3b66))),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, //關掉返回鍵
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /*
          const SizedBox(height: 50),
          Image.asset(
            // Logo
            'images/Logo.jpg', // 相對路徑
          ),*/
          const SizedBox(height: 50),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '我的帳號',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: const Color(0xfffaf0ca),
                  color: Color(0xff0d3b66),
                  fontSize: 25,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _accountController,
              decoration: InputDecoration(
                isDense: true,
                // TODO: Let the icon change color when being selected
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: Color(0xff0d3b66),
                ),
                //labelText: '帳號',
                hintText: '請輸入帳號',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xff0d3b66),
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xFFFFA493),
                    width: 3,
                  ),
                ),
                //labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
              ),
              cursorColor: Color(0xFFFFA493),
              style: TextStyle(fontSize: 20),
              keyboardType: TextInputType.text,
              obscureText: false,
              //controller: _controller,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              '我的密碼',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: const Color(0xfffaf0ca),
                  color: Color(0xff0d3b66),
                  fontSize: 25,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color(0xff0d3b66),
                ),
                //labelText: '密碼',
                hintText: '請輸入密碼',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xff0d3b66),
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xFFFFA493),
                    width: 3,
                  ),
                ),
                //labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
              ),
              cursorColor: Color(0xFFFFA493),
              style: TextStyle(fontSize: 20),
              keyboardType: TextInputType.text,
              obscureText: true,
              //controller: _controller,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(
                  "忘記密碼",
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFA493),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _buildForgetPasswordForm(context),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                child: Text(
                  "登入",
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFA493),
                ),
                onPressed: () async {
                  // 存储用戶輸入的帳號和密碼
                  print(
                      "${_accountController.text} : ${_passwordController.text}");

                  User? user = await FireAuth.signIn(
                    email: _accountController.text,
                    password: _passwordController.text,
                  );

                  if (user != null) {
                    await PlanAlgo.execute(user.uid);
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (Route<dynamic> route) => false,
                        arguments: {'user': user});
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    //登錄
    //var _accountController;
    return Scaffold(
      backgroundColor: const Color(0xfffaf0ca),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          '註冊',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color(0xff0d3b66),
              fontSize: 35,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        actions: [],
        //Text(widget.title, style: TextStyle(color: Color(0xff0d3b66))),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, //關掉返回鍵
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /*
          const SizedBox(height: 50),
          Image.asset(
            // Logo
            'images/Logo.jpg', // 相對路徑
          ),*/
          const SizedBox(height: 50),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '我的暱稱',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: const Color(0xfffaf0ca),
                  color: Color(0xff0d3b66),
                  fontSize: 25,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: Icon(
                  Icons.abc_rounded,
                  color: Color(0xff0d3b66),
                ),
                //labelText: '帳號',
                hintText: '請輸入名字',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xff0d3b66),
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xFFFFA493),
                    width: 3,
                  ),
                ),
                //labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
              ),
              cursorColor: Color(0xFFFFA493),
              style: TextStyle(fontSize: 20),
              keyboardType: TextInputType.text,
              obscureText: false,
              //controller: _controller,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '我的帳號',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: const Color(0xfffaf0ca),
                  color: Color(0xff0d3b66),
                  fontSize: 25,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _accountController,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: Color(0xff0d3b66),
                ),
                //labelText: '帳號',
                hintText: '請輸入帳號',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xff0d3b66),
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xFFFFA493),
                    width: 3,
                  ),
                ),
                //labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
              ),
              cursorColor: Color(0xFFFFA493),
              style: TextStyle(fontSize: 20),
              keyboardType: TextInputType.text,
              obscureText: false,
              //controller: _controller,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              '我的密碼',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: const Color(0xfffaf0ca),
                  color: Color(0xff0d3b66),
                  fontSize: 25,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color(0xff0d3b66),
                ),
                //labelText: '密碼',
                hintText: '請輸入密碼',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xff0d3b66),
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xFFFFA493),
                    width: 3,
                  ),
                ),
                //labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
              ),
              cursorColor: Color(0xFFFFA493),
              style: TextStyle(fontSize: 20),
              keyboardType: TextInputType.text,
              obscureText: true,
              //controller: _controller,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(
                  "我要登入",
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFA493),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _buildLoginForm(context),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                child: Text(
                  "註冊",
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFA493),
                ),
                onPressed: () async {
                  // 存储用戶輸入的帳號和密碼
                  print(
                      "${_accountController.text} : ${_passwordController.text}");

                  User? user = await FireAuth.register(
                    name: _nameController.text,
                    email: _accountController.text,
                    password: _passwordController.text,
                  );

                  if (user != null) {
                    await PlanAlgo.execute(user.uid);

                    // FIXME: CANNOT navigate to QuestionnairePage! I'm not sure whether it's related to register process...
                    // I tried the same code in the other page and it was able to work.
                    // ref: https://stackoverflow.com/questions/64255643/navigation-doesnt-work-from-signup-to-home-flutter
                    // ref: https://stackoverflow.com/questions/65543267/unable-to-navigate-to-homepage-after-register-with-firebase-flutter
                    Navigator.pushNamedAndRemoveUntil(context, '/questionnaire/1', (Route<dynamic> route) => false, arguments: {'user': user});
                    /*Navigator.popAndPushNamed(context, '/questionnaire/1',
                        arguments: {'user': user});*/
                    /*Navigator.pushNamed(context, '/questionnaire/1',
                        arguments: {'user': user});*/
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForgetPasswordForm(BuildContext context) {
    //登錄
    //var _accountController;
    List userData = [];
    return Scaffold(
      backgroundColor: const Color(0xfffaf0ca),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          '忘記密碼',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color(0xff0d3b66),
              fontSize: 35,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        actions: [],
        //Text(widget.title, style: TextStyle(color: Color(0xff0d3b66))),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, //關掉返回鍵
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /*
          const SizedBox(height: 50),
          Image.asset(
            // Logo
            'images/Logo.jpg', // 相對路徑
          ),*/
          const SizedBox(height: 50),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '我的帳號',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: const Color(0xfffaf0ca),
                  color: Color(0xff0d3b66),
                  fontSize: 25,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _accountController,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: Color(0xff0d3b66),
                ),
                //labelText: '帳號',
                hintText: '請輸入帳號',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xff0d3b66),
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xFFFFA493),
                    width: 3,
                  ),
                ),
                //labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
              ),
              cursorColor: Color(0xFFFFA493),
              style: TextStyle(fontSize: 20),
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
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              '我的新密碼',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: const Color(0xfffaf0ca),
                  color: Color(0xff0d3b66),
                  fontSize: 25,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color(0xff0d3b66),
                ),
                //labelText: '新密碼',
                hintText: '請輸入英數 6-12 位數',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xff0d3b66),
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xFFFFA493),
                    width: 3,
                  ),
                ),
                //labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
              ),
              cursorColor: Color(0xFFFFA493),
              style: TextStyle(fontSize: 20),
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
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              '確認新密碼',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: const Color(0xfffaf0ca),
                  color: Color(0xff0d3b66),
                  fontSize: 25,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color(0xff0d3b66),
                ),
                //labelText: '新密碼',
                hintText: '請確認新密碼',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xff0d3b66),
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xFFFFA493),
                    width: 3,
                  ),
                ),
                //labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
              ),
              cursorColor: Color(0xFFFFA493),
              style: TextStyle(fontSize: 20),
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
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              ElevatedButton(
                child: Text(
                  "重設密碼",
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFA493),
                ),
                onPressed: () {
                  // 存儲用戶輸入的帳號和密碼
                  userData.add(_accountController.text);
                  userData.add(_passwordController.text);
                  userData.add(_passwordConfirmController.text);
                  print(userData);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _buildLoginForm(context),
                    ),
                  );
                  //Navigator.popAndPushNamed(context, '/register');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
