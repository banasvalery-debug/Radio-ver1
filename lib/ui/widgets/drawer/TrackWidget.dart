import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';

import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/model/Track.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';
import 'package:voicetruth/utils/logger.dart';

class TrackWidget extends StatelessWidget {
  final Track track;
  final Function onTap;

  const TrackWidget({
    required this.track,
    required this.onTap,
  });

  CustomAppThemeData get theme => AppNavigation.theme;

  @override
  build(context) {
    var duration = 0;
    var useMinutes = true;

    if (track.getDuration().inMinutes != 0) {
      duration = track.getDuration().inMinutes;
    } else {
      duration = track.getDuration().inSeconds;
      useMinutes = false;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: size.w1 * 44,
      child: Stack(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () async {
                  if (!track.isScheduled()) {
                    await track.scheduleNotification(context);
                    onTap();
                  } else {
                    await track.cancelNotification();
                    onTap();
                  }
                },
                child: Container(
                  width: size.w1 * 44,
                  height: size.w1 * 44,
                  decoration: BoxDecoration(
                    color: !track.isCurrent() && !track.isScheduled()
                        ? theme.textDark.withOpacity(0.08)
                        : theme.primaryColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: track.isCurrent()
                        ? SvgPicture.asset(
                            "assets/play.svg",
                            width: 20,
                          )
                        : SvgPicture.asset(
                            "assets/alarm.svg",
                            width: 20,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _showTrackInfo(context, track);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                       TextSpan(
                         text: (track.artist??"").isNotEmpty && (track.title??"").isNotEmpty ? track.artist : track.name,
                          children: [
                              TextSpan(
                              text: (track.artist??"").isNotEmpty && (track.title??"").isNotEmpty ? " - ${track.title}" : "",
                                style: AppTextStyles.blueGrey14w400,// theme.textTheme.grey14w400,
                             )
                          ],
                         style: theme.textTheme.dark17w400.copyWith(fontSize: size.w1 * 14),
                       ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      track.isLiveStream ? _streamInfo() : _trackInfo(duration, useMinutes)
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
              child: Container(
                width: size.w1 * 80,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [theme.drawerBack.withOpacity(0), theme.drawerBack]

                  )
                ),
              ),
          ),
        ],
      ),
    );
  }

  Widget _streamInfo(){
    return Row(
      children: [
        Image.asset(app.getAssetsFolder(AppImages.radio_stream_icon, true), width: size.w1 * 10.4),
        SizedBox(width: size.w1 * 6.8),
        Text("Эфир в", style: theme.textTheme.grey10w500,),
        SizedBox(width: size.w1 * 6),
        Container(
          height: size.w1 * 16,
          child: Center(child: Text(track.starttime.substring(0,5), style: AppTextStyles.white10w500,)),
          padding: EdgeInsets.symmetric(horizontal: size.w1 * 5),
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(size.w1 * 3),
          ),
        ),
        SizedBox(width: size.w1 * 6),
        Text("прямая трансляция", style: theme.textTheme.grey10w500,),
      ],
    );
  }

  Widget _trackInfo(int duration,bool useMinutes){
    return Text.rich(
        TextSpan(
          text: 'Длительность  ',
          style: theme.textTheme.grey10w500,
          children: [
            TextSpan(
              text: (duration).toString(),
              style: theme.textTheme.dark11w500.copyWith(fontSize: size.w1 * 10),
            ),
            TextSpan(
              text: "  ${useMinutes ? _getMinuteText(duration) : _getSecondText(duration)}",
              style: theme.textTheme.grey10w500,
            ),
          ],
        )
    );
  }

  String _getMinuteText(int value) {
    return Intl.plural(
      value,
      zero: 'минут',
      one: 'минута',
      two: 'минуты',
      few: 'минуты',
      many: 'минут',
      other: 'минут',
      locale: 'ru_RU',
    );
  }

  String _getSecondText(int value) {
    return Intl.plural(
      value,
      zero: 'секунд',
      one: 'секунда',
      two: 'секунды',
      few: 'секунды',
      many: 'секунд',
      other: 'секунд',
      locale: 'ru_RU',
    );
  }

  _showTrackInfo(BuildContext context, Track track) {
    Widget infoWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Название: ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
            children: [
              TextSpan(
                text: track.name,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10),
        Text.rich(
          TextSpan(
            text: 'Длительность: ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
            children: [
              TextSpan(
                text: track.duration,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text('Информация'),
            content: Padding(
              padding: EdgeInsets.only(top: 10),
              child: infoWidget,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        }

        return AlertDialog(
          title: Text('Информация'),
          content: SingleChildScrollView(
            child: infoWidget,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }
}

class UiTrackSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: app.theme.getColor('secondaryColor'),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: SvgPicture.asset("assets/alarm.svg", width: 20),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 70,
                  decoration: BoxDecoration(
                    color: app.theme.getColor('secondaryColor'),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 120,
                  decoration: BoxDecoration(
                    color: app.theme.getColor('secondaryColor'),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
