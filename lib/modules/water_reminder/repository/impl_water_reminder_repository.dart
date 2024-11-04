import 'dart:developer';
import 'package:sqflite_common/sqlite_api.dart';

import '../model/water_reminder_model.dart';
import '../services/database_water_reminder.dart';
import './water_reminder_repository.dart';

class ImplWaterReminderRepository implements WaterReminderRepository {
  final DatabaseService _databaseService = DatabaseService();
  ImplWaterReminderRepository();

  // Carrega o primeiro lembrete de água disponível
  @override
  Future<WaterReminderModel?> loadWaterReminder() async {
    log('Repositório: carregando lembrete de água');
    return await _databaseService.loadWaterReminder();
  }

  // Salva um novo lembrete de água
  @override
  Future<void> saveWaterReminder(WaterReminderModel reminder) async {
    log('Repositório: salvando lembrete de água');
    await _databaseService.saveWaterReminder(reminder);
  }

  // Busca um lembrete específico pelo ID
  @override
  Future<WaterReminderModel?> getWaterReminder(int id) async {
    log('Repositório: buscando lembrete de água por ID');
    return await _databaseService.getWaterReminder(id);
  }

  // Deleta um lembrete específico pelo ID
  @override
  Future<void> deleteWaterReminder(int id) async {
    log('Repositório: deletando lembrete de água por ID');
    await _databaseService.deleteWaterReminder(id);
  }

  // Deleta todos os lembretes de água
  Future<void> deleteAllReminders() async {
    log('Repositório: deletando todos os lembretes de água');
    await _databaseService.deleteAllReminders();
  }
}
