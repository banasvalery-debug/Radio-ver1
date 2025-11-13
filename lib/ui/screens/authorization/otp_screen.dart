import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/data/provider/api/auth_profile_provider.dart';
import 'package:voicetruth/data/provider/firebase_auth_provider.dart';
import 'package:voicetruth/model/remote/user_model/phone_user_post_response.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/widgets/authorization/auth_dialog.dart';
import 'package:voicetruth/ui/widgets/buttons/ui_elevated_button.dart';
import 'package:voicetruth/ui/widgets/input/auth_text_field.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:voicetruth/utils/logger.dart';
import 'package:voicetruth/utils/toasts.dart';

import '../../app_navigation.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late TextEditingController _codeController;
  late FocusNode _codeNode;

  var codeMask = MaskTextInputFormatter(mask: "######", filter: { "#": RegExp(r'[0-9]') });

  bool isFull = false;
  String text = '';

  late String phone;
  int? frt;

  late Duration dur;
  late StreamSubscription durSubscription;

  @override
  void dispose() {
    durSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _codeController = TextEditingController();
    _codeNode = FocusNode();
    dur = Duration(minutes: 2);
    durSubscription = Stream.periodic(Duration(seconds: 1)).listen((event) {
      if(dur>=Duration(seconds: 1))
        dur -= Duration(seconds: 1);
      else dur = Duration();
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///Получаем аргументы
    final args = (ModalRoute.of(context)!.settings.arguments??[]) as List;
    phone = args[0];
    frt = args[1];

    final _content = Column(
      children: [
        Expanded(child: Center(child: _info())),
        _buttons(),
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: AppColors.blue.withOpacity(0.06),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(onPressed: AppNavigation.pop, icon: Icon(Icons.arrow_back_ios, color: Colors.black,),),
        ),
        body: SafeArea(
          ///Если размер экрана слишком маленький оборачиваем контент в ListView
          child: size.height < 600 ? ListView(
            physics: ClampingScrollPhysics(),
            children: [
              SizedBox(
                width: double.infinity,
                height: size.height - MediaQuery.of(context).padding.top - AppBar().preferredSize.height,
                child: _content,
              ),
            ],
          ) : _content,
        ),
      ),
    );
  }

  AppSizes get size => AppNavigation.sizeScales;


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
        Text('Введите код из SMS', style:AppTextStyles.black20w700),
        SizedBox(height: size.h1 * 16,),
        Text('Если код не пришел или вы ошиблись, отправьте запрос повторно.',
          style: AppTextStyles.blueGrey14w400,
          textAlign: TextAlign.center,),
      ],
    ),
  );

  Widget _buttons() => Padding(
    padding: EdgeInsets.symmetric(horizontal: size.w1 * 24),
    child: Column(children: [
      SizedBox(
        height: size.w1 * 56,
        child: Stack(
          children: [
            Positioned.fill(child: _numbers()),
            Opacity(
              opacity: 0,
              child: AuthTextField(
                focusNode: _codeNode,
                autofocus: true,
                textStyle: AppTextStyles.black14w400,
                controller: _codeController,
                formatters: [codeMask],
                hint: "Введите номер телефона",
                keyboardType: TextInputType.number,
                borderColor: isFull ? AppColors.lightBlueGrey : AppColors.lightBlue,
                onChanged: (v){
                  setState(() {
                    isFull = v.length>=6;
                    text = v;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: size.h1 * 20),
      UiElevatedButton(
        onPressed: () {
          if(isFull) _checkCode();
        },
        text: "Подтвердить",
        backgroundColor: isFull ? AppColors.blue : AppColors.whiteBlueGrey,
        // borderColor: Colors.white,
        textColor: isFull ? Colors.white : AppColors.blueGrey,
        onPrimaryColor: !isFull ? AppColors.blue :  Colors.white,
      ),
      SizedBox(height: size.h1 * 20),
      _richText(),
      SizedBox(height: size.h1 * 24),
    ],),
  );

  Widget _numbers(){
    return Row(
      children: [
        Expanded(child: _numberItem(text.length>0 ? text.substring(0,1) : ""),),
        SizedBox(width: size.w1 * 14),
        Expanded(child: _numberItem(text.length>1 ? text.substring(1,2) : ""),),
        SizedBox(width: size.w1 * 14),
        Expanded(child: _numberItem(text.length>2 ? text.substring(2,3) : ""),),
        SizedBox(width: size.w1 * 14),
        Expanded(child: _numberItem(text.length>3 ? text.substring(3,4) : ""),),
        SizedBox(width: size.w1 * 14),
        Expanded(child: _numberItem(text.length>4 ? text.substring(4,5) : ""),),
        SizedBox(width: size.w1 * 14),
        Expanded(child: _numberItem(text.length>5 ? text.substring(5,6) : ""),),
      ],
    );
  }
  Widget _numberItem(String text){
    return Container(
      height: size.w1 * 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: AppColors.lightBlue
        )
      ),
      child: Center(
        child: Text(text, style: AppTextStyles.black20w700,),
      ),
    );
  }

  Widget _richText()=>Column(
    children: [
      if(dur>Duration())
      Text.rich(TextSpan(text: "Только через ${_getDurText()} минуты вы сможете", style: AppTextStyles.grey11w500),),
      SizedBox(height: size.h1 * 5),
      Text.rich(TextSpan(children: [
        getTappableSpan("отправить код повторно", () {_resendCode();})
      ]), textAlign: TextAlign.center,),
    ],
  );

  String _getDurText(){
    final min = dur.inMinutes;
    final seconds =dur.inSeconds%60;
    return "$min:${seconds <10 ? "0" : ""}$seconds";
  }

  _resendCode()async{
    if(dur<=Duration()){
      _sendCode();
    }
  }
  _sendCode()async{
    logger.i("SEND SMS");
    context.loaderOverlay.show();
    await instanceFirebaseAuthProvider
        .getCodeWithPhoneNumber(
        phone,
        forceResendingToken: frt,
        verificationFailed: (e) {
          context.loaderOverlay.hide();
          logger.i("verificationFailed $e");
          showSnackBar(context, "Проблема отправки кода: ${e.message}");
        }, verificationCompleted: (pac) {
      context.loaderOverlay.hide();
      logger.i("verificationCompleted $pac");
    }, codeSent: (s, n) {
      context.loaderOverlay.hide();
      _requestFocus();
      showSnackBar(context, "Код успешно отправлен");
      setState(() {dur = Duration(minutes: 2);});
    }, codeAutoRetrievalTimeout: (s) {
      context.loaderOverlay.hide();
    });
    _requestFocus();
    logger.i("SEND SMS FINISHED");
  }
  _requestFocus()=>FocusScope.of(context).requestFocus(_codeNode);

  _checkCode()async{
    context.loaderOverlay.show();
    try {
      final firebaseUser = await instanceFirebaseAuthProvider
          .validateOtpAndLogin(_codeController.text);

      bool isProfile = true;
      if(firebaseUser!=null){
        final p = phone.replaceAll(" ", "");
        final response = await instanceAuthProfileProvider.auth(p);
        logger.i(response?.body);
        try{
          if(response!= null){
            if(response.statusCode < 300){
              final result = PhoneUserPostResponse.fromJson(json.decode(response.body));
              logger.i(result.toJson());
              if(result.status_code < 300){
                app.user.value = result.data;
                if((app.user.value?.username??"").isNotEmpty) isProfile = false;
              }
            }
          }
        }catch(err){
          logger.e(err);
        }
        final token = await firebaseUser.getIdToken();

        if(isProfile) AppNavigation.toCallToStream();
        else AppNavigation.toHomeError();
      }
      else{
        showSnackBar(context, "Неверный код");
      }
    }catch(e){}
    context.loaderOverlay.hide();
  }
}
