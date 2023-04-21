
import 'package:firebase_database/firebase_database.dart';

class DB {
  // Select all entries in the {table}
  static Future<DataSnapshot?> selectAll(String table) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(table).get();
    if (snapshot.exists) {
      print("$table: ${snapshot.value}");
      return snapshot;
    }
    return null;
  }

  // Select an entry from primary key
  static Future<Object?> select(String path, String id) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(path).get();
    if (snapshot.hasChild(id)) {
      print('$path/${snapshot.child(id).key}: ${snapshot.child(id).value}');
      return snapshot.child(id).value;
    }
    return null;
  }

  // Insert {data} into {table}
  static Future<bool> insert(String path, String id, Map data) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref("$path/$id");
    try {
      await ref.set(data);
      return true;
    } catch (error) {
      print("DB.insert: $error");
      return false;
    }
  }

  // Update data (using map) from ID
  static Future<bool> update(
      String path, String id, Map<String, Object> map) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref("$path/$id");
    try {
      await ref.update(map);
      return true;
    } catch (error) {
      print("DB.update: $error");
      return false;
    }
  }

  // Delete entry from {table}
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
