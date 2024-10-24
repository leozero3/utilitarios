import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utilitarios/modules/password_manager/cubit/password_manager_cubit.dart';
import 'package:utilitarios/modules/password_manager/repository/impl_password_repository.dart';
import 'package:utilitarios/modules/password_manager/repository/password_repository.dart';
import 'package:utilitarios/modules/password_manager/service/database_service.dart';
import 'package:utilitarios/modules/password_manager/service/encryption_service.dart';
import 'package:utilitarios/modules/water_reminder/database/database.dart';
import 'package:utilitarios/modules/water_reminder/repository/impl_water_reminder_repository.dart';
import 'package:utilitarios/modules/water_reminder/repository/water_reminder_repository.dart';
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

  getIt.registerSingleton<DatabasePasswordService>(DatabasePasswordService());
  getIt.registerSingleton<EncryptionService>(EncryptionService());
  getIt.registerSingleton<PasswordRepository>(ImplPasswordRepository(
      getIt<DatabasePasswordService>(), getIt<EncryptionService>()));
  // getIt.registerLazySingleton<PasswordRepository>(
  //   () => ImplPasswordRepository(
  //       getIt<DatabasePasswordService>(), getIt<EncryptionService>()),
  // );
  getIt.registerFactory<PasswordManagerCubit>(
    () => PasswordManagerCubit(getIt<PasswordRepository>()),
  );
}
