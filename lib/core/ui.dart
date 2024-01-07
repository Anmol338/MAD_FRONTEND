import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static Color accent = const Color(0xff1ab7c3);
  static Color text = const Color(0xff212121);
  static Color textLight = const Color(0xff8A8A8A);
  static Color white = const Color(0xffffffff);
  static Color myOrange = const Color(0xffF25F39);
  static Color myBlack = const Color(0xff272320);
  static Color grayBackground = const Color(0xffF8F8F8);
}

class Themes {
  static ThemeData defaultTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.text),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.text
        )
      ),
      colorScheme: ColorScheme.light(
          primary: AppColors.accent, secondary: AppColors.accent));
}

class TextStyles{
  static TextStyle heading1 = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    fontSize: 48
  );

  static TextStyle heading2 = TextStyle(
      fontWeight: FontWeight.bold,
      color: AppColors.text,
      fontSize: 32
  );

  static TextStyle heading3 = TextStyle(
      fontWeight: FontWeight.bold,
      color: AppColors.text,
      fontSize: 24
  );

  static TextStyle body1 = TextStyle(
      fontWeight: FontWeight.normal,
      color: AppColors.text,
      fontSize: 18
  );

  static TextStyle body2 = TextStyle(
      fontWeight: FontWeight.normal,
      color: AppColors.text,
      fontSize: 16
  );
}