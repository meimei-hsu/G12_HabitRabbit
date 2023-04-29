import 'dart:math';

import 'Database.dart';

class Algorithm {
  // Execute point of the planning algorithm
  static execute(String id) async {
    Algorithm algo = Algorithm();
    var db = await algo.initializeValue(id);
    var skd = await algo.arrangeSchedule(db);
    var plan = await algo.arrangePlan(db, skd);
    PlanDB.update(id, plan);
  }

  // Regenerate the plan for today
  static regenerate(String id) async {
    Algorithm algo = Algorithm();
    var db = await algo.initializeValue(id);
    var today = Calendar.today();

    switch ((await PlanDB.getTodayPlan(id))?[0]) {
      case 'S':
        PlanDB.update(id, {today: await algo.arrangeWorkout(db, "strength")});
        break;
      case 'C':
        PlanDB.update(id, {today: await algo.arrangeWorkout(db, "cardio")});
        break;
      case 'Y':
        PlanDB.update(id, {today: await algo.arrangeWorkout(db, "yoga")});
        break;
    }
  }

  // Method to initialize (and adjust) user's profile from their survey results
  Future<Data> initializeValue(String id) async {
    // Get user's profile
    Data db = Data();
    await db.init(id);

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

  // Method to generate 10 minutes workouts
  Future<List<List>> getTenMinWorkout(Data db, String type) async {
    // Get the workout database
    Map workoutDB = db.getWorkoutID();

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
    List<List> workouts = [];
    while (workouts.length < nLoops) {
      // Randomly select the difficulty level and pick five moves from that level
      List l = List.generate(
          5, (k) => workoutDB[type][rand.nextInt(ability)][rand.nextInt(50)]);
      while (same) {
        for (int j = 0; j < nSame - 1; j++) {
          // Duplicate the list twice then add to the return value
          workouts.add([...l, ...List.from(l)]);
        }
        same = false;
      }
      workouts.add([...l, ...List.from(l)]);
    }

    return workouts;
  }

  // Method to generate 5 minutes workouts
  Future<List<List>> getFiveMinWorkout(Data db, String type) async {
    // Get the workout database
    Map workoutDB = db.getWorkoutID();

    // Get difficulty level and plan settings
    int difficulty = 0; // difficulty level for 5 minute workout session: easy
    int nLoops = (db.timeSpan / 15).toInt() - 1; // total rounds

    // Generate the list of workouts from random
    Random rand = Random();
    List<List> workouts = [];
    for (int i = 0; i < nLoops; i++) {
      List l = List.generate(
          5, (k) => workoutDB[type][difficulty][rand.nextInt(50)]);
      workouts.add(l);
    }

    return workouts;
  }

  // Method to generate a list of workouts from a given workout type
  Future<String> arrangeWorkout(Data db, String type) async {
    // Generate the list of workouts from random
    List<List> tenMin = await getTenMinWorkout(db, type);
    List<List> fiveMin = await getFiveMinWorkout(db, type);

    // Arrange different sessions into one string
    String workouts = tenMin[0].join(", ");
    for (int i = 0; i < fiveMin.length; i++) {
      workouts += ", ${fiveMin[i].join(", ")}";
      workouts += ", ${tenMin[i].join(", ")}";
    }
    return workouts;
  }

  // Method to generate a workout plan
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
  // TODO: Get workoutID from firebase
  //var workout =  WorkoutDB.getWorkout(id);
  Map<String, List> getWorkoutID() => {
        /*'strength': [
          [for (var i = 100; i <= 150; i++) 'S$i'],
          [for (var i = 200; i <= 250; i++) 'S$i'],
          [for (var i = 300; i <= 350; i++) 'S$i'],
          [for (var i = 400; i <= 450; i++) 'S$i'],
          [for (var i = 500; i <= 550; i++) 'S$i']
        ],
        'cardio': [
          [for (var i = 100; i <= 150; i++) 'C$i'],
          [for (var i = 200; i <= 250; i++) 'C$i'],
          [for (var i = 300; i <= 350; i++) 'C$i'],
        ],
        'yoga': [
          [for (var i = 100; i <= 150; i++) 'Y$i'],
          [for (var i = 200; i <= 250; i++) 'Y$i'],
          [for (var i = 300; i <= 350; i++) 'Y$i'],
          [for (var i = 400; i <= 450; i++) 'Y$i'],
          [for (var i = 500; i <= 550; i++) 'Y$i']
        ],*/
    'strength': [
      WorkoutDB.getWorkoutIdByTD("strength","1"),
      WorkoutDB.getWorkoutIdByTD("strength","2"),
      WorkoutDB.getWorkoutIdByTD("strength","3"),
      WorkoutDB.getWorkoutIdByTD("strength","4"),
      WorkoutDB.getWorkoutIdByTD("strength","5"),
    ],
    'yoga': [
      WorkoutDB.getWorkoutIdByTD("yoga","1"),
      WorkoutDB.getWorkoutIdByTD("yoga","2"),
      WorkoutDB.getWorkoutIdByTD("yoga","3"),
      WorkoutDB.getWorkoutIdByTD("yoga","4"),
      WorkoutDB.getWorkoutIdByTD("yoga","5"),
    ],

    'cardio': [
      WorkoutDB.getWorkoutIdByTD("cardio","1"),
      WorkoutDB.getWorkoutIdByTD("cardio","2"),
    ],

    'warmup': [
      WorkoutDB.getWorkoutIdByTD("warmup","0"),
    ],

    'stretch': [
      WorkoutDB.getWorkoutIdByTD("stretch","0"),
    ],
      };

  // Get the decision variables for the planning algorithm
  Map _likings = {}, _abilities = {}, _workoutDays = {}, _personalities = {};
  num _timeSpan = 15;
  String _mostLike = '', _leastLike = '';
  String _bestAbility = '', _worstAbility = '';
  num _sumLikings = 0, _sumAbilities = 0, _nDays = 0, _nSame = 0;

  // Setter
  Future<void> init(String id) async {
    var profile = await UserDB.getPlanVariables(id);

    _timeSpan = profile![0]['timeSpan'];
    _workoutDays = profile[1];
    _likings = profile[2];
    _abilities = profile[3];
    _personalities = profile[0]..remove("timeSpan");

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
