import 'dart:math';

main() {
  Algorithm algo = Algorithm()..initializeValue();
  var schedule = algo.arrangeSchedule(algo.calcFrequency());
  var plan = algo.arrangePlan(schedule);
}

class Algorithm {
  Data db = Data();
  dynamic likings, abilities, workoutDays; // Map

  Algorithm() {
    // generate user's profile
    likings = db.likings;
    abilities = db.abilities;
    workoutDays = db.workoutDays;
  }

  // Method to initialize (and adjust) user's profile from their survey results
  void initializeValue() {
    // Set modifiers
    int nVal = db.personalities['neuroticism'];
    int nMul = 10;
    int cVal = db.personalities['conscientiousness'];
    int cMul = 5;

    // Adjust user's data
    print('survey: $likings & $abilities');
    likings.forEach((k, v) => {
          if (k == 'strength_liking')
            {likings[k] = v - nVal * nMul}
          else
            {likings[k] = v + nVal * nMul}
        });
    abilities.forEach((k, v) => {abilities[k] = v + cVal * cMul});
    print('survey(adjust): $likings & $abilities');
  }

  // Method to calculate workout frequency based on the adjusted user data
  Map calcFrequency() {
    Map<String, int> frequencies = {};
    likings.forEach((k, v) => {
          frequencies.putIfAbsent(
              k, () => (v / db.sumLikings * db.nDays).round())
        });
    print('settings: $workoutDays\nfrequency: $frequencies');

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
  Map arrangeSchedule(Map frequencies) {
    // Turn the frequency map into a list of selectable objects
    List<String> categories = [];
    frequencies.forEach((k, v) => {
          for (int i = 0; i < v; i++)
            {categories.add(k.substring(0, k.indexOf('_')))}
        });

    // Shuffle the list to randomly pick objects for non-rest days
    categories.shuffle();

    // Initialize the schedule with rest days
    Map schedule = Map<String, String>.fromIterables(
        workoutDays.keys, List.generate(7, (index) => 'rest'));

    // Assign workouts to the non-rest days
    workoutDays.forEach((k, v) => {
          if (v == 1) {schedule[k] = categories[0], categories.removeAt(0)}
        });
    print('schedule: $schedule');

    return schedule;
  }

  // Method to generate a 10 minutes workout
  List getTenMinWorkout(String type) {
    // Get the workout database
    Map workoutDB = db.getWorkoutID();

    // Get users ability level and plan settings
    int ability = (abilities['${type}_ability'] / 20).ceil();
    if (type == 'cardio') {
      ability = (abilities['${type}_ability'] / 33).ceil();
    }
    int nLoops = (db.timeSpan / 15).toInt(); // total rounds
    int nSame = db.nSame; // number of repetitions
    bool same = false;
    if (nSame > 0) {
      same = true;
    }
    print('$type: Lv.$ability ability'
        ', ${db.timeSpan} min, $nLoops loop ($nSame repeat)');

    // Generate the list of workouts from random
    Random rand = Random();
    List workouts = [];
    while (workouts.length < nLoops) {
      // Randomly select the difficulty level
      int i = rand.nextInt(ability);
      // Randomly select five moves from the picked level
      List l = List.generate(5, (k) => workoutDB[type][i][rand.nextInt(50)]);
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

  // Method to generate a 5 minutes workout
  List getFiveMinWorkout(String type) {
    // Get the workout database
    Map workoutDB = db.getWorkoutID();

    // Get difficulty level and plan settings
    int difficulty = 0; // difficulty level for 5 minute workout session: easy
    int nLoops = (db.timeSpan / 15).toInt() - 1; // total rounds

    // Generate the list of workouts from random
    Random rand = Random();
    List workouts = [];
    for (int i = 0; i < nLoops; i++) {
      List l = List.generate(
          5, (k) => workoutDB[type][difficulty][rand.nextInt(50)]);
      workouts.add(l);
    }

    return workouts;
  }

  // Method to generate a list of workouts from a given workout type
  List arrangeWorkout(String type) {
    // Generate the list of workouts from random
    List tenMin = getTenMinWorkout(type);
    List fiveMin = getFiveMinWorkout(type);

    // Arrange different sessions into one list
    List workouts = [];
    workouts.add(tenMin[0]);
    for (int i = 0; i < fiveMin.length; i++) {
      workouts.add(fiveMin[i]);
      workouts.add(tenMin[i]);
    }

    return workouts;
  }

  // Method to generate a workout plan
  Map arrangePlan(Map schedule) {
    Map plan = Map<String, List>.fromIterables(
        workoutDays.keys, List.generate(7, (index) => []));

    // Call arrangeWorkout() for each workout type in the workout schedule
    schedule.forEach((k, v) => {
          if (v == 'strength')
            {plan[k] = arrangeWorkout(v)}
          else if (v == 'cardio')
            {plan[k] = arrangeWorkout(v)}
          else if (v == 'yoga')
            {plan[k] = arrangeWorkout(v)}
        });
    print('plan: $plan');

    return schedule;
  }
}

class Data {
  Data() {
    getData();
  }

  // generate workouts
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

  // generate user profile
  Random rand = Random(7788); // test value: 3737, 77777, 7788

  List<Map<String, int>> getUsrProfile() => [
        {
          'strength_liking': 40 + rand.nextInt(2) * 20,
          'cardio_liking': 40 + rand.nextInt(2) * 20,
          'yoga_liking': 40 + rand.nextInt(2) * 20
        },
        {
          'strength_ability': 40 + rand.nextInt(5) * 10,
          'cardio_ability': 40 + rand.nextInt(5) * 10,
          'yoga_ability': 40 + rand.nextInt(5) * 10
        },
        Map.fromIterables(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            List.generate(7, (index) => rand.nextInt(2))),
        {'time_span': 15 + rand.nextInt(4) * 15},
        {
          'neuroticism': -1 + rand.nextInt(2) * 2,
          'conscientiousness': -1 + rand.nextInt(2) * 2,
          'openness': 2 + rand.nextInt(2)
        }
      ];

  // get user data
  var _profile = [];
  var _likings = {}, _abilities = {}, _workoutDays = {}, _personalities = {};
  var _timeSpan = 15;
  var _mostLike = '', _leastLike = '';
  var _bestAbility = '', _worstAbility = '';
  var _sumLikings = 0, _sumAbilities = 0, _nDays = 0, _nSame = 0;

  void getData() {
    _profile = getUsrProfile();

    _likings = _profile[0];
    _abilities = _profile[1];
    _workoutDays = _profile[2];
    _timeSpan = _profile[3]['time_span'];
    _personalities = _profile[4];

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

  get profile => _profile;

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
