import 'dart:async';
import 'package:flutter/material.dart';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';

class StatusBarWidget extends StatefulWidget {
  @override
  _StatusBarWidgetState createState() => _StatusBarWidgetState();
}

class _StatusBarWidgetState extends State<StatusBarWidget> {
  final ScrollController statusScrollController = ScrollController();

  StreamSubscription? playbackStateSubscription;

  Timer? statusScrollTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _startScrollTimer();
    });

    if (playbackStateSubscription == null) {
      playbackStateSubscription = AudioService.playbackStateStream.listen((event) {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    statusScrollTimer?.cancel();
    playbackStateSubscription?.cancel();
    super.dispose();
  }

  // Начать движение блока с названием воспроизводимого трека
  void _startScrollTimer() {
    statusScrollTimer?.cancel();
    if (statusScrollController.hasClients) {
      statusScrollTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        statusScrollController.animateTo(statusScrollController.offset + 30,
            duration: Duration(seconds: 1), curve: Curves.linear);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CustomAppThemeData.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(app.currentStation.value?.currentTrack != null || app.player.loading == true
                      ? 'Сейчас в эфире'
                      : 'Подключение к эфиру',
                  style: theme.textTheme.grey11w500,
                  textAlign: TextAlign.center,),
                if(app.currentStation.value?.in_live??false)
                  ...[
                    Text(" прямая трансляция ", style: theme.textTheme.grey11w500),
                    Image.asset(app.getAssetsFolder(AppImages.radio_stream_icon, true), width: size.w1 * 14,)
                  ],
              ],
            ),
          ),
          SizedBox(height: size.h1 * 6),
          Stack(
            children: [
              Container(
                height: 30,
                margin: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: statusScrollController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext ctx, index) {
                    return Text(
                        (app.currentStation.value?.currentTrack?.name ?? ' ') + (List<String>.filled(20, '').join(' ')),
                        style: theme.textTheme.grey17w400);
                  },
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: size.w1 * 50,
                  decoration:  BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                         theme.background.withOpacity(0),
                         theme.background.withOpacity(1),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: size.w1 * 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        theme.background.withOpacity(1),
                        theme.background.withOpacity(0)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
