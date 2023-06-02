import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
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
    var mc = [
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
    var ms = [
      '0, 24',
      '0, 3',
    ];
    Map maryProfile = Map.fromIterables(UserDB.getColumns(), m);
    Map maryContract = Map.fromIterables(ContractDB.getColumns(), mc);
    Map maryMilestone = Map.fromIterables(MilestoneDB.getColumns(), ms);
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
                UserDB.insert(maryProfile);
                // UserDB.update(mary, {"weight": 47});
                UserDB.updateByFeedback("cardio", [1, 1]);
                UserDB.getAll();
                WorkoutDB.toNames(plan);
                ContractDB.insert(maryContract);
                MilestoneDB.insert(maryMilestone);
                // WeightDB.insert(mary, {"2023-05-14": "47"});
              },
              child: const Text("test DB")),
          TextButton(
              onPressed: () {
                PlanAlgo.execute();
                PlanAlgo.regenerate(DateTime.now());
              },
              child: const Text("test AG")),
          TextButton(
              onPressed: () async {
                // print(Calendar.isThisWeek(DateTime(2023, 5, 21)));
                // print(Calendar.isThisWeek(DateTime(2023, 5, 28)));
                // print(Calendar.nextSunday(DateTime(2023, 5, 21)));
                // print(Calendar.nextSunday(DateTime(2023, 5, 25)));
                // print(await UserDB.isWorkoutDay(mary, DateTime(2023, 5, 21)));
                // print(await UserDB.isWorkoutDay(mary, DateTime(2023, 5, 22)));
                // print(await UserDB.isWorkoutDay("123", DateTime(2023, 5, 22)));
                print(await DurationDB.calcCompletion());
              },
              child: const Text("test")),
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

  // Check if the given date is within this week
  static bool isThisWeek(DateTime date) =>
      (thisWeek().contains(toKey(date))) ? true : false;

  // Get next sunday
  static DateTime nextSunday(DateTime today) =>
      (today.weekday == 7) ? today : firstDay().add(const Duration(days: 7));
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
  static get uid => FirebaseAuth.instance.currentUser?.uid ?? "";
  // static get uid => "j6QYBrgbLIQH7h8iRyslntFFKV63";  //Mary
  // static get uid => "1UFfKQ4ONxf5rGQIro8vpcyUM9z1";  //John

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
  static Future<Map?> getUser() async {
    var snapshot = await DB.select(db, uid);
    return (snapshot != null)
        ? Map<String, dynamic>.from(snapshot as Map)
        : null;
  }

  // Select dynamic data from userID
  static Future<List<Map<String, dynamic>>?> getPlanVariables() async {
    final Map? user = await getUser();

    if (user != null) {
      return [
        {
          'neuroticism': user["neuroticism"],
          'conscientiousness': user["conscientiousness"],
          'openness': user["openness"],
        },
        {
          'timeSpan': user["timeSpan"],
          'workoutDays': user['workoutDays'].split('').map(int.parse).toList(),
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

  static Future<Map?> getPersonalities() async {
    return (await getPlanVariables())?[0];
  }

  static Future<Map?> getLikings() async {
    return (await getPlanVariables())?[2];
  }

  static Future<Map?> getAbilities() async {
    return (await getPlanVariables())?[3];
  }

  static Future<int?> getTimeSpan() async {
    return (await getUser())?["timeSpan"] as int;
  }

  static Future<String?> getLastWorkoutDay() async {
    final Map? user = await getUser();
    return Calendar.thisWeek()[user!["workoutDays"].lastIndexOf("1")];
  }

  static Future<int?> getWorkoutDayCount() async {
    final Map? user = await getUser();
    int days = 0;
    for (int i = 0; i < 7; i++) {
      if (user!["workoutDays"][i] != 0) {
        days++;
      }
    }
    return days;
  }

  static Future<List?> getBothWeekWorkoutDays() async {
    List? workoutDays = (await getPlanVariables())?[1]["workoutDays"];
    if (workoutDays != null) {
      List retVal = [];
      List thisWeek = Calendar.thisWeek();
      List nextWeek = Calendar.nextWeek();
      for (int i = 0; i < 7; i++) {
        if (workoutDays[i] == 1) {
          retVal.add(thisWeek[i]);
          retVal.add(nextWeek[i]);
        }
      }
      return retVal..sort();
    }
    return null;
  }

  // Check if the given date should workout
  static Future<bool?> isWorkoutDay(DateTime date) async {
    int idx = Calendar.bothWeeks().indexOf(Calendar.toKey(date));
    idx = (idx >= 7) ? idx - 7 : idx;
    List? workoutDays = (await getPlanVariables())?[1]["workoutDays"];
    bool isWorkoutDay = (workoutDays?[idx] == 1) ? true : false;
    return (workoutDays != null) ? isWorkoutDay : null;
  }

  // Insert data {columnName: value} into Users
  static Future<bool> insert(Map data) async {
    // Set modifiers
    int nMul = 10;
    int cMul = 5;
    List types = ["strength", "cardio", "yoga"];

    // Adjust survey results with user's personalities
    for (var item in types) {
      if (item == "strength") {
        data[item + "Liking"] -= data["neuroticism"] * nMul;
      } else {
        data[item + "Liking"] += data["neuroticism"] * nMul;
      }
      data[item + "Ability"] += data["conscientiousness"] * cMul;
    }

    // Insert user into database
    return await DB.insert("$db/$uid/", data);
  }

  // Update data {columnName: value} from userID
  static Future<bool> update(Map<String, Object> data) async {
    return await DB.update("$db/$uid/", data);
  }

  // Update plan variables by user's feedback [滿意度, 疲憊度]
  static Future<bool> updateByFeedback(String type, List feedback) async {
    final List? data = await getPlanVariables();

    if (data != null) {
      String index1 = "${type}Liking", index2 = "${type}Ability";
      num liking = data[2][index1], ability = data[3][index2];

      List adjVal = [-5, -2, 0, 2, 5];
      liking += adjVal[feedback[0] - 1];
      ability += adjVal[feedback[0] - 1];

      return await update({index1: liking, index2: ability});
    }
    return false;
  }

  // Delete data from userName
  static Future<bool> delete() async {
    return await DB.delete(db, uid);
  }
}

class ContractDB {
  static const db = "contract";
  static get uid => FirebaseAuth.instance.currentUser?.uid ?? "";
  // static get uid => "j6QYBrgbLIQH7h8iRyslntFFKV63";  //Mary
  // static get uid => "1UFfKQ4ONxf5rGQIro8vpcyUM9z1";  //John

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
  static Future<Map?> getContract() async {
    var snapshot = await DB.select(db, uid);
    return (snapshot != null)
        ? Map<String, dynamic>.from(snapshot as Map)
        : null;
  }

  // Select dynamic data from userID
  static Future<Map<String, dynamic>?> getContractDetails() async {
    final Map? contract = await getContract();

    if (contract != null) {
      return {
        'startDay': contract["startDay"],
        'endDay': contract["endDay"],
        'money': contract["money"],
        'flag': contract["flag"],
      };
    } else {
      return null;
    }
  }

  static Future<num?> getStartDay() async {
    final Map? user = await getContract();
    return user!["startDay"];
  }

  static Future<String?> getEndDay() async {
    final Map? user = await getContract();
    return user!["endDay"];
  }

  static Future<num?> getMoney() async {
    final Map? user = await getContract();
    return user!["money"];
  }

  static Future<num?> getFlag() async {
    final Map? user = await getContract();
    return user!["flag"];
  }

  // Insert data {columnName: value} into Users
  static Future<bool> insert(Map data) async {
    // Insert contract into database
    return await DB.insert("$db/$uid/", data);
  }

  // Update data {columnName: value} from userID
  static Future<bool> update(Map<String, Object> data) async {
    return await DB.update("$db/$uid/", data);
  }

  // Delete data from userName
  static Future<bool> delete() async {
    return await DB.delete(db, uid);
  }
}

class MilestoneDB {
  static const db = "milestone";
  static get uid => FirebaseAuth.instance.currentUser?.uid ?? "";
  // static get uid => "j6QYBrgbLIQH7h8iRyslntFFKV63";  //Mary
  // static get uid => "1UFfKQ4ONxf5rGQIro8vpcyUM9z1";  //John

  // Define the columns of the milestone table
  static List<String> getColumns() {
    return [
      "flag",
      "steps",
    ];
  }

  // Select milestone from userID
  static Future<Map?> getMilestone() async {
    return Map<String, dynamic>.from(await DB.select(db, uid) as Map);
  }

  static Future<num?> getFlag() async {
    final Map? user = await getMilestone();
    return user!["flag"];
  }

  static Future<String?> getSteps() async {
    final Map? user = await getMilestone();
    return user!["steps"];
  }

  // Insert data {columnName: value} into Users
  static Future<bool> insert(Map data) async {
    // Insert milestone into database
    return await DB.insert("$db/$uid/", data);
  }

  // Update data {columnName: value} from userID
  static Future<bool> update(Map<String, Object> data) async {
    return await DB.update("$db/$uid/", data);
  }

  // Delete data from userName
  static Future<bool> delete() async {
    return await DB.delete(db, uid);
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

  static Future<bool> insert(Map data) async {
    return await DB.insert(db, data);
  }

  // Update data {columnName: value} from workoutID
  static Future<bool> update(Map<String, Object> data) async {
    return await DB.update(db, data);
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
  static get uid => FirebaseAuth.instance.currentUser?.uid ?? "";
  // static get uid => "j6QYBrgbLIQH7h8iRyslntFFKV63";  //Mary
  // static get uid => "1UFfKQ4ONxf5rGQIro8vpcyUM9z1";  //John

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
  static Future<Map?> getTable() async => await JournalDB.getTable(uid, table);

  // Select the user's plan from the dates of given week
  static Future<Map?> getThisWeek() async =>
      await JournalDB.getThisWeek(uid, table);

  static Future<Map?> getNextWeek() async =>
      await JournalDB.getNextWeek(uid, table);

  // Select user's workout plan from given dates
  static Future<Map?> getFromDates(List<String> dates) async =>
      await JournalDB.getFromDates(uid, dates, table);

  static Future<String?> getFromDate(DateTime date) async =>
      await JournalDB.getFromDate(uid, date, table);

  // Select a map of user's plans based on workout names
  static Future<Map?> getDatesByName(Map? plans) async {
    var workoutNames = await WorkoutDB.getAll();
    if (plans != null && workoutNames != null) {
      return plans.map((date, plan) => MapEntry(date,
          plan.split(", ").map((value) => workoutNames[value]).join(", ")));
    }
    return null;
  }

  static Future<Map?> getThisWeekByName() async =>
      await getDatesByName(await getThisWeek());

  static Future<Map?> getNextWeekByName() async =>
      await getDatesByName(await getNextWeek());

  // Select a String of user's plan based on workout names
  static Future<String?> getByName(DateTime date) async {
    var plan = await getFromDate(date);
    if (plan != null) {
      var ids = plan.split(", ");
      return (await WorkoutDB.toNames(ids))?.join(", ");
    }
    return null;
  }

  static Future<int?> getPlanLong(DateTime date) async {
    return (await getFromDate(date))?.split(", ").length;
  }

  static Future<String?> getWorkoutType(DateTime date) async {
    // The third element of the plan is the first workout after the warmup,
    // and its first character's index (which indicates the workout type) is 18.
    switch ((await getFromDate(date))?[18]) {
      case '1':
        return "strength";
      case '2':
        return "cardio";
      case '3':
        return "yoga";
      default:
        return null;
    }
  }

  // Select user's workout history
  static Future<Map?> getHistory() async {
    var daysComing = Calendar.daysComing();
    var nextWeek = Calendar.nextWeek();
    var retVal = await getTable();
    retVal?.removeWhere((k, v) => daysComing.contains(k));
    retVal?.removeWhere((k, v) => nextWeek.contains(k));
    return retVal;
  }

  // Insert plan data {date: plan} into table {table/userID/plan/date}
  static Future<bool> insert(Map<String, String> data) async =>
      await JournalDB.insert(uid, data, table) &&
      await DurationDB.update(data.map((key, value) {
        return MapEntry(key, "0, ${value.length}");
      }));

  // Update plan data {date: plan} from table {table/userID/plan/date}
  static Future<bool> update(Map<String, String> data) async =>
      await JournalDB.update(uid, data, table) &&
      await DurationDB.update(data.map((key, value) {
        return MapEntry(key, "0, ${value.split(", ").length}");
      }));

  // Update the plan's date to given date (coming days of current week)
  static Future<bool> updateDate(DateTime original, DateTime modified) async {
    // The map is constituted by the modified date and the original plan
    String? plan = await getFromDate(original);
    if (plan != null) {
      Map<String, String> map = {Calendar.toKey(modified): plan};
      // Delete the original record, and update with the modified date
      return await delete(Calendar.toKey(original)) && await update(map);
    }
    return false;
  }

  // Delete plan data {table/userID/plan/date}
  static Future<bool> delete(String date) async =>
      await JournalDB.delete(uid, date, table) &&
      await DurationDB.delete(date);
}

class DurationDB {
  static const table = "duration";
  static get uid => FirebaseAuth.instance.currentUser?.uid ?? "";
  // static get uid => "j6QYBrgbLIQH7h8iRyslntFFKV63";  //Mary
  // static get uid => "1UFfKQ4ONxf5rGQIro8vpcyUM9z1";  //John

  // Select all durations
  static Future<Map?> getTable() async => await JournalDB.getTable(uid, table);

  // Select user's workout duration from given date
  static Future<List?> getFromDate(DateTime date) async {
    var duration = await JournalDB.getFromDate(uid, date, table);
    return (duration != null)
        ? duration.split(', ').map(int.parse).toList()
        : null;
  }

  static Future<Map?> getThisWeek() async {
    Map? durations =
        await JournalDB.getFromDates(uid, Calendar.thisWeek(), table);
    if (durations != null) {
      return durations.map((key, value) {
        var duration = value.split(', ').map(int.parse).toList();
        return MapEntry(key, (duration[0] / duration[1] * 100).round());
      });
    }
    return null;
  }

  // Calculate user's workout progress from given date
  static Future<num?> calcProgress(DateTime date) async {
    List? duration = await getFromDate(date);
    return (duration != null)
        ? (duration[0] / duration[1] * 100).round() // percentage
        : null;
  }

  // Calculate the number of times user has completed a workout plan during this week
  static Future<num?> calcCompletion() async {
    List? workoutDays = (await UserDB.getPlanVariables())?[1]["workoutDays"];
    int complete = 0;
    for (String date in Calendar.thisWeek()) {
      complete += (await calcProgress(DateTime.parse(date)) == 100) ? 1 : 0;
    }
    return (workoutDays != null)
        ? (complete / workoutDays.fold(0, (p, c) => c + p) * 100).round()
        : null;
  }

  // Insert duration data {date: "duration, timeSpan"} into table {table/userID/duration/date}
  static Future<bool> insert(Map<String, String> data) async {
    var timeSpan = await UserDB.getTimeSpan();
    data.map((key, value) {
      value += ", $timeSpan";
      return MapEntry(key, value);
    });
    return await JournalDB.insert(uid, data, table);
  }

  // Update duration data {date: "duration, timeSpan"} from table {table/userID/duration/date}
  static Future<bool> update(Map data) async {
    var timeSpan = await UserDB.getTimeSpan();
    data.map((key, value) {
      value += ", $timeSpan";
      return MapEntry(key, value);
    });
    return await JournalDB.update(uid, data, table);
  }

  // Delete duration data {table/userID/duration/date}
  static Future<bool> delete(String date) async =>
      await JournalDB.delete(uid, date, table);
}

class WeightDB {
  static const table = "weight";
  static get uid => FirebaseAuth.instance.currentUser?.uid ?? "";
  // static get uid => "j6QYBrgbLIQH7h8iRyslntFFKV63";  //Mary
  // static get uid => "1UFfKQ4ONxf5rGQIro8vpcyUM9z1";  //John

  // Select all weight
  static Future<Map?> getTable() async => await JournalDB.getTable(uid, table);

  // Select the user's weight from the dates of given week
  static Future<Map?> getThisWeek() async =>
      await JournalDB.getThisWeek(uid, table);

  static Future<Map?> getNextWeek() async =>
      await JournalDB.getNextWeek(uid, table);

  // Select user's weight from given dates
  static Future<Map?> getFromDates(List<String> dates) async =>
      await JournalDB.getFromDates(uid, dates, table);

  static Future<double?> getFromDate(DateTime date) async {
    var weight = await JournalDB.getFromDate(uid, date, table);
    return (weight != null) ? double.parse(weight) : null;
  }

  // Insert weight data {date: weight} into table {table/userID/weight/date}
  static Future<bool> insert(Map<String, double> data) async =>
      await JournalDB.insert(uid, data, table);

  // Update weight data {date: weight} from table {table/userID/weight/date}
  static Future<bool> update(Map<String, double> data) async =>
      await JournalDB.update(uid, data, table);

  // Delete weight data {table/userID/weight/date}
  static Future<bool> delete(String date) async =>
      await JournalDB.delete(uid, date, table);
}
