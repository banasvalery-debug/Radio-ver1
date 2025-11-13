import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voicetruth/main.dart';
import 'package:voicetruth/model/remote/stories/story_model.dart';
import 'package:voicetruth/ui/screens/authorization/auth_screen.dart';
import 'package:voicetruth/ui/screens/authorization/otp_screen.dart';
import 'package:voicetruth/ui/screens/authorization/profile_register_screen.dart';
import 'package:voicetruth/ui/screens/home/HomeScreen.dart';
import 'package:voicetruth/ui/screens/home/call_to_stream/call_to_stream_screen.dart';
import 'package:voicetruth/ui/screens/home/stories/saved_stories_screen.dart';
import 'package:voicetruth/ui/screens/home/stories/stories_screen.dart';
import 'package:voicetruth/ui/screens/settings/theme_change_screen.dart';
import 'package:voicetruth/ui/screens/splash/SplashScreen.dart';
import 'package:voicetruth/ui/screens/test/test_screen.dart';
import 'package:voicetruth/ui/widgets/chat/chat_widget.dart';
import 'package:voicetruth/ui/widgets/drawer/settings_widget.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';

///Навигация в приложении
class _RoutesNames {
  static const String splash = "splash";
  static const String home = "home";
  static const String call_to_stream = "home/call_to_stream";
  static const String home_error = "home_error";
  static const String auth = "authorization";
  static const String otp = "otp";
  static const String profile_register = "profile_register";
  static const String stories = "stories";
  static const String savedStories = "savedStories";
  static const String chat = "chat";
  static const String settings = "settings";
  static const String themechange = "settings/themechange";


  static const String test = "test";
}

class AppSizes {
  late double w1, h1;
  late double height, width;
  AppSizes(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    w1 = width * 1 / 375;
    h1 = height * 1 / 812;
    if(height/width < 2){
      w1 = 1;
      h1 = 1;
    }
    w1 = min(w1, h1);
    h1 = w1;
  }
}

class AppNavigation {
  static String get initialRoute => _RoutesNames.splash;

  static NavigatorState get _navigatorState => MyApp.navigatorState;

  static AppSizes get sizeScales => AppSizes(_navigatorState.context);

  static BuildContext get context => _navigatorState.context;

  static CustomAppThemeData get theme => CustomAppThemeData.of(_navigatorState.context);

  ///
  /// Root navigation
  ///
  static void pop([result]) => _navigatorState.pop(result);
  static toHome() => _navigatorState.pushNamedAndRemoveUntil(_RoutesNames.home, (_) => false);
  static toCallToStream() => _navigatorState.pushReplacementNamed(_RoutesNames.call_to_stream);
  static toHomeError() => _navigatorState.pushNamedAndRemoveUntil(_RoutesNames.home_error, (_) => false);
  static toAuth() => _navigatorState.pushNamedAndRemoveUntil(_RoutesNames.auth, (_) => false);
  static toOtp(String phone, int? frt) => _navigatorState.pushNamed(_RoutesNames.otp, arguments: [phone, frt]);
  static toProfileRegister([bool isEdit = false]) => (isEdit ? _navigatorState.pushNamed : _navigatorState.pushReplacementNamed)(_RoutesNames.profile_register,arguments: isEdit);
  static Future toStories(StoryModel story, [bool isFavourite = false]) => _navigatorState.pushNamed(_RoutesNames.stories, arguments: [story, isFavourite]);
  static toSavedStories() => _navigatorState.pushNamed(_RoutesNames.savedStories);
  // static toChat() => _navigatorState.pushNamed(_RoutesNames.chat);
  static toTest() => _navigatorState.pushNamed(_RoutesNames.test);
  static toSettings() => _navigatorState.pushNamed(_RoutesNames.settings);
  static toThemeChange() => _navigatorState.pushNamed(_RoutesNames.themechange);

  ///
  /// moves
  ///
  static Future<dynamic> showAppDialog(Widget child) =>
      showDialog(context: _navigatorState.context, builder: (c) => child);
  static void showBotSheet(Widget child, [BuildContext? context]) =>
      showBottomSheet(
          context: context ?? _navigatorState.context, builder: (_) => child);
  static Future<dynamic> showModalBotSheet(Widget child,
          [bool isScrollControlled = false]) =>
      showModalBottomSheet(
          context: _navigatorState.context,
          backgroundColor: Colors.transparent,
          builder: (_) => child,
          isScrollControlled: isScrollControlled);

  ///
  /// onGenerateRoute
  ///
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case _RoutesNames.splash:
        return MaterialPageRoute(builder: (context) => SplashScreen(), settings: settings);
      case _RoutesNames.home:
        return MaterialPageRoute(builder: (context) => HomeScreen(), settings: settings);
      case _RoutesNames.call_to_stream:
        return MaterialPageRoute(builder: (context) => CallToStreamScreen(), settings: settings);
      case _RoutesNames.home_error:
        return MaterialPageRoute(builder: (context) => HomeErrorScreen(), settings: settings);
      case _RoutesNames.auth:
        return MaterialPageRoute(builder: (context) => AuthScreen(), settings: settings);
      case _RoutesNames.otp:
        return CupertinoPageRoute(builder: (context) => OtpScreen(), settings: settings);
      case _RoutesNames.profile_register:
        final bool isEdit = (settings.arguments as bool?)??false;
        return CupertinoPageRoute(builder: (context) => ProfileRegisterScreen(isEdit: isEdit), settings: settings);
      case _RoutesNames.stories:
        return PageRouteBuilder(
          fullscreenDialog: true,
            pageBuilder: (context, animation, secondaryAnimation){
              return StoriesScreen(
                story: (settings.arguments as List)[0],
                isFavourite: (settings.arguments as List)[1],
              );
            },
            settings: settings,
            opaque: false,
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: (context, a1, a2, c) {
              return c;
            }
          );
      case _RoutesNames.savedStories:
        return MaterialPageRoute(builder: (context) => SavedStoriesScreen(), settings: settings);
      case _RoutesNames.test:
        return MaterialPageRoute(builder: (context) => TestScreen(), settings: settings);
      // case _RoutesNames.chat:
      //   return CupertinoPageRoute(builder: (context) => ChatWidget());
      case _RoutesNames.settings:
        return CupertinoPageRoute(builder: (context) => SettingsWidget());
      case _RoutesNames.themechange:
        return CupertinoPageRoute(builder: (context) => ThemeChangeScreen());
      default:
        throw 'no case for route "${settings.name}"';
    }
  }
}

AppSizes get size => AppNavigation.sizeScales;
