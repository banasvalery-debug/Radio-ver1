import 'package:flutter/material.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/ui/app_navigation.dart';

class ChatInputLengthProgress extends StatelessWidget {
  final double percent;
  const ChatInputLengthProgress({Key? key, required this.percent}) :  assert(percent>=0 && percent<=1), super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = size.w1 * 12;
    return SizedBox(
      width: width, height: width,
      child: CircularProgressIndicator(
        value: percent,
        color: percent < 1 ? AppColors.blue : AppColors.blueGrey,
        backgroundColor: AppNavigation.theme.secondaryColor,
        strokeWidth: size.w1 * 1.6,
      ),
    );
  }
}
