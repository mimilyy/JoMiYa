import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // For Windows, Linux, macOS
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart'; // For Web IndexedDB

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;
  Box? _hiveBox;
  static const String _dbName = 'app_database.db';
  static const String _hiveBoxName = 'profiles_box';
  static const String _tableName = 'profiles';
  static late final DatabaseFactory _databaseFactory;

  static Future<void> initializeDatabaseFactory() async {
    if (kIsWeb) {
      await Hive.initFlutter(); // Initialize Hive for Web
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      _databaseFactory = databaseFactoryFfi;
    } else {
      _databaseFactory = databaseFactory; // Default for Android & iOS
    }
  }

  Future<dynamic> get database async {
    if (kIsWeb) {
      return await _initHiveDatabase();
    } else {
      return await _initDatabase();
    }
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasePath();
    return await _databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );
  }

  Future<Box> _initHiveDatabase() async {
    _hiveBox ??= await Hive.openBox<Map<String, dynamic>>(_hiveBoxName);
    return _hiveBox!;
  }

  Future<String> getDatabasePath() async {
    if (Platform.isAndroid || Platform.isIOS || Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      final directory = await getApplicationDocumentsDirectory();
      return join(directory.path, _dbName);
    }
    throw UnsupportedError("Unsupported platform");
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE
      )
    ''');
  }

  // **🔹 Fixed insertProfile for Hive**
  Future<void> insertProfile(Map<String, dynamic> profile) async {
    if (kIsWeb) {
      final box = await _initHiveDatabase();
      int newId = box.length + 1; // Auto-increment key
      await box.put(newId, profile);
    } else {
      final db = await database as Database;
      await db.insert(_tableName, profile);
    }
  }

  // **🔹 Fixed getProfiles for Hive**
  Future<List<Map<String, dynamic>>> getProfiles() async {
    if (kIsWeb) {
      final box = await _initHiveDatabase();
      return box.keys.map((key) {
        Map<String, dynamic> profile = Map<String, dynamic>.from(box.get(key));
        profile['id'] = key; // Ensure the key is included in the data
        return profile;
      }).toList();
    } else {
      final db = await database as Database;
      return await db.query(_tableName);
    }
  }

  // **🔹 Fixed deleteProfile for Hive**
  Future<void> deleteProfile(int id) async {
    if (kIsWeb) {
      final box = await _initHiveDatabase();
      await box.delete(id);
    } else {
      final db = await database as Database;
      await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }
}
