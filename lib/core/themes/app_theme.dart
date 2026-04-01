import 'package:flutter/material.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_text_styles.dart';


final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: colorOff,
  fontFamily: 'DM Sans',
  colorScheme: const ColorScheme.light(
    primary: colorDark,
    secondary: colorAccent,
    surface: colorOff,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: colorDark,
    elevation: 0,
    titleTextStyle: titleLarge,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: colorAccent,
    unselectedItemColor: colorG400,
    selectedLabelStyle: navLabel.copyWith(color: colorAccent),
    unselectedLabelStyle: navLabel.copyWith(color: colorG400),
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  ),
);