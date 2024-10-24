import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData data = ThemeData(
    primaryColor: ColorLibrary.primary,
    primaryColorLight: ColorLibrary.primary[50]!,
    primaryColorDark: ColorLibrary.primary[900]!,
    colorScheme: _scheme,
    useMaterial3: true,
    fontFamily: "Nunito",
    appBarTheme: _appBarTheme,
    dialogTheme: _dialogTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _elevatedButtonStyle,
    ),
    textButtonTheme: TextButtonThemeData(
      style: _textButtonStyle,
    ),
    textTheme: _textTheme,
    primaryTextTheme: _textTheme,
  );

  static final ColorScheme _scheme = ColorScheme.light(
    primary: ColorLibrary.primary,
    onPrimary: Colors.white,
    secondary: ColorLibrary.secondary,
    onSecondary: Colors.white,
    error: Colors.red[700]!,
    onError: Colors.white,
    background: ColorLibrary.background,
    onBackground: ColorLibrary.darkText,
    surface: ColorLibrary.surface,
    onSurface: ColorLibrary.darkText,
  );

  static const AppBarTheme _appBarTheme = AppBarTheme(
    elevation: 0,
    backgroundColor: ColorLibrary.background,
    foregroundColor: ColorLibrary.darkText,
    centerTitle: false,
  );

  static final ButtonStyle _elevatedButtonStyle = ElevatedButton.styleFrom(
        backgroundColor: ColorLibrary.secondary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      _textButtonStyle = TextButton.styleFrom(
        foregroundColor: ColorLibrary.secondary,
      );

  static final DialogTheme _dialogTheme = DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static final TextSelectionThemeData _textSelectionThemeData =
      TextSelectionThemeData(
    cursorColor: ColorLibrary.secondary[900]!,
  );

  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 52),
    displayMedium: TextStyle(fontSize: 40),
    displaySmall: TextStyle(fontSize: 32),
    headlineLarge: TextStyle(fontSize: 28),
    headlineMedium: TextStyle(fontSize: 24),
    headlineSmall: TextStyle(fontSize: 22),
    titleLarge: TextStyle(fontSize: 20),
    titleMedium: TextStyle(fontSize: 14),
    titleSmall: TextStyle(fontSize: 12),
    bodyLarge: TextStyle(fontSize: 14),
    bodyMedium: TextStyle(fontSize: 12),
    bodySmall: TextStyle(fontSize: 11),
    labelLarge: TextStyle(fontSize: 12),
    labelMedium: TextStyle(fontSize: 11),
    labelSmall: TextStyle(fontSize: 10),
  );
}

extension AppColorScheme on ColorScheme {
  MaterialColor get primarySwatch => ColorLibrary.primary;
  Color get primaryColorLight => primarySwatch[50]!;
  Color get primaryColorDark => primarySwatch[900]!;

  MaterialColor get secondarySwatch => ColorLibrary.secondary;
  Color get secondaryColorLight => secondarySwatch[50]!;
  Color get secondaryColorDark => secondarySwatch[900]!;

  Color get highContrast => ColorLibrary.yellow;
}
