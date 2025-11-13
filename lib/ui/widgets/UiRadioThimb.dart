import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voicetruth/data/constants/app_colors.dart';

import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';

class UiRadioThimb extends StatelessWidget {
  final bool checked;

  const UiRadioThimb({this.checked = false});

  @override
  build(context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: checked ? AppColors.blue.withOpacity(AppNavigation.theme.isDark ? 0.5 : 0.16) : Color(0xffCBD3DB))),
      child: checked
          ? Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blue,
                ),
              ),
            )
          : null,
    );
  }
}
