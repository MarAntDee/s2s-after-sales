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
}
