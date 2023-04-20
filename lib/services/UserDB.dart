
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'PlanAlgo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ensure initialisation
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: home(),
  ));
}

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var m = ['mary@gmail.com', 'mmm', 'Mary', 'Female', DateTime.utc(2001, 1, 1).toString(),
      1, -1, 2, 165, 50, 45, '1010101', 40, 60, 40, 70, 50, 40,];
    var j = ['john@gmail.com', 'jjj', 'John', 'Male', DateTime.utc(2008, 8, 8).toString(),
      -1, 1, 3, 178, 82, 30, '1011011', 60, 40, 60, 60, 40, 50,];
    Map mary = Map.fromIterables(UserDB.getColumns(), m);
    Map john = Map.fromIterables(UserDB.getColumns(), j);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    UserDB.insert(mary);
                    UserDB.insert(john);
                    UserDB.update("Mary", {"weight": 45});
                    UserDB.getUserList();
                  },
                  child: Text("test DB")),
              TextButton(
                  onPressed: () {
                    Algorithm.execute("Mary");
                  },
                  child: Text("test AG")),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDB {
  // Define the columns of the user table
  static List<String> getColumns() {
    return [
      "email",
      "password",
      "userName",
      "gender",
      "birthday",
      "neuroticism",
      "conscientiousness",
      "openness",
      "height",
      "weight",
      "timeSpan",
      "workoutDays",
      "strengthLiking",
      "cardioLiking",
      "yogaLiking",
      "strengthAbility",
      "cardioAbility",
      "yogaAbility",
    ];
  }

  // Select all users
  static Future<DataSnapshot?> getUserList() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users').get();
    if (snapshot.exists) {
      print(snapshot.value);
      return snapshot;
    } else {
      return null;
    }
  }

  // Select user from ID
  static Future<Map?> getUser(String id) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/$id').get();
    if (snapshot.exists) {
      print(snapshot.value);
      return Map<String, dynamic>.from(snapshot.value! as Map<Object?, Object?>);
    } else {
      return null;
    }
  }

  // Select dynamic data from ID
  static Future<List<Map<String, dynamic>>?> getPlanVariables(String id) async {
    final Map? user = await getUser(id);

    if (user != null) {
      return [
        {
          'neuroticism': user["neuroticism"],
          'conscientiousness': user["conscientiousness"],
          'openness': user["openness"],
          'timeSpan': user["timeSpan"],
        },
        Map.fromIterables(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            user["workoutDays"].split('').map(int.parse).toList()),
        {
          'strengthLiking': user["strengthLiking"],
          'cardioLiking': user["cardioLiking"],
          'yogaLiking': user["yogaLiking"],
        },
        {
          'strengthAbility': user["strengthAbility"],
          'cardioAbility': user["cardioAbility"],
          'yogaAbility': user["yogaAbility"],
        },
      ];
    } else {
      return null;
    }
  }

  // Insert data into Users
  static insert(Map map) async {
    final DatabaseReference ref =
        FirebaseDatabase.instance.ref("users/${map["userName"]}");
    await ref.set(map);
  }

  // Update data (using map) from ID
  static update(String id, Map<String, Object> map) async {
    final DatabaseReference ref =
        FirebaseDatabase.instance.ref("users/$id");
    await ref.update(map);
  }

  // Delete data from ID
  static delete(String id) async {
    final DatabaseReference ref =
        FirebaseDatabase.instance.ref("users/$id");
    await ref.remove();
  }
}