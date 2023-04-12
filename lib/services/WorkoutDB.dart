import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDB {
  static Database? database;

  static Future<Database> initDatabase() async {
    return database ??= await openDatabase(
      // Ensure the path is correctly for any platform
      // Database path: /data/user/0/com.example.g12/databases
      join(await getDatabasesPath(), "G12.db"),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE WORKOUT("
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

}