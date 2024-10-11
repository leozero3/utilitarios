import 'package:sqflite/sqflite.dart';
import 'package:utilitarios/modules/water_reminder/model/water_reminder_model.dart';

import './water_reminder_repository.dart';

class ImplWaterReminderRepository implements WaterReminderRepository {
  final Database _database;

  ImplWaterReminderRepository(this._database);

  Future<WaterReminderModel?> loadWaterReminder() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('water_reminder');

    // Se o banco de dados contiver dados, retorne o primeiro lembrete
    if (maps.isNotEmpty) {
      return WaterReminderModel.fromMap(
          maps.first); // Certifique-se de retornar um WaterReminder
    }
    return null; // Se nenhum dado for encontrado, retorne null
  }

  @override
  Future<void> saveWaterReminder(WaterReminderModel reminder) async {
    await _database.insert(
      'water_reminder',
      reminder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<WaterReminderModel?> getWaterReminder(int id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'water_reminder',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return WaterReminderModel.fromMap(maps.first);
    }
    ;
    return null;
  }

  @override
  Future<void> deleteWaterReminder(int id) async {
    await _database.delete('water_reminder', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllReminders() async {
    await _database.delete('water_reminder');
  }
}
