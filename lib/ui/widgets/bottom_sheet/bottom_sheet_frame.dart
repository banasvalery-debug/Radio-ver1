import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/buttons/ui_elevated_button.dart';

class BottomSheetFrame extends StatelessWidget {
  final Widget child;
  const BottomSheetFrame({Key? key,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppNavigation.theme;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: theme.secondaryBackground.withOpacity(0.88),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.w1 * 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.h1 * 10,),
                  Container(
                    width: size.w1 * 64,
                    height: size.w1 * 3,
                    decoration: BoxDecoration(
                      color: AppColors.blueGrey,//theme.buttonColor,
                      borderRadius: BorderRadius.circular(90)
                    ),
                  ),
                  SizedBox(height: size.h1 * 25,),
                  child,
                  SizedBox(height: size.w1 * 11,),
                  Divider(height: 1, color: theme.buttonColor.withOpacity(0.26),),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: AppNavigation.pop,
                      style: TextButton.styleFrom(primary: Colors.brown),
                      child: Align(
                        alignment: Alignment.centerLeft,
                          child: Text("Вернуться назад", style: theme.textTheme.s17w400,)
                      ),
                    ),
                  ),
                  SizedBox(height: size.w1 * 20,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
