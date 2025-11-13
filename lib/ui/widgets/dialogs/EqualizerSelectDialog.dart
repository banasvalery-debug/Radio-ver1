import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:voicetruth/model/EqualizerOption.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/UiRadioThimb.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/widgets/bottom_sheet/bottom_sheet_frame.dart';

import 'AndroidBottomActionSheet.dart';

class EqualizerSelectDialog extends StatelessWidget {
  static Future<EqualizerOption?> show(context) async {
    return await AppNavigation.showModalBotSheet(BottomSheetFrame(child: EqualizerSelectDialog(),), true);
    // Show cupertino modal if platform is ios
    // if (Platform.isIOS) {
    //   return await showCupertinoModalPopup(
    //     context: context,
    //     builder: (BuildContext ctx) => EqualizerSelectDialog(),
    //   );
    // }
    //
    // // Show default modal if platform is not ios
    // return await showModalBottomSheet(
    //   backgroundColor: Colors.transparent,
    //   context: context,
    //   builder: (BuildContext ctx) => EqualizerSelectDialog(),
    // );
  }

  @override
  build(context) {
    return Column(
      children: app.equalizerOptions
            .map((e) => CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop(e);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  e.name,
                  style: AppNavigation.theme.textTheme.dark17w400,
                ),
                UiRadioThimb(checked: app.currentEqualizerPreset == e),
              ],
            )))
            .toList(),
    );
    // return Platform.isIOS ? _buildIOSDialog(context) : _buildAndroidDialog(context);
  }

  Widget _buildAndroidDialog(BuildContext context) {
    return AndroidBottomActionSheet(
      title: Text('Эквалайзер',
          style: TextStyle(
            color: Color(0xFF6D7885),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.7,
          )),
      actions: app.equalizerOptions
          .map((e) => AndroidBottomActionSheetAction(
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
                    UiRadioThimb(checked: app.currentEqualizerPreset == e),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildIOSDialog(BuildContext context) {
    return CupertinoActionSheet(
      title: Text('Эквалайзер',
          style: TextStyle(
            color: app.theme.getColor('textDark'),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          )),
      actions: app.equalizerOptions
          .map((e) => CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop(e);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.name,
                      style: TextStyle(color: app.theme.getColor('textDark'), fontSize: 17),
                    ),
                    UiRadioThimb(checked: app.currentEqualizerPreset == e),
                  ],
                ),
              )))
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
}
