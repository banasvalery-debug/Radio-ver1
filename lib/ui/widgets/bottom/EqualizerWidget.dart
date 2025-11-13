import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voicetruth/ui/app_navigation.dart';

import 'package:voicetruth/ui/widgets/UiIconButton.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/widgets/dialogs/EqualizerSelectDialog.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';

class EqualizerWidget extends StatefulWidget {
  @override
  _EqualizerWidgetState createState() => _EqualizerWidgetState();
}

class _EqualizerWidgetState extends State<EqualizerWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = CustomAppThemeData.of(context);
    final isDefault = app.currentEqualizerPreset.id==1;
    return Container(
      width: 99,
      child: UiIconButton(
        onClick: _onClickButton,
        icon: SvgPicture.asset(
          isDefault ? app.getAssetsFolder("eq_disabled.svg", true) : app.getAssetsFolder("eq_enabled${theme.isDark ? "_dark" : ""}.svg", true),
          color: isDefault ? theme.buttonColor : null,
          height: size.w1 * 25//Platform.isIOS ? 30 : 28,
        ),
        child: Column(
          children: [
            Text(
              'Эквалайзер',
              style: theme.textTheme.dark11w500,
            ),
            Text(
              app.currentEqualizerPreset.name,
              style: theme.textTheme.grey10w500,
            ),
          ],
        ),
      ),
    );
  }

  void _onClickButton() async {
    var option = await EqualizerSelectDialog.show(context);
    if (option != null) {
      setState(() {
        app.currentEqualizerPreset = option;
        app.storage.settings?.put('equalizer', app.currentEqualizerPreset.id);
        app.player.setEqualizer(option);
      });
    }
  }
}
