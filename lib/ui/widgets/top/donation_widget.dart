import 'dart:math';

import 'package:flutter/material.dart';
import 'package:progresso/progresso.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';
import 'package:voicetruth/utils/app_theme_notifier.dart';

class DonationWidget extends StatefulWidget {
  const DonationWidget({Key? key}) : super(key: key);

  @override
  _DonationWidgetState createState() => _DonationWidgetState();
}

class _DonationWidgetState extends State<DonationWidget> {
  late Stream<List<double>> stream;

  CustomAppThemeData get _theme => CustomAppThemeData.of(context);

  @override
  void initState() {
    super.initState();
    stream = Stream.periodic(Duration(seconds: 5), (a){
      final rand = Random();
      final i = rand.nextInt(100000), i2 = rand.nextInt(100000);
      final d = rand.nextDouble(), d2 = rand.nextDouble();
      final n1 = i+d, n2 = i2 + d2;
      return [min(n1, n2), max(n1, n2)];
    });
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<double>>(
      stream: stream,
      builder: (context, snapshot) {
        final n = snapshot.data?[0]??0;
        final n2 = snapshot.data?[1]??0;
        return Container(
          padding: EdgeInsets.only(left: size.w1 * 20, right: size.w1 * 20, top: size.w1 * 16, bottom: size.w1 * 15.5),
          margin: EdgeInsets.symmetric(horizontal: size.w1 * 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(AppThemeNotifier.appThemeNotifier.isDarkMode() ? 0.08 :0.64),
            borderRadius: BorderRadius.circular(14),
          ),
          width: size.w1 * 291,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Донаты", style: _theme.textTheme.boldText,),
              SizedBox(height: size.w1 * 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${n.toStringAsFixed(2)} \$", style: _theme.textTheme.s20w500,),
                  Text("${n2==0 ? 0 : (n/n2 * 100).toStringAsFixed(1)}% из ${n2.toStringAsFixed(2)} \$", style: AppTextStyles.black14w600.copyWith(color: _theme.buttonColor.withOpacity(0.64)),)
                ],
              ),
              SizedBox(height: size.w1 * 13.5),
              TweenAnimationBuilder<double>(tween: Tween<double>(begin: 0, end: n2 == 0 ? 0 : (n/n2)), duration: Duration(milliseconds: 250), builder: (context, t, c) {
                return Progresso(
                  progress: t,
                  progressColor: AppColors.blue,
                  backgroundColor: Colors.black.withOpacity(0.08),
                  progressStrokeCap: StrokeCap.round,
                  backgroundStrokeCap: StrokeCap.round,
                  progressStrokeWidth: size.w1 * 5,
                  backgroundStrokeWidth: size.w1 * 2,
                );
              })
            ],
          ),
        );
      }
    );
  }
}
