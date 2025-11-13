import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/UiRadioThimb.dart';
import 'package:voicetruth/ui/widgets/buttons/ui_elevated_button.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';
import 'package:voicetruth/utils/app_theme_notifier.dart';

class ThemeChangeScreen extends StatefulWidget {
  const ThemeChangeScreen({Key? key}) : super(key: key);

  @override
  _ThemeChangeScreenState createState() => _ThemeChangeScreenState();
}

class _ThemeChangeScreenState extends State<ThemeChangeScreen> {
  CustomAppThemeData get theme => AppNavigation.theme;

  bool? isDark;

  @override
  void initState() {
    isDark = AppThemeNotifier.appThemeNotifier.isDarkModeDB();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(builder: (context, t, _)
    {
      final theme = isDark?? SchedulerBinding.instance!.window.platformBrightness == Brightness.dark
          ? CustomAppThemeData.dark() : CustomAppThemeData.light();
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: AppNavigation.pop,
          behavior: HitTestBehavior.opaque,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                decoration: BoxDecoration(
                    color: theme.background,
                    borderRadius: BorderRadius.circular(18)
                ),
                duration: Duration(milliseconds: 1000),
                margin: EdgeInsets.all(size.w1 * 8),
                padding: EdgeInsets.all(size.w1 * 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: size.h1 * 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Container(
                        color: theme.isDark
                            ? AppColors.dark
                            : AppColors.lightBlue,
                        height: size.w1 * 68,
                        width: size.w1 * 68,
                        child: Center(
                          child: SvgPicture.asset(app.getAssetsFolder(
                              AppImages.theme_outlined_icon, true),
                            width: size.w1 * 19,),
                        ),
                      ),
                    ),
                    SizedBox(height: size.h1 * 12),
                    Text("Настройки темы",
                        style: AppTextStyles.black20w700.copyWith(
                            color: theme.textDark)),
                    SizedBox(height: size.h1 * 24),
                    Column(
                      children: [
                        CupertinoActionSheetAction(
                            onPressed: () {
                              _setDark();
                              // t.switchThemeMode(null);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Как в системе",
                                  style: theme.textTheme
                                      .dark17w400,
                                ),
                                UiRadioThimb(checked: isDark == null),
                              ],
                            )),
                        CupertinoActionSheetAction(
                            onPressed: () {
                              _setDark(false);
                              // t.switchThemeMode(false);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Светлая",
                                  style: theme.textTheme
                                      .dark17w400,
                                ),
                                UiRadioThimb(checked: !(isDark ?? true)),
                              ],
                            )),
                        CupertinoActionSheetAction(
                            onPressed: () {
                              _setDark(true);
                              // t.switchThemeMode(true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Темная",
                                  style: theme.textTheme
                                      .dark17w400,
                                ),
                                UiRadioThimb(checked: (isDark ?? false)),
                              ],
                            )),
                        SizedBox(height: size.h1 * 28),
                        Row(
                          children: [
                            Expanded(
                                child: UiElevatedButton(
                                  text: "Отменить",
                                  textColor: AppColors.blue,
                                  textSize: size.w1 * 15,
                                  fontWeight: FontWeight.w600,
                                  backgroundColor: theme.greyBackground,
                                  onPrimaryColor: AppColors.blue,
                                  height: size.w1 * 44,
                                  onPressed: AppNavigation.pop,
                                )),
                            SizedBox(width: size.w1 * 12,),
                            Expanded(
                                child: UiElevatedButton(
                                  onPressed: () {
                                    AppNavigation.pop();
                                    t.switchThemeMode(isDark);
                                  },
                                  text: "Сохранить",
                                  backgroundColor: AppColors.blue,
                                  height: size.w1 * 44,
                                  textSize: size.w1 * 15,
                                  // borderColor: Colors.white,
                                  textColor: Colors.white,
                                  onPrimaryColor: Colors.white,
                                )),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _setDark([bool? dark]){
    setState(() {
      isDark = dark;
    });
  }
}
