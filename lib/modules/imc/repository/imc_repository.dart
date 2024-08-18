import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:utilitarios/modules/imc/models/imc_model.dart';

class ImcRepository {
  static final ImcRepository _instance = ImcRepository._();
  static Database? _database;

  ImcRepository._();

  factory ImcRepository() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'imc_history.db');

    return await openDatabase(
      databasePath,
      version: 2, // Altere a versão quando precisar fazer a migração
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE IF NOT EXISTS imc_history (' +
            'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
            'date TEXT NOT NULL,' +
            'peso REAL NOT NULL,' +
            'altura REAL NOT NULL,' +
            'imc REAL NOT NULL,' + // Certifique-se que a coluna 'imc' já existe aqui
            'categoria TEXT NOT NULL' + //TODO apagar banco de dados
            ')');
        print(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Exemplo: Adicionando uma nova coluna se ela não existia anteriormente
          await db.execute('ALTER TABLE imc_history ADD COLUMN imc REAL');
          print(db);
        }
      },
    );
  }

  Future<void> saveImc(ImcModel imc) async {
    final db = await database;
    await db.insert('imc_history', imc.toMap());
  }

  Future<List<ImcModel>> getImcHistory({int limit = 5, int offset = 0}) async {
    final db = await database;
    final result = await db.query('imc_history',
        orderBy: 'date DESC', limit: limit, offset: offset);
    return result.map((map) => ImcModel.fromMap(map)).toList();
  }

  Future<void> deleteImc(int id) async {
    final db = await database;
    await db.delete('imc_history', where: 'id = ?', whereArgs: [id]);
  }
}
