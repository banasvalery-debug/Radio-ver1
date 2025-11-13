import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/utils/logger.dart';

class Track {
  final String name;
  String? artist;
  String? title;
  final String filename;
  final String duration;
  String? casttitle;
  String starttime;
  DateTime startTime;
  DateTime endTime;
  //final String playlistindex; // НЕ ПРИХОДИТ С БЭКА!!!
  final String? index; // НЕ ПРИХОДИТ С БЭКА!!!
  bool hasStartTime;
  bool isLiveStream;

  Track({
    required this.name,
    this.artist,
    this.title,
    required this.filename,
    required this.duration,
    this.casttitle,
    required this.starttime,
    required this.startTime,
    required this.endTime,
    //required this.playlistindex,
    required this.index,
    this.hasStartTime = false,
    this.isLiveStream = false,
  });

  static Track fromResponse(dynamic data) {

    DateTime now = DateTime.now().toUtc().add(Duration(hours: 3)); // Get current time MSK
    DateTime currentDay = DateTime.utc(now.year, now.month, now.day);

    Track track = Track(
        name: data['casttitle']??"",
        starttime: data['starttime'] ?? '',
        startTime: now,
        endTime: now,
        filename: data['filename']??"",
        //playlistindex: data['playlistindex'],
        index: data['index'],
        duration: data['duration'],
        artist: data['artist'],
      title: data['title'],
      isLiveStream: data['is_live']
    );

    // logger.i(track.starttime);
    if (track.starttime.isNotEmpty) {
      DateFormat trackStartTimeFormat = DateFormat('H:m:s');
      DateTime trackStartTime = trackStartTimeFormat.parse(track.starttime);

      track.startTime = currentDay
          .add(Duration(hours: trackStartTime.hour, minutes: trackStartTime.minute, seconds: trackStartTime.second));

      final m = data['duration'].contains("–") ? 0 : int.parse(track.duration.toString().split(':').first);
      final s = data['duration'].contains("–") ? 0 : int.parse(track.duration.toString().split(':').last);
      track.endTime = track.startTime.add(Duration(
          minutes: m,
          seconds: s));

      track.hasStartTime = true;
    }

    return track;
  }

  bool isCurrent() {
    return index.toString() == app.currentStation.value!.playback?.playlistpos.toString();
  }

  void setStartTime(DateTime newStartTime) {
    startTime = newStartTime;
  }

  Duration getDuration() {
    return Duration(milliseconds: endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch);
  }

  Duration getLeftDuration() {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second, now.millisecond).toUtc();
    final end = DateTime(endTime.year, endTime.month, endTime.day, endTime.hour, endTime.minute, endTime.second, endTime.millisecond).toUtc();
    return Duration(
        milliseconds:
            end.millisecondsSinceEpoch - date.millisecondsSinceEpoch);
  }

  String getNotifyKey() {
    return "st_${app.currentStation.value!.id}_tr_${index.toString()}_t_${startTime.toString()}";
  }

  isScheduled() {
    return app.storage.notifications?.get(getNotifyKey()) != null;
  }

  scheduleNotification(BuildContext context) async {
    DateTime now = DateTime.now().toUtc().add(Duration(hours: 3));

    Duration interval = Duration(milliseconds: this.startTime.millisecondsSinceEpoch - now.millisecondsSinceEpoch);

    if (interval.inMilliseconds <= 0) {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            if (Platform.isIOS) {
              return CupertinoAlertDialog(
                title: const Text('Ошибка'),
                content: const Text('Не определено время воспроизведения. Попробуйте позже'),
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
              title: const Text('Ошибка'),
              content: const Text('Не определено время воспроизведения. Попробуйте позже'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                ),
              ],
            );
          });
      return;
    }

    var id = await app.notifications.schedule('Играет сейчас', this.name, interval, payload: app.currentStation.value!.name);

    await app.storage.notifications?.put(getNotifyKey(), id);
  }

  cancelNotification() async {
    var id = app.storage.notifications?.get(getNotifyKey());
    if (id == null) {
      return;
    }
    await app.notifications.cancel(id);
    await app.storage.notifications?.delete(getNotifyKey());
  }
}
