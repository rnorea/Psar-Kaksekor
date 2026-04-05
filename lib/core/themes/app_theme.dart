import 'package:flutter/material.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_text_styles.dart';

ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: colorOff,
  fontFamily: 'DM Sans',
  colorScheme: ColorScheme.light(
    primary: colorDark,
    secondary: colorAccent,
    background: colorOff,
    surface: Colors.white,
    error: colorRed,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: colorDark,
    elevation: 0,
    titleTextStyle: titleLarge,
    iconTheme: const IconThemeData(color: Colors.white),
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
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorDark,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: colorAccent,
      side: const BorderSide(color: colorG200, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: hintText,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: const BorderSide(color: colorG200, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: const BorderSide(color: colorAccent, width: 1.5),
    ),
    filled: true,
    fillColor: Colors.white,
  ),
  dividerTheme: const DividerThemeData(color: colorG200, thickness: 1),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: colorDark,
    contentTextStyle: const TextStyle(
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w700,
      fontSize: 11.5,
      color: Colors.white,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    behavior: SnackBarBehavior.floating,
  ),
);