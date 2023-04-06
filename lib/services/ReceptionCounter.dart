
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'UserDB.dart';

void main() async {
  // Avoid errors
  WidgetsFlutterBinding.ensureInitialized();

  // Init
  Survey survey = Survey();
  var m = ['mary@gmail.com', 'mmm', 'Mary', 'Female', DateTime.utc(2001, 1, 1).toString(),
    1, -1, 2, 165, 50, 45, '1010101', 40, 60, 40, 70, 50, 40,];
  User mary = survey.toUser(m);
  var j = ['john@gmail.com', 'jjj', 'John', 'Male', DateTime.utc(2008, 8, 8).toString(),
    -1, 1, 3, 178, 82, 30, '1011011', 60, 40, 60, 60, 40, 50,];
  User john = survey.toUser(j);

  // Main work
  await Authentication.register(mary);
  await Authentication.register(john);
  print('Register:\n ${await UserDB.getUserList()}');

  await UserDB.updateUser(mary..setData({'weight': 48}));
  await UserDB.deleteUser(john.email);
  print('Update:\n ${await UserDB.getUserList()}');

  print('Mary login: ${await Authentication.login('mary@gmail.com', 'mmm')}');
}

class Authentication {
  // Base64 code translator
  static final Codec<String, String> strToBase64 = utf8.fuse(base64);

  static String encode(String str) {
    return strToBase64.encode(str);
  }

  static Future<bool> register(User usr) async {
    return await UserDB.insertUser(usr);
  }

  static Future<bool> login(String email, String password) async {
    email = email.contains('@') ? email : '$email@gmail.com';
    return (encode(password) == await UserDB.getPassword(email));
  }
}

class Survey {
  // Survey results to list
  List toList() {
    return [];
  }

  User toUser(List ls) {
    // Match the results into a map by the column of UserDB
    Map map = Map.fromIterables(UserDB.getColumns(), ls);
    // return User class
    return User(
      email: map["email"],
      password: Authentication.encode(map["password"]),
      userName: map["userName"],
      gender: map["gender"],
      birthday: map["birthday"],
      neuroticism: map["neuroticism"],
      conscientiousness: map["conscientiousness"],
      openness: map["openness"],
      height: map["height"],
      weight: map["weight"],
      timeSpan: map["timeSpan"],
      workoutDays: map["workoutDays"],
      strengthLiking: map["strengthLiking"],
      cardioLiking: map["cardioLiking"],
      yogaLiking: map["yogaLiking"],
      strengthAbility: map["strengthAbility"],
      cardioAbility: map["cardioAbility"],
      yogaAbility: map["yogaAbility"],
    );
  }
}
