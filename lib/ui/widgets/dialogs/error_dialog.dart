import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/buttons/ui_elevated_button.dart';

class ErrorCustomDialog extends StatelessWidget {
  final String buttonText, description;
  final VoidCallback onPressed;
  final String? asset;
  const ErrorCustomDialog({Key? key,this.buttonText : "",required this.onPressed, this.asset, this.description : ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        asset == null ? SizedBox() : ClipRRect(
          borderRadius: BorderRadius.circular(90),
          child: Container(
            color: AppColors.lightBlue,
            height: size.w1 * 68,
            width: size.w1 * 68,
            child: Center(
              child: SvgPicture.asset(asset!, width: size.w1 * 26,),
            ),
          ),
        ),
        SizedBox(height: size.w1 * 12),
        Text("Что-то пошло не так!", style: AppNavigation.theme.textTheme.dark20w700),
        SizedBox(height: size.w1 * 12),
        Text(description, style: AppNavigation.theme.textTheme.grey14w400,textAlign: TextAlign.center,),
        SizedBox(height: size.w1 * 24),
        UiElevatedButton(
            height: size.w1 * 52,
            backgroundColor: AppNavigation.theme.primaryColor,
            textColor: AppNavigation.theme.background,
            onPrimaryColor: AppNavigation.theme.background,
            text: "Обновить",
            onPressed: onPressed
        )
      ],
    );
  }
}
