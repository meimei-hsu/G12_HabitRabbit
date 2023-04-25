import 'dart:async';
import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:g12/services/CRUD.dart';
import 'package:g12/services/PlanAlgo.dart';
import 'package:intl/intl.dart';

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
      //1101: 'Wall Sit',
      '1102': 'Wall Sittt',
      '1103': 'Wall',
      //'strength',
      //1,
    };
    Map mary = Map.fromIterables(UserDB.getColumns(), m);
    //Map wallSit = Map.fromIterables(WorkoutDB.getColumns(), w);



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
                //WorkoutDB.insert(wallSit);
                WorkoutDB.update(wallSit);
                WorkoutDB.getWorkoutIdByTD("strengt", 1);
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
  static DateTime td() => DateTime.now();
  static String today() => DateFormat('yyyy-MM-dd').format(DateTime.now());
  static DateTime firstDay() => td().subtract(Duration(days: td().weekday));

  // Get a number {duration} of dates from the given date {firstDay}
  static List<String> getWeekFrom(DateTime firstDay, int duration) {
    DateFormat fmt = DateFormat('yyyy-MM-dd');
    List<String> week = List.generate(duration,
        (index) => fmt.format(firstDay.add(Duration(days: index + 1))));
    return week;
  }

  // Get the days of week that have already passed
  static List<String> daysPassed() =>
      getWeekFrom(firstDay(), td().weekday.toInt());
  // Get the days of week that are yet to come
  static List<String> daysComing() =>
      getWeekFrom(td(), (14 - td().weekday).toInt());
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
    return await DB.insert(table, map["userName"], map);
  }

  // Update data {columnName: value} from userName
  static Future<bool> update(String id, Map<String, Object> map) async {
    return await DB.update(table, id, map);
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
  static Future<String?> getTodayPlan(String userID) async =>
      (await getPlanWhen(userID, [Calendar.today()]))?[Calendar.today()];
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
      var success = await DB.insert("$table/$userID", e.key, {"plan": e.value});
      if (success == false) {
        return false;
      }
    }
    return true;
  }

  // Update plan data {date: plan} from table {table/userID/date/plan}
  static Future<bool> update(String userID, Map map) async {
    for (MapEntry e in map.entries) {
      var success = await DB.update("$table/$userID", e.key, {"plan": e.value});
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

  // Define the columns of the user table
  /*static List<String> getColumns() {
    return [
      "workoutID",
      "workoutName",
      //"workoutType",
      //"workoutDifficulty",
    ];
  }*/

  // Select all workouts
  static Future<List?> getWorkoutList() async {
    var snapshot = await DB.selectAll(table);
    //return (snapshot?.value) as Map?;
    var map = snapshot?.value as Map?;
    return map?.keys.toList();
  }

  // Select workout from workoutId
  static Future<Map?> getWorkout(String workoutId) async {
    return Map<String, dynamic>.from(
        await DB.select(table, workoutId) as Map<Object?, Object?>);
  }

  // Select workoutId from workoutId by type and difficulty
  static Future<List?> getWorkoutIdByTD(String type, int difficulty) async {
    var workouts = await getWorkoutList();
    var retVal = [];
    if (type == "strength") {
      type = "1";
    }
    for (String w in workouts!) {
      if (w[0] == type) {
        retVal.add(w);
      }
    }
    print("getWorkoutID: $retVal");
    return retVal;
  }


  // Insert data {columnName: value} into workout
  /*static Future<bool> insert(Map map) async {
    return await DB.insert(table, map["workoutID"], map);
  }*/
  static Future<bool> insert(Map map) async {
    return await DB.insert(table,"", map);
  }

  // Update data {columnName: value} from workoutId
  static Future<bool> update(Map<String, Object> map) async {
    return await DB.update(table, "", map);
  }

  // Delete data from workoutId
  static Future<bool> delete(String workoutId) async {
    return await DB.delete(table, workoutId);
  }
}

