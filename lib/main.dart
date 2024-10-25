import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:utilitarios/core/services/setup_notification_service.dart';
import 'package:utilitarios/di/service_locator.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'app.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await dotenv.load(fileName: ".env");

  await setupNotificationService();

  await setup();

  runApp(MyApp());
}
