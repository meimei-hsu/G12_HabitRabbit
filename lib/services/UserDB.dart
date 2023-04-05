
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDB {
  static Database? database;

  // Initialize database
  // Only int(INTEGER), num(REAL), String(TEXT) and Uint8List(BLOB) are supported.
  static Future<Database> initDatabase() async {
    return database ??= await openDatabase(
      // Ensure the path is correctly for any platform
      // Database path: /data/user/0/com.example.g12/databases
      join(await getDatabasesPath(), "G12.db"),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE USER("
            "email TEXT PRIMARY KEY,"
            "password TEXT,"
            "userName TEXT,"
            "gender TEXT,"
            "birthday TEXT,"
            "neuroticism INTEGER,"
            "conscientiousness INTEGER,"
            "openness INTEGER,"
            "height REAL,"
            "weight REAL,"
            "timeSpan INTEGER,"
            "workoutDays TEXT,"
            "strengthLiking INTEGER,"
            "cardioLiking INTEGER,"
            "yogaLiking INTEGER,"
            "strengthAbility INTEGER,"
            "cardioAbility INTEGER,"
            "yogaAbility INTEGER"
            ")");
      },

      // Version
      version: 1,
    );
  }

  static List<String> getColumns() {
    return [
      "email",
      "password",
      "userName",
      "gender",
      "birthday",
      "neuroticism",
      "conscientiousness",
      "openness",
      "height",
      "weight",
      "timeSpan",
      "workoutDays",
      "strengthLiking",
      "cardioLiking",
      "yogaLiking",
      "strengthAbility",
      "cardioAbility",
      "yogaAbility",
    ];
  }

  // Select
  static Future<List<User>> getUserList() async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query("USER");

    return List.generate(maps.length, (i) {
      return User(
        email: maps[i]["email"],
        password: maps[i]["password"],
        userName: maps[i]["userName"],
        gender: maps[i]["gender"],
        birthday: maps[i]["birthday"],
        neuroticism: maps[i]["neuroticism"],
        conscientiousness: maps[i]["conscientiousness"],
        openness: maps[i]["openness"],
        height: maps[i]["height"],
        weight: maps[i]["weight"],
        timeSpan: maps[i]["timeSpan"],
        workoutDays: maps[i]["workoutDays"],
        strengthLiking: maps[i]["strengthLiking"],
        cardioLiking: maps[i]["cardioLiking"],
        yogaLiking: maps[i]["yogaLiking"],
        strengthAbility: maps[i]["strengthAbility"],
        cardioAbility: maps[i]["cardioAbility"],
        yogaAbility: maps[i]["yogaAbility"],
      );
    });
  }

  static Future<User?> getUser(String email) async {
    final List<User> users = await getUserList();
    for (User user in users) {
      if (user.email == email) {
        return user;
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

  // Insert
  static Future<bool> insertUser(User user) async {
    final Database db = await initDatabase();
    int row = await db.insert(
      "USER",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return (row != 0) ? true : false;
  }

  // Update
  static Future<bool> updateUser(User user) async {
    final db = await initDatabase();
    int count = await db.update(
      "USER",
      user.toMap(),
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
  }
}

class User {
  // Init
  String userName, password;
  final String email, gender, birthday;
  final int neuroticism, conscientiousness, openness;
  // dynamic data
  num height, weight; // cm, kg
  int timeSpan;
  String workoutDays;
  int strengthLiking, cardioLiking, yogaLiking;
  int strengthAbility, cardioAbility, yogaAbility;

  User({
    required this.userName,
    required this.email,
    required this.password,
    required this.gender,
    required this.birthday,
    required this.neuroticism,
    required this.conscientiousness,
    required this.openness,
    required this.height,
    required this.weight,
    required this.timeSpan,
    required this.workoutDays,
    required this.strengthLiking,
    required this.cardioLiking,
    required this.yogaLiking,
    required this.strengthAbility,
    required this.cardioAbility,
    required this.yogaAbility,
  });

  // Setter
  void setData(Map<String, dynamic> data) {
    userName = data['userName'] ?? userName;
    password = data['password'] ?? password;
    height = data['height'] ?? height;
    weight = data['weight'] ?? weight;
    timeSpan = data['timeSpan'] ?? timeSpan;
    workoutDays = data['workoutDays'] ?? workoutDays;
    strengthLiking = data['strengthLiking'] ?? strengthLiking;
    cardioLiking = data['cardioLiking'] ?? cardioLiking;
    yogaLiking = data['yogaLiking'] ?? yogaLiking;
    strengthAbility = data['strengthAbility'] ?? strengthAbility;
    cardioAbility = data['cardioAbility'] ?? cardioAbility;
    yogaAbility = data['yogaAbility'] ?? yogaAbility;
  }

  // toMap()
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
      'gender': gender,
      'birthday': birthday,
      'neuroticism': neuroticism,
      'conscientiousness': conscientiousness,
      'openness': openness,
      'height': height,
      'weight': weight,
      'timeSpan': timeSpan,
      'workoutDays': workoutDays,
      'strengthLiking': strengthLiking,
      'cardioLiking': cardioLiking,
      'yogaLiking': yogaLiking,
      'strengthAbility': strengthAbility,
      'cardioAbility': cardioAbility,
      'yogaAbility': yogaAbility,
    };
  }

  Map<String, num> getPersonality() {
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
  }
}
