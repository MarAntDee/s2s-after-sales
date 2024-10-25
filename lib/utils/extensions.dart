import 'package:flutter/material.dart';

extension AppString on String {
  bool get isNumeric => (int.tryParse(this) ?? -1) >= 0;

  String get masked => replaceRange(0, (length >= 4) ? length - 4 : 0,
      "*" * ((length >= 4) ? length - 4 : 4));

  String get toLocalMobile {
    assert(int.tryParse(this) != null);
    assert(length == 12);
    assert(substring(0, 3) == "639");

    return "0${substring(2, 5)} ${substring(5, 8)} ${substring(8)}";
  }

  Characters get characters => Characters(this);
}

extension AppDateTime on DateTime {
  String get greeting {
    if (hour >= 6 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}