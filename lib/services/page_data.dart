import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:g12/services/database.dart';
import 'package:g12/services/plan_algo.dart';

// ignore_for_file: avoid_print

class Data {
  // updatingDB is true if database is updating
  static bool updatingDB = false;
  // updatingUI is true if the five component of the bottom navigation bar needs to be updated
  static List<bool> updatingUI = [false, false, false, false, false];
  static List habitTypes = ["workout", "meditation"];
  static User? user = FirebaseAuth.instance.currentUser;
  static String characterImageURL = "";
  static String characterName = "";

  // general database records:
  static Map? profile; // whole user profile from UserDB
  static Map? game; // user's gamification data from GamificationDB
  static Map? community; // gamification table with all user
  static Map? contract; // user's contract data from ContractDB
  static Map<String, SplayTreeMap>? plans; // user's every plan record
  static Map<String, SplayTreeMap>? durations; // user's every duration record
  // specific database records:
  static SplayTreeMap? weights; // user's every weight record
  static Map? predClocks; // user's every clock record
  static Map? habits;

  static Future<void> init() async {
    print("initializing data");
    user = FirebaseAuth.instance.currentUser;
    if (Data.user != null) {
      // fetch data from database
      await fetchProfile();
      await fetchHabits();
      await fetchPlansAndDurations();
      await fetchGame();
      await fetchCharacter();
      await fetchContract();
      await fetchWeights();
      await fetchClocks();
      // update UI
      await HomeData.fetch();
      await StatData.fetch();
      await GameData.fetch();
      await SettingsData.fetch();
      // execute plan algorithm
      await PlanAlgo.execute();
    }
  }

  static Future<void> fetchCharacter() async {
    if (Data.updatingDB) await fetchGame();
    String character = game?["character"] ?? "Rabbit_2";
    characterImageURL = "assets/images/$character.png";
    characterName = character.substring(0, character.length - 2);
  }

  static Future<void> fetchProfile() async {
    // set HomePage and SettingsPage to true
    updatingUI[2] = true;
    updatingUI[4] = true;
    // fetch user profile
    profile = await UserDB.getUser();
  }

  static Future<void> fetchGame() async {
    // set GamificationPage and CommunityPage to true
    updatingUI[1] = true;
    updatingUI[3] = true;
    // fetch gamification data
    community = await GamificationDB.getAll();
    game = community![user!.uid];
  }

  static Future<void> fetchContract() async {
    // set GamificationPage to true
    updatingUI[1] = true;
    // fetch commitment contracts
    contract = await ContractDB.getContract();
  }

  static Future<void> fetchPlans() async {
    Map temp = {};
    for (String habit in habitTypes) {
      temp[habit] = await PlanDB.getTable(habit);
    }
    temp.removeWhere((key, value) => value == null);
    if (temp.isNotEmpty) plans = temp.cast<String, SplayTreeMap>();
  }

  static Future<void> fetchDurations() async {
    Map temp = {};
    for (String habit in habitTypes) {
      temp[habit] = await DurationDB.getTable(habit);
    }
    temp.removeWhere((key, value) => value == null);
    if (temp.isNotEmpty) durations = temp.cast<String, SplayTreeMap>();
  }

  static Future<void> fetchPlansAndDurations() async {
    // set HomePage, GamificationPage and StatisticPage to true
    updatingUI[0] = true;
    updatingUI[1] = true;
    updatingUI[2] = true;
    // fetch user's habit plans and execution records
    await fetchPlans();
    await fetchDurations();
  }

  static Future<void> fetchWeights() async {
    // set StatisticPage to true
    updatingUI[0] = true;
    // fetch user's weights
    weights = await WeightDB.getTable();
  }

  static Future<void> fetchHabits() async {
    Map temp = {};
    for (String habit in habitTypes) {
      temp[habit] = await HabitDB.getAll(habit);
    }
    temp.removeWhere((key, value) => value == null);
    if (temp.isNotEmpty) habits = temp;
  }

  static Future<void> fetchClocks() async {
    // set SettingsPage to true
    updatingUI[4] = true;
    // fetch user's starting time of the habit plan
    Map temp = {};
    for (String habit in habitTypes) {
      temp[habit] = await ClockDB.getPredictions(habit);
    }
    temp.removeWhere((key, value) => value == null);
    if (temp.isNotEmpty) predClocks = temp;
  }
}

// plan_algo.dart
class PlanData {
  // similar variables:
  static bool? thisWeek;
  static Map<String, dynamic> likings = {};
  static Map<String, dynamic> habitDays = {};
  static int habitDuration = 15;
  static int sumLikings = 0, sumHabitDays = 0;
  static Map habitIDs = {};
  // workout-specific variables:
  static Map<String, dynamic> abilities = {};
  static String mostLike = '', leastLike = '';
  static String bestAbility = '', worstAbility = '';
  static int sumAbilities = 0, repetition = 0;

  // database records:
  static List<Map<String, dynamic>>? planVariables;

  static Future<void> fetch(
      {required String habit, bool thisWeek = true}) async {
    if (Data.updatingDB) {
      await Data.fetchProfile();
      Data.updatingDB = false;
    }

    habitIDs = HabitDB.categorize(habit, Data.habits?[habit])!;
    planVariables = UserDB.toPlanVariables(Data.profile, habit);
    processData(habit: habit, data: planVariables, thisWeek: thisWeek);
  }

  static void processData(
      {required String habit, required List? data, required bool thisWeek}) {
    if (data == null) return;

    habitDuration = data[0]['${habit}Time'];
    habitDays = Map.fromIterables(
        (thisWeek) ? Calendar.thisWeek() : Calendar.nextWeek(),
        data[0]['${habit}Days']);
    likings = data[1];
    sumHabitDays = habitDays.values.fold(0, (p, c) => c + p);
    sumLikings = likings.values.fold(0, (p, c) => c + p);

    // workout-specific
    if (habit == "workout") {
      abilities = data[2];
      sumAbilities = abilities.values.fold(0, (p, c) => c + p);

      mostLike = likings.keys.last;
      leastLike = likings.keys.first;
      bestAbility = abilities.keys.last;
      worstAbility = abilities.keys.first;

      var openness = data[0]['openness'];
      if (openness < 0) {
        repetition = 3;
        if (habitDuration == 30) repetition = 2;
      } else if (openness == 1) {
        repetition = 2;
      }
      if (habitDuration == 60 && openness == -2) repetition = 4;
    }
  }
}

class HomeData {
  static bool isFetchingData = true;

  // Plan 相關資料
  static Map workoutPlanList = {};
  static Map workoutProgressList = {};
  static String? workoutPlan;
  static int? workoutProgress;
  static int currentIndex = 0;
  static int workoutDuration = 0;

  //Meditation Plan 相關資料
  static Map meditationPlanList = {};
  static Map meditationProgressList = {};
  static String? meditationPlan;
  static int? meditationProgress;
  static int meditationDuration = 0;

  // Calendar 相關設定
  static DateTime today = DateTime.now();
  static DateTime focusedDay = DateTime.now();
  static DateTime? selectedDay = DateTime.now();
  static String time = "今天";
  static DateTime firstDay = Calendar.firstDay;
  static DateTime lastDay = firstDay.add(const Duration(days: 13));
  static bool isThisWeek = Calendar.isThisWeek(selectedDay!);
  static bool isBefore = false;
  static bool isAfter = false;
  static bool isToday = true;

  static Future<void> fetch() async {
    print("Refreshing HomePage...");
    isFetchingData = true;

    if (Data.updatingDB) {
      await Data.fetchPlansAndDurations();
      await Data.fetchProfile();
      await Data.fetchGame();
      Data.updatingDB = false;
    }

    List twoWeeks = Calendar.bothWeeks();
    for (String habit in ["workout", "meditation"]) {
      setPlanList(habit: habit, twoWeeks: twoWeeks);
      setProgressList(habit: habit, twoWeeks: twoWeeks);
    }
    setSelectedDay();

    Data.updatingUI[2] = false;
    isFetchingData = false;
  }

  static void setPlanList({required String habit, required List twoWeeks}) {
    Map plans = {
      for (String date in twoWeeks) date: Data.plans?[habit]?[date]?.split(", ")
    };
    plans.removeWhere((key, value) => value == null);

    if (plans.isNotEmpty) {
      plans = plans.map((date, plan) => MapEntry(
          date, plan.map((value) => Data.habits?[habit]?[value]).join(", ")));
      if (habit == "workout") {
        workoutPlanList = plans;
      } else {
        meditationPlanList = plans;
      }
    }
  }

  static void setProgressList({required String habit, required List twoWeeks}) {
    Map durations = {
      for (String date in twoWeeks) date: Data.durations?[habit]?[date]
    };
    durations.removeWhere((key, value) => value == null);

    if (durations.isNotEmpty) {
      durations
          .updateAll((key, value) => Calculator.calcProgress(value).round());
      if (habit == "workout") {
        workoutProgressList = durations;
      } else {
        meditationProgressList = durations;
      }
    }
  }

  static void setSelectedDay() {
    // set variables for today
    String tdDate = Calendar.today;
    var tdDur =
        Data.durations?["workout"]?[tdDate]?.split(", ")?.map(int.parse);
    currentIndex = tdDur?.first ?? 0;
    workoutDuration = tdDur?.last ?? 0;
    tdDur = Data.durations?["meditation"]?[tdDate]?.split(", ")?.map(int.parse);
    meditationDuration = tdDur?.last ?? 0;

    // set variables for selectedDay
    String selectedDate = Calendar.dateToString(selectedDay!);
    String today = Calendar.today;
    workoutPlan = workoutPlanList[selectedDate];
    workoutProgress = workoutProgressList[selectedDate];
    meditationPlan = meditationPlanList[selectedDate];
    meditationProgress = meditationProgressList[selectedDate];
    isBefore = selectedDate.compareTo(today) == -1;
    isAfter = selectedDate.compareTo(today) == 1;
    isToday = selectedDate.compareTo(today) == 0;
    time = (isToday) ? "今天" : " ${selectedDay!.month} / ${selectedDay!.day} ";

    isFetchingData = false;
  }
}

class SettingsData {
  static Map userData = {};
  static Map timeForecast = {};
  static String habitType = ""; // e.g. workout, meditation
  static String habitTypeZH = ""; // habitType in Chinese
  static String profileType =
      ""; // the type of profile data that user is modifying

  static Future<void> fetch() async {
    print("Refreshing SettingsPage...");
    if (Data.updatingDB) {
      await Data.fetchClocks();
      await Data.fetchProfile();
      Data.updatingDB = false;
    }

    userData = Map.from(Data.profile ?? {});
    userData["workoutDays"] =
        userData["workoutDays"].split("").map(int.parse).toList();
    userData["meditationDays"] =
        userData["meditationDays"].split("").map(int.parse).toList();
    userData["workoutGoals"] = userData["workoutGoals"].split(", ");
    userData["meditationGoals"] = userData["meditationGoals"].split(", ");

    timeForecast["workoutClock"] = Data.predClocks?["workout"];
    timeForecast["meditationClock"] = Data.predClocks?["meditation"];
    timeForecast.removeWhere((key, value) => value == null);

    Data.updatingUI[4] = false;
  }

  static void isSettingWorkout() {
    habitType = "workout";
    habitTypeZH = "運動";
  }

  static void isSettingMeditation() {
    habitType = "meditation";
    habitTypeZH = "冥想";
  }

  static void isSettingDisplayName() {
    profileType = "暱稱";
  }

  static void isSettingPhotoURL() {
    profileType = "照片";
  }

  static void isSettingPassword() {
    profileType = "密碼";
  }
}

class StatData {
  // 體重
  static List<double> weightDataList = [0.0];
  static Map<String, double> weightDataMap = {};
  static double weight = 0.0;
  static double avgWeight = 0.0;
  static double minY = 0.0;
  static double maxY = 0.0;

  // 計畫進度
  static Map<DateTime, int> exerciseCompletionRateMap = {};
  static Map<DateTime, int> meditationCompletionRateMap = {};

  //連續完成天數
  static List consecutiveExerciseDaysList = [];
  static List consecutiveMeditationDaysList = [];
  static double continuousExerciseDays = 0;
  static double continuousMeditationDays = 0;

  //累積時長
  static Map<String, int> exerciseTypeCountMap = {
    "cardio": 0,
    "yoga": 0,
    "strength": 0,
  };
  static Map<String, double> exerciseTypePercentageMap = {};
  static List percentageExerciseList = [];

  static Map<String, int> meditationTypeCountMap = {
    "mindfulness": 0,
    "work": 0,
    "kindness": 0,
  };
  static Map<String, double> meditationTypePercentageMap = {};
  static List percentageMeditationList = [];

  // 每月成功天數
  static List exerciseMonthDaysList = [];
  static List meditationMonthDaysList = [];
  static double maxExerciseDays = 0;
  static double maxMeditationDays = 0;

  static int planProgress = 0;
  static int consecutiveDays = 0;
  static int accumulatedTime = 0;
  static int monthDays = 0;

  static Future<void> fetch({bool isAddingWeight = false}) async {
    print("Refreshing StatisticPage...");
    if (Data.updatingDB) {
      await Data.fetchWeights();
      await Data.fetchPlansAndDurations();
      Data.updatingDB = false;
    }

    setWeightData();
    if (!isAddingWeight) {
      // no need to fetch other data when only weight is updated
      setPlanCompletionData();
      setConsecutiveDaysData();
      setCumulativeTimeData();
      setMonthSuccessData();
    }

    Data.updatingUI[0] = false;
  }

  // 體重圖表
  static void setWeightData() {
    var weight = Data.weights; // Fetch user's data from firebase
    if (weight != null) {
      weightDataMap =
          weight.map((key, value) => MapEntry(key as String, value.toDouble()));
      // 照時間順序排
      weightDataMap = Map.fromEntries(weightDataMap.entries.toList()
        ..sort((e1, e2) => e1.key.compareTo(e2.key)));

      weightDataList = weightDataMap.values.toList();
    }
    minY = weightDataList.reduce(min);
    maxY = weightDataList.reduce(max);
    for (int i = 1; i <= 5; i++) {
      if ((minY - i) % 5 == 0) {
        minY = minY - i;
        break;
      }
    }
    for (int i = 1; i <= 5; i++) {
      if ((maxY + i) % 5 == 0) {
        maxY = maxY + i;
        break;
      }
    }
    avgWeight = weightDataList.average;
  }

  // 計畫進度圖表
  static void setPlanCompletionData() {
    var exerciseDuration = Data.durations?["workout"];
    if (exerciseDuration != null) {
      for (MapEntry entry in exerciseDuration.entries) {
        var exerciseDate = DateTime.parse(entry.key);
        exerciseCompletionRateMap[exerciseDate] =
            (Calculator.calcProgress(entry.value).round() == 100) ? 2 : 1;
      }
    }

    var meditationDuration = Data.durations?["meditation"];
    if (meditationDuration != null) {
      for (MapEntry entry in meditationDuration.entries) {
        var meditationDate = DateTime.parse(entry.key);
        meditationCompletionRateMap[meditationDate] =
            (Calculator.calcProgress(entry.value).round() == 100) ? 2 : 1;
      }
    }
  }

  // 連續成功天數圖表
  static void setConsecutiveDaysData() {
    var exerciseDuration = Data.durations?["workout"];
    if (exerciseDuration != null) {
      DateTime? startDate;
      DateTime? endDate;
      for (MapEntry entry in exerciseDuration.entries) {
        var exercise = DateTime.parse(entry.key);
        int completionStatus =
            (Calculator.calcProgress(entry.value).round() == 100) ? 2 : 1;

        if (completionStatus == 2) {
          if (continuousExerciseDays == 0) {
            startDate = exercise;
          }
          continuousExerciseDays++;
          endDate = exercise;
        } else {
          if (continuousExerciseDays >= 2) {
            consecutiveExerciseDaysList
                .add([startDate, endDate, continuousExerciseDays]);
          }
          continuousExerciseDays = 0;
        }
        exerciseCompletionRateMap[exercise] = completionStatus;
      }
      if (continuousExerciseDays >= 2) {
        consecutiveExerciseDaysList
            .add([startDate, endDate, continuousExerciseDays]);
      }
      continuousExerciseDays = 0;
    }

    var meditationDuration = Data.durations?["meditation"];
    if (meditationDuration != null) {
      DateTime? startDate;
      DateTime? endDate;
      for (MapEntry entry in meditationDuration.entries) {
        var meditation = DateTime.parse(entry.key);
        int completionStatus =
            (Calculator.calcProgress(entry.value).round() == 100) ? 2 : 1;

        if (completionStatus == 2) {
          if (continuousMeditationDays == 0) {
            startDate = meditation;
          }
          continuousMeditationDays++;
          endDate = meditation;
        } else {
          if (continuousMeditationDays >= 2) {
            consecutiveMeditationDaysList
                .add([startDate, endDate, continuousMeditationDays]);
          }
          continuousMeditationDays = 0;
        }
        meditationCompletionRateMap[meditation] = completionStatus;
      }
      if (continuousMeditationDays >= 2) {
        consecutiveMeditationDaysList
            .add([startDate, endDate, continuousMeditationDays]);
      }
      continuousMeditationDays = 0;
    }
  }

  // 累積時長圖表
  static void setCumulativeTimeData() {
    var exerciseDuration = Data.durations?["workout"];
    var exercisePlan = Data.plans?["workout"];
    if (exerciseDuration != null && exercisePlan != null) {
      for (MapEntry entry in exerciseDuration.entries) {
        var exerciseDate = entry.key;
        int completionStatus =
            (Calculator.calcProgress(entry.value).round() == 100) ? 2 : 1;

        if (completionStatus == 2) {
          var type = PlanDB.toPlanType("workout", exerciseDate) ?? "unknown";
          if (exerciseTypeCountMap.containsKey(type)) {
            exerciseTypeCountMap[type] = exerciseTypeCountMap[type]! + 1;

            int totalExerciseTypeCount =
                exerciseTypeCountMap.values.reduce((sum, count) => sum + count);

            exerciseTypeCountMap.forEach((type, count) {
              double percentage = (count / totalExerciseTypeCount) * 100;
              exerciseTypePercentageMap[type] = percentage;
              percentageExerciseList.add([type, percentage.toInt()]);
            });
          }
        }
      }
    }

    var meditationDuration = Data.durations?["meditation"];
    var meditationPlan = Data.plans?["meditation"];
    if (meditationDuration != null && meditationPlan != null) {
      for (MapEntry entry in meditationDuration.entries) {
        var meditationDate = entry.key;
        int completionStatus =
            (Calculator.calcProgress(entry.value).round() == 100) ? 2 : 1;

        if (completionStatus == 2) {
          var type =
              PlanDB.toPlanType("meditation", meditationDate) ?? "unknown";
          if (meditationTypeCountMap.containsKey(type)) {
            meditationTypeCountMap[type] = meditationTypeCountMap[type]! + 1;

            int totalMeditationTypeCount = meditationTypeCountMap.values
                .reduce((sum, count) => sum + count);

            meditationTypeCountMap.forEach((type, count) {
              double percentage = (count / totalMeditationTypeCount) * 100;
              meditationTypePercentageMap[type] = percentage;
              percentageMeditationList.add([type, percentage.toInt()]);
            });
          }
        }
      }
    }
  }

  // 每月成功天數圖表
  static void setMonthSuccessData() {
    exerciseMonthDaysList =
        Calculator.getMonthTotalDays(Data.durations?["workout"]) ?? [];
    meditationMonthDaysList =
        Calculator.getMonthTotalDays(Data.durations?["meditation"]) ?? [];

    List<double> exerciseDays = [];
    for (int i = 0; i < exerciseMonthDaysList.length; i++) {
      exerciseDays.add(exerciseMonthDaysList[i][2].toDouble());
    }
    maxExerciseDays = exerciseDays.reduce(max) + 10;

    List<double> meditationDays = [];
    for (int i = 0; i < meditationMonthDaysList.length; i++) {
      meditationDays.add(meditationMonthDaysList[i][2].toDouble());
    }
    maxMeditationDays = meditationDays.reduce(max) + 10;
  }
}

class GameData {
  static int workoutGem = 0;
  static int meditationGem = 0;
  static double workoutPercent = 0;
  static double meditationPercent = 0;
  static double totalPercent = 0;

  static Future<void> fetch() async {
    print("Refreshing GamificationPage...");
    if (Data.updatingDB) {
      await Data.fetchGame();
      await Data.fetchContract();
      Data.updatingDB = false;
    }

    if (Data.game != null) {
      workoutGem = Data.game?["workoutGem"];
      meditationGem = Data.game?["meditationGem"];
      workoutPercent =
          Calculator.calcProgress(Data.game?["workoutFragment"]).toDouble();
      meditationPercent =
          Calculator.calcProgress(Data.game?["meditationFragment"]).toDouble();
      totalPercent = (workoutGem + meditationGem) / 48 * 100;
    }

    Data.updatingUI[1] = false;
  }
}

class CommData {
  static String socialCode = "";
  static int level = 0;
  static List friends = [];
  static String currentFriend = ""; // the friend that user is checking status

  static Future<void> fetch() async {
    print("Refreshing CommunityPage...");
    if (Data.updatingDB) {
      await Data.fetchGame();
      Data.updatingDB = false;
    }

    if (Data.game != null) {
      socialCode = Data.user!.uid.substring(0, 7);
      level = Data.game?["level"];
      friends = Data.game?["friends"].split(", ");
    }

    Data.updatingUI[3] = false;
  }
}

class FriendData {
  static String userName = "", socialCode = "", character = "";
  static int level = 0, characterLevel = 0, workoutGem = 0, meditationGem = 0;
  static int workoutCumulativeTime = 0, meditationCumulativeTime = 0;
  static int workoutCumulativeDays = 0, medicationCumulativeDays = 0;

  static Future<void> fetch() async {
    Map info = Data.community?[CommData.currentFriend];
    userName = info["userName"];
    socialCode = CommData.currentFriend.substring(0, 7);
    character = info["character"];
    level = info["level"];
    characterLevel = int.parse(character[character.length - 1]);
    workoutGem = info["workoutGem"];
    meditationGem = info["meditationGem"];
  }
}