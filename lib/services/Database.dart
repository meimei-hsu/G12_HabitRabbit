import 'dart:async';
import 'dart:collection';

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
    var mms = [
      '0, 24',
      '0, 24',
      '0, 4',
      '0, 7',
    ];
    Map maryMilestone = Map.fromIterables(MilestoneDB.columns, mms);
    var plan = ["4008", "4012", "4006", "3102", "3209"];

    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextButton(
              onPressed: () {
                // UserDB.insert(maryProfile);
                // UserDB.update(mary, {"weight": 47});
                // UserDB.updateByFeedback("cardio", [1, 1]);
                // UserDB.getAll();
                // WorkoutDB.toNames(plan);
                // MilestoneDB.update(maryMilestone);
                // MilestoneDB.update(maryMilestone);
                // WeightDB.insert(mary, {"2023-05-14": "47"});
                ClockDB.updateForecast(DateTime.parse("2023-08-31"));
              },
              child: const Text("test DB")),
          TextButton(
              onPressed: () {
                // PlanAlgo.execute();
                // PlanAlgo.regenerate(DateTime.now());
                MeditationPlanAlgo.execute();
                MeditationPlanAlgo.regenerate(DateTime.now());
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
                // print(Calendar.daysPassed());
                // print(Calendar.daysComing());
                // print(await DurationDB.getConsecutiveDays());
                print(await DurationDB.getMonthTotalTime());
              },
              child: const Text("test")),
          TextButton(
            onPressed: () async {
              SplayTreeMap? actual = await ClockDB.getTable();
              if (actual != null) {
                SplayTreeMap forecast = SplayTreeMap.from(actual);
                List dates = actual.keys.toList();

                for (int i = 0; i < dates.length - 1; i++) {
                  // start the forecasting from the second day (1st day prediction is equal to the actual data)
                  var pred = Calculator.forecastStartTime(
                      actual[dates[i]], forecast[dates[i]]);
                  forecast[dates[i + 1]] = pred;
                }
                print("actual:\n$actual");
                print("forecast:\n$forecast");

                List bias = [];
                List neg = [];
                for (int i = 0; i < dates.length; i++) {
                  // calculate the deviation value of the forecast
                  var dev = Calculator.convertToMinutes(forecast[dates[i]]) -
                      Calculator.convertToMinutes(actual[dates[i]]);
                  bias.add(dev);
                  if (dev < 0) neg.add(dev);
                }
                print("bias:\n$bias");

                // analyze the forecasting method's performance
                print("MAE: ${bias.fold(0, (p, c) => c + p) / bias.length}");
                print("# of negatives: ${neg.length / bias.length * 100}%");
                print("平均提前 ${neg.fold(0, (p, c) => c + p) / neg.length} 分鐘");
              } else {
                print("fail to fetch data");
              }
            },
            child: const Text("forecasting"),
          ),
        ],
      ),
    ));
  }
}

class Calendar {
  static DateTime today() => DateTime.now();

  static DateTime firstDay() => getSunday(today());

  static DateTime getSunday(DateTime date) =>
      (date.weekday == 7) ? date : date.subtract(Duration(days: date.weekday));

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
  static List<String> daysPassed() =>
      (today().weekday != 7) ? getWeekFrom(firstDay(), today().weekday) : [];
  // Get the days of week that are yet to come
  static List<String> daysComing() =>
      (today().weekday != 6) ? getWeekFrom(today(), 7 - today().weekday) : [];
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
  static get columns => [
        "userName",
        "gender",
        "birthday",
        "neuroticism",
        "conscientiousness",
        "openness",
        "agreeableness",
        "height",
        "weight",
        "workoutTime",
        "meditationTime",
        "workoutDays",
        "meditationDays",
        "workoutGoals",
        "meditationGoals",
        "relaxLiking",
        "visualizeLiking",
        "kindnessLiking",
        "strengthLiking",
        "cardioLiking",
        "yogaLiking",
        "strengthAbility",
        "cardioAbility",
        "yogaAbility",
      ];

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

  // Select meditation dynamic data from userID
  static Future<List<Map<String, dynamic>>?>
      getMeditationPlanVariables() async {
    final Map? user = await getUser();

    if (user != null) {
      return [
        {
          'meditationTime': user["meditationTime"],
          'meditationDays':
              user['meditationDays'].split('').map(int.parse).toList(),
        },
        {
          'relaxLiking': user["relaxLiking"],
          'visualizeLiking': user["visualizeLiking"],
          'kindnessLiking': user["kindnessLiking"],
        },
      ];
    } else {
      return null;
    }
  }

// Select workout dynamic data from userID
  static Future<List<Map<String, dynamic>>?> getPlanVariables() async {
    final Map? user = await getUser();

    if (user != null) {
      return [
        {
          'openness': user["openness"],
          'workoutTime': user["workoutTime"],
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

  static Future<Map?> getLikings() async {
    return (await getPlanVariables())?[1];
  }

  static Future<Map?> getAbilities() async {
    return (await getPlanVariables())?[2];
  }

  static Future<int?> getWorkoutTime() async {
    return (await getUser())?["workoutTime"] as int;
  }

  static Future<Map?> getMeditationLikings() async {
    return (await getMeditationPlanVariables())?[1];
  }

  static Future<int?> getMeditationTimeSpan() async {
    return (await getUser())?["meditationTime"] as int;
  }

  static Future<String?> getLastWorkoutDay() async {
    final Map? user = await getUser();
    return user != null
        ? Calendar.thisWeek()[user["workoutDays"].lastIndexOf("1")]
        : null;
  }

  static Future<String?> getLastMeditationDay() async {
    final Map? user = await getUser();
    return user != null
        ? Calendar.thisWeek()[user["meditationDays"].lastIndexOf("1")]
        : null;
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

  static Future<int?> getMeditationDayCount() async {
    final Map? user = await getUser();
    int days = 0;
    for (int i = 0; i < 7; i++) {
      if (user!["meditationDays"][i] != 0) {
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

  static Future<List?> getBothWeekMeditationDays() async {
    List? meditationDays =
        (await getMeditationPlanVariables())?[1]["meditationDays"];
    if (meditationDays != null) {
      List retVal = [];
      List thisWeek = Calendar.thisWeek();
      List nextWeek = Calendar.nextWeek();
      for (int i = 0; i < 7; i++) {
        if (meditationDays[i] == 1) {
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

  static Future<bool?> isMeditationDay(DateTime date) async {
    int idx = Calendar.bothWeeks().indexOf(Calendar.toKey(date));
    idx = (idx >= 7) ? idx - 7 : idx;
    List? meditationDays =
        (await getMeditationPlanVariables())?[1]["meditationDays"];
    bool isMeditationDay = (meditationDays?[idx] == 1) ? true : false;
    return (meditationDays != null) ? isMeditationDay : null;
  }

  // Insert data {columnName: value} into Users
  static Future<bool> insert(Map data) async {
    // Set modifiers
    const int nMul = 10;
    const int cMul = 5;
    const int mMul = 10;
    const List wTypes = ["strength", "cardio", "yoga"];

    // Adjust survey results with user's personalities
    for (var item in wTypes) {
      if (item == "strength") {
        data[item + "Liking"] -= data["neuroticism"] * nMul;
      } else {
        data[item + "Liking"] += data["neuroticism"] * nMul;
      }
      data[item + "Ability"] += data["conscientiousness"] * cMul;
    }
    data["bodyScan"] += data["neuroticism"] * mMul;
    data["visualize"] -= data["conscientiousness"] * mMul;
    data["kindness"] -= data["agreeableness"] * mMul;

    // Add userName column
    data["userName"] = FirebaseAuth.instance.currentUser?.displayName;

    // Insert user into database
    return await DB.insert("$db/$uid/", data);
  }

  // Update data {columnName: value} from userID
  static Future<bool> update(Map data) async {
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
  static get columns => [
        "type",
        "plan",
        "startDay",
        "endDay",
        "money",
        "bankAccount",
        "flag",
        "result",
      ];

  // Select data from userID
  static Future<Map<String, dynamic>?> getContract() async {
    var snapshot = await DB.select(db, uid);
    return (snapshot != null)
        ? Map<String, dynamic>.from(snapshot as Map)
        : null;
  }

  // Select workout contract from userID
  static Future<Map?> getWorkout() async => (await getContract())?["workout"];
  // Select meditation contract from userID
  static Future<Map?> getMeditation() async =>
      (await getContract())?["meditation"];

  // Update data {columnName: value} from userID
  static Future<bool> update(Map data) async => await DB.update(
      "$db/$uid/${(data["type"] == "運動") ? "workout" : "meditation"}", data);

  // Delete data from userID
  static Future<bool> delete() async => await DB.delete(db, uid);
  // Delete workout contract from userID
  static Future<bool> deleteWorkout() async =>
      await DB.delete(db, "$uid/workout");
  // Delete meditation contract from userID
  static Future<bool> deleteMeditation() async =>
      await DB.delete(db, "$uid/meditation");
}

class MilestoneDB {
  static const db = "milestone";
  static get uid => FirebaseAuth.instance.currentUser?.uid ?? "";
  // static get uid => "j6QYBrgbLIQH7h8iRyslntFFKV63";  //Mary
  // static get uid => "1UFfKQ4ONxf5rGQIro8vpcyUM9z1";  //John

  // Define the columns of the milestone table
  static get columns => [
        "workoutGem",
        "meditationGem",
        "workoutFragment",
        "meditationFragment",
      ];

  // Select milestone from userID
  static Future<Map<String, dynamic>?> getMilestone() async {
    var snapshot = await DB.select(db, uid);
    return (snapshot != null)
        ? Map<String, dynamic>.from(snapshot as Map)
        : null;
  }
  /*static Future<Map?> getMilestone() async {
    return Map<String, dynamic>.from(await DB.select(db, uid) as Map);
  }*/

  static Future<num?> getWorkoutGem() async {
    final Map? user = await getMilestone();
    return user!["workoutGem"];
  }

  static Future<num?> getMeditationGem() async {
    final Map? user = await getMilestone();
    return user!["meditationGem"];
  }

  static Future<String?> getWorkoutFragment() async {
    final Map? user = await getMilestone();
    return user!["workoutFragment"];
  }

  static Future<String?> getMeditationFragment() async {
    final Map? user = await getMilestone();
    return user!["meditationFragment"];
  }

  // Update data {columnName: value} from userID
  static Future<bool> update(Map data) async {
    return await DB.update("$db/$uid/", data);
  }

  static Future<Map?> gem() async {
    // String? step = await MilestoneDB.getMeditationGem();
    //if (step != null) {
    //step加一
    // var duration = value.split(', ').map(int.parse).toList();
    // return MapEntry(key, (duration[0] / duration[1] * 100).round());
    // }
    // if(){
    // 當step前後兩個數字相同，歸零，flag加一
    //contract flag加一
    //}

    return null;
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

  // Update data {columnName: value} from workoutID
  static Future<bool> update(Map data) async {
    return await DB.update(db, data);
  }

  // Delete data from workoutId
  static Future<bool> delete(String workoutID) async {
    return await DB.delete(db, workoutID);
  }
}

class MeditationDB {
  static const db = "meditations";

  // Select all workouts
  static Future<Map?> getAll() async {
    var snapshot = await DB.selectAll(db);
    return snapshot?.value as Map?;
  }

  // Convert workoutIDs to workoutNames
  static Future<List?> toNames(List<String> ids) async {
    var meditations = await getAll();

    List retVal = [];
    for (var id in ids) {
      retVal.add(meditations![id]);
    }

    return retVal;
  }

  // Select meditationIDs
  static Future<Map?> getMIDs() async {
    var meditations = await getAll();
    List ids = meditations!.keys.toList();

    Map retVal = {
      "mindfulness": [],
      "relax": [[], [], [], []],
      "visualize": [[], [], [], []],
      "kindness": [[], [], [], []],
    };
    List keys = retVal.keys.toList();

    // Get the list of workoutID from the given type and difficulty
    for (int category = 2; category <= 4; category++) {
      for (int type = 1; type <= 4; type++) {
        retVal[keys[category - 1]][type - 1] = List.from(
            ids.where((item) => item[0] == "$category" && item[1] == "$type"));
      }
    }
    retVal["mindfulness"] = List.from(ids.where((item) => item[0] == "1"));

    return retVal;
  }

  // Update data {columnName: value} from meditationID
  static Future<bool> update(Map data) async {
    return await DB.update(db, data);
  }

  // Delete data from meditationID
  static Future<bool> delete(String meditationID) async {
    return await DB.delete(db, meditationID);
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
  static Future<SplayTreeMap?> getTable() async =>
      await JournalDB.getTable(uid, table);

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
      await JournalDB.delete(uid, date, table) && await DurationDB.delete(date);
}

class MeditationPlanDB {
  static const table = "meditationPlan";
  static get uid => FirebaseAuth.instance.currentUser?.uid ?? "";
  // static get uid => "j6QYBrgbLIQH7h8iRyslntFFKV63";  //Mary
  // static get uid => "1UFfKQ4ONxf5rGQIro8vpcyUM9z1";  //John

  // Select all user's plans
  static Future<SplayTreeMap?> getTable() async =>
      await JournalDB.getTable(uid, table);

  // Select the user's plan from the dates of given week
  static Future<Map?> getThisWeek() async =>
      await JournalDB.getThisWeek(uid, table);

  static Future<Map?> getNextWeek() async =>
      await JournalDB.getNextWeek(uid, table);

  // Select user's meditation plan from given dates
  static Future<Map?> getFromDates(List<String> dates) async =>
      await JournalDB.getFromDates(uid, dates, table);

  static Future<String?> getFromDate(DateTime date) async =>
      await JournalDB.getFromDate(uid, date, table);

  // Select a map of user's plans based on meditation names
  static Future<Map?> getDatesByName(Map? plans) async {
    var meditationNames = await MeditationDB.getAll();
    if (plans != null && meditationNames != null) {
      return plans.map((date, plan) => MapEntry(date,
          plan.split(", ").map((value) => meditationNames[value]).join(", ")));
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
      return (await MeditationDB.toNames(ids))?.join(", ");
    }
    return null;
  }

  static Future<int?> getPlanLong(DateTime date) async {
    return (await getFromDate(date))?.split(", ").length;
  }

  static Future<String?> getMeditationType(DateTime date) async {
    switch ((await getFromDate(date))?[0]) {
      case '1':
        return "mindfulness";
      case '2':
        return "relax";
      case '3':
        return "visualize";
      case '4':
        return "kindness";
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

  // Update plan data {date: plan} from table {table/userID/plan/date}
  static Future<bool> update(Map<String, String> data) async =>
      await JournalDB.update(uid, data, table) &&
      await MeditationDurationDB.update(data.map((key, value) {
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
      await MeditationDurationDB.delete(date);
}

class Calculator {
  // Convert the time "hh:mm" to "mm"
  static num convertToMinutes(String time) {
    var lst = time.split(':').map(int.parse).toList();
    return lst[0] * 60 + lst[1];
  }

  // Forecast the starting time from the previous records with exponential smoothing
  static String forecastStartTime(String actualTime, String predictedTime) {
    double alpha = 0.8;
    // convert the time data from String to int (e.g. "09:00" -> 540)
    num y = convertToMinutes(actualTime),
        yHat = convertToMinutes(predictedTime);
    // make prediction by exponential smoothing method
    num pred = y + alpha * (y - yHat);
    // return result
    String hh = "${pred ~/ 60}".padLeft(2, "0");
    String mm = "${(pred % 60).round()}".padLeft(2, "0");
    return "$hh:$mm";
  }

  // Calculate the progress of the given data "completeNum, totalNum"
  static num calcProgress(String duration) {
    var lst = duration.split(', ').map(int.parse).toList();
    return lst[0] / lst[1] * 100; // percentage
  }

  // Calculate the number of times user has completed a plan during this week
  static num calcCompletion(List habitDays) {
    int complete = 0;
    for (String date in Calendar.thisWeek()) {
      complete += (calcProgress(date).round() == 100) ? 1 : 0;
    }
    return complete / habitDays.fold(0, (p, c) => c + p) * 100;
  }

  // Calculate the number of consecutive completion days
  static List? getConsecutiveDays(SplayTreeMap? durations) {
    List retVal = []; // store the results

    if (durations != null) {
      List dates = durations.keys.toList();
      List values = durations.values.toList();

      List success = []; // store the completion status of the workout plans
      for (var duration in values) {
        List record = duration.split(", ");
        // the 1st element of `record` is the completed minutes, and the 2nd element is the total minutes
        // if the plan is completed (i.e. 1st element == 2nd), then set the status to 1 otherwise set to 0, and add to `success`
        success.add((record[0] == record[1]) ? 1 : 0);
      }

      int count = 0; // store the number of consecutive days in a row
      String? element;
      for (int i = 0; i < success.length; i++) {
        element ??= dates[i];
        count++;
        if (success[i] == 0) {
          // format the result as "firstDay, lastDay, countDays"
          element = "${element!}, ${dates[i - 1]}, ${--count}";
          // store the result to `retVal` when the continuous record is broken and `count` is more than one
          if (count > 1) retVal.add(element.split(", "));
          // reset `count` and `element` variables for the next iteration
          count = 0;
          element = null;
        }
      }
      // if all the elements in `success` are one (i.e. every day is completed)
      if (retVal.isEmpty) {
        String element = "${dates.first}, ${dates.last}, ${success.length}";
        retVal.add(element.split(", "));
      }

      return retVal;
    }
    return null;
  }

  // Add up the total amount of habit commitment time for each week
  static List? getWeekTotalTime(SplayTreeMap? durations) {
    List retVal = []; // store the results

    if (durations != null) {
      List<DateTime> dates =
          durations.keys.map((d) => DateTime.parse(d)).toList();
      List<int> values =
          durations.values.map((e) => int.parse(e.split(", ")[0])).toList();

      DateTime sunday = Calendar.getSunday(dates.first); // 1st day of each week
      int sum = 0; // the sum of habit time for the given week
      for (int i = 0; i < dates.length; i++) {
        if (sunday.difference(dates[i]).inDays * -1 < 7) {
          sum += values[i];
        } else {
          // store the result to `retVal` when the difference to `sunday` is more than 7 days (1 week)
          retVal.add([
            Calendar.toKey(sunday),
            Calendar.toKey(sunday.add(const Duration(days: 6))),
            sum
          ]);
          // reset variables for next iteration
          sunday = sunday.add(const Duration(days: 7));
          sum = values[i];
        }
      }

      return retVal;
    }
    return null;
  }

  // Add up the total amount of habit commitment time for each month
  static List? getMonthTotalTime(SplayTreeMap? durations) {
    List retVal = []; // store the results

    if (durations != null) {
      List<DateTime> dates =
          durations.keys.map((d) => DateTime.parse(d)).toList();
      List<int> values =
          durations.values.map((e) => int.parse(e.split(", ")[0])).toList();

      DateTime dayOne = dates.first.subtract(
          Duration(days: dates.first.day - 1)); // 1st day of each month
      int sum = 0; // the sum of habit time for the given week
      for (int i = 0; i < dates.length; i++) {
        if (dayOne.year == dates[i].year && dayOne.month == dates[i].month) {
          sum += values[i];
        } else {
          DateTime nextDayOne = DateTime(dayOne.year, dayOne.month + 1, 1);

          // store the result to `retVal` when the difference to `dayOne` is more than 1 month
          retVal.add([
            Calendar.toKey(dayOne),
            Calendar.toKey(nextDayOne.subtract(const Duration(days: 1))),
            sum
          ]);

          // reset variables for next iteration
          dayOne = nextDayOne;
          sum = values[i];
        }
      }

      return retVal;
    }
    return null;
  }

  // Add up the total number of habit committed days for each month
  static List? getMonthTotalDays(SplayTreeMap? durations) {
    List retVal = []; // store the results

    if (durations != null) {
      List<DateTime> dates =
          durations.keys.map((d) => DateTime.parse(d)).toList();
      List values = durations.values.toList();

      List<int> success =
          []; // store the completion status of the workout plans
      for (var duration in values) {
        List record = duration.split(", ");
        // the 1st element of `record` is the completed minutes, and the 2nd element is the total minutes
        // if the plan is completed (i.e. 1st element == 2nd), then set the status to 1 otherwise set to 0, and add to `success`
        success.add((record[0] == record[1]) ? 1 : 0);
      }

      DateTime dayOne = dates.first.subtract(
          Duration(days: dates.first.day - 1)); // 1st day of each month
      int count = 0; // the sum of habit days for the given month
      for (int i = 0; i < dates.length; i++) {
        if (dayOne.year == dates[i].year && dayOne.month == dates[i].month) {
          count += success[i];
        } else {
          DateTime nextDayOne = DateTime(dayOne.year, dayOne.month + 1, 1);

          // store the result to `retVal` when the difference to `dayOne`` is more than 1 month
          retVal.add([
            Calendar.toKey(dayOne),
            Calendar.toKey(nextDayOne.subtract(const Duration(days: 1))),
            count
          ]);

          // reset variables for next iteration
          dayOne = nextDayOne;
          count = success[i];
        }
      }

      return retVal;
    }
    return null;
  }

  // Add up the total number of habit committed days for each year
  static List? getYearTotalDays(SplayTreeMap? durations) {
    List retVal = []; // store the results

    if (durations != null) {
      List<DateTime> dates =
          durations.keys.map((d) => DateTime.parse(d)).toList();
      List values = durations.values.toList();

      List<int> success =
          []; // store the completion status of the workout plans
      for (var duration in values) {
        List record = duration.split(", ");
        // the 1st element of `record` is the completed minutes, and the 2nd element is the total minutes
        // if the plan is completed (i.e. 1st element == 2nd), then set the status to 1 otherwise set to 0, and add to `success`
        success.add((record[0] == record[1]) ? 1 : 0);
      }

      DateTime dayOne =
          DateTime(dates.first.year, 1, 1); // 1st day of each year
      int count = 0; // the sum of habit days for the given month
      for (int i = 0; i < dates.length; i++) {
        if (dayOne.year == dates[i].year) {
          count += success[i];
        } else {
          DateTime nextDayOne = DateTime(dayOne.year + 1, 1, 1);

          // store the result to `retVal` when the difference to `dayOne` is more than 1 year
          retVal.add([
            Calendar.toKey(dayOne),
            Calendar.toKey(nextDayOne.subtract(const Duration(days: 1))),
            count
          ]);

          // reset variables for next iteration
          dayOne = nextDayOne;
          count = success[i];
        }
      }

      if (retVal.isEmpty) {
        retVal.add([
          Calendar.toKey(dayOne),
          Calendar.toKey(DateTime(dayOne.year + 1, 1, 1)),
          count
        ]);
      }

      return retVal;
    }
    return null;
  }
}

class DurationDB {
  static const table = "duration";
  static get uid => FirebaseAuth.instance.currentUser?.uid ?? "";
  // static get uid => "j6QYBrgbLIQH7h8iRyslntFFKV63";  //Mary
  // static get uid => "1UFfKQ4ONxf5rGQIro8vpcyUM9z1";  //John

  // Select all durations
  static Future<SplayTreeMap?> getTable() async =>
      await JournalDB.getTable(uid, table);

  // Select user's workout duration from given date
  static Future<int?> getFromDate(DateTime date) async {
    var duration = await JournalDB.getFromDate(uid, date, table);
    return (duration != null) ? int.parse(duration.split(', ')[0]) : null;
  }

  // Calculate the number of consecutive completion days
  static Future<List?> getConsecutiveDays() async =>
      Calculator.getConsecutiveDays(await getTable());

  // Add up the total amount of workout time for each week
  static Future<List?> getWeekTotalTime() async =>
      Calculator.getWeekTotalTime(await getTable());

  // Add up the total amount of workout time for each month
  static Future<List?> getMonthTotalTime() async =>
      Calculator.getMonthTotalTime(await getTable());

  // Add up the total number of workout days for each month
  static Future<List?> getMonthTotalDays() async =>
      Calculator.getMonthTotalDays(await getTable());

  // Add up the total number of workout days for each year
  static Future<List?> getYearTotalDays() async =>
      Calculator.getYearTotalDays(await getTable());

  // Calculate user's workout progress from given dates
  static Future<Map?> getWeekProgress() async {
    Map? durations = await JournalDB.getThisWeek(uid, table);
    if (durations != null) {
      return durations.map((key, value) =>
          MapEntry(key, Calculator.calcProgress(value).round()));
    }
    return null;
  }

  // Calculate user's workout progress from given date
  static Future<num?> calcProgress(DateTime date) async {
    var record = (await JournalDB.getFromDate(uid, date, table));
    return (record != null) ? Calculator.calcProgress(record).round() : null;
  }

  // Calculate the number of times user has completed a workout plan during this week
  static Future<num?> calcCompletion() async {
    List? days = (await UserDB.getUser())?["workoutDays"];
    return (days != null) ? Calculator.calcCompletion(days).round() : null;
  }

  // Update duration data {date: "duration, timeSpan"} from table {table/userID/duration/date}
  static Future<bool> update(Map data) async {
    String key = data.keys.first;
    String value = data.values.first.toString();

    if (value.contains(", ")) {
      // value: "duration, timeSpan"
      return await JournalDB.update(uid, data, table);
    } else {
      // value: "duration"
      var record = await JournalDB.getFromDate(
          uid, DateTime.parse(data.keys.first), table);
      if (record != null) {
        String timeSpan = record.split(', ')[1];
        return await JournalDB.update(uid, {key: "$value, $timeSpan"}, table);
      }
    }
    return false;
  }

  // Delete duration data {table/userID/duration/date}
  static Future<bool> delete(String date) async =>
      await JournalDB.delete(uid, date, table);
}

class MeditationDurationDB {
  static const table = "meditationDuration";
  static get uid => FirebaseAuth.instance.currentUser?.uid ?? "";
  // static get uid => "j6QYBrgbLIQH7h8iRyslntFFKV63";  //Mary
  // static get uid => "1UFfKQ4ONxf5rGQIro8vpcyUM9z1";  //John

  // Select all durations
  static Future<SplayTreeMap?> getTable() async =>
      await JournalDB.getTable(uid, table);

  // Select user's meditation duration from given date
  static Future<int?> getFromDate(DateTime date) async {
    var duration = await JournalDB.getFromDate(uid, date, table);
    return (duration != null) ? int.parse(duration.split(', ')[0]) : null;
  }

  // Calculate the number of consecutive completion days
  static Future<List?> getConsecutiveDays() async =>
      Calculator.getConsecutiveDays(await getTable());

  // Add up the total amount of meditation time for each week
  static Future<List?> getWeekTotalTime() async =>
      Calculator.getWeekTotalTime(await getTable());

  // Add up the total amount of meditation time for each month
  static Future<List?> getMonthTotalTime() async =>
      Calculator.getMonthTotalTime(await getTable());

  // Add up the total number of meditation days for each month
  static Future<List?> getMonthTotalDays() async =>
      Calculator.getMonthTotalDays(await getTable());

  // Add up the total number of meditation days for each year
  static Future<List?> getYearTotalDays() async =>
      Calculator.getYearTotalDays(await getTable());

  // Calculate user's meditation progress from given dates
  static Future<Map?> getWeekProgress() async {
    Map? durations = await JournalDB.getThisWeek(uid, table);
    if (durations != null) {
      return durations.map((key, value) =>
          MapEntry(key, Calculator.calcProgress(value).round()));
    }
    return null;
  }

  // Calculate user's meditation progress from given date
  static Future<num?> calcProgress(DateTime date) async {
    var record = (await JournalDB.getFromDate(uid, date, table));
    return (record != null) ? Calculator.calcProgress(record).round() : null;
  }

  // Calculate the number of times user has completed a meditation plan during this week
  static Future<num?> calcCompletion() async {
    List? days = (await UserDB.getUser())?["meditationDays"];
    return (days != null) ? Calculator.calcCompletion(days).round() : null;
  }

  // Update duration data {date: "duration, timeSpan"} from table {table/userID/duration/date}
  static Future<bool> update(Map data) async {
    String key = data.keys.first;
    String value = data.values.first.toString();

    if (value.contains(", ")) {
      // value: "duration, timeSpan"
      return await JournalDB.update(uid, data, table);
    } else {
      // value: "duration"
      var record = await JournalDB.getFromDate(
          uid, DateTime.parse(data.keys.first), table);
      if (record != null) {
        String timeSpan = record.split(', ')[1];
        return await JournalDB.update(uid, {key: "$value, $timeSpan"}, table);
      }
    }
    return false;
  }

  // Delete duration data {table/userID/duration/date}
  static Future<bool> delete(String date) async =>
      await JournalDB.delete(uid, date, table);
}

class ClockDB {
  static const table = "clock";
  static get uid =>
      FirebaseAuth.instance.currentUser?.uid ?? "j6QYBrgbLIQH7h8iRyslntFFKV63";
  // static get uid => "j6QYBrgbLIQH7h8iRyslntFFKV63";  //Mary
  // static get uid => "1UFfKQ4ONxf5rGQIro8vpcyUM9z1";  //John

  // Select all start time records
  static Future<SplayTreeMap?> getTable() async =>
      await JournalDB.getTable(uid, table);

  // Select the user's start time from the dates of given week
  static Future<Map?> getThisWeek() async =>
      await JournalDB.getThisWeek(uid, table);

  static Future<Map?> getNextWeek() async =>
      await JournalDB.getNextWeek(uid, table);

  // Select user's start time from given dates
  static Future<Map?> getFromDates(List<String> dates) async =>
      await JournalDB.getFromDates(uid, dates, table);

  static Future<String?> getFromDate(DateTime date) async {
    var startTime = await JournalDB.getFromDate(uid, date, table);
    return (startTime != null) ? startTime : null;
  }

  // Get the start time prediction
  static Future<String?> getPrediction() async =>
      await DB.select("journal/$uid/$table", "forecast") as String;

  // Update start time data {date: "09:00"} from table {table/userID/clock/date}
  // Update when user first start the video/audio in that day
  static Future<bool> update(Map<String, String> data) async =>
      await JournalDB.update(uid, data, table) &
      await updateForecast(DateTime.now());

  // Update the forecast data {"forecast": "09:00"} from table {table/userID/clock/forecast}
  static Future<bool> updateForecast(DateTime today) async {
    String? actualTime = await getFromDate(today);
    String? predictedTime = await getPrediction();
    if (actualTime != null && predictedTime != null) {
      String forecast = Calculator.forecastStartTime(actualTime, predictedTime);
      return update({"forecast": forecast});
    }
    return false;
  }

  // Delete start time data {table/userID/clock/date}
  static Future<bool> delete(String date) async =>
      await JournalDB.delete(uid, date, table);
}

class WeightDB {
  static const table = "weight";
  static get uid => FirebaseAuth.instance.currentUser?.uid ?? "";
  // static get uid => "j6QYBrgbLIQH7h8iRyslntFFKV63";  //Mary
  // static get uid => "1UFfKQ4ONxf5rGQIro8vpcyUM9z1";  //John

  // Select all weight
  static Future<SplayTreeMap?> getTable() async =>
      await JournalDB.getTable(uid, table);

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

  // Update weight data {date: weight} from table {table/userID/weight/date}
  static Future<bool> update(Map<String, double> data) async =>
      await JournalDB.update(uid, data, table);

  // Delete weight data {table/userID/weight/date}
  static Future<bool> delete(String date) async =>
      await JournalDB.delete(uid, date, table);
}
