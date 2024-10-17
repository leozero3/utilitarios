import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:utilitarios/di/service_locator.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'app.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Alarm.init();
  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          '@mipmap/ic_launcher'); // Ícone da notificação
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
