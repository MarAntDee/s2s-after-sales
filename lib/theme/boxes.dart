import 'package:flutter/material.dart';
import 'package:s2s_after_sales/main.dart';

class AppBoxes {
  final BuildContext _context = navigatorKey.currentContext!;

  ThemeData get _theme => Theme.of(_context);

  BoxDecoration get main => BoxDecoration(
        color: _theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      );

  BoxDecoration get receipt => BoxDecoration(
        color: _theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      );
}
