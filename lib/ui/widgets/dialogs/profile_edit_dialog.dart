import 'dart:math';

import 'package:flutter/material.dart';
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
import 'package:voicetruth/utils/logger.dart';
import 'package:voicetruth/utils/toasts.dart';

class ProfileEditDialog extends StatefulWidget {
  final TextInputType? keyboardType;
  final bool obscure;
  const ProfileEditDialog({Key? key, this.obscure: false, this.keyboardType})
      : super(key: key);

  @override
  _ProfileEditDialogState createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppNavigation.theme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
          onTap: AppNavigation.pop,
          behavior: HitTestBehavior.opaque,
          child: ValueListenableBuilder(
              valueListenable: app.user,
              builder: (BuildContext context, UserModel? value, Widget? child) {
                return Padding(
                  padding: EdgeInsets.only(bottom: size.h1 * 8),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: size.w1 * 8),
                      padding: EdgeInsets.all(size.w1 * 16),
                      constraints: BoxConstraints(
                        minHeight: 0,
                        maxHeight: size.h1 * 380
                      ),
                      decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(18)),
                      child: GestureDetector(
                        onTap: () {},
                        behavior: HitTestBehavior.opaque,
                        child: ListView(
                          physics: ClampingScrollPhysics(),
                          children: [
                            _content(),
                            SizedBox(height: size.w1 * 24),
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
                                SizedBox(
                                  width: size.w1 * 12,
                                ),
                                Expanded(
                                    child: UiElevatedButton(
                                  onPressed: () {
                                    if (text.isNotEmpty) _saveName();
                                  },
                                  text: "Сохранить",
                                  backgroundColor: text.isEmpty
                                      ? AppNavigation.theme.isDark
                                          ? AppColors.dark
                                          : AppColors.whiteBlueGrey
                                      : AppColors.blue,
                                  height: size.w1 * 44,
                                  textSize: size.w1 * 15,
                                  // borderColor: Colors.white,
                                  textColor: text.isEmpty
                                      ? AppColors.blueGrey
                                      : Colors.white,
                                  onPrimaryColor: Colors.white,
                                )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  Widget _content() => Column(
        children: [
          SizedBox(height: size.h1 * 24),
          _profileImage(),
          SizedBox(height: size.h1 * 12),
          Text('Ваш профиль', style: AppNavigation.theme.textTheme.dark20w700),
          SizedBox(height: size.h1 * 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.w1 * 10),
            child: Text(
              'Люди на радио для общения в чате используют аватар и псевдоним.',
              style: AppTextStyles.blueGrey14w400,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: size.h1 * 24),
          AuthTextField(
            controller: _nameController,
            borderColor: AppNavigation.theme.isDark
                ? AppNavigation.theme.borderColor
                : AppColors.lightBlue,
            hint: "Ваш псевдоним",
            hintStyle: AppTextStyles.blueGrey14w400,
            textStyle: AppNavigation.theme.textTheme.dark17w400
                .copyWith(fontSize: size.w1 * 14),
            // suffix: Text("Занято"),
          ),
        ],
      );

  Future<void> _saveName() async {
    context.loaderOverlay.show();
    try {
      final response = await instanceAuthProfileProvider.changeUsername(text);
      _editSuccess();
    } catch (err) {}
    context.loaderOverlay.hide();
  }

  Widget _profileImage() {
    double width = min(size.h1 * 95, size.w1 * 95);
    return SizedBox(
      width: double.infinity,
      height: width,
      child: Stack(
        children: [
          Center(
            child: CircleAvatar(
              radius: width / 2,
              backgroundColor: AppColors.blueGrey.withOpacity(0.16),
              backgroundImage: app.user.value?.avatar == null
                  ? null
                  : NetworkImage(app.user.value!.avatar!),
              child: app.user.value?.avatar == null
                  ? SvgPicture.asset(
                      app.getAssetsFolder(AppImages.person_icon, true),
                      width: size.w1 * 46)
                  : null,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(child: SizedBox()),
                Expanded(
                    child: Row(
                  children: [
                    SizedBox(width: width / 8),
                    Container(
                      width: size.w1 * 28,
                      height: size.w1 * 28,
                      decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(
                              width: size.w1 * 2, color: Colors.white)),
                      child: TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(90))),
                          onPressed: () {
                            _onPhotoPressed();
                          },
                          child: SvgPicture.asset(
                              app.getAssetsFolder(AppImages.pencil_icon, true),
                              width: size.w1 * 12)),
                    ),
                    SizedBox(width: size.w1 * 8),
                    InkWell(
                        onTap: () {
                          _onPhotoPressed();
                        },
                        child: Text(
                          "Изменить",
                          style: AppTextStyles.blue11w500,
                        ))
                  ],
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  _onPhotoPressed() async {
    final res = await ChooseMediaWidget.show(context);
    if (res != null) {
      XFile? file;
      if (res) {
        file = await app.imagePicker.pickImage(source: ImageSource.camera);
      } else {
        file = await app.imagePicker.pickImage(source: ImageSource.gallery);
      }
      if (file != null) {
        _uploadPhoto(file);
      }
    }
  }

  _uploadPhoto(XFile file) async {
    context.loaderOverlay.show();
    try {
      final response =
          await instanceAuthProfileProvider.uploadAvatar(file.path);
      if (response != null && response.statusCode < 300) {
        await app.getProfile();
      } else {
        if (response?.reasonPhrase != null) {
          showToastMessage("${response?.reasonPhrase}");
        }
      }
    } catch (er) {
      logger.e("ERROR",er);
    }
    context.loaderOverlay.hide();
  }

  void _editSuccess() {
    showToastMessage("Изменения сохранены");
    app.getProfile();
    // else AppNavigation.pop();
  }
}
