import 'package:flutter/material.dart';
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

  await setupNotificationService();

  await setup();
  // Future<void> checkAndroidScheduleExactAlarmPermission() async {
  //   final status = await Permission.scheduleExactAlarm.status;
  //   print('Schedule exact alarm permission: $status.');
  //   if (status.isDenied) {
  //     print('Requesting schedule exact alarm permission...');
  //     final res = await Permission.scheduleExactAlarm.request();
  //     print(
  //         'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
  //   }
  // }

  runApp(MyApp());
}
