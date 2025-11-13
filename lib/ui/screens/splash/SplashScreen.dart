import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';


class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool opaque = true;

  SplashScreenState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this, value: 0.7);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.repeat(min: 0.8, max: 1, reverse: true);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () => setState(() => opaque = false));
    (() async {
      await app.init();
      Future.delayed(
          Duration(seconds: 2), ()async {
                /// Проверяем приложение открыто впервые или нет
                bool isFirst = app.prefs?.getBool("isFirst") ?? true;
                if(!isFirst)
                  AppNavigation.toHomeError();
                else
                  AppNavigation.toAuth();
                app.prefs?.setBool("isFirst", false);
              }
      );
    })();
    _getPermissions();
  }
  _getPermissions()async{
    await Permission.microphone.request();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      color: AppNavigation.theme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          color: AppColors.blue.withOpacity(0.06),
          child: Center(
            child: AnimatedOpacity(
              opacity: opaque ? 0 : 1,
              duration: Duration(seconds: 1),
              child: ScaleTransition(
                scale: _animation,
                child: SvgPicture.asset(
                  AppImages.logo_text,
                  width: size.w1 * 160,
                  color: AppColors.blue,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
