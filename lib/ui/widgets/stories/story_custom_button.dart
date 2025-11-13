import 'package:flutter/material.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/model/remote/stories/button_model.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/utils/hex_color.dart';

class StoryCustomButton extends StatelessWidget {
  final ButtonModel button;
  const StoryCustomButton({Key? key,required this.button}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: size.h1 * 0),
      child: Container(
        height: size.h1 * 44,
        margin: EdgeInsets.symmetric(
            horizontal: size.w1 * 24),
        decoration: BoxDecoration(
            color: HexColor(button.background_color),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            button.title,
            style: AppTextStyles.black14w600
                .copyWith(color: HexColor(button.text_color)),
          ),
        ),
      ),
    );
  }
}
