import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:g12/services/CRUD.dart';
import 'package:g12/services/PlanAlgo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ensure initialisation
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var m = [
      'mary@gmail.com',
      'mmm',
      'Mary',
      'Female',
      DateTime.utc(2001, 1, 1).toString(),
      1,
      -1,
      2,
      165,
      50,
      45,
      '1010101',
      40,
      60,
      40,
      70,
      50,
      40,
    ];
    var wallSit = {
      '3101': '高膝行走',
      '3102': '跳躍',
      '3103': '側步',
      '3104': '前進後退',
      '3105': '踏步/踏板',
      '3106': '跨步側跳',
      '3107': '雙腳交替跳',
      '3108': '踏步蹲跳',
      '3109': '踏步抬腳',
      '3110': '龍舞踢腿',
      '3111': '模仿拳擊',
      '3112': '緩步',
      '3201': '快速跳躍/跑步',
      '3202': '踩踏',
      '3203': '穿梭',
      '3204': '側向跳躍',
      '3205': '高抬腿',
      '3206': '半蹲跳',
      '3207': '搖擺',
      '3208': '快速轉身',
      '3209': '快速交叉步',
      '3210': '快速揮臂',
      '3211': '跳躍揮臂',
      '3212': '拍手',
    };
    Map mary = Map.fromIterables(UserDB.getColumns(), m);

    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextButton(
              onPressed: () {
                UserDB.insert(mary);
                UserDB.update("Mary", {"weight": 45});
                UserDB.getUserList();
                WorkoutDB.update(wallSit);
                WorkoutDB.getWorkoutID();
              },
              child: const Text("test DB")),
          TextButton(
              onPressed: () {
                Algorithm.execute("Mary");
                PlanDB.getThisWeekPlan("Mary");
                PlanDB.getHistory("Mary");
                Algorithm.regenerate("Mary");
              },
              child: const Text("test AG")),
        ],
      ),
    ));
  }
}

class Calendar {
  static DateTime today() => DateTime.now();
  static DateTime firstDay() =>
      today().subtract(Duration(days: today().weekday));

  // convert DateTime to String (i.e. plan's key)
  static String toKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  // Get a number {duration} of dates from the given date {firstDay}
  static List<String> getWeekFrom(DateTime firstDay, int duration) {
    DateFormat fmt = DateFormat('yyyy-MM-dd');
    List<String> week = List.generate(duration,
        (index) => fmt.format(firstDay.add(Duration(days: index + 1))));
    return week;
  }

  // Get the days of week that have already passed
  static List<String> daysPassed() =>
      getWeekFrom(firstDay(), today().weekday.toInt());
  // Get the days of week that are yet to come
  static List<String> daysComing() =>
      getWeekFrom(today(), (14 - today().weekday).toInt());
  // Get the days of week from the first day
  static List<String> thisWeek() => getWeekFrom(firstDay(), 7);
  // Get the days of week from the eighth day
  static List<String> nextWeek() =>
      getWeekFrom(firstDay().add(const Duration(days: 7)), 7);
  // Get the days of the following two weeks
  static List<String> bothWeeks() => [...thisWeek(), ...nextWeek()];
}

class UserDB {
  static const table = "users";

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
  static Future<Map?> getUserList() async {
    var snapshot = await DB.selectAll(table);
    return (snapshot?.value) as Map?;
  }

  // Select user from userName
  static Future<Map?> getUser(String id) async {
    return Map<String, dynamic>.from(
        await DB.select(table, id) as Map<Object?, Object?>);
  }

  // Select dynamic data from userName
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
        Map.fromIterables(Calendar.thisWeek(),
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

  // Insert data {columnName: value} into Users
  static Future<bool> insert(Map map) async {
    return await DB.insert(map, table, map["userName"]);
  }

  // Update data {columnName: value} from userName
  static Future<bool> update(String id, Map<String, Object> map) async {
    return await DB.update(map, table, id);
  }

  // Delete data from userName
  static Future<bool> delete(String id) async {
    return await DB.delete(table, id);
  }
}

class PlanDB {
  static const table = "journal";

  // Select all plans
  static Future<Map?> getPlanList(String userID) async {
    Map map = {};
    var snapshot = await DB.selectAll("$table/$userID");
    for (var element in snapshot!.children) {
      if (element.child("plan").exists) {
        map[element.key] = element.child("plan").value;
      }
    }
    print("getPlanList: $map");
    return map;
  }

  // Select the user's plan from the dates of given week
  static Future<Map?> getPlanWhen(String userID, List datesOfWeek) async {
    Map map = {};
    for (String date in datesOfWeek) {
      var plan = await DB.select("$table/$userID/$date", "plan");
      if (plan != null) {
        map[date] = plan;
      }
    }
    return map;
  }

  // Select user's workout plan
  static Future<String?> getTodayPlan(String userID) async {
    String today = Calendar.toKey(DateTime.now());
    return (await getPlanWhen(userID, [today]))![today];
  }

  static Future<Map?> getThisWeekPlan(String userID) async =>
      await getPlanWhen(userID, Calendar.thisWeek());
  static Future<Map?> getNextWeekPlan(String userID) async =>
      await getPlanWhen(userID, Calendar.nextWeek());

  // Select user's workout history
  static Future<Map?> getHistory(String userID) async {
    var daysComing = Calendar.daysComing();
    var records = await getPlanList(userID);
    return records!..removeWhere((k, v) => daysComing.contains(k));
  }

  // Insert plan data {date: plan} into table {table/userID/date/plan}
  static Future<bool> insert(String userID, Map<String, String> map) async {
    for (MapEntry e in map.entries) {
      var success = await DB.insert({"plan": e.value}, "$table/$userID", e.key);
      if (success == false) {
        return false;
      }
    }
    return true;
  }

  // Update plan data {date: plan} from table {table/userID/date/plan}
  static Future<bool> update(String userID, Map map) async {
    for (MapEntry e in map.entries) {
      var success = await DB.update({"plan": e.value}, "$table/$userID", e.key);
      if (success == false) {
        return false;
      }
    }
    return true;
  }

  // Delete plan data {table/userID/date/plan}
  static Future<bool> delete(String userID, String date) async {
    return DB.delete("$table/$userID/$date", "plan");
  }
}

class WorkoutDB {
  static const table = "workouts";

  // Select all workouts
  static Future<List?> getWorkoutList() async {
    var snapshot = await DB.selectAll(table);
    var map = snapshot?.value as Map?;
    return map?.keys.toList();
  }

  // Select workout from workoutId
  static Future<Map?> getWorkout(String workoutId) async {
    return Map<String, dynamic>.from(
        await DB.select(table, workoutId) as Map<Object?, Object?>);
  }

  // Select workoutId from workoutId by type and difficulty
  static Future<Map?> getWorkoutID() async {
    var workouts = await getWorkoutList();

    Map retVal = {
      'strength': [
        List.from(workouts!.where((item) => item[0] == "1" && item[1] == "1")),
        List.from(workouts.where((item) => item[0] == "1" && item[1] == "2")),
        List.from(workouts.where((item) => item[0] == "1" && item[1] == "3")),
        List.from(workouts.where((item) => item[0] == "1" && item[1] == "4")),
        List.from(workouts.where((item) => item[0] == "1" && item[1] == "5")),
      ],
      'cardio': [
        List.from(workouts.where((item) => item[0] == "2" && item[1] == "1")),
        List.from(workouts.where((item) => item[0] == "2" && item[1] == "2")),
      ],
      'yoga': [
        List.from(workouts.where((item) => item[0] == "3" && item[1] == "1")),
        List.from(workouts.where((item) => item[0] == "3" && item[1] == "2")),
        List.from(workouts.where((item) => item[0] == "3" && item[1] == "3")),
        List.from(workouts.where((item) => item[0] == "3" && item[1] == "4")),
        List.from(workouts.where((item) => item[0] == "3" && item[1] == "5")),
      ],
      'warmUp': List.from(workouts.where((item) => item[0] == "4")),
      'coolDown': List.from(workouts.where((item) => item[0] == "5")),
    };

    print("getWorkoutID: $retVal");
    return retVal;
  }

  static Future<bool> insert(Map map) async {
    return await DB.insert(map, table);
  }

  // Update data {columnName: value} from workoutId
  static Future<bool> update(Map<String, Object> map) async {
    return await DB.update(map, table);
  }

  // Delete data from workoutId
  static Future<bool> delete(String workoutID) async {
    return await DB.delete(table, workoutID);
  }
}
