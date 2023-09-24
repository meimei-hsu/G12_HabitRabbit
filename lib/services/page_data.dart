import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:g12/services/database.dart';

// ignore_for_file: avoid_print

class Data {
  static bool updated = false; // true if database is updated
  static User? user = FirebaseAuth.instance.currentUser;

  // general database records:
  static Map? profile; // whole user profile from UserDB
  static Map? game; // user's gamification data from GamificationDB
  static Map? contract; // user's contract data from ContractDB
  static Map<String, SplayTreeMap>? plans; // user's every plan record
  static Map<String, SplayTreeMap>? durations; // user's every duration record
  // specific database records:
  static SplayTreeMap? weights; // user's every weight record

  static Future<void> init() async {
    await fetchPlansAndDurations();
    await fetchGame();
    await fetchContract();
    await fetchProfile();
    await fetchWeights();
  }

  static Future<void> fetchProfile() async {
    profile = await UserDB.getUser();
  }

  static Future<void> fetchGame() async {
    game = await GamificationDB.getGamification();
  }

  static Future<void> fetchContract() async {
    contract = await ContractDB.getContract();
  }

  static Future<void> fetchPlans() async {
    Map temp = {};
    temp["workout"] = await PlanDB.getTable();
    temp["meditation"] = await MeditationPlanDB.getTable();
    temp.removeWhere((key, value) => value == null);
    if (temp.isNotEmpty) plans = temp.cast<String, SplayTreeMap>();
  }

  static Future<void> fetchDurations() async {
    Map temp = {};
    temp["workout"] = await DurationDB.getTable();
    temp["meditation"] = await MeditationDurationDB.getTable();
    temp.removeWhere((key, value) => value == null);
    if (temp.isNotEmpty) durations = temp.cast<String, SplayTreeMap>();
  }

  static Future<void> fetchPlansAndDurations() async {
    await fetchPlans();
    await fetchDurations();
  }

  static Future<void> fetchWeights() async {
    weights = await WeightDB.getTable();
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
  static List<Map<String, dynamic>>? workoutPlanVariables;
  static List<Map<String, dynamic>>? meditationPlanVariables;

  PlanData() {
    init();
  }

  static Future<void> init() async {
    workoutPlanVariables = UserDB.getPlanVariables(Data.profile);
    meditationPlanVariables = UserDB.getMeditationPlanVariables(Data.profile);
  }

  static Future<void> fetch(
      {required String habit, bool thisWeek = true}) async {
    if (Data.updated == true) init();

    switch (habit) {
      case "workout":
        /*if ( == null) {

        }*/
        habitIDs = (await WorkoutDB.getWIDs())!;
        PlanData.process(
            habit: habit, data: workoutPlanVariables, thisWeek: thisWeek);
        break;
      case "meditation":
        habitIDs = (await MeditationDB.getMIDs())!;
        PlanData.process(
            habit: habit, data: meditationPlanVariables, thisWeek: thisWeek);
        break;
    }
  }

  static void process(
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
  static bool noWorkoutThisWeek = false, noWorkoutNextWeek = false;
  static bool noMeditationThisWeek = false, noMeditationNextWeek = false;
  static Map planList = {"workout": {}, "meditation": {}},
      progressList = {"workout": {}, "meditation": {}};

  static Future<void> fetch() async {
    if (Data.updated) await Data.fetchPlansAndDurations();

    for (String habit in ["workout", "meditation"]) {
      for (List week in [Calendar.thisWeek(), Calendar.nextWeek()]) {
        setPlanList(habit: habit, week: week);
        setProgressList(habit: habit, week: week);
      }
    }
  }

  static void setPlanList({required String habit, required List week}) {
    Map plans = {for (String date in week) date: Data.plans?[habit]?[date]};
    plans.removeWhere((key, value) => value == null);

    if (plans.isNotEmpty) {
      planList[habit].addAll(plans);
    } else {
      if (week.contains(Calendar.today)) {
        if (habit == "workout") {
          noWorkoutThisWeek = true;
        } else {
          noMeditationThisWeek = true;
        }
      } else {
        if (habit == "workout") {
          noWorkoutNextWeek = true;
        } else {
          noMeditationNextWeek = true;
        }
      }
    }
  }

  static void setProgressList({required String habit, required List week}) {
    Map durations = {
      for (String date in week) date: Data.durations?[habit]?[date]
    };
    durations.removeWhere((key, value) => value == null);

    if (durations.isNotEmpty) {
      durations.updateAll((key, value) => Calculator.calcProgress(value).round());
      progressList[habit].addAll(durations);
    }
  }
}
