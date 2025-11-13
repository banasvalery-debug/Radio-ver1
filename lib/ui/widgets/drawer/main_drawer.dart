import 'package:flutter/material.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/widgets/chat/chat_widget.dart';
import 'package:voicetruth/ui/widgets/drawer/settings_widget.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox()
        // StreamBuilder<bool>(
        //   stream: app.mainDrawerStream,
        //   builder: (context, snapshot) {
        //     bool isSettings = snapshot.data??app.isSettings;
        //     return isSettings ? SettingsWidget() : ChatWidget();
        //   }
        // )
    );
  }
}
