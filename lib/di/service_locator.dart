import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utilitarios/modules/water_reminder/database/database.dart';
import 'package:utilitarios/modules/water_reminder/repository/impl_water_reminder_repository.dart';
import 'package:utilitarios/modules/water_reminder/repository/water_reminder_repository.dart';
import 'package:utilitarios/modules/water_reminder/services/alarm_service.dart';
import 'package:utilitarios/modules/water_reminder/services/notification_service.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton<FlutterLocalNotificationsPlugin>(
      FlutterLocalNotificationsPlugin());

  getIt.registerSingletonAsync<Database>(() async {
    return DatabaseService.initDatabase();
  });

  getIt.registerSingletonWithDependencies<WaterReminderRepository>(
      () => ImplWaterReminderRepository(getIt.get<Database>()),
      dependsOn: [Database]);

  getIt.registerSingleton<NotificationService>(
      NotificationService(getIt.get<FlutterLocalNotificationsPlugin>()));

  // getIt.registerSingleton<AlarmService>(AlarmService());
}
