import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:voicetruth/state/app.dart';

class AppThemeNotifier with ChangeNotifier{
  final _key = "isDarkMode";

  static late AppThemeNotifier appThemeNotifier;

  ThemeMode get theme => isDarkMode() ? ThemeMode.dark : ThemeMode.light;
  bool isDarkMode() {
    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return app.storage.themeMode?.get(_key)??isDarkMode;
  }

  bool? isDarkModeDB()=>app.storage.themeMode?.get(_key);

  Future<void>? _saveThemeToBox(bool? isDarkMode) => app.storage.themeMode?.put(_key, isDarkMode);
  Future<void> switchThemeMode(bool? themeMode) async {
    await _saveThemeToBox(themeMode);
    notifyListeners();
  }
  void notify()=>notifyListeners();
}