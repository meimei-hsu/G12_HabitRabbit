
import 'dart:math';

import 'package:flutter/widgets.dart';

import 'UserDB.dart';

main() async {
  // Avoid errors
  WidgetsFlutterBinding.ensureInitialized();

  Algorithm algo = Algorithm();
  await algo.initializeValue();
  var schedule = await algo.arrangeSchedule(await algo.calcFrequency());
  await algo.arrangePlan(schedule);
}

class Algorithm {
  Data db = Data();

  // Method to initialize (and adjust) user's profile from their survey results
  Future<void> initializeValue() async {
    // Initialize Data class
    await db.initData();

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
  }

  // Method to calculate workout frequency based on the adjusted user data
  Future<Map<String, int>> calcFrequency() async {
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

    return frequencies;
  }

  // Method to arrange a workout schedule based on the workout frequency and workout days
  Future<Map<String, String>> arrangeSchedule(Map frequencies) async {
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
  Future<List<List>> getTenMinWorkout(String type) async {
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
  Future<List<List>> getFiveMinWorkout(String type) async {
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
  Future<List<List>> arrangeWorkout(String type) async {
    // Generate the list of workouts from random
    List<List> tenMin = await getTenMinWorkout(type);
    List<List> fiveMin = await getFiveMinWorkout(type);

    // Arrange different sessions into one list
    List<List> workouts = [];
    workouts.add(tenMin[0]);
    for (int i = 0; i < fiveMin.length; i++) {
      workouts.add(fiveMin[i]);
      workouts.add(tenMin[i]);
    }

    return workouts;
  }

  // Method to generate a workout plan
  Future<Map<String, List>> arrangePlan(Map schedule) async {
    Map<String, List> plan =
        Map.fromIterables(db.workoutDays.keys, List.generate(7, (index) => []));

    // Call arrangeWorkout() for each workout type in the workout schedule
    for (MapEntry entry in schedule.entries) {
      if (entry.value != 'rest') {
        plan[entry.key] = await arrangeWorkout(entry.value);
      }
    }

    print("Plan{");
    for (String day in plan.keys) {
      print("  $day: {");
      for (int i = 0; i < plan[day]!.length; i++) {
        print("       ${plan[day]![i]}\n");
      }
      print("  }");
    }
    print("}");

    return plan;
  }
}

class Data {
  // Get workout data
  Map<String, List> getWorkoutID() => {
        'strength': [
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
        ],
      };

  // Get user data
  User? _user;
  Map _likings = {}, _abilities = {}, _workoutDays = {}, _personalities = {};
  num _timeSpan = 15;
  String _mostLike = '', _leastLike = '';
  String _bestAbility = '', _worstAbility = '';
  num _sumLikings = 0, _sumAbilities = 0, _nDays = 0, _nSame = 0;

  Future<void> initData() async {
    _user = await UserDB.getUser('mary@gmail.com');
    print(_user.toString());
    await getData();
  }

  Future<void> getData() async {
    var profile = _user!.getDynamicData();

    _timeSpan = profile[0]['timeSpan']!;
    _workoutDays = profile[1];
    _likings = profile[2];
    _abilities = profile[3];
    _personalities = _user!.getPersonality();

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

  get user => _user;

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
