import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voicetruth/ui/app_navigation.dart';

import 'package:voicetruth/ui/widgets/UiIconButton.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/widgets/dialogs/QualitySelectDialog.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';

class QualityWidget extends StatefulWidget {
  @override
  _QualityWidgetState createState() => _QualityWidgetState();
}

class _QualityWidgetState extends State<QualityWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = CustomAppThemeData.of(context);
    return Container(
      width: 99,
      child: UiIconButton(
        onClick: _onClickButton,
        icon: SvgPicture.asset(
          app.getAssetsFolder("quality.svg",true),
          height: size.w1 * 20,//(Platform.isIOS ? 30 : 28),
          color: theme.buttonColor,
        ),
        child: Column(
          children: [
            Text(
              'Качество звука',
              style: theme.textTheme.dark11w500,
            ),
            SizedBox(height: 1),
            Text(
              '${app.currentQuality?.value} кбит/с',
              style: theme.textTheme.grey10w500,
            ),
          ],
        ),
      ),
    );
  }

  void _onClickButton() async {
    var option = await QualitySelectDialog.show(context);
    if (option != null) {
      setState(() {
        app.currentQuality = option;
        app.storage.settings?.put('quality', app.currentQuality!.value);
      });

      app.player.setLoading(true);

      if (app.player.playing) {
        await app.player.pause();
        Future.delayed(Duration(seconds: 1), () {
          app.player.play();
          app.player.setLoading(false);
        });
      } else {
        app.player.setLoading(false);
      }
    }
  }
}
