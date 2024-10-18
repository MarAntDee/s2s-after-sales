import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:surf2sawa/theme/app.dart';

class Background extends StatelessWidget {
  final Widget? child;
  const Background({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/login-bg.png"),
            fit: BoxFit.cover,
            opacity: 0.25,
          ),
          gradient: LinearGradient(
            colors: <Color>[
              _theme.colorScheme.primaryColorDark,
              _theme.colorScheme.primary,
              _theme.colorScheme.secondaryColorDark,
            ],
            stops: const [0, 0.7, 1],
            begin: const Alignment(-0.35, -1),
            end: const Alignment(0.35, 1),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }
}
