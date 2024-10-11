import 'package:utilitarios/modules/water_reminder/model/water_reminder_model.dart';

abstract class WaterReminderRepository {
  Future<WaterReminderModel?> loadWaterReminder();
  Future<void> saveWaterReminder(WaterReminderModel reminder);
  Future<WaterReminderModel?> getWaterReminder(int id);
  Future<void> deleteWaterReminder(int id);
  Future<void> deleteAllReminders();
}
