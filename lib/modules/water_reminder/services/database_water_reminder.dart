import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/water_reminder_model.dart';

class DatabaseService {
  static const String _dbName = 'water_reminder.db';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  // Método para inicializar o banco de dados
  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    log('>>>>>>>>>>>>>>>>>>>Inicializando banco de dados em $path');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        log('>>>>>>>>>>>>>>>>>>Criando tabela water_reminder');
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

  // Método para salvar um lembrete
  Future<void> saveWaterReminder(WaterReminderModel reminder) async {
    log('Salvando lembrete de água no banco de dados');
    try {
      final db = await database;
      await db.insert(
        'water_reminder',
        reminder.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      log('Erro ao salvar lembrete: $e');
    }
  }

  // Método para carregar o primeiro lembrete disponível
  Future<WaterReminderModel?> loadWaterReminder() async {
    log('Carregando lembrete de água do banco de dados');
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('water_reminder');
    if (maps.isNotEmpty) {
      return WaterReminderModel.fromMap(maps.first);
    }
    return null;
  }

  // Método para buscar um lembrete específico pelo ID
  Future<WaterReminderModel?> getWaterReminder(int id) async {
    log('Buscando lembrete de água por ID');
    final List<Map<String, dynamic>> maps = await _database!.query(
      'water_reminder',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return WaterReminderModel.fromMap(maps.first);
    }
    return null;
  }

  // Método para deletar um lembrete específico pelo ID
  Future<void> deleteWaterReminder(int id) async {
    log('Deletando lembrete de água por ID');
    await _database!.delete('water_reminder', where: 'id = ?', whereArgs: [id]);
  }

  // Método para deletar todos os lembretes de água
  Future<void> deleteAllReminders() async {
    log('Deletando todos os lembretes de água');
    await _database!.delete('water_reminder');
  }
}
