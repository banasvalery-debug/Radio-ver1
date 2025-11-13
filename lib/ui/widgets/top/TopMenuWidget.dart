import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';

import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/dialogs/StationSelectDialog.dart';
import 'package:voicetruth/ui/widgets/drawer/settings_widget.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';
import 'package:voicetruth/utils/app_theme_notifier.dart';
import 'package:voicetruth/utils/logger.dart';

class TopMenuWidget extends StatelessWidget {
  final VoidCallback onDrawer, onChat;
  final Function(bool) onChangePlayer;
  final bool isPlayer;

  const TopMenuWidget({Key? key,required this.onDrawer,required this.onChangePlayer,required this.isPlayer, required this.onChat}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = CustomAppThemeData.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.w1 * 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder(
              valueListenable: app.currentStation,
              builder: (context, c, d){
                return InkWell(
                  onTap: () => onSelectStation(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Выбор станции',
                        style: theme.textTheme.grey10w400,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            app.currentStation.value?.name??"",
                            style: theme.textTheme.s12w600,
                          ),
                          const SizedBox(width: 4),
                          SvgPicture.asset("assets/dropdown.svg", color: theme.buttonColor,),
                        ],
                      )
                    ],
                  ),
                );
              }),
          Row(
            children: [
              // InkWell(onTap:AppNavigation.toTest , child: Text(" TEST "),),
              // SizedBox(width: 50,child: Switch(value: isPlayer, onChanged: onChangePlayer)),SizedBox(width: 5,),
              InkWell(
                child: StreamBuilder<DateTime>(
                  stream: app.chat.dateTimeStream,
                  builder: (context, snapshot) {
                    final count = app.chat.getUnreadMessagesCount();
                    return SizedBox(
                      width: size.w1 * (count==0 ? 25 : 35),
                      child: Stack(children: [
                        SvgPicture.asset(app.getAssetsFolder(AppImages.chat_top_icon, true), height: size.w1 * 24, color: theme.buttonColor.withOpacity(app.isAuthorized ? 1 : 0.3),),
                        if(count>0)
                        Positioned(
                          right: 0,top: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: EdgeInsets.all(size.w1 * 1.4),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.pink,
                                borderRadius: BorderRadius.circular(5),
                                // border: Border.all(
                                //   width: size.w1 * 1.4,
                                //   color: Colors.white
                                // )
                              ),
                              constraints: BoxConstraints(
                                minWidth: size.w1 * 20,
                                minHeight: size.w1 * 15,
                              ),
                              padding: EdgeInsets.symmetric(vertical: size.w1,),
                              child: Center(child: Text("$count", style: AppTextStyles.white10w500,)),
                            ),
                          ),
                        )
                      ],),
                    );
                  }
                ),
                onTap: () {
                  if(app.isAuthorized) onChat();
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  app.getAssetsFolder(AppImages.channels_top_icon, true),
                  height: size.w1 * 24,
                  color: theme.buttonColor,
                ),
                onPressed: () {
                  // Scaffold.of(context).openEndDrawer();
                  onDrawer();
                },
                // onPressed: () => SettingsWidget.show(context),
              ),
              InkWell(
                  onTap: ()=>SettingsWidget.show(context),
                  child: SvgPicture.asset(app.getAssetsFolder(AppImages.settings_icon, true), height: size.w1 * 24, color: theme.buttonColor,))
            ],
          ),
        ],
      ),
    );
  }

  Future<void> onSelectStation(BuildContext context) async {
    try{
      var result = await StationSelectDialog.show(context);

      if (result != null) {
        app.call_status.value = null;
        app.currentStation.value = result;
        app.storage.settings?.put('station', result.id);

        app.checkQualityList();

        app.player.setLoading(true);

        app.currentStation.value!.loadData();

        if (app.player.playing) {
          await app.player.pause();
          Future.delayed(Duration(seconds: 1), () {
            app.player.play();
            app.player.setLoading(false);
          });
        } else {
          await Future.delayed(Duration(seconds: 1));
          app.player.setLoading(false);
        }
      }
    }catch(e){
      logger.e("ERROR", "e $e");
    }
  }
}
