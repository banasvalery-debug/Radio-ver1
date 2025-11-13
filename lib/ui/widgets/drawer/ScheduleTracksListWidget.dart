import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';

import 'TrackWidget.dart';

class ScheduleTracksListWidget extends StatefulWidget {
  @override
  createState() => _ScheduleTracksListWidgetState();
}

class _ScheduleTracksListWidgetState extends State<ScheduleTracksListWidget> {

  CustomAppThemeData get theme => AppNavigation.theme;
  @override
  build(context) {
    if(app.currentStation.value == null) return SizedBox();
    final stationTrackList = app.currentStation.value!.getTrackList();

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListView.separated(
            padding: const EdgeInsets.only(top: 0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext ctx, index) {
              return Divider(
                color: theme.secondaryColor,
              );
            },
            itemCount: stationTrackList.length != 0 ? stationTrackList.length : 10,
            itemBuilder: (BuildContext ctx, int index) {
              if (stationTrackList.length != 0) {
                return TrackWidget(
                    track: stationTrackList[index],
                    onTap: () {
                      setState(() {});
                    });
              }
              return UiTrackSkeleton();
            },
          ),
          const SizedBox(height: 28,),
        ],
      ),
    );
  }
}
