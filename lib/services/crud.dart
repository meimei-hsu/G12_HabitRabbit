import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';

import 'package:g12/services/database.dart';

// ignore_for_file: avoid_print

class DB {
  // Select all entries in the given table {table}
  static Future<DataSnapshot?> selectAll(String table) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(table).get();
    if (snapshot.exists) {
      print("$table: ${snapshot.value}");
      return snapshot;
    }
    return null;
  }

  // Select an entry from given path {path/id}
  static Future<Object?> select(String path, String id) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(path).get();
    if (snapshot.hasChild(id)) {
      print('$path/${snapshot.child(id).key}: ${snapshot.child(id).value}');
      return snapshot.child(id).value;
    }
    return null;
  }

  // Insert data {columnName: value} into table {path/id}
  static Future<bool> insert(String path, Map data) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    try {
      await ref.set(data);
      return true;
    } catch (error) {
      print("DB.insert: $error");
      return false;
    }
  }

  // Update data {columnName: value} into table {path/id}
  // set vs update: https://stackoverflow.com/a/38924648
  static Future<bool> update(String path, Map data) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    try {
      await ref.update(Map<String, Object>.from(data));
      return true;
    } catch (error) {
      print("DB.update: $error");
      return false;
    }
  }

  // Delete entry from table {path/id}
  static Future<bool> delete(String path, String id) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref("$path/$id");
    try {
      await ref.remove();
      return true;
    } catch (error) {
      print("DB.delete: $error");
      return false;
    }
  }
}

class JournalDB {
  static const db = "journal";

  // Select whole table of user's journal records
  static Future<SplayTreeMap?> getTable(String userID, String table) async {
    var snapshot = await DB.selectAll("$db/$userID/$table");
    return (snapshot != null)
        ? SplayTreeMap<String, dynamic>.from(
            (snapshot.value) as Map, (a, b) => a.compareTo(b))
        : null;
  }

  // Select user's journal records from given dates
  static Future<Map?> getFromDates(
      String userID, List<String> dates, String table) async {
    Map retVal = {};
    Map? records = await getTable(userID, table);
    if (records != null) {
      for (String date in dates) {
        if (records.containsKey(date)) {
          retVal[date] = records[date];
        }
      }
    }
    return retVal.isNotEmpty ? retVal : null;
  }

  static Future<String?> getFromDate(
      String userID, DateTime date, String table) async {
    var records = await DB.select("$db/$userID/$table", Calendar.dateToString(date));
    return (records != null) ? records as String : null;
  }

  // Select the user's journal records of the given week
  static Future<Map?> getThisWeek(String userID, String table) async =>
      getFromDates(userID, Calendar.thisWeek(), table);

  static Future<Map?> getNextWeek(String userID, String table) async =>
      getFromDates(userID, Calendar.nextWeek(), table);

  // Insert data {date: data} into table {journal/userID/table/date}
  static Future<bool> insert(String userID, Map map, String table) async {
    for (MapEntry e in map.entries) {
      var success = await DB.insert("$db/$userID/$table", {e.key: e.value});
      if (success == false) {
        return false;
      }
    }
    return true;
  }

  // Update data {date: data} into table {journal/userID/table/date}
  static Future<bool> update(String userID, Map map, String table) async {
    for (MapEntry e in map.entries) {
      var success = await DB.update("$db/$userID/$table", {e.key: e.value});
      if (success == false) {
        return false;
      }
    }
    return true;
  }

  // Delete data from {journal/userID/table/date}
  static Future<bool> delete(String userID, String date, String table) async {
    return DB.delete("$db/$userID/$table", date);
  }
}
