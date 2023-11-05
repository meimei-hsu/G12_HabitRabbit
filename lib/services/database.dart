import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:g12/services/page_data.dart';
import 'package:intl/intl.dart';

import 'package:g12/services/crud.dart';
import 'package:g12/Services/notification.dart';

// ignore_for_file: avoid_print

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
    // var plan = ["4008", "4012", "4006", "3102", "3209"];

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
                // WeightDB.insert(mary, {"2023-05-14": "47"});
                // ClockDB.updateForecast(DateTime.parse("2023-08-31"));
              },
              child: const Text("text")),
          TextButton(
              onPressed: () {
                // PlanAlgo.execute();
                // PlanAlgo.regenerate(DateTime.now());
                // MeditationPlanAlgo.execute();
                // MeditationPlanAlgo.regenerate(DateTime.now());
                DateTime scheduleTime = DateTime.now();
                debugPrint('Notification Scheduled for $scheduleTime');
                NotificationService().scheduleNotification(
                    title: 'Scheduled Notification',
                    body: '$scheduleTime',
                    scheduledNotificationDateTime: scheduleTime);
              },
              child: const Text("test SN")),
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
                // print(await DurationDB.getMonthTotalTime());
                NotificationService()
                    .showNotification(title: 'Sample title', body: 'It works!');
              },
              child: const Text("testN")),
          TextButton(
            onPressed: () async {
              SplayTreeMap? actual = await ClockDB.getTable("workout")
                ?..remove("forecast");
              if (actual != null) {
                SplayTreeMap forecast = SplayTreeMap.from(actual);
                List dates = actual.keys.toList();

                List yHat = ["", "", "", "", "", "", ""];
                Map cache = {};
                for (int i = 0; i < dates.length - 1; i++) {
                  var weekday = DateTime.parse(dates[i]).weekday - 1;

                  // forecast start time
                  if (yHat.contains(weekday)) {
                    yHat[weekday] = Calculator.forecastStartTime(
                        actual[dates[i]], yHat[weekday]);
                  } else {
                    yHat[weekday] = actual[dates[i]];
                  }

                  // write back the forecast if it's in `cache` (i.e. unsaved data)
                  if (cache.containsKey(weekday)) {
                    forecast[dates[i]] = cache[weekday];
                    cache.remove(weekday);
                  }

                  // temporary store the result
                  cache[weekday] = yHat[weekday];
                }
                print("actual:\n$actual");
                print("forecast:\n$forecast");
                print("yHat:\n$yHat");

                List bias = [];
                List pos = [];
                for (int i = 0; i < dates.length; i++) {
                  // calculate the deviation value of the forecast
                  var dev = Calculator.convertToMinutes(forecast[dates[i]]) -
                      Calculator.convertToMinutes(actual[dates[i]]);
                  bias.add(dev);
                  if (dev > 0) pos.add(dev);
                }
                print("bias:\n$bias");

                // analyze the forecasting method's performance
                print("MAE: ${bias.fold(0, (p, c) => c + p) / bias.length}");
                print("遲到通知 ${pos.length / bias.length * 100} %");
                print("平均提前 ${pos.fold(0, (p, c) => c + p) / pos.length} 分鐘");
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

/* userID
  - Mary: "j6QYBrgbLIQH7h8iRyslntFFKV63"
  - John: "1UFfKQ4ONxf5rGQIro8vpcyUM9z1"
*/

class Calendar {
  static String get today => dateToString(DateTime.now());

  static int get todayWeekday => DateTime.now().weekday;

  static DateTime get firstDay => getSunday(DateTime.now());

  static DateTime getSunday(DateTime date) =>
      (date.weekday == 7) ? date : date.subtract(Duration(days: date.weekday));

  // Convert DateTime to String (i.e. plan's key)
  static String dateToString(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  // Convert String to TimeOfDay
  static TimeOfDay stringToTime(String time) => TimeOfDay(
      hour: int.parse(time.substring(0, 2)),
      minute: int.parse(time.substring(3, 5)));

  static String timeToString(TimeOfDay time) =>
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

  // Get a number {duration} of dates from the given date {firstDay}
  static List<String> getWeekFrom(DateTime firstDay, int duration) {
    DateFormat fmt = DateFormat('yyyy-MM-dd');
    List<String> week = List.generate(
        duration, (index) => fmt.format(firstDay.add(Duration(days: index))));
    return week;
  }

  // Check if the given date is within this week
  static bool isThisWeek(DateTime date) =>
      (thisWeek().contains(dateToString(date))) ? true : false;

  // Get next sunday
  static DateTime nextSunday(DateTime today) =>
      (today.weekday == 7) ? today : firstDay.add(const Duration(days: 7));
  // Get the days of week that have already passed
  static List<String> daysPassed() =>
      (todayWeekday != 7) ? getWeekFrom(firstDay, todayWeekday) : [];
  // Get the days of week that are yet to come
  static List<String> daysComing() => getWeekFrom(
      DateTime.now().add(const Duration(days: 1)), 14 - (todayWeekday + 1) % 7);
  // Get the days of week from the first day
  static List<String> thisWeek() => getWeekFrom(firstDay, 7);
  // Get the days of week from the eighth day
  static List<String> nextWeek() =>
      getWeekFrom(firstDay.add(const Duration(days: 7)), 7);
  // Get the days of the following two weeks
  static List<String> bothWeeks() => [...thisWeek(), ...nextWeek()];
}

/*
################################################################################
General Database: database records that occurs occasionally
################################################################################
*/

class UserDB {
  static get uid =>
      FirebaseAuth.instance.currentUser?.uid ?? "j6QYBrgbLIQH7h8iRyslntFFKV63";
  static const db = "users";

  // Define the columns of the user table
  static get columns => [
        "userName",
        "gender",
        "birthday",
        "age",
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
        "mindfulnessLiking",
        "workLiking",
        "kindnessLiking",
        "strengthLiking",
        "cardioLiking",
        "yogaLiking",
        "strengthAbility",
        "cardioAbility",
        "yogaAbility",
      ];

  // Select user from userID
  static Future<Map?> getUser() async {
    var snapshot = await DB.select(db, uid);
    return (snapshot != null)
        ? Map<String, dynamic>.from(snapshot as Map)
        : null;
  }

  // Select workout dynamic data from userID
  static List<Map<String, dynamic>>? toPlanVariables(Map? user, String habit) {
    if (user != null) {
      if (habit == "workout") {
        var likings = {
          'strengthLiking': user["strengthLiking"],
          'cardioLiking': user["cardioLiking"],
          'yogaLiking': user["yogaLiking"],
        };
        var abilities = {
          'strengthAbility': user["strengthAbility"],
          'cardioAbility': user["cardioAbility"],
          'yogaAbility': user["yogaAbility"],
        };

        return [
          {
            'openness': user["openness"],
            'workoutTime': user["workoutTime"],
            'workoutDays': user['workoutDays'].split('').map(int.parse).toList()
          },
          Map.fromEntries(likings.entries.toList()
            ..sort((e1, e2) => e1.value.compareTo(e2.value))),
          Map.fromEntries(abilities.entries.toList()
            ..sort((e1, e2) => e1.value.compareTo(e2.value))),
        ];
      } else if (habit == "meditation") {
        var likings = {
          'mindfulnessLiking': user["mindfulnessLiking"],
          'workLiking': user["workLiking"],
          'kindnessLiking': user["kindnessLiking"],
        };

        return [
          {
            'meditationTime': user["meditationTime"],
            'meditationDays':
                user['meditationDays'].split('').map(int.parse).toList()
          },
          Map.fromEntries(likings.entries.toList()
            ..sort((e1, e2) => e1.value.compareTo(e2.value))),
        ];
      }
    }
    return null;
  }

  // Check if the given date should workout
  static Future<bool> isHabitDay(DateTime date, String workoutDays) async {
    int idx = Calendar.bothWeeks().indexOf(Calendar.dateToString(date));
    idx = (idx >= 7) ? idx - 7 : idx;
    return (workoutDays[idx] == "1") ? true : false;
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

    data["mindfulnessLiking"] += data["neuroticism"] * mMul;
    data["workLiking"] -= data["conscientiousness"] * mMul;
    data["kindnessLiking"] -= data["agreeableness"] * mMul;

    // Calculate user's age
    String birthday = data["birthday"];
    int age = DateTime.now().difference(DateTime.parse(birthday)).inDays ~/ 365;

    // Add userName and age column
    data["userName"] = Data.user!.displayName;
    data["age"] = age;

    // Insert user into database
    return await DB.insert("$db/$uid", data);
  }

  // Update data {columnName: value} from userID
  static Future<bool> update(Map data) async {
    return await DB.update("$db/$uid", data);
  }

  // Update plan variables by user's feedback [滿意度, 疲憊度]
  static Future<bool> updateWorkoutFeedback(String type, List feedback) async {
    String index1 = "${type}Liking", index2 = "${type}Ability";
    List keys = [
      ...["strengthLiking", "cardioLiking", "yogaLiking"],
      ...["strengthAbility", "cardioAbility", "yogaAbility"]
    ];
    Map updateVal = {for (String key in keys) key: Data.profile![key]!};

    // adjust workoutLiking by feedback[0] (i.e. satisfiedScore)
    List adjVal = [-5, -2, 0, 2, 5];
    updateVal[index1] += adjVal[feedback[0] - 1];
    // TODO: the adjusting method when score > 100 needs optimization
    if (updateVal[index1] >= 100) {
      for (String key in keys.sublist(0, 3)) {
        updateVal[key] *= 0.8;
      }
    } else if (updateVal[index1] < 0) {
      updateVal[index1] = 0;
    }
    // adjust workoutAbility by feedback[1] (i.e. tiredScore)
    updateVal[index2] -= adjVal[feedback[1] - 1];
    if (updateVal[index2] >= 100) {
      for (String key in keys.sublist(3, 6)) {
        updateVal[key] *= 0.8;
      }
    } else if (updateVal[index2] < 0) {
      updateVal[index2] = 0;
    }

    return await update(updateVal);
  }

  static Future<bool> updateMeditationFeedback(String type, List feedback) async {
    String index = "${type}Liking";
    List keys = ["mindfulnessLiking", "workLiking", "kindnessLiking"];
    Map updateVal = {for (String key in keys) key: Data.profile![key]!};

    bool overflow = false; // whether the score is over 100

    // adjust meditationLiking by feedback[0] (i.e. satisfiedScore)
    List adjVal = [-5, -2, 0, 2, 5];
    updateVal[index] += adjVal[feedback[0] - 1];

    // adjust meditationLiking by feedback[1~3] (i.e. recentSituation)
    for (int i = 0; i < 3; i++) {
      updateVal[keys[i]] += (feedback[i + 1] == 1) ? 10 : 0;
      if (updateVal[keys[i]] >= 100) overflow = true;
      if (updateVal[keys[i]] < 0) updateVal[keys[i]] = 0;
    }

    // TODO: the adjusting method when score > 100 needs optimization
    if (overflow) {
      for (String key in keys) {
        updateVal[key] *= 0.8;
      }
    }

    return await update(updateVal);
  }

  // Delete data from userName
  static Future<bool> delete() async {
    return await DB.delete(db, uid);
  }
}

class ContractDB {
  static get uid =>
      FirebaseAuth.instance.currentUser?.uid ?? "j6QYBrgbLIQH7h8iRyslntFFKV63";
  static const db = "contract";

  // Define the columns of the user table
  static get columns => [
        "type",
        "content",
        "startDay",
        "endDay",
        "money",
        "bankAccount",
        "gem",
        "succeed",
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

  static Future<bool> updateGem(String habit) async {
    var data = Data.contract?[habit]?["gem"];
    if (data != null) {
      List gem = data.split(", ").map(int.parse).toList();
      return await DB
          .update("$db/$uid/$habit", {"gem": "${++gem[0]}, ${gem[1]}"});
    }
    return false;
  }

  // Delete data from userID
  static Future<bool> delete() async => await DB.delete(db, uid);
  // Delete workout contract from userID
  static Future<bool> deleteWorkout() async =>
      await DB.delete(db, "$uid/workout");
  // Delete meditation contract from userID
  static Future<bool> deleteMeditation() async =>
      await DB.delete(db, "$uid/meditation");
}

class GamificationDB {
  static get uid =>
      FirebaseAuth.instance.currentUser?.uid ?? "j6QYBrgbLIQH7h8iRyslntFFKV63";
  static const db = "gamification";

  // Define the columns of the milestone table
  static get columns => [
        "level",
        "userName",
        "workoutGem", // num
        "meditationGem", // num
        "workoutFragment", // String
        "meditationFragment", // String
        "character", // String
        "friends" // String
      ];

  // Select whole table of gamification
  static Future<Map?> getAll() async {
    var snapshot = await DB.selectAll(db);
    return snapshot?.value as Map?;
  }

  // Select milestone from userID
  static Future<Map?> getGamification() async {
    var snapshot = await DB.select(db, uid);
    return (snapshot != null) ? Map.from(snapshot as Map) : null;
  }

  static Map getChart(String category, {bool isGlobal = true}) {
    Map chart = {Data.user?.uid: Data.game?[category]};

    Data.community?.forEach((key, value) {
      if (!isGlobal && !CommData.friends.contains(key)) return;
      dynamic catVal = value[category];
      // select the last character as character's level
      if (category == "character") {
        catVal = int.parse(catVal[catVal.length - 1]);
      }
      chart[key] = catVal;
    });

    // Sort the chart by descending order
    chart = Map.fromEntries(
        chart.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    // Set the values to user's corresponding rank
    List keys = chart.keys.toList();
    List values = chart.values.toList();
    for (int i = 0; i < chart.length; i++) {
      // Set the rank as the previous if their values are same, else rank++
      int rank = (i == 0) ? 1 : chart[keys[i - 1]][0];
      if (i != 0 && (values[i - 1] != values[i])) rank++;
      // Set the value to the following format: ["rank", "photoUrl", "userName"]
      String uid = keys[i];
      chart[uid] = [
        rank,
        "assets/images/${Data.community?[uid]["character"]}.png",
        Data.community?[uid]["userName"]
      ];
    }
    return chart;
  }

  static String? convertSocialCode(String friendCode) {
    if (Data.community != null) {
      for (MapEntry entry in Data.community!.entries) {
        // check if friendCode fits the first 7 characters of the userIDs
        if (entry.key.substring(0, 7) == friendCode) return entry.key;
      }
    }
    return null;
  }

  static Future<bool> insert(Map userInfo, String character) async {
    int workoutDays = userInfo["workoutDays"]
        .split("")
        .map(int.parse)
        .fold(0, (p, c) => c + p);
    int meditationDays = userInfo["meditationDays"]
        .split("")
        .map(int.parse)
        .fold(0, (p, c) => c + p);
    List values = [
      1,
      userInfo["userName"],
      0,
      0,
      "0, $workoutDays",
      "0, $meditationDays",
      character,
      ""
    ];
    return await DB.insert("$db/$uid", Map.fromIterables(columns, values));
  }

  // Update data {columnName: value} from userID
  static Future<bool> update(Map data) async =>
      await DB.update("$db/$uid", data);

  static Future<bool> updateFriend(String newFriend) async {
    String? friends = Data.game?["friends"];
    friends = (friends != null) ? "$newFriend, $friends" : newFriend;
    return await DB.update("$db/$uid", {"friends": friends});
  }

  static Future<bool> updateCharacterLevel() async {
    String? character = Data.game?["character"];
    int level = int.parse(character![character.length - 1]);
    character = character.replaceAll("$level", "${level + 1}");
    return await DB.update("$db/$uid", {"character": character});
  }

  // Update fragment or gem whenever user completes a plan
  static Future<bool> updateFragment(String habit) async {
    Map? table = Data.game;
    if (table != null) {
      List fragment =
          table["${habit}Fragment"].split(", ").map(int.parse).toList();
      if (fragment[0] == fragment[1]) {
        // 當 fragment 前後兩個數字相同，歸零，gem 加一
        // ContractDB 的 gem 加一
        table["${habit}Gem"]++;
        table["${habit}Fragment"] = "0, ${fragment[1]}";
        // TODO: only update gem when the week is end
        return await update(table) && await ContractDB.updateGem(habit);
      } else {
        // 當 fragment 前後兩個數字不同，第一個數字加一
        return await DB.update("$db/$uid",
            {"${habit}Fragment": "${++fragment[0]}, ${fragment[1]}"});
      }
    }
    return false;
  }

  static Future<bool> resetFragment() async {
    Map? table = Data.profile;
    if (table != null) {
      int wDays =
          List<int>.from(table["workoutDays"].split("").map(int.parse)).sum;
      int mDays =
          List<int>.from(table["meditationDays"].split("").map(int.parse)).sum;

      return await DB.update("$db/$uid", {"workoutFragment": "0, $wDays"}) &&
          await DB.update("$db/$uid", {"meditationFragment": "0, $mDays"});
    }
    return false;
  }

  // Delete data from userName
  static Future<bool> delete() async {
    return await DB.delete(db, uid);
  }
}

class HabitDB {
  static get uid =>
      FirebaseAuth.instance.currentUser?.uid ?? "j6QYBrgbLIQH7h8iRyslntFFKV63";
  static const db = "s";

  // Select all workouts
  static Future<Map?> getAll(String habit) async {
    var snapshot = await DB.selectAll("$habit$db");
    return snapshot?.value as Map?;
  }

  // Select workoutIDs
  static Map? categorize(String habit, Map? habitTable) {
    List ids = habitTable!.keys.toList();
    Map? retVal;

    if (habit == "workout") {
      retVal = {
        "strength": [[], [], [], [], []],
        "cardio": [[], [], []],
        "yoga": [[], [], [], [], []],
        "warmUp": [],
        "coolDown": []
      };
      List keys = retVal.keys.toList();

      // Get the list of workoutID from the given type and difficulty
      for (int type = 1; type <= 3; type++) {
        for (int diff = 1; diff <= ((type == 2) ? 3 : 5); diff++) {
          retVal[keys[type - 1]][diff - 1] = List.from(
              ids.where((item) => item[0] == "$type" && item[1] == "$diff"));
        }
      }
      for (int type = 4; type <= 5; type++) {
        retVal[keys[type - 1]] =
            List.from(ids.where((item) => item[0] == "$type"));
      }
    } else if (habit == "meditation") {
      retVal = {
        "mindfulness": [[], [], [], [], [], [], []],
        "work": [[], [], [], [], [], [], []],
        "kindness": [[], [], [], [], [], [], []],
        "sleep": [[], [], [], [], [], [], []],
      };
      List keys = retVal.keys.toList();

      // Get the list of workoutID from the given type and difficulty
      for (int category = 1; category <= 4; category++) {
        for (int type = 1; type <= 7; type++) {
          retVal[keys[category - 1]][type - 1] = List.from(ids
              .where((item) => item[0] == "$category" && item[1] == "$type"));
        }
      }
    }

    return retVal;
  }

  // Update data {columnName: value} from workoutID
  static Future<bool> update(String habit, Map data) async {
    return await DB.update("$habit$db", data);
  }

  // Delete data from workoutId
  static Future<bool> delete(String habit, String habitID) async {
    return await DB.delete("$habit$db", habitID);
  }
}

/*
################################################################################
Journal Database: database records that occurs daily
################################################################################
*/

class PlanDB {
  static get uid =>
      FirebaseAuth.instance.currentUser?.uid ?? "j6QYBrgbLIQH7h8iRyslntFFKV63";
  static const table = "Plan";

  // Format the String of plan into List of workouts, grouped by workout sets
  static List toWorkoutList(String planStr) {
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
  static Future<SplayTreeMap?> getTable(String habit) async =>
      await JournalDB.getTable(uid, "$habit$table");

  // Select the user's plan from the dates of given week
  static Future<Map?> getThisWeek(String habit) async =>
      await JournalDB.getThisWeek(uid, "$habit$table");

  static Future<Map?> getNextWeek(String habit) async =>
      await JournalDB.getNextWeek(uid, "$habit$table");

  // Select user's workout plan from given dates
  static Future<Map?> getFromDates(String habit, List<String> dates) async =>
      await JournalDB.getFromDates(uid, dates, "$habit$table");

  static Future<String?> getFromDate(String habit, DateTime date) async =>
      await JournalDB.getFromDate(uid, date, "$habit$table");

  static String? toPlanType(String habit,
      {String? date, String? plan, bool zh = false}) {
    date = date ?? Calendar.today;
    String? planStr = plan ?? Data.plans?[habit]?[date];
    if (habit == "workout") {
      // The third element of the plan is the first workout after the warmup,
      // and its first character's index (which indicates the workout type) is 18.
      switch (planStr?[18]) {
        case '1':
          return (zh) ? "肌力運動" : "strength";
        case '2':
          return (zh) ? "有氧運動" : "cardio";
        case '3':
          return (zh) ? "瑜珈運動" : "yoga";
        default:
          return null;
      }
    } else if (habit == "meditation") {
      // the first character indicates the meditation type
      switch (planStr?[0]) {
        case '1':
          return (zh) ? "正念冥想" : "mindfulness";
        case '2':
          return (zh) ? "工作冥想" : "work";
        case '3':
          return (zh) ? "慈心冥想" : "kindness";
        case '4':
          return (zh) ? "睡眠冥想" : "sleep";
        default:
          return null;
      }
    }
    return null;
  }

  // Update plan data {date: plan} from table {table/userID/plan/date}
  static Future<bool> update(String habit, Map<String, String> data) async =>
      await JournalDB.update(uid, data, "$habit$table") &&
      await DurationDB.update(habit, data.map((key, value) {
        return MapEntry(key,
            "0, ${(habit == "workout") ? value.split(", ").length : Data.profile!["meditationTime"]}");
      }));

  // Update the plan's date to given date (coming days of current week)
  static Future<bool> updateDate(
      String habit, DateTime original, DateTime modified) async {
    // The map is constituted by the modified date and the original plan
    String? plan = await getFromDate(habit, original);
    if (plan != null) {
      Map<String, String> map = {Calendar.dateToString(modified): plan};
      // Delete the original record, and update with the modified date
      return await delete(habit, Calendar.dateToString(original)) &&
          await update(habit, map);
    }
    return false;
  }

  // Delete plan data {table/userID/plan/date}
  static Future<bool> delete(String habit, String date) async =>
      await JournalDB.delete(uid, date, "$habit$table") &&
      await DurationDB.delete(habit, date);

  static Future<bool> deleteAll() async => await DB.delete("journal", uid);
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
    // if the difference between both time is less than 12 hrs,
    // then add 24 hrs to the smaller variable
    if ((y - yHat).abs() > 720) {
      if (y > yHat) {
        yHat += 1440;
      } else {
        y += 1440;
      }
    }
    // make prediction by exponential smoothing method
    num pred = alpha * y + (1 - alpha) * yHat;
    // return result
    String hh = "${pred ~/ 60 % 24}".padLeft(2, "0"); // 24小時制
    String mm = "${(pred % 60).round()}".padLeft(2, "0");
    print("debug: f($y,$yHat) = $pred -> $hh:$mm");
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
            Calendar.dateToString(sunday),
            Calendar.dateToString(sunday.add(const Duration(days: 6))),
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
            Calendar.dateToString(dayOne),
            Calendar.dateToString(nextDayOne.subtract(const Duration(days: 1))),
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

  // Add up the total number of habit committed days for each week
  static List? getWeekTotalDays(SplayTreeMap? durations) {
    List retVal = []; // store the results

    if (durations != null) {
      List<DateTime> dates =
          durations.keys.map((d) => DateTime.parse(d)).toList();
      List values = durations.values.toList();

      List<int> success = []; // store the completion status of the workoutPlans
      for (var duration in values) {
        List record = duration.split(", ");
        // the 1st element of `record` is the completed minutes, and the 2nd element is the total minutes
        // if the plan is completed (i.e. 1st element == 2nd), then set the status to 1 otherwise set to 0, and add to `success`
        success.add((record[0] == record[1]) ? 1 : 0);
      }

      DateTime sunday = Calendar.getSunday(dates.first); // 1st day of each week
      int count = 0; // the sum of habit days for the given month
      for (int i = 0; i < dates.length; i++) {
        if (dates[i].difference(sunday).inDays < 7) {
          count += success[i];
        } else {
          // store the result to `retVal` when the difference to `sunday` is more than 7 days (1 week)
          retVal.add([Calendar.dateToString(sunday), count]);
          // reset variables for next iteration
          sunday = sunday.add(const Duration(days: 7));
          count = success[i];
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

      List<int> success = []; // store the completion status of the workoutPlans
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
          // store the result to `retVal` when the difference to `dayOne` is more than 1 month
          retVal.add([Calendar.dateToString(dayOne), count]);

          // reset variables for next iteration
          dayOne = DateTime(dayOne.year, dayOne.month + 1, 1);
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
            Calendar.dateToString(dayOne),
            Calendar.dateToString(nextDayOne.subtract(const Duration(days: 1))),
            count
          ]);

          // reset variables for next iteration
          dayOne = nextDayOne;
          count = success[i];
        }
      }

      if (retVal.isEmpty) {
        retVal.add([
          Calendar.dateToString(dayOne),
          Calendar.dateToString(DateTime(dayOne.year + 1, 1, 1)),
          count
        ]);
      }

      return retVal;
    }
    return null;
  }
}

class DurationDB {
  static get uid =>
      FirebaseAuth.instance.currentUser?.uid ?? "j6QYBrgbLIQH7h8iRyslntFFKV63";
  static const table = "Duration";

  // Select all durations
  static Future<SplayTreeMap?> getTable(String habit) async =>
      await JournalDB.getTable(uid, "$habit$table");

  // Select user's workout duration from given date
  static Future<int?> getFromDate(String habit, DateTime date) async {
    var duration = await JournalDB.getFromDate(uid, date, "$habit$table");
    return (duration != null) ? int.parse(duration.split(', ')[0]) : null;
  }

  // Update duration data {date: "duration, timeSpan"} from table {table/userID/duration/date}
  static Future<bool> update(String habit, Map data) async {
    String key = data.keys.first;
    String value = data.values.first.toString();

    if (value.contains(", ")) {
      // value: "duration, timeSpan"
      return await JournalDB.update(uid, data, "$habit$table");
    } else {
      // value: "duration"
      var record = Data.durations?[habit]?[key];
      if (record != null) {
        String timeSpan = record.split(', ')[1];
        return await JournalDB.update(
            uid, {key: "$value, $timeSpan"}, "$habit$table");
      }
    }
    return false;
  }

  // Delete duration data {table/userID/duration/date}
  static Future<bool> delete(String habit, String date) async =>
      await JournalDB.delete(uid, date, "$habit$table");
}

class ClockDB {
  static get uid =>
      FirebaseAuth.instance.currentUser?.uid ?? "j6QYBrgbLIQH7h8iRyslntFFKV63";
  static const table = "Clock";

  // Select all start time records
  static Future<SplayTreeMap?> getTable(String habit) async =>
      await JournalDB.getTable(uid, "$habit$table");

  // Select user's start time from given dates
  static Future<Map?> getFromDates(String habit, List<String> dates) async =>
      await JournalDB.getFromDates(uid, dates, "$habit$table");

  static Future<String?> getFromDate(String habit, DateTime date) async {
    var startTime = await JournalDB.getFromDate(uid, date, "$habit$table");
    return (startTime != null) ? startTime : null;
  }

  // Get the start time prediction
  static Future<String?> getPrediction(String habit, int weekday) async {
    String? time = await DB.select(
        "journal/$uid/$habit$table", "forecast_$weekday") as String?;
    return (time != null) ? time : null;
  }

  static Future<Map?> getPredictions(String habit) async {
    var table = await getTable(habit);
    if (table != null) {
      return {
        for (int weekday = 0; weekday <= 6; weekday++)
          "forecast_$weekday": table["forecast_$weekday"]
      };
    }
    return null;
  }

  // Update start time data {date: "09:00"} from table {table/userID/clock/date}
  // Update when user first start the video/audio in that day
  static Future<bool> update(String habit, Map<String, String> data) async =>
      await JournalDB.update(uid, data, "$habit$table");

  // Update the forecast data {"forecast": "09:00"} from table {table/userID/clock/forecast}
  static Future<bool> updateForecast(String habit) async {
    DateTime today = DateTime.now();
    String? actualTime = Calendar.timeToString(TimeOfDay.now());
    String? predictedTime = await getPrediction(habit, today.weekday % 7);
    if (predictedTime != null) {
      // Forecast notification time
      String forecast = Calculator.forecastStartTime(actualTime, predictedTime);

      // Schedule notification time
      List duration = forecast.split(":").map(int.parse).toList();
      DateTime nextWeekDay = today.add(const Duration(days: 7));
      NotificationService().scheduleNotification(
        title: '該開始${(habit == "workout") ? "運動" : "冥想"}了!',
        body: '加油',
        scheduledNotificationDateTime: DateTime(nextWeekDay.year,
            nextWeekDay.month, nextWeekDay.day, duration[0], duration[1]),
      );

      // Update forecast and actual start time to ClockDB
      return update(habit, {
        "forecast_${today.weekday % 7}": forecast,
        Calendar.dateToString(today): actualTime
      });
    } else {
      // Update actual start time to ClockDB
      return update(habit, {Calendar.dateToString(today): actualTime});
    }
  }

  // Delete start time data {table/userID/clock/date}
  static Future<bool> delete(String habit, String date) async =>
      await JournalDB.delete(uid, date, "$habit$table");
}

class WeightDB {
  static get uid =>
      FirebaseAuth.instance.currentUser?.uid ?? "j6QYBrgbLIQH7h8iRyslntFFKV63";
  static const table = "weight";

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
