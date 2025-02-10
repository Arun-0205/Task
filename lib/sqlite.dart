
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('counter.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path = join(await getDatabasesPath(), filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        count INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> insertOrUpdateUser(String username) async {
    final db = await database;
    await db.insert(
      'users',
      {'username': username, 'count': 0},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> getUserCount(String username) async {
    final db = await database;
    final result =
        await db.query('users', where: 'username = ?', whereArgs: [username]);
    if (result.isNotEmpty) {
      return result.first['count'] as int;
    }
    return 0;
  }

  Future<void> updateUserCount(String username, int count) async {
    final db = await database;
    await db.update(
      'users',
      {'count': count},
      where: 'username = ?',
      whereArgs: [username],
    );
  }
}
