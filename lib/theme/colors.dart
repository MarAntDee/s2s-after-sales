import 'package:flutter/material.dart';

class ColorLibrary {

  static const int _purple = 0xFF41317D, _teal = 0xFF29B198;

  static MaterialColor purple = const MaterialColor(
    _purple,
    <int, Color>{
      50: Color(0xFFe9e9f3),
      100: Color(0xFFc9c9e3),
      200: Color(0xFFa6a6cf),
      300: Color(0xFF8583bb),
      400: Color(0xFF6d67ad),
      500: Color(0xFF584c9f),
      600: Color(0xFF524595),
      700: Color(0xFF493b89),
      800: Color(_purple),
      900: Color(0xFF342067),
    },
  ), teal = const MaterialColor(
    _teal,
    <int, Color>{
      50: Color(0xFFe1f4f1),
      100: Color(0xFFb4e3da),
      200: Color(0xFF83d2c2),
      300: Color(0xFF51c0aa),
      400: Color(_teal),
      500: Color(0xFF00a287),
      600: Color(0xFF00957a),
      700: Color(0xFF00846a),
      800: Color(0xFF00745c),
      900: Color(0xFF005740),
    },
  );
}

//{
//   "Primary": {
//     "50": "#e9e9f3",
//     "100": "#c9c9e3",
//     "200": "#a6a6cf",
//     "300": "#8583bb",
//     "400": "#6d67ad",
//     "500": "#584c9f",
//     "600": "#524595",
//     "700": "#493b89",
//     "800": "#41317d",
//     "900": "#342067"
//   },
//   "Secondary": {
//     "50": "#e1f4f1",
//     "100": "#b4e3da",
//     "200": "#83d2c2",
//     "300": "#51c0aa",
//     "400": "#29b198",
//     "500": "#00a287",
//     "600": "#00957a",
//     "700": "#00846a",
//     "800": "#00745c",
//     "900": "#005740"
//   }
// }