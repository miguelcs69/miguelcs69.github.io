import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  static final _dbName = 'Database.db';
  static final _dbVersion = 1;
  static final _tableName = 'mytable';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnAge = 'name';


  static final columnDescripcion = 'descripcion';
  static final columnSaldo = 'saldo';
  DatabaseHelper._privateConstuctor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstuctor();

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initiateDatabase();

  Future<Database> _initiateDatabase() async {

    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {

    await db.execute(''' 
          CREATE TABLE $_tableName ( 
          $columnId INTEGER PRIMARY KEY,
          $columnName TEXT NOT NULL)          
          ''');
    await db.execute(''' 
          CREATE TABLE cuentas ( 
          $columnId INTEGER PRIMARY KEY,
          $columnDescripcion TEXT NOT NULL,
          $columnSaldo NUMERIC(12,2) NOT NULL)
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    /*await db.execute('''
          DROP TABLE CUENTAS
          ''');*/
    await db.execute(''' 
          CREATE TABLE CUENTAS ( 
          $columnId INTEGER PRIMARY KEY,
          $columnDescripcion TEXT NOT NULL,
          $columnSaldo NUMERIC(12,2) NOT NULL)
          ''');
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $_tableName'));
  }
}