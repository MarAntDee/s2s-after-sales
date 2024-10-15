import 'dart:ui';

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget? child;
  const Background({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: _theme.colorScheme.primary,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }
}
