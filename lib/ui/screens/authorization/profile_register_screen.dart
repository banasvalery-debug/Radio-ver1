import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/data/provider/api/auth_profile_provider.dart';
import 'package:voicetruth/model/remote/user_model/user_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/bottom/choose_media_widget.dart';
import 'package:voicetruth/ui/widgets/buttons/ui_elevated_button.dart';
import 'package:voicetruth/ui/widgets/input/auth_text_field.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:voicetruth/utils/app_theme_notifier.dart';
import 'package:voicetruth/utils/logger.dart';
import 'package:voicetruth/utils/toasts.dart';

class ProfileRegisterScreen extends StatefulWidget {
  final bool isEdit;
  const ProfileRegisterScreen({Key? key, this.isEdit:false}) : super(key: key);

  @override
  _ProfileRegisterScreenState createState() => _ProfileRegisterScreenState();
}

class _ProfileRegisterScreenState extends State<ProfileRegisterScreen> {

  late TextEditingController _nameController;

  String text = "";



  @override
  void initState() {
    _nameController = TextEditingController(text: app.user.value?.username);
    text = _nameController.text;
    _nameController.addListener(() {
      text = _nameController.text;
      setState(() {});
    });
    super.initState();
    Future.microtask(() => AppThemeNotifier.appThemeNotifier.notifyListeners());
  }

  @override
  Widget build(BuildContext context) {

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: size.w1 * 76,
          padding: EdgeInsets.symmetric(horizontal: size.w1 * 10),
          child: Row(
            children: [
              IconButton(
                onPressed: () => AppNavigation.pop(),
                icon: Icon(Icons.arrow_back_ios, color: AppNavigation.theme.textDark),
                iconSize: size.w1 * 20,
              ),
            ],
          ),
        ),
        _info(),
        _content(),
        isEdit ? SizedBox() :
        InkWell(
          onTap: (){
            AppNavigation.toHomeError();
          },
          /// Нельзя пропустить регистрацию
          child: true ? SizedBox() : Padding(
            padding: EdgeInsets.only(bottom: size.w1 * 17),
            child: Text("Пропустить, и выбрать потом", style: AppTextStyles.blue11w500,),
          ),
        )
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
        // backgroundColor: AppColors.blue.withOpacity(0.06),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ValueListenableBuilder(
              valueListenable: app.user,
              builder: (BuildContext context, UserModel? value, Widget? child) {
                ///Если размер экрана слишком маленький оборачиваем контент в ListView
                return size.height < 600  ? ListView(
                  physics: ClampingScrollPhysics(),
                  children: [
                    SizedBox(
                      height: size.height - MediaQuery.of(context).padding.top,
                      child: content,
                    ),
                  ],
                ) : content;
              },
            ),
          ),
        ),
      ),
    );
  }

  bool get isEdit => widget.isEdit;

  Widget _info()=>Padding(
    padding: EdgeInsets.symmetric(horizontal: size.w1 * 30, vertical: size.h1 * 24 * 0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _profileImage(),
        SizedBox(height: size.h1 * 20),
        Text(isEdit ? "Редактировать профиль" : 'Ваш профиль', style: AppNavigation.theme.textTheme.dark20w700),
        SizedBox(height: size.h1 * 16,),
        Text('Люди на радио для общения в чате используют аватар и псевдоним.',
          style: AppTextStyles.blueGrey14w400,
          textAlign: TextAlign.center,),
      ],
    ),
  );

  Widget _content()=>Padding(
    padding: EdgeInsets.symmetric(horizontal: size.w1 * 24),
    child: Column(
      children: [
        AuthTextField(
          controller: _nameController,
          borderColor: AppNavigation.theme.isDark ? AppNavigation.theme.borderColor : AppColors.lightBlue,
          hint: "Псевдоним",
          hintStyle: AppTextStyles.blueGrey14w400,
          textStyle: AppNavigation.theme.textTheme.dark17w400.copyWith(fontSize: size.w1 * 14),
          // suffix: Text("Занято"),
        ),
        SizedBox(height: size.h1 * 20),
        UiElevatedButton(
          onPressed: () {
            if(text.isNotEmpty) _saveName();
          },
          text: "Сохранить",
          backgroundColor: text.isEmpty
              ? AppNavigation.theme.isDark ? AppColors.dark : AppColors.whiteBlueGrey
              : AppColors.blue,
          // borderColor: Colors.white,
          textColor: text.isEmpty ?  AppColors.blueGrey : Colors.white,
          onPrimaryColor: Colors.white,
        ),
      ],
    ),
  );

  Future<void> _saveName()async{
    context.loaderOverlay.show();
    try{
      final response = await instanceAuthProfileProvider.changeUsername(text);
      _editSuccess();
    }catch(err){}
    context.loaderOverlay.hide();
  }

  void _editSuccess(){
    if(!isEdit) AppNavigation.toHomeError();
    else{
      showToastMessage("Изменения сохранены");
    }
    app.getProfile();
    // else AppNavigation.pop();
  }

  Widget _profileImage(){
    double width = min(size.h1 * 95, size.w1 * 95);
    return SizedBox(
      height: width,
      child: Stack(
        children: [
          Center(
            child: CircleAvatar(
              radius: width/2,
              backgroundColor: AppColors.blueGrey.withOpacity(0.16),
              backgroundImage: app.user.value?.avatar == null ? null : NetworkImage(app.user.value!.avatar!),
              child:
              app.user.value?.avatar == null ?
              SvgPicture.asset(app.getAssetsFolder(AppImages.person_icon, true), width: size.w1 * 46) :
              null,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(child:SizedBox()),
                Expanded(child:Row(
                  children: [
                    SizedBox(width: width / 8),
                    Container(
                      width: size.w1 * 32,
                      height: size.w1 * 32,
                      decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(width: size.w1 * 2, color: Colors.white)
                      ),
                      child: TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90))),
                          onPressed: (){
                            _onPhotoPressed();
                          },
                          child: SvgPicture.asset(app.getAssetsFolder(AppImages.pencil_icon, true), width: size.w1 * 12)
                      ),
                    ),
                    SizedBox(width: size.w1 * 8),
                    InkWell(
                        onTap: (){
                          _onPhotoPressed();
                        },
                        child: Text("Изменить", style: AppTextStyles.blue11w500,))
                  ],
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
  _onPhotoPressed()async{
    final res = await ChooseMediaWidget.show(context);
    if(res!=null){
      XFile? file;
      if(res){
        file = await app.imagePicker.pickImage(source: ImageSource.camera);
      }
      else{
        file = await app.imagePicker.pickImage(source: ImageSource.gallery);
      }
      if(file != null){
        _uploadPhoto(file);
      }
    }
  }
  _uploadPhoto(XFile file) async{
    context.loaderOverlay.show();
    try{
      final response = await instanceAuthProfileProvider.uploadAvatar(file.path);
      if(response != null && response.statusCode<300){
        await app.getProfile();
      }
      else{
        if(response?.reasonPhrase!=null){
          showToastMessage("${response?.reasonPhrase}");
        }
      }
    }
    catch(er){
      logger.e(er);
    }
    context.loaderOverlay.hide();
  }

}
