import 'package:flutter/material.dart';

class ColorLibrary {
  static const Color background = Color(0xFFF6F6F6),
      surface = Color(0xFFFFFFFF),
      darkText = Color(0xFF1B1B1B),
      yellow = Color(0xFFFFCF2D);
  static MaterialColor primary = spanishViolet, secondary = mountainMeadow;

  //CONVERGE COLOR
  static const int _spanishViolet = 0xFF41317D, _mountainMeadow = 0xFF29B198;
  static MaterialColor spanishViolet = const MaterialColor(
        _spanishViolet,
        <int, Color>{
          50: Color(0xFFe9e9f3),
          100: Color(0xFFc9c9e3),
          200: Color(0xFFa6a6cf),
          300: Color(0xFF8583bb),
          400: Color(0xFF6d67ad),
          500: Color(0xFF584c9f),
          600: Color(0xFF524595),
          700: Color(0xFF493b89),
          800: Color(_spanishViolet),
          900: Color(0xFF342067),
        },
      ),
      mountainMeadow = const MaterialColor(
        _mountainMeadow,
        <int, Color>{
          50: Color(0xFFe1f4f1),
          100: Color(0xFFb4e3da),
          200: Color(0xFF83d2c2),
          300: Color(0xFF51c0aa),
          400: Color(_mountainMeadow),
          500: Color(0xFF00a287),
          600: Color(0xFF00957a),
          700: Color(0xFF00846a),
          800: Color(0xFF00745c),
          900: Color(0xFF005740),
        },
      );

  //UCHAT COLOR
  static const int _blueBlack = 0xFF0d0a3b, _jade = 0xFF00a287;
  static MaterialColor blueBlack = const MaterialColor(
        _blueBlack,
        <int, Color>{
          50: Color(0xFFe4e5ec),
          100: Color(0xFFbbbdd2),
          200: Color(0xFF8f93b3),
          300: Color(0xFF666a95),
          400: Color(0xFF494d82),
          500: Color(0xFF2d316f),
          600: Color(0xFF282b67),
          700: Color(0xFF20235d),
          800: Color(0xFF181a51),
          900: Color(_blueBlack),
        },
      ),
      jade = const MaterialColor(
        _jade,
        <int, Color>{
          50: Color(0xFFe1f4f1),
          100: Color(0xFFb4e3da),
          200: Color(0xFF83d2c3),
          300: Color(0xFF51bfaa),
          400: Color(0xFF29b198),
          500: Color(_jade),
          600: Color(0xFF00947a),
          700: Color(0xFF00846a),
          800: Color(0xFF00745c),
          900: Color(0xFF005740),
        },
      );
}

// {
// "Primary": {
// "50": "#e4e5ec",
// "100": "#bbbdd2",
// "200": "#8f93b3",
// "300": "#666a95",
// "400": "#494d82",
// "500": "#2d316f",
// "600": "#282b67",
// "700": "#20235d",
// "800": "#181a51",
// "900": "#0d0a3b"
// },
// "Secondary": {
// "50": "#e1f4f1",
// "100": "#b4e3da",
// "200": "#83d2c3",
// "300": "#51bfaa",
// "400": "#29b198",
// "500": "#00a287",
// "600": "#00947a",
// "700": "#00846a",
// "800": "#00745c",
// "900": "#005740"
// }
// }
