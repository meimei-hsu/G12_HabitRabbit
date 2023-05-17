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
    Map mary = Map.fromIterables(UserDB.getColumns(), m);
    var plan = [
      "4008",
      "4012",
      "4006",
      "3102",
      "3209",
      "3209",
      "3103",
      "3205",
      "3102",
      "3209",
      "3209",
      "3103",
      "3205",
      "3110",
      "3103",
      "3103",
      "3103",
      "3108",
      "5005",
      "5007"
    ];

    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextButton(
              onPressed: () {
                UserDB.insert("j6QYBrgbLIQH7h8iRyslntFFKV63", mary);
                UserDB.update("j6QYBrgbLIQH7h8iRyslntFFKV63", {"weight": 47});
                UserDB.getAll();
                WorkoutDB.getNames(plan);
                WeightDB.insert("j6QYBrgbLIQH7h8iRyslntFFKV63", {"2023-05-14": "47"});
                WeightDB.insert("pk80ghfLICRtGhVaOlAOzlcGU4S2", {"2023-05-14": "70"});
              },
              child: const Text("test DB")),
          TextButton(
              onPressed: () {
                PlanAlgo.execute("pk80ghfLICRtGhVaOlAOzlcGU4S2");
                //Algorithm.regenerate("j6QYBrgbLIQH7h8iRyslntFFKV63", DateTime.now());
              },
              child: const Text("test AG")),
        ],
      ),
    ));
  }
}

class Calendar {
  static DateTime today() => DateTime.now();

  static DateTime firstDay() {
    var td = today();
    return (td.weekday == 7) ? td : td.subtract(Duration(days: td.weekday));
  }

  // Convert DateTime to String (i.e. plan's key)
  static String toKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  // Get a number {duration} of dates from the given date {firstDay}
  static List<String> getWeekFrom(DateTime firstDay, int duration) {
    DateFormat fmt = DateFormat('yyyy-MM-dd');
    List<String> week = List.generate(
        duration, (index) => fmt.format(firstDay.add(Duration(days: index))));
    return week;
  }

  // Get the days of week that have already passed
  static List<String> daysPassed() =>
      getWeekFrom(firstDay(), today().weekday.toInt());
  // Get the days of week that are yet to come
  static List<String> daysComing() =>
      getWeekFrom(today(), (7 - today().weekday).toInt());
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
  static Future<Map?> getAll() async {
    var snapshot = await DB.selectAll(table);
    return (snapshot?.value) as Map?;
  }

  // Select user from userID
  static Future<Map?> getUser(String id) async {
    return Map<String, dynamic>.from(await DB.select(table, id) as Map);
  }

  // Select dynamic data from userID
  static Future<List<Map<String, dynamic>>?> getPlanVariables(String id) async {
    final Map? user = await getUser(id);

    if (user != null) {
      return [
        {
          'neuroticism': user["neuroticism"],
          'conscientiousness': user["conscientiousness"],
          'openness': user["openness"],
        },
        {
          'timeSpan': user["timeSpan"],
          'workoutDays': user["workoutDays"],
        },
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

  static Future<num?> getTimeSpan(String id) async {
    final Map? user = await getUser(id);
    return user!["timeSpan"];
  }

  static Future<num?> changeLiking(String id, String type, double feedBack) async {
    final Map? user = await getUser(id);
    final Map? data = (await getPlanVariables(id)) as Map?;
    //int liking=getPlanVariables(id)[2][type-1];
    int liking=0;
    if(type=="strength") {
      liking=data?[2][0];//初始值
      if (feedBack == 1) {
        update(id, {"strengthLiking": liking - 5});
      }
      else if (feedBack == 2) {
        update(id, {"strengthLiking": liking - 2});
      }
      else if (feedBack == 4) {
        update(id, {"strengthLiking": liking + 2});
      }
      else if (feedBack == 5) {
        update(id, {"strengthLiking": liking + 5});
      }
    }
    else if(type=="cardio") {
      liking=data?[2][1];//初始值
      if (feedBack == 1) {
        update(id, {"cardioLiking": liking - 5});
      }
      else if (feedBack == 2) {
        update(id, {"cardioLiking": liking - 2});
      }
      else if (feedBack == 4) {
        update(id, {"cardioLiking": liking + 2});
      }
      else if (feedBack == 5) {
        update(id, {"cardioLiking": liking + 5});
      }
    }
    else if(type=="yoga") {
      liking=data?[2][2];//初始值
      if (feedBack == 1) {
        update(id, {"yogaLiking": liking - 5});
      }
      else if (feedBack == 2) {
        update(id, {"yogaLiking": liking - 2});
      }
      else if (feedBack == 4) {
        update(id, {"yogaLiking": liking + 2});
      }
      else if (feedBack == 5) {
        update(id, {"yogaLiking": liking + 5});
      }
    }
    //return user!["timeSpan"];
  }
  static Future<num?> changeAbility(String id, String type, double feedBack) async {
    final Map? user = await getUser(id);
    final Map? data = (await getPlanVariables(id)) as Map?;
    int ability=0;
    if(type=="strength") {
      ability=data?[3][0];//初始值
      if (feedBack == 1) {
        update(id, {"strengthAbility": ability - 5});
      }
      else if (feedBack == 2) {
        update(id, {"strengthAbility": ability - 2});
      }
      else if (feedBack == 4) {
        update(id, {"strengthAbility": ability + 2});
      }
      else if (feedBack == 5) {
        update(id, {"strengthAbility": ability + 5});
      }
    }
    else if(type=="cardio") {
      ability=data?[3][1];//初始值
      if (feedBack == 1) {
        update(id, {"cardioAbility": ability - 5});
      }
      else if (feedBack == 2) {
        update(id, {"cardioAbility": ability - 2});
      }
      else if (feedBack == 4) {
        update(id, {"cardioAbility": ability + 2});
      }
      else if (feedBack == 5) {
        update(id, {"cardioAbility": ability + 5});
      }
    }
    else if(type=="yoga") {
      ability=data?[3][2];//初始值
      if (feedBack == 1) {
        update(id, {"yogaAbility": ability - 5});
      }
      else if (feedBack == 2) {
        update(id, {"yogaAbility": ability - 2});
      }
      else if (feedBack == 4) {
        update(id, {"yogaAbility": ability + 2});
      }
      else if (feedBack == 5) {
        update(id, {"yogaAbility": ability + 5});
      }
    }
    //return user!["timeSpan"];
  }


  static Future<String?> getLastWorkoutDay(String id) async {
    final Map? user = await getUser(id);
    return Calendar.thisWeek()[user!["workoutDays"].lastIndexOf("1")];
  }

  // Insert data {columnName: value} into Users
  static Future<bool> insert(String id, Map map) async {
    return await DB.insert(map, table, id);
  }

  // Update data {columnName: value} from userID
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

  // Format the String of plan into List of workouts
  static List toList(String planStr) {
    List<String> plan = planStr.split(", ");

    // (String) plan: 3 warm-up + n loops (10/5/...) + 10 min + 2 cool-down
    int nLoop = (plan.length - 5) ~/ 15;

    // Split the plan into different loops
    List<List<String>> fmtPlan = [
      plan.sublist(0, 3),
    ];
    int count = 3;

    for (int i = 0; i < nLoop; i++) {
      fmtPlan.add(plan.sublist(count, count + 10));
      count += 10;
      fmtPlan.add(plan.sublist(count, count + 5));
      count += 5;
    }

    fmtPlan.add(plan.sublist(count, count + 10));
    count += 10;
    fmtPlan.add(plan.sublist(count, count + 2));

    return fmtPlan;
  }

  // Select all plans
  static Future<Map?> getAll(String userID) async {
    var snapshot = await DB.selectAll("$table/$userID/plan");
    return (snapshot != null) ? (snapshot.value) as Map : null;
  }

  // Select the user's plan from the dates of given week
  static Future<Map?> getThisWeek(String userID) async =>
      getFromDates(userID, Calendar.thisWeek());

  static Future<Map?> getNextWeek(String userID) async =>
      getFromDates(userID, Calendar.nextWeek());

  // Select user's workout plan from given dates
  static Future<Map?> getFromDates(String userID, List<String> dates) async {
    Map retVal = {};
    Map? plan = await getAll(userID);
    if (plan != null) {
      for (String date in dates) {
        if (plan.containsKey(date)) {
          retVal[date] = plan[date];
        }
      }
    }
    return retVal.isNotEmpty ? retVal : null;
  }

  static Future<String> getFromDate(String userID, DateTime date) async {
    var plan = await DB.select("$table/$userID/plan", Calendar.toKey(date));
    return (plan != null) ? plan as String : "";
  }

  static Future<String> getType(String userID) async {
    switch ((await PlanDB.getFromDate(userID, DateTime.now()))[18]) {
      case '1':
        return "strength";
      case '2':
        return "cardio";
      case '3':
        return "yoga";
      default:
        return "";
    }
  }

  // Select user's workout history
  static Future<Map?> getHistory(String userID) async {
    var daysComing = Calendar.daysComing();
    var nextWeek = Calendar.nextWeek();
    var retVal = await getAll(userID);
    retVal?.removeWhere((k, v) => daysComing.contains(k));
    retVal?.removeWhere((k, v) => nextWeek.contains(k));
    return retVal;
  }

  // Insert plan data {date: plan} into table {table/userID/plan/date}
  static Future<bool> insert(String userID, Map<String, String> map) async {
    for (MapEntry e in map.entries) {
      var success = await DB.insert({e.key: e.value}, "$table/$userID", "plan");
      if (success == false) {
        return false;
      }
    }
    return true;
  }

  // Update plan data {date: plan} from table {table/userID/plan/date}
  static Future<bool> update(String userID, Map map) async {
    for (MapEntry e in map.entries) {
      var success = await DB.update({e.key: e.value}, "$table/$userID", "plan");
      if (success == false) {
        return false;
      }
    }
    return true;
  }

  // Delete plan data {table/userID/plan/date}
  static Future<bool> delete(String userID, String date) async {
    return DB.delete("$table/$userID/plan", date);
  }
}


class DurationDB {
  static const table = "journal";

  // Select all durations
  static Future<Map?> getAll(String userID) async {
    var snapshot = await DB.selectAll("$table/$userID/duration");
    return (snapshot != null) ? (snapshot.value) as Map : null;
  }

  // Select the user's duration from the dates of given week
  static Future<List?> getToday(String userID) async {
    String today = Calendar.toKey(DateTime.now());
    Map? durations = await getAll(userID);
    return (durations != null)
        ? durations[today]?.split(', ').map(int.parse).toList()
        : null;
  }

  // Select user's workout duration
  static Future<List?> getFromDate(String userID, DateTime date) async {
    var dur = await DB.select("$table/$userID/duration", Calendar.toKey(date));
    return (dur != null)
        ? (dur as String).split(', ').map(int.parse).toList()
        : null;
  }

  // Insert duration data {date: "duration, timeSpan"} into table {table/userID/duration/date}
  static Future<bool> insert(String userID, Map<String, String> map) async {
    for (MapEntry e in map.entries) {
      var success =
          await DB.insert({e.key: e.value}, "$table/$userID", "duration");
      if (success == false) {
        return false;
      }
    }
    return true;
  }

  // Update duration data {date: "duration, timeSpan"} from table {table/userID/duration/date}
  static Future<bool> update(String userID, Map map) async {
    for (MapEntry e in map.entries) {
      var success =
          await DB.update({e.key: e.value}, "$table/$userID", "duration");
      if (success == false) {
        return false;
      }
    }
    return true;
  }

  // Delete duration data {table/userID/duration/date}
  static Future<bool> delete(String userID, String date) async {
    return DB.delete("$table/$userID/duration", date);
  }
}

class WeightDB {
  static const table = "journal";


  // Select all weight
  static Future<Map?> getAll(String userID) async {
    var snapshot = await DB.selectAll("$table/$userID/weight");
    return (snapshot != null) ? (snapshot.value) as Map : null;
  }

  // Select the user's weight from the dates of given week
  static Future<Map?> getThisWeek(String userID) async =>
      getFromDates(userID, Calendar.thisWeek());

  static Future<Map?> getNextWeek(String userID) async =>
      getFromDates(userID, Calendar.nextWeek());

  // Select user's weight from given dates
  static Future<Map?> getFromDates(String userID, List<String> dates) async {
    Map retVal = {};
    Map? weight = await getAll(userID);
    if (weight != null) {
      for (String date in dates) {
        if (weight.containsKey(date)) {
          retVal[date] = weight[date];
        }
      }
    }
    return retVal.isNotEmpty ? retVal : null;
  }

  static Future<String> getFromDate(String userID, DateTime date) async {
    var weight = await DB.select("$table/$userID/weight", Calendar.toKey(date));
    return (weight != null) ? weight as String : "";
  }



  // Insert weight data {date: weight} into table {table/userID/weight/date}
  static Future<bool> insert(String userID, Map<String, String> map) async {
    for (MapEntry e in map.entries) {
      var success = await DB.insert({e.key: e.value}, "$table/$userID", "weight");
      if (success == false) {
        return false;
      }
    }
    return true;
  }

  // Update weight data {date: weight} from table {table/userID/weight/date}
  static Future<bool> update(String userID, Map map) async {
    for (MapEntry e in map.entries) {
      var success = await DB.update({e.key: e.value}, "$table/$userID", "weight");
      if (success == false) {
        return false;
      }
    }
    return true;
  }

  // Delete weight data {table/userID/weight/date}
  static Future<bool> delete(String userID, String date) async {
    return DB.delete("$table/$userID/weight", date);
  }
}
class WorkoutDB {
  static const table = "workouts";

  // Select all workouts
  static Future<Map?> getAll() async {
    var snapshot = await DB.selectAll(table);
    return snapshot?.value as Map?;
  }

  // Select workoutNames from workoutID
  static Future<List?> getNames(List ids) async {
    var workouts = await getAll();

    List retVal = [];
    for (var id in ids) {
      retVal.add(workouts![id]);
    }

    return retVal;
  }

  // Select workoutIDs
  static Future<Map?> getWIDs() async {
    var workouts = await getAll();
    List ids = workouts!.keys.toList();

    Map retVal = {
      "strength": [[], [], [], [], []],
      "cardio": [[], []],
      "yoga": [[], [], [], [], []],
      "warmUp": [],
      "coolDown": []
    };
    List keys = retVal.keys.toList();

    // Get the list of workoutID from the given type and difficulty
    for (int type = 1; type <= 3; type++) {
      for (int diff = 1; diff <= ((type == 2) ? 2 : 5); diff++) {
        retVal[keys[type - 1]][diff - 1] = List.from(
            ids.where((item) => item[0] == "$type" && item[1] == "$diff"));
      }
    }
    for (int type = 4; type <= 5; type++) {
      retVal[keys[type - 1]] =
          List.from(ids.where((item) => item[0] == "$type"));
    }

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
