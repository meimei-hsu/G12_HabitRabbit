import 'dart:math';

main() {
  Algorithm algo = new Algorithm()..initializeValue();
  var type_freq = algo.arrangeSchedule(algo.calcFrequency());
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

    print('survey: $likings and $abilities');
    // adjust user's data
    likings.forEach((k, v) => {
          if (k == 'strength_liking')
            {likings.update(k, (value) => v - n_val * n_mul)}
          else
            {likings.update(k, (value) => v + n_val * n_mul)}
        });
    abilities
        .forEach((k, v) => {abilities.update(k, (v) => v + c_val * c_mul)});
    print('survey(adjust): $likings and $abilities');
  }

  Map calcFrequency() {
    var n_days = db.sum_days;

    Map<String, int> frequencies = {};
    likings.forEach((k, v) => {
          frequencies.putIfAbsent(
              k, () => (v / db.sum_likings * n_days).round())
        });
    print('settings: ${workout_days}\nfrequency: $frequencies');
    // Adjustment: the rounding step might lead to an error margin of +-1
    var sum_freq = frequencies.values.toList().fold(0, (p, c) => c + p);
    if (n_days > sum_freq) {
      frequencies.update(db.most_like, (v) => v + 1);
    } else if (n_days < sum_freq) {
      frequencies.update(db.least_like, (v) => v - 1);
    }
    print('frequency(adjust): $frequencies');

    return frequencies;
  }

  Map arrangeSchedule(Map frequencies){
    List<String> categories = [];
    frequencies.forEach((k, v) => {
      for (int i = 0; i < v; i++) {
        categories.add(k.substring(0, k.indexOf('_')))
      }
    });
    categories.shuffle(); // shuffle to randomly pick objects
    Map schedule = Map<String, dynamic>.from(workout_days);
    workout_days.forEach((k, v) => {
      if (v == 1) {
        schedule[k] = categories[0],
        categories.removeAt(0)
      } else {
        schedule[k] = 'rest'
      }
    });
    print('schedule: $schedule');

    return schedule;
  }

  // TODO: arrangeWorkout
  void arrangeWorkout() {}
}

class Data {
  Data() {
    getData();
  }

  // generate user profile
  Random rand = new Random(77777); // test value: 3737, 77777

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
  var _sum_likings = 0, _sum_abilities = 0, _sum_days = 0;

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
    _sum_days = _workout_days.values.toList().fold(0, (p, c) => c + p);
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

  get sum_days => _sum_days;
}
