import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutDB {
  static Database? database;

  static Future<Database> initDatabase() async {
    return database ??= await openDatabase(
      // Ensure the path is correctly for any platform
      // Database path: /data/user/0/com.example.g12/databases
      join(await getDatabasesPath(), "G12.db"),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE WORKOUT("
            "workoutId TEXT PRIMARY KEY,"
            "workoutName TEXT,"
            "workoutType TEXT,"
            "workoutDifficulty INTEGER,"
            ")");
      },

      // Version
      version: 1,
    );
  }

  static List<String> getColumns() {
    return [
      "workoutId",
      "workoutName",
      "workoutType",
      "workoutDifficulty",

    ];
  }

  // Select
  static Future<List<Workout>> getUserList() async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query("USER");

    return List.generate(maps.length, (i) {
      return Workout(
        workoutId: maps[i]["workoutId"],
        workoutName: maps[i]["workoutName"],
        workoutType: maps[i]["workoutType"],
        workoutDifficulty: maps[i]["workoutDifficulty"],

      );
    });
  }

  /*static Future<Workout?> getUser(String email) async {
    final List<Workout> users = await getUserList();
    for (Workout workout in users) {
      if (workout.email == email) {
        return workout;
      }
    }
    return null;
  }

  static Future<List<Map>?> getDynamicData(String email) async {
    final User? user = await getUser(email);

    if (user != null) {
      return [
        {
          'height': user.height,
          'weight': user.weight,
          'timeSpan': user.timeSpan,
        },
        Map.fromIterables(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            user.workoutDays.split('')),
        {
          'strengthLiking': user.strengthLiking,
          'cardioLiking': user.cardioLiking,
          'yogaLiking': user.yogaLiking,
        },
        {
          'strengthAbility': user.strengthAbility,
          'cardioAbility': user.cardioAbility,
          'yogaAbility': user.yogaAbility,
        },
      ];
    } else {
      return null;
    }
  }

  static Future<String> getPassword(String email) async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> maps =
    await db.rawQuery("SELECT password FROM USER WHERE email = '$email'");
    if (maps.isEmpty) {
      return '';
    } else {
      return maps[0]["password"];
    }
  }
*/
  // Insert
  static Future<bool> insertWorkout(Workout workout) async {
    final Database db = await initDatabase();
    int row = await db.insert(
      "WORKOUT",
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return (row != 0) ? true : false;
  }

  // Update
  /*static Future<bool> updateWorkout(Workout workout) async {
    final db = await initDatabase();
    int count = await db.update(
      "WORKOUT",
      workout.toMap(),
      where: "email = ?",
      whereArgs: [user.email],
    );
    return (count != 0) ? true : false;
  }

  static Future<bool> updateData(
      String email, Map<String, dynamic> data) async {
    final db = await initDatabase();
    int count = await db.update(
      "USER",
      data,
      where: "email = ?",
      whereArgs: [email],
    );
    return (count != 0) ? true : false;
  }

  // Delete
  static Future<bool> deleteUser(String email) async {
    final db = await initDatabase();
    int count = await db.delete(
      "USER",
      where: "email = ?",
      whereArgs: [email],
    );
    return (count != 0) ? true : false;
  }*/
}

class Workout {
  // Init
   String workoutId, workoutName,workoutType;
  //final String email, gender, birthday;
   int workoutDifficulty;


  Workout({
    required this.workoutId,
    required this.workoutName,
    required this.workoutType,
    required this.workoutDifficulty,
  });

  // Setter
  void setData(Map<String, dynamic> data) {
    workoutId = data['workoutId'] ?? workoutId;
    workoutName = data['workoutName'] ?? workoutName;
    workoutType = data['workoutType'] ?? workoutType;
    workoutDifficulty = data['workoutDifficulty'] ?? workoutDifficulty;

  }

  // toMap()
  Map<String, dynamic> toMap() {
    return {
      'workoutId': workoutId,
      'workoutName': workoutName,
      'workoutType': workoutType,
      'workoutDifficulty':  workoutDifficulty,
    };
  }

  /*Map<String, num> getPersonality() {
    return {
      'neuroticism': neuroticism,
      'conscientiousness': conscientiousness,
      'openness': openness,
    };
  }

  List<Map<String, num>> getDynamicData() {
    return [
      {
        'height': height,
        'weight': weight,
        'timeSpan': timeSpan,
      },
      Map.fromIterables(['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
          List.generate(7, (index) => int.parse(workoutDays[index]))),
      {
        'strengthLiking': strengthLiking,
        'cardioLiking': cardioLiking,
        'yogaLiking': yogaLiking,
      },
      {
        'strengthAbility': strengthAbility,
        'cardioAbility': cardioAbility,
        'yogaAbility': yogaAbility,
      },
    ];
  }

  @override
  String toString() {
    return "UserInfo{\n  email: $email\n  password: $password\n"
        "  userName: $userName\n  gender: $gender\n"
        "  birthday: $birthday\n  neuroticism: $neuroticism\n"
        "  conscientiousness: $conscientiousness\n  openness: $openness\n"
        "  height: $height\n  weight: $weight\n"
        "  timeSpan: $timeSpan\n  workoutDays: $workoutDays\n"
        "  strengthLiking: $strengthLiking\n  cardioLiking: $cardioLiking\n"
        "  yogaLiking: $yogaLiking\n  strengthAbility: $strengthAbility\n"
        "  cardioAbility: $cardioAbility\n  yogaAbility: $yogaAbility\n}";
  }*/
}
