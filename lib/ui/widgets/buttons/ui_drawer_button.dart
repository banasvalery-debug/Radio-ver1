import 'package:flutter/material.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/ui/app_navigation.dart';

class UiDrawerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  const UiDrawerButton({Key? key, this.text:'',required this.onPressed, this.textColor: Colors.black}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.h1 * 50,
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(text, style: AppTextStyles.black14w400.copyWith(color: textColor),),
        ),
      ),
    );
  }
}
