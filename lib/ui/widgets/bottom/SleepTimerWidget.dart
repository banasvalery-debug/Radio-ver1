import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voicetruth/model/SleepTimerOption.dart';
import 'package:voicetruth/ui/app_navigation.dart';

import 'package:voicetruth/ui/widgets/UiIconButton.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/widgets/dialogs/SleepTimerSelectDialog.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';

class SleepTimerWidget extends StatefulWidget {
  @override
  _SleepTimerWidgetState createState() => _SleepTimerWidgetState();
}

class _SleepTimerWidgetState extends State<SleepTimerWidget> {
  Duration? _duration;
  Timer? _timerPeriodic;
  int _timerSecondsPassed = 0;

  @override
  void dispose() {
    _timerPeriodic?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _getTimerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this._duration = app.getSleepTimerRest();
    final theme = CustomAppThemeData.of(context);
    return Container(
      width: 99,
      child: UiIconButton(
        onClick: _onClickButton,
        icon: SvgPicture.asset(
          app.getAssetsFolder(app.sleepTimer.duration == Duration.zero ? "timer_disabled${theme.isDark ? "_dark" : ""}.svg" : "timer_enabled${theme.isDark ? "_dark" : ""}.svg", true),
          height: size.w1 * 25,//Platform.isIOS ? 30 : 28,
        ),
        child: Column(
          children: [
            Text(
              'Таймер сна',
              style: theme.textTheme.dark11w500,
            ),
            Text(
              _timerText(),
              style: theme.textTheme.grey10w500,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _timerText() {
    if (_timerSecondsPassed > 0) {
      return "${twoDigits(_duration?.inMinutes ?? 0)}:${twoDigits((_duration?.inSeconds ?? 0).remainder(60))} осталось";
    }

    return app.sleepTimer.name;
  }

  void _onClickButton() async {
    var option = await SleepTimerSelectDialog.show(context);
    if (option != null) {
      setState(() {
        ///Выставляем данные таймера
        app.setSleepTimer(option);
        _timerSecondsPassed = app.sleepTimer.duration.inSeconds;
      });
      _setTimer();
    }
  }

  /// Получаем данные о таймере
  _getTimerData(){
    final duration = app.getSleepTimerRest();
    _timerSecondsPassed = duration.inSeconds;

    _setTimer();
  }

  /// Запускаем таймер
  void _setTimer(){
    _timerPeriodic?.cancel();
    _timerPeriodic = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if(this.mounted)
        setState(() {
          _timerSecondsPassed = _timerSecondsPassed - 1;
        });

      if (_timerSecondsPassed < 1) {
        _timerPeriodic?.cancel();
      }
    });
  }
}

String twoDigits(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}
