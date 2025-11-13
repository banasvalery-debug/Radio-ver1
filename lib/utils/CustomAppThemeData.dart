import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_theme/flutter_custom_theme.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';

class CustomAppThemeData extends CustomThemeData {
  static CustomAppThemeData of(BuildContext context) => CustomThemes.safeOf(
        context,
        mainDefault: CustomAppThemeData.light(),
        darkDefault: CustomAppThemeData.dark(),
      );
  final Color splashBackground;
  final Color grey;
  final Color textGrey;
  final Color textDark;
  final Color background;
  final Color secondaryBackground;
  final Color greyBackground;
  final Color secondaryColor;
  final Color primaryColor;
  final Color buttonColor;
  final Color borderColor;
  final Color extraBorder;
  final Color drawerBack;

  final bool isDark;

  const CustomAppThemeData.light({
    this.splashBackground: AppColors.blue,
    this.grey: AppColors.grey,
    this.textGrey: AppColors.grey4,
    this.textDark: AppColors.dark,
    this.background: AppColors.backgroundWhite,
    this.secondaryBackground: Colors.white,
    this.greyBackground: AppColors.whiteGrey,
    this.secondaryColor: AppColors.whiteBlue,
    this.primaryColor: AppColors.blue,
    this.buttonColor: AppColors.dark,
    this.borderColor: AppColors.lightGrey,
    this.extraBorder: AppColors.lightBlue,
    this.drawerBack: Colors.white,
    this.isDark: false,
  });
  const CustomAppThemeData.dark({
    this.splashBackground: AppColors.blue,
    this.grey: AppColors.grey,
    this.textGrey: AppColors.grey4,
    this.textDark: Colors.white,
    this.background: AppColors.backBlack,
    this.secondaryBackground: AppColors.backBlack,
    this.greyBackground: AppColors.greyBlack,
    this.secondaryColor: AppColors.dark,
    this.primaryColor: AppColors.blue,
    this.buttonColor: Colors.white,
    this.borderColor: AppColors.lightGrey,
    this.extraBorder: Colors.transparent,
    this.drawerBack: AppColors.dark,
    this.isDark: true,
  });

  factory CustomAppThemeData.lightTheme() => CustomAppThemeData.light();
  factory CustomAppThemeData.darkTheme() => CustomAppThemeData.dark(
    greyBackground: Colors.white.withOpacity(0.04),
    borderColor: Colors.white.withOpacity(0.04),
    grey: AppColors.grey.withOpacity(0.1)
  );

  AppTextTheme get textTheme => AppTextTheme(
      boldText: isDark ? AppTextStyles.white14w600 : AppTextStyles.black14w600,
      grey10w400: isDark
          ? AppTextStyles.white10w400
              .copyWith(color: Colors.white.withOpacity(0.32))
          : AppTextStyles.grey10w400,
      s12w600: isDark ? AppTextStyles.white12w600 : AppTextStyles.black12w600,
      s16w600: isDark ? AppTextStyles.white16w600 : AppTextStyles.black16w600,
      s17w400: isDark ? AppTextStyles.white17w400 : AppTextStyles.black17w400,
      s20w500: isDark ? AppTextStyles.white20w500 : AppTextStyles.black20w500,
      grey10w500: isDark ? AppTextStyles.grey10w500.copyWith(color: Colors.white.withOpacity(0.16)) : AppTextStyles.grey10w500,
      grey11w500: isDark ? AppTextStyles.grey11w500.copyWith(color: Colors.white.withOpacity(0.32)) : AppTextStyles.grey11w500,
      grey14w400: isDark ? AppTextStyles.grey14w400.copyWith(color: Colors.white.withOpacity(0.8)) : AppTextStyles.grey14w400,
      grey17w400: isDark ? AppTextStyles.grey17w400.copyWith(color: Colors.white.withOpacity(0.32)) : AppTextStyles.grey17w400,
      dark11w500: isDark ? AppTextStyles.white11w500 : AppTextStyles.dark11w500,
      dark16w600: isDark ? AppTextStyles.white16w600 : AppTextStyles.dark16w600,
      dark17w400: isDark ? AppTextStyles.white17w400 : AppTextStyles.dark17w400,
    dark20w700: isDark ? AppTextStyles.white20w700 : AppTextStyles.black20w700
  );

  ThemeData get themeData => ThemeData(
    appBarTheme: AppBarTheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      backwardsCompatibility: false,
      systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    ),
        brightness: isDark ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: splashBackground,
        scaffoldBackgroundColor: secondaryBackground,
        backgroundColor: background
      );
}

class AppTextTheme {
  final TextStyle boldText, s12w600, s16w600, s20w500, s17w400;
  final TextStyle grey10w400, grey10w500, grey11w500, grey17w400, grey14w400;
  final TextStyle dark11w500, dark17w400, dark16w600, dark20w700;

  AppTextTheme({
    required this.boldText,
    required this.grey10w400,
    required this.s12w600,
    required this.s16w600,
    required this.s17w400,
    required this.s20w500,
    required this.grey10w500,
    required this.grey11w500,
    required this.grey14w400,
    required this.grey17w400,
    required this.dark11w500,
    required this.dark16w600,
    required this.dark17w400,
    required this.dark20w700
  });
}
