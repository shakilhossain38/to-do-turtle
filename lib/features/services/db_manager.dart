import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:intl/intl.dart';

class DbManager {
  //column names
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE toDoList(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        subTitle TEXT,
        message TEXT,
        date TEXT,
        isFavorite INT,
        isCompleted INT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

//initialize db
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'todo.db',
      version: 2,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

//create task
  static Future<int> createNewTask(
      {String? title,
      String? subTitle,
      String? message,
      String? date,
      int? isFavorite,
      int? isCompleted}) async {
    final db = await DbManager.db();
    final data = {
      'title': title,
      'subTitle': subTitle,
      "message": message,
      "date": date,
      "isFavorite": isFavorite,
      "isCompleted": isCompleted,
    };
    final id = await db.insert('toDoList', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // all tasks list
  static Future<List<Map<String, dynamic>>> getTasks({String? sortBy}) async {
    final db = await DbManager.db();
    return db.query('toDoList', orderBy: "date $sortBy");
  }

  //completed tasks list
  static Future<List<Map<String, dynamic>>> completedItem(
      {int isCompleted = 1, String? sortBy}) async {
    final db = await DbManager.db();
    return db.query(
      'toDoList',
      where: "isCompleted = ?",
      whereArgs: [isCompleted],
      orderBy: "date $sortBy",
    );
  }

  //favorite tasks list
  static Future<List<Map<String, dynamic>>> favoriteItem(
      {int isFavorite = 1, String? sortBy}) async {
    final db = await DbManager.db();
    return db.query('toDoList',
        where: "isFavorite = ?",
        whereArgs: [isFavorite],
        orderBy: "date $sortBy");
  }

  // Update task
  static Future<int> updateTask(
      {int? id,
      String? title,
      String? subTitle,
      String? message,
      String? date,
      int? isFavorite,
      int? isCompleted}) async {
    final db = await DbManager.db();

    final data = {
      'title': title,
      'subTitle': subTitle,
      "message": message,
      "date": date,
      "isFavorite": isFavorite,
      "isCompleted": isCompleted,
    };

    final result =
        await db.update('toDoList', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete task
  static Future<void> deleteTask(int id) async {
    final db = await DbManager.db();
    try {
      await db.delete("toDoList", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
