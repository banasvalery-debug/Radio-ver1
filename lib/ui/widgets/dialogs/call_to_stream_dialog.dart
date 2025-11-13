import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/model/remote/user_model/user_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/buttons/ui_elevated_button.dart';
import 'package:voicetruth/utils/logger.dart';
import 'package:voicetruth/utils/toasts.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CallToStreamDialog extends StatelessWidget {
  const CallToStreamDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  SizedBox(height: size.w1 * 12),
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
              child: SvgPicture.asset(app.getAssetsFolder(AppImages.call_icon, true), width: size.w1 * 19,),
            ),
          ),
        ),
        SizedBox(height: size.h1 * 12,),
        Text('Позвонить в эфир?', style: AppNavigation.theme.textTheme.dark20w700),
        SizedBox(height: size.h1 * 16,),
        Text('Выберите мессенджер, чтобы осуществлять звонки в прямой эфир.',
          style: AppTextStyles.blueGrey14w400,
          textAlign: TextAlign.center,),
      ],
    ),
  );

  Widget _buttons(BuildContext context){
    return Container(
      child: ValueListenableBuilder<UserModel?>(
          valueListenable: app.user,
          builder: (context, d, child) {
            logger.i(d?.toJson());
            return Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _callItem(
                        app.getAssetsFolder(AppImages.whatsapp, true),
                        "WhatsApp",
                            (){
                          _setButton(0);
                        },
                        app.user.value?.allowed_communications.whatsapp??false
                    ),
                    SizedBox(width: size.w1 * 18),
                    _callItem(app.getAssetsFolder(AppImages.viber, true), "Viber",
                            (){_setButton(1);},
                        app.user.value?.allowed_communications.viber??false
                    ),
                    SizedBox(width: size.w1 * 18),
                    _callItem(app.getAssetsFolder(AppImages.telegram, true), "Telegram",
                            (){_setButton(2);},
                        app.user.value?.allowed_communications.telegram??false
                    ),
                  ],
                ),
                SizedBox(height: size.w1 * 16,),
                UiElevatedButton(
                    textColor: Colors.white,
                    height: size.w1 * 52,
                    backgroundColor: AppColors.blue,
                    text: "Далее",
                    onPressed: ()async{
                      context.loaderOverlay.show();
                      final result = await app.updateCommunications();
                      await app.getInQueue(true);
                      context.loaderOverlay.hide();
                      AppNavigation.pop();
                    }
                ),
                SizedBox(height: size.w1 * 16),
                InkWell(
                  onTap: (){
                    AppNavigation.pop();
                  },
                  child: Text("Отмена, вернуться назад", style: AppTextStyles.blue11w500,),
                ),
                SizedBox(height: size.w1 * 16),
              ],
            );
          }
      ),
    );
  }

  Widget _callItem(String asset, String text, VoidCallback onPressed,[ bool checked = false]){
    return Opacity(
      opacity: checked ? 1 : 0.5,
      child: Container(
        height: size.w1 * 86,
        width: size.w1 * 70,
        decoration: BoxDecoration(
            color: AppNavigation.theme.greyBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                width: 1,
                color: AppNavigation.theme.secondaryColor
            )
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(asset, width: size.w1 * 26.67,),
              SizedBox(height: size.w1 * 6,),
              Text(text, style: AppTextStyles.blueGrey10w500,),
            ],
          ),
        ),
      ),
    );
  }

  _setButton(int i){
    if(app.user.value!=null){
      switch(i){
        case 0:
          app.user.value!.allowed_communications.whatsapp = !(app.user.value!.allowed_communications.whatsapp??false);
          break;
        case 1:
          app.user.value!.allowed_communications.viber = !(app.user.value!.allowed_communications.viber??false);
          break;
        case 2:
          app.user.value!.allowed_communications.telegram = !(app.user.value!.allowed_communications.telegram??false);
          break;
      }
      app.user.notifyListeners();
    }
  }
}
