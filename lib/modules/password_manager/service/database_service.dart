import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabasePasswordService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'password_manager.db');

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE passwords (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            password TEXT
          )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      // Handle database version upgrades here
    });
  }

  Future<int> addPassword(
      String name, String description, String password) async {
    final db = await database;
    return await db.insert('passwords', {
      'name': name,
      'description': description,
      'password': password,
    });
  }

  Future<List<Map<String, dynamic>>> getPasswords() async {
    final db = await database;
    return await db.query('passwords');
  }

  Future<Map<String, dynamic>> getPasswordById(int id) async {
    final db = await database;
    final result = await db.query('passwords', where: 'id =?', whereArgs: [id]);
    return result.first;
  }

  Future<int> updatePassword(
      int id, String name, String description, String password) async {
    final db = await database;
    return await db.update(
      'passwords',
      {
        'name': name,
        'description': description,
        'password': password,
      },
      where: 'id =?',
      whereArgs: [id],
    );
  }

  Future<int> deletePassword(int id) async {
    final db = await database;
    return await db.delete('passwords', where: 'id =?', whereArgs: [id]);
  }
}
