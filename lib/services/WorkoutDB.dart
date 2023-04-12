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
      "workoutName",
      "workoutDifficulty",

    ];
  }
}