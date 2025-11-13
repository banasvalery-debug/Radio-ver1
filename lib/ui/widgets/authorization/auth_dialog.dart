import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/buttons/custom_close_button.dart';
import 'package:voicetruth/ui/widgets/buttons/ui_elevated_button.dart';
import 'package:voicetruth/ui/widgets/input/auth_text_field.dart';

class AuthDialog extends StatelessWidget {
  final List<InlineSpan> richChildren, richSwitch;
  final String title, info, buttonText;
  final VoidCallback? onTap;
  const AuthDialog(
      {Key? key,
      this.richChildren: const [],
      this.richSwitch: const [],
      this.title:'',
      this.info:'', this.buttonText:'', this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => AppNavigation.pop(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(size.w1 * 8.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Material(
                    color: Colors.transparent,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(size.w1 * 18),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [CustomCloseButton()],
                            ),
                            SizedBox(
                              height: size.h1 * 6,
                            ),
                            Text(
                              title,
                              style: AppTextStyles.black17w700.copyWith(color: AppColors.blue),
                            ),
                            SizedBox(
                              height: size.h1 * 16,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.w1 * 10),
                              child: Text(
                                info,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.black14w400.copyWith(color: AppColors.grey4),
                              ),
                            ),
                            SizedBox(
                              height: size.h1 * 24,
                            ),
                            AuthTextField(
                              hint: "Введите электронную почту",
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: size.h1 * 16,
                            ),
                            AuthTextField(
                              hint: "Введите пароль",
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                            ),
                            SizedBox(
                              height: size.h1 * 16,
                            ),
                            UiElevatedButton(
                              onPressed: onTap??(){},
                              textColor: Colors.white,
                              backgroundColor: AppColors.blue,
                              onPrimaryColor: Colors.white,
                              text: buttonText,
                            ),
                            SizedBox(
                              height: size.h1 * 19,
                            ),
                            RichText(
                              text: TextSpan(children: richChildren),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: size.h1 * 25,
                            ),
                            RichText(text: TextSpan(children: richSwitch)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppSizes get size => AppNavigation.sizeScales;
}

InlineSpan getTappableSpan(String text, VoidCallback onTap, [TextStyle? style])=>TextSpan(
  text: text, style: style ?? AppTextStyles.black11w500.copyWith(decoration: TextDecoration.underline, color: AppColors.blue),
  recognizer: new TapGestureRecognizer()..onTap = onTap,
);
