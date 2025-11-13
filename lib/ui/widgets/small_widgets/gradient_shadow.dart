import 'package:flutter/material.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';

class GradientShadow extends StatelessWidget {
  final double height;
  final bool top;
  const GradientShadow({Key? key, this.height : 26, this.top:true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: top ? [col, noCol] : [noCol, col],
        ),
      ),
    );
  }

  Color get col => theme.drawerBack;
  Color get noCol => theme.drawerBack.withOpacity(0);

  CustomAppThemeData get theme => AppNavigation.theme;
}
