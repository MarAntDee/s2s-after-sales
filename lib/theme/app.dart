import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData data = ThemeData(
    primaryColor: ColorLibrary.primary,
    primaryColorLight: ColorLibrary.primary[50]!,
    primaryColorDark: ColorLibrary.primary[900]!,
    highlightColor: const Color(0xFFE6E6E6),
    colorScheme: _scheme,
    useMaterial3: true,
    fontFamily: "Work Sans",
    appBarTheme: _appBarTheme,
    dialogTheme: _dialogTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _elevatedButtonStyle,
    ),
    inputDecorationTheme: _inputDecorationTheme,
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
    surface: ColorLibrary.surface,
    onSurface: ColorLibrary.darkText,
  );

  static const AppBarTheme _appBarTheme = AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontFamily: "WorkSans",
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  );

  static final ButtonStyle _elevatedButtonStyle = ElevatedButton.styleFrom(
        backgroundColor: ColorLibrary.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 20),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      _textButtonStyle = TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          decoration: TextDecoration.underline,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );

  static final DialogTheme _dialogTheme = DialogTheme(
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    isDense: true,
    contentPadding: EdgeInsets.zero,
    labelStyle: const TextStyle(
      fontSize: 18,
      color: ColorLibrary.darkGray,
      fontWeight: FontWeight.w500,
    ),
    hintStyle: TextStyle(
      fontSize: 18,
      color: ColorLibrary.darkGray.withOpacity(0.6),
      fontWeight: FontWeight.w500,
    ),
    prefixStyle: const TextStyle(
      fontSize: 18,
      color: ColorLibrary.darkGray,
      fontWeight: FontWeight.w500,
    ),
  );

  static final TextSelectionThemeData _textSelectionThemeData =
      TextSelectionThemeData(
    cursorColor: ColorLibrary.primary,
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

  Color get lightGrayText => ColorLibrary.lightGray;
  Color get darkGrayText => ColorLibrary.darkGray;

  Color get highContrast => ColorLibrary.yellow;
}
