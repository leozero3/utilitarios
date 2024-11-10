import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoDatabase {
  static const String _dbName = "todo.db";
  static Database? _database;

  static TodoDatabase? _instance;
  TodoDatabase._();

  static TodoDatabase get instance {
    _instance ??= TodoDatabase._();
    return _instance!;
  }

  Future<Database> initDatabase() async {
    log('========== initDatabase');
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    // Remova o banco de dados anterior para garantir que `onCreate` seja chamado
    // await deleteDatabase(path);

    log('========== Abrindo o banco de dados');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        log('========== Criando tabela');
        var batch = db.batch();
        _createTable(batch);
        await batch.commit();
        log('========== Tabela criada');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        log('========== Atualizando banco de dados');
        var batch = db.batch();
        _upgradeDatabase(oldVersion, batch);
        await batch.commit();
      },
    );

    return _database!;
  }

  void _createTable(Batch batch) {
    batch.execute(
      """
      CREATE TABLE IF NOT EXISTS todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        priority INTEGER NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      """,
    );
  }

  void _upgradeDatabase(int oldVersion, Batch batch) {
    // Aqui você pode adicionar alterações de estrutura quando necessário
  }
}

Future<void> checkTables() async {
  final db = await TodoDatabase.instance.initDatabase();
  final tables =
      await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
  log("Tabelas no banco de dados: $tables");
}
