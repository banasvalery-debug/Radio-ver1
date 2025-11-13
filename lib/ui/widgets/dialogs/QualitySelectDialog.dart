import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:voicetruth/model/QualityOption.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/UiRadioThimb.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/widgets/bottom_sheet/bottom_sheet_frame.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';

import 'AndroidBottomActionSheet.dart';

class QualitySelectDialog extends StatelessWidget {
  static Future<QualityOption?> show(context) async {
    return await AppNavigation.showModalBotSheet(BottomSheetFrame(child: QualitySelectDialog(),), true);
    // Show cupertino modal if platform is ios
    // if (Platform.isIOS) {
    //   return await showCupertinoModalPopup(
    //     context: context,
    //     builder: (BuildContext ctx) => QualitySelectDialog(),
    //   );
    // }
    //
    // // Show default modal if platform is not ios
    // return await showModalBottomSheet(
    //   backgroundColor: Colors.transparent,
    //   context: context,
    //   builder: (BuildContext ctx) => QualitySelectDialog(),
    // );
  }

  CustomAppThemeData get theme => AppNavigation.theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: app.qualityOptions
          .map((e) => CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop(e);
          },
          child: _buildOption(e)))
          .toList(),
    );
    // return Platform.isIOS ? _buildIOSDialog(context) : _buildAndroidDialog(context);
  }

  Widget _buildAndroidDialog(BuildContext context) {
    return AndroidBottomActionSheet(
      title: Text('Качество звука',
          style: TextStyle(
            color: Color(0xFF6D7885),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.7,
          )),
      actions: app.qualityOptions
          .map((e) => AndroidBottomActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop(e);
                },
                child: _buildOption(e),
              ))
          .toList(),
    );
  }

  Widget _buildIOSDialog(BuildContext context) {
    return CupertinoActionSheet(
      title: Text('Качество звука',
          style: TextStyle(
            color: app.theme.getColor('textDark'),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          )),
      actions: app.qualityOptions
          .map((e) => CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop(e);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: _buildOption(e),
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

  Widget _buildOption(QualityOption e) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(TextSpan(
            text: e.value.toString(),
            style: theme.textTheme.dark17w400,
            children: [
              TextSpan(
                text: " кбит/с",
                style: theme.textTheme.grey17w400,
              )
            ],
          )),
          SizedBox(height: 3),
          Text(e.name, style: theme.textTheme.grey17w400.copyWith(fontSize: size.w1 * 14))
        ],
      ),
      UiRadioThimb(checked: app.currentQuality!.value == e.value)
    ]);
  }
}
