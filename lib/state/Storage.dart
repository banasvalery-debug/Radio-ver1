import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:voicetruth/utils/app_theme_notifier.dart';

class Storage {
  Box<dynamic>? settings;
  Box<dynamic>? notifications;
  Box<bool?>? themeMode;
  Box<bool?>? firstAppLaunch;

  init() async {
    await Hive.initFlutter();

    notifications = await Hive.openBox('notifications');
    settings = await Hive.openBox('settings');
    themeMode = await Hive.openBox('themeMode');

    AppThemeNotifier.appThemeNotifier.notify();
  }
}
