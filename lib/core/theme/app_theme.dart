import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/_values.dart';
import '../utils/strings_service.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final c = StringsService.strings.colors;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: c.darkBg1,
      primaryColor: c.gradientMid,
      colorScheme: ColorScheme.dark(
        primary: c.gradientMid,
        secondary: c.gradientEnd,
        surface: c.darkBg2,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: c.darkTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: c.darkTextPrimary),
        titleTextStyle: TextStyle(
          color: c.darkTextPrimary,
          fontSize: AppValues.homeSectionTitleSize + 2,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
            color: c.darkTextPrimary,
            fontSize: AppValues.splashTitleSize,
            fontWeight: FontWeight.bold),
        displayMedium: TextStyle(
            color: c.darkTextPrimary,
            fontSize: AppValues.homeTitleSize,
            fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            color: c.darkTextPrimary,
            fontSize: AppValues.homeSectionTitleSize + 6,
            fontWeight: FontWeight.w600),
        titleLarge: TextStyle(
            color: c.darkTextPrimary,
            fontSize: AppValues.homeSectionTitleSize + 2,
            fontWeight: FontWeight.w600),
        titleMedium: TextStyle(
            color: c.darkTextPrimary,
            fontSize: AppValues.homeSectionTitleSize,
            fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(
            color: c.darkTextPrimary, fontSize: AppValues.homeSectionTitleSize),
        bodyMedium: TextStyle(
            color: c.darkTextSecondary, fontSize: AppValues.homeSubtitleSize),
        bodySmall: TextStyle(
            color: c.darkTextTertiary,
            fontSize: AppValues.homePlatformLabelSize),
      ),
      iconTheme: IconThemeData(
          color: c.darkTextPrimary, size: AppValues.homeBottomNavIcon),
    );
  }

  static ThemeData get lightTheme {
    final c = StringsService.strings.colors;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: c.lightBg1,
      primaryColor: c.gradientMid,
      colorScheme: ColorScheme.light(
        primary: c.gradientMid,
        secondary: c.gradientEnd,
        surface: c.lightBg2,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: c.lightTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: c.lightTextPrimary),
        titleTextStyle: TextStyle(
          color: c.lightTextPrimary,
          fontSize: AppValues.homeSectionTitleSize + 2,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
            color: c.lightTextPrimary,
            fontSize: AppValues.splashTitleSize,
            fontWeight: FontWeight.bold),
        displayMedium: TextStyle(
            color: c.lightTextPrimary,
            fontSize: AppValues.homeTitleSize,
            fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            color: c.lightTextPrimary,
            fontSize: AppValues.homeSectionTitleSize + 6,
            fontWeight: FontWeight.w600),
        titleLarge: TextStyle(
            color: c.lightTextPrimary,
            fontSize: AppValues.homeSectionTitleSize + 2,
            fontWeight: FontWeight.w600),
        titleMedium: TextStyle(
            color: c.lightTextPrimary,
            fontSize: AppValues.homeSectionTitleSize,
            fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(
            color: c.lightTextPrimary,
            fontSize: AppValues.homeSectionTitleSize),
        bodyMedium: TextStyle(
            color: c.lightTextSecondary, fontSize: AppValues.homeSubtitleSize),
        bodySmall: TextStyle(
            color: c.lightTextTertiary,
            fontSize: AppValues.homePlatformLabelSize),
      ),
      iconTheme: IconThemeData(
          color: c.lightTextPrimary, size: AppValues.homeBottomNavIcon),
    );
  }
}
