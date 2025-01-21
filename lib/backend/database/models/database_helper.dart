import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Factory constructor
  factory DatabaseHelper() => _instance;

  // Private constructor
  DatabaseHelper._internal();

  // Database instance
  Database? _database;

  // Database name
  static const String _dbName = 'app_database.db';

  // Table name
  static const String _tableName = 'profiles';

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Create and open the database
  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create table
  Future<void> _onCreate(Database db, int version) async {
    print('Creating database and tables...'); // Debug: Vérifie l'exécution
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE
      )
    ''');
  }

  // Insert a profile
  Future<int> insertProfile(Map<String, dynamic> profile) async {
    final db = await database;
    return await db.insert(_tableName, profile);
  }

  // Get all profiles
  Future<List<Map<String, dynamic>>> getProfiles() async {
    final db = await database;
    return await db.query(_tableName);
  }

  // Delete a profile
  Future<int> deleteProfile(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
