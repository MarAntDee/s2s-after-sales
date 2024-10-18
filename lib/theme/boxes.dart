import 'package:flutter/material.dart';
import 'package:surf2sawa/main.dart';

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

  BoxDecoration get txTile => BoxDecoration(
        color: _theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      );
}
