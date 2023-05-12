import 'dart:math';

import 'package:g12/services/Database.dart';

class PlanAlgo {
  // Start point of the planning algorithm (execute when user login)
  static execute(String uid) async {
    Algorithm algo = Algorithm();
    Data? db;

    // Conditions
    bool isLastDay =
        Calendar.toKey(DateTime.now()) == await UserDB.getLastWorkoutDay(uid);
    bool noPlan = await PlanDB.getThisWeek(uid) == null;
    bool isFinished = await PlanAlgo.calcProgress(uid) == 100;

    if (isLastDay && isFinished) {
      // Generate plan on the last day if plan is finished
      db = await algo.initializeNextWeek(uid);
      print("generate next week's plan");
    } else if (noPlan) {
      // Generate plan on any day if database hos no data for that week
      db = await algo.initializeThisWeek(uid);
      print("generate this week's plan");
    } else {
      print("not the time to generate a plan");
    }

    if (db != null) {
      var skd = await algo.arrangeSchedule(db);
      var plan = await algo.arrangePlan(db, skd);
      await PlanDB.update(uid, plan);
    }
  }

  // Regenerate the plan for a day in the current week
  static regenerate(String uid, DateTime dateTime) async {
    Algorithm algo = Algorithm();
    var db = await algo.initializeThisWeek(uid);
    var date = Calendar.toKey(dateTime);

    // The third element of the plan is the first workout after the warmup,
    // and its first character's index (which indicates the workout type) is 18.
    switch ((await PlanDB.getFromDate(uid, dateTime))[18]) {
      case '1':
        await PlanDB.update(
            uid, {date: await algo.arrangeWorkout(db, "strength")});
        break;
      case '2':
        await PlanDB.update(
            uid, {date: await algo.arrangeWorkout(db, "cardio")});
        break;
      case '3':
        await PlanDB.update(uid, {date: await algo.arrangeWorkout(db, "yoga")});
        break;
    }
  }

  static Future<num> calcProgress(String uid) async {
    List? duration = await DurationDB.getToday(uid);
    if (duration != null) {
      return (duration[0] / duration[1] * 100).round(); // percentage
    }
    return 0; // percentage
  }
}

class Algorithm {
  // Method to initialize (and adjust) user's profile from their survey results
  Future<Data> initializeThisWeek(String uid) async {
    Data db = Data();
    await db.init(uid, Calendar.daysComing());

    return await initialize(db);
  }

  Future<Data> initializeNextWeek(String uid) async {
    Data db = Data();
    await db.init(uid, Calendar.nextWeek());

    return await initialize(db);
  }

  Future<Data> initialize(Data db) async {
    // Set modifiers
    int nVal = db.personalities['neuroticism'];
    int nMul = 10;
    int cVal = db.personalities['conscientiousness'];
    int cMul = 5;

    // Adjust user's data
    print('survey: ${db.likings}\n'
        '        ${db.abilities}');
    db.likings.forEach((k, v) => {
          if (k == 'strengthLiking')
            {db.likings[k] = v - nVal * nMul}
          else
            {db.likings[k] = v + nVal * nMul}
        });
    db.abilities.forEach((k, v) => {db.abilities[k] = v + cVal * cMul});
    print('survey(adjust): ${db.likings}\n'
        '                ${db.abilities}');

    return db;
  }

  // Method to arrange a workout schedule based on the workout frequency and workout days
  Future<Map<String, String>> arrangeSchedule(Data db) async {
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

    // Assign workouts to the non-rest days
    db.workoutDays.forEach((k, v) => {
          if (v == 1) {schedule[k] = categories[0], categories.removeAt(0)}
        });
    print('schedule: $schedule');

    return schedule;
  }

  // Method to generate all 10 minutes workouts
  Future<List<List>> getTenMinWorkout(Data db, String type) async {
    // Get the workout database
    List workouts = db.workoutIDs[type]!;

    // Get users ability level and plan settings
    int ability = db.abilities['${type}Ability'];
    ability =
        (type == 'cardio') ? (ability / 33).ceil() : (ability / 20).ceil();
    int nLoops = (db.timeSpan / 15).toInt(); // total rounds
    int nSame = db.nSame; // number of repetitions
    bool same = (nSame > 0) ? true : false;

    print('$type: Lv.$ability ability,'
        ' ${db.timeSpan} min, $nLoops loop ($nSame repeat)');

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
  Future<List<List>> getFiveMinWorkout(Data db, String type) async {
    // Get the workout database
    List workouts = db.workoutIDs[type]!;

    // Get difficulty level and plan settings
    int diff = 0; // difficulty level for 5 minute workout session: easy
    int nLoops = (db.timeSpan / 15).toInt() - 1; // total rounds

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
  Future<List<String>> getStretchWorkout(Data db, String type) async {
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
  Future<String> arrangeWorkout(Data db, String type) async {
    // Generate the list of workouts from random
    List<String> warmUp = await getStretchWorkout(db, "warmUp");
    List<List> tenMin = await getTenMinWorkout(db, type);
    List<List> fiveMin = await getFiveMinWorkout(db, type);
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
  Future<Map<String, String>> arrangePlan(Data db, Map schedule) async {
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

class Data {
  // Get the decision variables for the planning algorithm
  Map<String, dynamic> _likings = {}, _abilities = {};
  Map<String, dynamic> _workoutDays = {}, _personalities = {};
  num _timeSpan = 15;
  String _mostLike = '', _leastLike = '';
  String _bestAbility = '', _worstAbility = '';
  num _sumLikings = 0, _sumAbilities = 0, _nDays = 0, _nSame = 0;
  // Get the workouts ID
  Map _workoutIDs = {};

  // Setter
  Future<void> init(String uid, List<String> weekDates) async {
    _workoutIDs = (await WorkoutDB.getWIDs())!;

    var profile = await UserDB.getPlanVariables(uid);

    _personalities = profile![0];
    _timeSpan = profile[1]['timeSpan'];
    _workoutDays = Map.fromIterables(
        weekDates, profile[1]['workoutDays'].split('').map(int.parse).toList());
    _likings = profile[2];
    _abilities = profile[3];

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

    var openness = _personalities['openness'];
    if (_timeSpan == 15) {
      if (openness <= 2) {
        _nSame = 2;
      }
    } else {
      if (openness <= 2) {
        _nSame = 3;
      } else if (openness == 3) {
        _nSame = 2;
      }
      if (_timeSpan == 60 && openness == 1) {
        _nSame = 4;
      }
    }
  }

  // Getters
  get workoutIDs => _workoutIDs;
  get likings => _likings;
  get abilities => _abilities;
  get workoutDays => _workoutDays;
  get personalities => _personalities;
  get timeSpan => _timeSpan;
  get mostLike => _mostLike;
  get leastLike => _leastLike;
  get bestAbility => _bestAbility;
  get worstAbility => _worstAbility;
  get sumLikings => _sumLikings;
  get sumAbilities => _sumAbilities;
  get nDays => _nDays;
  get nSame => _nSame;
}
