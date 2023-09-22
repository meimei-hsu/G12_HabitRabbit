import 'package:firebase_auth/firebase_auth.dart';

// TODO: 驗證錯誤訊息改為中文
class FireAuth {
  // For registering a new user
  static Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Future.error('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return Future.error('The account already exists for that email.');
      }
    } catch (e) {
      return Future.error(e);
    }

    return user;
  }

  // For signing in an user (have already registered)
  static Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
        return Future.error('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        // print('Wrong password provided.');
        return Future.error('Wrong password provided.');
      }
    } catch (e) {
      return Future.error(e);
    }

    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }
}

class Validator {
  static String? validateName(String? name) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return '\u26A0 暱稱不得為空。';
    }

    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return '\u26A0 電子郵件地址不得為空。';
    } else if (!emailRegExp.hasMatch(email)) {
      return '\u26A0 請輸入有效的電子郵件地址。';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return '\u26A0 密碼不得為空。';
    } else if (password.length < 6) {
      return '\u26A0 這個密碼太短了 (至少 6 位元)。';
    }

    return null;
  }
}
