import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // Avoid errors
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database
  //final Future<Database> database = HeroDB.getDatabaseConnect();

  // Main work
  // Batman
  var batman = SuperHero(
    id: 0,
    name: "Batman",
    age: 50,
    ability: "Rich",
  );

  // Superman
  var superman = SuperHero(
    id: 1,
    name: "Superman",
    age: 35,
    ability: "I can fly",
  );

  // Main work
  await HeroDB.insertData(batman);
  await HeroDB.insertData(superman);
  print(await HeroDB.showAllData());

  await HeroDB.deleteData(0);
  print(await HeroDB.showAllData());
}

class HeroDB {
  static Database? database;

  // Initialize database
  static Future<Database> initDatabase() async {
    return database ??= await openDatabase(
      // Ensure the path is correctly for any platform
      join(await getDatabasesPath(), "hero_database.db"),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE HEROS("
            "id INTEGER PRIMARY KEY,"
            "name TEXT,"
            "age INTEGER,"
            "ability TEXT"
            ")");
      },

      // Version
      version: 1,
    );
  }

  // Show all data
  static Future<List<SuperHero>> showAllData() async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query("HEROS");

    return List.generate(maps.length, (i) {
      return SuperHero(
        id: maps[i]["id"],
        name: maps[i]["name"],
        age: maps[i]["age"],
        ability: maps[i]["ability"],
      );
    });
  }

  // Insert
  static Future<void> insertData(SuperHero hero) async {
    final Database db = await initDatabase();
    await db.insert(
      "HEROS",
      hero.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update
  static Future<void> updateData(SuperHero hero) async {
    final db = await initDatabase();
    await db.update(
      "HEROS",
      hero.toMap(),
      where: "id = ?",
      whereArgs: [hero.id],
    );
  }

  // Delete
  static Future<void> deleteData(int id) async {
    final db = await initDatabase();
    await db.delete(
      "HEROS",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

class SuperHero {
  // Init
  final int id;
  final String name;
  final int age;
  final String ability;
  SuperHero({
    required this.id,
    required this.name,
    required this.age,
    required this.ability,
  });

  // toMap()
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "age": age,
      "ability": ability,
    };
  }

  @override
  String toString() {
    return "SuperHero{\n  id: $id\n  name: $name\n  age: $age\n  ability: $ability\n}\n\n";
  }
}
