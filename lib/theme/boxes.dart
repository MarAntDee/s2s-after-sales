import 'package:flutter/material.dart';
import 'package:s2s_after_sales/main.dart';

class AppBoxes {
  final BuildContext _context = navigatorKey.currentContext!;

  BoxDecoration get main => BoxDecoration(
        color: Theme.of(_context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      );
}
