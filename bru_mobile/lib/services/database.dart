import 'dart:async';
import 'dart:io';

import 'package:bru_mobile/models/lesson_model.dart';
import 'package:bru_mobile/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {

  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  static Future<Database> get database async {
    if (_database != null)
    return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

   static initDB() async {
    Directory documentsDirectory = await getTemporaryDirectory();
    String path = join(documentsDirectory.path, "bru_timetablepss.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE lessons ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "type INTEGER,"
          "podgroup INTEGER,"
          "day INTEGER,"
          "step INTEGER,"
          "weekday INTEGER,"
          "teacherid INTEGER,"
          "time TEXT,"
          "name TEXT,"
          "location TEXT,"
          "date TEXT"
          ")");

      await db.execute("CREATE TABLE teachers ("
          "id INTEGER,"
          "fsname TEXT,"
          "lastname TEXT"
          ")");
    });
  }

  static newLesson(Lesson newLesson) async {
    final db = await database;
    //get the biggest id in the table
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into lessons (type,podgroup,day,step,weekday,teacherid,time,name,location,date)"
        " VALUES (?,?,?,?,?,?,?,?,?,?)",
        [newLesson.type, newLesson.podgroup, newLesson.day, newLesson.step, newLesson.weekday, newLesson.teacherid, newLesson.time, newLesson.name, newLesson.location, newLesson.date]);
    return raw;
  }

  static newUser(User newUser) async {
    final db = await database;
    //get the biggest id in the table
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into teachers (id,fsname,lastname)"
        " VALUES (?,?,?)",
        [newUser.id, newUser.fsname, newUser.lastname]);
    return raw;
  }

  static Future<List<User>> getAllUsers() async {
    final db = await database;
    var res = await db.query("teachers");
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }

  static Future<List<User>> getUsers() async {

    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('teachers');

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        fsname: maps[i]['fsname'],
        lastname: maps[i]['lastname'],
      );
    });
  }


  static Future<List<Lesson>> getAllLessons() async {
    final db = await database;
    var res = await db.query("lessons");
    List<Lesson> list =
        res.isNotEmpty ? res.map((c) => Lesson.fromMap(c)).toList() : [];
    return list;
  }
  static Future<List<Lesson>> getAllExams() async {
    final db = await database;
    var res = await db.query("lessons", where: "day = 0");
    List<Lesson> list =
        res.isNotEmpty ? res.map((c) => Lesson.fromMap(c)).toList() : [];
    return list;
  }

  static Future<List<Lesson>> getLessons(int day) async {
    final db = await database;
    var res = await db.query("lessons", where: "day = ?", whereArgs: [day]);
    List<Lesson> list =
        res.isNotEmpty ? res.map((c) => Lesson.fromMap(c)).toList() : [];
    debugPrint('Getter $day');
    return list;
  }

  static updateLesson(Lesson newLesson) async {
    final db = await database;
    var res = await db.update("lessons", newLesson.toMap(),
        where: "id = ?", whereArgs: [newLesson.id]);
    return res;
  }

  static deleteLesson(int id) async {
    final db = await database;
    db.delete("lessons", where: "id = ?", whereArgs: [id]);
  }
}