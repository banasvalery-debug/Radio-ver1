import 'package:flutter/material.dart';
import 'package:voicetruth/model/remote/stories/slide_model.dart';
import 'package:voicetruth/model/remote/stories/story_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/small_widgets/gradient_shadow.dart';
import 'package:voicetruth/ui/widgets/stories/stories_folder_item.dart';
import 'package:voicetruth/ui/widgets/stories/story_item_widget.dart';

import 'ScheduleTracksListWidget.dart';


class DrawerContent extends StatelessWidget {
  final VoidCallback onBack;

  const DrawerContent({Key? key,required this.onBack}) : super(key: key);
  @override
  Widget build(context) {
    final top = MediaQuery.of(context).padding.top;
    final theme = AppNavigation.theme;
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Container(
          height: size.h1 * 76,
          padding: EdgeInsets.symmetric(horizontal: size.w1 * 10),
          child: Row(
            children: [
              IconButton(
                onPressed: ()=>onBack(),
                icon: Icon(Icons.arrow_back_ios, color: theme.textDark),
                iconSize: size.w1 * 20,
              ),
              SizedBox(
                width: size.w1 * 5,
              ),
              Text(
                "Передачи на сегодня",
                style: theme.textTheme.s16w600,
              ),
            ],
          ),
        ),),
        Expanded(
          child: Stack(children: [
            ListView(
              children: [
                ScheduleTracksListWidget(),
              ],
            ),
          ]),
        ),
      ],
    );
  }
}
