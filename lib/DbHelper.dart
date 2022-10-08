import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'note.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  DbHelper.internal();

  static Database? _db;

  createDatabase() async {
    if (_db != null) {
      return _db;
    }
    String path = join(await getDatabasesPath(), 'notes.db');
    _db = await openDatabase(path, version: 1, onCreate: (Database db, int v) {
      db.execute(
          'create table tasks (id integer primary key autoincrement , task varchar(50),date integer,isChecked boolean )');
    });
    return _db;
  }

  Future<int> createTask(Note note) async {
    Database db = await createDatabase();
    return db.insert('tasks', note.toMap());
  }

  Future<List> allTasks() async {
    Database db = await createDatabase();
    return db.query('tasks');
  }

  Future<int> delete(int? id) async {
    Database db = await createDatabase();
    return db.delete('tasks', where: 'id=?', whereArgs: [id]);
  }

  Future<int> createUpdate(Note note) async {
    Database db = await createDatabase();
    return await db
        .update('tasks', note.toMap(), where: 'id=?', whereArgs: [note.id]);
  }
}
