import 'dart:math';

main() {
  Algorithm algo = new Algorithm()..initializeValue();
  var schedule = algo.arrangeSchedule(algo.calcFrequency());
  var plan = algo.arrangePlan(schedule);
}

class Algorithm {
  var db;
  var likings, abilities, workout_days;

  Algorithm() {
    // generate user's profile
    db = new Data();
    likings = db.likings;
    abilities = db.abilities;
    workout_days = db.workout_days;
  }

  // Initialize (and adjust) user's profile from their survey results.
  void initializeValue() {
    // set modifiers
    int n_val = db.personalities['neuroticism'];
    int n_mul = 10;
    int c_val = db.personalities['conscientiousness'];
    int c_mul = 5;

    print('survey: $likings & $abilities');
    // adjust user's data
    likings.forEach((k, v) => {
          if (k == 'strength_liking')
            {likings[k] = v - n_val * n_mul}
          else
            {likings[k] = v + n_val * n_mul}
        });
    abilities.forEach((k, v) => {abilities[k] = v + c_val * c_mul});
    print('survey(adjust): $likings & $abilities');
  }

  Map calcFrequency() {
    Map<String, int> frequencies = {};
    likings.forEach((k, v) => {
          frequencies.putIfAbsent(
              k, () => (v / db.sum_likings * db.n_days).round())
        });
    print('settings: ${workout_days}\nfrequency: $frequencies');
    // Adjustment: the rounding step might lead to an error margin of +-1
    var sum_freq = frequencies.values.toList().fold(0, (p, c) => c + p);
    if (db.n_days > sum_freq) {
      frequencies.update(db.most_like, (v) => v + 1);
    } else if (db.n_days < sum_freq) {
      frequencies.update(db.least_like, (v) => v - 1);
    }
    print('frequency(adjust): $frequencies');

    return frequencies;
  }

  Map arrangeSchedule(Map frequencies) {
    // turn the frequency map into a list of selectable objects
    List<String> categories = [];
    frequencies.forEach((k, v) => {
          for (int i = 0; i < v; i++)
            {categories.add(k.substring(0, k.indexOf('_')))}
        });
    // shuffle the list to randomly pick objects for non-rest days
    categories.shuffle();
    Map schedule = Map<String, String>.fromIterables(
        workout_days.keys, List.generate(7, (index) => 'rest'));
    workout_days.forEach((k, v) => {
          if (v == 1) {schedule[k] = categories[0], categories.removeAt(0)}
        });
    print('schedule: $schedule');

    return schedule;
  }

  List arrangeWorkout(String type) {
    // get the workouts database
    Map workoutDB = db.getWorkoutID();
    // get users ability and settings
    var ability = (abilities['${type}_ability'] / 20).ceil();
    if (type == 'cardio') {
      ability = (abilities['${type}_ability'] / 33).ceil();
    }
    var n_loops = db.time_span / 15; // total rounds of the 10 min workout
    var n_same = db.n_same; // the number of repetitions of the 10 min workout
    var same = false;
    if (n_same > 0) {
      same = true;
    }
    print('$type: $n_loops loops ($n_same repeats) & ability $ability');

    Random rand = new Random();
    List workouts = [];
    while (workouts.length < n_loops) {
      // randomly select the difficulty level
      int i = rand.nextInt(ability);
      // randomly select five moves from the picked level
      List l = List.generate(5, (k) => workoutDB['$type'][i][rand.nextInt(50)]);
      while (same) {
        for (int j = 0; j < n_same - 1; j++) {
          // duplicate the list twice then add to the return value
          workouts.add([...l, ...List.from(l)]);
        }
        same = false;
      }
      workouts.add([...l, ...List.from(l)]);
    }

    return workouts;
  }

  Map arrangePlan(Map schedule) {
    Map plan = Map<String, List>.fromIterables(
        workout_days.keys, List.generate(7, (index) => []));
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
  Random rand = new Random(3737); // test value: 3737, 77777

  List<Map<String, dynamic>> getUsrProfile() => [
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
  var _likings = {}, _abilities = {}, _workout_days = {}, _personalities = {};
  var _time_span = 15;
  var _most_like = '', _least_like = '';
  var _best_ability = '', _worst_ability = '';
  var _sum_likings = 0, _sum_abilities = 0, _n_days = 0, _n_same = 0;

  void getData() {
    _profile = getUsrProfile();

    _likings = _profile[0];
    _abilities = _profile[1];
    _workout_days = _profile[2];
    _time_span = _profile[3]['time_span'];
    _personalities = _profile[4];

    var max = double.negativeInfinity, min = double.infinity;
    _likings.forEach((key, value) {
      if (value > max) {
        _most_like = key;
      }
      if (value < min) {
        _least_like = key;
      }
    });
    max = double.negativeInfinity;
    min = double.infinity;
    _abilities.forEach((key, value) {
      if (value > max) {
        _best_ability = key;
      }
      if (value < min) {
        _worst_ability = key;
      }
    });

    _sum_likings = _likings.values.toList().fold(0, (p, c) => c + p);
    _sum_abilities = _abilities.values.toList().fold(0, (p, c) => c + p);
    _n_days = _workout_days.values.toList().fold(0, (p, c) => c + p);

    var openness = _personalities['openness'];
    if (_time_span == 15) {
      if (openness <= 2) {
        _n_same = 2;
      }
    } else {
      if (openness <= 2) {
        _n_same = 3;
      } else if (openness == 3) {
        _n_same = 2;
      }
      if (_time_span == 60 && openness == 1) {
        _n_same = 4;
      }
    }
  }

  get profile => _profile;

  get likings => _likings;

  get abilities => _abilities;

  get workout_days => _workout_days;

  get personalities => _personalities;

  get time_span => _time_span;

  get most_like => _most_like;

  get least_like => _least_like;

  get best_ability => _best_ability;

  get worst_ability => _worst_ability;

  get sum_likings => _sum_likings;

  get sum_abilities => _sum_abilities;

  get n_days => _n_days;

  get n_same => _n_same;
}
