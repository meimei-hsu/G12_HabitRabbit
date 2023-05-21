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
    var mc=[
      DateTime.utc(2023, 5, 1).toString(),
      DateTime.utc(2023, 10, 1).toString(),
      500,
      '12345678',
      '0,4',
      false,
    ];
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
    Map maryProfile = Map.fromIterables(UserDB.getColumns(), m);
    Map maryContract = Map.fromIterables(ContractDB.getColumns(), mc);
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

    String mary = "j6QYBrgbLIQH7h8iRyslntFFKV63";
    String john = "1UFfKQ4ONxf5rGQIro8vpcyUM9z1";

    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextButton(
              onPressed: () {
                UserDB.insert(mary, maryProfile);
                // UserDB.update(mary, {"weight": 47});
                UserDB.updateByFeedback(mary, "cardio", [1, 1]);
                UserDB.getAll();
                WorkoutDB.toNames(plan);
                ContractDB.insert(mary, maryContract);
                // WeightDB.insert(mary, {"2023-05-14": "47"});
              },
              child: const Text("test DB")),
          TextButton(
              onPressed: () {
                // PlanAlgo.execute(john);
                PlanAlgo.regenerate(mary, DateTime.now());
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
  static List<String> daysPassed() => (firstDay().weekday != 7)
      ? getWeekFrom(firstDay(), today().weekday.toInt())
      : [];
  // Get the days of week that are yet to come
  static List<String> daysComing() => (firstDay().weekday != 6)
      ? getWeekFrom(today(), (7 - today().weekday).toInt())
      : [];
  // Get the days of week from the first day
  static List<String> thisWeek() => getWeekFrom(firstDay(), 7);
  // Get the days of week from the eighth day
  static List<String> nextWeek() =>
      getWeekFrom(firstDay().add(const Duration(days: 7)), 7);
  // Get the days of the following two weeks
  static List<String> bothWeeks() => [...thisWeek(), ...nextWeek()];
}

/*
################################################################################
General Database: database records that occurs occasionally
################################################################################
*/

class UserDB {
  static const db = "users";

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
    var snapshot = await DB.selectAll(db);
    return (snapshot?.value) as Map?;
  }

  // Select user from userID
  static Future<Map?> getUser(String id) async {
    return Map<String, dynamic>.from(await DB.select(db, id) as Map);
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

  static Future<String?> getLastWorkoutDay(String id) async {
    final Map? user = await getUser(id);
    return Calendar.thisWeek()[user!["workoutDays"].lastIndexOf("1")];
  }

  // Insert data {columnName: value} into Users
  static Future<bool> insert(String id, Map map) async {
    // Set modifiers
    int nMul = 10;
    int cMul = 5;
    List types = ["strength", "cardio", "yoga"];

    // Adjust survey results with user's personalities
    for (var item in types) {
      if (item == "strength") {
        map[item + "Liking"] -= map["neuroticism"] * nMul;
      } else {
        map[item + "Liking"] += map["neuroticism"] * nMul;
      }
      map[item + "Ability"] += map["conscientiousness"] * cMul;
    }

    // Insert user into database
    return await DB.insert("$db/$id/", map);
  }

  // Update data {columnName: value} from userID
  static Future<bool> update(String id, Map<String, Object> map) async {
    return await DB.update("$db/$id/", map);
  }

  // Update plan variables by user's feedback [滿意度, 疲憊度]
  static Future<bool> updateByFeedback(
      String id, String type, List feedback) async {
    final List? data = await getPlanVariables(id);

    if (data != null) {
      String index1 = "${type}Liking", index2 = "${type}Ability";
      num liking = data[2][index1], ability = data[3][index2];

      List adjVal = [-5, -2, 0, 2, 5];
      liking += adjVal[feedback[0] - 1];
      ability += adjVal[feedback[0] - 1];

      return await update(id, {index1: liking, index2: ability});
    }
    return false;
  }

  // Delete data from userName
  static Future<bool> delete(String id) async {
    return await DB.delete(db, id);
  }
}
class ContractDB {
  static const db = "contract";

  // Define the columns of the user table
  static List<String> getColumns() {
    return [
      "startDay",
      "endDay",
      "money",
      "bankAccount",
      "flag",
      "result",

    ];
  }



  // Select contract from userID
  static Future<Map?> getContract(String id) async {
    return Map<String, dynamic>.from(await DB.select(db, id) as Map);
  }

  // Select dynamic data from userID
  static Future<List<Map<String, dynamic>>?> getContractDetails(String id) async {
    final Map? contract = await getContract(id);

    if (contract != null) {
      return [
        {
          'startDay': contract["startDay"],
          'endDay': contract["endDay"],
          'money': contract["money"],
          'flag': contract["flag"],
        },

      ];
    } else {
      return null;
    }
  }

  static Future<num?> getStartDay(String id) async {
    final Map? user = await getContract(id);
    return user!["startDay"];
  }

  static Future<num?> getEndDay(String id) async {
    final Map? user = await getContract(id);
    return user!["endDay"];
  }

  static Future<num?> getMoney(String id) async {
    final Map? user = await getContract(id);
    return user!["money"];
  }

  static Future<num?> getFlag(String id) async {
    final Map? user = await getContract(id);
    return user!["flag"];
  }



  // Insert data {columnName: value} into Users
  static Future<bool> insert(String id, Map map) async {


    // Insert contract into database
    return await DB.insert("$db/$id/", map);
  }

  // Update data {columnName: value} from userID
  static Future<bool> update(String id, Map<String, Object> map) async {
    return await DB.update("$db/$id/", map);
  }



  // Delete data from userName
  static Future<bool> delete(String id) async {
    return await DB.delete(db, id);
  }
}

class WorkoutDB {
  static const db = "workouts";

  // Select all workouts
  static Future<Map?> getAll() async {
    var snapshot = await DB.selectAll(db);
    return snapshot?.value as Map?;
  }

  // Convert workoutIDs to workoutNames
  static Future<List?> toNames(List<String> ids) async {
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
    return await DB.insert(db, map);
  }

  // Update data {columnName: value} from workoutId
  static Future<bool> update(Map<String, Object> map) async {
    return await DB.update(db, map);
  }

  // Delete data from workoutId
  static Future<bool> delete(String workoutID) async {
    return await DB.delete(db, workoutID);
  }
}

/*
################################################################################
Journal Database: database records that occurs daily
################################################################################
*/

class PlanDB {
  static const table = "plan";

  // Format the String of plan into List of workouts, grouped by workout sets
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

  // Select all user's plans
  static Future<Map?> getTable(String userID) async =>
      await JournalDB.getTable(userID, table);

  // Select the user's plan from the dates of given week
  static Future<Map?> getThisWeek(String userID) async =>
      await JournalDB.getThisWeek(userID, table);

  static Future<Map?> getNextWeek(String userID) async =>
      await JournalDB.getNextWeek(userID, table);

  // Select user's workout plan from given dates
  static Future<Map?> getFromDates(String userID, List<String> dates) async =>
      await JournalDB.getFromDates(userID, dates, table);

  static Future<String> getFromDate(String userID, DateTime date) async =>
      await JournalDB.getFromDate(userID, date, table);

  // Select user's plan based on workout names
  static Future<String?> getByName(String userID, DateTime date) async {
    var plan = await getFromDate(userID, date);
    if (plan.isNotEmpty) {
      var ids = plan.split(", ");
      return (await WorkoutDB.toNames(ids))?.join(", ");
    }
    return null;
  }

  static Future<String> getWorkoutType(String userID, DateTime date) async {
    // The third element of the plan is the first workout after the warmup,
    // and its first character's index (which indicates the workout type) is 18.
    switch ((await getFromDate(userID, date))[18]) {
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
    var retVal = await getTable(userID);
    retVal?.removeWhere((k, v) => daysComing.contains(k));
    retVal?.removeWhere((k, v) => nextWeek.contains(k));
    return retVal;
  }

  // Insert plan data {date: plan} into table {table/userID/plan/date}
  static Future<bool> insert(String userID, Map<String, String> map) async =>
      await JournalDB.insert(userID, map, table);

  // Update plan data {date: plan} from table {table/userID/plan/date}
  static Future<bool> update(String userID, Map<String, String> map) async =>
      await JournalDB.update(userID, map, table);

  // Update the plan's date to given date (coming days of current week)
  static Future<bool> updateDate(
      String userID, DateTime original, DateTime modified) async {
    // The map is constituted by the modified date and the original plan
    String plan = await getFromDate(userID, original);
    if (plan.isNotEmpty) {
      Map<String, String> map = {Calendar.toKey(modified): plan};
      // Delete the original record, and update with the modified date
      return await delete(userID, Calendar.toKey(original)) &&
          await update(userID, map);
    }
    return false;
  }

  // Delete plan data {table/userID/plan/date}
  static Future<bool> delete(String userID, String date) async =>
      await JournalDB.delete(userID, date, table);
}

class DurationDB {
  static const table = "duration";

  // Select all durations
  static Future<Map?> getTable(String userID) async =>
      await JournalDB.getTable(userID, table);

  // Select user's workout duration from given date
  static Future<List?> getFromDate(String userID, DateTime date) async {
    var duration = await JournalDB.getFromDate(userID, date, table);
    return (duration.isNotEmpty)
        ? duration.split(', ').map(int.parse).toList()
        : null;
  }

  // Calculate user's workout progress from given date
  static Future<num?> calcProgress(String uid, DateTime date) async {
    List? duration = await getFromDate(uid, date);
    return (duration != null)
        ? (duration[0] / duration[1] * 100).round() // percentage
        : null;
  }

  // Insert duration data {date: "duration, timeSpan"} into table {table/userID/duration/date}
  static Future<bool> insert(String userID, Map<String, String> map) async =>
      await JournalDB.insert(userID, map, table);

  // Update duration data {date: "duration, timeSpan"} from table {table/userID/duration/date}
  static Future<bool> update(String userID, Map map) async =>
      await JournalDB.update(userID, map, table);

  // Delete duration data {table/userID/duration/date}
  static Future<bool> delete(String userID, String date) async =>
      await JournalDB.delete(userID, date, table);
}

class WeightDB {
  static const table = "weight";

  // Select all weight
  static Future<Map?> getTable(String userID) async =>
      await JournalDB.getTable(userID, table);

  // Select the user's weight from the dates of given week
  static Future<Map?> getThisWeek(String userID) async =>
      await JournalDB.getThisWeek(userID, table);

  static Future<Map?> getNextWeek(String userID) async =>
      await JournalDB.getNextWeek(userID, table);

  // Select user's weight from given dates
  static Future<Map?> getFromDates(String userID, List<String> dates) async =>
      await JournalDB.getFromDates(userID, dates, table);

  static Future<double> getFromDate(String userID, DateTime date) async {
    var weight = await JournalDB.getFromDate(userID, date, table);
    return (weight.isNotEmpty) ? double.parse(weight) : 0;
  }

  // Insert weight data {date: weight} into table {table/userID/weight/date}
  static Future<bool> insert(String userID, Map<String, String> map) async =>
      await JournalDB.insert(userID, map, table);

  // Update weight data {date: weight} from table {table/userID/weight/date}
  static Future<bool> update(String userID, Map map) async =>
      await JournalDB.update(userID, map, table);

  // Delete weight data {table/userID/weight/date}
  static Future<bool> delete(String userID, String date) async =>
      await JournalDB.delete(userID, date, table);
}




