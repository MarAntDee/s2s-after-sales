import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData data = ThemeData(
    primaryColor: ColorLibrary.spanishViolet,
    colorScheme: _scheme,
    useMaterial3: true,
    fontFamily: "Poppins",
    appBarTheme: _appBarTheme,
  );

  static final ColorScheme _scheme = ColorScheme.light(
    primary: ColorLibrary.spanishViolet,
    onPrimary: Colors.white,
    secondary: ColorLibrary.mountainMeadow,
    onSecondary: Colors.white,
    error: Colors.red[700]!,
    onError: Colors.white,
    background: ColorLibrary.background,
    onBackground: ColorLibrary.darkText,
    surface: ColorLibrary.surface,
    onSurface: ColorLibrary.darkText,
  );

  static final AppBarTheme _appBarTheme = AppBarTheme(
    color: ColorLibrary.spanishViolet,
    foregroundColor: Colors.white,
  );
}