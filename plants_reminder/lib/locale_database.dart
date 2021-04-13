import 'dart:io' as io;
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static final _databaseName = "plants_reminer.db";
  static final _databaseVersion = 1;

  static final tableUser = "user";
  static final columnUserId = 'id';
  static final columnUserGuid = 'guid';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUser (
        $columnUserId INTEGER PRIMARY KEY UNIQUE NOT NULL AUTOINCREMENT,
        $columnUserGuid VARCHAR(64) UNIQUE NOT NULL
      )
    ''');
  }

  static Future<void> insertDB(String guid) async {
    Database db = await instance.database;
    int id = await db.insert(tableUser, {"$columnUserGuid": guid});
    print("user inserted: " + id.toString());
  }

  static Future<String> getUserGuid() async {
    Database db = await instance.database;
    List<Map> users = await db.query(tableUser);
    if (users.length > 0) {
      return users[0]['$columnUserGuid'];
    }
  }

  Future<void> dropTable() async {
    Database db = await instance.database;
    await db.execute('''
      DROP TABLE IF EXISTS $tableUser
    ''');
  }
}
