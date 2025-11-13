import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_theme/flutter_custom_theme.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:voicetruth/data/constants/app_strings.dart';
import 'package:voicetruth/data/services/uni_links_service.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/common_widgets.dart';

import 'package:voicetruth/utils/CustomAppThemeData.dart';
import 'package:voicetruth/utils/app_theme_notifier.dart';
import 'package:voicetruth/utils/logger.dart';

var uuid = Uuid();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  await remoteConfigInit();
  initUniLinks();


  // ErrorWidget.builder = (e) => ErrorScreen(e);
  runZonedGuarded(()async{
    await SentryFlutter.init((options){
      options.dsn = AppStrings.sentry_url;
      options.tracesSampleRate = 1;
      options.debug = false;
      options.diagnosticLevel = SentryLevel.error;
    },);
    runApp(ChangeNotifierProvider<AppThemeNotifier>(
      create: (_) => AppThemeNotifier(),
      child: MyApp(),
    ));
  }, (exception, stackTrace)async{
    logger.e("SENTRY EXCEPTION $exception", exception, stackTrace);
    await Sentry.captureException(exception, stackTrace: stackTrace);
  });

}

class MyApp extends StatelessWidget {
  static final _navigatorGlobalKey = GlobalKey<NavigatorState>();

  static NavigatorState get navigatorState {
    if (_navigatorGlobalKey.currentState == null) {
      throw 'can\'t provide NavigatorState as it isn\'t created yet or already disposed';
    }
    return _navigatorGlobalKey.currentState!;
  }

  @override
  build(context) {
    ///Только портретный режим
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final light = CustomAppThemeData.lightTheme();
    final dark = CustomAppThemeData.darkTheme();

    return AudioServiceWidget(
      child: Consumer<AppThemeNotifier>(
        builder: (context, theme, _) {
          AppThemeNotifier.appThemeNotifier = theme;
          SystemChrome.setSystemUIOverlayStyle(theme.isDarkMode() ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
          final appTheme = (theme.isDarkMode() ? dark : light);
          return CustomThemes(
            data: [CustomThemeDataSet(data: light, dataDark: dark)],
            child: GlobalLoaderOverlay(
              useDefaultLoading: false,
              overlayColor: appTheme.buttonColor,
              overlayWidget: Center(
                child: Container(
                    child: Center(child: SizedBox(
                        height: 44,
                        width: 44,
                        child: CircularProgressIndicator(color: appTheme.splashBackground,)
                    )),
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      color: appTheme.secondaryBackground,
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              child: MaterialApp(
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                navigatorObservers: [
                  SentryNavigatorObserver()
                ],
                supportedLocales: [Locale("ru", '')],
                title: 'Голос Истины',
                theme: light.themeData,
                darkTheme: dark.themeData,
                themeMode: theme.theme,
                navigatorKey: _navigatorGlobalKey,
                initialRoute: AppNavigation.initialRoute,
                onGenerateRoute: AppNavigation.onGenerateRoute,
                debugShowCheckedModeBanner: false,
              ),
            ),
          );
        }
      ),
    );
  }
}

///Вклюаем Firebase
Future<void> initFirebase()async{
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setUserIdentifier(uuid.v4());


  final messaging = FirebaseMessaging.instance;
  messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    sound: true,
    badge: true
  );

  final notificationSettings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  messaging.getToken().then((token) => print("FCM token is $token"));
}

Future<void> remoteConfigInit()async{
  RemoteConfig remoteConfig = RemoteConfig.instance;
  // remoteConfig.setDefaults({
  //   "share_app_text": ""
  // });

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: Duration(seconds: 10),
    minimumFetchInterval: Duration(seconds: 1),
  ));

  await remoteConfig.ensureInitialized();
  bool updated = await remoteConfig.fetchAndActivate();
}

///Виджет который скрывает клавиатуру
class DismissKeyboard extends StatelessWidget {
  final Widget child;
  DismissKeyboard({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}

Future<NotificationSettings> requestPermission(){
  return FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}