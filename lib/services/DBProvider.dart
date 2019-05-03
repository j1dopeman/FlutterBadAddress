import 'dart:async';
import 'dart:io';
//import 'dart:io';

import 'package:path/path.dart';
import 'package:error/models/session.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'sample_collection.db');
    if (await Directory(dirname(path)).exists()) {
      await deleteDatabase(path);
    }

    return await openDatabase(
      join(await getDatabasesPath(), 'sample_collection.db'),
      version: 1,
      //onOpen: (db) {},
      onCreate: (Database db, int version) async {
        var sessionTable = db.execute("""
        CREATE TABLE Sessions (
          session_id INTEGER PRIMARY KEY,
          server_id INTEGER,
          user_id TEXT,
          date TEXT,
          complete BIT,
          uploaded BIT
        );""");

        var insertDummies = db.rawInsert("""
        INSERT Into Sessions (session_id,server_id,user_id,date,complete,uploaded)
        VALUES (1,-1,'Tim','05-03-2019',0,0),
        (2,-1,'John','04-02-2017',0,0);
        """);

        Future.wait([sessionTable, insertDummies]);
      },
    );
  }

  insertSession(Session newSession) async {
    final db = await database;
    int id = await db.insert("Sessions", newSession.toMap());
    return id;
  }

  updateSession(Session updSession) async {
    final db = await database;
    var res = await db.update("Sessions", updSession.toMap(),
        where: "session_id = ?", whereArgs: [updSession.sessionId]);
    return res;
  }

  getSession(int id) async {
    final db = await database;
    var res =
        await db.query("Sessions", where: "session_id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Session.fromMap(res.first) : null;
  }

  Future<List<Session>> getAllSessions() async {
    final db = await database;
    var res = await db.query("Sessions");
    List<Session> list =
        res.isNotEmpty ? res.map((c) => Session.fromMap(c)).toList() : [];
    return list;
  }
}
