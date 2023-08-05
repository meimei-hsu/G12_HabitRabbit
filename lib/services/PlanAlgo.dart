import 'dart:math';

import 'package:g12/services/Database.dart';
//workout
class PlanAlgo {
  // Start point of the planning algorithm
  // Execute when user login or after giving feedback.
  static execute() async {
    Algorithm algo = Algorithm();
    PlanData? db;
    DateTime lastWorkoutDay =
        DateTime.parse((await UserDB.getLastWorkoutDay())!);

    // Conditions
    int today = DateTime.now().weekday;
    int lastDay = lastWorkoutDay.weekday;
    bool noThisWeekPlan = await PlanDB.getThisWeek() == null;
    bool noNextWeekPlan = await PlanDB.getNextWeek() == null;
    bool isFinished = await DurationDB.calcProgress(lastWorkoutDay) == 100;

    // Start generating the plan
    // Generate next week's plan if:
    //   1. on the last day & feedback is given
    //   2. on days after last day & no feedback given from the last day
    // else, generate this week's plan on any day if database has no data.
    if ((today == lastDay && isFinished) ||
        (today > lastDay && !isFinished && today != 7)) {
      if (noNextWeekPlan) {
        db = await algo.initializeNextWeek();
        print("Generate next week's plan.");
      }
    } else {
      if (noThisWeekPlan) {
        db = await algo.initializeThisWeek();
        print("Generate this week's plan.");
      }
    }

    if (db != null) {
      var skd = await algo.arrangeSchedule(db);
      var plan = await algo.arrangePlan(db, skd);
      await PlanDB.update(plan);
    } else {
      print("Not the time to generate a plan.");
    }
  }

  // Regenerate the plan for a day in the current week
  static regenerate(DateTime dateTime) async {
    Algorithm algo = Algorithm();
    var db = await algo.initializeThisWeek();
    var date = Calendar.toKey(dateTime);

    var workoutType = await PlanDB.getWorkoutType(dateTime);
    var timeSpan = await PlanDB.getPlanLong(dateTime);
    if (workoutType != null) {
      var plan = await algo.arrangeWorkout(db, workoutType, timeSpan);
      await PlanDB.update({date: plan});
    }
  }

  static generate(DateTime dateTime, int timeSpan) async {
    Algorithm algo = Algorithm();
    var db = await algo.initializeThisWeek();
    var date = Calendar.toKey(dateTime);

    List workoutType = ["strength", "cardio", "yoga"];
    int idx = Random().nextInt(3);
    var plan = await algo.arrangeWorkout(db, workoutType[idx], timeSpan);
    await PlanDB.update({date: plan});
  }
}

class Algorithm {
  Future<PlanData> initializeThisWeek() async {
    PlanData db = PlanData();
    await db.init(Calendar.thisWeek());
    return db;
  }

  Future<PlanData> initializeNextWeek() async {
    PlanData db = PlanData();
    await db.init(Calendar.nextWeek());
    return db;
  }

  // Method to arrange a workout schedule based on the workout frequency and workout days
  Future<Map<String, String>> arrangeSchedule(PlanData db) async {
    // Calculate workout frequency based on the adjusted user data
    Map<String, int> frequencies = {};
    db.likings.forEach((k, v) => {
          frequencies.putIfAbsent(
              k, () => (v / db.sumLikings * db.nDays).round())
        });
    print('settings: ${db.workoutDays}\nfrequency: $frequencies');

    // Adjust the frequency map based on the error margin of +-1
    var sumFreq = frequencies.values.toList().fold(0, (p, c) => c + p);
    if (db.nDays > sumFreq) {
      frequencies.update(db.mostLike, (v) => v + 1);
    } else if (db.nDays < sumFreq) {
      frequencies.update(db.leastLike, (v) => v - 1);
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
        db.workoutDays.keys, List.generate(7, (index) => 'rest'));

    // Assign workouts to the upcoming non-rest days
    List daysPassed = Calendar.daysPassed();
    print("daysPassed: $daysPassed");
    db.workoutDays.forEach((k, v) => {
          if (!daysPassed.contains(k) && v == 1)
            {schedule[k] = categories[0], categories.removeAt(0)}
        });
    print('schedule: $schedule');

    return schedule;
  }

  // Method to generate all 10 minutes workouts
  Future<List<List>> getTenMinWorkout(PlanData db, String type,
      [int? timeSpan]) async {
    // Get the workout database
    List workouts = db.workoutIDs[type]!;

    // Get users ability level and plan settings
    int ability = db.abilities['${type}Ability'];
    ability = ((type == 'cardio') ? ability / 33 : ability / 20).ceil();
    timeSpan ??= db.workoutTime;
    int nLoops = timeSpan! ~/ 15; // total rounds
    int nSame = db.nSame; // number of repetitions
    bool same = (nSame > 0) ? true : false;

    print('$type: Lv.$ability ability,'
        ' ${db.workoutTime} min, $nLoops loop ($nSame repeat)');

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
        for (int j = 0; j < nSame - 1; j++) {
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
  Future<List<List>> getFiveMinWorkout(PlanData db, String type,
      [int? timeSpan]) async {
    // Get the workout database
    List workouts = db.workoutIDs[type]!;

    // Get difficulty level and plan settings
    int diff = 0; // difficulty level for 5 minute workout session: easy
    timeSpan ??= db.workoutTime;
    int nLoops = timeSpan! ~/ 15 - 1; // total rounds

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
  Future<List<String>> getStretchWorkout(PlanData db, String type) async {
    // Get the workout database
    List workouts = db.workoutIDs[type]!;

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
  Future<String> arrangeWorkout(PlanData db, String type,
      [int? timeSpan]) async {
    // Generate the list of workouts from random
    List<String> warmUp = await getStretchWorkout(db, "warmUp");
    List<List> tenMin = await getTenMinWorkout(db, type, timeSpan);
    List<List> fiveMin = await getFiveMinWorkout(db, type, timeSpan);
    List<String> coolDown = await getStretchWorkout(db, "coolDown");

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
  Future<Map<String, String>> arrangePlan(PlanData db, Map schedule) async {
    Map<String, String> plan = {};
    // Call arrangeWorkout() for each workout type in the workout schedule
    for (MapEntry entry in schedule.entries) {
      if (entry.value != 'rest') {
        plan[entry.key] = await arrangeWorkout(db, entry.value);
      }
    }
    print("plan: $plan");
    return plan;
  }
}

class PlanData {
  // Get the decision variables for the planning algorithm
  Map<String, dynamic> _likings = {}, _abilities = {};
  Map<String, dynamic> _workoutDays = {};
  num _timeSpan = 15;
  String _mostLike = '', _leastLike = '';
  String _bestAbility = '', _worstAbility = '';
  num _sumLikings = 0, _sumAbilities = 0, _nDays = 0, _nSame = 0;
  // Get the workouts ID
  Map _workoutIDs = {};

  // Setter
  Future<void> init(List<String> weekDates) async {
    _workoutIDs = (await WorkoutDB.getWIDs())!;

    var profile = await UserDB.getPlanVariables();

    _timeSpan = profile![0]['workoutTime'];
    _workoutDays = Map.fromIterables(weekDates, profile[0]['workoutDays']);
    _likings = profile[1];
    _abilities = profile[2];

    var max = double.negativeInfinity, min = double.infinity;
    _likings.forEach((key, value) {
      if (value > max) {
        _mostLike = key;
      }
      if (value < min) {
        _leastLike = key;
      }
    });
    max = double.negativeInfinity;
    min = double.infinity;
    _abilities.forEach((key, value) {
      if (value > max) {
        _bestAbility = key;
      }
      if (value < min) {
        _worstAbility = key;
      }
    });

    _sumLikings = _likings.values.toList().fold(0, (p, c) => c + p);
    _sumAbilities = _abilities.values.toList().fold(0, (p, c) => c + p);
    _nDays = _workoutDays.values.toList().fold(0, (p, c) => c + p);

    var openness = profile[0]['openness'];
    if (openness < 0) {
      _nSame = 3;
      if (_timeSpan == 30) _nSame = 2;
    } else if (openness == 1) {
      _nSame = 2;
    }
    if (_timeSpan == 60 && openness == -2) _nSame = 4;
  }

  // Getters
  get workoutIDs => _workoutIDs;
  get likings => _likings;
  get abilities => _abilities;
  get workoutDays => _workoutDays;
  get workoutTime => _timeSpan;
  get mostLike => _mostLike;
  get leastLike => _leastLike;
  get bestAbility => _bestAbility;
  get worstAbility => _worstAbility;
  get sumLikings => _sumLikings;
  get sumAbilities => _sumAbilities;
  get nDays => _nDays;
  get nSame => _nSame;
}

//Meditation
class MeditationPlanAlgo {
  // Start point of the planning algorithm
  // Execute when user login or after giving feedback.
  static execute() async {
    MeditationAlgorithm algo = MeditationAlgorithm();
    MeditationPlanData? db;
    DateTime? lastMeditationDay =
    DateTime.parse((await UserDB.getLastMeditationDay())!);

    // Conditions
    int today = DateTime.now().weekday;
    int lastDay = lastMeditationDay.weekday;
    bool noThisWeekPlan = await MeditationPlanDB.getThisWeek() == null;
    bool noNextWeekPlan = await MeditationPlanDB.getNextWeek() == null;
    bool isFinished = await MeditationDurationDB.calcProgress(lastMeditationDay) == 100;

    // Start generating the plan
    // Generate next week's plan if:
    //   1. on the last day & feedback is given
    //   2. on days after last day & no feedback given from the last day
    // else, generate this week's plan on any day if database has no data.
    if ((today == lastDay && isFinished) ||
        (today > lastDay && !isFinished && today != 7)) {
      if (noNextWeekPlan) {
        db = await algo.initializeNextWeek();
        print("Generate next week's plan.");
      }
    } else {
      if (noThisWeekPlan) {
        db = await algo.initializeThisWeek();
        print("Generate this week's plan.");
      }
    }

    if (db != null) {
      var skd = await algo.arrangeSchedule(db);
      var plan = await algo.arrangePlan(db, skd);
      await MeditationPlanDB.update(plan);
    } else {
      print("Not the time to generate a plan.");
    }
  }

  // Regenerate the plan for a day in the current week
  static regenerate(DateTime dateTime) async {
    MeditationAlgorithm algo = MeditationAlgorithm();
    var db = await algo.initializeThisWeek();
    var date = Calendar.toKey(dateTime);

    var meditationType = await MeditationPlanDB.getMeditationType(dateTime);
    var timeSpan = await MeditationPlanDB.getPlanLong(dateTime);
    if (meditationType != null) {
      //var plan = await algo.arrangeWorkout(db, workoutType, timeSpan);
      var plan = meditationType;
      await MeditationPlanDB.update({date: plan});
    }
  }

  static generate(DateTime dateTime, int timeSpan) async {
    MeditationAlgorithm algo = MeditationAlgorithm();
    var db = await algo.initializeThisWeek();
    var date = Calendar.toKey(dateTime);

    List meditationType = ["relax", "visualize","kindness"];
    int idx = Random().nextInt(3);
    //var meditationplan = await algo.arrangeWorkout(db, meditationType[idx], timeSpan);
    var meditationplan = await algo.arrangeSchedule(db);
    //await MeditationPlanDB.update({date: meditationplan});
    await MeditationPlanDB.update({date: meditationType[idx]});
  }
}

class MeditationAlgorithm {
  Future<MeditationPlanData> initializeThisWeek() async {
    MeditationPlanData db = MeditationPlanData();
    await db.init(Calendar.thisWeek());
    return db;
  }

  Future<MeditationPlanData> initializeNextWeek() async {
    MeditationPlanData db = MeditationPlanData();
    await db.init(Calendar.nextWeek());
    return db;
  }

  // Method to arrange a workout schedule based on the workout frequency and workout days
  Future<Map<String, String>> arrangeSchedule(MeditationPlanData db) async {
    // Calculate workout frequency based on the adjusted user data
    Map<String, int> frequencies = {};
    db.likings.forEach((k, v) => {
      frequencies.putIfAbsent(
          k, () => (v / db.sumLikings * db.nDays).round())
    });
    print('settings: ${db.meditationDays}\nfrequency: $frequencies');

    // Adjust the frequency map based on the error margin of +-1
    var sumFreq = frequencies.values.toList().fold(0, (p, c) => c + p);
    if (db.nDays > sumFreq) {
      frequencies.update(db.mostLike, (v) => v + 1);
    } else if (db.nDays < sumFreq) {
      frequencies.update(db.leastLike, (v) => v - 1);
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
        db.meditationDays.keys, List.generate(7, (index) => 'rest'));

    // Assign workouts to the upcoming non-rest days
    List daysPassed = Calendar.daysPassed();
    print("daysPassed: $daysPassed");
    db.meditationDays.forEach((k, v) => {
      if (!daysPassed.contains(k) && v == 1)
        {schedule[k] = categories[0], categories.removeAt(0)}
    });
    print('schedule: $schedule');

    return schedule;
  }


  // Method to generate a workout plan {"Date": "workoutIDs"}
  Future<Map<String, String>> arrangePlan(MeditationPlanData db, Map schedule) async {
    Map<String, String> plan = {};
    // Call arrangeWorkout() for each workout type in the workout schedule
    for (MapEntry entry in schedule.entries) {
      if (entry.value != 'rest') {
        //plan[entry.key] = await arrangeWorkout(db, entry.value);
      }
    }
    print("plan: $plan");
    return plan;
  }
}

class MeditationPlanData {
  // Get the decision variables for the planning algorithm
  Map<String, dynamic> _likings = {};
  Map<String, dynamic> _meditationDays = {};
  num _timeSpan = 15;
  String _mostLike = '', _leastLike = '';

  num _sumLikings = 0, _nDays = 0;
  // Get the _meditationIDs ID
  Map _meditationIDs = {};

  // Setter
  Future<void> init(List<String> weekDates) async {
    _meditationIDs = (await MeditationDB.getMIDs())!;

    var profile = await UserDB.getMeditationPlanVariables();

    _timeSpan = profile![0]['meditationTime'];
    _meditationDays = Map.fromIterables(weekDates, profile[0]['meditationDays']);
    _likings = profile[1];


    var max = double.negativeInfinity, min = double.infinity;
    _likings.forEach((key, value) {
      if (value > max) {
        _mostLike = key;
      }
      if (value < min) {
        _leastLike = key;
      }
    });
    max = double.negativeInfinity;
    min = double.infinity;


    _sumLikings = _likings.values.toList().fold(0, (p, c) => c + p);

    _nDays = _meditationDays.values.toList().fold(0, (p, c) => c + p);
  }

  // Getters
  get meditationIDs => _meditationIDs;
  get likings => _likings;
  get meditationDays => _meditationDays;
  get meditationTime => _timeSpan;
  get mostLike => _mostLike;
  get leastLike => _leastLike;
  get sumLikings => _sumLikings;
  get nDays => _nDays;
}

