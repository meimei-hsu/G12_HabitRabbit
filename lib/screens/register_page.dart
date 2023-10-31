import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:g12/screens/page_material.dart';

import 'package:g12/services/authentication.dart';
import 'package:g12/services/page_data.dart';
import 'package:g12/services/plan_algo.dart';

OutlineInputBorder enabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(20),
  borderSide: const BorderSide(
    color: ColorSet.borderColor,
    width: 3,
  ),
);

OutlineInputBorder focusedAndErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(20),
  borderSide: const BorderSide(
    color: ColorSet.errorColor,
    width: 3,
  ),
);

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignupForm(toggleView: toggleView);
    } else {
      return LoginForm(
        toggleView: toggleView,
      );
    }
  }
}

class LoginForm extends StatefulWidget {
  final Function toggleView;

  const LoginForm({super.key, required this.toggleView});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  bool isProcessing = false;
  bool isPasswordVisible = false;

  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorSet.backgroundColor,
        body: SafeArea(
            child: Column(
          children: [
            const SizedBox(height: 50,),
            // TODO: 調整 flex (根據背景圖?)
            Expanded(
              flex: 1,
              child: Image.asset(
                "assets/images/Logo.png",
                width: double.infinity,
                //fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  //physics: const NeverScrollableScrollPhysics(),
                  // Disable scrolling
                  child: Form(
                    key: loginFormKey,
                    child: Container(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, top: 50, bottom: 110),
                      decoration: BoxDecoration(
                          color: ColorSet.backgroundColor,
                          border: Border.all(color: ColorSet.backgroundColor),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Column(
                        children: [
                          // TODO: 標題內容 or 藝術字
                          const Text("Habit Rabbit",
                              style: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  height: 1)),
                          const SizedBox(height: 5),
                          const Text("習慣兔，你的專屬習慣tool！",
                              style: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  height: 1)),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _accountController,
                            validator: Validator.validateEmail,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: const Icon(
                                Icons.account_circle,
                                color: ColorSet.iconColor,
                              ),
                              //errorText: '',
                              labelText: '帳號',
                              hintText: '請輸入電子郵件地址',
                              enabledBorder: enabledBorder,
                              errorBorder: focusedAndErrorBorder,
                              focusedBorder: focusedAndErrorBorder,
                              focusedErrorBorder: focusedAndErrorBorder,
                              labelStyle:
                                  const TextStyle(color: ColorSet.textColor),
                              hintStyle: const TextStyle(color: ColorSet.hintColor),
                              errorStyle: const TextStyle(
                                  height: 1,
                                  color: ColorSet.errorColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              errorMaxLines: 1,
                              filled: true,
                              fillColor: ColorSet.backgroundColor,
                            ),
                            cursorColor: ColorSet.errorColor,
                            style: const TextStyle(
                              fontSize: 18,
                              color: ColorSet.textColor,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            validator: Validator.validatePassword,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: const Icon(
                                Icons.lock_rounded,
                                color: ColorSet.iconColor,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  isPasswordVisible
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: ColorSet.iconColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                              //errorText: '',
                              labelText: '密碼',
                              hintText: '至少 6 位數字',
                              enabledBorder: enabledBorder,
                              errorBorder: focusedAndErrorBorder,
                              focusedBorder: focusedAndErrorBorder,
                              focusedErrorBorder: focusedAndErrorBorder,
                              labelStyle:
                                  const TextStyle(color: ColorSet.textColor),
                              hintStyle: const TextStyle(color: ColorSet.hintColor,),
                              errorStyle: const TextStyle(
                                  height: 1,
                                  color: ColorSet.errorColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              errorMaxLines: 1,
                              filled: true,
                              fillColor: ColorSet.backgroundColor,
                            ),
                            cursorColor: ColorSet.errorColor,
                            style: const TextStyle(
                                fontSize: 18, color: ColorSet.textColor),
                            keyboardType: TextInputType.text,
                            obscureText: !isPasswordVisible,
                          ),
                          const SizedBox(height: 30),
                          isProcessing
                              ? Center(
                                  child: LoadingAnimationWidget
                                      .horizontalRotatingDots(
                                  color: ColorSet.bottomBarColor,
                                  size: 100,
                                ))
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: ColorSet.buttonColor,
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    loginFormKey.currentState?.save();
                                    setState(() {
                                      isProcessing = true;
                                    });

                                    String email = _accountController.text;
                                    String password = _passwordController.text;
                                    debugPrint("$email : $password");

                                    String errMsg = "";
                                    User? user;

                                    if (loginFormKey.currentState!.validate()) {
                                      try {
                                        user = await FireAuth.signIn(
                                          email: email,
                                          password: password,
                                        );
                                      } catch (e) {
                                        errMsg = "$e";
                                      }
                                    }

                                    if (errMsg.isNotEmpty) {
                                      if (!mounted) return;
                                      InformDialog()
                                          .get(context, ":(", errMsg)
                                          .show();
                                    } else {
                                      if (user != null) {
                                        await Data.init();
                                        await PlanAlgo.execute();
                                        if (!mounted) return;
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/',
                                                (Route<dynamic> route) => false);
                                      }
                                    }

                                    setState(() {
                                      isProcessing = false;
                                    });
                                  },
                                  child: const Text(
                                    "登入",
                                    style: TextStyle(
                                      color: ColorSet.textColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "還沒有帳號？ ",
                                style: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 18,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.toggleView();
                                },
                                child: const Text(
                                  '註冊',
                                  style: TextStyle(
                                      color: ColorSet.buttonColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ))));
  }
}

class SignupForm extends StatefulWidget {
  final Function toggleView;

  const SignupForm({super.key, required this.toggleView});

  @override
  SignupFormState createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  bool isProcessing = false;
  bool isPasswordVisible = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorSet.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50,),
              // TODO: 調整 flex (根據背景圖?)
              Expanded(
                flex: 1,
                child: Image.asset(
                  "assets/images/Logo.png",
                  width: double.infinity,
                  //fit: BoxFit.fitWidth,
                ),
              ),
              Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                      //physics: const NeverScrollableScrollPhysics(),
                      // Disable scrolling
                      child: Form(
                          key: signupFormKey,
                          child: Container(
                              padding: const EdgeInsets.only(
                                  right: 20, left: 20, top: 50, bottom: 70),
                              decoration: BoxDecoration(
                                  color: ColorSet.backgroundColor,
                                  border: Border.all(
                                      color: ColorSet.backgroundColor),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              child: Column(
                                children: [
                                  // TODO: 標題內容 or 藝術字
                                  const Text("一起",
                                      style: TextStyle(
                                          color: ColorSet.textColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          height: 1)),
                                  const SizedBox(height: 5),
                                  const Text("養成習慣吧！",
                                      style: TextStyle(
                                          color: ColorSet.textColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          height: 1)),
                                  const SizedBox(height: 30),
                                  TextFormField(
                                    controller: _nameController,
                                    validator: Validator.validateName,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      prefixIcon: const Icon(
                                        Icons.abc_rounded,
                                        color: ColorSet.iconColor,
                                      ),
                                      labelText: '暱稱',
                                      hintText: '請輸入暱稱',
                                      //errorText: '',
                                      enabledBorder: enabledBorder,
                                      errorBorder: focusedAndErrorBorder,
                                      focusedBorder: focusedAndErrorBorder,
                                      focusedErrorBorder: focusedAndErrorBorder,
                                      labelStyle: const TextStyle(
                                          color: ColorSet.textColor),
                                      hintStyle:
                                          const TextStyle(color: ColorSet.hintColor),
                                      errorStyle: const TextStyle(
                                          height: 1,
                                          color: ColorSet.errorColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      errorMaxLines: 1,
                                      filled: true,
                                      fillColor: ColorSet.backgroundColor,
                                    ),
                                    cursorColor: ColorSet.errorColor,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: ColorSet.textColor),
                                    keyboardType: TextInputType.text,
                                    obscureText: false,
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _accountController,
                                    validator: Validator.validateEmail,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      prefixIcon: const Icon(
                                        Icons.account_circle,
                                        color: ColorSet.iconColor,
                                      ),
                                      labelText: '帳號',
                                      hintText: '請輸入電子郵件地址',
                                      //errorText: '',
                                      enabledBorder: enabledBorder,
                                      errorBorder: focusedAndErrorBorder,
                                      focusedBorder: focusedAndErrorBorder,
                                      focusedErrorBorder: focusedAndErrorBorder,
                                      labelStyle: const TextStyle(
                                          color: ColorSet.textColor),
                                      hintStyle:
                                          const TextStyle(color: ColorSet.hintColor,),
                                      errorStyle: const TextStyle(
                                          height: 1,
                                          color: ColorSet.errorColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      errorMaxLines: 1,
                                      filled: true,
                                      fillColor: ColorSet.backgroundColor,
                                    ),
                                    cursorColor: ColorSet.errorColor,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: ColorSet.textColor),
                                    keyboardType: TextInputType.text,
                                    obscureText: false,
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _passwordController,
                                    validator: Validator.validatePassword,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: ColorSet.iconColor,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          isPasswordVisible
                                              ? Icons.visibility_rounded
                                              : Icons.visibility_off_rounded,
                                          color: ColorSet.iconColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isPasswordVisible =
                                                !isPasswordVisible;
                                          });
                                        },
                                      ),
                                      labelText: '密碼',
                                      hintText: '至少 6 位數字或英文',
                                      //errorText: '',
                                      enabledBorder: enabledBorder,
                                      errorBorder: focusedAndErrorBorder,
                                      focusedBorder: focusedAndErrorBorder,
                                      focusedErrorBorder: focusedAndErrorBorder,
                                      labelStyle: const TextStyle(
                                          color: ColorSet.textColor),
                                      hintStyle:
                                          const TextStyle(color: ColorSet.hintColor,),
                                      errorStyle: const TextStyle(
                                          height: 1,
                                          color: ColorSet.errorColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      errorMaxLines: 1,
                                      filled: true,
                                      fillColor: ColorSet.backgroundColor,
                                    ),
                                    cursorColor: const Color(0xfff6cdb7),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: ColorSet.textColor),
                                    keyboardType: TextInputType.text,
                                    obscureText: !isPasswordVisible,
                                  ),
                                  const SizedBox(height: 30),
                                  isProcessing
                                      ? Center(
                                          child: LoadingAnimationWidget
                                              .horizontalRotatingDots(
                                          color: ColorSet.bottomBarColor,
                                          size: 100,
                                        ))
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:
                                            ColorSet.buttonColor,
                                            minimumSize:
                                                const Size.fromHeight(50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () async {
                                            signupFormKey.currentState?.save();
                                            setState(() {
                                              isProcessing = true;
                                            });

                                            String name = _nameController.text;
                                            String email =
                                                _accountController.text;
                                            String password =
                                                _passwordController.text;

                                            String errMsg = "";

                                            if (signupFormKey.currentState!
                                                .validate()) {
                                              try {
                                                User? user =
                                                    await FireAuth.register(
                                                  name: name,
                                                  email: email,
                                                  password: password,
                                                );

                                                if (user != null) {
                                                  if (!mounted) return;
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          '/questionnaire',
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false,
                                                          arguments: {
                                                        "part": 0
                                                      });
                                                }
                                              } catch (e) {
                                                errMsg = "$e";
                                              }
                                            }

                                            if (errMsg.isNotEmpty) {
                                              if (!mounted) return;
                                              InformDialog()
                                                  .get(context, ":(", errMsg)
                                                  .show();
                                            }

                                            setState(() {
                                              isProcessing = false;
                                            });
                                          },
                                          child: const Text(
                                            "註冊",
                                            style: TextStyle(
                                              color: ColorSet.textColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Text(
                                        "已經有帳號嗎？ ",
                                        style: TextStyle(
                                          color: ColorSet.textColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          widget.toggleView();
                                        },
                                        child: const Text(
                                          '登入',
                                          style: TextStyle(
                                              color: ColorSet.buttonColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ))))),
            ],
          ),
        )));
  }
}
