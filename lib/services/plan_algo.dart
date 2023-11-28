import 'dart:collection';
import 'dart:math';

import 'package:g12/services/database.dart';
import 'package:g12/services/page_data.dart';

// ignore_for_file: avoid_print

class PlanAlgo {
  // Execute when user register an account.
  static initialize() async {
    await Data.fetchHabits();

    Map<String, String> workoutPlan = {}, meditationPlan = {};

    for (bool thisWeek in [true, false]) {
      await PlanData.fetch(habit: "workout", thisWeek: thisWeek);
      var skd = await WorkoutAlgorithm.arrangeSchedule();
      workoutPlan.addAll(await WorkoutAlgorithm.arrangePlan(skd));
    }
    if (workoutPlan.isNotEmpty) await PlanDB.update("workout", workoutPlan);

    for (bool thisWeek in [true, false]) {
      await PlanData.fetch(habit: "meditation", thisWeek: thisWeek);
      var skd = await MeditationAlgorithm.arrangeSchedule();
      meditationPlan.addAll(await MeditationAlgorithm.arrangePlan(skd));
    }
    if (meditationPlan.isNotEmpty) await PlanDB.update("meditation", meditationPlan);

    Data.plans = {
      "workout": SplayTreeMap.of(workoutPlan),
      "meditation": SplayTreeMap.of(meditationPlan)
    };
    Data.durations = {
      "workout": SplayTreeMap.of(workoutPlan
          .map((k, v) => MapEntry(k, "0, ${PlanData.habitDuration}"))),
      "meditation": SplayTreeMap.of(meditationPlan
          .map((k, v) => MapEntry(k, "0, ${PlanData.habitDuration}")))
    };
  }

  // Start point of the planning algorithm
  // Execute when user login or after giving feedback.
  static execute() async {
    if (Data.updatingDB) {
      await Data.fetchProfile();
      Data.updatingDB = false;
    }

    Map<String, String> workoutPlan = {}, meditationPlan = {};

    // Check if user has no plan within two weeks
    Map<String, bool> check = {
      "workoutThisWeek": false,
      "workoutNextWeek": false,
      "meditationThisWeek": false,
      "meditationNextWeek": false,
    };
    List twoWeeks = Calendar.bothWeeks();
    for (String habit in Data.habitTypes) {
      Map plans = {
        for (String date in twoWeeks) date: Data.plans?[habit]?[date]
      };
      plans.removeWhere((key, value) => value == null);

      List b = plans.keys.map((date) => twoWeeks.indexOf(date) ~/ 7).toList();
      if (b.contains(0)) check["${habit}ThisWeek"] = true;
      if (b.contains(1)) check["${habit}NextWeek"] = true;
    }

    // Check condition before generating new plans.
    bool? thisWeek;
    if (check["workoutNextWeek"]! == false) {
      thisWeek = false;
      print("Generate next week's workout plan.");
    }
    if (check["workoutThisWeek"]! == false || Data.isFirstTime) {
      thisWeek = true;
      print("Generate this week's workout plan.");
    }

    // Execute planning algorithm to generate new plans.
    if (thisWeek != null) {
      if (thisWeek) {
        await PlanData.fetch(habit: "workout", thisWeek: true);
        var skd = await WorkoutAlgorithm.arrangeSchedule();
        workoutPlan.addAll(await WorkoutAlgorithm.arrangePlan(skd));
      }
      await PlanData.fetch(habit: "workout", thisWeek: false);
      var skd = await WorkoutAlgorithm.arrangeSchedule();
      workoutPlan.addAll(await WorkoutAlgorithm.arrangePlan(skd));
      // update to firebase
      if (workoutPlan.isNotEmpty) await PlanDB.update("workout", workoutPlan);
    } else {
      print("Not the time to generate a workout plan.");
    }

    // Check condition before generating new plans
    thisWeek = null;
    if (check["meditationNextWeek"]! == false) {
      thisWeek = false;
      print("Generate next week's meditation plan.");
    }
    if (check["meditationThisWeek"]! == false || Data.isFirstTime) {
      thisWeek = true;
      print("Generate this week's meditation plan.");
    }

    // Execute planning algorithm to generate new plans.
    if (thisWeek != null) {
      if (thisWeek) {
        await PlanData.fetch(habit: "meditation", thisWeek: true);
        var skd = await MeditationAlgorithm.arrangeSchedule();
        meditationPlan.addAll(await MeditationAlgorithm.arrangePlan(skd));
      }
      await PlanData.fetch(habit: "meditation", thisWeek: false);
      var skd = await MeditationAlgorithm.arrangeSchedule();
      meditationPlan.addAll(await MeditationAlgorithm.arrangePlan(skd));
      // update to firebase
      if (meditationPlan.isNotEmpty) await PlanDB.update("meditation", meditationPlan);
    } else {
      print("Not the time to generate a meditation plan.");
    }

    // Reset GamificationDB's workoutFragment/meditationFragment to zero since a new week has come
    if (check.containsValue(false)) await GamificationDB.resetFragment();
  }

  // Regenerate the plan for a day in the current week
  static regenerateWorkout(DateTime dateTime) async {
    await PlanData.fetch(
        habit: "workout", thisWeek: Calendar.isThisWeek(dateTime));

    var date = Calendar.dateToString(dateTime);
    var plan = HomeData.workoutPlanList[date];
    var workoutType = PlanDB.toPlanType("workout", date: date);
    var timeSpan = plan.split(", ").length;
    if (workoutType != null) {
      plan = await WorkoutAlgorithm.arrangeWorkout(workoutType, timeSpan);
      await PlanDB.update("workout", {date: plan});
    }
  }

  static regenerateMeditation(DateTime dateTime) async {
    await PlanData.fetch(
        habit: "meditation", thisWeek: Calendar.isThisWeek(dateTime));

    var date = Calendar.dateToString(dateTime);
    var meditationType = PlanDB.toPlanType("meditation", date: date);
    if (meditationType != null) {
      var plan = await MeditationAlgorithm.arrangeMeditation(meditationType);
      await PlanDB.update("meditation", {date: plan});
    }
  }

  static generateWorkout(DateTime dateTime, int timeSpan) async {
    await PlanData.fetch(
        habit: "workout", thisWeek: Calendar.isThisWeek(dateTime));

    var date = Calendar.dateToString(dateTime);
    List workoutType = ["strength", "cardio", "yoga"];
    int idx = Random().nextInt(3);
    var plan =
        await WorkoutAlgorithm.arrangeWorkout(workoutType[idx], timeSpan);

    await PlanDB.update("workout", {date: plan});
  }

  static generateMeditation(DateTime dateTime, int meditationType) async {
    await PlanData.fetch(
        habit: "meditation", thisWeek: Calendar.isThisWeek(dateTime));

    var date = Calendar.dateToString(dateTime);
    String type = ["mindfulness", "work", "kindness"][meditationType - 1];
    var meditationPlan = await MeditationAlgorithm.arrangeMeditation(type);

    await PlanDB.update("meditation", {date: meditationPlan});
  }

  // Adjust the difficulty if user's completion rate is not as expected
  // if the completion rate is less than half for three days, then return 1
  // else if the completion rate is zero for three days, then return 0
  // else, return -1
  static Future<int> adjust() async {
    var data = Data.durations?["workout"];

    if (data != null) {
      List dates = data.keys.toList();
      int today = dates.indexOf(Calendar.today);
      Map planList = HomeData.workoutPlanList;

      int lessThanHalf = 0; // count the consecutive days when completion < 50%
      int zero = 0; // count the consecutive days when completion = 0%

      for (int i = today; i >= 0; i--) {
        // calculate the completion rate
        var completionRate = Calculator.calcProgress(dates[i]);
        // count the days that are not as expected
        if (completionRate < 50) {
          if (completionRate == 0) zero++;
          if (zero == 3) {
            // adjust the difficulty of next day and the day after
            for (i = 1; i <= 2; i++) {
              String? type = PlanDB.toPlanType("workout", date: dates[today]);
              if (type != null) {
                var plan = (i == 1)
                    ? await WorkoutAlgorithm.getFiveMinWorkout(type)
                    : await WorkoutAlgorithm.getTenMinWorkout(type);
                await PlanDB.update(
                    "workout", {dates[today + i]: plan.join(", ")});
              }
            }
            // return 0 to trigger app notification
            return 0;
          }

          if (++lessThanHalf == 3) {
            int? planLong = planList[today].split(", ").length;
            if (planLong != null) {
              planLong ~/= 3;

              // adjust the difficulty of next day and the day after
              for (i = 1; i <= 2; i++) {
                String? type =
                    PlanDB.toPlanType("workout", date: dates[today + i]);
                if (type != null) {
                  String plan = "";
                  switch (planLong) {
                    case 5:
                      plan = (await WorkoutAlgorithm.getFiveMinWorkout(type))
                          .join(", ");
                      break;
                    case 10:
                      plan = (await WorkoutAlgorithm.getTenMinWorkout(type))
                          .join(", ");
                      break;
                    case 15:
                      plan = (await WorkoutAlgorithm.getTenMinWorkout(type))
                          .join(", ");
                      plan += (await WorkoutAlgorithm.getFiveMinWorkout(type))
                          .join(", ");
                      break;
                    case 20:
                      plan = (await WorkoutAlgorithm.getTenMinWorkout(type))
                          .join(", ");
                      plan += (await WorkoutAlgorithm.getTenMinWorkout(type))
                          .join(", ");
                      break;
                  }
                  await PlanDB.update("workout", {dates[today + i]: plan});
                }
              }
            }
            // return 1 to provoke the character dialog for asking to adjust difficulty permanently
            return 1;
          }
        } else {
          // return -1 to do nothing (i.e. didn't fail to meet the expectation)
          return -1;
        }
      }
    }
    return -1;
  }
}

class WorkoutAlgorithm {
  // Method to arrange a workout schedule based on the workout frequency and workout days
  static Future<Map<String, String>> arrangeSchedule() async {
    // Calculate workout frequency based on the adjusted user data
    Map<String, int> frequencies = {};
    // workouts' frequency are calculated by the proportion of their likings
    PlanData.likings.forEach((k, v) => {
          frequencies.putIfAbsent(k,
              () => ((v / PlanData.sumLikings) * PlanData.sumHabitDays).round())
        });
    print('settings: ${PlanData.habitDays}\nfrequency: $frequencies');

    // Adjust the frequency map based on the error margin of +-1
    var sumFreq = frequencies.values.toList().fold(0, (p, c) => c + p);
    if (PlanData.sumHabitDays > sumFreq) {
      frequencies.update(PlanData.mostLike, (v) => v + 1);
    } else if (PlanData.sumHabitDays < sumFreq) {
      frequencies.update(PlanData.leastLike, (v) => v - 1);
    }
    print('frequency(adjust): $frequencies');

    // Turn the frequency map into a list of selectable objects
    List<String> categories = [];
    frequencies.forEach((k, v) => {
          for (int i = 0; i < v; i++)
            {categories.add(k.substring(0, k.indexOf('Liking')))}
        });

    // Shuffle the list to randomly pick objects for non-rest days
    categories.shuffle();

    // Initialize the schedule with rest days
    Map<String, String> schedule = Map.fromIterables(
        PlanData.habitDays.keys, List.generate(7, (index) => 'rest'));

    // Assign workouts to the upcoming non-rest days
    List daysPassed = Calendar.daysPassed();
    print("daysPassed: $daysPassed");
    PlanData.habitDays.forEach((k, v) => {
          if (!daysPassed.contains(k) && v == 1)
            {schedule[k] = categories[0], categories.removeAt(0)}
        });
    print('schedule: $schedule');

    return schedule;
  }

  // Method to generate all 10 minutes workouts
  static Future<List<List>> getTenMinWorkout(String type,
      [int? timeSpan]) async {
    // Get the workout database
    List workouts = PlanData.habitIDs[type]!;

    // Get users ability level and plan settings
    int ability = PlanData.abilities['${type}Ability'];
    ability = ((type == 'cardio') ? ability / 33 : ability / 20).ceil();
    timeSpan ??= PlanData.habitDuration;
    int nLoops = timeSpan ~/ 15; // total rounds
    int repetition = PlanData.repetition; // number of repetitions
    bool same = (repetition > 0) ? true : false;

    print('$type: Lv.$ability ability,'
        ' ${PlanData.habitDuration} min, $nLoops loop ($repetition repeat)');

    // Generate the list of workouts from random
    Random rand = Random();
    List<List> tenMin = [];
    while (tenMin.length < nLoops) {
      // Randomly select the difficulty level and pick five moves from that level
      List lst = [];
      for (int i = 0; i < 5; i++) {
        int diff = rand.nextInt(ability);
        int index = rand.nextInt(workouts[diff].length);
        lst.add(workouts[diff][index]);
      }
      while (same) {
        for (int j = 0; j < repetition - 1; j++) {
          // Duplicate the list twice then add to the return value
          tenMin.add([...lst, ...List.from(lst)]);
        }
        same = false;
      }
      tenMin.add([...lst, ...List.from(lst)]);
    }

    return tenMin;
  }

  // Method to generate all 5 minutes workouts
  static Future<List<List>> getFiveMinWorkout(String type,
      [int? timeSpan]) async {
    // Get the workout database
    List workouts = PlanData.habitIDs[type]!;

    // Get difficulty level and plan settings
    int diff = 0; // difficulty level for 5 minute workout session: easy
    timeSpan ??= PlanData.habitDuration;
    int nLoops = timeSpan ~/ 15 - 1; // total rounds

    // Generate the list of workouts from random
    Random rand = Random();
    List<List> fiveMin = [];
    for (int i = 0; i < nLoops; i++) {
      List lst = [];
      for (int i = 0; i < 5; i++) {
        int index = rand.nextInt(workouts[diff].length);
        lst.add(workouts[diff][index]);
      }
      fiveMin.add(lst);
    }

    return fiveMin;
  }

  // Method to generate warm-up or cool-down workouts
  static Future<List<String>> getStretchWorkout(String type) async {
    // Get the workout database
    List workouts = PlanData.habitIDs[type]!;

    int min = (type == "warmUp") ? 3 : 2; // warm-up 3 min, cool-down 2 min

    // Generate the list of workouts from random
    Random rand = Random();
    List<String> stretch = [];
    for (int i = 0; i < min; i++) {
      stretch.add(workouts[rand.nextInt(workouts.length)]);
    }

    return stretch;
  }

  // Method to generate a list of workouts from a given workout type
  static Future<String> arrangeWorkout(String type, [int? timeSpan]) async {
    // Generate the list of workouts from random
    List<String> warmUp = await getStretchWorkout("warmUp");
    List<List> tenMin = await getTenMinWorkout(type, timeSpan);
    List<List> fiveMin = await getFiveMinWorkout(type, timeSpan);
    List<String> coolDown = await getStretchWorkout("coolDown");

    // Arrange different sessions into one string
    String workouts = warmUp.join(", ");
    for (int i = 0; i < fiveMin.length; i++) {
      workouts += ", ${tenMin[i].join(", ")}";
      workouts += ", ${fiveMin[i].join(", ")}";
    }
    workouts += ", ${tenMin.last.join(", ")}";
    workouts += ", ${coolDown.join(", ")}";
    return workouts;
  }

  // Method to generate a workout plan {"Date": "workoutIDs"}
  static Future<Map<String, String>> arrangePlan(Map schedule) async {
    Map<String, String> plan = {};
    // Call arrangeWorkout() for each workout type in the workout schedule
    for (MapEntry entry in schedule.entries) {
      if (entry.value != 'rest') {
        plan[entry.key] = await arrangeWorkout(entry.value);
      }
    }
    print("plan: $plan");
    return plan;
  }
}

class MeditationAlgorithm {
  // Method to arrange a meditation schedule based on the meditation frequency and meditation days
  static Future<Map<String, String>> arrangeSchedule() async {
    // Calculate meditation frequency based on the adjusted user data
    Map<String, int> frequencies = {};
    // meditations' frequency are calculated by the proportion of their likings
    PlanData.likings.forEach((k, v) => {
          frequencies.putIfAbsent(k,
              () => ((v / PlanData.sumLikings) * PlanData.sumHabitDays).round())
        });
    print('settings: ${PlanData.habitDays}\nfrequency: $frequencies');

    // Adjust the frequency map based on the error margin of +-1
    var sumFreq = frequencies.values.toList().fold(0, (p, c) => c + p);
    if (PlanData.sumHabitDays > sumFreq) {
      frequencies.update("mindfulnessLiking", (v) => v + 1);
    } else if (PlanData.sumHabitDays < sumFreq) {
      frequencies.update("mindfulnessLiking", (v) => v - 1);
    }
    print('frequency(adjust): $frequencies');

    // Turn the frequency map into a list of selectable objects
    List<String> categories = [];
    frequencies.forEach((k, v) => {
          for (int i = 0; i < v; i++)
            {categories.add(k.substring(0, k.indexOf('Liking')))}
        });

    // Shuffle the list to randomly pick objects for non-rest days
    categories.shuffle();
    print('categories: $categories');

    // Initialize the schedule with rest days
    Map<String, String> schedule = Map.fromIterables(
        PlanData.habitDays.keys, List.generate(7, (index) => 'rest'));

    // Assign workouts to the upcoming non-rest days
    List daysPassed = Calendar.daysPassed();
    print("daysPassed: $daysPassed");
    PlanData.habitDays.forEach((k, v) => {
          // if the day isn'tPassed and isMeditationDay, then assign a meditation category to the day
          if (!daysPassed.contains(k) && v == 1)
            {schedule[k] = categories[0], categories.removeAt(0)}
        });
    print('schedule: $schedule');

    return schedule;
  }

  // Method to generate a meditation from a given meditation type
  static Future<String> arrangeMeditation(String type) async {
    Random rand = Random();
    // Get the type's meditationIDs
    List meditations = [];
    meditations = PlanData.habitIDs[type][rand.nextInt(7)]!;
    // randomly generate a meditationID
    return meditations[rand.nextInt(meditations.length)];
  }

  // Method to generate a meditation plan {"Date": "meditationIDs"}
  static Future<Map<String, String>> arrangePlan(Map schedule) async {
    Map<String, String> plan = {};
    // Call arrangeMeditation() for each workout type in the workout schedule
    for (MapEntry entry in schedule.entries) {
      if (entry.value != 'rest') {
        plan[entry.key] = await arrangeMeditation(entry.value);
      }
    }
    print("plan: $plan");
    return plan;
  }
}
