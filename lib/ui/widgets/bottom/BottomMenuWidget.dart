import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/state/Player.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';

import 'package:voicetruth/ui/app_navigation.dart';
import 'EqualizerWidget.dart';
import 'QualityWidget.dart';
import 'SleepTimerWidget.dart';

class BottomMenuWidget extends StatefulWidget {
  @override
  _BottomMenuWidgetState createState() => _BottomMenuWidgetState();
}

class _BottomMenuWidgetState extends State<BottomMenuWidget> {
  @override
  build(context) {
    return Container(
        padding: EdgeInsets.only(
          left: size.w1 * 32,
          right: size.w1 * 32,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SleepTimerWidget(),
            SizedBox(
              height: size.w1 * 56.8,
              width: size.w1 * 56.8,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: StreamBuilder(
                  stream: AudioService.playbackStateStream,
                  builder:(context, snapshot) => _iconButton()
                ),
                onPressed: () => _onPressedButton(),
              ),
            ),
            QualityWidget()
          ],
        ));
  }


  bool canClick = true;
  Widget _iconButton() {
    /// Если идет загрузка данных для плеера
    if (app.player.loading) {
      return Container(
        decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(90),),
        child: SpinKitCircle(
          size: size.w1 * 35,
          color: Colors.white,
        ),
      );
    }

    /// Если плеер уже воспроизводит вещание
    if (AudioService.playbackState.playing == true) { // app.player.playing == true // Если нужно слушать аудио канал, а не стэйт
      return Container(
        decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(90),),
        child: Center(
          child: SizedBox(
            width: size.w1 * 20.7,
            height: size.w1 * 23.67,
            child: SvgPicture.asset(
              "assets/pause_icon.svg",
            ),
          ),
        ),
      );
    }

    /// Если плеер не запущен
    return Container(
      decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(90),),
      child: Center(
        child: Container(
          width: size.w1 * 20.3,
          height: size.w1 * 23.1,
          margin: EdgeInsets.only(left: size.w1 * 5),
          child: SvgPicture.asset(
            "assets/play_icon.svg",
          ),
        ),
      ),
    );
  }

  void _onPressedButton() async {
    if (canClick) {
      setState(() => canClick = false);

      try {
        if (AudioService.playbackState.playing == true) {
          await app.player.pause();
        } else {
          await app.player.play();
        }
      } on PlayerRequestExeption catch (e) {
        _showError(e.toString());
      } catch (e) {
        _showError(e.toString());
      }

      setState(() => canClick = true);
    }
  }

  Future<void> _showError(String? message) async {
    final String defaultErrorMessage = 'Ошибка воспроизведения. Попробуйте позже';
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: const Text('Ошибка'),
              content: Text(message ?? defaultErrorMessage),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          } else {
            return AlertDialog(
              title: const Text('Ошибка'),
              content: Text(message ?? defaultErrorMessage),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
        });
  }
}
