import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData data = ThemeData(
    primaryColor: ColorLibrary.spanishViolet,
    primaryColorLight: ColorLibrary.spanishViolet[50]!,
    primaryColorDark: ColorLibrary.spanishViolet[900]!,
    colorScheme: _scheme,
    useMaterial3: true,
    fontFamily: "Poppins",
    appBarTheme: _appBarTheme,
    dialogTheme: _dialogTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _elevatedButtonStyle,
    ),
    textButtonTheme: TextButtonThemeData(
      style: _textButtonStyle,
    ),
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

  static final ButtonStyle _elevatedButtonStyle = ElevatedButton.styleFrom(
        backgroundColor: ColorLibrary.mountainMeadow,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      _textButtonStyle = TextButton.styleFrom(
        foregroundColor: ColorLibrary.mountainMeadow,
      );

  static final DialogTheme _dialogTheme = DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static final TextSelectionThemeData _textSelectionThemeData =
      TextSelectionThemeData(
    cursorColor: ColorLibrary.mountainMeadow[900]!,
  );
}

extension AppColorScheme on ColorScheme {
  MaterialColor get primarySwatch => ColorLibrary.spanishViolet;
  Color get primaryColorLight => primarySwatch[50]!;
  Color get primaryColorDark => primarySwatch[900]!;

  MaterialColor get secondarySwatch => ColorLibrary.mountainMeadow;
  Color get secondaryColorLight => secondarySwatch[50]!;
  Color get secondaryColorDark => secondarySwatch[900]!;

  Color get highContrast => ColorLibrary.yellow;
}
