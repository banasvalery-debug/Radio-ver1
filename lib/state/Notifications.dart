import 'dart:io';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  IOSInitializationSettings? initializationSettingsIOS;

  final MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings(
      requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);

  AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1001', 'Уведомления', 'Уведомления приложения',
      importance: Importance.max, priority: Priority.high, showWhen: false);

  NotificationDetails? platformChannelSpecifics;

  init() async {
    initializationSettingsIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: initializationSettingsMacOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);

    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
  }

  Future selectNotification(String? payload) async {
    if (payload != null && payload.isNotEmpty) {
      // print('notification payload: $payload');
    }
  }

  Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    this.selectNotification(payload);
  }

  show(String title, String body, {String? payload}) async {
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  schedule(String title, String body, Duration interval, {String? payload}) async {
    int id = tz.TZDateTime.now(tz.local).add(interval).millisecondsSinceEpoch ~/ 1000;
    await flutterLocalNotificationsPlugin.zonedSchedule(id, title, body, tz.TZDateTime.now(tz.local).add(interval),
        const NotificationDetails(android: AndroidNotificationDetails('1001', 'Уведомления', 'Уведомления приложения')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);

    return id;
  }

  cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
