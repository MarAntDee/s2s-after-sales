import 'package:flutter/material.dart';

import '../main.dart';

class Popup {
  static BuildContext? _context() => navigatorKey.currentContext;

  static Future showError(dynamic e) => showDialog(
        context: _context()!,
        builder: (context) => AlertDialog(
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
