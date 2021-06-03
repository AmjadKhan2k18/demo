import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "weatherDB.db";
  static final _databaseVersion = 1;

  static final tableName = 'cities';

  static final id = 'id';
  static final city = 'city';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onConfigure: _onConfigure);
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableName (
            $id integer primary key autoincrement,
            $city TEXT NOT NULL
            )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryAllRowsWithLimit(
      {String table, List<dynamic> whereargs, String where}) async {
    Database db = await instance.database;
    return await db.query(table,
        limit: 1, where: '$where = ?', whereArgs: whereargs);
  }

  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(
      Map<String, dynamic> row, String table, String columnId) async {
    Database db = await instance.database;
    var id = row['actId'];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> customSearch(
      {@required List<dynamic> whereArgs,
      @required List<String> columns,
      @required String tableName,
      @required String where}) async {
    Database db = await instance.database;
    return await db.query(tableName,
        where: '$where = ?', whereArgs: whereArgs, columns: columns);
  }

  Future<int> delete(int id, String table, String columnId) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}

var dbHelper = DatabaseHelper.instance;
