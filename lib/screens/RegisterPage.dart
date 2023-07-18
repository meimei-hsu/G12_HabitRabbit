import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:g12/services/Authentication.dart';
import 'package:g12/services/PlanAlgo.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class RegisterPage extends StatefulWidget {
  final bool isLoginPage;

  const RegisterPage({Key? key, required this.isLoginPage}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

// TODO: 將各頁面改為 class 並加入路徑(參考小戴做的頁面)
class _RegisterPageState extends State<RegisterPage> {
  late bool isLoginPage;
  bool isProcessing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  //_RegisterPageState({required this.title, required this.isLoginPage})
  void initState() {
    super.initState();
    isLoginPage = widget.isLoginPage; //初始化
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA493),
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _buildLoginForm(context),
                      ),
                    );
                  },
                  child: const Text(
                    "登入",
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA493),
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
                  child: const Text(
                    "註冊新帳號",
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildLoginForm(BuildContext context) {
    //登錄
    // TODO: 記住帳號密碼
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        actions: const [],
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
            child: const Text(
              '我的帳號',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: Color(0xfffaf0ca),
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
                prefixIcon: const Icon(
                  Icons.account_circle,
                  color: Color(0xff0d3b66),
                ),
                //labelText: '帳號',
                hintText: '請輸入電子信箱',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff0d3b66),
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFFFA493),
                    width: 3,
                  ),
                ),
                //labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
              ),
              cursorColor: const Color(0xFFFFA493),
              style: const TextStyle(fontSize: 20),
              keyboardType: TextInputType.text,
              obscureText: false,
              //controller: _controller,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: const Text(
              '我的密碼',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: Color(0xfffaf0ca),
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
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Color(0xff0d3b66),
                ),
                //labelText: '密碼',
                hintText: '請輸入密碼',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff0d3b66),
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFFFA493),
                    width: 3,
                  ),
                ),
                //labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
              ),
              cursorColor: const Color(0xFFFFA493),
              style: const TextStyle(fontSize: 20),
              keyboardType: TextInputType.text,
              obscureText: true,
              //controller: _controller,
            ),
          ),
          const SizedBox(height: 30),
          isProcessing
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA493),
                  ),
                  onPressed: () async {
                    setState(() {
                      isProcessing = true;
                    });

                    String email = _accountController.text;
                    String password = _passwordController.text;
                    print("$email : $password");

                    String errMsg = "";
                    errMsg += Validator.validateEmail(email) ?? "";
                    errMsg += Validator.validatePassword(password) ?? "";

                    if (errMsg.isEmpty) {
                      try {
                        User? user = await FireAuth.signIn(
                          email: email,
                          password: password,
                        );

                        if (user != null) {
                          await PlanAlgo.execute();
                          if (!mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (Route<dynamic> route) => false);
                        }
                      } catch (e) {
                        errMsg = "$e";
                      }
                    }

                    if (errMsg.isNotEmpty) {
                      if (!mounted) return;
                      MotionToast(
                        icon: Icons.done_all_rounded,
                        primaryColor: const Color(0xffffa493),
                        description: Text(
                          errMsg,
                          style: const TextStyle(
                            color: Color(0xff0d3b66),
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                        position: MotionToastPosition.bottom,
                        animationType: AnimationType.fromBottom,
                        animationCurve: Curves.bounceIn,
                        //displaySideBar: false,
                      ).show(context);
                    }

                    setState(() {
                      isProcessing = false;
                    });
                  },
                  child: const Text(
                    "登入",
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        actions: const [],
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
            child: const Text(
              '我的暱稱',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: Color(0xfffaf0ca),
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
                prefixIcon: const Icon(
                  Icons.abc_rounded,
                  color: Color(0xff0d3b66),
                ),
                //labelText: '帳號',
                hintText: '請輸入名字',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff0d3b66),
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFFFA493),
                    width: 3,
                  ),
                ),
                //labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
              ),
              cursorColor: const Color(0xFFFFA493),
              style: const TextStyle(fontSize: 20),
              keyboardType: TextInputType.text,
              obscureText: false,
              //controller: _controller,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Text(
              '我的帳號',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: Color(0xfffaf0ca),
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
                prefixIcon: const Icon(
                  Icons.account_circle,
                  color: Color(0xff0d3b66),
                ),
                //labelText: '帳號',
                hintText: '請輸入電子信箱',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff0d3b66),
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFFFA493),
                    width: 3,
                  ),
                ),
                //labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
              ),
              cursorColor: const Color(0xFFFFA493),
              style: const TextStyle(fontSize: 20),
              keyboardType: TextInputType.text,
              obscureText: false,
              //controller: _controller,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: const Text(
              '我的密碼',
              textAlign: TextAlign.left,
              style: TextStyle(
                  backgroundColor: Color(0xfffaf0ca),
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
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Color(0xff0d3b66),
                ),
                //labelText: '密碼',
                hintText: '請輸入密碼 (至少六位字元)',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff0d3b66),
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFFFA493),
                    width: 3,
                  ),
                ),
                //labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
              ),
              cursorColor: const Color(0xFFFFA493),
              style: const TextStyle(fontSize: 20),
              keyboardType: TextInputType.text,
              obscureText: true,
              //controller: _controller,
            ),
          ),
          const SizedBox(height: 30),
          isProcessing
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA493),
                  ),
                  onPressed: () async {
                    setState(() {
                      isProcessing = true;
                    });

                    String name = _nameController.text;
                    String email = _accountController.text;
                    String password = _passwordController.text;
                    print("$email : $password");

                    String errMsg = "";
                    errMsg += Validator.validateName(name) ?? "";
                    errMsg += Validator.validateEmail(email) ?? "";
                    errMsg += Validator.validatePassword(password) ?? "";

                    if (errMsg.isEmpty) {
                      try {
                        User? user = await FireAuth.register(
                          name: name,
                          email: email,
                          password: password,
                        );

                        if (user != null) {
                          if (!mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/questionnaire',
                              (Route<dynamic> route) => false,
                              arguments: {"part": 0});
                        }
                      } catch (e) {
                        errMsg = "$e";
                      }
                    }

                    if (errMsg.isNotEmpty) {
                      if (!mounted) return;
                      MotionToast(
                        icon: Icons.done_all_rounded,
                        primaryColor: const Color(0xffffa493),
                        description: Text(
                          errMsg,
                          style: const TextStyle(
                            color: Color(0xff0d3b66),
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                        position: MotionToastPosition.bottom,
                        animationType: AnimationType.fromBottom,
                        animationCurve: Curves.bounceIn,
                        //displaySideBar: false,
                      ).show(context);
                    }

                    setState(() {
                      isProcessing = false;
                    });
                  },
                  child: const Text(
                    "註冊",
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
