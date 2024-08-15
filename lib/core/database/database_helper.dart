import 'dart:io';

import 'package:diary_app/core/enum/face_enum.dart';
import 'package:diary_app/core/model/entry_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'my_table';

  static const columnId = '_id';
  static const columnText = 'text';
  static const columnEnum = 'enum';
  static const columnImagePath = 'image_path';
  static const columnDateTime = 'date_time';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnText TEXT NOT NULL,
            $columnEnum TEXT NOT NULL,
            $columnImagePath TEXT NOT NULL,
            $columnDateTime TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    final tmpRow = row;
    tmpRow[columnEnum] = enumToString<Face>(row[columnEnum]);
    return await db.insert(table, row);
  }

  Future<List<Entry>> queryAllRows() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> red = await db.query(table);
    return red.map(Entry.fromMap).toList();
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    final tmpRow = row;
    tmpRow[columnEnum] = enumToString<Face>(row[columnEnum]);
    return await db.update(table, tmpRow, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  String enumToString<T>(T value) {
    return value.toString().split('.').last;
  }

  T stringToEnum<T extends Enum>(String value, List<T> values) {
    return values.firstWhere((e) => e.toString().split('.').last == value);
  }

  Future<List<Entry>> searchEntries(String query) async {
    print('searchEntries: $query');
    Database db = await instance.database;
    // Выполняем запрос с использованием SQL LIKE
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: '$columnText LIKE ?',
      whereArgs: ['%$query%'],
    );
    return result.map(Entry.fromMap).toList();
  }
}
