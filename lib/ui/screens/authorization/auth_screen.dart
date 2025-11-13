import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/constants/app_strings.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/data/provider/firebase_auth_provider.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/authorization/auth_dialog.dart';
import 'package:voicetruth/ui/widgets/buttons/ui_elevated_button.dart';
import 'package:voicetruth/ui/widgets/input/auth_text_field.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:voicetruth/utils/logger.dart';
import 'package:voicetruth/utils/toasts.dart';

class AuthScreen extends StatefulWidget{
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late TextEditingController _phoneController;
  late FocusNode _phoneFocus;

  var phoneMask = MaskTextInputFormatter(mask: "+# ### ### ## #### ", filter: { "#": RegExp(r'[0-9]') });
  bool isFull = false;

  @override
  void initState() {
    app.checkAuthorization();
    _phoneController = TextEditingController();
    _phoneFocus = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        Expanded(child: Center(child: _info())),
        _buttons(),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: DecoratedBox(
        decoration: BoxDecoration(color: AppColors.blue.withOpacity(0.06)),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                ///Если размер экрана слишком маленький оборачиваем контент в ListView
                size.height < 600 ?
                ListView(
                  physics: ClampingScrollPhysics(),
                  children: [
                    SizedBox(
                      height: size.height - MediaQuery.of(context).padding.top,
                      child: content
                    ),
                  ]) : content,
                Positioned(
                  top: size.h1 * 18,
                  right: size.w1 * 24,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                        AppNavigation.toHomeError();
                      },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.w1 * 14,
                        vertical: size.w1 * 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Text("Пропустить", style: AppTextStyles.white12w400,),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppSizes get size => AppNavigation.sizeScales;

  Widget _logo() => Padding(
    padding: EdgeInsets.only(bottom: size.h1 * 20),
    child: SvgPicture.asset(AppImages.logo_text,height: size.w1 * 160,),
  );

  Widget _info() => Padding(
    padding: EdgeInsets.symmetric(horizontal: size.w1 * 30),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(90),
          child: Container(
            color: AppColors.lightBlue,
            height: size.w1 * 68,
            width: size.w1 * 68,
            child: Center(
              child: SvgPicture.asset(app.getAssetsFolder(AppImages.lock_icon, true), width: size.w1 * 19,),
            ),
          ),
        ),
        SizedBox(height: size.h1 * 12,),
        Text('Введите номер телефона', style:AppTextStyles.black20w700, textAlign: TextAlign.center,),
        SizedBox(height: size.h1 * 16,),
        Text('На указанный номер придет SMS с кодом подтверждения. Телефонный номер используется для авторизации профиля.',
          style: AppTextStyles.blueGrey14w400,
          textAlign: TextAlign.center,),
      ],
    ),
  );

  Widget _buttons() => Padding(
    padding: EdgeInsets.symmetric(horizontal: size.w1 * 24),
    child: Column(children: [
      AuthTextField(
        focusNode: _phoneFocus,
        autofocus: true,
        textStyle: AppTextStyles.black14w400,
        controller: _phoneController,
        hint: "Введите номер телефона",
        formatters: [phoneMask],
        keyboardType: TextInputType.phone,
        borderColor: isFull ? AppColors.lightBlueGrey : AppColors.lightBlue,
        onChanged: (v){
          setState(() {isFull = v.length>=16;});
        },
      ),
      SizedBox(height: size.h1 * 20),
      UiElevatedButton(
        onPressed: () {
          if (isFull) _sendCode();
        },
        text: "Получить код",
        backgroundColor: isFull ? AppColors.blue : AppColors.blueGrey,
        // borderColor: Colors.white,
        textColor: Colors.white,
        onPrimaryColor: Colors.white,
      ),
      SizedBox(height: size.h1 * 20),
      _richText(),
      SizedBox(height: size.h1 * 24),
    ],),
  );

  Widget _richText()=>Column(
    children: [
      Text.rich(TextSpan(text: "Нажимая “Получить код”, вы принимаете", style: AppTextStyles.grey11w500),),
      SizedBox(height: size.h1 * 5),
      Text.rich(TextSpan(children: [
        // getTappableSpan("Условия использования", () { print("TAP");}),
        TextSpan(
            // text: " и ",
            style: AppTextStyles.grey11w500),
        getTappableSpan("Политику конфиденциальности", () => launch(AppStrings.politics))
      ]), textAlign: TextAlign.center,),
    ],
  );

  _sendCode()async{
    final phone = _phoneController.text;
    context.loaderOverlay.show();
    await instanceFirebaseAuthProvider
        .getCodeWithPhoneNumber(
        phone,
        verificationFailed: (e) {
          context.loaderOverlay.hide();
          logger.i("verificationFailed $e");
          logger.i("${e.runtimeType} ${e.message} ${e.code} ${e.plugin}");
          showSnackBar(context, "Проблема отправки кода: ${e.message}");
        }, verificationCompleted: (pac) {
      context.loaderOverlay.hide();
      logger.i("verificationCompleted $pac");
    }, codeSent: (s, n) async{
      context.loaderOverlay.hide();
      showSnackBar(context, "Код успешно отправлен");
      await AppNavigation.toOtp(phone, n);
      _requestFocus();
    }, codeAutoRetrievalTimeout: (s) {
      context.loaderOverlay.hide();
    });
    _requestFocus();
    logger.i("SEND SMS FINISHED");
    await Future.delayed(Duration(seconds: 30));
    if(mounted) context.loaderOverlay.hide();
  }
  _requestFocus()=>FocusScope.of(context).requestFocus(_phoneFocus);
}