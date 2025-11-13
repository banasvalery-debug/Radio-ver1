import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/constants/app_strings.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/data/provider/firebase_auth_provider.dart';
import 'package:voicetruth/main.dart';
import 'package:voicetruth/model/remote/remote_configs/remote_config_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/screens/settings/theme_change_screen.dart';
import 'package:voicetruth/ui/widgets/bottom_sheet/bottom_sheet_frame.dart';
import 'package:voicetruth/ui/widgets/buttons/ui_drawer_button.dart';
import 'package:voicetruth/ui/widgets/dialogs/notification_permit_dialog.dart';
import 'package:voicetruth/ui/widgets/dialogs/profile_edit_dialog.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';
import 'package:voicetruth/model/remote/user_model/user_model.dart';

class SettingsWidget extends StatefulWidget {
  static Future show(context)async{
    return await AppNavigation.toSettings();
    // return await AppNavigation.showModalBotSheet(BottomSheetFrame(child: SettingsWidget(),), true);
  }
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  CustomAppThemeData get theme => AppNavigation.theme;

  late bool isNotification;
  late String version;

  @override
  void initState() {
    version = "";
    isNotification = false;
    super.initState();
    _checkPermission();
    _checkPlatform();
  }

  _checkPlatform()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    setState(() {});
  }

  _checkPermission()async{
    isNotification = await Permission.notification.isGranted;
    setState(() {});
  }

  _notifPressed()async{
    final result = await AppNavigation.showAppDialog(NotificationPermitDialog());
    if(result??false){
      await requestPermission();
      isNotification = (await Permission.notification.request()).isGranted;
      _checkPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: size.w1 * 76,
              padding: EdgeInsets.symmetric(horizontal: size.w1 * 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: ()=>AppNavigation.pop(),
                    icon: Icon(Icons.arrow_back_ios, color: theme.textDark),
                    iconSize: size.w1 * 20,
                  ),
                  SizedBox(
                    width: size.w1 * 5,
                  ),
                  Text(
                    "Настройки",
                    style: theme.textTheme.s16w600,
                  ),
                ],
              ),
            ),
            if(app.isAuthorized)
              ...[SizedBox(height: size.w1 * 12), _profile()],
            SizedBox(height: size.w1 * 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.w1 * 24),
              child: Column(
                children: [
                  // getButton("Изменить номер телефона", () {}, null, app.getAssetsFolder(AppImages.phone_icon, true)),
                  // Divider(),
                  getButton("Настройки темы", () {
                    AppNavigation.showAppDialog(ThemeChangeScreen());
                  },  null, app.getAssetsFolder(AppImages.theme_icon, true)),
                  Divider(),
                  if(!isNotification)
                    ...[getButton("Уведомления", () {_notifPressed();}, null, app.getAssetsFolder(AppImages.notif_icon, true)),
                    Divider(),],

                  SizedBox(height: size.w1 * 40),
                  getButton("Поделиться приложением", () {
                    _share();
                  }),
                  SizedBox(height: size.w1 * 40),

                  // getButton("Условия доставки", () {}),
                  // Divider(),
                  getButton("Политика конфиденциальности", () {
                    launch(AppStrings.politics);
                  }),
                  SizedBox(height: size.w1 * 50),
                  getButton( app.isAuthorized ?
                      "Выйти из профиля" : "Войти в профиль",
                          () async{
                    await instanceFirebaseAuthProvider.logout();
                    AppNavigation.toAuth();
                  }, AppColors.pink),
                  SizedBox(height: size.w1 * 25),
                  Center(
                    child: Text("Версия $version", style: theme.textTheme.dark11w500,),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profile(){
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        AppNavigation.showAppDialog(ProfileEditDialog());
      },
      child: ValueListenableBuilder<UserModel?>(
        valueListenable: app.user,
        builder: (context, snapshot, c) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            padding: EdgeInsets.symmetric(horizontal: 24),
            height: size.w1 * 88,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1,
                  color: theme.isDark ? theme.borderColor : theme.borderColor.withOpacity(0.5))
            ),
            child: Row(
              children: [
                _avatar(),
                SizedBox(width: size.w1 * 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(app.user.value?.username??"", style: theme.textTheme.dark16w600,),
                    SizedBox(height: size.w1 * 4,),
                    Text("Редактировать профиль", style: theme.textTheme.grey11w500,),

                  ],
                )
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _avatar(){
    return app.user.value?.avatar != null
        ? ClipRRect(
      borderRadius: BorderRadius.circular(90),
      child: SizedBox(
          width: size.w1 * 40, height: size.w1 * 40,
          child: Image.network(app.user.value!.avatar!, fit: BoxFit.cover,)),
    )
      : SvgPicture.asset(app.getAssetsFolder(AppImages.profile_icon, true), width: size.w1 * 40,);
  }

  Widget getButton(String text, VoidCallback onPressed, [Color? color, String? asset])=>SizedBox(
    width: double.infinity,
    height: size.w1 * 48,
    child: GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      // style: TextButton.styleFrom(
      //     primary: Colors.transparent,
      //   padding: EdgeInsets.zero,
      // ),
      child: Row(
        children: [
          SizedBox(width: size.w1 * 13),
          if(asset != null)
            ...[
              SvgPicture.asset(asset, height: size.w1 * 20,),
              SizedBox(width: size.w1 * 15,)
            ],
          Text(text, style: theme.textTheme.s17w400.copyWith(color: color),),
        ],
      ),
    ),
  );

  get divider => Divider(height: 1,);

  Future _share()async{
    try {
      final remoteJson = RemoteConfig.instance.getString(AppStrings.share_app_welcome_json);
      final model = jsonDecode(remoteJson);
      final config = RemoteConfigModel.fromJson(model);
      final res = await FlutterShare.share(
          title: config.title??"",
          chooserTitle: Platform.isAndroid ? config.title : null,
          text: config.text,
          linkUrl: config.linkUrl,
      );
    }catch(e){}
  }
}
