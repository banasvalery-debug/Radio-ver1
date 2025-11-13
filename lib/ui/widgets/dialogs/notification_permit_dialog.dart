import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/buttons/ui_elevated_button.dart';

class NotificationPermitDialog extends StatelessWidget {
  const NotificationPermitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0, right: 0,
          child: Padding(
            padding: EdgeInsets.only(bottom: size.w1 * 8, left: size.w1 * 7.5, right: size.w1 * 7.5),
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.w1 * 16,
                    vertical: size.w1 * 8
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: size.w1 * 12),
                    _info(),
                    SizedBox(height: size.w1 * 24),
                    _buttons(context),
                  ],),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _info() => Padding(
    padding: EdgeInsets.symmetric(horizontal: size.w1 * 30),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(90),
          child: Container(
            color: AppNavigation.theme.isDark ? AppColors.dark :  AppColors.lightBlue,
            height: size.w1 * 68,
            width: size.w1 * 68,
            child: Center(
              child: SvgPicture.asset(app.getAssetsFolder(AppImages.notification_outlined_icon, true), width: size.w1 * 28,),
            ),
          ),
        ),
        SizedBox(height: size.h1 * 12,),
        Text('Приложение запрашивает доступ к уведомлениям', style: AppNavigation.theme.textTheme.dark20w700),
        SizedBox(height: size.h1 * 16,),
        Text('Вы сможете получать уведоление о начале выбраных передач, начале прямых эфиров и новостей.',
          style: AppTextStyles.blueGrey14w400,
          textAlign: TextAlign.center,),
      ],
    ),
  );

  Widget _buttons(BuildContext context){
    return Container(
      child: Column(
        children: [
          Row(children: [
            Expanded(
              child: UiElevatedButton(
                onPressed: () {AppNavigation.pop();},
                text: "Отменить",
                backgroundColor: AppNavigation.theme.greyBackground,
                textColor: AppColors.blue,
              ),
            ),
            SizedBox(width: size.w1 * 12),
            Expanded(
              child: UiElevatedButton(
                onPressed: () {AppNavigation.pop(true);},
                text: "Продолжить",
                backgroundColor: AppColors.blue,
                textColor: Colors.white,
              ),
            )
          ]),
          SizedBox(height: size.w1 * 8)
        ],
      ),
    );
  }
}
