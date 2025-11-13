import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:voicetruth/model/SleepTimerOption.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/UiRadioThimb.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/widgets/bottom_sheet/bottom_sheet_frame.dart';

class SleepTimerSelectDialog extends StatelessWidget {
  static Future<SleepTimerOption?> show(context) async {
    return await AppNavigation.showModalBotSheet(BottomSheetFrame(child: SleepTimerSelectDialog(),), true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppNavigation.theme;
    return Column(
      children: [
        ...app.sleepTimerOptions
            .map((e) => CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop(e);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                e.name,
                style: theme.textTheme.dark17w400,
              ),
              UiRadioThimb(checked: app.sleepTimer == e),
            ],
          ),
        ))
            .toList(),
      ],
    );
    return cupertinoActionSheet(context);
  }

  Widget cupertinoActionSheet(BuildContext context)=>CupertinoActionSheet(
    title: Text('Таймер сна',
        style: TextStyle(
          color: app.theme.getColor('textDark'),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        )),
    actions: app.sleepTimerOptions
        .map((e) => CupertinoActionSheetAction(
      onPressed: () {
        Navigator.of(context).pop(e);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            e.name,
            style: TextStyle(color: app.theme.getColor('textDark'), fontSize: 17),
          ),
          UiRadioThimb(checked: app.sleepTimer == e),
        ],
      ),
    ))
        .toList(),
    cancelButton: CupertinoActionSheetAction(
      isDestructiveAction: true,
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('Отмена', style: TextStyle(color: Colors.red, fontSize: 17)),
    ),
  );
}
