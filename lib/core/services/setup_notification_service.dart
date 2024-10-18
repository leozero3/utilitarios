import 'package:utilitarios/main.dart';
import 'package:utilitarios/modules/water_reminder/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;

Future<void> setupNotificationService() async {
  tz.initializeTimeZones(); // Inicializa os fusos horários.

  NotificationService notificationService =
      NotificationService(flutterLocalNotificationsPlugin);
  await notificationService.initialize();
}
