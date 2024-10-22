import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // Nome do banco de dados
  static const String _dbName = 'water_reminder.db';

  // Inicializa o banco de dados e garante que a tabela seja criada
  static Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Criação da tabela water_reminder
        await db.execute('''
          CREATE TABLE water_reminder (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            totalLiters REAL,
            startHour REAL,
            endHour REAL,
            doseAmount REAL,
            doseTimes TEXT,
            intervalInMinutes INTEGER
          )
        ''');
      },
    );
  }
}
