import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voicetruth/ui/app_navigation.dart';

import 'package:voicetruth/ui/widgets/UiRadioThimb.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/model/Station.dart';
import 'package:voicetruth/ui/widgets/bottom_sheet/bottom_sheet_frame.dart';

import 'AndroidBottomActionSheet.dart';

class StationSelectDialog extends StatelessWidget {
  static Future<Station?> show(context) async {
    return await AppNavigation.showModalBotSheet(BottomSheetFrame(child: StationSelectDialog(),), true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppNavigation.theme;
    return ValueListenableBuilder(
        valueListenable: app.currentStation,
        builder: (context, d, v){
        return Column(
          children: app.stations
              .map((e) => CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop(e);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.name,
                    style: theme.textTheme.dark17w400.copyWith(fontWeight: FontWeight.w500),
                  ),
                  UiRadioThimb(checked: app.currentStation.value?.id == e.id),
                ],
              )))
              .toList(),
        );
    });
  }
}
